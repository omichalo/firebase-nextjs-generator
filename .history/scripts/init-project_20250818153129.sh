#!/bin/bash

# Script d'initialisation automatique du projet
# Usage: ./init-project.sh [environment]

set -e

ENVIRONMENT=${1:-dev}

echo "🚀 Initialisation automatique du projet..."
echo "📍 Environnement: $ENVIRONMENT"

# Vérifier que Firebase CLI est installé
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI n'est pas installé"
    echo "💡 Installez-le avec: npm install -g firebase-tools"
    exit 1
fi

# Vérifier que l'utilisateur est connecté
if ! firebase projects:list &> /dev/null; then
    echo "🔐 Connexion à Firebase..."
    firebase login
fi

# Basculer vers l'environnement
echo "📍 Basculement vers l'environnement: $ENVIRONMENT"
firebase use $ENVIRONMENT

# Installer les dépendances du frontend
echo "📦 Installation des dépendances frontend..."
cd frontend
npm install --legacy-peer-deps
cd ..

# Installer les dépendances du backend
echo "📦 Installation des dépendances backend..."
cd backend/functions
npm install --legacy-peer-deps
cd ../..

echo "✅ Initialisation terminée avec succès !"
echo "🚀 Pour démarrer le projet:"
echo "   Frontend: cd frontend && npm run dev"
echo "   Backend: cd backend && firebase emulators:start" 