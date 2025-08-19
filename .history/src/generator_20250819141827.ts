import * as fs from 'fs-extra';
import * as path from 'path';
import { NextJSGenerator } from './generators/nextjs-generator';
import { FirebaseGenerator } from './generators/firebase-generator';
import { GeneratorOptions } from './types';

import { TemplateEngine } from './utils/template-engine';

export class Generator {
  private options: GeneratorOptions;
  private nextjsGenerator: NextJSGenerator;
  private firebaseGenerator: FirebaseGenerator;
  private templateEngine: TemplateEngine;

  constructor(options: GeneratorOptions) {
    this.options = options;
    this.nextjsGenerator = new NextJSGenerator(options);
    this.firebaseGenerator = new FirebaseGenerator(options);
    this.templateEngine = new TemplateEngine(options);
  }

  async generate(): Promise<void> {
    console.log('🚀 Démarrage de la génération du projet...');

    // Créer la structure principale
    await this.createMainStructure();

    // Générer le frontend Next.js
    await this.nextjsGenerator.generate();

    // Générer le backend Firebase
    await this.firebaseGenerator.generate();

    // Générer les fichiers de configuration globaux
    await this.generateGlobalConfig();

    // Générer la documentation
    await this.generateDocumentation();

    // Générer les scripts de déploiement
    await this.generateDeploymentScripts();

    console.log('✅ Génération terminée avec succès!');
  }

  private async createMainStructure(): Promise<void> {
    const directories = ['docs', 'scripts', 'github', 'config'];

    for (const dir of directories) {
      await fs.ensureDir(path.join(this.options.outputDir, dir));
    }
  }

  private async generateGlobalConfig(): Promise<void> {
    // README.md principal
    await this.generateMainReadme();

    // Configuration GitHub Actions
    await this.generateGitHubActions();

    // Configuration des environnements
    await this.generateEnvironmentConfig();

    // Configuration des thèmes
    await this.generateThemeConfig();
  }

