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
    const playersMap = data['players'];

    for (const playerId of Object.keys(playersMap)) {
      result.add(playerId, Hand.parse(playersMap[playerId]));
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
        data['hiddenPile'], // TODO
        data['discardPile'], // TODO
        data['number'] as number,
    );
  }

  public json() {
    return {
      hiddenPile: this.hiddenPile.map((c) => c.json()),
      revealedPile: this.revealedPile.map((c) => c.json()),
    };
  }
}
