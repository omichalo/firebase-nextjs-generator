import { auth, db } from '../admin';

export interface SecurityRule {
  allow: boolean;
  reason?: string;
}

export class SecurityManager {
  /**
   * Vérifie si l'utilisateur est authentifié
   */
  static async isAuthenticated(token: string): Promise<SecurityRule> {
    try {
      const decodedToken = await auth.verifyIdToken(token);
      return {
        allow: true,
        reason: 'Utilisateur authentifié',
      };
    } catch (error) {
      return {
        allow: false,
        reason: 'Token invalide ou expiré',
      };
    }
  }

  /**
   * Vérifie si l'utilisateur a un rôle spécifique
   */
  static async hasRole(token: string, requiredRole: string): Promise<SecurityRule> {
    try {
      const decodedToken = await auth.verifyIdToken(token);
      const userDoc = await db.collection('users').doc(decodedToken.uid).get();
      
      if (!userDoc.exists) {
        return {
          allow: false,
          reason: 'Utilisateur non trouvé dans la base de données',
        };
      }
      
      const userData = userDoc.data();
      const userRole = userData?.role || 'user';
      
      if (userRole === requiredRole || userRole === 'admin') {
        return {
          allow: true,
          reason: `Utilisateur avec le rôle ${userRole}`,
        };
      }
      
      return {
        allow: false,
        reason: `Rôle requis: ${requiredRole}, rôle actuel: ${userRole}`,
      };
    } catch (error) {
      return {
        allow: false,
        reason: 'Erreur lors de la vérification du rôle',
      };
    }
  }

  /**
   * Vérifie si l'utilisateur est propriétaire de la ressource
   */
  static async isOwner(token: string, collection: string, documentId: string): Promise<SecurityRule> {
    try {
      const decodedToken = await auth.verifyIdToken(token);
      const doc = await db.collection(collection).doc(documentId).get();
      
      if (!doc.exists) {
        return {
          allow: false,
          reason: 'Document non trouvé',
        };
      }
      
      const docData = doc.data();
      const ownerId = docData?.userId || docData?.ownerId || docData?.createdBy;
      
      if (ownerId === decodedToken.uid) {
        return {
          allow: true,
          reason: 'Utilisateur propriétaire de la ressource',
        };
      }
      
      return {
        allow: false,
        reason: 'Utilisateur non propriétaire de la ressource',
      };
    } catch (error) {
      return {
        allow: false,
        reason: 'Erreur lors de la vérification de la propriété',
      };
    }
  }

  /**
   * Vérifie les permissions d'accès combinées
   */
  static async checkAccess(
    token: string,
    options: {
      requireAuth?: boolean;
      requiredRole?: string;
      requireOwnership?: {
        collection: string;
        documentId: string;
      };
    } = {}
  ): Promise<SecurityRule> {
    const { requireAuth = true, requiredRole, requireOwnership } = options;
    
    // Vérification de l'authentification
    if (requireAuth) {
      const authCheck = await this.isAuthenticated(token);
      if (!authCheck.allow) {
        return authCheck;
      }
    }
    
    // Vérification du rôle
    if (requiredRole) {
      const roleCheck = await this.hasRole(token, requiredRole);
      if (!roleCheck.allow) {
        return roleCheck;
      }
    }
    
    // Vérification de la propriété
    if (requireOwnership) {
      const ownershipCheck = await this.isOwner(
        token,
        requireOwnership.collection,
        requireOwnership.documentId
      );
      if (!ownershipCheck.allow) {
        return ownershipCheck;
      }
    }
    
    return {
      allow: true,
      reason: 'Toutes les vérifications de sécurité sont passées',
    };
  }

  /**
   * Valide les données d'entrée pour prévenir les injections
   */
  static validateInput(data: any): SecurityRule {
    const dangerousPatterns = [
      /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,
      /javascript:/gi,
      /on\w+\s*=/gi,
      /data:text\/html/gi,
    ];
    
    const dataString = JSON.stringify(data);
    
    for (const pattern of dangerousPatterns) {
      if (pattern.test(dataString)) {
        return {
          allow: false,
          reason: 'Données d\'entrée potentiellement dangereuses détectées',
        };
      }
    }
    
    return {
      allow: true,
      reason: 'Données d\'entrée validées',
    };
  }
} 