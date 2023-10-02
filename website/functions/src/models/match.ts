import {UserRecord} from 'firebase-admin/auth';
import {MatchStatus} from '../types/match-status';
import {getDatabase} from 'firebase-admin/database';
import {Player, Players} from './player';
import {Round} from './round';

export class Match {
  constructor(
    public id: string,
    public numberOfPlayers: number,
    public maxPoints: number,
    public createdAt: Date,
    public creator: string,
    public status: MatchStatus,
    public players: Players,
    public roundCount: number,
    public round: Round,
  ) {}

  public get playersJoined(): number {
    return this.players.length;
  }

  static new(params: {
    creator: UserRecord,
    numberOfPlayers: number,
    maxPoints: number,
  }): Match {
    const players = new Players();
    players.add(Player.fromUser(params.creator));

    return new Match(
        '',
        params.numberOfPlayers,
        params.maxPoints,
        new Date(),
        params.creator.uid,
        'waitingForPlayers',
        players,
        0,
        new Round(),
    );
  }

  static async load(matchId: string) {
    const snapshot = await getDatabase().ref(`matches/${matchId}`).get();

    if (snapshot.exists()) {
      return Match.parse(snapshot.toJSON());
    } else {
      throw new Error(`Match with ID ${matchId} does not exist`);
    }
  }

  static parse(data: any): Match {
    return new Match(
        data['id'],
        data['numberOfPlayers'],
        data['maxPoints'],
        new Date(data['createdAt']),
        data['creator'],
        data['status'],
        Players.parse(data['players']),
        data['roundCount'],
        new Round(), // TODO
    );
  }

  public async create() {
    this.id = getDatabase().ref('matches').push().key ?? '';
    await this.update();

    return this.id;
  }

  public async join(user: UserRecord) {
    if (this.players.has(user.uid)) {
      return;
    }

    if (this.playersJoined < this.numberOfPlayers) {
      this.players.add(Player.fromUser(user));

      if (this.playersJoined === this.numberOfPlayers) {
        this.status = 'playing';

        for (const player of this.players.list) {
          player.setStatus('playing');
        }

        this.roundCount++;
        this.round = Round.new(this.players);
      }

      await this.update();
    } else {
      throw new Error('Match is full');
    }
  }

  private async update() {
    const matchesRef = getDatabase().ref(`matches/${this.id}`);
    await matchesRef.update(this.json());
  }

  public json() {
    return {
      id: this.id,
      numberOfPlayers: this.numberOfPlayers,
      maxPoints: this.maxPoints,
      createdAt: this.createdAt,
      creator: this.creator,
      status: this.status,
      players: this.players.json(),
      roundCount: this.roundCount,
      round: this.round.json(),
    };
  }
}
