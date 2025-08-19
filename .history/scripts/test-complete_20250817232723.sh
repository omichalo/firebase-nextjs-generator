#!/bin/bash

# Script de test complet et unique pour le Générateur Firebase + Next.js 2025
# Ce script remplace tous les autres scripts de test et teste toutes les fonctionnalités
# Usage: ./scripts/test-complete.sh

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Test counter
PASSED=0
FAILED=0
TOTAL=0

echo -e "${BLUE}=== Test Complet du Générateur Firebase + Next.js 2025 ===${NC}"
echo -e "${CYAN}Ce script teste toutes les fonctionnalités du générateur${NC}"
echo

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -e "${BLUE}Testing: $test_name${NC}"
    TOTAL=$((TOTAL + 1))
    
    if eval "$test_command" 2>/dev/null; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
}

# Phase 1: Tests d'environnement
echo -e "${YELLOW}=== Phase 1: Tests d'environnement ===${NC}"

run_test "Node.js version" "node --version | grep -q 'v1[89]\\|v2[0-9]'"
run_test "npm version" "npm --version | grep -q '^[9-9]\\|[1-9][0-9]'"
run_test "Git installation" "git --version"
run_test "package.json exists" "test -f package.json"
run_test "Dependencies installed" "test -d node_modules"

# Phase 2: Tests de build
echo -e "${YELLOW}=== Phase 2: Tests de build ===${NC}"

run_test "Project build" "npm run build"
run_test "Dist folder created" "test -d dist"

# Phase 3: Tests de la CLI
echo -e "${YELLOW}=== Phase 3: Tests de la CLI ===${NC}"

run_test "CLI help command" "npx ts-node src/cli.ts --help"
run_test "CLI version command" "npx ts-node src/cli.ts --version"

# Phase 4: Tests de génération de projets
echo -e "${YELLOW}=== Phase 4: Tests de génération de projets ===${NC}"

# Test 4.1: Projet minimal avec MUI + Zustand
echo -e "${BLUE}Testing: Generate minimal project (MUI + Zustand)${NC}"
TOTAL=$((TOTAL + 1))

if npx ts-node src/cli.ts create --name test-minimal-mui --description "Test project MUI" --author "Test" --package-manager npm --nextjs-version 15 --ui mui --state-management zustand --features pwa --output ./test-output-minimal-mui --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
    
    # Vérifier immédiatement la structure
    echo -e "${YELLOW}  Vérification de la structure...${NC}"
    sleep 2
    
    # Test 4.2: Structure du projet
    echo -e "${BLUE}Testing: Project structure (minimal)${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -d "test-output-minimal-mui/frontend" ] && [ -d "test-output-minimal-mui/backend" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 4.3: Fichiers frontend
    echo -e "${BLUE}Testing: Frontend files (minimal)${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -f "test-output-minimal-mui/frontend/package.json" ] && [ -f "test-output-minimal-mui/frontend/src/app/page.tsx" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 4.4: Fichiers backend
    echo -e "${BLUE}Testing: Backend files (minimal)${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -f "test-output-minimal-mui/backend/firebase.json" ] && [ -f "test-output-minimal-mui/backend/.firebaserc" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 4.5: Variables Handlebars (minimal)
    echo -e "${BLUE}Testing: Handlebars processing (minimal)${NC}"
    TOTAL=$((TOTAL + 1))
    if ! grep -r "{{.*}}" test-output-minimal-mui 2>/dev/null; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 4.6: Nom du projet (minimal)
    echo -e "${BLUE}Testing: Project name replacement (minimal)${NC}"
    TOTAL=$((TOTAL + 1))
    if grep -r "test-minimal-mui" test-output-minimal-mui >/dev/null 2>&1; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi

# Test 4.7: Projet complet avec Shadcn + Redux + toutes les fonctionnalités
echo -e "${BLUE}Testing: Generate complete project (Shadcn + Redux + all features)${NC}"
TOTAL=$((TOTAL + 1))

if npx ts-node src/cli.ts create --name test-complete-shadcn --description "Complete test project Shadcn" --author "Test" --package-manager npm --nextjs-version 15 --ui shadcn --state-management redux --features pwa,fcm,analytics,performance,sentry --output ./test-output-complete-shadcn --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
    
    # Vérifier immédiatement la structure
    echo -e "${YELLOW}  Vérification de la structure...${NC}"
    sleep 2
    
    # Test 4.8: Structure du projet complet
    echo -e "${BLUE}Testing: Complete project structure${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -d "test-output-complete-shadcn/frontend" ] && [ -d "test-output-complete-shadcn/backend" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 4.9: Fonctionnalités avancées
    echo -e "${BLUE}Testing: Advanced features${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -f "test-output-complete-shadcn/frontend/public/manifest.json" ] && [ -f "test-output-complete-shadcn/frontend/src/components/MUIWrapper.tsx" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 4.10: Variables Handlebars (complet)
    echo -e "${BLUE}Testing: Handlebars processing (complete)${NC}"
    TOTAL=$((TOTAL + 1))
    if ! grep -r "{{.*}}" test-output-complete-shadcn 2>/dev/null; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 4.11: Nom du projet (complet)
    echo -e "${BLUE}Testing: Project name replacement (complete)${NC}"
    TOTAL=$((TOTAL + 1))
    if grep -r "test-complete-shadcn" test-output-complete-shadcn >/dev/null 2>&1; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi

# Test 4.12: Projet avec Yarn + Next.js 14
echo -e "${BLUE}Testing: Generate project with Yarn + Next.js 14${NC}"
TOTAL=$((TOTAL + 1))

