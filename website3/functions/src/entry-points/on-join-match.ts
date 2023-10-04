import {CallableRequest} from 'firebase-functions/v2/https';
import {Match} from '../models/match';
import {UserRecord} from 'firebase-admin/auth';

export const onJoinMatch = async (request: CallableRequest, user: UserRecord) => {
  const matchId = request.data.matchId;
  const match = await Match.load(matchId);
  await match.join(user);

  return {};
};
