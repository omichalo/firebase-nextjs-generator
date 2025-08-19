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

echo -e "${BLUE}🚀 Script de publication Firebase Next.js Generator (Beta)${NC}"
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

# Vérification de la branche
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    echo -e "${YELLOW}⚠️  Vous n'êtes pas sur la branche main/master (actuellement sur $CURRENT_BRANCH)${NC}"
    read -p "Voulez-vous continuer ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}❌ Publication annulée${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Branche vérifiée${NC}"
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

# Publication sur npm
echo -e "${BLUE}📤 Publication sur npm...${NC}"
read -p "Voulez-vous publier sur npm ? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if npm publish; then
        echo -e "${GREEN}✅ Package publié sur npm avec succès !${NC}"
        echo -e "${BLUE}🌐 URL: https://www.npmjs.com/package/firebase-nextjs-generator${NC}"
    else
        echo -e "${RED}❌ Échec de la publication sur npm${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  Publication npm annulée${NC}"
fi
echo

# Nettoyage
echo -e "${BLUE}🧹 Nettoyage...${NC}"
rm -f firebase-nextjs-generator-*.tgz
echo -e "${GREEN}✅ Nettoyage terminé${NC}"
echo

# Résumé final
echo -e "${GREEN}🎉 Publication terminée avec succès !${NC}"
echo
echo -e "${BLUE}📋 Résumé:${NC}"
echo "  📦 Version: $NEW_VERSION"
echo "  🏷️  Tag: v$NEW_VERSION"
echo "  🌐 GitHub: Poussé avec succès"
echo "  📤 npm: $([ -n "$PACKAGE_FILE" ] && echo "Publié" || echo "Non publié")"
echo
echo -e "${BLUE}🚀 Prochaines étapes:${NC}"
echo "  1. Vérifier le tag sur GitHub"
echo "  2. Créer une release GitHub si nécessaire"
echo "  3. Vérifier la publication npm"
echo "  4. Tester l'installation: npm install -g firebase-nextjs-generator"
echo
echo -e "${GREEN}🎯 Votre générateur est maintenant public !${NC}" 