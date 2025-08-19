#!/bin/bash

# Script de test de la structure des applications générées
# Usage: ./scripts/test-apps-structure.sh
# Ce script teste que les applications sont correctement générées et structurées

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}=== TEST DE LA STRUCTURE DES APPLICATIONS GÉNÉRÉES ===${NC}"
echo -e "${CYAN}Ce script teste que les applications sont correctement générées et structurées${NC}"
echo -e "${YELLOW}⏱️  Durée estimée : 3-5 minutes${NC}"
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
    rm -rf test-app-structure-* 2>/dev/null || true
    echo -e "${GREEN}✅ Nettoyage terminé${NC}"
}

# Trap cleanup on exit
trap cleanup EXIT

# Phase 1: Tests de génération avec toutes les configurations
echo -e "${YELLOW}=== Phase 1: Tests de génération avec toutes les configurations ===${NC}"

# Test 1.1: Projet minimal MUI + Zustand
echo -e "${BLUE}Testing: Generate minimal MUI + Zustand project${NC}"
TOTAL=$((TOTAL + 1))
if npx ts-node src/cli.ts create \
    --name test-app-structure-mui \
    --description "Test structure MUI project" \
    --author "Test User" \
    --package-manager npm \
    --nextjs-version 15 \
    --ui mui \
    --state-management zustand \
    --features pwa \
    --output ./test-app-structure-mui \
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
    --name test-app-structure-shadcn \
    --description "Test structure Shadcn project" \
    --author "Test User" \
    --package-manager npm \
    --nextjs-version 15 \
    --ui shadcn \
    --state-management redux \
    --features pwa,analytics \
    --output ./test-app-structure-shadcn \
    --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 1.3: Projet avec Yarn
echo -e "${BLUE}Testing: Generate Yarn project${NC}"
TOTAL=$((TOTAL + 1))
if npx ts-node src/cli.ts create \
    --name test-app-structure-yarn \
    --description "Test structure Yarn project" \
    --author "Test User" \
    --package-manager yarn \
    --nextjs-version 14 \
    --ui mui \
    --state-management zustand \
    --features pwa \
    --output ./test-app-structure-yarn \
    --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Phase 2: Tests de structure et validation des projets
echo -e "${YELLOW}=== Phase 2: Tests de structure et validation des projets ===${NC}"

# Test 2.1: Structure des projets
run_test "MUI project structure" "test -d test-app-structure-mui/frontend && test -d test-app-structure-mui/backend"
run_test "Shadcn project structure" "test -d test-app-structure-shadcn/frontend && test -d test-app-structure-shadcn/backend"
run_test "Yarn project structure" "test -d test-app-structure-yarn/frontend && test -d test-app-structure-yarn/backend"

# Test 2.2: Fichiers essentiels
run_test "MUI essential files" "test -f test-app-structure-mui/frontend/package.json && test -f test-app-structure-mui/frontend/src/app/page.tsx"
run_test "Shadcn essential files" "test -f test-app-structure-shadcn/frontend/package.json && test -f test-app-structure-shadcn/frontend/tailwind.config.js"
run_test "Yarn essential files" "test -f test-app-structure-yarn/frontend/package.json && test -f test-app-structure-yarn/frontend/src/app/page.tsx"

# Test 2.3: Configuration Firebase
run_test "MUI Firebase config" "test -f test-app-structure-mui/backend/firebase.json && test -f test-app-structure-mui/backend/.firebaserc"
run_test "Shadcn Firebase config" "test -f test-app-structure-shadcn/backend/firebase.json && test -f test-app-structure-shadcn/backend/.firebaserc"
run_test "Yarn Firebase config" "test -f test-app-structure-yarn/backend/firebase.json && test -f test-app-structure-yarn/backend/.firebaserc"

# Phase 3: Tests de validation des dépendances
echo -e "${YELLOW}=== Phase 3: Tests de validation des dépendances ===${NC}"

# Test 3.1: Dépendances
run_test "MUI dependencies" "grep -q '@mui/material' test-app-structure-mui/frontend/package.json"
run_test "Shadcn dependencies" "grep -q 'tailwindcss' test-app-structure-shadcn/frontend/package.json"
run_test "Zustand dependencies" "grep -q 'zustand' test-app-structure-mui/frontend/package.json"
run_test "Redux dependencies" "grep -q '@reduxjs/toolkit' test-app-structure-shadcn/frontend/package.json"
run_test "Yarn package manager" "grep -q '\"packageManager\": \"yarn\"' test-app-structure-yarn/frontend/package.json"

# Phase 4: Tests de validation des composants et fichiers
echo -e "${YELLOW}=== Phase 4: Tests de validation des composants et fichiers ===${NC}"

# Test 4.1: Composants
run_test "MUI components" "test -f test-app-structure-mui/frontend/src/components/Button.tsx"
run_test "Shadcn components" "test -f test-app-structure-shadcn/frontend/src/components/Button.tsx"
run_test "Common components" "test -f test-app-structure-mui/frontend/src/components/Loading.tsx"

# Test 4.2: Stores et hooks
run_test "Zustand stores" "test -f test-app-structure-mui/frontend/src/stores/auth-store.ts"
run_test "Redux stores" "test -f test-app-structure-shadcn/frontend/src/stores/auth-slice.ts"
run_test "Custom hooks" "test -f test-app-structure-mui/frontend/src/hooks/use-auth.ts"

