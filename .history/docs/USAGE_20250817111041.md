# 🎯 Guide d'utilisation complet

> **Maîtrisez le Générateur Firebase + Next.js 2025 de A à Z**

## 📋 Prérequis

> **💡 Avant de commencer :** Assurez-vous d'avoir suivi le [Guide d'installation](INSTALLATION.md) pour installer et configurer le générateur.

- ✅ **Générateur installé** : `firebase-nextjs-generator --version`
- ✅ **Firebase CLI connecté** : `firebase login`
- ✅ **Git configuré** : `git --version`

## 🚀 Premiers pas

### 1. Vérification de l'installation

```bash
# Vérifier que le générateur est installé
firebase-nextjs-generator --version

# Afficher l'aide
firebase-nextjs-generator --help
```

### 2. Première génération

```bash
# Génération interactive (recommandée pour débuter)
firebase-nextjs-generator create

# Ou avec des options de base
firebase-nextjs-generator create --name my-first-app
```

## 📝 Processus de génération détaillé

### Étape 1 : Configuration du projet

Le générateur vous demandera les informations suivantes :

```bash
? Nom du projet: my-awesome-app
? Description: Une application moderne avec Firebase et Next.js
? Version: 1.0.0
? Auteur: Votre Nom <votre.email@example.com>
```

**Conseils :**

- **Nom** : Utilisez des tirets, pas d'espaces
- **Description** : Soyez précis pour la documentation
- **Version** : Suivez le semver (1.0.0, 1.0.1, etc.)

### Étape 2 : Configuration Next.js

```bash
? Version de Next.js: 15.0.0
? Framework UI:
  ❯ Material-UI (MUI)
    Shadcn/ui
? Gestion d'état:
  ❯ Zustand
    Redux Toolkit
? Fonctionnalités avancées:
  ❯ PWA (Progressive Web App)
  ❯ FCM (Firebase Cloud Messaging)
  ❯ Analytics
  ❯ Performance Monitoring
  ❯ Sentry (Error Monitoring)
```

**Explications :**

#### **Framework UI**

- **Material-UI (MUI)** : Composants Material Design prêts à l'emploi
- **Shadcn/ui** : Composants headless personnalisables

#### **Gestion d'état**

- **Zustand** : Léger et simple, parfait pour la plupart des projets
- **Redux Toolkit** : Puissant et structuré, idéal pour les gros projets

#### **Fonctionnalités avancées**

- **PWA** : Application web installable avec cache offline
- **FCM** : Notifications push en temps réel
- **Analytics** : Suivi des utilisateurs et événements
- **Performance** : Monitoring des performances
- **Sentry** : Détection et reporting d'erreurs

### Étape 3 : Configuration Firebase

```bash
? Environnements à configurer:
  ❯ dev
  ❯ staging
  ❯ prod

? Pour l'environnement 'dev':
  ? Type de projet Firebase:
    ❯ Lier un projet existant
      Créer un nouveau projet
```

#### **Liaison à un projet existant**

```bash
? ID du projet Firebase existant: my-existing-project
? Vérification de la connexion Firebase...
✅ Connexion Firebase active
? Vérification du projet...
✅ Projet trouvé: my-existing-project
✅ Région détectée: us-central1
```

#### **Création d'un nouveau projet**

```bash
? Préfixe du projet: my-app
? ID du projet généré: my-app-dev
? Région Firebase:
  ❯ us-central1 (Iowa)
    us-east1 (South Carolina)
    europe-west1 (Belgium)
    asia-northeast1 (Tokyo)
```

**Régions recommandées :**

- **us-central1** : Défaut, bonne performance
- **europe-west1** : Pour l'Europe
- **asia-northeast1** : Pour l'Asie

### Étape 4 : Configuration des Cloud Functions

```bash
? Runtime Node.js: nodejs20
? Région des fonctions: us-central1
? Triggers à configurer:
  ❯ Auth (Création/suppression utilisateur)
  ❯ Firestore (Création/modification/suppression documents)
  ❯ Storage (Upload/suppression fichiers)
  ❯ HTTP (API REST, health checks)
  ❯ Scheduled (Tâches programmées)
```

#### **Triggers détaillés**

##### **Auth Triggers**

- **user-created** : Création automatique du profil utilisateur
- **user-updated** : Synchronisation des données utilisateur
- **user-deleted** : Nettoyage des données utilisateur

##### **Firestore Triggers**

- **document-created** : Logs d'audit, notifications
- **document-updated** : Validation, synchronisation
- **document-deleted** : Nettoyage, archives

##### **Storage Triggers**

