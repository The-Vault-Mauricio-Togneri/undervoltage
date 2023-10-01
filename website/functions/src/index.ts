import * as admin from 'firebase-admin';
import {onCall} from 'firebase-functions/v2/https';
import {createMatch} from './entry-points/create-match';
import {onValueUpdated} from 'firebase-functions/v2/database';
import {onMatchUpdated} from './entry-points/on-match-updated';

admin.initializeApp();

exports.createMatch = onCall(createMatch);

const isEmulator = Boolean(process.env.FUNCTIONS_EMULATOR);

export const onMatchUpdatedTrigger = onValueUpdated({
  ref: '/matches/{matchId}',
  region: isEmulator ? 'us-central1' : 'europe-west1',
}, (event) => {
  return onMatchUpdated(event.data.after, event.params);
});
