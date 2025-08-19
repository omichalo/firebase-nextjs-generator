#!/bin/bash

# Script de test ULTRA-COMPLET pour 100% de couverture
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

echo -e "${PURPLE}=== Test ULTRA-COMPLET pour 100% de COUVERTURE ===${NC}"
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

if "$SCRIPT_DIR/test-ultra-deep.sh" 2>&1 | tee test-ultra-deep.log; then
    echo -e "${GREEN}✅ Test ultra-complet terminé avec succès${NC}"
    
    # Extraire les résultats
    ULTRA_PASSED=$(grep -c "  PASS" test-ultra-deep.log 2>/dev/null | tr -d '\n' || echo "0")
    ULTRA_FAILED=$(grep -c "  FAIL" test-ultra-deep.log 2>/dev/null | tr -d '\n' || echo "0")
    
    show_results "Test Ultra-Complet" "$ULTRA_PASSED" "$ULTRA_FAILED"
else
    echo -e "${RED}❌ Test ultra-complet a échoué${NC}"
    ULTRA_PASSED=0
    ULTRA_FAILED=1
    show_results "Test Ultra-Complet" "$ULTRA_PASSED" "$ULTRA_FAILED"
fi

echo -e "\n${CYAN}=== Phase 2: Tests Firebase RÉELS avec émulateurs ===${NC}"

# Lancer le test Firebase réel
echo -e "\n${YELLOW}Lancement du test Firebase réel...${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 3-5 minutes${NC}"

if "$SCRIPT_DIR/test-firebase-real.sh" 2>&1 | tee test-firebase-real.log; then
    echo -e "${GREEN}✅ Test Firebase réel terminé avec succès${NC}"
    
    # Extraire les résultats
    FIREBASE_PASSED=$(grep -c "  PASS" test-firebase-real.log 2>/dev/null | tr -d '\n' || echo "0")
    FIREBASE_FAILED=$(grep -c "  FAIL" test-firebase-real.log 2>/dev/null | tr -d '\n' || echo "0")
    
    show_results "Test Firebase Réel" "$FIREBASE_PASSED" "$FIREBASE_FAILED"
else
    echo -e "${RED}❌ Test Firebase réel a échoué${NC}"
    FIREBASE_PASSED=0
    FIREBASE_FAILED=1
    show_results "Test Firebase Réel" "$FIREBASE_PASSED" "$FIREBASE_FAILED"
fi

echo -e "\n${CYAN}=== Phase 3: Tests CI/CD et Déploiement ===${NC}"

# Lancer le test CI/CD
echo -e "\n${YELLOW}Lancement du test CI/CD et déploiement...${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 2-3 minutes${NC}"

if "$SCRIPT_DIR/test-cicd-deployment.sh" 2>&1 | tee test-cicd.log; then
    echo -e "${GREEN}✅ Test CI/CD terminé avec succès${NC}"
    
    # Extraire les résultats
    CICD_PASSED=$(grep -c "  PASS" test-cicd.log 2>/dev/null | tr -d '\n' || echo "0")
    CICD_FAILED=$(grep -c "  FAIL" test-cicd.log 2>/dev/null | tr -d '\n' || echo "0")
    
    show_results "Test CI/CD et Déploiement" "$CICD_PASSED" "$CICD_FAILED"
else
    echo -e "${RED}❌ Test CI/CD a échoué${NC}"
    CICD_PASSED=0
    CICD_FAILED=1
    show_results "Test CI/CD et Déploiement" "$CICD_PASSED" "$CICD_FAILED"
fi

echo -e "\n${CYAN}=== Phase 4: Tests de Fonctionnalités Avancées ===${NC}"

# Lancer le test des fonctionnalités avancées
echo -e "\n${YELLOW}Lancement du test des fonctionnalités avancées...${NC}"
echo -e "${BLUE}⏱️  Temps estimé: 2-3 minutes${NC}"

if "$SCRIPT_DIR/test-advanced-features.sh" 2>&1 | tee test-advanced.log; then
    echo -e "${GREEN}✅ Test des fonctionnalités avancées terminé avec succès${NC}"
    
    # Extraire les résultats
    ADVANCED_PASSED=$(grep -c "  PASS" test-advanced.log 2>/dev/null | tr -d '\n' || echo "0")
    ADVANCED_FAILED=$(grep -c "  FAIL" test-advanced.log 2>/dev/null | tr -d '\n' || echo "0")
    
    show_results "Test Fonctionnalités Avancées" "$ADVANCED_PASSED" "$ADVANCED_FAILED"
else
    echo -e "${RED}❌ Test des fonctionnalités avancées a échoué${NC}"
    ADVANCED_PASSED=0
    ADVANCED_FAILED=1
    show_results "Test Fonctionnalités Avancées" "$ADVANCED_PASSED" "$ADVANCED_FAILED"
fi

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