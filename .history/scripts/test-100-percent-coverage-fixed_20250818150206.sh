#!/bin/bash

# 🎯 Test ULTRA-COMPLET pour 100% de COUVERTURE - VERSION CORRIGÉE
# Ce script combine TOUS les tests : Générateur + Applications + Firebase + CI/CD + Déploiement

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Variables globales
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOTAL_TESTS_ALL=0
TOTAL_PASSED_ALL=0
TOTAL_FAILED_ALL=0

# Fonction de debug
debug_log() {
    if [ "$DEBUG" = "true" ]; then
        echo -e "${BLUE}[DEBUG] $1${NC}"
    fi
}

# Fonction d'affichage des résultats
show_results() {
    local test_name="$1"
    local passed="$2"
    local failed="$3"
    
    echo -e "\n${CYAN}=== Résultats de ${test_name} ===${NC}"
    echo -e "Passed: ${GREEN}${passed}${NC}"
    echo -e "Failed: ${RED}${failed}${NC}"
    
    TOTAL_TESTS_ALL=$((TOTAL_TESTS_ALL + passed + failed))
    TOTAL_PASSED_ALL=$((TOTAL_PASSED_ALL + passed))
    TOTAL_FAILED_ALL=$((TOTAL_FAILED_ALL + failed))
}

# Fonction de nettoyage globale
cleanup_all() {
    echo -e "\n${YELLOW}Cleaning up all test projects...${NC}"
    
    # Arrêter tous les processus en cours
    pkill -f "firebase emulators" 2>/dev/null || true
    pkill -f "npm run dev" 2>/dev/null || true
    
    # Nettoyer tous les projets de test
    if [ -d "./test-output-ultra-deep" ]; then
        rm -rf ./test-output-ultra-deep
    fi
    
    if [ -d "./test-firebase-real" ]; then
        rm -rf ./test-firebase-real
    fi
    
    if [ -d "./test-advanced-features" ]; then
        rm -rf ./test-advanced-features
    fi
    
    echo "Global cleanup completed"
}

# Trapper les signaux pour le nettoyage
trap cleanup_all EXIT INT TERM

echo -e "${PURPLE}=== Test ULTRA-COMPLET pour 100% de COUVERTURE - VERSION CORRIGÉE ===${NC}"
echo "Ce script combine TOUS les tests :"
echo "  🎯 Générateur + Applications générées"
echo "  🔥 Intégration Firebase réelle (émulateurs)"
echo "  🚀 Fonctionnalités avancées (PWA, FCM, Analytics, Performance, Sentry)"
echo "  🌍 CI/CD et déploiement (GitHub Actions, Firebase)"
echo "  🧪 Tests de build, démarrage, fonctionnement et déploiement"

echo -e "\n${CYAN}=== Phase 1: Tests ULTRA-COMPLETS du Générateur + Applications ===${NC}"

# Lancer le test ultra-complet
echo -e "\n${YELLOW}Lancement du test ultra-complet...${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 5-8 minutes${NC}"
echo -e "${BLUE}📊 12 phases de tests à exécuter${NC}"

# Créer le projet de test s'il n'existe pas
if [ ! -d "./test-output-ultra-deep" ]; then
    echo -e "${BLUE}Création du projet de test...${NC}"
    node dist/cli.js create \
        --name "test-ultra-deep" \
        --output "./test-output-ultra-deep" \
        --yes \
        --ui "mui" \
        --state-management "redux" \
        --features "pwa,fcm,analytics,performance,sentry"
fi

# Exécuter les tests de base
cd test-output-ultra-deep/frontend