- **file-uploaded** : Traitement d'images, génération de thumbnails
- **file-deleted** : Nettoyage des références

##### **HTTP Triggers**

- **health** : Monitoring de l'application
- **api** : Endpoints REST personnalisés

##### **Scheduled Triggers**

- **daily-cleanup** : Nettoyage des logs anciens
- **weekly-backup** : Sauvegarde automatique

### Étape 5 : Extensions Firebase

```bash
? Extensions Firebase à installer:
  ❯ Firebase Auth UI
  ❯ Firebase Storage
  ❯ Firebase Performance
  ❯ Firebase Analytics
  ❯ Algolia Search
  ❯ Stripe Payments
```

**Extensions populaires :**

- **Firebase Auth UI** : Interface d'authentification prête
- **Algolia Search** : Recherche avancée
- **Stripe Payments** : Paiements en ligne

## 🔧 Configuration avancée

### Variables d'environnement

Le générateur crée automatiquement les fichiers `.env.local` :

```bash
# .env.local
NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_project.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
NEXT_PUBLIC_FIREBASE_APP_ID=your_app_id
NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID=your_measurement_id

# Fonctionnalités
NEXT_PUBLIC_ENABLE_PWA=true
NEXT_PUBLIC_ENABLE_FCM=true
NEXT_PUBLIC_ENABLE_ANALYTICS=true
NEXT_PUBLIC_ENABLE_PERFORMANCE=true
NEXT_PUBLIC_ENABLE_SENTRY=true

# Sentry
NEXT_PUBLIC_SENTRY_DSN=your_sentry_dsn
NEXT_PUBLIC_SENTRY_ENVIRONMENT=development

# FCM
NEXT_PUBLIC_VAPID_KEY=your_vapid_key
NEXT_PUBLIC_FCM_PUBLIC_KEY=your_fcm_public_key
```

### Configuration TypeScript

