import * as functions from 'firebase-functions';
import { db } from '../admin';

export const onFileDeleted = functions.storage
  .object()
  .onDelete(async (object) => {
    try {
      const filePath = object.name;
      const bucket = object.bucket;
      
      console.log(`Fichier supprimé: ${filePath}`);
      
      // Log de l'événement
      await db.collection('file_logs').add({
        action: 'delete',
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