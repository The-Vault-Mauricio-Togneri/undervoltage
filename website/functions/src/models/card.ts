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

  static all() {
    const blue = [
      ...Array(3).map((_) => new Card('blue', 1, 1)), // 1
      ...Array(3).map((_) => new Card('blue', 2, 1)), // 2
      ...Array(3).map((_) => new Card('blue', 3, 1)), // 3
      ...Array(3).map((_) => new Card('blue', 4, 1)), // 4
      ...Array(2).map((_) => new Card('blue', 5, 1)), // 5
      ...Array(2).map((_) => new Card('blue', 6, 1)), // 6
      ...Array(2).map((_) => new Card('blue', 7, 1)), // 7
      ...Array(2).map((_) => new Card('blue', 8, 1)), // 8
      ...Array(2).map((_) => new Card('blue', 9, 1)), // 9
      ...Array(2).map((_) => new Card('blue', 10, 1)), // 10
    ];

    const yellow = [
      ...Array(2).map((_) => new Card('blue', 1, 2)), // 1
      ...Array(2).map((_) => new Card('blue', 2, 2)), // 2
      ...Array(2).map((_) => new Card('blue', 3, 2)), // 3
      ...Array(2).map((_) => new Card('blue', 4, 2)), // 4
      ...Array(3).map((_) => new Card('blue', 5, 2)), // 5
      ...Array(3).map((_) => new Card('blue', 6, 2)), // 6
      ...Array(3).map((_) => new Card('blue', 7, 2)), // 7
      ...Array(3).map((_) => new Card('blue', 8, 2)), // 8
      ...Array(2).map((_) => new Card('blue', 9, 2)), // 9
      ...Array(2).map((_) => new Card('blue', 10, 2)), // 10
    ];

    const red = [
      ...Array(3).map((_) => new Card('blue', 1, 3)), // 1
      ...Array(3).map((_) => new Card('blue', 2, 3)), // 2
      ...Array(3).map((_) => new Card('blue', 3, 3)), // 3
      ...Array(2).map((_) => new Card('blue', 4, 3)), // 4
      ...Array(2).map((_) => new Card('blue', 5, 3)), // 5
      ...Array(2).map((_) => new Card('blue', 6, 3)), // 6
      ...Array(2).map((_) => new Card('blue', 7, 3)), // 7
      ...Array(2).map((_) => new Card('blue', 8, 3)), // 8
      ...Array(3).map((_) => new Card('blue', 9, 3)), // 9
      ...Array(3).map((_) => new Card('blue', 10, 3)), // 10
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
