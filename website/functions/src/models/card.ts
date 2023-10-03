import {CardColor} from '../types/card-color';

export class Card {
  constructor(
    private color: CardColor,
    private value: number,
    private diff: number,
  ) {}

  static parse(data: any): Card {
    return new Card(
        data['color'],
        data['value'],
        data['diff'],
    );
  }

  static generate(amount: number, card: Card) {
    const result = [];

    for (let i = 0; i < amount; i++) {
      result.push(card);
    }

    return result;
  }

  static all() {
    const blue = [
      ...this.generate(3, new Card('blue', 1, 1)), // 1
      ...this.generate(3, new Card('blue', 2, 1)), // 2
      ...this.generate(3, new Card('blue', 3, 1)), // 3
      ...this.generate(3, new Card('blue', 4, 1)), // 4
      ...this.generate(2, new Card('blue', 5, 1)), // 5
      ...this.generate(2, new Card('blue', 6, 1)), // 6
      ...this.generate(2, new Card('blue', 7, 1)), // 7
      ...this.generate(2, new Card('blue', 8, 1)), // 8
      ...this.generate(2, new Card('blue', 9, 1)), // 9
      ...this.generate(2, new Card('blue', 10, 1)), // 10
    ];

    const yellow = [
      ...this.generate(2, new Card('yellow', 1, 2)), // 1
      ...this.generate(2, new Card('yellow', 2, 2)), // 2
      ...this.generate(2, new Card('yellow', 3, 2)), // 3
      ...this.generate(2, new Card('yellow', 4, 2)), // 4
      ...this.generate(3, new Card('yellow', 5, 2)), // 5
      ...this.generate(3, new Card('yellow', 6, 2)), // 6
      ...this.generate(3, new Card('yellow', 7, 2)), // 7
      ...this.generate(3, new Card('yellow', 8, 2)), // 8
      ...this.generate(2, new Card('yellow', 9, 2)), // 9
      ...this.generate(2, new Card('yellow', 10, 2)), // 10
    ];

    const red = [
      ...this.generate(3, new Card('red', 1, 3)), // 1
      ...this.generate(3, new Card('red', 2, 3)), // 2
      ...this.generate(3, new Card('red', 3, 3)), // 3
      ...this.generate(2, new Card('red', 4, 3)), // 4
      ...this.generate(2, new Card('red', 5, 3)), // 5
      ...this.generate(2, new Card('red', 6, 3)), // 6
      ...this.generate(2, new Card('red', 7, 3)), // 7
      ...this.generate(2, new Card('red', 8, 3)), // 8
      ...this.generate(3, new Card('red', 9, 3)), // 9
      ...this.generate(3, new Card('red', 10, 3)), // 10
    ];

    return [
      ...blue,
      ...yellow,
      ...red,
    ];
  }

  public json() {
    return {
      color: this.color,
      value: this.value,
      diff: this.diff,
    };
  }
}