Le générateur configure automatiquement TypeScript avec :

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/hooks/*": ["./src/hooks/*"],
      "@/stores/*": ["./src/stores/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/types/*": ["./src/types/*"],
      "@/utils/*": ["./src/utils/*"]
    }
  }
}
```

### Configuration Next.js

```javascript
// next.config.js
const nextConfig = {
  experimental: {
    appDir: true,
  },
  images: {
    domains: ['firebasestorage.googleapis.com'],
  },
  env: {
    CUSTOM_KEY: 'custom_value',
  },
  // Configuration PWA
  ...(process.env.NEXT_PUBLIC_ENABLE_PWA === 'true' && {
    pwa: {
      dest: 'public',
      register: true,
      skipWaiting: true,
    },
  }),
};

module.exports = nextConfig;
```

## 🎨 Personnalisation des templates

### Structure des templates

```
templates/
├── nextjs/                    # Templates Next.js
│   ├── app/                   # App Router
│   ├── components/            # Composants UI
│   ├── hooks/                 # Hooks personnalisés
│   ├── stores/                # Gestion d'état
│   ├── lib/                   # Utilitaires
│   └── tests/                 # Tests
└── firebase/                  # Templates Firebase
    ├── functions/             # Cloud Functions
    ├── firestore/             # Règles et index
    ├── storage/               # Règles de stockage
    └── scripts/               # Scripts de déploiement
```

### Modification des templates

#### **Ajouter un nouveau composant**

1. Créer le template dans `templates/nextjs/components/`
2. Modifier `src/generators/nextjs-generator.ts`
3. Ajouter la logique de génération

#### **Ajouter une nouvelle fonction Firebase**

1. Créer le template dans `templates/firebase/functions/`
2. Modifier `src/generators/firebase-generator.ts`
3. Ajouter l'export dans `index.ts`

### Variables Handlebars disponibles

```handlebars
{{project.name}}
# Nom du projet
{{project.description}}
# Description du projet
{{project.version}}
# Version du projet
{{project.author}}
# Auteur du projet

{{nextjs.ui}}
# Framework UI (mui/shadcn)
{{nextjs.stateManagement}}
# Gestion d'état (zustand/redux)
{{nextjs.features.pwa}}
# PWA activé
{{nextjs.features.fcm}}
# FCM activé

{{firebase.environments}}
# Liste des environnements
{{firebase.extensions}}
# Extensions Firebase

{{timestamp}}
# Timestamp de génération
{{year}}
# Année actuelle
```

## 🚀 Déploiement

### 1. Build du projet

```bash
# Build frontend
cd frontend
npm run build

# Build backend (Cloud Functions)
cd ../backend/functions
npm run build
```

### 2. Déploiement Firebase

```bash
# Déploiement complet
firebase deploy

# Déploiement sélectif
firebase deploy --only hosting
firebase deploy --only functions
firebase deploy --only firestore:rules
```

### 3. Déploiement par environnement

```bash
# Déploiement en dev
./scripts/deploy-env.sh dev

# Déploiement en staging
./scripts/deploy-env.sh staging

# Déploiement en production
./scripts/deploy-env.sh prod
```

### 4. Configuration CI/CD

Le générateur crée automatiquement les workflows GitHub Actions :

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run build
      - run: npm run deploy:${{ github.ref_name }}
```

## 🧪 Tests et qualité

### Tests unitaires

```bash
# Exécution des tests
npm test

# Tests en mode watch
npm run test:watch

# Couverture de code
npm run test:coverage
```

### Tests d'intégration

```bash
# Tests Firebase
npm run test:firebase

# Tests Next.js
npm run test:nextjs

# Tests complets
npm run test:all
```

### Qualité du code

```bash
# Linting
npm run lint

# Vérification des types
npm run type-check

# Audit de sécurité
npm audit

# Formatage du code
npm run format
```

## 🔍 Débogage

### Mode verbose

```bash
# Activer le mode verbose
firebase-nextjs-generator create --verbose

# Logs détaillés
DEBUG=* firebase-nextjs-generator create
```

### Logs et erreurs

```bash
# Vérifier les logs
tail -f ~/.firebase-nextjs-generator/logs/app.log

# Erreurs courantes
firebase-nextjs-generator create --debug
```

### Validation des templates

```bash
# Valider tous les templates
npm run validate-templates

# Valider un template spécifique
npm run validate-template:nextjs
npm run validate-template:firebase
```

## 📚 Exemples d'utilisation

### Exemple 1 : Application e-commerce

```bash
firebase-nextjs-generator create \
  --name ecommerce-app \
  --ui shadcn \
  --state-management zustand \
  --features pwa,fcm,analytics,performance \
  --firebase-extensions stripe,algolia
```

### Exemple 2 : Application de blog

```bash
firebase-nextjs-generator create \
  --name blog-app \
  --ui mui \
  --state-management redux \
  --features pwa,analytics \
  --firebase-extensions firebase-auth-ui
```

### Exemple 3 : Application de chat

```bash
firebase-nextjs-generator create \
  --name chat-app \
  --ui shadcn \
  --state-management zustand \
  --features pwa,fcm,analytics,performance \
  --firebase-extensions firebase-auth-ui
```

## 🚨 Résolution des problèmes

### Erreurs courantes

#### **Template non trouvé**

```bash
Error: ENOENT: no such file or directory, open '.../template.hbs'
```

**Solution :**

1. Vérifier que tous les templates sont présents
2. Exécuter `npm run validate-templates`
3. Régénérer les templates manquants

#### **Erreur de validation**

```bash
Error: Configuration invalide: [détails de l'erreur]
```

**Solution :**

1. Vérifier la configuration avec `npm run validate-config`
2. Corriger les erreurs indiquées
3. Relancer la génération

#### **Erreur Firebase**

```bash
Error: Firebase project not found
```

**Solution :**

1. Vérifier la connexion Firebase : `firebase login`
2. Vérifier l'ID du projet : `firebase projects:list`
3. Vérifier les permissions sur le projet

### Support et communauté

- **GitHub Issues** : [Signaler un bug](https://github.com/your-username/firebase-nextjs-generator/issues)
- **Discord** : [Communauté](https://discord.gg/your-community)
- **Documentation** : [Wiki](https://github.com/your-username/firebase-nextjs-generator/wiki)

## 🎉 Félicitations !

Vous maîtrisez maintenant le Générateur Firebase + Next.js 2025 !

## 📚 Documentation complète

**Prochaines étapes :**

- **[🚀 Guide de déploiement](DEPLOYMENT.md)** - Déployez votre application
- **[🔧 Guide de personnalisation](CUSTOMIZATION.md)** - Personnalisez selon vos besoins
- **[📚 Bonnes pratiques](BEST_PRACTICES.md)** - Standards et recommandations
- **[🤝 Guide de contribution](CONTRIBUTING.md)** - Contribuez au projet
- **[🔄 Guide de maintenance](MAINTENANCE.md)** - Maintenez et évoluez
- **[💡 Exemples d'utilisation](EXAMPLES.md)** - Exemples concrets

---

**💡 Astuce :** Utilisez `firebase-nextjs-generator --help` pour découvrir toutes les options disponibles !

**🚀 [Passer au déploiement →](DEPLOYMENT.md)**
