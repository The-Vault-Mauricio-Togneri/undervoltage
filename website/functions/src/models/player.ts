import {UserRecord} from 'firebase-admin/auth';

export class Player {
  constructor(
    private id: string,
    private name: string,
    private points: number,
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
