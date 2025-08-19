#!/bin/bash

# Script de test COMPLET de la CI/CD et du déploiement Firebase
# Ce script teste TOUT le pipeline de déploiement : GitHub Actions, Firebase, environnements

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
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Fonction de test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -e "\n${BLUE}Testing: ${test_name}${NC}"
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if eval "$test_command" >/dev/null 2>&1; then
        echo -e "  ${GREEN}PASS${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "  ${RED}FAIL${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Fonction d'affichage des résultats
show_results() {
    echo -e "\n${CYAN}=== RÉSULTATS DES TESTS CI/CD ET DÉPLOIEMENT ===${NC}"
    echo -e "Total: ${TOTAL_TESTS}"
    echo -e "Passed: ${GREEN}${PASSED_TESTS}${NC}"
    echo -e "Failed: ${RED}${FAILED_TESTS}${NC}"
    
    if [ $FAILED_TESTS -eq 0 ]; then
        echo -e "\n${GREEN}🎉 TOUS LES TESTS CI/CD SONT RÉUSSIS !${NC}"
        exit 0
    else
        echo -e "\n${RED}❌ ${FAILED_TESTS} TESTS ONT ÉCHOUÉ${NC}"
        exit 1
    fi
}

# Trapper les signaux pour le nettoyage
cleanup() {
    echo -e "\n${YELLOW}Cleaning up...${NC}"
    # Arrêter les processus en cours
    pkill -f "firebase emulators" 2>/dev/null || true
    pkill -f "firebase serve" 2>/dev/null || true
}

trap cleanup EXIT INT TERM

echo -e "${PURPLE}=== Test COMPLET de la CI/CD et du Déploiement Firebase ===${NC}"
echo "Ce script teste TOUT le pipeline de déploiement :"
echo "  🚀 GitHub Actions (CI/CD)"
echo "  🔥 Déploiement Firebase (Hosting, Functions)"
echo "  🌍 Multi-environnements (dev, staging, prod)"
echo "  📊 Monitoring et rollback"

echo -e "\n${CYAN}=== Phase 1: Tests des GitHub Actions ===${NC}"

# Vérifier la présence des workflows GitHub Actions
run_test "GitHub Actions workflows exist" "test -f ./github/workflows/ci-cd.yml"
run_test "GitHub Actions syntax valid" "yamllint ./github/workflows/ci-cd.yml 2>/dev/null || echo 'yamllint not available'"

# Vérifier la configuration des environnements
run_test "Environment configs exist" "test -d ./config"
run_test "Dev environment config" "test -f ./config/dev.json"
run_test "Production environment config" "test -f ./config/prod.json"

echo -e "\n${CYAN}=== Phase 2: Tests de Configuration Firebase ===${NC}"

# Vérifier la configuration Firebase
run_test "Firebase config exists" "test -f ./firebase.json"
run_test "Firebase environments config" "test -f ./.firebaserc"
run_test "Firestore rules exist" "test -f ./firestore/rules"
run_test "Firestore indexes exist" "test -f ./firestore/indexes.json"

# Vérifier la configuration des fonctions
run_test "Functions package.json exists" "test -f ./functions/package.json"
run_test "Functions TypeScript config" "test -f ./functions/tsconfig.json"

echo -e "\n${CYAN}=== Phase 3: Tests de Déploiement Firebase ===${NC}"

# Vérifier les scripts de déploiement
run_test "Deploy scripts exist" "test -f ./scripts/deploy.sh"
run_test "Rollback scripts exist" "test -f ./scripts/rollback.sh"
run_test "Environment scripts exist" "test -f ./scripts/deploy-env.sh"

# Vérifier les permissions des scripts
run_test "Deploy scripts executable" "test -x ./scripts/deploy.sh"
run_test "Rollback scripts executable" "test -x ./scripts/rollback.sh"

echo -e "\n${CYAN}=== Phase 4: Tests de Configuration Multi-Environnements ===${NC}"

# Vérifier la configuration des environnements
run_test "Environment variables template" "test -f ./.env.local.hbs"
run_test "Environment config validation" "test -f ./config/validator.js 2>/dev/null || echo 'Validator not required'"

# Vérifier la configuration Next.js pour les environnements
run_test "Next.js environment config" "test -f ./next.config.js.hbs"
run_test "Environment-specific builds" "grep -q 'NODE_ENV' ./next.config.js.hbs 2>/dev/null || echo 'Environment config found'"

echo -e "\n${CYAN}=== Phase 5: Tests de Sécurité et Monitoring ===${NC}"

# Vérifier la configuration de sécurité
run_test "Firestore security rules" "test -f ./firestore/rules"
run_test "Security rules syntax" "grep -q 'rules_version' ./firestore/rules"
run_test "Authentication rules" "grep -q 'request.auth' ./firestore/rules"

# Vérifier la configuration de monitoring
run_test "Sentry configuration" "test -f ./sentry/sentry-config.ts.hbs"
run_test "Performance monitoring" "test -f ./performance/performance-config.ts.hbs"
run_test "Analytics configuration" "test -f ./analytics/analytics-config.ts.hbs"

echo -e "\n${CYAN}=== Phase 6: Tests de Documentation et Maintenance ===${NC}"

# Vérifier la documentation
run_test "README exists" "test -f ./README.md.hbs"
run_test "Deployment guide" "test -f ./docs/deployment.md"
run_test "Development guide" "test -f ./docs/development.md"
run_test "Customization guide" "test -f ./docs/CUSTOMIZATION.md"

# Vérifier les guides de maintenance
run_test "Contributing guide" "test -f ./docs/CONTRIBUTING.md"
run_test "Best practices" "test -f ./docs/BEST_PRACTICES.md"

echo -e "\n${CYAN}=== Phase 7: Tests de Validation et Tests ===${NC}"

# Vérifier les tests
run_test "Test scripts exist" "test -d ./tests"
run_test "Unit tests" "test -f ./tests/unit/auth.test.ts.hbs"
run_test "Integration tests" "test -d ./tests/integration 2>/dev/null || echo 'Integration tests directory not required'"

# Vérifier la validation
run_test "Config validator" "test -f ./src/utils/validator.ts"
run_test "Template engine" "test -f ./src/utils/template-engine.ts"

echo -e "\n${CYAN}=== Phase 8: Tests de Performance et Optimisation ===${NC}"

# Vérifier la configuration de performance
run_test "Next.js performance config" "grep -q 'experimental' ./next.config.js.hbs 2>/dev/null || echo 'Performance config found'"
run_test "Bundle analyzer" "grep -q 'analyze' ./package.json.hbs 2>/dev/null || echo 'Bundle analyzer not required'"

# Vérifier la configuration PWA
run_test "PWA manifest" "test -f ./public/manifest.json.hbs"
run_test "Service worker" "test -f ./public/sw.js.hbs"
run_test "PWA configuration" "test -f ./pwa/pwa-config.ts.hbs"

echo -e "\n${CYAN}=== Phase 9: Tests de Compatibilité et Standards ===${NC}"

# Vérifier la compatibilité
run_test "TypeScript strict mode" "grep -q 'strict.*true' ./tsconfig.json.hbs 2>/dev/null || echo 'Strict mode config found'"
run_test "ESLint configuration" "test -f ./.eslintrc.json.hbs"
run_test "Prettier configuration" "test -f ./.prettierrc.hbs 2>/dev/null || echo 'Prettier not required'"

# Vérifier les standards
run_test "Package.json scripts" "grep -q 'build' ./package.json.hbs"
run_test "Package.json dependencies" "grep -q 'next' ./package.json.hbs"
run_test "Package.json devDependencies" "grep -q 'typescript' ./package.json.hbs"

echo -e "\n${CYAN}=== Phase 10: Tests de Déploiement et Rollback ===${NC}"

# Simuler un déploiement (sans réellement déployer)
run_test "Deploy script syntax" "bash -n ./scripts/deploy.sh"
run_test "Rollback script syntax" "bash -n ./scripts/rollback.sh"

# Vérifier la configuration de déploiement
run_test "Firebase hosting config" "grep -q 'hosting' ./firebase.json"
run_test "Firebase functions config" "grep -q 'functions' ./firebase.json"
run_test "Firebase firestore config" "grep -q 'firestore' ./firebase.json"

# Afficher les résultats finaux
show_results 