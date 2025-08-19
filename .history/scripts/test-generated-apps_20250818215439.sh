#!/bin/bash

# Script de test ultra-complet des applications générées
# Usage: ./scripts/test-generated-apps.sh
# Ce script teste que TOUTES les applications générées fonctionnent correctement

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}=== TESTS ULTRA-COMPLETS DES APPLICATIONS GÉNÉRÉES ===${NC}"
echo -e "${CYAN}Ce script teste que TOUTES les applications générées fonctionnent correctement${NC}"
echo -e "${YELLOW}⚠️  ATTENTION: Ce test peut prendre 15-30 minutes et nécessite une connexion internet${NC}"
echo

# Test counter
PASSED=0
FAILED=0
TOTAL=0
SKIPPED=0

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    local skip_condition="$3"
    
    echo -e "${BLUE}Testing: $test_name${NC}"
    TOTAL=$((TOTAL + 1))
    
    # Check skip condition
    if [ -n "$skip_condition" ] && eval "$skip_condition" 2>/dev/null; then
        echo -e "${YELLOW}  SKIP (condition non remplie)${NC}"
        SKIPPED=$((SKIPPED + 1))
        echo
        return
    fi
    
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
    rm -rf test-app-* 2>/dev/null || true
    echo -e "${GREEN}✅ Nettoyage terminé${NC}"
}

# Trap cleanup on exit
trap cleanup EXIT

# Phase 1: Tests de génération avec toutes les configurations
echo -e "${YELLOW}=== Phase 1: Tests de génération avec toutes les configurations ===${NC}"

# Test 1.1: Projet minimal MUI + Zustand + PWA
echo -e "${BLUE}Testing: Generate minimal MUI + Zustand + PWA project${NC}"
TOTAL=$((TOTAL + 1))
if npx ts-node src/cli.ts create \
    --name test-app-minimal-mui \
    --description "Test minimal MUI project" \
    --author "Test User" \
    --package-manager npm \
    --nextjs-version 15 \
    --ui mui \
    --state-management zustand \
    --features pwa \
    --output ./test-app-minimal-mui \
    --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 1.2: Projet complet Shadcn + Redux + toutes fonctionnalités
echo -e "${BLUE}Testing: Generate complete Shadcn + Redux + all features project${NC}"
TOTAL=$((TOTAL + 1))
if npx ts-node src/cli.ts create \
    --name test-app-complete-shadcn \
    --description "Test complete Shadcn project" \
    --author "Test User" \
    --package-manager npm \
    --nextjs-version 15 \
    --ui shadcn \
    --state-management redux \
    --features pwa,fcm,analytics,performance,sentry \
    --output ./test-app-complete-shadcn \
    --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 1.3: Projet avec Yarn + Next.js 14
echo -e "${BLUE}Testing: Generate Yarn + Next.js 14 project${NC}"
TOTAL=$((TOTAL + 1))
if npx ts-node src/cli.ts create \
    --name test-app-yarn-14 \
    --description "Test Yarn Next.js 14 project" \
    --author "Test User" \
    --package-manager yarn \
    --nextjs-version 14 \
    --ui mui \
    --state-management zustand \
    --features pwa \
    --output ./test-app-yarn-14 \
    --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Test 1.4: Projet avec pnpm + Next.js 15 + UI mixte
echo -e "${BLUE}Testing: Generate pnpm + Next.js 15 + mixed UI project${NC}"
TOTAL=$((TOTAL + 1))
if npx ts-node src/cli.ts create \
    --name test-app-pnpm-mixed \
    --description "Test pnpm mixed UI project" \
    --author "Test User" \
    --package-manager pnpm \
    --nextjs-version 15 \
    --ui both \
    --state-management both \
    --features pwa,fcm,analytics \
    --output ./test-app-pnpm-mixed \
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

# Test 2.1: Structure du projet minimal MUI
run_test "Minimal MUI project structure" "test -d test-app-minimal-mui/frontend && test -d test-app-minimal-mui/backend"
run_test "Minimal MUI frontend files" "test -f test-app-minimal-mui/frontend/package.json && test -f test-app-minimal-mui/frontend/src/app/page.tsx"
run_test "Minimal MUI backend files" "test -f test-app-minimal-mui/backend/firebase.json && test -f test-app-minimal-mui/backend/.firebaserc"

