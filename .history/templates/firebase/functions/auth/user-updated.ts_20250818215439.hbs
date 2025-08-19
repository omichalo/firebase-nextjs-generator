import * as functions from 'firebase-functions';
import { db } from '../admin';

export const onUserUpdated = functions.auth.user().onUpdate(async (change) => {
  try {
    const user = change.after;
    const previousUser = change.before;
    
    console.log(`Utilisateur mis à jour: ${user.uid}`);
    
    // Mettre à jour le document utilisateur dans Firestore
    await db.collection('users').doc(user.uid).update({
      email: user.email,
      displayName: user.displayName || null,
      photoURL: user.photoURL || null,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      lastLogin: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    console.log(`Document utilisateur mis à jour pour: ${user.uid}`);
  } catch (error) {
    console.error(`Erreur lors de la mise à jour du document utilisateur: ${error}`);
    throw error;
  }
}); 