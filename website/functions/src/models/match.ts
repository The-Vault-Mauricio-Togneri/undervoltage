import {UserRecord} from 'firebase-admin/auth';
import {MatchStatus} from '../types/match-status';
import {getDatabase} from 'firebase-admin/database';
import {Player} from './player';

export class Match {
  private id: string;

  constructor(
      id: string,
    readonly numberOfPlayers: number,
    readonly maxPoints: number,
    readonly createdAt: Date,
    readonly creator: string,
    readonly status: MatchStatus,
    readonly players: Record<string, Player>,
  ) {
    this.id = id;
  }

  static new(params: {
    creator: UserRecord,
    numberOfPlayers: number,
    maxPoints: number,
  }): Match {
    return new Match(
        '',
        params.numberOfPlayers,
        params.maxPoints,
        new Date(),
        params.creator.uid,
        'waitingForPlayers',
        {
          [params.creator.uid]: new Player(
              params.creator.uid,
              params.creator.displayName ?? 'Anonymous',
              0,
          ),
        },
    );
  }

  static parse(data: any): Match {
    const players: Record<string, Player> = {};

    for (const playerData of data['players']) {
      const player = Player.parse(playerData);
      players[player.id] = player;
    }

    return new Match(
        data['id'],
        data['numberOfPlayers'],
        data['maxPoints'],
        data['createdAt'],
        data['creator'],
        data['status'],
        players,
    );
  }

  public json() {
    const players: any = {};

    for (const [key, value] of Object.entries(this.players)) {
      players[key] = value.json();
    }

    return {
      id: this.id,
      numberOfPlayers: this.numberOfPlayers,
      maxPoints: this.maxPoints,
      createdAt: this.createdAt,
      creator: this.creator,
      status: this.status,
      players: players,
    };
  }

  public async create() {
    this.id = getDatabase().ref('matches').push().key ?? '';

    const matchesRef = getDatabase().ref(`matches/${this.id}`);
    await matchesRef.update(this.json());

    return {
      id: this.id,
    };
  }
}
