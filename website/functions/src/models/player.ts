export class Player {
  constructor(
    readonly name: string,
    readonly points: number,
  ) {}

  public json() {
    return {
      name: this.name,
      points: this.points,
    };
  }
}
