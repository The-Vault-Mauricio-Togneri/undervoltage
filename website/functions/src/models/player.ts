import {UserRecord} from 'firebase-admin/auth';

export class Player {
  constructor(
    readonly id: string,
    readonly name: string,
    readonly points: number,
  ) {}

  static fromUser(user: UserRecord): Player {
    return new Player(
        user.uid,
        user.displayName ?? 'Anonymous',
        0,
    );
  }

  static parse(data: any): Player {
    return new Player(
        data['id'],
        data['name'],
        data['points'],
    );
  }

  public json() {
    return {
      id: this.id,
      name: this.name,
      points: this.points,
    };
  }
}
