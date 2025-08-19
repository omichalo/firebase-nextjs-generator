import * as functions from 'firebase-functions';
import { db, auth } from '../admin';

export const api = functions.https.onRequest(async (req, res) => {
  try {
    // Vérifier l'authentification
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Token d\'authentification requis' });
    }
    
    const token = authHeader.split('Bearer ')[1];
    const decodedToken = await auth.verifyIdToken(token);
    
    // Autoriser l'accès
    req.user = decodedToken;
    
    // Router vers les endpoints appropriés
    const { method, path } = req;
    
    switch (path) {
      case '/users':
        if (method === 'GET') {
          // Récupérer les utilisateurs
          const usersSnapshot = await db.collection('users').get();
          const users = usersSnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
          }));
          
          res.json({ users });
        } else if (method === 'POST') {
          // Créer un utilisateur
          const userData = req.body;
          const userRef = await db.collection('users').add({
            ...userData,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });
          
          res.json({ id: userRef.id, ...userData });
        }
        break;
        
      default:
        res.status(404).json({ error: 'Endpoint non trouvé' });
    }
  } catch (error) {
    console.error('Erreur API:', error);
    res.status(500).json({ error: 'Erreur interne du serveur' });
  }
}); 