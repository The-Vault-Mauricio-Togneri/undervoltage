import {CallableRequest} from 'firebase-functions/v2/https';
import {Match} from '../models/match';
import {UserRecord} from 'firebase-admin/auth';

export const onPlayCard = async (request: CallableRequest, user: UserRecord) => {
  const matchId = request.data.matchId;
  const match = await Match.load(matchId);
  await match.playCard(user.uid, request.data.cardId);

  return {};
};
