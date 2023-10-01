export class Player {
  constructor(
    readonly id: string,
    readonly name: string,
    readonly points: number,
  ) {}

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
