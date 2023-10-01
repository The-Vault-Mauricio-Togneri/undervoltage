import * as admin from 'firebase-admin';
import {CallableRequest} from 'firebase-functions/v2/https';
import {Match} from '../models/match';

export const createMatch = async (request: CallableRequest) => {
  const user = await admin.auth().getUser(request.auth?.uid ?? '');

  const match = Match.new({
    creator: user,
    numberOfPlayers: Number(request.data.numberOfPlayers),
    maxPoints: Number(request.data.maxPoints),
  });

  const matchId = await match.create();

  return {
    matchId: matchId,
  };
};
