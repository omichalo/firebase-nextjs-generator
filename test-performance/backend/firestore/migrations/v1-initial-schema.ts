// Migration Firestore v1
// initial-schema
// Date: 2025-08-19T10:09:01.789Z

import { db } from '@/lib/firebase';
import { doc, setDoc, deleteDoc, collection, getDocs } from 'firebase/firestore';

export async function up() {
  try {
    console.log(`🚀 Exécution de la migration v1: initial-schema`);
    
    // Code de migration vers l'avant
    // Migration initiale
    
    console.log(`✅ Migration v1 exécutée avec succès`);
  } catch (error) {
    console.error(`❌ Erreur lors de la migration v1:`, error);
    throw error;
  }
}

export async function down() {
  try {
    console.log(`🔄 Annulation de la migration v1: initial-schema`);
    
    // Code de migration vers l'arrière
    // Rollback initial
    
    console.log(`✅ Migration v1 annulée avec succès`);
  } catch (error) {
    console.error(`❌ Erreur lors de l'annulation de la migration v1:`, error);
    throw error;
  }
} 