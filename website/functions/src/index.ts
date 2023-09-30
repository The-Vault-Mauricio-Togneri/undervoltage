//import * as functions from 'firebase-functions'
//import * as express from 'express'
//import * as cors from 'cors'
import * as admin from 'firebase-admin'
import { getDatabase } from 'firebase-admin/database'
import { onCall } from 'firebase-functions/v2/https'

//const app = express()
//app.use(cors({ origin: true }))
admin.initializeApp()
const db = getDatabase()

exports.createMatch = onCall(async (request) => {
    const matches = db.ref('matches')
    const matchRef = await matches.push({
        numberOfPlayers: 3,
        createdAt: new Date(),
        text: request.data.text,
        uid: request.auth?.uid,
    });

    return {
        id: matchRef.key,
    }
})

/*app.post('/matching', async (request, response) => {
    var matchId = ''
    var playerId = ''
    var playerIndex = 0
    var hasError = false
    const playerName = request.body.name
    const isPrivate = request.body.isPrivate === 'true'

    const ref = admin.database().ref('matches')

    if (isPrivate) {
        const sharedMatchId = request.body.sharedMatchId

        if (sharedMatchId) {
            const matchRef = admin.database().ref(`matches/${sharedMatchId}`)
            const snapshot = await matchRef.once('value')
            const match = snapshot.val()

            if ((match.players.length == 1) && (!match.started)) {
                matchId = sharedMatchId
                playerIndex = 1

                const playersRef = snapshot.child('players')
                await playersRef.ref.update({
                    1: {
                        id: playerId,
                        name: playerName,
                    },
                })

                await snapshot.ref.update({
                    startedAt: admin.database.ServerValue.TIMESTAMP,
                    started: true
                })
            } else {
                hasError = true
            }
        }
    }
    else {
        const snapshot = await ref.orderByChild('started').equalTo(false).once('value')
        snapshot.forEach(function (data) {
            const match = data.val()

            if (matchId === '') {
                if (match.players == undefined) {
                    data.ref.remove()
                } else if (match.players.length == 1) {
                    matchId = data.key!
                    playerIndex = 1

                    const playersRef = data.child('players')
                    playersRef.ref.update({
                        1: {
                            id: playerId,
                            name: playerName,
                        },
                    })

                    data.ref.update({
                        startedAt: admin.database.ServerValue.TIMESTAMP,
                        started: true
                    })
                }
            }
        })
    }

    if (!hasError) {
        if (matchId === '') {
            const newMatchRef = ref.push()

            matchId = newMatchRef.key!

            await newMatchRef.set({
                createdAt: admin.database.ServerValue.TIMESTAMP,
                started: false,
                isPrivate: isPrivate,
                players: {
                    0: {
                        id: playerId,
                        name: playerName,
                    },
                },
            })
        }

        const object = {
            matchId: matchId,
            isPrivate: isPrivate,
            playerId: playerId,
            playerIndex: playerIndex,
            playerName: playerName,
        }

        response.status(200).send(object)
    } else {
        response.status(409).send()
    }
})

exports.api = functions.https.onRequest(app)*/