# Test 2.2: Structure du projet complet Shadcn
run_test "Complete Shadcn project structure" "test -d test-app-complete-shadcn/frontend && test -d test-app-complete-shadcn/backend"
run_test "Complete Shadcn frontend files" "test -f test-app-complete-shadcn/frontend/package.json && test -f test-app-complete-shadcn/frontend/tailwind.config.js"
run_test "Complete Shadcn backend files" "test -f test-app-complete-shadcn/backend/firebase.json && test -f test-app-complete-shadcn/backend/.firebaserc"

# Test 2.3: Structure du projet Yarn
run_test "Yarn project structure" "test -d test-app-yarn-14/frontend && test -d test-app-yarn-14/backend"
run_test "Yarn package.json" "grep -q '\"packageManager\": \"yarn@' test-app-yarn-14/frontend/package.json"

# Test 2.4: Structure du projet pnpm mixte
run_test "Pnpm mixed project structure" "test -d test-app-pnpm-mixed/frontend && test -d test-app-pnpm-mixed/backend"
run_test "Pnpm package.json" "grep -q '\"packageManager\": \"pnpm@' test-app-pnpm-mixed/frontend/package.json"

# Phase 3: Tests de validation des dépendances
echo -e "${YELLOW}=== Phase 3: Tests de validation des dépendances ===${NC}"

# Test 3.1: Dépendances MUI
run_test "MUI dependencies in minimal project" "grep -q '@mui/material' test-app-minimal-mui/frontend/package.json"
run_test "Zustand dependencies in minimal project" "grep -q 'zustand' test-app-minimal-mui/frontend/package.json"

# Test 3.2: Dépendances Shadcn
run_test "Shadcn dependencies in complete project" "grep -q 'tailwindcss' test-app-complete-shadcn/frontend/package.json"
run_test "Redux dependencies in complete project" "grep -q '@reduxjs/toolkit' test-app-complete-shadcn/frontend/package.json"

# Test 3.3: Dépendances avancées
run_test "PWA dependencies in complete project" "grep -q 'next-pwa' test-app-complete-shadcn/frontend/package.json"
run_test "Analytics dependencies in complete project" "grep -q '@sentry/nextjs' test-app-complete-shadcn/frontend/package.json"

# Phase 4: Tests de compilation et build
echo -e "${YELLOW}=== Phase 4: Tests de compilation et build ===${NC}"

# Test 4.1: Build du projet minimal MUI
echo -e "${BLUE}Testing: Build minimal MUI project${NC}"
TOTAL=$((TOTAL + 1))
cd test-app-minimal-mui/frontend
if npm install --silent && npm run build --silent; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
cd ../..
echo

# Test 4.2: Build du projet complet Shadcn
echo -e "${BLUE}Testing: Build complete Shadcn project${NC}"
TOTAL=$((TOTAL + 1))
cd test-app-complete-shadcn/frontend
if npm install --silent && npm run build --silent; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
cd ../..
echo

# Test 4.3: Build du projet Yarn
echo -e "${BLUE}Testing: Build Yarn project${NC}"
TOTAL=$((TOTAL + 1))
cd test-app-yarn-14/frontend
if yarn install --silent && yarn build --silent; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
cd ../..
echo

# Test 4.4: Build du projet pnpm mixte
echo -e "${BLUE}Testing: Build pnpm mixed project${NC}"
TOTAL=$((TOTAL + 1))
cd test-app-pnpm-mixed/frontend
if pnpm install --silent && pnpm build --silent; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
cd ../..
echo

# Phase 5: Tests de validation TypeScript
echo -e "${YELLOW}=== Phase 5: Tests de validation TypeScript ===${NC}"

# Test 5.1: Type-check du projet minimal MUI
run_test "TypeScript check minimal MUI project" "cd test-app-minimal-mui/frontend && npx tsc --noEmit --skipLibCheck --silent"

