import {COLLECTIONS, Database, WriteOptionMerge} from '../../database/database'
import {Match} from '../../models/match'

export const createMatchDocument = async (params: {
  database: Database,
  matchId: string,
  playerIds: string[],
  scores: Record<string, number>,
}) => {
  const docRef = params.database
      .collection(COLLECTIONS.MATCHES)
      .doc(params.matchId)

  const match = new Match({
    id: params.matchId,
    playerIds: params.playerIds,
    scores: params.scores,
    createdAt: new Date(),
    numberOfPlayers: params.playerIds.length,
  })

  await params.database.setDocument(docRef, match, WriteOptionMerge)
}