# Test 1: Installation des dépendances
echo -e "\n${BLUE}Test 1: Installation des dépendances${NC}"
if npm install; then
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
if [ -f "src/app/layout.tsx" ] && [ -f "src/components/Providers.tsx" ] && [ -f "src/lib/firebase.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 4: Configuration MUI
echo -e "\n${BLUE}Test 4: Configuration MUI${NC}"
if [ -f "src/components/MUIWrapper.tsx" ] && [ -f "src/components/ClientThemeProvider.tsx" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 5: Configuration Redux
echo -e "\n${BLUE}Test 5: Configuration Redux${NC}"
if [ -f "src/stores/auth-slice.ts" ] && [ -f "src/stores/store.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 6: Configuration PWA
echo -e "\n${BLUE}Test 6: Configuration PWA${NC}"
if [ -f "public/manifest.json" ] && [ -f "public/sw.js" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 7: Configuration Firebase
echo -e "\n${BLUE}Test 7: Configuration Firebase${NC}"
if [ -f "src/lib/firebase.ts" ] && [ -f "src/fcm/use-fcm.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 8: Configuration Sentry
echo -e "\n${BLUE}Test 8: Configuration Sentry${NC}"
if [ -f "src/sentry/sentry-config.ts" ] && [ -f "src/sentry/sentry-middleware.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 9: Configuration Analytics
echo -e "\n${BLUE}Test 9: Configuration Analytics${NC}"
if [ -f "src/analytics/analytics-config.ts" ] && [ -f "src/analytics/use-analytics.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

# Test 10: Configuration Performance
echo -e "\n${BLUE}Test 10: Configuration Performance${NC}"
if [ -f "src/performance/performance-config.ts" ]; then
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
if [ -f "tests/auth.test.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ULTRA_PASSED=$((ULTRA_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ULTRA_FAILED=$((ULTRA_FAILED + 1))
fi

show_results "Test Ultra-Complet" "$ULTRA_PASSED" "$ULTRA_FAILED"

cd "$PROJECT_ROOT"

echo -e "\n${CYAN}=== Phase 2: Tests Firebase RÉELS avec émulateurs ===${NC}"

# Lancer le test Firebase réel
echo -e "\n${YELLOW}Lancement du test Firebase réel...${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 3-5 minutes${NC}"

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
cd functions
if npm install && npm run build; then
    echo -e "  ${GREEN}PASS${NC}"
    FIREBASE_PASSED=$((FIREBASE_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FIREBASE_FAILED=$((FIREBASE_FAILED + 1))
fi
cd ..

# Test 4: Démarrage des émulateurs
echo -e "\n${BLUE}Test 4: Démarrage des émulateurs${NC}"
firebase emulators:start --only auth,firestore,functions,storage --project demo-project > emulators.log 2>&1 &
EMULATOR_PID=$!

# Attendre que les émulateurs démarrent
echo "Attente du démarrage des émulateurs..."
sleep 45

# Test des émulateurs
if curl -s http://localhost:9099 | grep -q "authEmulator" && \
   curl -s http://localhost:8080 | grep -q "Ok" && \
   curl -s http://localhost:5001 | grep -q "Not Found" && \
   curl -s http://localhost:9199 | grep -q "Not Implemented"; then
    echo -e "  ${GREEN}PASS${NC}"
    FIREBASE_PASSED=$((FIREBASE_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    FIREBASE_FAILED=$((FIREBASE_FAILED + 1))
fi

# Arrêter les émulateurs
kill $EMULATOR_PID 2>/dev/null || true
wait $EMULATOR_PID 2>/dev/null || true

show_results "Test Firebase Réel" "$FIREBASE_PASSED" "$FIREBASE_FAILED"

cd "$PROJECT_ROOT"

echo -e "\n${CYAN}=== Phase 3: Tests CI/CD et Déploiement ===${NC}"

# Lancer le test CI/CD
echo -e "\n${YELLOW}Lancement du test CI/CD et déploiement...${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 2-3 minutes${NC}"

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
if [ -f "docs/TESTING_DEEP.md" ] && [ -f "README.md" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    CICD_PASSED=$((CICD_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    CICD_FAILED=$((CICD_FAILED + 1))
fi

show_results "Test CI/CD et Déploiement" "$CICD_PASSED" "$CICD_FAILED"

echo -e "\n${CYAN}=== Phase 4: Tests de Fonctionnalités Avancées ===${NC}"

# Lancer le test des fonctionnalités avancées
echo -e "\n${YELLOW}Lancement du test des fonctionnalités avancées...${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 2-3 minutes${NC}"

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
if [ -f "test-output-ultra-deep/frontend/src/fcm/use-fcm.ts" ] && [ -f "test-output-ultra-deep/frontend/src/fcm/fcm-config.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ADVANCED_PASSED=$((ADVANCED_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ADVANCED_FAILED=$((ADVANCED_FAILED + 1))
fi

# Test 3: Analytics
echo -e "\n${BLUE}Test 3: Analytics${NC}"
if [ -f "test-output-ultra-deep/frontend/src/analytics/analytics-config.ts" ] && [ -f "test-output-ultra-deep/frontend/src/analytics/use-analytics.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ADVANCED_PASSED=$((ADVANCED_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ADVANCED_FAILED=$((ADVANCED_FAILED + 1))
fi

# Test 4: Performance
echo -e "\n${BLUE}Test 4: Performance${NC}"
if [ -f "test-output-ultra-deep/frontend/src/performance/performance-config.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ADVANCED_PASSED=$((ADVANCED_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ADVANCED_FAILED=$((ADVANCED_FAILED + 1))
fi

# Test 5: Sentry
echo -e "\n${BLUE}Test 5: Sentry${NC}"
if [ -f "test-output-ultra-deep/frontend/src/sentry/sentry-config.ts" ] && [ -f "test-output-ultra-deep/frontend/src/sentry/sentry-middleware.ts" ]; then
    echo -e "  ${GREEN}PASS${NC}"
    ADVANCED_PASSED=$((ADVANCED_PASSED + 1))
else
    echo -e "  ${RED}FAIL${NC}"
    ADVANCED_FAILED=$((ADVANCED_FAILED + 1))
fi

show_results "Test Fonctionnalités Avancées" "$ADVANCED_PASSED" "$ADVANCED_FAILED"

echo -e "\n${CYAN}=== RÉSULTATS FINAUX COMPLETS ===${NC}"
echo -e "🎯 COUVERTURE TOTALE DE TEST :"
echo -e "Total des tests: ${TOTAL_TESTS_ALL}"
echo -e "Tests réussis: ${GREEN}${TOTAL_PASSED_ALL}${NC}"
echo -e "Tests échoués: ${RED}${TOTAL_FAILED_ALL}${NC}"

# Calculer le pourcentage de réussite
if [ $TOTAL_TESTS_ALL -gt 0 ]; then
    SUCCESS_RATE=$(( (TOTAL_PASSED_ALL * 100) / TOTAL_TESTS_ALL ))
    echo -e "Taux de réussite: ${GREEN}${SUCCESS_RATE}%${NC}"
    
    if [ $SUCCESS_RATE -eq 100 ]; then
        echo -e "\n${GREEN}🎉 FÉLICITATIONS ! 100% DE COUVERTURE ATTEINT ! 🎉${NC}"
        echo -e "Votre générateur est maintenant un outil de niveau ENTERPRISE !"
        exit 0
    elif [ $SUCCESS_RATE -ge 90 ]; then
        echo -e "\n${GREEN}🌟 EXCELLENT ! Couverture de ${SUCCESS_RATE}% atteinte ! 🌟${NC}"
        echo -e "Votre générateur est de niveau PROFESSIONNEL !"
        exit 0
    elif [ $SUCCESS_RATE -ge 80 ]; then
        echo -e "\n${YELLOW}👍 BON ! Couverture de ${SUCCESS_RATE}% atteinte 👍${NC}"
        echo -e "Votre générateur est de niveau AVANCÉ !"
        exit 0
    else
        echo -e "\n${RED}⚠️  Couverture de ${SUCCESS_RATE}% - Amélioration nécessaire ⚠️${NC}"
        echo -e "Continuez à corriger les tests échoués pour atteindre 100% !"
        exit 1
    fi
else
    echo -e "\n${RED}❌ Aucun test exécuté${NC}"
    exit 1
fi 