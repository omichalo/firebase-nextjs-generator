# 🚀 Guide de Démarrage Rapide - Firebase Next.js Generator

## ⚡ Installation en 5 minutes

### 1. **Prérequis**

```bash
# Node.js 18+ et npm
node --version  # Doit être >= 18
npm --version   # Doit être >= 8

# Firebase CLI
npm install -g firebase-tools
firebase login
```

### 2. **Génération du projet**

```bash
# Cloner le générateur
git clone <votre-repo>
cd base-react-firebase-project

# Générer un projet
npx ts-node src/cli.ts create \
  --name "mon-projet" \
  --description "Mon application Firebase + Next.js" \
  --author "Votre Nom" \
  --package-manager npm \
  --nextjs-version 15 \
  --ui mui \
  --state-management zustand \
  --features pwa,analytics,performance,sentry \
  --output ./mon-projet \
  --yes
```

### 3. **Initialisation automatique**

```bash
cd mon-projet
chmod +x scripts/init-project.sh
./scripts/init-project.sh dev
```

### 4. **Démarrage**

```bash
# Frontend (développement)
cd frontend
npm run dev

# Backend (déploiement)
cd ../backend
firebase deploy
```

## 🎯 **Fonctionnalités incluses**

### ✅ **Frontend Next.js 15**

- App Router avec API routes
- Material-UI (MUI) components
- Zustand state management
- TypeScript strict mode
- PWA avec Service Worker
- FCM pour notifications push
- Analytics Firebase
- Performance monitoring
- Error tracking Sentry

### ✅ **Backend Firebase**

- Cloud Functions Node.js 20
- Firestore avec règles de sécurité
- Storage avec règles de sécurité
- Authentication
- Extensions Firebase
- Firebase App Hosting

## 🔧 **Configuration Firebase**

### **1. Projet Firebase**

```bash
cd backend
firebase use [votre-projet-id]
```

### **2. Variables d'environnement**

```bash
# frontend/.env.local
NEXT_PUBLIC_FIREBASE_API_KEY=votre_api_key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=votre_projet.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=votre_projet_id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=votre_projet.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=votre_sender_id
NEXT_PUBLIC_FIREBASE_APP_ID=votre_app_id
```

## 🚀 **Déploiement**

### **Déploiement complet**

```bash
cd backend
firebase deploy
```

### **Déploiement sélectif**

```bash
# App Hosting uniquement
firebase deploy --only hosting

# Cloud Functions uniquement
firebase deploy --only functions

# Firestore uniquement
firebase deploy --only firestore
```

## 📱 **API Routes**

Vos API routes sont accessibles sur `/api/*` :

- **`/api/auth/login`** - Authentification
- **`/api/health`** - Health check
- **`/api/*`** - Routes personnalisées

## 🧪 **Tests**

### **Tests complets**

```bash
# Depuis le répertoire du générateur
./scripts/test.sh
```

### **Tests de déploiement**

```bash
# Validation des règles Firebase
firebase deploy --dry-run --only firestore:rules
firebase deploy --dry-run --only storage:rules
```

## 🔍 **Troubleshooting**

### **Problème de dépendances**

```bash
cd frontend
rm -rf node_modules package-lock.json
npm install
```

### **Problème de build**

```bash
cd frontend
npm run build
# Vérifiez les erreurs TypeScript
```

### **Problème Firebase**

```bash
cd backend
firebase login
firebase use [projet-id]
firebase deploy --dry-run
```

## 📚 **Documentation complète**

- [Installation détaillée](INSTALLATION.md)
- [Personnalisation](CUSTOMIZATION.md)
- [Déploiement](DEPLOYMENT.md)
- [Maintenance](MAINTENANCE.md)

## 🆘 **Support**

- **Issues** : GitHub Issues
- **Documentation** : `/docs/`
- **Tests** : `./scripts/test.sh`

---

**🎉 Votre projet est maintenant prêt pour la production !**
