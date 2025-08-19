# 📦 Guide d'installation détaillé

> **Installation complète et configuration du Générateur Firebase + Next.js 2025**

## 🎯 Vue d'ensemble

Ce guide vous accompagne étape par étape dans l'installation et la configuration du générateur, depuis les prérequis jusqu'à la première utilisation.

## 📋 Prérequis système

### 🖥️ Système d'exploitation

- **macOS** : 10.15 (Catalina) ou supérieur
- **Windows** : 10 ou supérieur
- **Linux** : Ubuntu 18.04+, CentOS 7+, ou distribution équivalente

### 💻 Matériel recommandé

- **RAM** : 8 GB minimum, 16 GB recommandé
- **Stockage** : 2 GB d'espace libre
- **Processeur** : Intel i5/AMD Ryzen 5 ou supérieur

## 🔧 Installation des outils

### 1. Node.js et npm

#### Vérification de l'installation

```bash
node --version
npm --version
```

**Versions requises :**

- Node.js : 18.0.0 ou supérieur
- npm : 9.0.0 ou supérieur

#### Installation sur macOS

```bash
# Avec Homebrew (recommandé)
brew install node

# Avec nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18
```

#### Installation sur Windows

```bash
# Télécharger depuis nodejs.org
# Ou avec Chocolatey
choco install nodejs

# Ou avec winget
winget install OpenJS.NodeJS
```

#### Installation sur Linux

```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# CentOS/RHEL
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs
```

### 2. Firebase CLI

#### Installation globale

```bash
npm install -g firebase-tools
```

#### Vérification de l'installation

```bash
firebase --version
```

**Version requise :** 13.0.0 ou supérieur

#### Connexion à Firebase

```bash
firebase login
```

Suivez les instructions pour vous connecter avec votre compte Google.

### 3. Git

#### Vérification de l'installation

```bash
git --version
```

#### Configuration Git

```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@example.com"
```

## 🚀 Installation du générateur

### Option 1 : Installation globale (recommandée)

```bash
npm install -g firebase-nextjs-generator
```

**Avantages :**

- Accessible depuis n'importe où
- Mise à jour facile
- Installation unique

**Inconvénients :**

- Permissions globales requises
- Peut entrer en conflit avec d'autres projets

### Option 2 : Installation locale

```bash
# Cloner le repository
git clone https://github.com/your-username/firebase-nextjs-generator.git
cd firebase-nextjs-generator

# Installer les dépendances
npm install

# Construire le projet
npm run build

# Lier globalement (optionnel)
npm link
```

### Option 3 : Installation avec npx

```bash
npx firebase-nextjs-generator create
```

**Avantages :**

- Pas d'installation permanente
- Toujours la dernière version
- Pas de conflits

**Inconvénients :**

- Téléchargement à chaque utilisation
- Dépend de la connexion internet

## ⚙️ Configuration initiale

### 1. Vérification de l'installation

```bash
# Vérifier que le générateur est installé
firebase-nextjs-generator --version

# Ou avec npx
npx firebase-nextjs-generator --version
```

### 2. Configuration des variables d'environnement

Créez un fichier `.env` à la racine de votre projet :

```bash
# .env
NODE_ENV=development
FIREBASE_DEFAULT_REGION=us-central1
NEXTJS_DEFAULT_VERSION=15.0.0
REACT_DEFAULT_VERSION=19.0.0
```

### 3. Configuration des préférences utilisateur

```bash
# Créer le fichier de configuration
mkdir -p ~/.config/firebase-nextjs-generator
touch ~/.config/firebase-nextjs-generator/config.json
```

```json
{
  "defaults": {
    "ui": "mui",
    "stateManagement": "zustand",
    "features": {
      "pwa": true,
      "fcm": true,
      "analytics": true,
      "performance": true,
      "sentry": true
    },
    "firebase": {
      "region": "us-central1",
      "extensions": []
    }
  },
  "paths": {
    "templates": "./templates",
    "output": "./output"
  }
}
```

## 🔐 Configuration Firebase

### 1. Création d'un projet Firebase

```bash
# Créer un nouveau projet
firebase projects:create my-awesome-project

# Ou utiliser un projet existant
firebase use --add my-existing-project
```

### 2. Configuration des services

```bash
# Initialiser Firebase dans votre projet
firebase init

# Sélectionner les services nécessaires :
# - Hosting
# - Functions
# - Firestore
# - Storage
# - Emulators
```

### 3. Configuration des régions

