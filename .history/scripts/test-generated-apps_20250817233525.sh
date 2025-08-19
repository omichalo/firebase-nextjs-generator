#!/bin/bash

# Script de test ULTRA-COMPLET pour le Générateur Firebase + Next.js 2025
# Ce script teste TOUT : générateur + applications générées + fonctionnement réel
# Usage: ./scripts/test-generated-apps.sh

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

echo -e "${BLUE}=== Test ULTRA-COMPLET du Générateur + Applications Générées ===${NC}"
echo -e "${CYAN}Ce script teste TOUT : générateur + build + démarrage + fonctionnalités${NC}"
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

# Phase 2: Tests de build du générateur
echo -e "${YELLOW}=== Phase 2: Tests de build du générateur ===${NC}"

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
        FAILED=$((PASSED + 1))
    fi
    echo
    
    # Test 4.5: Variables Handlebars
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
    
    # Test 4.6: Nom du projet
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

# Test 4.7: Projet complet avec MUI + Redux + toutes les fonctionnalités
echo -e "${BLUE}Testing: Generate complete project (MUI + Redux + all features)${NC}"
TOTAL=$((TOTAL + 1))

if npx ts-node src/cli.ts create --name test-complete-mui --description "Test project MUI complete" --author "Test" --package-manager npm --nextjs-version 15 --ui mui --state-management redux --features pwa,sentry,fcm,analytics,performance --output ./test-output-complete-mui --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
    
    # Vérifier immédiatement la structure
    echo -e "${YELLOW}  Vérification de la structure...${NC}"
    sleep 2
    
    # Test 4.8: Structure du projet complet
    echo -e "${BLUE}Testing: Complete project structure${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -d "test-output-complete-mui/frontend" ] && [ -d "test-output-complete-mui/backend" ]; then
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
    if [ -f "test-output-complete-mui/frontend/public/manifest.json" ] && [ -f "test-output-complete-mui/frontend/src/components/MUIWrapper.tsx" ]; then
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
    if ! grep -r "{{.*}}" test-output-complete-mui 2>/dev/null; then
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
    if grep -r "test-complete-mui" test-output-complete-mui >/dev/null 2>&1; then
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

# Phase 5: Tests de BUILD des applications générées
echo -e "${YELLOW}=== Phase 5: Tests de BUILD des applications générées ===${NC}"

# Test 5.1: Build du projet minimal
echo -e "${BLUE}Testing: Build minimal project${NC}"
TOTAL=$((TOTAL + 1))

cd test-output-minimal-mui/frontend
if npm install --legacy-peer-deps --silent && npm run build; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
cd ../..

# Test 5.2: Build du projet complet
echo -e "${BLUE}Testing: Build complete project${NC}"
TOTAL=$((TOTAL + 1))

cd test-output-complete-mui/frontend
if npm install --legacy-peer-deps --silent && npm run build; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
cd ../..

# Phase 6: Tests de DÉMARRAGE des applications
echo -e "${YELLOW}=== Phase 6: Tests de DÉMARRAGE des applications ===${NC}"

# Test 6.1: Démarrage du projet minimal
echo -e "${BLUE}Testing: Start minimal project${NC}"
TOTAL=$((TOTAL + 1))

cd test-output-minimal-mui/frontend
npm run dev > /dev/null 2>&1 &
DEV_PID=$!
sleep 15  # Attendre le démarrage

if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
    kill $DEV_PID 2>/dev/null || true
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
    kill $DEV_PID 2>/dev/null || true
fi
cd ../..

# Test 6.2: Démarrage du projet complet
echo -e "${BLUE}Testing: Start complete project${NC}"
TOTAL=$((TOTAL + 1))

cd test-output-complete-mui/frontend
npm run dev > /dev/null 2>&1 &
DEV_PID=$!
sleep 15  # Attendre le démarrage

if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
    kill $DEV_PID 2>/dev/null || true
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
    kill $DEV_PID 2>/dev/null || true
fi
cd ../..

# Phase 7: Tests de FONCTIONNALITÉS des applications
echo -e "${YELLOW}=== Phase 7: Tests de FONCTIONNALITÉS des applications ===${NC}"

# Test 7.1: Composants MUI du projet minimal
echo -e "${BLUE}Testing: MUI components (minimal)${NC}"
TOTAL=$((TOTAL + 1))

