import {Card} from './card';

export class Hands {
  constructor(
    private data: Record<string, Hand> = {}
  ) {
  }

  public get length() {
    return Object.keys(this.data).length;
  }

  public get list() {
    return Object.values(this.data);
  }

  public add(playerId: string, hand: Hand) {
    this.data[playerId] = hand;
  }

  public json() {
    const result: any = {};

    for (const [key, value] of Object.entries(this.data)) {
      result[key] = value.json();
    }

    return result;
  }

  public static parse(data: any) {
    const result = new Hands();

    for (const playerId of Object.keys(data)) {
      result.add(playerId, Hand.parse(data[playerId]));
    }

    return result;
  }
}

export class Hand {
  constructor(
    public hiddenPile: Card[],
    public revealedPile: Card[],
    public faults: number,
  ) {}

  static parse(data: any): Hand {
    return new Hand(
        data['hiddenPile'].map((c: any) => Card.parse(c)),
        data['revealedPile'].map((c: any) => Card.parse(c)),
        data['faults'],
    );
  }

  public json() {
    return {
      hiddenPile: this.hiddenPile.map((c) => c.json()),
      revealedPile: this.revealedPile.map((c) => c.json()),
      faults: this.faults,
    };
  }
}
