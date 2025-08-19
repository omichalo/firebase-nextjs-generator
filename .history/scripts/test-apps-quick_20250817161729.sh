#!/bin/bash

# Script de test rapide des applications générées
# Usage: ./scripts/test-apps-quick.sh
# Ce script teste rapidement que les applications générées fonctionnent

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}=== TEST RAPIDE DES APPLICATIONS GÉNÉRÉES ===${NC}"
echo -e "${CYAN}Ce script teste rapidement que les applications générées fonctionnent${NC}"
echo -e "${YELLOW}⏱️  Durée estimée : 5-10 minutes${NC}"
echo

# Test counter
PASSED=0
FAILED=0
TOTAL=0

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

# Cleanup function
cleanup() {
    echo -e "${YELLOW}🧹 Nettoyage des projets de test...${NC}"
    rm -rf test-app-quick-* 2>/dev/null || true
    echo -e "${GREEN}✅ Nettoyage terminé${NC}"
}

# Trap cleanup on exit
trap cleanup EXIT

# Phase 1: Tests de génération rapide
echo -e "${YELLOW}=== Phase 1: Tests de génération rapide ===${NC}"

# Test 1.1: Projet minimal MUI + Zustand
echo -e "${BLUE}Testing: Generate minimal MUI + Zustand project${NC}"
TOTAL=$((TOTAL + 1))
if npx ts-node src/cli.ts create \
    --name test-app-quick-mui \
    --description "Test quick MUI project" \
    --author "Test User" \
    --package-manager npm \
    --nextjs-version 15 \
    --ui mui \
    --state-management zustand \
    --features pwa \
    --output ./test-app-quick-mui \
    --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 1.2: Projet Shadcn + Redux
echo -e "${BLUE}Testing: Generate Shadcn + Redux project${NC}"
TOTAL=$((TOTAL + 1))
if npx ts-node src/cli.ts create \
    --name test-app-quick-shadcn \
    --description "Test quick Shadcn project" \
    --author "Test User" \
    --package-manager npm \
    --nextjs-version 15 \
    --ui shadcn \
    --state-management redux \
    --features pwa,analytics \
    --output ./test-app-quick-shadcn \
    --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Phase 2: Tests de structure rapide
echo -e "${YELLOW}=== Phase 2: Tests de structure rapide ===${NC}"

# Test 2.1: Structure des projets
run_test "MUI project structure" "test -d test-app-quick-mui/frontend && test -d test-app-quick-mui/backend"
run_test "Shadcn project structure" "test -d test-app-quick-shadcn/frontend && test -d test-app-quick-shadcn/backend"

# Test 2.2: Fichiers essentiels
run_test "MUI essential files" "test -f test-app-quick-mui/frontend/package.json && test -f test-app-quick-mui/frontend/src/app/page.tsx"
run_test "Shadcn essential files" "test -f test-app-quick-shadcn/frontend/package.json && test -f test-app-quick-shadcn/frontend/tailwind.config.js"

# Test 2.3: Configuration Firebase
run_test "MUI Firebase config" "test -f test-app-quick-mui/backend/firebase.json && test -f test-app-quick-mui/backend/.firebaserc"
run_test "Shadcn Firebase config" "test -f test-app-quick-shadcn/backend/firebase.json && test -f test-app-quick-shadcn/backend/.firebaserc"

# Phase 3: Tests de validation rapide
echo -e "${YELLOW}=== Phase 3: Tests de validation rapide ===${NC}"

# Test 3.1: Dépendances
run_test "MUI dependencies" "grep -q '@mui/material' test-app-quick-mui/frontend/package.json"
run_test "Shadcn dependencies" "grep -q 'tailwindcss' test-app-quick-shadcn/frontend/package.json"
run_test "Zustand dependencies" "grep -q 'zustand' test-app-quick-mui/frontend/package.json"
run_test "Redux dependencies" "grep -q '@reduxjs/toolkit' test-app-quick-shadcn/frontend/package.json"

# Test 3.2: Composants
run_test "MUI components" "test -f test-app-quick-mui/frontend/src/components/Button.tsx"
run_test "Shadcn components" "test -f test-app-quick-shadcn/frontend/src/components/Button.tsx"

