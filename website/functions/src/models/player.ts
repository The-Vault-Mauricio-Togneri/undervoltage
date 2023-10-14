import {UserRecord} from 'firebase-admin/auth';
import {PlayerStatus} from '../types/player-status';
import {Hand} from './hand';

export class Players {
  constructor(
    private data: Record<string, Player> = {}
  ) {
  }

  public get length() {
    return Object.keys(this.data).length;
  }

  public get list() {
    return Object.values(this.data);
  }

  public has(playerId: string) {
    return Object.keys(this.data).includes(playerId);
  }

  public of(playerId: string) {
    return this.data[playerId];
  }

  public add(player: Player) {
    this.data[player.id] = player;
  }

  public json() {
    const result: any = {};

    for (const [key, value] of Object.entries(this.data)) {
      result[key] = value.json();
    }

    return result;
  }

  public static parse(data: any) {
    const result = new Players();

    if (data) {
      for (const playerId of Object.keys(data)) {
        result.add(Player.parse(data[playerId]));
      }
    }

    return result;
  }
}

export class Player {
  constructor(
    public id: string,
    public name: string,
    public points: number,
    public status: PlayerStatus,
  ) {}

  static fromUser(user: UserRecord): Player {
    return new Player(
        user.uid,
        user.displayName ?? 'Anonymous',
        0,
        'ready',
    );
  }

  static parse(data: any): Player {
    return new Player(
        data['id'],
        data['name'],
        data['points'],
        data['status'],
    );
  }

  public setStatus(newStatus: PlayerStatus) {
    this.status = newStatus;
  }

  public updatePoints(hand: Hand) {
    const hiddenPoints = hand.hiddenPile.length;
    let revealedPoints = 0;

    for (const card of hand.revealedPile) {
      revealedPoints += card.value;
    }

    this.points += (hiddenPoints + revealedPoints + hand.faults);
  }

  public json() {
    return {
      id: this.id,
      name: this.name,
      points: this.points,
      status: this.status,
    };
  }
}
