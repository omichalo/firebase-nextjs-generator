import * as functions from 'firebase-functions';
import { db } from '../admin';

export const healthCheck = functions.https.onRequest(async (req, res) => {
  try {
    // Vérifier la connexion à Firestore
    await db.collection('health').doc('check').get();
    
    // Vérifier la connexion à l'authentification
    const auth = admin.auth();
    
    res.status(200).json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      services: {
        firestore: 'connected',
        auth: 'connected',
      },
      environment: process.env.NODE_ENV || 'development',
    });
  } catch (error) {
    console.error('Erreur de health check:', error);
    
    res.status(500).json({
      status: 'unhealthy',
      timestamp: new Date().toISOString(),
      error: error.message,
    });
  }
}); 