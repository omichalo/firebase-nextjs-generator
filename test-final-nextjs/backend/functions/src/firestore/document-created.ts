import * as functions from 'firebase-functions';
import { db } from '../admin';

export const onDocumentCreated = functions.firestore
  .document('{collection}/{docId}')
  .onCreate(async (snap, context) => {
    try {
      const data = snap.data();
      const collection = context.params.collection;
      const docId = context.params.docId;
      
      console.log(`Document créé: ${collection}/${docId}`);
      
      // Log de l'événement
      await db.collection('audit_logs').add({
        action: 'create',
        collection,
        documentId: docId,
        data: data,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        userId: context.auth?.uid || 'system',
      });
      
      console.log(`Audit log créé pour: ${collection}/${docId}`);
    } catch (error) {
      console.error(`Erreur lors de la création du log d'audit: ${error}`);
      throw error;
    }
  }); 