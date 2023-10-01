import {initializeApp, auth} from 'firebase-admin';
import {getDatabase} from 'firebase-admin/database';
import {onCall} from 'firebase-functions/v2/https';

initializeApp();
const db = getDatabase();

exports.createMatch = onCall(async (request) => {
  const userId = request.auth?.uid;

  if (userId) {
    const user = await auth().getUser(userId);
    const matchesRef = db.ref('matches');
    const matchRef = await matchesRef.push({
      numberOfPlayers: Number(request.data.numberOfPlayers),
      maxPoints: Number(request.data.maxPoints),
      createdAt: new Date(),
      creator: userId,
      players: {
        [userId]: {
          name: user.displayName ?? 'Anonymous',
        },
      },
    });

    return {
      id: matchRef.key,
    };
  } else {
    throw new Error('User not authenticated');
  }
});
