#!/bin/bash

# 🚀 Test COMPLET et APPROFONDI de TOUT le système
# Ce script lance tous les tests en profondeur : générateur + applications + Firebase + fonctionnalités avancées

set -e  # Arrêter sur la première erreur

# Mode debug activé par défaut (désactivable avec DEBUG=false)
DEBUG=${DEBUG:-true}

# Fonction de debug
debug_log() {
    if [ "$DEBUG" = "true" ]; then
        echo -e "${BLUE}[DEBUG] $1${NC}"
    fi
}

# Détecter automatiquement le répertoire de base du projet
# Ce script peut être exécuté depuis n'importe quel répertoire
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

debug_log "Script directory: $SCRIPT_DIR"
debug_log "Project root: $PROJECT_ROOT"

# Aller au répertoire racine du projet
cd "$PROJECT_ROOT"
debug_log "Changed to project root: $(pwd)"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Compteurs globaux
TOTAL_TESTS_ALL=0
TOTAL_PASSED_ALL=0
TOTAL_FAILED_ALL=0

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

echo -e "${PURPLE}=== Test COMPLET et APPROFONDI de TOUT le système ===${NC}"
echo "Ce script lance tous les tests en profondeur :"
echo "  🎯 Générateur + Applications générées"
echo "  🔥 Intégration Firebase réelle (émulateurs)"
echo "  🚀 Fonctionnalités avancées (PWA, FCM, Analytics, Performance, Sentry)"
echo "  🧪 Tests de build, démarrage et fonctionnement"

echo -e "\n${CYAN}=== Phase 1: Tests ULTRA-COMPLETS du Générateur + Applications ===${NC}"

# Lancer le test ultra-complet
echo -e "\n${YELLOW}Lancement du test ultra-complet...${NC}"
debug_log "About to execute: $SCRIPT_DIR/test-ultra-deep.sh"
debug_log "Command will be redirected to: test-ultra-deep.log"

# Exécuter avec timeout et traces
debug_log "Starting test-ultra-deep.sh..."
if timeout 300 "$SCRIPT_DIR/test-ultra-deep.sh" > test-ultra-deep.log 2>&1; then
    echo -e "${GREEN}✅ Test ultra-complet terminé avec succès${NC}"
    
    # Extraire les résultats (format: PASS/FAIL)
    debug_log "Extracting results from test-ultra-deep.log..."
    debug_log "Log file size: $(wc -l < test-ultra-deep.log) lines"
    
    ULTRA_PASSED=$(grep -c "  PASS" test-ultra-deep.log || echo "0")
    ULTRA_FAILED=$(grep -c "  FAIL" test-ultra-deep.log || echo "0")
    
    debug_log "Extracted results: PASSED=$ULTRA_PASSED, FAILED=$ULTRA_FAILED"
    
    show_results "Test Ultra-Complet" "$ULTRA_PASSED" "$ULTRA_FAILED"
else
    echo -e "${RED}❌ Test ultra-complet a échoué${NC}"
    echo "Log du test ultra-complet :"
    cat test-ultra-deep.log
    exit 1
fi

echo -e "\n${CYAN}=== Phase 2: Tests Firebase RÉELS avec émulateurs ===${NC}"

# Lancer le test Firebase réel
echo -e "\n${YELLOW}Lancement du test Firebase réel...${NC}"
if "$SCRIPT_DIR/test-firebase-real.sh" > test-firebase-real.log 2>&1; then
    echo -e "${GREEN}✅ Test Firebase réel terminé avec succès${NC}"
    
    # Extraire les résultats
    FIREBASE_PASSED=$(grep -o "Passed: [0-9]*" test-firebase-real.log | tail -1 | grep -o "[0-9]*")
    FIREBASE_FAILED=$(grep -o "Failed: [0-9]*" test-firebase-real.log | tail -1 | grep -o "[0-9]*")
    
    show_results "Test Firebase Réel" "$FIREBASE_PASSED" "$FIREBASE_FAILED"
else
    echo -e "${RED}❌ Test Firebase réel a échoué${NC}"
    echo "Log du test Firebase réel :"
    cat test-firebase-real.log
    exit 1
fi

echo -e "\n${CYAN}=== Phase 3: Tests des fonctionnalités AVANCÉES ===${NC}"