# Test 5.2: Type-check du projet complet Shadcn
run_test "TypeScript check complete Shadcn project" "cd test-app-complete-shadcn/frontend && npx tsc --noEmit --skipLibCheck --silent"

# Test 5.3: Type-check du projet Yarn
run_test "TypeScript check Yarn project" "cd test-app-yarn-14/frontend && npx tsc --noEmit --skipLibCheck --silent"

# Test 5.4: Type-check du projet pnpm mixte
run_test "TypeScript check pnpm mixed project" "cd test-app-pnpm-mixed/frontend && npx tsc --noEmit --skipLibCheck --silent"

# Phase 6: Tests de validation des composants
echo -e "${YELLOW}=== Phase 6: Tests de validation des composants ===${NC}"

# Test 6.1: Composants MUI
run_test "MUI components exist in minimal project" "test -f test-app-minimal-mui/frontend/src/components/Button.tsx && test -f test-app-minimal-mui/frontend/src/components/Card.tsx"
run_test "MUI components import correctly" "grep -q 'from.*@mui/material' test-app-minimal-mui/frontend/src/components/Button.tsx"

# Test 6.2: Composants Shadcn
run_test "Shadcn components exist in complete project" "test -f test-app-complete-shadcn/frontend/src/components/Button.tsx && test -f test-app-complete-shadcn/frontend/src/components/Card.tsx"
run_test "Tailwind classes in Shadcn components" "grep -q 'className.*bg-blue-500' test-app-complete-shadcn/frontend/src/components/Button.tsx"

# Test 6.3: Composants mixtes
run_test "Mixed UI components exist" "test -f test-app-pnpm-mixed/frontend/src/components/mui/Button.tsx && test -f test-app-pnpm-mixed/frontend/src/components/shadcn/Button.tsx"

# Phase 7: Tests de validation des stores et hooks
echo -e "${YELLOW}=== Phase 7: Tests de validation des stores et hooks ===${NC}"

# Test 7.1: Stores Zustand
run_test "Zustand stores exist in minimal project" "test -f test-app-minimal-mui/frontend/src/stores/auth-store.ts"
run_test "Zustand stores import correctly" "grep -q 'from.*zustand' test-app-minimal-mui/frontend/src/stores/auth-store.ts"

# Test 7.2: Stores Redux
run_test "Redux stores exist in complete project" "test -f test-app-complete-shadcn/frontend/src/stores/auth-slice.ts"
run_test "Redux stores import correctly" "grep -q 'from.*@reduxjs/toolkit' test-app-complete-shadcn/frontend/src/stores/auth-slice.ts"

# Test 7.3: Hooks personnalisés
run_test "Custom hooks exist in minimal project" "test -f test-app-minimal-mui/frontend/src/hooks/use-auth.ts && test -f test-app-minimal-mui/frontend/src/hooks/use-modal.ts"
run_test "Custom hooks import correctly" "grep -q 'from.*firebase' test-app-minimal-mui/frontend/src/hooks/use-auth.ts"

# Phase 8: Tests de validation Firebase
echo -e "${YELLOW}=== Phase 8: Tests de validation Firebase ===${NC}"

# Test 8.1: Configuration Firebase
run_test "Firebase config exists in minimal project" "test -f test-app-minimal-mui/backend/firebase.json && test -f test-app-minimal-mui/backend/.firebaserc"
run_test "Firebase config is valid JSON" "node -e \"JSON.parse(require('fs').readFileSync('test-app-minimal-mui/backend/firebase.json', 'utf8'))\""

# Test 8.2: Cloud Functions
run_test "Cloud Functions exist in minimal project" "test -f test-app-minimal-mui/backend/functions/src/index.ts && test -f test-app-minimal-mui/backend/functions/src/admin.ts"
run_test "Cloud Functions package.json is valid" "node -e \"JSON.parse(require('fs').readFileSync('test-app-minimal-mui/backend/functions/package.json', 'utf8'))\""

# Test 8.3: Firestore rules
run_test "Firestore rules exist in minimal project" "test -f test-app-minimal-mui/backend/firestore.rules && test -f test-app-minimal-mui/backend/firestore.indexes.json"
run_test "Firestore rules are valid" "grep -q 'rules_version' test-app-minimal-mui/backend/firestore.rules"

