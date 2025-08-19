import * as functions from 'firebase-functions';
import { db } from '../admin';

export const onUserDeleted = functions.auth.user().onDelete(async (user) => {
  try {
    console.log(`Utilisateur supprimé: ${user.uid}`);
    
    // Supprimer le document utilisateur de Firestore
    await db.collection('users').doc(user.uid).delete();
    
    // Supprimer toutes les données associées à l'utilisateur
    const userDataRef = db.collection('users').doc(user.uid);
    const collections = await userDataRef.listCollections();
    
    for (const collection of collections) {
      const docs = await collection.get();
      const batch = db.batch();
      
      docs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      await batch.commit();
    }
    
    console.log(`Données utilisateur supprimées pour: ${user.uid}`);
  } catch (error) {
    console.error(`Erreur lors de la suppression des données utilisateur: ${error}`);
    throw error;
  }
}); 