```bash
# Vérifier les régions disponibles
firebase functions:config:get

# Configurer la région par défaut
firebase functions:config:set region=us-central1
```

## 🧪 Vérification de l'installation

### 1. Test de base

```bash
# Tester la commande d'aide
firebase-nextjs-generator --help

# Tester la création d'un projet de test
firebase-nextjs-generator create --name test-project --template minimal
```

### 2. Test des fonctionnalités

```bash
# Vérifier la génération Next.js
cd test-project/frontend
npm install
npm run dev

# Vérifier la configuration Firebase
cd ../backend
firebase emulators:start
```

### 3. Test des templates

```bash
# Vérifier que tous les templates sont présents
ls -la templates/nextjs/
ls -la templates/firebase/

# Vérifier la validité des templates Handlebars
npm run validate-templates
```

## 🚨 Résolution des problèmes

### Erreurs courantes

#### 1. Permission denied

```bash
# Sur macOS/Linux
sudo npm install -g firebase-nextjs-generator

# Ou utiliser nvm pour éviter les permissions
nvm use 18
npm install -g firebase-nextjs-generator
```

#### 2. Firebase CLI non trouvé

```bash
# Réinstaller Firebase CLI
npm uninstall -g firebase-tools
npm install -g firebase-tools

# Vérifier le PATH
echo $PATH
which firebase
```

#### 3. Erreurs de dépendances

```bash
# Nettoyer le cache npm
npm cache clean --force

# Supprimer node_modules et réinstaller
rm -rf node_modules package-lock.json
npm install
```

#### 4. Erreurs de templates

```bash
# Vérifier la structure des templates
npm run validate-templates

# Régénérer les templates
npm run generate-templates
```

### Logs et débogage

```bash
# Activer le mode verbose
firebase-nextjs-generator create --verbose

# Vérifier les logs
tail -f ~/.firebase-nextjs-generator/logs/app.log

# Mode debug
DEBUG=* firebase-nextjs-generator create
```

## 🔄 Mise à jour

### Mise à jour du générateur

```bash
# Mise à jour globale
npm update -g firebase-nextjs-generator

# Ou réinstaller
npm uninstall -g firebase-nextjs-generator
npm install -g firebase-nextjs-generator
```

### Mise à jour des dépendances

```bash
# Vérifier les mises à jour disponibles
npm outdated

# Mettre à jour les dépendances
npm update

# Mettre à jour vers les dernières versions
npm install -g firebase-nextjs-generator@latest
```

## 📚 Ressources supplémentaires

### Documentation officielle

- [Node.js Documentation](https://nodejs.org/docs/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Next.js Documentation](https://nextjs.org/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

### Communauté et support

- [GitHub Issues](https://github.com/your-username/firebase-nextjs-generator/issues)
- [Discord Community](https://discord.gg/your-community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/firebase-nextjs-generator)

### Outils de développement

- [VS Code](https://code.visualstudio.com/) - Éditeur recommandé
- [Firebase Console](https://console.firebase.google.com/) - Gestion Firebase
- [Vercel Dashboard](https://vercel.com/dashboard) - Déploiement Next.js

## ✅ Checklist d'installation

- [ ] Node.js 18+ installé
- [ ] npm 9+ installé
- [ ] Firebase CLI installé et connecté
- [ ] Git configuré
- [ ] Générateur installé
- [ ] Configuration initiale effectuée
- [ ] Projet Firebase créé
- [ ] Tests de base réussis
- [ ] Templates validés

## 🎉 Félicitations !

Vous avez maintenant un environnement de développement complet et fonctionnel pour créer des applications Firebase + Next.js modernes !

## 📚 Documentation complète

**Prochaines étapes :**

- **[🎯 Guide d'utilisation](USAGE.md)** - Maîtrisez le générateur de A à Z
- **[🚀 Guide de déploiement](DEPLOYMENT.md)** - Déployez votre application
- **[🔧 Guide de personnalisation](CUSTOMIZATION.md)** - Personnalisez selon vos besoins
- **[📚 Bonnes pratiques](BEST_PRACTICES.md)** - Standards et recommandations
- **[🤝 Guide de contribution](CONTRIBUTING.md)** - Contribuez au projet
- **[🔄 Guide de maintenance](MAINTENANCE.md)** - Maintenez et évoluez
- **[💡 Exemples d'utilisation](EXAMPLES.md)** - Exemples concrets

---

**🚀 [Commencer avec le guide d'utilisation →](USAGE.md)**
