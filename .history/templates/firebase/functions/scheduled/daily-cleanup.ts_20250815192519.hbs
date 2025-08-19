import * as functions from 'firebase-functions';
import { db } from '../admin';

export const dailyCleanup = functions.pubsub
  .schedule('0 2 * * *') // Tous les jours à 2h du matin
  .timeZone('Europe/Paris')
  .onRun(async (context) => {
    try {
      console.log('Début du nettoyage quotidien...');
      
      // Supprimer les logs d'audit de plus de 30 jours
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      
      const auditLogsSnapshot = await db.collection('audit_logs')
        .where('timestamp', '<', thirtyDaysAgo)
        .get();
      
      const batch = db.batch();
      auditLogsSnapshot.docs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      await batch.commit();
      console.log(`${auditLogsSnapshot.docs.length} logs d'audit supprimés`);
      
      // Supprimer les logs de fichiers de plus de 90 jours
      const ninetyDaysAgo = new Date();
      ninetyDaysAgo.setDate(ninetyDaysAgo.getDate() - 90);
      
      const fileLogsSnapshot = await db.collection('file_logs')
        .where('timestamp', '<', ninetyDaysAgo)
        .get();
      
      const fileBatch = db.batch();
      fileLogsSnapshot.docs.forEach(doc => {
        fileBatch.delete(doc.ref);
      });
      
      await fileBatch.commit();
      console.log(`${fileLogsSnapshot.docs.length} logs de fichiers supprimés`);
      
      console.log('Nettoyage quotidien terminé avec succès');
    } catch (error) {
      console.error('Erreur lors du nettoyage quotidien:', error);
      throw error;
    }
  }); 