  private async generateMainReadme(): Promise<void> {
    const readmeContent = `# {{project.name}}

{{project.description}}

## 🚀 Technologies

- **Frontend**: Next.js {{nextjs.version}} avec App Router et API routes
- **Backend**: Firebase App Hosting (Firestore, Auth, Functions, Storage)
- **UI**: {{#ifEquals nextjs.ui "mui"}}Material-UI (MUI){{/ifEquals}}{{#ifEquals nextjs.ui "shadcn"}}Shadcn/ui{{/ifEquals}}{{#ifEquals nextjs.ui "both"}}Material-UI + Shadcn/ui{{/ifEquals}}
- **State Management**: {{#ifEquals nextjs.stateManagement "zustand"}}Zustand{{/ifEquals}}{{#ifEquals nextjs.stateManagement "redux"}}Redux Toolkit{{/ifEquals}}{{#ifEquals nextjs.stateManagement "both"}}Zustand + Redux{{/ifEquals}}
- **TypeScript**: Strict mode activé
- **PWA**: {{#if nextjs.features.pwa}}Activé avec Service Worker{{else}}Désactivé{{/if}}
- **FCM**: {{#if nextjs.features.fcm}}Activé pour notifications push{{else}}Désactivé{{/if}}
- **Analytics**: {{#if nextjs.features.analytics}}Activé pour suivi utilisateurs{{else}}Désactivé{{/if}}
- **Performance**: {{#if nextjs.features.performance}}Activé pour monitoring{{else}}Désactivé{{/if}}
- **Sentry**: {{#if nextjs.features.sentry}}Activé pour error tracking{{else}}Désactivé{{/if}}

## 📁 Structure du Projet

\`\`\`
{{project.name}}/
├── frontend/          # Application Next.js {{nextjs.version}} avec API routes
│   ├── src/
│   │   ├── app/       # App Router avec API routes (/api/*)
│   │   ├── components/ # Composants réutilisables
│   │   ├── hooks/     # Hooks personnalisés
│   │   ├── stores/    # Gestion d'état ({{nextjs.stateManagement}})
│   │   └── lib/       # Utilitaires et configuration
├── backend/           # Configuration Firebase App Hosting
│   ├── firebase.json              # Configuration Firebase (sans hosting)
│   ├── firebase-app-hosting.json # Configuration App Hosting avec API routes
│   ├── functions/     # Cloud Functions Node.js 20
│   ├── firestore/     # Règles et index
│   ├── storage/       # Règles de stockage
│   └── extensions/    # Extensions Firebase
├── docs/             # Documentation
├── scripts/          # Scripts de déploiement
└── github/           # GitHub Actions
\`\`\`

## 🛠️ Installation

1. **Cloner le projet**
   \`\`\`bash
   git clone <repository-url>
   cd {{project.name}}
   \`\`\`

2. **Installer les dépendances**
   \`\`\`bash
   # Frontend
   cd frontend
   {{project.packageManager}} install
   
   # Backend (Cloud Functions)
   cd ../backend/functions
   {{project.packageManager}} install
   \`\`\`

3. **Configuration Firebase**
   \`\`\`bash
   firebase login
   firebase use {{firebase.projectId}}
   \`\`\`

4. **Variables d'environnement**
   \`\`\`bash
   # Copier le fichier d'exemple
   cp frontend/.env.local.example frontend/.env.local
   
   # Configurer les variables
   # Voir docs/environment-setup.md
   \`\`\`

## 🚀 Développement

### Frontend
\`\`\`bash
cd frontend
{{project.packageManager}} run dev
\`\`\`

### Backend (Emulateur Firebase)
\`\`\`bash
cd backend
firebase emulators:start
\`\`\`

## 📦 Déploiement Firebase App Hosting

### **Configuration Firebase App Hosting**

Le projet utilise **Firebase App Hosting** pour supporter les API routes Next.js :

\`\`\`json
// firebase-app-hosting.json
{
  "hosting": {
    "public": "frontend/.next",
    "rewrites": [
      {
        "source": "/api/**",
        "function": "nextjs-api"
      }
    ]
  }
}
\`\`\`

### Environnements Disponibles
{{#each firebase.environments}}
- **{{name}}**: {{projectId}}
{{/each}}

### Déploiement complet

\`\`\`bash
# 1. Build de l'application Next.js
cd frontend
{{project.packageManager}} run build

# 2. Déploiement Firebase complet
cd ../backend
firebase deploy
\`\`\`

### Déploiement sélectif

\`\`\`bash
# Déploiement App Hosting uniquement
firebase deploy --only hosting

# Déploiement Cloud Functions uniquement
firebase deploy --only functions

# Déploiement Firestore uniquement
firebase deploy --only firestore

# Déploiement Storage uniquement
firebase deploy --only storage
\`\`\`

## 📱 Fonctionnalités

{{#if nextjs.features.pwa}}
- ✅ **PWA** - Progressive Web App avec Service Worker
{{/if}}
{{#if nextjs.features.fcm}}
- ✅ **FCM** - Firebase Cloud Messaging pour notifications push
{{/if}}
{{#if nextjs.features.analytics}}
- ✅ **Analytics** - Firebase Analytics pour le suivi des utilisateurs
{{/if}}
{{#if nextjs.features.performance}}
- ✅ **Performance** - Firebase Performance Monitoring
{{/if}}
{{#if nextjs.features.sentry}}
- ✅ **Sentry** - Monitoring des erreurs et performance
{{/if}}

### **Avantages Firebase App Hosting**

- ✅ **API routes Next.js** : Complètement supportées
- ✅ **SSR/SSG** : Possible via Cloud Functions
- ✅ **Middleware** : Supporté
- ✅ **Dynamic routes** : Fonctionnels
- ✅ **Écosystème Firebase** : 100% intégré

## 🧪 Tests

\`\`\`bash
# Tests frontend
cd frontend
{{project.packageManager}} run test

# Tests backend
cd backend/functions
{{project.packageManager}} run test
\`\`\`

## 📚 Documentation

- [Guide de développement](docs/development.md)
- [Guide de déploiement](docs/deployment.md)
- [Configuration des environnements](docs/environment-setup.md)
- [Architecture](docs/architecture.md)

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (\`git checkout -b feature/AmazingFeature\`)
3. Commit les changements (\`git commit -m 'Add some AmazingFeature'\`)
4. Push vers la branche (\`git push origin feature/AmazingFeature\`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence {{project.license}}. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Auteurs

{{project.author}}

---

Généré avec ❤️ par Firebase Next.js Generator
`;

    await fs.writeFile(
      path.join(this.options.outputDir, 'README.md'),
      this.processTemplate(readmeContent)
    );
  }

