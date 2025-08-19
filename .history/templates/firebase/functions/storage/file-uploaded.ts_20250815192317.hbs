import * as functions from 'firebase-functions';
import { db, storage } from '../admin';

export const onFileUploaded = functions.storage
  .object()
  .onFinalize(async (object) => {
    try {
      const filePath = object.name;
      const bucket = object.bucket;
      
      console.log(`Fichier uploadé: ${filePath}`);
      
      // Log de l'événement
      await db.collection('file_logs').add({
        action: 'upload',
        filePath: filePath,
        bucket: bucket,
        size: object.size,
        contentType: object.contentType,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        userId: object.metadata?.userId || 'unknown',
      });
      
      console.log(`Log de fichier créé pour: ${filePath}`);
    } catch (error) {
      console.error(`Erreur lors de la création du log de fichier: ${error}`);
      throw error;
    }
  }); 