import {createRoomDocument} from '../../../collections/rooms/create-room-document'
import {getAvailableRoomDocument} from '../../../collections/rooms/get-available-room-document'
import {updateRoomDocument} from '../../../collections/rooms/update-room-document'
import {Database} from '../../../database/database'
import {Room} from '../../../models/room'
import {registerCallable} from '../../index'
import {RoomStatus} from '../../../types/room-status'
import {createMatchServerRoom} from '../../../clients/match-server-client'
import {CustomInternalError} from '../../../utils/custom-internal-error'

interface StartMatchmakingCallableParams {
  playerId: string
  playerName: string
  matchType: string
  numberOfPlayers: number
}

export const startMatchmakingCallable = registerCallable(async (params: StartMatchmakingCallableParams) => {
  return Database.runTransaction(async (database) => {
    const room = await getAvailableRoomDocument({
      database: database,
      playerId: params.playerId,
      matchType: params.matchType,
      numberOfPlayers: params.numberOfPlayers,
    })

    if (room) {
      return joinExistingRoom({
        database: database,
        room: room,
        playerId: params.playerId,
        playerName: params.playerName,
      })
    } else {
      return createNewRoom({
        database: database,
        playerId: params.playerId,
        playerName: params.playerName,
        matchType: params.matchType,
        numberOfPlayers: params.numberOfPlayers,
      })
    }
  })
})

const joinExistingRoom = async (params: {
  database: Database,
  room: Room,
  playerId: string,
  playerName: string,
}) => {
  const newRoom = params.room.join({
    playerId: params.playerId,
    playerName: params.playerName,
  })

  if (newRoom.status === RoomStatus.closed) {
    const created = await createMatchServerRoom(newRoom)

    if (!created) {
      throw new CustomInternalError({
        message: 'Cannot create remote room',
        data: {
          room: JSON.stringify(params.room),
          playerId: params.playerId,
          playerName: params.playerName,
        },
      })
    }
  }

  await updateRoomDocument({
    database: params.database,
    room: newRoom,
  })

  return newRoom
}

const createNewRoom = async (params: {
  database: Database,
  playerId: string,
  playerName: string,
  matchType: string,
  numberOfPlayers: number,
}) => {
  const newRoom = Room.create({
    playerId: params.playerId,
    playerName: params.playerName,
    matchType: params.matchType,
    numberOfPlayers: params.numberOfPlayers,
  })

  const result = await createRoomDocument({
    database: params.database,
    room: newRoom,
  })

  return result
}
