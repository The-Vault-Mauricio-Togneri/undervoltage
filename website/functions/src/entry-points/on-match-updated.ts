import {DataSnapshot} from 'firebase-functions/v2/database';
import {Match} from '../models/match';

export const onMatchUpdated = async (data: DataSnapshot, params: Record<string, string>) => {
  console.log(params);

  const match = Match.parse(data);
  console.log(JSON.stringify(match));
};
