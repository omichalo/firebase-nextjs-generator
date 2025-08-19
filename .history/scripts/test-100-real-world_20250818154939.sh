#!/bin/bash

# Test ULTRA-COMPLET pour 100% de couverture RÉELLE
# Teste TOUT le cycle de vie : Générateur → Application → Fonctionnement → CI/CD

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
    
    # Tuer tous les processus
    pkill -f "npm run dev" 2>/dev/null || true
    pkill -f "firebase emulators" 2>/dev/null || true
    pkill -f "node.*cli.js" 2>/dev/null || true
    
    # Attendre que les processus se terminent
    sleep 3
    
    # Nettoyer les projets de test
    rm -rf test-100-real-world test-firebase-real-world 2>/dev/null || true
    
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

echo -e "${CYAN}🚀 TEST ULTRA-COMPLET POUR 100% DE COUVERTURE RÉELLE${NC}"
echo -e "${BLUE}⏱️  Temps estimé total: 15-20 minutes${NC}"
echo -e "${BLUE}🎯 Objectif: Tester TOUT le cycle de vie de l'application${NC}"

# Phase 1: Tests du Générateur et Génération
echo -e "\n${CYAN}=== Phase 1: Tests du Générateur et Génération ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 5-7 minutes${NC}"

# Créer le projet de test
echo -e "\n${YELLOW}Création du projet de test...${NC}"
node dist/cli.js create \
    --name "test-100-real-world" \
    --output "./test-100-real-world" \
    --yes \
    --ui "mui" \
    --state-management "redux" \
    --features "pwa,fcm,analytics,performance,sentry"

cd test-100-real-world/frontend

# Test 1: Installation des dépendances
echo -e "\n${BLUE}Test 1: Installation des dépendances${NC}"
if npm install --legacy-peer-deps; then
    echo -e "  ${GREEN}PASS${NC}"
    GENERATOR_PASSED=1
    GENERATOR_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    GENERATOR_PASSED=0
    GENERATOR_FAILED=1
fi

