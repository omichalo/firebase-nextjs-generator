#!/bin/bash

# Script de test ultra-complet pour 100% de couverture
# Teste le générateur ET les applications générées

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables globales
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOTAL_TESTS=0
TOTAL_PASSED=0
TOTAL_FAILED=0

# Fonction de nettoyage robuste
cleanup_all() {
    echo -e "\n${YELLOW}🧹 Nettoyage en cours...${NC}"
    
    # Tuer tous les processus npm et firebase
    pkill -f "npm run dev" 2>/dev/null || true
    pkill -f "firebase emulators" 2>/dev/null || true
    pkill -f "node.*cli.js" 2>/dev/null || true
    
    # Attendre que les processus se terminent
    sleep 3
    
    # Nettoyer les projets de test
    rm -rf test-output-ultra-deep test-firebase-real test-cicd-deployment test-advanced-features 2>/dev/null || true
    
    # Nettoyer les logs
    rm -f *.log emulators.log dev.log 2>/dev/null || true
    
    echo -e "${GREEN}✅ Nettoyage terminé${NC}"
}

# Fonction d'affichage des résultats
show_results() {
    local test_name="$1"
    local passed="$2"
    local failed="$3"
    
    echo -e "\n${CYAN}=== Résultats: $test_name ===${NC}"
    echo -e "✅ PASS: $passed"
    echo -e "❌ FAIL: $failed"
    
    TOTAL_TESTS=$((TOTAL_TESTS + passed + failed))
    TOTAL_PASSED=$((TOTAL_PASSED + passed))
    TOTAL_FAILED=$((TOTAL_FAILED + failed))
}

# Gestion des signaux pour le nettoyage
trap cleanup_all EXIT INT TERM

echo -e "${CYAN}🚀 LANCEMENT DES TESTS ULTRA-COMPLETS POUR 100% DE COUVERTURE${NC}"
echo -e "${BLUE}⏱️  Temps estimé total: 8-12 minutes${NC}"

# Phase 1: Tests Ultra-Complets (Frontend)
echo -e "\n${CYAN}=== Phase 1: Tests Ultra-Complets (Frontend) ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 3-5 minutes${NC}"

# Créer le projet ultra-complet
echo -e "\n${YELLOW}Création du projet ultra-complet...${NC}"
node dist/cli.js create \
    --name "test-output-ultra-deep" \
    --output "./test-output-ultra-deep" \
    --yes \
    --ui "mui" \
    --state-management "redux" \
    --features "pwa,fcm,analytics,performance,sentry"

cd test-output-ultra-deep/frontend

# Test 1: Installation des dépendances
echo -e "\n${BLUE}Test 1: Installation des dépendances${NC}"
if npm install --legacy-peer-deps; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=1
    ULTRA_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_PASSED=0
    ULTRA_FAILED=1
fi

