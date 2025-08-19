#!/bin/bash

# Script de déploiement Firebase
# Usage: ./deploy.sh [environment]

set -e

ENVIRONMENT=${1:-dev}

echo "🚀 Déploiement vers l'environnement: $ENVIRONMENT"

# Vérifier que Firebase CLI est installé
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI n'est pas installé"
    exit 1
fi

# Vérifier que l'utilisateur est connecté
if ! firebase projects:list &> /dev/null; then
    echo "❌ Vous devez être connecté à Firebase"
    firebase login
fi

# Basculer vers l'environnement
echo "📍 Basculement vers l'environnement: $ENVIRONMENT"
firebase use $ENVIRONMENT

# Build du frontend
echo "🏗️  Build du frontend..."
cd frontend
npm run build
cd ..

# Déploiement
echo "🚀 Déploiement en cours..."
firebase deploy

echo "✅ Déploiement terminé avec succès !" 