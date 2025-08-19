import * as functions from 'firebase-functions';
import { db } from '../admin';

export const weeklyBackup = functions.pubsub
  .schedule('0 3 * * 0') // Tous les dimanches à 3h du matin
  .timeZone('Europe/Paris')
  .onRun(async (context) => {
    try {
      console.log('Début de la sauvegarde hebdomadaire...');
      
      const backupDate = new Date();
      const backupId = `backup-${backupDate.getTime()}`;
      
      // Créer un document de sauvegarde
      await db.collection('backups').doc(backupId).set({
        id: backupId,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        type: 'weekly',
        status: 'in_progress',
      });
      
      // Récupérer toutes les collections importantes
      const collections = ['users', 'audit_logs', 'file_logs'];
      const backupData: any = {};
      
      for (const collectionName of collections) {
        const snapshot = await db.collection(collectionName).get();
        backupData[collectionName] = snapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
      }
      
      // Sauvegarder les données
      await db.collection('backups').doc(backupId).update({
        data: backupData,
        status: 'completed',
        completedAt: admin.firestore.FieldValue.serverTimestamp(),
        documentCount: Object.values(backupData).reduce((acc: number, curr: any[]) => acc + curr.length, 0),
      });
      
      console.log(`Sauvegarde hebdomadaire terminée: ${backupId}`);
      console.log(`Nombre de documents sauvegardés: ${Object.values(backupData).reduce((acc: number, curr: any[]) => acc + curr.length, 0)}`);
    } catch (error) {
      console.error('Erreur lors de la sauvegarde hebdomadaire:', error);
      
      // Marquer la sauvegarde comme échouée
      if (backupId) {
        await db.collection('backups').doc(backupId).update({
          status: 'failed',
          error: error.message,
          failedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
      
      throw error;
    }
  }); 