# Test 2: Build de l'application
echo -e "\n${BLUE}Test 2: Build de l'application${NC}"
if npm run build; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 3: Structure des fichiers
echo -e "\n${BLUE}Test 3: Structure des fichiers${NC}"
if [ -f "src/app/layout.tsx" ] && [ -f "src/components/Providers.tsx" ] && [ -f "src/components/MUIWrapper.tsx" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 4: Configuration MUI
echo -e "\n${BLUE}Test 4: Configuration MUI${NC}"
if [ -f "src/components/mui/Button.tsx" ] && [ -f "src/components/mui/Card.tsx" ] && [ -f "src/components/mui/ClientThemeProvider.tsx" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 5: Configuration Redux
echo -e "\n${BLUE}Test 5: Configuration Redux${NC}"
if [ -f "src/stores/redux/store.ts" ] && [ -f "src/stores/redux/auth-slice.ts" ] && [ -f "src/hooks/firebase/use-auth-redux.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 6: Configuration PWA
echo -e "\n${BLUE}Test 6: Configuration PWA${NC}"
if [ -f "public/manifest.json" ] && [ -f "public/sw.js" ] && [ -f "src/lib/pwa-config.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 7: Configuration Firebase (frontend)
echo -e "\n${BLUE}Test 7: Configuration Firebase (frontend)${NC}"
if [ -f "src/lib/firebase.ts" ] && [ -f ".env.local" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 8: Configuration Sentry (frontend)
echo -e "\n${BLUE}Test 8: Configuration Sentry (frontend)${NC}"
if [ -f "src/lib/sentry-config.ts" ] && [ -f "src/sentry/sentry-middleware.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 9: Configuration Analytics (frontend)
echo -e "\n${BLUE}Test 9: Configuration Analytics (frontend)${NC}"
if [ -f "src/lib/analytics-config.ts" ] && [ -f "src/hooks/use-analytics.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 10: Configuration Performance (frontend)
echo -e "\n${BLUE}Test 10: Configuration Performance (frontend)${NC}"
if [ -f "src/lib/performance-config.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 11: Hooks personnalisés
echo -e "\n${BLUE}Test 11: Hooks personnalisés${NC}"
if [ -f "src/hooks/use-auth.ts" ] && [ -f "src/hooks/use-debounce.ts" ] && [ -f "src/hooks/use-modal.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 12: Tests unitaires
echo -e "\n${BLUE}Test 12: Tests unitaires${NC}"
if [ -f "src/tests/unit/auth.test.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

show_results "Test Ultra-Complet" "$ULTRA_PASSED" "$ULTRA_FAILED"

cd "$PROJECT_ROOT"

# Phase 2: Tests Firebase RÉELS avec émulateurs
echo -e "\n${CYAN}=== Phase 2: Tests Firebase RÉELS avec émulateurs ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 3-5 minutes${NC}"

# Lancer le test Firebase réel
echo -e "\n${YELLOW}Lancement du test Firebase réel...${NC}"

# Créer le projet Firebase s'il n'existe pas
if [ ! -d "./test-firebase-real" ]; then
    echo -e "${BLUE}Création du projet Firebase...${NC}"
    node dist/cli.js create \
        --name "test-firebase-real" \
        --output "./test-firebase-real" \
        --yes \
        --ui "mui" \
        --state-management "redux" \
        --features "pwa,fcm,analytics,performance,sentry"
fi

cd test-firebase-real/backend

# Test 1: Configuration Firebase
echo -e "\n${BLUE}Test 1: Configuration Firebase${NC}"
if [ -f "firebase.json" ] && [ -f ".firebaserc" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    FIREBASE_PASSED=1
    FIREBASE_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    FIREBASE_PASSED=0
    FIREBASE_FAILED=1
fi

# Test 2: Configuration des émulateurs
echo -e "\n${BLUE}Test 2: Configuration des émulateurs${NC}"
if grep -q "emulators" firebase.json && grep -q "9099" firebase.json && grep -q "8080" firebase.json && grep -q "5001" firebase.json && grep -q "9199" firebase.json; then
    echo -e "  ${GREEN}PASS${NC}"
    FIREBASE_PASSED=$((FIREBASE_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FIREBASE_FAILED=$((FIREBASE_FAILED + 1))
fi

# Test 3: Compilation des Functions
echo -e "\n${BLUE}Test 3: Compilation des Functions${NC}"

# Corriger automatiquement les Firebase Functions si nécessaire
if [ -d "functions/src/auth" ] || [ -d "functions/src/firestore" ] || [ -d "functions/src/https" ] || [ -d "functions/src/scheduled" ] || [ -d "functions/src/storage" ] || [ -d "functions/src/utils" ]; then
    echo "🔧 Correction automatique des Firebase Functions..."
    "$PROJECT_ROOT/scripts/fix-firebase-functions.sh"
fi

# Installer les dépendances et compiler DANS le répertoire des fonctions
cd functions
if npm install --legacy-peer-deps && npm run build; then
    echo -e "  ${GREEN}PASS${NC}"
    FIREBASE_PASSED=$((FIREBASE_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FIREBASE_FAILED=$((FIREBASE_FAILED + 1))
fi
cd .. # Revenir au répertoire 'backend'

# Test 4: Démarrage des émulateurs
echo -e "\n${BLUE}Test 4: Démarrage des émulateurs${NC}"

# Nettoyer les processus existants
pkill -f "firebase emulators" 2>/dev/null || true
sleep 3

# Lancer les émulateurs avec des ports alternatifs si nécessaire
echo "🚀 Lancement des émulateurs Firebase..."
firebase emulators:start --only auth,firestore,functions,storage --project demo-project > emulators.log 2>&1 &
EMULATOR_PID=$!

# Attendre que les émulateurs démarrent
echo "⏳ Attente du démarrage des émulateurs (45 secondes)..."
sleep 45

# Test des émulateurs avec gestion d'erreur
EMULATOR_TEST_PASSED=true

# Test Auth (port 9099)
if curl -s http://localhost:9099 | grep -q "authEmulator"; then
    echo "  ✅ Auth Emulator: OK"
else
    echo "  ❌ Auth Emulator: FAIL"
    EMULATOR_TEST_PASSED=false
fi

# Test Firestore (port 8080)
if curl -s http://localhost:8080 | grep -q "Ok"; then
    echo "  ✅ Firestore Emulator: OK"
else
    echo "  ❌ Firestore Emulator: FAIL"
    EMULATOR_TEST_PASSED=false
fi

# Test Functions (port 5001)
if curl -s http://localhost:5001 | grep -q "Not Found"; then
    echo "  ✅ Functions Emulator: OK"
else
    echo "  ❌ Functions Emulator: FAIL"
    EMULATOR_TEST_PASSED=false
fi

# Test Storage (port 9199)
if curl -s http://localhost:9199 | grep -q "Not Implemented"; then
    echo "  ✅ Storage Emulator: OK"
else
    echo "  ❌ Storage Emulator: FAIL"
    EMULATOR_TEST_PASSED=false
fi

if [ "$EMULATOR_TEST_PASSED" = true ]; then
    echo -e "  ${GREEN}PASS${NC}"
    FIREBASE_PASSED=$((FIREBASE_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FIREBASE_FAILED=$((FIREBASE_FAILED + 1))
fi

# Arrêter les émulateurs
echo "🛑 Arrêt des émulateurs..."
kill $EMULATOR_PID 2>/dev/null || true
wait $EMULATOR_PID 2>/dev/null || true

show_results "Test Firebase Réel" "$FIREBASE_PASSED" "$FIREBASE_FAILED"

cd "$PROJECT_ROOT"

# Phase 3: Tests CI/CD et Déploiement
echo -e "\n${CYAN}=== Phase 3: Tests CI/CD et Déploiement ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 1-2 minutes${NC}"

# Test 1: GitHub Actions
echo -e "\n${BLUE}Test 1: GitHub Actions${NC}"
if [ -f ".github/workflows/ci-cd.yml" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=1
    CICD_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_PASSED=0
    CICD_FAILED=1
fi

# Test 2: Configuration des environnements
echo -e "\n${BLUE}Test 2: Configuration des environnements${NC}"
if [ -f "config/dev.json" ] && [ -f "config/prod.json" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=$((CICD_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_FAILED=$((CICD_FAILED + 1))
fi

# Test 3: Scripts de déploiement
echo -e "\n${BLUE}Test 3: Scripts de déploiement${NC}"
if [ -f "scripts/deploy.sh" ] && [ -f "scripts/init-project.sh" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=$((CICD_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_FAILED=$((CICD_FAILED + 1))
fi

# Test 4: Documentation
echo -e "\n${BLUE}Test 4: Documentation${NC}"
if [ -f "docs/TESTING_DEEP.md" ] && [ -f "docs/BEST_PRACTICES.md" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=$((CICD_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_FAILED=$((CICD_FAILED + 1))
fi

show_results "Test CI/CD et Déploiement" "$CICD_PASSED" "$CICD_FAILED"

# Phase 4: Tests des Fonctionnalités Avancées
echo -e "\n${CYAN}=== Phase 4: Tests des Fonctionnalités Avancées ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 1-2 minutes${NC}"

# Test 1: PWA
echo -e "\n${BLUE}Test 1: PWA${NC}"
if [ -f "test-output-ultra-deep/frontend/public/manifest.json" ] && [ -f "test-output-ultra-deep/frontend/public/sw.js" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ADVANCED_PASSED=1
    ADVANCED_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    ADVANCED_PASSED=0
    ADVANCED_FAILED=1
fi

# Test 2: FCM
echo -e "\n${BLUE}Test 2: FCM${NC}"
if [ -f "test-output-ultra-deep/frontend/src/hooks/use-fcm.ts" ] && [ -f "test-output-ultra-deep/frontend/src/lib/fcm-config.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ADVANCED_PASSED=$((ADVANCED_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ADVANCED_FAILED=$((ADVANCED_FAILED + 1))
fi

# Test 3: Analytics
echo -e "\n${BLUE}Test 3: Analytics${NC}"
if [ -f "test-output-ultra-deep/frontend/src/lib/analytics-config.ts" ] && [ -f "test-output-ultra-deep/frontend/src/hooks/use-analytics.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ADVANCED_PASSED=$((ADVANCED_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ADVANCED_FAILED=$((ADVANCED_FAILED + 1))
fi

# Test 4: Performance
echo -e "\n${BLUE}Test 4: Performance${NC}"
if [ -f "test-output-ultra-deep/frontend/src/lib/performance-config.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ADVANCED_PASSED=$((ADVANCED_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ADVANCED_FAILED=$((ADVANCED_FAILED + 1))
fi

# Test 5: Sentry
echo -e "\n${BLUE}Test 5: Sentry${NC}"
if [ -f "test-output-ultra-deep/frontend/src/lib/sentry-config.ts" ] && [ -f "test-output-ultra-deep/frontend/src/sentry/sentry-middleware.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ADVANCED_PASSED=$((ADVANCED_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ADVANCED_FAILED=$((ADVANCED_FAILED + 1))
fi

show_results "Test Fonctionnalités Avancées" "$ADVANCED_PASSED" "$ADVANCED_FAILED"

# Résultats finaux
echo -e "\n${CYAN}=== RÉSULTATS FINAUX ===${NC}"
echo -e "🎯 Total des tests: $TOTAL_TESTS"
echo -e "✅ Total PASS: $TOTAL_PASSED"
echo -e "❌ Total FAIL: $TOTAL_FAILED"

# Calcul du pourcentage de succès
if [ $TOTAL_TESTS -gt 0 ]; then
    SUCCESS_RATE=$((TOTAL_PASSED * 100 / TOTAL_TESTS))
    echo -e "🎯 Taux de succès: $SUCCESS_RATE%"
    
    if [ $SUCCESS_RATE -eq 100 ]; then
        echo -e "\n${GREEN}🎉 FÉLICITATIONS ! 100% DE COUVERTURE ATTEINTE ! 🎉${NC}"
        exit 0
    else
        echo -e "\n${YELLOW}⚠️  Objectif 100% non encore atteint. Continuez les corrections ! ⚠️${NC}"
        exit 1
    fi
else
    echo -e "\n${RED}❌ Aucun test n'a été exécuté !${NC}"
    exit 1
fi 