#!/bin/bash

# Script de publication pour GitHub et npm
# Usage: ./publish.sh [patch|minor|major]

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Orchestrateur de publication Firebase Next.js Generator (Beta)${NC}"
echo

# Vérification des prérequis
echo -e "${BLUE}🔍 Vérification des prérequis...${NC}"

if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git n'est pas installé${NC}"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm n'est pas installé${NC}"
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js n'est pas installé${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Tous les prérequis sont satisfaits${NC}"
echo

# Vérification du statut Git
echo -e "${BLUE}🔍 Vérification du statut Git...${NC}"

if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️  Il y a des modifications non commitées${NC}"
    git status --short
    echo
    read -p "Voulez-vous continuer ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}❌ Publication annulée${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Aucune modification non commitée${NC}"
fi

# Vérification de la branche (main/master uniquement)
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    echo -e "${RED}❌ ERREUR: Vous devez être sur la branche main/master pour publier${NC}"
    echo -e "${YELLOW}💡 Créez d'abord une Pull Request depuis $CURRENT_BRANCH vers main${NC}"
    echo -e "${BLUE}📋 Processus recommandé:${NC}"
    echo "  1. git push origin $CURRENT_BRANCH"
    echo "  2. Créer une Pull Request sur GitHub"
    echo "  3. Attendre l'approbation et le merge"
    echo "  4. git checkout main && git pull origin main"
    echo "  5. ./publish.sh"
    exit 1
fi

echo -e "${GREEN}✅ Branche vérifiée: $CURRENT_BRANCH${NC}"
echo

# Vérification qu'il n'y a pas de PR en cours
echo -e "${BLUE}🔍 Vérification des Pull Requests...${NC}"
if command -v gh &> /dev/null; then
    OPEN_PR_COUNT=$(gh pr list --state open --base main --json number --jq length 2>/dev/null || echo "0")
    if [ "$OPEN_PR_COUNT" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Il y a $OPEN_PR_COUNT Pull Request(s) ouverte(s) vers main${NC}"
        echo -e "${BLUE}📋 Voulez-vous les consulter avant de continuer ?${NC}"
        read -p "Afficher les PR ? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            gh pr list --state open --base main
        fi
        echo
        read -p "Continuer malgré les PR ouvertes ? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${RED}❌ Publication annulée${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✅ Aucune Pull Request ouverte vers main${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  GitHub CLI (gh) non installé - impossible de vérifier les PR${NC}"
    echo -e "${BLUE}💡 Installez GitHub CLI: brew install gh (Mac) ou apt install gh (Ubuntu)${NC}"
    echo -e "${YELLOW}⚠️  Vérifiez manuellement qu'il n'y a pas de PR en cours${NC}"
    read -p "Continuer ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}❌ Publication annulée${NC}"
        exit 1
    fi
fi
echo

# Type de version
VERSION_TYPE=${1:-patch}
if [[ ! "$VERSION_TYPE" =~ ^(patch|minor|major)$ ]]; then
    echo -e "${RED}❌ Type de version invalide. Utilisez: patch, minor, ou major${NC}"
    exit 1
fi

echo -e "${BLUE}📦 Type de version: ${VERSION_TYPE}${NC}"
echo

# Vérification rapide (optionnelle)
echo -e "${BLUE}🔍 Vérification rapide...${NC}"
echo -e "${YELLOW}⚠️  Tests et build seront exécutés automatiquement par GitHub Actions${NC}"
echo -e "${GREEN}✅ Vérification locale ignorée${NC}"
echo

# Mise à jour de la version
echo -e "${BLUE}📈 Mise à jour de la version...${NC}"
OLD_VERSION=$(npm version --json | grep '"version"' | cut -d'"' -f4)
npm version $VERSION_TYPE --no-git-tag-version
NEW_VERSION=$(npm version --json | grep '"version"' | cut -d'"' -f4)
echo -e "${GREEN}✅ Version mise à jour: $OLD_VERSION → $NEW_VERSION${NC}"
echo

# Commit des changements
echo -e "${BLUE}💾 Commit des changements...${NC}"
git add package.json package-lock.json
git commit -m "chore: bump version to $NEW_VERSION"
echo -e "${GREEN}✅ Changements commités${NC}"
echo

# Tag de version
echo -e "${BLUE}🏷️  Création du tag de version...${NC}"
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"
echo -e "${GREEN}✅ Tag v$NEW_VERSION créé${NC}"
echo

# Push vers GitHub
echo -e "${BLUE}🚀 Push vers GitHub...${NC}"
git push origin $CURRENT_BRANCH
git push origin "v$NEW_VERSION"
echo -e "${GREEN}✅ Code et tags poussés vers GitHub${NC}"
echo

# Publication automatique via GitHub Actions
echo -e "${BLUE}📤 Publication automatique...${NC}"
echo -e "${GREEN}✅ La publication npm sera gérée automatiquement par GitHub Actions${NC}"
echo -e "${BLUE}🌐 Surveillez l'onglet Actions pour suivre le processus${NC}"
echo

# Nettoyage (plus nécessaire)
echo -e "${BLUE}🧹 Nettoyage...${NC}"
echo -e "${GREEN}✅ Aucun fichier temporaire à nettoyer${NC}"
echo

# Résumé final
echo -e "${GREEN}🎉 Orchestration terminée avec succès !${NC}"
echo
echo -e "${BLUE}📋 Résumé:${NC}"
echo "  📦 Version: $NEW_VERSION"
echo "  🏷️  Tag: v$NEW_VERSION"
echo "  🌐 GitHub: Poussé avec succès"
echo "  📤 npm: Publication automatique en cours via GitHub Actions"
echo
echo -e "${BLUE}🚀 Prochaines étapes:${NC}"
echo "  1. Vérifier le tag sur GitHub"
echo "  2. Surveiller l'onglet Actions pour la publication npm"
echo "  3. Créer une release GitHub manuellement si nécessaire"
echo "  4. Tester l'installation: npm install -g firebase-nextjs-generator"
echo
echo -e "${GREEN}🎯 Votre générateur sera publié automatiquement !${NC}" 