import * as admin from 'firebase-admin';
import {CallableRequest, onCall} from 'firebase-functions/v2/https';
import {onCreateMatch} from './entry-points/on-create-match';
import {onValueUpdated} from 'firebase-functions/v2/database';
import {onMatchUpdated} from './entry-points/on-match-updated';
import {onJoinMatch} from './entry-points/on-join-match';

admin.initializeApp();

const isEmulator = Boolean(process.env.FUNCTIONS_EMULATOR);

exports.createMatch = onCall(async (request: CallableRequest) => {
  const user = await admin.auth().getUser(request.auth?.uid ?? '');
  const result = await onCreateMatch(request, user);

  return result;
});

exports.joinMatch = onCall(async (request: CallableRequest) => {
  const user = await admin.auth().getUser(request.auth?.uid ?? '');
  const result = await onJoinMatch(request, user);

  return result;
});

export const onMatchUpdatedTrigger = onValueUpdated({
  ref: '/matches/{matchId}',
  region: isEmulator ? 'us-central1' : 'europe-west1',
}, (event) => {
  return onMatchUpdated(event.data.after, event.params);
});
