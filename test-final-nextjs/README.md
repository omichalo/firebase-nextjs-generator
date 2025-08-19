# test-final-nextjs

Test final Next.js config

## 🚀 Technologies

- **Frontend**: Next.js 15 avec App Router
- **Backend**: Firebase (Firestore, Auth, Functions, Storage)
- **UI**: Material-UI (MUI)
- **State Management**: Zustand
- **TypeScript**: Strict mode activé
- **PWA**: Activé
- **FCM**: Désactivé

## 📁 Structure du Projet

```
test-final-nextjs/
├── frontend/          # Application Next.js
├── backend/           # Configuration Firebase
├── docs/             # Documentation
├── scripts/          # Scripts de déploiement
└── github/           # GitHub Actions
```

## 🛠️ Installation

1. **Cloner le projet**
   ```bash
   git clone <repository-url>
   cd test-final-nextjs
   ```

2. **Installer les dépendances**
   ```bash
   # Frontend
   cd frontend
   npm install
   
   # Backend (Cloud Functions)
   cd ../backend/functions
   npm install
   ```

3. **Configuration Firebase**
   ```bash
   firebase login
   firebase use 
   ```

4. **Variables d'environnement**
   ```bash
   # Copier le fichier d'exemple
   cp frontend/.env.local.example frontend/.env.local
   
   # Configurer les variables
   # Voir docs/environment-setup.md
   ```

## 🚀 Développement

### Frontend
```bash
cd frontend
npm run dev
```

### Backend (Emulateur Firebase)
```bash
cd backend
firebase emulators:start
```

## 📦 Déploiement

### Environnements Disponibles
- **dev**: test-project-dev

### Déploiement Frontend
```bash
cd frontend
npm run build
firebase deploy --only hosting
```

### Déploiement Backend
```bash
cd backend
firebase deploy --only functions,firestore
```

## 🧪 Tests

```bash
# Tests frontend
cd frontend
npm run test

# Tests backend
cd backend/functions
npm run test
```

## 📚 Documentation

- [Guide de développement](docs/development.md)
- [Guide de déploiement](docs/deployment.md)
- [Configuration des environnements](docs/environment-setup.md)
- [Architecture](docs/architecture.md)

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Auteurs

Test

---

Généré avec ❤️ par Firebase Next.js Generator