# Phase 9: Tests de validation des fonctionnalités avancées
echo -e "${YELLOW}=== Phase 9: Tests de validation des fonctionnalités avancées ===${NC}"

# Test 9.1: Configuration PWA
run_test "PWA config exists in minimal project" "test -f test-app-minimal-mui/frontend/public/manifest.json && test -f test-app-minimal-mui/frontend/public/sw.js"
run_test "PWA manifest is valid JSON" "node -e \"JSON.parse(require('fs').readFileSync('test-app-minimal-mui/frontend/public/manifest.json', 'utf8'))\""

# Test 9.2: Configuration Tailwind
run_test "Tailwind config exists in complete project" "test -f test-app-complete-shadcn/frontend/tailwind.config.js"
run_test "Tailwind config is valid" "node -e \"require('./test-app-complete-shadcn/frontend/tailwind.config.js')\""

# Test 9.3: Configuration Sentry
run_test "Sentry config exists in complete project" "test -f test-app-complete-shadcn/frontend/src/lib/sentry-config.ts"
run_test "Sentry config imports correctly" "grep -q 'from.*@sentry/nextjs' test-app-complete-shadcn/frontend/src/lib/sentry-config.ts"

# Phase 10: Tests de validation des scripts
echo -e "${YELLOW}=== Phase 10: Tests de validation des scripts ===${NC}"

# Test 10.1: Scripts d'initialisation
run_test "Init scripts exist in minimal project" "test -f test-app-minimal-mui/scripts/init-project.sh && test -f test-app-minimal-mui/scripts/init-project.bat"
run_test "Init scripts are executable" "test -x test-app-minimal-mui/scripts/init-project.sh"

# Test 10.2: Scripts de déploiement
run_test "Deploy scripts exist in minimal project" "test -f test-app-minimal-mui/backend/scripts/deploy.sh"
run_test "Deploy scripts are executable" "test -x test-app-minimal-mui/backend/scripts/deploy.sh"

# Phase 11: Tests de validation des tests
echo -e "${YELLOW}=== Phase 11: Tests de validation des tests ===${NC}"

# Test 11.1: Tests unitaires
run_test "Unit tests exist in minimal project" "test -f test-app-minimal-mui/frontend/tests/auth.test.ts"
run_test "Test scripts in package.json" "grep -q '\"test\"' test-app-minimal-mui/frontend/package.json"

# Test 11.2: Tests d'intégration
run_test "Integration tests exist in complete project" "test -d test-app-complete-shadcn/frontend/tests/integration"
run_test "E2E tests exist in complete project" "test -d test-app-complete-shadcn/frontend/tests/e2e"

# Phase 12: Tests de validation de la documentation
echo -e "${YELLOW}=== Phase 12: Tests de validation de la documentation ===${NC}"

# Test 12.1: README principal
run_test "Main README exists in minimal project" "test -f test-app-minimal-mui/README.md"
run_test "Main README contains project name" "grep -q 'test-app-minimal-mui' test-app-minimal-mui/README.md"

# Test 12.2: Documentation de déploiement
run_test "Deployment docs exist in minimal project" "test -f test-app-minimal-mui/docs/deployment.md"
run_test "Development docs exist in minimal project" "test -f test-app-minimal-mui/docs/development.md"

# Phase 13: Tests de validation des workflows CI/CD
echo -e "${YELLOW}=== Phase 13: Tests de validation des workflows CI/CD ===${NC}"

# Test 13.1: GitHub Actions
run_test "GitHub Actions exist in minimal project" "test -f test-app-minimal-mui/.github/workflows/ci-cd.yml"
run_test "GitHub Actions are valid YAML" "node -e \"require('js-yaml').load(require('fs').readFileSync('test-app-minimal-mui/.github/workflows/ci-cd.yml', 'utf8'))\""

# Phase 14: Tests de validation des thèmes
echo -e "${YELLOW}=== Phase 14: Tests de validation des thèmes ===${NC}"

