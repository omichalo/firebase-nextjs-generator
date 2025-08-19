# 🚀 Guide de déploiement complet

> **Déployez votre application Firebase + Next.js en production avec les meilleures pratiques**

## 📋 Table des matières

- [🎯 Vue d'ensemble](#-vue-densemble)
- [🔧 Préparation au déploiement](#-préparation-au-déploiement)
- [🌍 Configuration multi-environnements](#-configuration-multi-environnements)
- [📱 Déploiement Firebase](#-déploiement-firebase)
- [🔄 CI/CD avec GitHub Actions](#-cicd-avec-github-actions)
- [📊 Monitoring et observabilité](#-monitoring-et-observabilité)
- [🔒 Sécurité et performance](#-sécurité-et-performance)
- [🚨 Rollback et récupération](#-rollback-et-récupération)

## 🎯 Vue d'ensemble

Ce guide vous accompagne dans le déploiement de votre application en production, avec une approche multi-environnements et des bonnes pratiques de DevOps.

### 🎯 Objectifs du déploiement

- **Fiabilité** : Déploiement sans interruption de service
- **Sécurité** : Protection des données et des utilisateurs
- **Performance** : Optimisation pour la production
- **Observabilité** : Monitoring et alertes en temps réel
- **Récupération** : Rollback rapide en cas de problème

## 🔧 Préparation au déploiement

### 1. Vérification de la configuration

#### **Variables d'environnement**

```bash
# .env.production
NODE_ENV=production
NEXT_PUBLIC_FIREBASE_API_KEY=your_production_api_key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_project.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
NEXT_PUBLIC_FIREBASE_APP_ID=your_app_id
NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID=your_measurement_id

# Sentry
NEXT_PUBLIC_SENTRY_DSN=your_production_sentry_dsn
NEXT_PUBLIC_SENTRY_ENVIRONMENT=production

# FCM
NEXT_PUBLIC_VAPID_KEY=your_production_vapid_key
NEXT_PUBLIC_FCM_PUBLIC_KEY=your_production_fcm_public_key
```

#### **Configuration Firebase**

```bash
# Vérifier la configuration Firebase
firebase projects:list
firebase use your-production-project

# Vérifier les services activés
firebase projects:get your-production-project
```

### 2. Build de production

#### **Frontend (Next.js)**

```bash
cd frontend

# Installation des dépendances
npm ci --only=production

# Build de production
npm run build

# Vérification du build
npm run start
```

#### **Backend (Cloud Functions)**

```bash
cd backend/functions

# Installation des dépendances
npm ci --only=production

# Build TypeScript
npm run build

# Vérification du build
npm run serve
```

### 3. Tests de pré-déploiement

```bash
# Tests unitaires
npm test

# Tests d'intégration
npm run test:integration

# Tests de build
npm run test:build

# Audit de sécurité
npm audit --audit-level=high
```

## 🌍 Configuration multi-environnements

### 1. Structure des environnements

```bash
# Configuration des environnements
environments/
├── dev/
│   ├── .env.dev
│   ├── firebase.dev.json
│   └── next.config.dev.js
├── staging/
│   ├── .env.staging
│   ├── firebase.staging.json
│   └── next.config.staging.js
└── prod/
    ├── .env.production
    ├── firebase.production.json
    └── next.config.production.js
```

### 2. Configuration par environnement

#### **Développement (dev)**

```json
// firebase.dev.json
{
  "hosting": {
    "public": "frontend/out",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  },
  "functions": {
    "source": "backend/functions",
    "runtime": "nodejs20"
  },
  "firestore": {
    "rules": "backend/firestore.rules",
    "indexes": "backend/firestore.indexes.json"
  }
}
```

#### **Staging**

```json
// firebase.staging.json
{
  "hosting": {
    "public": "frontend/out",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "public, max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

#### **Production**

```json
// firebase.production.json
{
  "hosting": {
    "public": "frontend/out",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "public, max-age=31536000"
          }
        ]
      },
      {
        "source": "**/*.@(jpg|jpeg|gif|png|svg|webp)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "public, max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

### 3. Scripts de déploiement par environnement

```bash
#!/bin/bash
# scripts/deploy-env.sh

ENVIRONMENT=$1
PROJECT_ID=""

case $ENVIRONMENT in
  "dev")
    PROJECT_ID="your-project-dev"
    ;;
  "staging")
    PROJECT_ID="your-project-staging"
    ;;
  "prod")
    PROJECT_ID="your-project-prod"
    ;;
  *)
    echo "Environnement invalide: $ENVIRONMENT"
    exit 1
    ;;
esac

echo "🚀 Déploiement en $ENVIRONMENT..."
echo "📍 Projet: $PROJECT_ID"

# Basculer vers le projet
firebase use $PROJECT_ID

# Build frontend
cd frontend
npm run build
cd ..

# Build backend
cd backend/functions
npm run build
cd ../..

# Déploiement Firebase
firebase deploy --only hosting,functions,firestore:rules,storage

echo "✅ Déploiement en $ENVIRONMENT terminé!"
```

## 📱 Déploiement Firebase

### 1. Déploiement manuel

#### **Déploiement complet**

```bash
# Déploiement de tous les services
firebase deploy

# Vérification du déploiement
firebase hosting:channel:list
firebase functions:list
```

#### **Déploiement sélectif**

```bash
# Déploiement du hosting uniquement
firebase deploy --only hosting

# Déploiement des fonctions uniquement
firebase deploy --only functions

# Déploiement des règles Firestore
firebase deploy --only firestore:rules

# Déploiement du storage
firebase deploy --only storage
```

### 2. Déploiement avec canary

```bash
# Créer un canal de déploiement
firebase hosting:channel:deploy preview

# Tester le canal
firebase hosting:channel:open preview

# Promouvoir en production
firebase hosting:channel:promote preview
```

### 3. Déploiement avec rollback

```bash
# Lister les versions déployées
firebase hosting:releases:list

# Rollback vers une version précédente
firebase hosting:releases:rollback VERSION_ID
```

## 🔄 CI/CD avec GitHub Actions

### 1. Workflow de déploiement automatique

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: "18"

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: "npm"

      - run: npm ci
      - run: npm test
      - run: npm run build

  deploy-dev:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    environment: development

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: "npm"

      - run: npm ci
      - run: npm run build

      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_DEV }}"
          projectId: your-project-dev
          channelId: live

  deploy-staging:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: staging

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: "npm"

      - run: npm ci
      - run: npm run build

      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_STAGING }}"
          projectId: your-project-staging
          channelId: live

  deploy-production:
    needs: [test, deploy-staging]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: "npm"

      - run: npm ci
      - run: npm run build

      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_PROD }}"
          projectId: your-project-prod
          channelId: live
```

### 2. Configuration des secrets

```bash
# Dans GitHub Repository > Settings > Secrets and variables > Actions

# Service Account Firebase pour chaque environnement
FIREBASE_SERVICE_ACCOUNT_DEV
FIREBASE_SERVICE_ACCOUNT_STAGING
FIREBASE_SERVICE_ACCOUNT_PROD

# Variables d'environnement
NEXT_PUBLIC_FIREBASE_API_KEY
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN
NEXT_PUBLIC_FIREBASE_PROJECT_ID
```

### 3. Workflow de déploiement manuel

```yaml
# .github/workflows/manual-deploy.yml
name: Manual Deploy

on:
  workflow_dispatch:
    inputs:
      environment:
        description: "Environment to deploy to"
        required: true
        default: "staging"
        type: choice
        options:
          - dev
          - staging
          - prod

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ github.event.inputs.environment }}

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "18"
          cache: "npm"

      - run: npm ci
      - run: npm run build

      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_${{ github.event.inputs.environment | upper }} }}"
          projectId: your-project-${{ github.event.inputs.environment }}
          channelId: live