  private async generateGitHubActions(): Promise<void> {
    const githubDir = path.join(this.options.outputDir, 'github/workflows');

    // Workflow CI/CD principal
    const ciWorkflow = `name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
        cache: '{{project.packageManager}}'
    
    - name: Install dependencies (Frontend)
      run: |
        cd frontend
        {{project.packageManager}} install
    
    - name: Install dependencies (Backend)
      run: |
        cd backend/functions
        {{project.packageManager}} install
    
    - name: Run tests (Frontend)
      run: |
        cd frontend
        {{project.packageManager}} run test
    
    - name: Run tests (Backend)
      run: |
        cd backend/functions
        {{project.packageManager}} run test
    
    - name: Build (Frontend)
      run: |
        cd frontend
        {{project.packageManager}} run build

  deploy-dev:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
    
    - name: Setup Firebase
      uses: FirebaseExtended/action-hosting-deploy@v0
      with:
        repoToken: '\${{ secrets.GITHUB_TOKEN }}'
        firebaseServiceAccount: '\${{ secrets.FIREBASE_SERVICE_ACCOUNT_DEV }}'
        projectId: {{firebase.projectId}}
        channelId: live
    
    - name: Deploy to Firebase
      run: |
        cd backend
        firebase deploy --only hosting,functions --project {{firebase.projectId}}

  deploy-prod:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
    
    - name: Setup Firebase
      uses: FirebaseExtended/action-hosting-deploy@v0
      with:
        repoToken: '\${{ secrets.GITHUB_TOKEN }}'
        firebaseServiceAccount: '\${{ secrets.FIREBASE_SERVICE_ACCOUNT_PROD }}'
        projectId: {{firebase.projectId}}
        channelId: live
    
    - name: Deploy to Firebase
      run: |
        cd backend
        firebase deploy --only hosting,functions --project {{firebase.projectId}}
`;

    await fs.ensureDir(githubDir);
    await fs.writeFile(
      path.join(githubDir, 'ci-cd.yml'),
      this.processTemplate(ciWorkflow)
    );
  }

  private async generateEnvironmentConfig(): Promise<void> {
    const configDir = path.join(this.options.outputDir, 'config');

    // Configuration par environnement
    for (const env of this.options.firebase.environments) {
      const envConfig = {
        name: env.name,
        projectId: env.projectId,
        region: env.region,
        variables: env.variables,
        firebase: {
          projectId: env.projectId,
          region: env.region,
        },
        nextjs: {
          ...this.options.nextjs,
          env: env.name,
        },
      };

      await fs.writeFile(
        path.join(configDir, `${env.name}.json`),
        JSON.stringify(envConfig, null, 2)
      );
    }
  }

  private async generateThemeConfig(): Promise<void> {
    const configDir = path.join(this.options.outputDir, 'config');

    const themeConfig = {
      themes: this.options.themes,
      defaultTheme: this.options.themes[0]?.name || 'default',
    };

    await fs.writeFile(
      path.join(configDir, 'themes.json'),
      JSON.stringify(themeConfig, null, 2)
    );
  }

