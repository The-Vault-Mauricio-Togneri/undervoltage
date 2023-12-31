export * from './entry-points'
import {firestore} from 'firebase-admin'
import {initializeApp} from 'firebase-admin/app'
import {defineString} from 'firebase-functions/params'
import {onRequest} from 'firebase-functions/v2/https'
import {setGlobalOptions} from 'firebase-functions/v2/options'
import {createMatchDocument} from './collections/matches/create-match-document'
import {Database} from './database/database'

export const isEmulator = Boolean(process.env.FUNCTIONS_EMULATOR)
export const X_API_KEY_HEADER = 'x-api-key'

export const MATCH_SERVER_URL = defineString('MATCH_SERVER_URL')
export const API_KEY = defineString('API_KEY')

initializeApp()
firestore().settings({ignoreUndefinedProperties: true})

setGlobalOptions({
  region: 'europe-west6',
  timeoutSeconds: 60,
})

export const matchFinished = onRequest(async (request, response) => {
  const apiKey = request.headers[X_API_KEY_HEADER]

  if (apiKey === API_KEY.value()) {
    const data = JSON.parse(request.query.data as string)

    await Database.runTransaction(async (database) => {
      await createMatchDocument({
        database: database,
        matchId: data.matchId,
        playerIds: data.playerIds,
        scores: data.scores,
      })
    })

    response.status(204).send()
  } else {
    response.status(403).send()
  }
})