```

## 📊 Monitoring et observabilité

### 1. Firebase Performance Monitoring

```typescript
// lib/performance.ts
import { getPerformance, trace } from "firebase/performance";

export const performance = getPerformance();

// Traçage des performances
export const tracePageLoad = (pageName: string) => {
  const pageLoadTrace = trace(performance, "page_load");
  pageLoadTrace.start();

  return {
    stop: () => pageLoadTrace.stop(),
    addMetric: (metricName: string, value: number) =>
      pageLoadTrace.putMetric(metricName, value),
  };
};

// Traçage des actions utilisateur
export const traceUserAction = (actionName: string) => {
  const userActionTrace = trace(performance, "user_action");
  userActionTrace.start();

  return {
    stop: () => userActionTrace.stop(),
    addAttribute: (attributeName: string, value: string) =>
      userActionTrace.putAttribute(attributeName, value),
  };
};
```

### 2. Sentry Error Monitoring

```typescript
// lib/sentry.ts
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NEXT_PUBLIC_SENTRY_ENVIRONMENT,
  tracesSampleRate: 1.0,
  integrations: [
    new Sentry.BrowserTracing({
      tracePropagationTargets: ["localhost", "your-domain.com"],
    }),
  ],
});

// Capture des erreurs
export const captureError = (error: Error, context?: any) => {
  Sentry.captureException(error, {
    extra: context,
  });
};

