#!/bin/bash

# Script de rollback pour test-performance
# Usage: ./scripts/rollback.sh [environment] [version]

set -e

ENVIRONMENT=${1:-dev}
VERSION=${2:-latest}
PROJECT_NAME="test-performance"

echo "🔄 Rollback de $PROJECT_NAME en $ENVIRONMENT vers la version $VERSION..."

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

# Rollback des fonctions
echo "🔄 Rollback des Cloud Functions..."
firebase functions:rollback --version $VERSION

# Rollback du hosting
echo "🔄 Rollback du hosting..."
firebase hosting:clone $ENVIRONMENT:live:$VERSION $ENVIRONMENT:live

echo "✅ Rollback terminé avec succès!"
echo "🌐 Application restaurée à la version $VERSION" 