#!/bin/bash

# Script de déploiement principal
# Usage: ./scripts/deploy.sh [environment]

set -e

ENVIRONMENT=${1:-dev}
PROJECT_NAME="test-final-nextjs"

echo "🚀 Déploiement de $PROJECT_NAME en $ENVIRONMENT..."

# Vérifier l'environnement
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo "❌ Environnement invalide. Utilisez: dev, staging, ou prod"
    exit 1
fi

# Build frontend
echo "📦 Build du frontend..."
cd frontend
npm install
npm run build

# Build backend
echo "🔥 Build du backend..."
cd ../backend/functions
npm install
npm run build

# Déploiement Firebase
echo "🚀 Déploiement Firebase..."
cd ..
firebase use $ENVIRONMENT
firebase deploy

echo "✅ Déploiement terminé!"
echo "🌐 URL: https://-$ENVIRONMENT.web.app"