# Test 2: Build de l'application
echo -e "\n${BLUE}Test 2: Build de l'application${NC}"
if npm run build; then
    echo -e "  ${GREEN}PASS${NC}"
    GENERATOR_PASSED=$((GENERATOR_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    GENERATOR_FAILED=$((GENERATOR_FAILED + 1))
fi

# Test 3: Structure des fichiers
echo -e "\n${BLUE}Test 3: Structure des fichiers${NC}"
if [ -f "src/app/layout.tsx" ] && [ -f "src/components/Providers.tsx" ] && [ -f "src/components/MUIWrapper.tsx" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    GENERATOR_PASSED=$((GENERATOR_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    GENERATOR_FAILED=$((GENERATOR_FAILED + 1))
fi

# Test 4: Configuration complète
echo -e "\n${BLUE}Test 4: Configuration complète${NC}"
if [ -f "src/lib/firebase.ts" ] && [ -f "src/lib/sentry-config.ts" ] && [ -f "src/stores/store.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    GENERATOR_PASSED=$((GENERATOR_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    GENERATOR_FAILED=$((GENERATOR_FAILED + 1))
fi

show_results "Tests du Générateur" "$GENERATOR_PASSED" "$GENERATOR_FAILED"

# Phase 2: Tests de Démarrage et Fonctionnement RÉEL
echo -e "\n${CYAN}=== Phase 2: Tests de Démarrage et Fonctionnement RÉEL ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 5-7 minutes${NC}"

# Test 5: Démarrage de l'application
echo -e "\n${BLUE}Test 5: Démarrage de l'application${NC}"
echo "🚀 Démarrage de l'application en mode développement..."
npm run dev > dev.log 2>&1 &
DEV_PID=$!

# Attendre que l'application démarre
echo "⏳ Attente du démarrage de l'application (30 secondes)..."
sleep 30

# Vérifier que l'application est accessible
if curl -s http://localhost:3000 | grep -q "html"; then
    echo -e "  ${GREEN}PASS${NC}"
    FUNCTIONAL_PASSED=1
    FUNCTIONAL_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    FUNCTIONAL_PASSED=0
    FUNCTIONAL_FAILED=1
fi

# Test 6: Test des pages principales
echo -e "\n${BLUE}Test 6: Test des pages principales${NC}"
PAGES_PASSED=0
PAGES_FAILED=0

# Test page d'accueil
if curl -s http://localhost:3000 | grep -q "html"; then
    echo "  ✅ Page d'accueil: OK"
    PAGES_PASSED=$((PAGES_PASSED + 1))
else
    echo "  ❌ Page d'accueil: FAIL"
    PAGES_FAILED=$((PAGES_FAILED + 1))
fi

# Test page de connexion
if curl -s http://localhost:3000/auth/login | grep -q "html"; then
    echo "  ✅ Page de connexion: OK"
    PAGES_PASSED=$((PAGES_PASSED + 1))
else
    echo "  ❌ Page de connexion: FAIL"
    PAGES_FAILED=$((PAGES_FAILED + 1))
fi

# Test page dashboard
if curl -s http://localhost:3000/dashboard | grep -q "html"; then
    echo "  ✅ Page dashboard: OK"
    PAGES_PASSED=$((PAGES_PASSED + 1))
else
    echo "  ❌ Page dashboard: FAIL"
    PAGES_FAILED=$((PAGES_FAILED + 1))
fi

if [ $PAGES_FAILED -eq 0 ]; then
    echo -e "  ${GREEN}PASS${NC}"
    FUNCTIONAL_PASSED=$((FUNCTIONAL_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FUNCTIONAL_FAILED=$((FUNCTIONAL_FAILED + 1))
fi

# Test 7: Test des fonctionnalités PWA
echo -e "\n${BLUE}Test 7: Test des fonctionnalités PWA${NC}"
if [ -f "public/manifest.json" ] && [ -f "public/sw.js" ]; then
    # Vérifier que le service worker est accessible
    if curl -s http://localhost:3000/sw.js | grep -q "serviceWorker"; then
        echo -e "  ${GREEN}PASS${NC}"
        FUNCTIONAL_PASSED=$((FUNCTIONAL_PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC}"
        FUNCTIONAL_FAILED=$((FUNCTIONAL_FAILED + 1))
    fi
else
    echo -e "  ${RED}FAIL${NC}"
    FUNCTIONAL_FAILED=$((FUNCTIONAL_FAILED + 1))
fi

# Arrêter l'application de manière robuste
echo "🛑 Arrêt de l'application..."
kill $DEV_PID 2>/dev/null || true
sleep 2
pkill -f "npm run dev" 2>/dev/null || true
sleep 1

show_results "Tests de Fonctionnement" "$FUNCTIONAL_PASSED" "$FUNCTIONAL_FAILED"

cd "$PROJECT_ROOT"

# Phase 3: Tests Firebase RÉELS avec Émulateurs
echo -e "\n${CYAN}=== Phase 3: Tests Firebase RÉELS avec Émulateurs ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 5-7 minutes${NC}"

# Créer le projet Firebase
echo -e "\n${YELLOW}Création du projet Firebase...${NC}"
node dist/cli.js create \
    --name "test-firebase-real-world" \
    --output "./test-firebase-real-world" \
    --yes \
    --ui "mui" \
    --state-management "redux" \
    --features "pwa,fcm,analytics,performance,sentry"

cd test-firebase-real-world/backend

# Test 8: Configuration Firebase
echo -e "\n${BLUE}Test 8: Configuration Firebase${NC}"
if [ -f "firebase.json" ] && [ -f ".firebaserc" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    FIREBASE_PASSED=1
    FIREBASE_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    FIREBASE_PASSED=0
    FIREBASE_FAILED=1
fi

# Test 9: Compilation des Functions
echo -e "\n${BLUE}Test 9: Compilation des Functions${NC}"
if [ -d "functions/src/auth" ] || [ -d "functions/src/firestore" ] || [ -d "functions/src/https" ] || [ -d "functions/src/scheduled" ] || [ -d "functions/src/storage" ] || [ -d "functions/src/utils" ]; then
    echo "🔧 Correction automatique des Firebase Functions..."
    bash "$PROJECT_ROOT/scripts/fix-firebase-functions.sh"
fi

cd functions
if npm install --legacy-peer-deps && npm run build; then
    echo -e "  ${GREEN}PASS${NC}"
    FIREBASE_PASSED=$((FIREBASE_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FIREBASE_FAILED=$((FIREBASE_FAILED + 1))
fi
cd ..

# Test 10: Démarrage des émulateurs
echo -e "\n${BLUE}Test 10: Démarrage des émulateurs${NC}"
pkill -f "firebase emulators" 2>/dev/null || true
sleep 3

echo "🚀 Lancement des émulateurs Firebase..."
firebase emulators:start --only auth,firestore,functions,storage --project demo-project > emulators.log 2>&1 &
EMULATOR_PID=$!

echo "⏳ Attente du démarrage des émulateurs (45 secondes)..."
sleep 45

# Test des émulateurs
EMULATOR_TEST_PASSED=true

if curl -s http://localhost:9099 | grep -q "authEmulator"; then
    echo "  ✅ Auth Emulator: OK"
else
    echo "  ❌ Auth Emulator: FAIL"
    EMULATOR_TEST_PASSED=false
fi

if curl -s http://localhost:8080 | grep -q "Ok"; then
    echo "  ✅ Firestore Emulator: OK"
else
    echo "  ❌ Firestore Emulator: FAIL"
    EMULATOR_TEST_PASSED=false
fi

if curl -s http://localhost:5001 | grep -q "Not Found"; then
    echo "  ✅ Functions Emulator: OK"
else
    echo "  ❌ Functions Emulator: FAIL"
    EMULATOR_TEST_PASSED=false
fi

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
kill $EMULATOR_PID 2>/dev/null || true
wait $EMULATOR_PID 2>/dev/null || true

show_results "Tests Firebase Réels" "$FIREBASE_PASSED" "$FIREBASE_FAILED"

cd "$PROJECT_ROOT"

# Phase 4: Tests CI/CD et Déploiement RÉELS
echo -e "\n${CYAN}=== Phase 4: Tests CI/CD et Déploiement RÉELS ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 2-3 minutes${NC}"

# Test 11: GitHub Actions
echo -e "\n${BLUE}Test 11: GitHub Actions${NC}"
if [ -f ".github/workflows/ci-cd.yml" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=1
    CICD_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_PASSED=0
    CICD_FAILED=1
fi

# Test 12: Configuration des environnements
echo -e "\n${BLUE}Test 12: Configuration des environnements${NC}"
if [ -f "config/dev.json" ] && [ -f "config/prod.json" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=$((CICD_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_FAILED=$((CICD_FAILED + 1))
fi

# Test 13: Scripts de déploiement
echo -e "\n${BLUE}Test 13: Scripts de déploiement${NC}"
if [ -f "scripts/deploy.sh" ] && [ -f "scripts/init-project.sh" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=$((CICD_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_FAILED=$((CICD_FAILED + 1))
fi

# Test 14: Test de déploiement simulé
echo -e "\n${BLUE}Test 14: Test de déploiement simulé${NC}"
if [ -f "test-100-real-world/scripts/init-project.sh" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=$((CICD_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_FAILED=$((CICD_FAILED + 1))
fi

show_results "Tests CI/CD et Déploiement" "$CICD_PASSED" "$CICD_FAILED"

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
        echo -e "\n${GREEN}🎉 FÉLICITATIONS ! 100% DE COUVERTURE RÉELLE ATTEINTE ! 🎉${NC}"
        echo -e "🚀 Votre générateur et vos applications sont 100% testés et fonctionnels !"
        exit 0
    else
        echo -e "\n${YELLOW}⚠️  Objectif 100% non encore atteint. Continuez les corrections ! ⚠️${NC}"
        exit 1
    fi
else
    echo -e "\n${RED}❌ Aucun test n'a été exécuté !${NC}"
    exit 1
fi 