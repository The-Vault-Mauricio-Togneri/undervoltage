import {FirebaseDocument} from '../database/firebase-document'

export interface IMatch {
  id: string
  playerIds: string[]
  scores: Record<string, number>
  createdAt: Date
  numberOfPlayers: number
}

export class Match implements IMatch {
  readonly id: string
  readonly playerIds: string[]
  readonly scores: Record<string, number>
  readonly createdAt: Date
  readonly numberOfPlayers: number

  constructor(data: IMatch) {
    this.id = data.id
    this.playerIds = data.playerIds
    this.scores = data.scores
    this.createdAt = data.createdAt
    this.numberOfPlayers = data.numberOfPlayers
  }

  public static parse(document: FirebaseDocument): Match {
    return new Match(document.data())
  }
}