  private async generateDocumentation(): Promise<void> {
    const docsDir = path.join(this.options.outputDir, 'docs');

    // Guide de développement
    const developmentGuide = `# Guide de Développement

## 🛠️ Configuration de l'Environnement

### Prérequis
- Node.js 18+
- {{project.packageManager}}
- Firebase CLI
- Git

### Installation
1. Cloner le repository
2. Installer les dépendances (voir README.md)
3. Configurer Firebase
4. Configurer les variables d'environnement

## 📁 Architecture

### Frontend (Next.js)
- **App Router**: Architecture moderne Next.js 15
- **TypeScript**: Strict mode activé
- **UI Components**: {{#ifEquals nextjs.ui "mui"}}Material-UI{{/ifEquals}}{{#ifEquals nextjs.ui "shadcn"}}Shadcn/ui{{/ifEquals}}
- **State Management**: {{#ifEquals nextjs.stateManagement "zustand"}}Zustand{{/ifEquals}}{{#ifEquals nextjs.stateManagement "redux"}}Redux{{/ifEquals}}

### Backend (Firebase)
- **Firestore**: Base de données NoSQL
- **Cloud Functions**: Logique métier
- **Authentication**: Gestion des utilisateurs
- **Storage**: Fichiers et médias

## 🔧 Scripts Disponibles

### Frontend
\`\`\`bash
{{project.packageManager}} run dev      # Développement
{{project.packageManager}} run build    # Production build
{{project.packageManager}} run start    # Production serveur
{{project.packageManager}} run test     # Tests
{{project.packageManager}} run lint     # Linting
\`\`\`

### Backend
\`\`\`bash
{{project.packageManager}} run build    # Build des fonctions
{{project.packageManager}} run test     # Tests
{{project.packageManager}} run deploy   # Déploiement
\`\`\`

## 🧪 Tests

### Tests Frontend
- **Jest**: Tests unitaires
- **React Testing Library**: Tests de composants
- **Cypress**: Tests E2E

### Tests Backend
- **Jest**: Tests unitaires
- **Firebase Emulator**: Tests d'intégration

## 📝 Conventions de Code

### TypeScript
- Strict mode obligatoire
- Interfaces pour tous les types
- Pas de \`any\` sauf cas exceptionnel

### React/Next.js
- Fonctions composants avec hooks
- Props typées avec TypeScript
- Hooks personnalisés pour la logique

### Firebase
- Règles de sécurité strictes
- Index optimisés
- Fonctions modulaires
`;

    await fs.writeFile(
      path.join(docsDir, 'development.md'),
      this.processTemplate(developmentGuide)
    );

    // Guide de déploiement
    const deploymentGuide = `# Guide de Déploiement

## 🚀 Déploiement Automatique

### GitHub Actions
Le projet utilise GitHub Actions pour le CI/CD automatique :

1. **Push sur develop** → Déploiement automatique en dev
2. **Push sur main** → Déploiement automatique en production
3. **Pull Request** → Tests automatiques

### Configuration des Secrets
Configurer les secrets suivants dans GitHub :
- \`FIREBASE_SERVICE_ACCOUNT_DEV\`
- \`FIREBASE_SERVICE_ACCOUNT_PROD\`

## 🔧 Déploiement Manuel

### Frontend
\`\`\`bash
cd frontend
{{project.packageManager}} run build
firebase deploy --only hosting
\`\`\`

### Backend
\`\`\`bash
cd backend
firebase deploy --only functions,firestore
\`\`\`

### Tout
\`\`\`bash
firebase deploy
\`\`\`

## 🌍 Environnements

### Développement
- **URL**: https://{{firebase.projectId}}-dev.web.app
- **Firebase Project**: {{firebase.projectId}}-dev

### Staging
- **URL**: https://{{firebase.projectId}}-staging.web.app
- **Firebase Project**: {{firebase.projectId}}-staging

### Production
- **URL**: https://{{firebase.projectId}}.web.app
- **Firebase Project**: {{firebase.projectId}}

## 📊 Monitoring

### Firebase Console
- Performance Monitoring
- Analytics
- Crashlytics

### Sentry (si activé)
- Error tracking
- Performance monitoring
- Release tracking

## 🔄 Rollback

### Frontend
\`\`\`bash
firebase hosting:clone {{firebase.projectId}}:live:{{version}} {{firebase.projectId}}:live
\`\`\`

### Backend
\`\`\`bash
firebase functions:rollback {{functionName}} {{version}}
\`\`\`
`;

    await fs.writeFile(
      path.join(docsDir, 'deployment.md'),
      this.processTemplate(deploymentGuide)
    );
  }

