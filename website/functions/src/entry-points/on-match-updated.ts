import {DataSnapshot} from 'firebase-functions/v2/database';
import {Match} from '../models/match';

export const onMatchUpdated = async (data: DataSnapshot, _: Record<string, string>) => {
  const match = Match.parse(data.toJSON());

  if (match.status === 'playing') {
    if (match.isBlocked) {
      console.log(JSON.stringify(match));
    }
  }
};

