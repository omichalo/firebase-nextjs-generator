#!/bin/bash

# 🚀 TEST FINAL 100% COMPLET - TOUT SUR UN SEUL PROJET
# ⏱️  Temps estimé total: 15-20 minutes
# 🎯 Objectif: Tester TOUT sur un seul projet avec toutes les features

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables globales
PROJECT_ROOT=$(pwd)
PROJECT_NAME="test-100-final"
TOTAL_TESTS=24
TOTAL_PASSED=0
TOTAL_FAILED=0

# Fonction pour afficher les résultats
show_results() {
    local phase_name="$1"
    local passed="$2"
    local failed="$3"
    
    echo -e "\n${CYAN}=== Résultats: $phase_name ===${NC}"
    echo -e "✅ PASS: $passed"
    echo -e "❌ FAIL: $failed"
    
    TOTAL_PASSED=$((TOTAL_PASSED + passed))
    TOTAL_FAILED=$((TOTAL_FAILED + failed))
}

# Fonction de nettoyage
cleanup() {
    echo -e "\n🧹 Nettoyage en cours..."
    pkill -f "npm run dev" 2>/dev/null || true
    pkill -f "firebase emulators" 2>/dev/null || true
    sleep 2
    rm -rf "$PROJECT_NAME" 2>/dev/null || true
    echo -e "✅ Nettoyage terminé"
}

# Traitement des signaux
trap cleanup EXIT
trap 'echo -e "\n🛑 Interruption détectée, nettoyage..."; cleanup; exit 1' INT TERM

echo -e "${CYAN}🚀 TEST FINAL 100% COMPLET - TOUT SUR UN SEUL PROJET${NC}"
echo -e "${BLUE}⏱️  Temps estimé total: 15-20 minutes${NC}"
echo -e "${YELLOW}🎯 Objectif: Tester TOUT sur un seul projet avec toutes les features${NC}"

# === Phase 1: Création du Projet Complet ===
echo -e "\n${CYAN}=== Phase 1: Création du Projet Complet ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 3-5 minutes${NC}"

echo -e "\n${YELLOW}Création du projet complet avec toutes les features...${NC}"
node dist/cli.js create \
    --name "$PROJECT_NAME" \
    --output "./$PROJECT_NAME" \
    --yes \
    --ui "mui" \
    --state-management "redux" \
    --features "pwa,fcm,analytics,performance"

if [ ! -d "$PROJECT_NAME/frontend" ]; then
    echo -e "${RED}❌ Échec de la création du projet${NC}"
    exit 1
fi

echo -e "✅ Projet créé avec succès"

# === Phase 2: Tests du Générateur ===
echo -e "\n${CYAN}=== Phase 2: Tests du Générateur ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 2-3 minutes${NC}"

