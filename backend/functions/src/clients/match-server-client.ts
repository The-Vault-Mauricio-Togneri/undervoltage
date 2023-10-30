import axios, {HttpStatusCode} from 'axios'
import {Room} from '../models/room'
import {MATCH_SERVER_URL} from '..'

export const createMatchServerRoom = async (room: Room): Promise<boolean> => {
  const xAxios = axios.create()
  const response = await xAxios.request({
    baseURL: MATCH_SERVER_URL.value(),
    url: '/rooms',
    method: 'POST',
    headers: {
      ['X-API-Key']: 'API_KEY', // TODO(momo): externalize
      ['Content-Type']: 'application/json',
    },
    data: {
      roomId: room.id,
      createdAt: room.createdAt.toISOString(),
      numberOfPlayers: room.numberOfPlayers,
      matchType: room.matchType,
      players: room.players,
    },
  })

  return (response.status === HttpStatusCode.Created)
}
