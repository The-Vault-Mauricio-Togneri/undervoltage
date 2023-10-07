import {Card} from './card';
import {Hand, Hands} from './hand';
import {Players} from './player';

export class Round {
  constructor(
    public discardPile: Card[] = [],
    public playersHand: Hands = new Hands(),
  ) {}

  static new(players: Players): Round {
    const cards = Card.all().sort(() => Math.random() - 0.5);
    const firstCard = cards.pop();

    const hands: Record<string, Hand> = {};

    for (const player of players.list) {
      hands[player.id] = new Hand(
          [],
          [],
          0,
      );
    }

    while (cards.length >= players.length) {
      for (const player of players.list) {
        const hand = hands[player.id];

        if (hand.revealedPile.length < 3) {
          hand.revealedPile.push(cards.pop()!);
        } else {
          hand.hiddenPile.push(cards.pop()!);
        }
      }
    }

    return new Round(
        [firstCard!],
        new Hands(hands),
    );
  }

  static parse(data: any): Round {
    if (data) {
      return new Round(
          Card.parseList(data['discardPile']),
          Hands.parse(data['playersHand']),
      );
    } else {
      return new Round();
    }
  }

  public get lastCard() {
    return this.discardPile[this.discardPile.length - 1];
  }

  public json() {
    return {
      discardPile: this.discardPile.map((c) => c.json()),
      playersHand: this.playersHand.json(),
    };
  }
}