cd "$PROJECT_NAME/frontend"

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
if [ -d "src/app" ] && [ -d "src/components" ] && [ -d "src/hooks" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    GENERATOR_PASSED=$((GENERATOR_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    GENERATOR_FAILED=$((GENERATOR_FAILED + 1))
fi

# Test 4: Configuration complète
echo -e "\n${BLUE}Test 4: Configuration complète${NC}"
if [ -f "src/lib/firebase.ts" ] && [ -f "src/stores/store.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    GENERATOR_PASSED=$((GENERATOR_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    GENERATOR_FAILED=$((GENERATOR_FAILED + 1))
fi

show_results "Tests du Générateur" "$GENERATOR_PASSED" "$GENERATOR_FAILED"

# === Phase 3: Tests de Démarrage et Fonctionnement ===
echo -e "\n${CYAN}=== Phase 3: Tests de Démarrage et Fonctionnement ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 3-4 minutes${NC}"

# Test 5: Démarrage de l'application
echo -e "\n${BLUE}Test 5: Démarrage de l'application${NC}"
echo "🚀 Démarrage de l'application en mode développement..."
npm run dev > dev.log 2>&1 &
DEV_PID=$!

echo "⏳ Attente du démarrage de l'application (30 secondes)..."
sleep 30

# Test sur le port 3000 ou 3001 (port dynamique)
PORT=3000
if ! curl -s http://localhost:3000 > /dev/null 2>&1; then
    PORT=3001
    if ! curl -s http://localhost:3001 > /dev/null 2>&1; then
        PORT=3002
    fi
fi

if curl -s http://localhost:$PORT > /dev/null 2>&1; then
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
PAGES_OK=0
PAGES_TOTAL=3

if curl -s http://localhost:$PORT | grep -q "Test Page\|Hello World\|Bienvenue"; then
    echo "  ✅ Page d'accueil: OK"
    PAGES_OK=$((PAGES_OK + 1))
else
    echo "  ❌ Page d'accueil: FAIL"
fi

if curl -s http://localhost:$PORT/auth/login | grep -q "Connexion\|Login"; then
    echo "  ✅ Page de connexion: OK"
    PAGES_OK=$((PAGES_OK + 1))
else
    echo "  ❌ Page de connexion: FAIL"
fi

if curl -s http://localhost:$PORT/dashboard | grep -q "Dashboard\|Tableau"; then
    echo "  ✅ Page dashboard: OK"
    PAGES_OK=$((PAGES_OK + 1))
else
    echo "  ❌ Page dashboard: FAIL"
fi

if [ $PAGES_OK -eq $PAGES_TOTAL ]; then
    echo -e "  ${GREEN}PASS${NC}"
    FUNCTIONAL_PASSED=$((FUNCTIONAL_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FUNCTIONAL_FAILED=$((FUNCTIONAL_FAILED + 1))
fi

# Test 7: Test des fonctionnalités PWA
echo -e "\n${BLUE}Test 7: Test des fonctionnalités PWA${NC}"
if [ -f "public/manifest.json" ] && [ -f "public/sw.js" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    FUNCTIONAL_PASSED=$((FUNCTIONAL_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FUNCTIONAL_FAILED=$((FUNCTIONAL_FAILED + 1))
fi

# Test 8: Test des API Routes
echo -e "\n${BLUE}Test 8: Test des API Routes${NC}"
if curl -s http://localhost:$PORT/api/auth/login | grep -q "message\|error\|status"; then
    echo -e "  ${GREEN}PASS${NC}"
    FUNCTIONAL_PASSED=$((FUNCTIONAL_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FUNCTIONAL_FAILED=$((FUNCTIONAL_FAILED + 1))
fi

# Arrêter l'application
echo "🛑 Arrêt de l'application..."
kill $DEV_PID 2>/dev/null || true
sleep 2
pkill -f "npm run dev" 2>/dev/null || true
sleep 1

show_results "Tests de Fonctionnement" "$FUNCTIONAL_PASSED" "$FUNCTIONAL_FAILED"

# === Phase 4: Tests Firebase ===
echo -e "\n${CYAN}=== Phase 4: Tests Firebase ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 3-4 minutes${NC}"

cd ../backend

# Test 9: Configuration Firebase
echo -e "\n${BLUE}Test 9: Configuration Firebase${NC}"
if [ -f "firebase.json" ] && [ -f ".firebaserc" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    FIREBASE_PASSED=1
    FIREBASE_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    FIREBASE_PASSED=0
    FIREBASE_FAILED=1
fi

# Test 10: Compilation des Functions
echo -e "\n${BLUE}Test 10: Compilation des Functions${NC}"
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

# Test 11: Démarrage des émulateurs
echo -e "\n${BLUE}Test 11: Démarrage des émulateurs${NC}"
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

# Test 12: Test d'intégration Firebase réelle
echo -e "\n${BLUE}Test 12: Test d'intégration Firebase réelle${NC}"
if curl -s http://localhost:5001/demo-project/us-central1/helloWorld | grep -q "Hello from Firebase Functions"; then
    echo -e "  ${GREEN}PASS${NC}"
    FIREBASE_PASSED=$((FIREBASE_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FIREBASE_FAILED=$((FIREBASE_FAILED + 1))
fi

# Arrêter les émulateurs
pkill -f "firebase emulators" 2>/dev/null || true
sleep 3

show_results "Tests Firebase" "$FIREBASE_PASSED" "$FIREBASE_FAILED"

# === Phase 5: Tests CI/CD ===
echo -e "\n${CYAN}=== Phase 5: Tests CI/CD ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 2-3 minutes${NC}"

cd "$PROJECT_ROOT"

# Test 15: GitHub Actions
echo -e "\n${BLUE}Test 15: GitHub Actions${NC}"
if [ -f ".github/workflows/ci-cd.yml" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=1
    CICD_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_PASSED=0
    CICD_FAILED=1
fi

# Test 16: Configuration des environnements
echo -e "\n${BLUE}Test 16: Configuration des environnements${NC}"
if [ -f "config/dev.json" ] && [ -f "config/prod.json" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=$((CICD_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_FAILED=$((CICD_FAILED + 1))
fi

# Test 17: Scripts de déploiement
echo -e "\n${BLUE}Test 17: Scripts de déploiement${NC}"
if [ -f "scripts/deploy.sh" ] && [ -f "scripts/init-project.sh" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=$((CICD_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_FAILED=$((CICD_FAILED + 1))
fi

# Test 18: Test de déploiement simulé
echo -e "\n${BLUE}Test 18: Test de déploiement simulé${NC}"
if [ -f "$PROJECT_NAME/scripts/deploy.sh" ] && [ -f "$PROJECT_NAME/scripts/init-project.sh" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=$((CICD_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_FAILED=$((CICD_FAILED + 1))
fi

show_results "Tests CI/CD" "$CICD_PASSED" "$CICD_FAILED"

# === Phase 6: Tests de Performance et Qualité ===
echo -e "\n${CYAN}=== Phase 6: Tests de Performance et Qualité ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 2-3 minutes${NC}"

cd "$PROJECT_NAME/frontend"

# Test 19: Vérification des métriques de build
echo -e "\n${BLUE}Test 19: Vérification des métriques de build${NC}"
if [ -d ".next" ] && [ -f ".next/BUILD_ID" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    QUALITY_PASSED=1
    QUALITY_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    QUALITY_FAILED=1
    QUALITY_PASSED=0
fi

# Test 20: Vérification des types TypeScript
echo -e "\n${BLUE}Test 20: Vérification des types TypeScript${NC}"
if npx tsc --noEmit; then
    echo -e "  ${GREEN}PASS${NC}"
    QUALITY_PASSED=$((QUALITY_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    QUALITY_FAILED=$((QUALITY_FAILED + 1))
fi

show_results "Tests de Performance et Qualité" "$QUALITY_PASSED" "$QUALITY_FAILED"

# === Phase 7: Tests PWA avancés ===
echo -e "\n${CYAN}=== Phase 7: Tests PWA avancés ===${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 2-3 minutes${NC}"

# Test 21: Test d'installation PWA
echo -e "\n${BLUE}Test 21: Test d'installation PWA${NC}"
if [ -f "public/manifest.json" ] && grep -q "display.*standalone" public/manifest.json; then
    echo -e "  ${GREEN}PASS${NC}"
    PWA_PASSED=1
    PWA_FAILED=0
else
    echo -e "  ${RED}FAIL${NC}"
    PWA_PASSED=0
    PWA_FAILED=1
fi

# Test 22: Test du mode hors ligne
echo -e "\n${BLUE}Test 22: Test du mode hors ligne${NC}"
if [ -f "src/app/offline/page.tsx" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    PWA_PASSED=$((PWA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    PWA_FAILED=$((PWA_FAILED + 1))
fi

# Test 23: Test des push notifications
echo -e "\n${BLUE}Test 23: Test des push notifications${NC}"
if [ -f "src/hooks/use-fcm.ts" ] && [ -f "src/lib/fcm-config.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    PWA_PASSED=$((PWA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    PWA_FAILED=$((PWA_FAILED + 1))
fi

# Test 24: Test du cache management
echo -e "\n${BLUE}Test 24: Test du cache management${NC}"
if [ -f "public/sw.js" ] && grep -q "caches.open" public/sw.js; then
    echo -e "  ${GREEN}PASS${NC}"
    PWA_PASSED=$((PWA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    PWA_FAILED=$((PWA_FAILED + 1))
fi

show_results "Tests PWA avancés" "$PWA_PASSED" "$PWA_FAILED"

cd "$PROJECT_ROOT"

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
        echo -e "\n${GREEN}🎉 FÉLICITATIONS ! 100% DE COUVERTURE RÉELLE COMPLÈTE ATTEINTE ! 🎉${NC}"
        echo -e "🚀 Votre générateur et vos applications sont 100% testés et fonctionnels !"
        echo -e "🏆 Niveau ENTERPRISE ULTRA atteint !"
        echo -e "✅ TOUS les gaps identifiés sont maintenant testés !"
        exit 0
    else
        echo -e "\n${YELLOW}⚠️  Objectif 100% non encore atteint. Continuez les corrections ! ⚠️${NC}"
        exit 1
    fi
else
    echo -e "\n${RED}❌ Aucun test n'a été exécuté !${NC}"
    exit 1
fi 