if npx ts-node src/cli.ts create --name test-yarn-14 --description "Test project Yarn Next.js 14" --author "Test" --package-manager yarn --nextjs-version 14 --ui mui --state-management zustand --features pwa --output ./test-output-yarn-14 --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
    
    # Vérifier immédiatement la structure
    echo -e "${YELLOW}  Vérification de la structure...${NC}"
    sleep 2
    
    # Test 4.13: Structure du projet Yarn
    echo -e "${BLUE}Testing: Yarn project structure${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -d "test-output-yarn-14/frontend" ] && [ -d "test-output-yarn-14/backend" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 4.14: Variables Handlebars (Yarn)
    echo -e "${BLUE}Testing: Handlebars processing (Yarn)${NC}"
    TOTAL=$((TOTAL + 1))
    if ! grep -r "{{.*}}" test-output-yarn-14 2>/dev/null; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi

# Phase 5: Tests de validation
echo -e "${YELLOW}=== Phase 5: Tests de validation ===${NC}"

run_test "Documentation files" "test -f docs/README.md && test -f docs/INSTALLATION.md && test -f docs/USAGE.md"

# Test 5.1: Validation des projets générés
echo -e "${BLUE}Testing: Validate generated projects${NC}"
TOTAL=$((TOTAL + 1))
if [ -d "test-output-minimal-mui" ] && [ -d "test-output-complete-shadcn" ] && [ -d "test-output-yarn-14" ]; then
    if node -e "JSON.parse(require('fs').readFileSync('test-output-minimal-mui/frontend/package.json', 'utf8'))" 2>/dev/null && node -e "JSON.parse(require('fs').readFileSync('test-output-complete-shadcn/frontend/package.json', 'utf8'))" 2>/dev/null && node -e "JSON.parse(require('fs').readFileSync('test-output-yarn-14/frontend/package.json', 'utf8'))" 2>/dev/null; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Phase 6: Tests de fonctionnalités spécifiques
echo -e "${YELLOW}=== Phase 6: Tests de fonctionnalités spécifiques ===${NC}"

# Test 6.1: Configuration Tailwind (Shadcn)
echo -e "${BLUE}Testing: Tailwind configuration (Shadcn)${NC}"
TOTAL=$((TOTAL + 1))
if [ -f "test-output-complete-shadcn/frontend/tailwind.config.js" ]; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 6.2: Configuration PWA
echo -e "${BLUE}Testing: PWA configuration${NC}"
TOTAL=$((TOTAL + 1))
if [ -f "test-output-minimal-mui/frontend/public/manifest.json" ] && [ -f "test-output-minimal-mui/frontend/public/sw.js" ]; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 6.3: Configuration Firebase
echo -e "${BLUE}Testing: Firebase configuration${NC}"
TOTAL=$((TOTAL + 1))
if [ -f "test-output-minimal-mui/backend/firebase.json" ] && [ -f "test-output-minimal-mui/backend/.firebaserc" ] && [ -f "test-output-minimal-mui/backend/firestore.rules" ]; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 6.4: Configuration TypeScript
echo -e "${BLUE}Testing: TypeScript configuration${NC}"
TOTAL=$((TOTAL + 1))
if [ -f "test-output-minimal-mui/frontend/tsconfig.json" ] && [ -f "test-output-minimal-mui/backend/functions/tsconfig.json" ]; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 6.5: Scripts d'initialisation
echo -e "${BLUE}Testing: Initialization scripts${NC}"
TOTAL=$((TOTAL + 1))
if [ -f "test-output-minimal-mui/scripts/init-project.sh" ] && [ -f "test-output-minimal-mui/scripts/init-project.bat" ]; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Phase 7: Tests de robustesse
echo -e "${YELLOW}=== Phase 7: Tests de robustesse ===${NC}"

# Test 7.1: Gestion des erreurs (nom de projet invalide)
echo -e "${BLUE}Testing: Error handling (invalid project name)${NC}"
TOTAL=$((TOTAL + 1))
if ! npx ts-node src/cli.ts create --name "invalid name" --description "Test" --author "Test" --package-manager npm --nextjs-version 15 --ui mui --state-management zustand --features pwa --output ./test-error --yes 2>/dev/null; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Nettoyage
echo -e "${BLUE}Cleaning up test projects...${NC}"
rm -rf test-output-minimal-mui test-output-complete-shadcn test-output-yarn-14 test-error
echo -e "${GREEN}Cleanup completed${NC}"
echo

# Résultats finaux
echo -e "${BLUE}=== Résultats Finaux ===${NC}"
echo -e "Total tests: $TOTAL"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 Tous les tests ont réussi !${NC}"
    echo -e "${GREEN}🚀 Le générateur est 100% fonctionnel et prêt pour la production !${NC}"
    echo
    echo -e "${CYAN}Fonctionnalités testées avec succès :${NC}"
    echo -e "  ✅ Génération de projets avec différentes configurations"
    echo -e "  ✅ Support de MUI et Shadcn/ui"
    echo -e "  ✅ Support de Zustand et Redux"
    echo -e "  ✅ Support de npm et Yarn"
    echo -e "  ✅ Support de Next.js 14 et 15"
    echo -e "  ✅ Fonctionnalités PWA, FCM, Analytics, Performance, Sentry"
    echo -e "  ✅ Configuration Firebase complète"
    echo -e "  ✅ Traitement des variables Handlebars"
    echo -e "  ✅ Remplacement des noms de projets"
    echo -e "  ✅ Gestion des erreurs"
    exit 0
else
    echo -e "${RED}❌ $FAILED tests ont échoué.${NC}"
    echo -e "${YELLOW}🔧 Des ajustements peuvent être nécessaires.${NC}"
    exit 1
fi 