// Capture des messages
export const captureMessage = (
  message: string,
  level: Sentry.SeverityLevel = "info"
) => {
  Sentry.captureMessage(message, level);
};
```

### 3. Health Checks

```typescript
// pages/api/health.ts
import { NextApiRequest, NextApiResponse } from "next";
import { db } from "@/lib/firebase";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  try {
    // Vérifier la connexion Firestore
    await db.collection("health").doc("check").get();

    // Vérifier la connexion Auth
    // (Firebase Admin SDK)

    res.status(200).json({
      status: "healthy",
      timestamp: new Date().toISOString(),
      services: {
        firestore: "connected",
        auth: "connected",
      },
      environment: process.env.NODE_ENV,
    });
  } catch (error) {
    res.status(500).json({
      status: "unhealthy",
      timestamp: new Date().toISOString(),
      error: error.message,
    });
  }
}
```

## 🔒 Sécurité et performance

### 1. Règles de sécurité Firestore

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Règles par défaut - restreindre l'accès
    match /{document=**} {
      allow read, write: if false;
    }

    // Règles pour les utilisateurs authentifiés
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Règles pour les données publiques (lecture seule)
    match /public/{document=**} {
      allow read: if true;
      allow write: if false;
    }

    // Règles pour les administrateurs
    match /admin/{document=**} {
      allow read, write: if request.auth != null &&
        exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

### 2. Optimisation des performances

#### **Lazy Loading**

```typescript
// Composants chargés à la demande
import dynamic from 'next/dynamic';

const HeavyComponent = dynamic(() => import('./HeavyComponent'), {
  loading: () => <div>Chargement...</div>,
  ssr: false,
});
```

#### **Image Optimization**

```typescript
// next.config.js
const nextConfig = {
  images: {
    domains: ["firebasestorage.googleapis.com"],
    formats: ["image/webp", "image/avif"],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
    imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
  },
};
```

#### **Bundle Analysis**

```bash
# Analyser la taille du bundle
npm run build
npm run analyze

# Optimiser les imports
npm run bundle-analyzer
```

### 3. Sécurité des headers

```javascript
// next.config.js
const nextConfig = {
  async headers() {
    return [
      {
        source: "/(.*)",
        headers: [
          {
            key: "X-Frame-Options",
            value: "DENY",
          },
          {
            key: "X-Content-Type-Options",
            value: "nosniff",
          },
          {
            key: "Referrer-Policy",
            value: "strict-origin-when-cross-origin",
          },
          {
            key: "Permissions-Policy",
            value: "camera=(), microphone=(), geolocation=()",
          },
        ],
      },
    ];
  },
};
```

## 🚨 Rollback et récupération

### 1. Stratégie de rollback

```bash
#!/bin/bash
# scripts/rollback.sh

ENVIRONMENT=$1
VERSION=$2

if [ -z "$ENVIRONMENT" ] || [ -z "$VERSION" ]; then
  echo "Usage: ./rollback.sh <environment> <version>"
  exit 1
fi

echo "🔄 Rollback de $ENVIRONMENT vers la version $VERSION..."

# Basculer vers l'environnement
firebase use $ENVIRONMENT

# Rollback des fonctions
firebase functions:rollback --version $VERSION

# Rollback du hosting
firebase hosting:clone $ENVIRONMENT:live:$VERSION $ENVIRONMENT:live

echo "✅ Rollback terminé!"
```

### 2. Points de restauration

```bash
# Créer un point de restauration
firebase hosting:releases:create backup-$(date +%Y%m%d-%H%M%S)

# Lister les points de restauration
firebase hosting:releases:list

# Restaurer un point
firebase hosting:releases:rollback VERSION_ID
```

### 3. Monitoring des déploiements

```typescript
// lib/deployment-monitor.ts
export class DeploymentMonitor {
  static async checkDeploymentHealth() {
    try {
      // Vérifier les endpoints critiques
      const healthCheck = await fetch("/api/health");
      const performance = await fetch("/api/performance");

      if (!healthCheck.ok || !performance.ok) {
        throw new Error("Déploiement défaillant");
      }

      return { status: "healthy" };
    } catch (error) {
      // Alerter l'équipe
      await this.alertTeam(error);
      return { status: "unhealthy", error: error.message };
    }
  }

  static async alertTeam(error: Error) {
    // Envoyer une alerte Slack/Email
    console.error("🚨 Alerte déploiement:", error);
  }
}
```

## ✅ Checklist de déploiement

### Pré-déploiement

- [ ] Tests unitaires passent
- [ ] Tests d'intégration passent
- [ ] Build de production réussi
- [ ] Variables d'environnement configurées
- [ ] Configuration Firebase vérifiée
- [ ] Audit de sécurité effectué

### Déploiement

- [ ] Déploiement en staging réussi
- [ ] Tests de staging passent
- [ ] Déploiement en production réussi
- [ ] Health checks passent
- [ ] Monitoring configuré
- [ ] Alertes configurées

### Post-déploiement

- [ ] Vérification des performances
- [ ] Vérification des erreurs
- [ ] Vérification des logs
- [ ] Tests de régression
- [ ] Documentation mise à jour

## 🎉 Félicitations !

Votre application est maintenant déployée en production avec une architecture robuste et des bonnes pratiques de DevOps !

**Prochaines étapes :**

- [Guide de personnalisation](CUSTOMIZATION.md) 🎨
- [Guide des bonnes pratiques](BEST_PRACTICES.md) 📚
- [Guide de maintenance](MAINTENANCE.md) 🔧

---

**💡 Astuce :** Configurez des alertes automatiques pour être notifié en cas de problème en production !