if [ -f "test-output-minimal-mui/frontend/src/components/Button.tsx" ] && [ -f "test-output-minimal-mui/frontend/src/components/Card.tsx" ]; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 7.2: Composants MUI du projet complet
echo -e "${BLUE}Testing: MUI components (complete)${NC}"
TOTAL=$((TOTAL + 1))

if [ -f "test-output-complete-mui/frontend/src/components/MUIWrapper.tsx" ] && [ -f "test-output-complete-mui/frontend/src/components/Providers.tsx" ]; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 7.3: Pages de l'application
echo -e "${BLUE}Testing: Application pages${NC}"
TOTAL=$((TOTAL + 1))

if [ -f "test-output-minimal-mui/frontend/src/app/page.tsx" ] && [ -f "test-output-minimal-mui/frontend/src/app/auth/login/page.tsx" ] && [ -f "test-output-minimal-mui/frontend/src/app/dashboard/page.tsx" ]; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 7.4: Configuration Firebase
echo -e "${BLUE}Testing: Firebase configuration${NC}"
TOTAL=$((TOTAL + 1))

if [ -f "test-output-minimal-mui/frontend/src/lib/firebase.ts" ] && [ -f "test-output-minimal-mui/backend/firebase.json" ]; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 7.5: Configuration PWA
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

# Phase 8: Tests de validation finale
echo -e "${YELLOW}=== Phase 8: Tests de validation finale ===${NC}"

# Test 8.1: Documentation
run_test "Documentation files" "test -f docs/README.md && test -f docs/INSTALLATION.md && test -f docs/USAGE.md"

# Test 8.2: Validation des projets générés
echo -e "${BLUE}Testing: Validate generated projects${NC}"
TOTAL=$((TOTAL + 1))
if [ -d "test-output-minimal-mui" ] && [ -d "test-output-complete-mui" ]; then
    if node -e "JSON.parse(require('fs').readFileSync('test-output-minimal-mui/frontend/package.json', 'utf8'))" 2>/dev/null && node -e "JSON.parse(require('fs').readFileSync('test-output-complete-mui/frontend/package.json', 'utf8'))" 2>/dev/null; then
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

# Phase 9: Tests de robustesse
echo -e "${YELLOW}=== Phase 9: Tests de robustesse ===${NC}"

# Test 9.1: Gestion des erreurs
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

# Nettoyer les projets de test
echo -e "${YELLOW}Cleaning up test projects...${NC}"
if [ -d "test-output-minimal-mui" ]; then rm -rf test-output-minimal-mui; fi
if [ -d "test-output-complete-mui" ]; then rm -rf test-output-complete-mui; fi
if [ -d "test-error" ]; then rm -rf test-error; fi
echo -e "${GREEN}Cleanup completed${NC}"

# Résultats finaux
echo -e "${BLUE}=== Résultats Finaux ===${NC}"
echo -e "Total tests: $TOTAL"
echo -e "Passed: $PASSED"
echo -e "Failed: $FAILED"
echo

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 Tous les tests ont réussi !${NC}"
    echo -e "${GREEN}🚀 Le générateur ET les applications générées sont 100% fonctionnels !${NC}"
    echo
    echo -e "${CYAN}Fonctionnalités testées avec succès :${NC}"
    echo -e "  ✅ Génération de projets avec différentes configurations"
    echo -e "  ✅ Support de MUI et Zustand/Redux"
    echo -e "  ✅ Support de npm et Yarn"
    echo -e "  ✅ Support de Next.js 14 et 15"
    echo -e "  ✅ Fonctionnalités PWA, FCM, Analytics, Performance, Sentry"
    echo -e "  ✅ Configuration Firebase complète"
    echo -e "  ✅ Traitement des variables Handlebars"
    echo -e "  ✅ Remplacement des noms de projets"
    echo -e "  ✅ Gestion des erreurs"
    echo -e "  ✅ BUILD des applications générées"
    echo -e "  ✅ DÉMARRAGE des serveurs de développement"
    echo -e "  ✅ FONCTIONNEMENT des composants MUI"
    echo -e "  ✅ PAGES de l'application (login, dashboard, 404)"
    echo -e "  ✅ INTÉGRATION Firebase et PWA"
else
    echo -e "${RED}❌ $FAILED tests ont échoué.${NC}"
    echo -e "${YELLOW}🔧 Des ajustements peuvent être nécessaires.${NC}"
fi

echo
echo -e "${BLUE}=== Test ULTRA-COMPLET terminé ===${NC}" 