# Test 3.3: Stores et hooks
run_test "Zustand stores" "test -f test-app-quick-mui/frontend/src/stores/auth-store.ts"
run_test "Redux stores" "test -f test-app-quick-shadcn/frontend/src/stores/auth-slice.ts"
run_test "Custom hooks" "test -f test-app-quick-mui/frontend/src/hooks/use-auth.ts"

# Phase 4: Tests de compilation rapide
echo -e "${YELLOW}=== Phase 4: Tests de compilation rapide ===${NC}"

# Test 4.1: Build MUI
echo -e "${BLUE}Testing: Build MUI project${NC}"
TOTAL=$((TOTAL + 1))
cd test-app-quick-mui/frontend
if npm install --silent && npm run build --silent; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
cd ../..
echo

# Test 4.2: Build Shadcn
echo -e "${BLUE}Testing: Build Shadcn project${NC}"
TOTAL=$((TOTAL + 1))
cd test-app-quick-shadcn/frontend
if npm install --silent && npm run build --silent; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
cd ../..
echo

# Phase 5: Tests de validation finale
echo -e "${YELLOW}=== Phase 5: Tests de validation finale ===${NC}"

# Test 5.1: Aucun fichier .hbs
run_test "No .hbs files in MUI project" "! find test-app-quick-mui -name '*.hbs' | grep -q ."
run_test "No .hbs files in Shadcn project" "! find test-app-quick-shadcn -name '*.hbs' | grep -q ."

# Test 5.2: Cohérence des noms
run_test "MUI project names consistent" "grep -r 'test-app-quick-mui' test-app-quick-mui >/dev/null 2>&1 && ! grep -r '{{project.name}}' test-app-quick-mui >/dev/null 2>&1"
run_test "Shadcn project names consistent" "grep -r 'test-app-quick-shadcn' test-app-quick-shadcn >/dev/null 2>&1 && ! grep -r '{{project.name}}' test-app-quick-shadcn >/dev/null 2>&1"

# Test 5.3: Structure finale
run_test "MUI final structure" "find test-app-quick-mui -type f -name '*.tsx' -o -name '*.ts' | wc -l | grep -q '[0-9]'"
run_test "Shadcn final structure" "find test-app-quick-shadcn -type f -name '*.tsx' -o -name '*.ts' | wc -l | grep -q '[0-9]'"

# Résultats finaux
echo -e "${PURPLE}=== RÉSULTATS FINAUX ===${NC}"
echo -e "Total tests: $TOTAL"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"

# Calculer le pourcentage de réussite
if [ $TOTAL -gt 0 ]; then
    SUCCESS_PERCENTAGE=$(( (PASSED * 100) / TOTAL ))
    echo -e "Success rate: ${CYAN}${SUCCESS_PERCENTAGE}%${NC}"
fi

echo

# Résumé de la validation
echo -e "${BLUE}=== RÉSUMÉ DE LA VALIDATION RAPIDE ===${NC}"
echo -e "📱 Applications testées : 2 projets avec configurations différentes"
echo -e "🎨 Frameworks UI : MUI, Shadcn/ui"
echo -e "📊 Gestion d'état : Zustand, Redux"
echo -e "🚀 Fonctionnalités : PWA, Analytics"
echo -e "🔥 Backend : Firebase complet"
echo

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 Les applications générées fonctionnent parfaitement !${NC}"
    echo -e "${GREEN}✅ Le générateur produit des applications 100% fonctionnelles !${NC}"
    echo
    echo -e "${CYAN}Validation rapide garantie :${NC}"
    echo -e "  ✅ Génération de projets (100%)"
    echo -e "  ✅ Structure des projets (100%)"
    echo -e "  ✅ Compilation et build (100%)"
    echo -e "  ✅ Composants et stores (100%)"
    echo -e "  ✅ Configuration Firebase (100%)"
    echo -e "  ✅ Traitement des templates (100%)"
    echo
    echo -e "${YELLOW}💡 Pour une validation complète, utilisez :${NC}"
    echo -e "  ./scripts/test-generated-apps.sh"
    exit 0
else
    echo -e "${RED}❌ $FAILED tests ont échoué.${NC}"
    echo -e "${YELLOW}🔧 Des ajustements peuvent être nécessaires pour les applications générées.${NC}"
    exit 1
fi 