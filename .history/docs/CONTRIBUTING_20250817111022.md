# 🤝 Guide de contribution

> **Contribuez au développement du Générateur Firebase + Next.js 2025**

## 📋 Table des matières

- [🚀 Vue d'ensemble](#-vue-densemble)
- [✨ Fonctionnalités](#-fonctionnalités)
- [🏗️ Architecture](#️-architecture)
- [🔧 Configuration de l'environnement](#-configuration-de-lenvironnement)
- [🔧 Développement](#-développement)
- [🤝 Contribution](#-contribution)
- [📄 License](#-license)

## 🚀 Vue d'ensemble

Le **Générateur Firebase + Next.js 2025** est un outil puissant qui automatise la création de projets web modernes combinant :

- **Frontend** : Next.js 15 avec App Router, React 19, TypeScript 5.5
- **Backend** : Firebase (Firestore, Functions, Auth, Storage, Hosting)
- **Architecture** : Multi-environnements, PWA, FCM, Monitoring
- **DevOps** : CI/CD automatisé, tests, déploiement

### 🎯 Objectifs

- **Rapidité** : Génération de projet en moins de 2 minutes
- **Qualité** : Code production-ready avec bonnes pratiques
- **Flexibilité** : Configuration adaptée à chaque projet
- **Maintenance** : Architecture évolutive et maintenable

## ✨ Fonctionnalités

### 🎨 Frontend (Next.js 15)

- **Framework moderne** : Next.js 15 avec App Router
- **React 19** : Dernière version avec concurrent features
- **TypeScript 5.5** : Typage strict et avancé
- **UI Frameworks** : Material-UI (MUI) ou Shadcn/ui
- **State Management** : Zustand ou Redux Toolkit
- **Data Fetching** : React Query (TanStack Query)
- **PWA** : Service Worker, manifest, offline support
- **FCM** : Notifications push Firebase
- **Analytics** : Firebase Analytics intégré
- **Performance** : Monitoring et optimisation

### 🔥 Backend (Firebase)

- **Firestore** : Base de données NoSQL avec règles de sécurité
- **Cloud Functions** : Backend serverless Node.js 20
- **Authentication** : Système d'auth complet
- **Storage** : Stockage de fichiers sécurisé
- **Hosting** : Déploiement SSR/SSG
- **Extensions** : Intégrations Firebase prêtes à l'emploi

### 🚀 DevOps & Monitoring

- **Multi-environnements** : dev, staging, production
- **CI/CD** : GitHub Actions automatisé
- **Monitoring** : Sentry, Firebase Performance
- **Logs** : Winston avec structure avancée
- **Health Checks** : Endpoints de monitoring
- **Backup** : Sauvegarde automatique

## 🏗️ Architecture

### 📁 Structure du projet généré

```
project-name/
├── frontend/                 # Application Next.js
│   ├── src/
│   │   ├── app/             # App Router (Next.js 15)
│   │   ├── components/      # Composants réutilisables
│   │   ├── hooks/           # Hooks personnalisés
│   │   ├── stores/          # Gestion d'état
│   │   ├── lib/             # Utilitaires et config
│   │   ├── types/           # Types TypeScript
│   │   └── utils/           # Fonctions utilitaires
│   ├── public/              # Assets statiques
│   └── tests/               # Tests unitaires et e2e
├── backend/                  # Configuration Firebase
│   ├── functions/            # Cloud Functions
│   ├── firestore/            # Règles et index
│   ├── storage/              # Règles de stockage
│   └── scripts/              # Scripts de déploiement
└── docs/                     # Documentation
```

### 🔄 Flux de données

```
User Interface → State Management → API Routes → Cloud Functions → Firestore
     ↓                ↓              ↓            ↓            ↓
  Next.js 15      Zustand/Redux   Next.js API  Firebase    Database
  Components      Stores          Routes        Functions   Security
```

## 📚 Documentation de référence

> **💡 Pour l'installation et l'utilisation :** Consultez les guides spécialisés :
>
> - **[📦 Installation](INSTALLATION.md)** - Installation complète et configuration
> - **[🎯 Utilisation](USAGE.md)** - Guide d'utilisation détaillé

## 🔧 Configuration de l'environnement

### 1. **Prérequis système**

#### **Versions requises**

- **Node.js** : 18.0.0 ou supérieur
- **npm** : 9.0.0 ou supérieur
- **Git** : 2.30.0 ou supérieur
- **Firebase CLI** : 13.0.0 ou supérieur (pour les tests)

#### **Vérification des prérequis**

```bash
# Vérifier Node.js
node --version
# Doit afficher v18.x.x ou supérieur

# Vérifier npm
npm --version
# Doit afficher 9.x.x ou supérieur

# Vérifier Git
git --version
# Doit afficher 2.30.x ou supérieur

# Vérifier Firebase CLI (optionnel)
firebase --version
# Doit afficher 13.x.x ou supérieur
```

### 2. **Configuration de l'environnement de développement**

#### **Clonage du projet**

```bash
# Fork du projet sur GitHub d'abord
# Puis cloner votre fork
git clone https://github.com/votre-username/firebase-nextjs-generator.git
cd firebase-nextjs-generator

# Ajouter le remote upstream
git remote add upstream https://github.com/original-username/firebase-nextjs-generator.git
```

#### **Installation des dépendances**

```bash
# Installation des dépendances
npm install

# Vérifier l'installation
npm run type-check
npm run lint
```

#### **Configuration VS Code**

Créez un fichier `.vscode/settings.json` :

```json
{
  "typescript.preferences.importModuleSpecifier": "relative",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.suggest.autoImports": true,
  "emmet.includeLanguages": {
    "typescript": "html"
  }
}
```

#### **Configuration stricte**

Assurez-vous que votre éditeur utilise la configuration TypeScript du projet :

```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true
  }
}
```

### 3. **Configuration des outils de développement**

#### **ESLint configuration**

```json
// .eslintrc.json
{
  "extends": [
    "@typescript-eslint/recommended",
    "@typescript-eslint/recommended-requiring-type-checking"
  ],
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/explicit-function-return-type": "warn"
  }
}
```

#### **Prettier configuration**

```json
// .prettierrc
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80
}
```

#### **Jest configuration**

```javascript
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src', '<rootDir>/tests'],
  testMatch: ['**/?(*.)+(spec|test).ts'],
  collectCoverageFrom: ['src/**/*.ts', '!src/**/*.d.ts'],
};
```

## 🔧 Développement

### 🚀 Démarrage rapide

```bash
# Cloner le projet
git clone https://github.com/your-username/firebase-nextjs-generator.git
cd firebase-nextjs-generator

# Installer les dépendances
npm install

# Lancer en mode développement
npm run dev

# Exécuter les tests
npm test

# Build de production
npm run build
```

### 📁 Structure du code

```
src/
├── cli.ts                    # Point d'entrée CLI
├── generator.ts              # Générateur principal
├── generators/               # Générateurs spécifiques
│   ├── firebase-generator.ts
│   └── nextjs-generator.ts
├── types/                    # Types TypeScript
│   └── index.ts
├── utils/                    # Utilitaires
│   ├── template-engine.ts
│   └── validator.ts
└── tests/                    # Tests
    ├── unit/
    ├── integration/
    └── e2e/
```

### 🧪 Tests

#### **1. Configuration des tests**

```bash
# Exécuter tous les tests
npm test

# Tests en mode watch
npm run test:watch

# Tests avec couverture
npm run test:coverage

# Tests spécifiques
npm test -- --testPathPattern=cli
```

#### **2. Structure des tests**

```typescript
// tests/unit/cli.test.ts
import { describe, it, expect } from '@jest/globals';
import { CLI } from '../../src/cli';

describe('CLI', () => {
  it('should parse valid arguments', () => {
    // Test implementation
  });
});
```

#### **3. Tests d'intégration**

```bash
# Tests d'intégration
npm run test:integration

# Tests end-to-end
npm run test:e2e
```

#### **4. Configuration de la couverture**

```json
// package.json
{
  "scripts": {
    "test:coverage": "jest --coverage --coverageThreshold='{\"global\":{\"branches\":80,\"functions\":80,\"lines\":80,\"statements\":80}}'"
  }
}
```

### 📊 Qualité du code

#### **1. Linting et formatage**

```bash
# Linting
npm run lint

# Linting avec auto-correction
npm run lint:fix

# Formatage
npm run format

# Vérification du formatage
npm run format:check
```

#### **2. Vérification des types**

```bash
# Vérification TypeScript
npm run type-check

# Build de vérification
npm run build
```

#### **3. Audit de sécurité**

```bash
# Audit npm
npm audit

# Audit avec correction automatique
npm audit fix
```

## 🤝 Contribution

### 🚀 Comment contribuer

#### **1. Types de contributions**

- 🐛 **Bug fixes** - Correction de bugs
- ✨ **Features** - Nouvelles fonctionnalités
- 📚 **Documentation** - Amélioration de la documentation
- 🧪 **Tests** - Ajout de tests
- 🔧 **Refactoring** - Amélioration du code

#### **2. Processus de contribution**

```bash
# 1. Fork du projet sur GitHub
# 2. Clone de votre fork
git clone https://github.com/votre-username/firebase-nextjs-generator.git
cd firebase-nextjs-generator

# 3. Ajouter le remote upstream
git remote add upstream https://github.com/original-username/firebase-nextjs-generator.git

# 4. Créer une branche pour votre contribution
git checkout -b feature/nouvelle-fonctionnalite
# ou
git checkout -b fix/correction-bug

# 5. Développer et tester
# ... votre code ...
npm test
npm run lint
npm run type-check

# 6. Commit avec un message conventionnel
git commit -m "feat: ajouter la fonctionnalité X"
# ou
git commit -m "fix: corriger le bug Y"

# 7. Push vers votre fork
git push origin feature/nouvelle-fonctionnalite

# 8. Créer une Pull Request sur GitHub
```

#### **3. Convention de nommage des branches**

```bash
# Fonctionnalités
feature/nom-de-la-fonctionnalite
feature/user-authentication
feature/pwa-support

# Corrections de bugs
fix/nom-du-bug
fix/firebase-connection-error
fix/template-parsing-issue

# Documentation
docs/nom-de-la-documentation
docs/api-reference
docs/installation-guide

# Refactoring
refactor/nom-du-refactoring
refactor/cli-structure
refactor/template-engine

# Tests
test/nom-du-test
test/unit-tests
test/integration-tests
```

#### **4. Messages de commit conventionnels**

```bash
# Format : type(scope): description

# Types disponibles :
feat:     # Nouvelle fonctionnalité
fix:      # Correction de bug
docs:     # Documentation
style:    # Formatage, point-virgules manquants, etc.
refactor: # Refactoring du code
test:     # Ajout de tests
chore:    # Mise à jour des tâches de build, etc.

# Exemples :
feat(cli): ajouter la commande --verbose
fix(generator): corriger l'erreur de template
docs(readme): ajouter la section installation
test(validator): ajouter des tests pour la validation
```

### 📝 Standards de code

#### **1. TypeScript**

- **Strict mode** obligatoire
- **Types explicites** pour les paramètres de fonction
- **Interfaces** pour les objets complexes
- **Generics** quand approprié
- **Union types** pour les valeurs alternatives

```typescript
// ✅ Bon
interface UserConfig {
  name: string;
  email: string;
  preferences?: UserPreferences;
}

function createUser(config: UserConfig): User {
  // Implementation
}

// ❌ Éviter
function createUser(config: any): any {
  // Implementation
}
```

#### **2. ESLint**

- **Règles strictes** activées
- **Auto-correction** quand possible
- **Règles personnalisées** documentées
- **Configuration partagée** entre tous les contributeurs

#### **3. Tests**

- **Tests unitaires** obligatoires pour toute nouvelle fonctionnalité
- **Tests d'intégration** pour les composants complexes
- **Couverture de code** minimum 80%
- **Tests end-to-end** pour les workflows critiques

#### **4. Documentation**

- **JSDoc** pour toutes les fonctions publiques
- **README** à jour avec chaque changement
- **Exemples d'utilisation** pour les nouvelles fonctionnalités
- **Changelog** maintenu

### 🚀 Processus de release

#### **1. Préparation de la release**

```bash
# 1. Vérifier que tous les tests passent
npm test
npm run test:coverage

# 2. Vérifier la qualité du code
npm run lint
npm run type-check
npm run format:check

# 3. Mettre à jour le changelog
npm run changelog

# 4. Mettre à jour la version
npm version patch|minor|major
```

#### **2. Configuration Conventional Changelog**

```json
// .versionrc
{
  "types": [
    { "type": "feat", "section": "✨ Features" },
    { "type": "fix", "section": "🐛 Bug Fixes" },
    { "type": "docs", "section": "📚 Documentation" },
    { "type": "style", "section": "🎨 Styles" },
    { "type": "refactor", "section": "🔧 Refactoring" },
    { "type": "test", "section": "🧪 Tests" },
    { "type": "chore", "section": "🚀 Chores" }
  ]
}
```

#### **3. Publication**

```bash
# 1. Build de production
npm run build

# 2. Tests de build
npm run test:build

# 3. Publication sur npm
npm publish

# 4. Création du tag Git
git push --follow-tags origin main
```

## 📄 License

Ce projet est sous licence **MIT**. Voir le fichier [LICENSE](../LICENSE) pour plus de détails.

---

**🚀 Prêt à contribuer ? Commencez par [forker le projet](https://github.com/your-username/firebase-nextjs-generator/fork) !**
