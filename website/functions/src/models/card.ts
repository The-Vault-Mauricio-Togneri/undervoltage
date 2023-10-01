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

  public json() {
    return {
      color: this.color,
      value: this.value,
      diff: this.diff,
    };
  }
}