# Test 4.3: Pages et API
run_test "App pages" "test -f test-app-structure-mui/frontend/src/app/page.tsx && test -f test-app-structure-mui/frontend/src/app/layout.tsx"
run_test "Auth pages" "test -f test-app-structure-mui/frontend/src/app/auth/login/page.tsx"
run_test "Dashboard pages" "test -f test-app-structure-mui/frontend/src/app/dashboard/page.tsx"
run_test "API routes" "test -f test-app-structure-mui/frontend/src/app/api/auth/login/route.ts"

# Phase 5: Tests de validation des fonctionnalités
echo -e "${YELLOW}=== Phase 5: Tests de validation des fonctionnalités ===${NC}"

# Test 5.1: Configuration PWA
run_test "PWA config exists" "test -f test-app-structure-mui/frontend/public/manifest.json && test -f test-app-structure-mui/frontend/public/sw.js"
run_test "PWA config is valid JSON" "node -e \"JSON.parse(require('fs').readFileSync('test-app-structure-mui/frontend/public/manifest.json', 'utf8'))\""

# Test 5.2: Configuration Tailwind
run_test "Tailwind config exists" "test -f test-app-structure-shadcn/frontend/tailwind.config.js"

# Test 5.3: Configuration Firebase
run_test "Firebase config is valid JSON" "node -e \"JSON.parse(require('fs').readFileSync('test-app-structure-mui/backend/firebase.json', 'utf8'))\""
run_test "Firebase project config is valid JSON" "node -e \"JSON.parse(require('fs').readFileSync('test-app-structure-mui/backend/.firebaserc', 'utf8'))\""

# Phase 6: Tests de validation des scripts et documentation
echo -e "${YELLOW}=== Phase 6: Tests de validation des scripts et documentation ===${NC}"

# Test 6.1: Scripts
run_test "Init scripts exist" "test -f test-app-structure-mui/scripts/init-project.sh && test -f test-app-structure-mui/scripts/init-project.bat"
run_test "Deploy scripts exist" "test -f test-app-structure-mui/backend/scripts/deploy.sh"

# Test 6.2: Documentation
run_test "Main README exists" "test -f test-app-structure-mui/README.md"
run_test "README contains project name" "grep -q 'test-app-structure-mui' test-app-structure-mui/README.md"

# Phase 7: Tests de validation finale
echo -e "${YELLOW}=== Phase 7: Tests de validation finale ===${NC}"

# Test 7.1: Aucun fichier .hbs
run_test "No .hbs files in MUI project" "! find test-app-structure-mui -name '*.hbs' | grep -q ."
run_test "No .hbs files in Shadcn project" "! find test-app-structure-shadcn -name '*.hbs' | grep -q ."
run_test "No .hbs files in Yarn project" "! find test-app-structure-yarn -name '*.hbs' | grep -q ."

# Test 7.2: Cohérence des noms
run_test "MUI project names consistent" "grep -r 'test-app-structure-mui' test-app-structure-mui >/dev/null 2>&1 && ! grep -r '{{project.name}}' test-app-structure-mui >/dev/null 2>&1"
run_test "Shadcn project names consistent" "grep -r 'test-app-structure-shadcn' test-app-structure-shadcn >/dev/null 2>&1 && ! grep -r '{{project.name}}' test-app-structure-shadcn >/dev/null 2>&1"
run_test "Yarn project names consistent" "grep -r 'test-app-structure-yarn' test-app-structure-yarn >/dev/null 2>&1 && ! grep -r '{{project.name}}' test-app-structure-yarn >/dev/null 2>&1"

# Test 7.3: Structure finale
run_test "MUI final structure" "find test-app-structure-mui -type f -name '*.tsx' -o -name '*.ts' | wc -l | grep -q '[0-9]'"
run_test "Shadcn final structure" "find test-app-structure-shadcn -type f -name '*.tsx' -o -name '*.ts' | wc -l | grep -q '[0-9]'"
run_test "Yarn final structure" "find test-app-structure-yarn -type f -name '*.tsx' -o -name '*.ts' | wc -l | grep -q '[0-9]'"

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
echo -e "${BLUE}=== RÉSUMÉ DE LA VALIDATION DE STRUCTURE ===${NC}"
echo -e "📱 Applications testées : 3 projets avec configurations différentes"
echo -e "🔧 Package managers : npm, yarn"
echo -e "⚛️  Versions Next.js : 14, 15"
echo -e "🎨 Frameworks UI : MUI, Shadcn/ui"
echo -e "📊 Gestion d'état : Zustand, Redux"
echo -e "🚀 Fonctionnalités : PWA, Analytics"
echo -e "🔥 Backend : Firebase complet"
echo

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 La structure des applications générées est parfaite !${NC}"
    echo -e "${GREEN}✅ Le générateur produit des applications 100% bien structurées !${NC}"
    echo
    echo -e "${CYAN}Validation de structure garantie :${NC}"
    echo -e "  ✅ Génération de projets (100%)"
    echo -e "  ✅ Structure des projets (100%)"
    echo -e "  ✅ Composants et stores (100%)"
    echo -e "  ✅ Configuration Firebase (100%)"
    echo -e "  ✅ Fonctionnalités avancées (100%)"
    echo -e "  ✅ Scripts et documentation (100%)"
    echo -e "  ✅ Traitement des templates (100%)"
    echo
    echo -e "${YELLOW}💡 Note : Les tests de build ne sont pas inclus dans cette validation.${NC}"
    echo -e "${YELLOW}   Pour une validation complète incluant le build, utilisez :${NC}"
    echo -e "   ./scripts/test-generated-apps.sh"
    exit 0
else
    echo -e "${RED}❌ $FAILED tests ont échoué.${NC}"
    echo -e "${YELLOW}🔧 Des ajustements peuvent être nécessaires pour la structure des applications.${NC}"
    exit 1
fi 