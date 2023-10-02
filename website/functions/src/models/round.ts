import {Card} from './card';
import {Hand, Hands} from './hand';
import {Players} from './player';

export class Round {
  constructor(
    private discardPile: Card[] = [],
    private playersHand: Hands = new Hands(),
  ) {}

  static randomCard(): Card {
    const colorChoice = this.random(1, 3);
    const color = (colorChoice === 1) ? 'red' : (
      (colorChoice === 2) ? 'yellow' : 'blue'
    );
    const valueChoice = this.random(1, 10);
    const diffChoice = this.random(1, 3);

    return new Card(color, valueChoice, diffChoice);
  }

  static random(min: number, max: number): number {
    return Math.floor(Math.random() * max + min);
  }

  static new(players: Players): Round {
    let cards = [];

    for (let i = 0; i < 73; i++) {
      cards.push(this.randomCard());
    }

    cards = cards.sort(() => Math.random() - 0.5);
    const firstCard = cards.pop();

    const hands: Record<string, Hand> = {};

    for (const player of players.list) {
      hands[player.id] = new Hand(
          [],
          [],
      );
    }

    while (cards.length >= players.length) {
      for (const player of players.list) {
        const hand = hands[player.id];

        if (hand.revealedPile.length < 4) {
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