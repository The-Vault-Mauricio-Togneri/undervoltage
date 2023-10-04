import * as admin from 'firebase-admin';
import {CallableRequest, onCall} from 'firebase-functions/v2/https';
import {onCreateMatch} from './entry-points/on-create-match';
import {onValueUpdated} from 'firebase-functions/v2/database';
import {onMatchUpdated} from './entry-points/on-match-updated';
import {onJoinMatch} from './entry-points/on-join-match';
import {UserRecord} from 'firebase-admin/auth';

admin.initializeApp();

const isEmulator = Boolean(process.env.FUNCTIONS_EMULATOR);

type CallableHandler = (request: CallableRequest, user: UserRecord) => Promise<unknown>

const handleCallable = (handler: CallableHandler) => {
  return onCall(async (request: CallableRequest) => {
    const user = await admin.auth().getUser(request.auth?.uid ?? '');
    const result = await handler(request, user);

    return result;
  });
};

export const createMatch = handleCallable(onCreateMatch);

export const joinMatch = handleCallable(onJoinMatch);

export const onMatchUpdatedTrigger = onValueUpdated({
  ref: '/matches/{matchId}',
  region: isEmulator ? 'us-central1' : 'europe-west1',
}, (event) => {
  return onMatchUpdated(event.data.after, event.params);
});
