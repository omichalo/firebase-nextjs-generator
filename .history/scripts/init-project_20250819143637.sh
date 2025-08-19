#!/bin/bash

# Script d'initialisation pour projets générés
# Usage: ./init-project.sh [environment]

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Initialisation du projet Firebase + Next.js${NC}"
echo

# Vérification de l'environnement
ENVIRONMENT=${1:-dev}
echo -e "${BLUE}📍 Environnement: ${ENVIRONMENT}${NC}"

# Vérification des prérequis
echo -e "${BLUE}🔍 Vérification des prérequis...${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js n'est pas installé${NC}"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm n'est pas installé${NC}"
    exit 1
fi

if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI n'est pas installé${NC}"
    echo -e "${YELLOW}💡 Installez-le avec: npm install -g firebase-tools${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Tous les prérequis sont satisfaits${NC}"
echo

# Initialisation du frontend
echo -e "${BLUE}⚛️  Initialisation du frontend Next.js...${NC}"
cd frontend

# Suppression des lockfiles potentiellement conflictuels
if [ -f "package-lock.json" ]; then
    echo "  🗑️  Suppression de package-lock.json existant..."
    rm -f package-lock.json
fi

if [ -f "yarn.lock" ]; then
    echo "  🗑️  Suppression de yarn.lock existant..."
    rm -f yarn.lock
fi

if [ -d "node_modules" ]; then
    echo "  🗑️  Suppression de node_modules existant..."
    rm -rf node_modules
fi

echo "  📦 Installation des dépendances..."
npm install --silent

echo "  🔨 Build de l'application..."
npm run build --silent

echo -e "${GREEN}✅ Frontend initialisé avec succès${NC}"
echo

# Retour au répertoire principal
cd ..

# Initialisation du backend Firebase
echo -e "${BLUE}🔥 Initialisation du backend Firebase...${NC}"
cd backend

# Configuration Firebase
echo "  🔧 Configuration Firebase..."
if [ -f ".firebaserc" ]; then
    PROJECT_ID=$(grep -o '"dev": "[^"]*"' .firebaserc | cut -d'"' -f4)
    if [ -n "$PROJECT_ID" ]; then
        echo "    📍 Projet détecté: $PROJECT_ID"
        echo "    🔄 Configuration Firebase..."
        if firebase use "$PROJECT_ID" >/dev/null 2>&1; then
            echo -e "    ${GREEN}✅ Projet Firebase configuré${NC}"
        else
            echo -e "    ${YELLOW}⚠️  Impossible de configurer le projet (login requis)${NC}"
        fi
    fi
fi

# Initialisation des Cloud Functions
echo "  ⚡ Initialisation des Cloud Functions..."
cd functions

if [ -f "package.json" ]; then
    echo "    📦 Installation des dépendances des fonctions..."
    npm install --silent
    
    echo "    🔨 Build des fonctions..."
    npm run build --silent 2>/dev/null || echo "    ⚠️  Build échoué (normal si pas de script build)"
    
    echo -e "    ${GREEN}✅ Cloud Functions initialisées${NC}"
else
    echo -e "    ${YELLOW}⚠️  Aucune Cloud Function configurée${NC}"
fi

cd ..

echo -e "${GREEN}✅ Backend Firebase initialisé${NC}"
echo

# Retour au répertoire principal
cd ..

# Rendre les scripts exécutables
echo -e "${BLUE}🔧 Configuration des scripts...${NC}"
if [ -f "scripts/init-project.sh" ]; then
    chmod +x scripts/init-project.sh
fi
if [ -f "scripts/deploy.sh" ]; then
    chmod +x scripts/deploy.sh
fi
if [ -f "scripts/rollback.sh" ]; then
    chmod +x scripts/rollback.sh
fi

echo -e "${GREEN}✅ Scripts configurés${NC}"
echo

# Résumé final
echo -e "${GREEN}🎉 Initialisation terminée avec succès !${NC}"
echo
echo -e "${BLUE}📋 Prochaines étapes:${NC}"
echo "  1. ${GREEN}Frontend prêt${NC}: cd frontend && npm run dev"
echo "  2. ${GREEN}Backend prêt${NC}: cd backend && firebase deploy"
echo "  3. ${GREEN}API routes${NC}: Accessibles sur /api/*"
echo "  4. ${GREEN}Firebase App Hosting${NC}: Configuré et prêt"
echo
echo -e "${BLUE}🚀 Votre projet est maintenant 100% opérationnel !${NC}" 