import * as admin from 'firebase-admin';
import {CallableRequest, HttpsError, onCall} from 'firebase-functions/v2/https';
import {onCreateMatch} from './entry-points/on-create-match';
import {onValueUpdated} from 'firebase-functions/v2/database';
import {onMatchUpdated} from './entry-points/on-match-updated';
import {onJoinMatch} from './entry-points/on-join-match';
import {UserRecord} from 'firebase-admin/auth';
import {onPlayCard} from './entry-points/on-play-card';

admin.initializeApp();

const isEmulator = Boolean(process.env.FUNCTIONS_EMULATOR);

type CallableHandler = (request: CallableRequest, user: UserRecord) => Promise<unknown>

const handleCallable = (handler: CallableHandler) => {
  return onCall(async (request: CallableRequest) => {
    try {
      const user = await admin.auth().getUser(request.auth?.uid ?? '');
      const result = await handler(request, user);

      return result;
    } catch (e) {
      if (e instanceof Error) {
        throw new HttpsError('internal', e.message);
      } else {
        throw new HttpsError('internal', 'Error');
      }
    }
  });
};

export const createMatch = handleCallable(onCreateMatch);

export const joinMatch = handleCallable(onJoinMatch);

export const playCard = handleCallable(onPlayCard);

export const onMatchUpdatedTrigger = onValueUpdated({
  ref: '/matches/{matchId}',
  region: isEmulator ? 'us-central1' : 'europe-west1',
}, (event) => {
  return onMatchUpdated(event.data.after, event.params);
});
