# Guide de Développement

## 🛠️ Configuration de l'Environnement

### Prérequis
- Node.js 18+
- npm
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
- **UI Components**: Material-UI
- **State Management**: Zustand

### Backend (Firebase)
- **Firestore**: Base de données NoSQL
- **Cloud Functions**: Logique métier
- **Authentication**: Gestion des utilisateurs
- **Storage**: Fichiers et médias

## 🔧 Scripts Disponibles

### Frontend
```bash
npm run dev      # Développement
npm run build    # Production build
npm run start    # Production serveur
npm run test     # Tests
npm run lint     # Linting
```

### Backend
```bash
npm run build    # Build des fonctions
npm run test     # Tests
npm run deploy   # Déploiement
```

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
- Pas de `any` sauf cas exceptionnel

### React/Next.js
- Fonctions composants avec hooks
- Props typées avec TypeScript
- Hooks personnalisés pour la logique

### Firebase
- Règles de sécurité strictes
- Index optimisés
- Fonctions modulaires
