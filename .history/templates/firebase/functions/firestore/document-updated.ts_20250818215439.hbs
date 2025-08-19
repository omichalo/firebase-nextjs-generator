import * as functions from 'firebase-functions';
import { db } from '../admin';

export const onDocumentUpdated = functions.firestore
  .document('{collection}/{docId}')
  .onUpdate(async (change, context) => {
    try {
      const beforeData = change.before.data();
      const afterData = change.after.data();
      const collection = context.params.collection;
      const docId = context.params.docId;
      
      console.log(`Document mis à jour: ${collection}/${docId}`);
      
      // Log de l'événement
      await db.collection('audit_logs').add({
        action: 'update',
        collection,
        documentId: docId,
        beforeData: beforeData,
        afterData: afterData,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        userId: context.auth?.uid || 'system',
      });
      
      console.log(`Audit log créé pour: ${collection}/${docId}`);
    } catch (error) {
      console.error(`Erreur lors de la création du log d'audit: ${error}`);
      throw error;
    }
  }); 