import {UserRecord} from 'firebase-admin/auth';
import {MatchStatus} from '../types/match-status';
import {getDatabase} from 'firebase-admin/database';
import {Player} from './player';

export class Match {
  private id: string;
  private status: MatchStatus;

  constructor(
      id: string,
    readonly numberOfPlayers: number,
    readonly maxPoints: number,
    readonly createdAt: Date,
    readonly creator: string,
    status: MatchStatus,
    readonly players: Record<string, Player>,
  ) {
    this.id = id;
    this.status = status;
  }

  public get playersJoined(): number {
    return Object.keys(this.players).length;
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
          [params.creator.uid]: Player.fromUser(params.creator),
        },
    );
  }

  static async load(matchId: string) {
    const snapshot = await getDatabase().ref(`matches/${matchId}`).get();

    return Match.parse(snapshot.toJSON());
  }

  static parse(data: any): Match {
    const players: Record<string, Player> = {};
    const playersMap = data['players'];

    for (const playerId of Object.keys(playersMap)) {
      players[playerId] = Player.parse(playersMap[playerId]);
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

  public async create() {
    this.id = getDatabase().ref('matches').push().key ?? '';

    const matchesRef = getDatabase().ref(`matches/${this.id}`);
    await matchesRef.update(this.json());

    return {
      id: this.id,
    };
  }

  public async join(user: UserRecord) {
    if (this.playersJoined < this.numberOfPlayers) {
      this.players[user.uid ?? ''] = Player.fromUser(user);

      if (this.playersJoined === this.numberOfPlayers) {
        this.status = 'started';
      }

      const matchesRef = getDatabase().ref(`matches/${this.id}`);
      await matchesRef.update(this.json());
    } else {
      throw new Error('Match is full');
    }
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
}