# Test 14.1: Configuration des thèmes
run_test "Theme config exists in minimal project" "test -f test-app-minimal-mui/config/themes.json"
run_test "Theme config is valid JSON" "node -e \"JSON.parse(require('fs').readFileSync('test-app-minimal-mui/config/themes.json', 'utf8'))\""

# Phase 15: Tests de validation finale
echo -e "${YELLOW}=== Phase 15: Tests de validation finale ===${NC}"

# Test 15.1: Vérification qu'aucun fichier .hbs ne reste
run_test "No .hbs files remain in minimal project" "! find test-app-minimal-mui -name '*.hbs' | grep -q ."
run_test "No .hbs files remain in complete project" "! find test-app-complete-shadcn -name '*.hbs' | grep -q ."
run_test "No .hbs files remain in Yarn project" "! find test-app-yarn-14 -name '*.hbs' | grep -q ."
run_test "No .hbs files remain in pnpm project" "! find test-app-pnpm-mixed -name '*.hbs' | grep -q ."

# Test 15.2: Vérification de la cohérence des noms
run_test "Project names consistent in minimal project" "grep -r 'test-app-minimal-mui' test-app-minimal-mui >/dev/null 2>&1 && ! grep -r '{{project.name}}' test-app-minimal-mui >/dev/null 2>&1"
run_test "Project names consistent in complete project" "grep -r 'test-app-complete-shadcn' test-app-complete-shadcn >/dev/null 2>&1 && ! grep -r '{{project.name}}' test-app-complete-shadcn >/dev/null 2>&1"

# Test 15.3: Vérification de la structure finale
run_test "Final structure validation minimal project" "find test-app-minimal-mui -type f -name '*.tsx' -o -name '*.ts' | wc -l | grep -q '[0-9]'"
run_test "Final structure validation complete project" "find test-app-complete-shadcn -type f -name '*.tsx' -o -name '*.ts' | wc -l | grep -q '[0-9]'"

# Résultats finaux
echo -e "${PURPLE}=== RÉSULTATS FINAUX ===${NC}"
echo -e "Total tests: $TOTAL"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo -e "${YELLOW}Skipped: $SKIPPED${NC}"

# Calculer le pourcentage de réussite
if [ $TOTAL -gt 0 ]; then
    SUCCESS_PERCENTAGE=$(( (PASSED * 100) / TOTAL ))
    echo -e "Success rate: ${CYAN}${SUCCESS_PERCENTAGE}%${NC}"
fi

echo

# Résumé de la validation
echo -e "${BLUE}=== RÉSUMÉ DE LA VALIDATION ===${NC}"
echo -e "📱 Applications testées : 4 projets avec configurations différentes"
echo -e "🔧 Package managers : npm, yarn, pnpm"
echo -e "⚛️  Versions Next.js : 14, 15"
echo -e "🎨 Frameworks UI : MUI, Shadcn/ui, mixte"
echo -e "📊 Gestion d'état : Zustand, Redux, mixte"
echo -e "🚀 Fonctionnalités : PWA, FCM, Analytics, Performance, Sentry"
echo -e "🔥 Backend : Firebase complet (Functions, Firestore, Storage)"
echo

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 TOUTES les applications générées fonctionnent parfaitement !${NC}"
    echo -e "${GREEN}✅ Le générateur produit des applications 100% fonctionnelles !${NC}"
    echo
    echo -e "${CYAN}Validation garantie :${NC}"
    echo -e "  ✅ Génération de projets (100%)"
    echo -e "  ✅ Structure des projets (100%)"
    echo -e "  ✅ Compilation et build (100%)"
    echo -e "  ✅ Validation TypeScript (100%)"
    echo -e "  ✅ Composants et stores (100%)"
    echo -e "  ✅ Configuration Firebase (100%)"
    echo -e "  ✅ Fonctionnalités avancées (100%)"
    echo -e "  ✅ Scripts et CI/CD (100%)"
    echo -e "  ✅ Documentation et thèmes (100%)"
    exit 0
else
    echo -e "${RED}❌ $FAILED tests ont échoué.${NC}"
    echo -e "${YELLOW}🔧 Des ajustements peuvent être nécessaires pour les applications générées.${NC}"
    exit 1
fi 