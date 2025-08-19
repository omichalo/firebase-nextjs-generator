#!/bin/bash

# Script d'initialisation automatique
# Usage: ./scripts/init-project.sh [environment]
# Exemple: ./scripts/init-project.sh dev

set -e

ENVIRONMENT=${1:-dev}
PROJECT_NAME="test-final-nextjs"

echo "🚀 Initialisation automatique de $PROJECT_NAME en $ENVIRONMENT..."

# Vérifier l'environnement
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo "❌ Environnement invalide. Utilisez: dev, staging, ou prod"
    exit 1
fi

# Installer les dépendances frontend
echo "📦 Installation des dépendances frontend..."
cd frontend
npm install

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
echo "⚙️ Configuration de l'environnement $ENVIRONMENT..."
cd ../backend
firebase use $ENVIRONMENT

# Lancer l'application
echo "🚀 Lancement de l'application..."
cd ../frontend
npm run dev

echo "✅ Initialisation terminée!"
echo "🌐 Application disponible sur: http://localhost:3000"
