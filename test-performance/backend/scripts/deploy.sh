#!/bin/bash

# Script de déploiement principal pour test-performance
# Usage: ./scripts/deploy.sh [environment]

set -e

ENVIRONMENT=${1:-dev}
PROJECT_NAME="test-performance"

echo "🚀 Déploiement de $PROJECT_NAME en $ENVIRONMENT..."

# Vérifier que Firebase CLI est installé
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI non installé. Installez-le avec: npm install -g firebase-tools"
    exit 1
fi

# Vérifier que l'utilisateur est connecté
if ! firebase projects:list &> /dev/null; then
    echo "❌ Utilisateur Firebase non connecté. Connectez-vous avec: firebase login"
    exit 1
fi

echo "✅ Vérifications terminées"

# Basculer vers l'environnement
echo "🔄 Basculement vers l'environnement $ENVIRONMENT..."
firebase use $ENVIRONMENT

# Build frontend
echo "📦 Build du frontend..."
cd frontend
npm install
npm run build
cd ..

# Build backend
echo "🔥 Build du backend..."
cd backend/functions
npm install
npm run build
cd ../..

# Déploiement Firebase
echo "🚀 Déploiement Firebase..."
firebase deploy --only hosting,functions,firestore:rules,storage

echo "✅ Déploiement en $ENVIRONMENT terminé avec succès!"
echo "🌐 URL: https://$(firebase use --json | jq -r '.current')" 