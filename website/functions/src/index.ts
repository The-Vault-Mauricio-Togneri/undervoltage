import * as admin from 'firebase-admin';
import {onCall} from 'firebase-functions/v2/https';
import {createMatch} from './create-match';

admin.initializeApp();

exports.createMatch = onCall(createMatch);
