import {Card} from './card';
import {Hand, Hands} from './hand';
import {Players} from './player';

export class Round {
  constructor(
    private discardPile: Card[] = [],
    private playersHand: Hands = new Hands(),
  ) {}

  static new(players: Players): Round {
    console.log(players);

    return new Round(
        [
          new Card('red', 1, 2),
        ],
        new Hands({
          'xxx': new Hand([
            new Card('yellow', 3, 4),
          ], [
            new Card('blue', 5, 6),
          ]),
        }),
    );
  }

  static parse(data: any): Round {
    return new Round(
        data['discardPile'],
        data['playersHand'],
    );
  }

  public json() {
    return {
      discardPile: this.discardPile.map((c) => c.json()),
      playersHand: this.playersHand.json(),
    };
  }
}
