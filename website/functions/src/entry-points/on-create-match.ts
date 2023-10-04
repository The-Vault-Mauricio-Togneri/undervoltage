import {CallableRequest} from 'firebase-functions/v2/https';
import {Match} from '../models/match';
import {UserRecord} from 'firebase-admin/auth';

export const onCreateMatch = async (request: CallableRequest, user: UserRecord) => {
  const match = Match.new({
    creator: user,
    numberOfPlayers: Number(request.data.numberOfPlayers),
    maxPoints: Number(request.data.maxPoints),
  });

  console.log('test');

  const matchId = await match.create();

  return {
    matchId: matchId,
  };
};