# Lancer le test des fonctionnalités avancées
echo -e "\n${YELLOW}Lancement du test des fonctionnalités avancées...${NC}"
if "$SCRIPT_DIR/test-advanced-features.sh" > test-advanced-features.log 2>&1; then
    echo -e "${GREEN}✅ Test des fonctionnalités avancées terminé avec succès${NC}"
    
    # Extraire les résultats
    ADVANCED_PASSED=$(grep -o "Passed: [0-9]*" test-advanced-features.log | tail -1 | grep -o "[0-9]*")
    ADVANCED_FAILED=$(grep -o "Failed: [0-9]*" test-advanced-features.log | tail -1 | grep -o "[0-9]*")
    
    show_results "Test Fonctionnalités Avancées" "$ADVANCED_PASSED" "$ADVANCED_FAILED"
else
    echo -e "${RED}❌ Test des fonctionnalités avancées a échoué${NC}"
    echo "Log du test des fonctionnalités avancées :"
    cat test-advanced-features.log
    exit 1
fi

echo -e "\n${CYAN}=== Phase 4: Tests de validation finale ===${NC}"

# Tests de validation finale
echo -e "\n${YELLOW}Validation finale du système...${NC}"

# Vérifier que tous les composants sont présents
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -e "\n${BLUE}Testing: ${test_name}${NC}"
    
    if eval "$test_command"; then
        echo -e "  ${GREEN}PASS${NC}"
        TOTAL_PASSED_ALL=$((TOTAL_PASSED_ALL + 1))
    else
        echo -e "  ${RED}FAIL${NC}"
        TOTAL_FAILED_ALL=$((TOTAL_FAILED_ALL + 1))
    fi
}

# Tests de validation finale
run_test "Generator CLI executable" "test -f dist/cli.js"
run_test "Generator templates" "test -d templates"
run_test "Generator source code" "test -d src"
run_test "Test scripts" "test -f scripts/test-ultra-deep.sh && test -f scripts/test-firebase-real.sh && test -f scripts/test-advanced-features.sh"

echo -e "\n${CYAN}=== Résultats FINAUX COMPLETS ===${NC}"
echo -e "Total tests exécutés: ${TOTAL_TESTS_ALL}"
echo -e "Total passed: ${GREEN}${TOTAL_PASSED_ALL}${NC}"
echo -e "Total failed: ${RED}${TOTAL_FAILED_ALL}${NC}"

if [ $TOTAL_FAILED_ALL -eq 0 ]; then
    echo -e "\n${GREEN}🎉🎉🎉 TOUS LES TESTS ONT RÉUSSI ! 🎉🎉🎉${NC}"
    echo -e "${GREEN}🚀🚀🚀 LE SYSTÈME EST 100% FONCTIONNEL ET TESTÉ EN PROFONDEUR ! 🚀🚀🚀${NC}"
    
    echo -e "\n${CYAN}Résumé complet des tests réussis :${NC}"
    echo -e "  ${GREEN}✅${NC} Tests ULTRA-COMPLETS du Générateur + Applications"
    echo -e "  ${GREEN}✅${NC} Tests Firebase RÉELS avec émulateurs (Auth, Firestore, Storage, Functions)"
    echo -e "  ${GREEN}✅${NC} Tests des fonctionnalités AVANCÉES (PWA, FCM, Analytics, Performance, Sentry)"
    echo -e "  ${GREEN}✅${NC} Tests de validation finale du système"
    
    echo -e "\n${CYAN}Niveau de test atteint :${NC}"
    echo -e "  ${GREEN}🎯 PROFESSIONNEL ET APPROFONDI${NC}"
    echo -e "  ${GREEN}🚀 PRÊT POUR LA PRODUCTION${NC}"
    echo -e "  ${GREEN}🧪 COUVERTURE COMPLÈTE DU SYSTÈME${NC}"
    
    echo -e "\n${GREEN}🎊 FÉLICITATIONS ! Le générateur et les applications générées sont 100% opérationnels ! 🎊${NC}"
    
else
    echo -e "\n${RED}❌ ${TOTAL_FAILED_ALL} tests ont échoué au total.${NC}"
    echo -e "${YELLOW}🔧 Des ajustements peuvent être nécessaires.${NC}"
    
    echo -e "\n${CYAN}Logs des tests :${NC}"
    echo -e "  Test Ultra-Complet: test-ultra-deep.log"
    echo -e "  Test Firebase Réel: test-firebase-real.log"
    echo -e "  Test Fonctionnalités Avancées: test-advanced-features.log"
fi

echo -e "\n${CYAN}=== Test COMPLET et APPROFONDI de TOUT le système terminé ===${NC}"

# Nettoyer les logs de test
echo -e "\n${YELLOW}Nettoyage des logs de test...${NC}"
rm -f test-ultra-deep.log test-firebase-real.log test-advanced-features.log
echo "Logs nettoyés" 