  private async generateDeploymentScripts(): Promise<void> {
    const scriptsDir = path.join(this.options.outputDir, 'scripts');

    // Script de déploiement principal
    const deployScript = `#!/bin/bash

# Script de déploiement principal
# Usage: ./scripts/deploy.sh [environment]

set -e

ENVIRONMENT=\${1:-dev}
PROJECT_NAME="{{project.name}}"

echo "🚀 Déploiement de \$PROJECT_NAME en \$ENVIRONMENT..."

# Vérifier l'environnement
if [[ ! "\$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo "❌ Environnement invalide. Utilisez: dev, staging, ou prod"
    exit 1
fi

# Build frontend
echo "📦 Build du frontend..."
cd frontend
{{project.packageManager}} install
{{project.packageManager}} run build

# Build backend
echo "🔥 Build du backend..."
cd ../backend/functions
{{project.packageManager}} install
{{project.packageManager}} run build

# Déploiement Firebase
echo "🚀 Déploiement Firebase..."
cd ..
firebase use \$ENVIRONMENT
firebase deploy

echo "✅ Déploiement terminé!"
echo "🌐 URL: https://{{firebase.projectId}}-\$ENVIRONMENT.web.app"
`;

    await fs.writeFile(
      path.join(scriptsDir, 'deploy.sh'),
      this.processTemplate(deployScript)
    );

    // Rendre le script exécutable
    await fs.chmod(path.join(scriptsDir, 'deploy.sh'), 0o755);

    // Script d'initialisation Linux/Mac
    const initScriptSh = `#!/bin/bash

# Script d'initialisation automatique
# Usage: ./scripts/init-project.sh [environment]
# Exemple: ./scripts/init-project.sh dev

set -e

ENVIRONMENT=\${1:-dev}
PROJECT_NAME="{{project.name}}"

echo "🚀 Initialisation automatique de \$PROJECT_NAME en \$ENVIRONMENT..."

# Vérifier l'environnement
if [[ ! "\$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo "❌ Environnement invalide. Utilisez: dev, staging, ou prod"
    exit 1
fi

# Installer les dépendances frontend
echo "📦 Installation des dépendances frontend..."
cd frontend
{{project.packageManager}} install

# Vérifier Firebase CLI
echo "🔥 Vérification de Firebase CLI..."
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI non installé. Installez-le avec: npm install -g firebase-tools"
    exit 1
fi

# Connexion Firebase
echo "🔐 Connexion Firebase..."
firebase login

# Configurer l'environnement Firebase
echo "⚙️ Configuration de l'environnement \$ENVIRONMENT..."
cd ../backend
firebase use \$ENVIRONMENT

# Lancer l'application
echo "🚀 Lancement de l'application..."
cd ../frontend
{{project.packageManager}} run dev

echo "✅ Initialisation terminée!"
echo "🌐 Application disponible sur: http://localhost:3000"
`;

    await fs.writeFile(
      path.join(scriptsDir, 'init-project.sh'),
      this.processTemplate(initScriptSh)
    );

    // Rendre le script exécutable
    await fs.chmod(path.join(scriptsDir, 'init-project.sh'), 0o755);

    // Script d'initialisation Windows
    const initScriptBat = `@echo off
REM Script d'initialisation automatique pour Windows
REM Usage: scripts\\init-project.bat [environment]
REM Exemple: scripts\\init-project.bat dev

setlocal enabledelayedexpansion

set ENVIRONMENT=%1
if "%ENVIRONMENT%"=="" set ENVIRONMENT=dev

echo 🚀 Initialisation automatique de {{project.name}} en %ENVIRONMENT%...

REM Vérifier l'environnement
if not "%ENVIRONMENT%"=="dev" if not "%ENVIRONMENT%"=="staging" if not "%ENVIRONMENT%"=="prod" (
    echo ❌ Environnement invalide. Utilisez: dev, staging, ou prod
    exit /b 1
)

REM Installer les dépendances frontend
echo 📦 Installation des dépendances frontend...
cd frontend
{{project.packageManager}} install

REM Vérifier Firebase CLI
echo 🔥 Vérification de Firebase CLI...
firebase --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Firebase CLI non installé. Installez-le avec: npm install -g firebase-tools
    exit /b 1
)

REM Connexion Firebase
echo 🔐 Connexion Firebase...
firebase login

REM Configurer l'environnement Firebase
echo ⚙️ Configuration de l'environnement %ENVIRONMENT%...
cd ..\\backend
firebase use %ENVIRONMENT%

REM Lancer l'application
echo 🚀 Lancement de l'application...
cd ..\\frontend
{{project.packageManager}} run dev

echo ✅ Initialisation terminée!
echo 🌐 Application disponible sur: http://localhost:3000
`;

    await fs.writeFile(
      path.join(scriptsDir, 'init-project.bat'),
      this.processTemplate(initScriptBat)
    );
  }

  private processTemplate(template: string): string {
    // Utiliser le moteur de template Handlebars
    const compiledTemplate = this.templateEngine.compileTemplate(template);
    return compiledTemplate(this.templateEngine['context']);
  }
}
