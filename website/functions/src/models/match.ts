import {UserRecord} from 'firebase-admin/auth';
import {MatchStatus} from '../types/match-status';
import {getDatabase} from 'firebase-admin/database';
import {Player} from './player';

export class Match {
  constructor(
    readonly id: string,
    readonly numberOfPlayers: number,
    readonly maxPoints: number,
    readonly createdAt: Date,
    readonly creator: string,
    readonly status: MatchStatus,
    readonly players: Record<string, Player>,
  ) {}

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
              params.creator.displayName ?? 'Anonymous',
              0,
          ),
        },
    );
  }

  public json() {
    const players: any = {};

    for (const [key, value] of Object.entries(this.players)) {
      players[key] = value.json();
    }

    return {
      numberOfPlayers: this.numberOfPlayers,
      maxPoints: this.maxPoints,
      createdAt: this.createdAt,
      creator: this.creator,
      status: this.status,
      players: players,
    };
  }

  public async create() {
    const matchesRef = getDatabase().ref('matches');
    const matchRef = await matchesRef.push(this.json());

    return {
      id: matchRef.key,
    };
  }
}
