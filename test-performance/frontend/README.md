# test-performance

Test performance

## 🚀 Démarrage rapide

### Prérequis

- Node.js  ou supérieur
- npm, Yarn ou pnpm
- Compte Firebase

### Installation

1. **Cloner le projet**
   ```bash
   git clone <repository-url>
   cd test-performance
   ```

2. **Installer les dépendances frontend**
   ```bash
   cd frontend
   npm install
   ```

3. **Configurer Firebase**
   ```bash
   cd ../backend
   firebase login
   firebase use dev  # ou l'environnement de votre choix
   ```

4. **Lancer l'application**
   ```bash
   cd ../frontend
   npm run dev
   ```

## 🏗️ Architecture

Ce projet utilise une architecture **frontend/backend** séparée :

```
test-performance/
├── frontend/          # Application Next.js 15
├── backend/           # Configuration Firebase
└── scripts/           # Scripts d'automatisation
```

### Frontend (Next.js 15)

- **Framework**: Next.js 15 avec App Router
- **UI**: mui
- **State Management**: zustand
- **Styling**: CSS Modules

### Backend (Firebase)

- **Authentication**: Firebase Auth
- **Database**: Firestore
- **Storage**: Firebase Storage
- **Functions**: Cloud Functions
- **Hosting**: Firebase Hosting

## 🔧 Configuration

### Environnements Firebase

- **dev**: test-project-dev (us-central1)

### Variables d'environnement

Créez un fichier `.env.local` dans le dossier `frontend/` :

```env
NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_auth_domain
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_storage_bucket
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
NEXT_PUBLIC_FIREBASE_APP_ID=your_app_id
```

## 📱 Fonctionnalités

- ✅ **PWA** - Progressive Web App

## 🧪 Tests

```bash
# Tests unitaires
npm run test

# Tests E2E
npm run test:e2e

# Couverture des tests
npm run test:coverage
```

## 🚀 Déploiement

### Déploiement automatique

```bash
# Déploiement en développement
./scripts/deploy-env.sh dev

# Déploiement en production
./scripts/deploy-env.sh prod
```

### Déploiement manuel

```bash
# Build de l'application
npm run build

# Déploiement Firebase
firebase deploy
```

## 📚 Documentation

- [Next.js Documentation](https://nextjs.org/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Material-UI Documentation](https://mui.com/material-ui/getting-started/)

## 🤝 Contribution

1. Fork le projet
2. Créez une branche feature (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Auteurs

- **Test** - *Développement initial*

## 🙏 Remerciements

- [Next.js](https://nextjs.org/) - Framework React
- [Firebase](https://firebase.google.com/) - Plateforme backend
- [Material-UI](https://mui.com/) - Composants UI
- [Vercel](https://vercel.com/) - Déploiement et hosting 