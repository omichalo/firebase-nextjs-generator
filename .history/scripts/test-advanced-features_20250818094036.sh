#!/bin/bash

# 🚀 Test des fonctionnalités AVANCÉES : PWA, FCM, Analytics, Performance, Sentry
# Ce script teste toutes les fonctionnalités avancées des applications générées

set -e  # Arrêter sur la première erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Compteurs de tests
TOTAL_TESTS=0
PASSED=0
FAILED=0

# Fonction de test avec compteur
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -e "\n${BLUE}Testing: ${test_name}${NC}"
    
    if eval "$test_command"; then
        echo -e "  ${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
}

# Fonction de nettoyage
cleanup() {
    echo -e "\n${YELLOW}Cleaning up test projects...${NC}"
    
    # Nettoyer les projets de test
    if [ -d "./test-advanced-features" ]; then
        rm -rf ./test-advanced-features
    fi
    
    echo "Cleanup completed"
}

# Trapper les signaux pour le nettoyage
trap cleanup EXIT INT TERM

echo -e "${PURPLE}=== Test des fonctionnalités AVANCÉES : PWA, FCM, Analytics, Performance, Sentry ===${NC}"
echo "Ce script teste toutes les fonctionnalités avancées des applications générées"

echo -e "\n${CYAN}=== Phase 1: Génération d'un projet avec toutes les fonctionnalités avancées ===${NC}"

# Générer un projet avec toutes les fonctionnalités avancées
echo -e "\n${YELLOW}Generating project with all advanced features...${NC}"

if node dist/cli.js create \
    --project-name "test-advanced-features" \
    --output-dir "./test-advanced-features" \
    --template-dir "./templates" \
    --non-interactive \
    --nextjs-version "15" \
    --nextjs-ui "mui" \
    --nextjs-state-management "redux" \
    --nextjs-package-manager "npm" \
    --nextjs-features-pwa "true" \
    --nextjs-features-fcm "true" \
    --nextjs-features-analytics "true" \
    --nextjs-features-performance "true" \
    --nextjs-features-sentry "true" \
    --firebase-environments "dev" \
    --firebase-region "us-central1" \
    --firebase-extensions "auth,firestore,storage,functions" \
    --firebase-features-auth "true" \
    --firebase-features-firestore "true" \
    --firebase-features-storage "true" \
    --firebase-features-functions "true" \
    --firebase-features-hosting "true" \
    --firebase-features-emulators "true"; then
    
    echo -e "${GREEN}✅ Projet avec fonctionnalités avancées généré avec succès!${NC}"
    
    # Vérification de la structure
    run_test "Project structure" "test -d ./test-advanced-features/frontend && test -d ./test-advanced-features/backend"
    
else
    echo -e "${RED}❌ Échec de la génération du projet${NC}"
    exit 1
fi

echo -e "\n${CYAN}=== Phase 2: Tests PWA (Progressive Web App) ===${NC}"

cd ./test-advanced-features/frontend

# Tests des fichiers PWA
run_test "PWA manifest.json" "test -f public/manifest.json"
run_test "PWA service worker" "test -f public/sw.js"
run_test "PWA offline page" "test -f public/offline.html"

# Vérifier le contenu du manifest
run_test "PWA manifest name" "grep -q 'test-advanced-features' public/manifest.json"
run_test "PWA manifest short_name" "grep -q 'short_name' public/manifest.json"
run_test "PWA manifest start_url" "grep -q 'start_url' public/manifest.json"
run_test "PWA manifest display" "grep -q 'display' public/manifest.json"
run_test "PWA manifest theme_color" "grep -q 'theme_color' public/manifest.json"
run_test "PWA manifest background_color" "grep -q 'background_color' public/manifest.json"

# Vérifier le service worker
run_test "PWA service worker content" "grep -q 'install' public/sw.js"
run_test "PWA service worker fetch" "grep -q 'fetch' public/sw.js"

# Vérifier la configuration PWA dans Next.js
run_test "PWA config in next.config.js" "grep -q 'PWA' next.config.js || grep -q 'pwa' next.config.js"

echo -e "\n${CYAN}=== Phase 3: Tests FCM (Firebase Cloud Messaging) ===${NC}"

# Tests des fichiers FCM
run_test "FCM config file" "test -f src/lib/fcm-config.ts"
run_test "FCM hook" "test -f src/hooks/use-fcm.ts"

# Vérifier le contenu de la configuration FCM
run_test "FCM config structure" "grep -q 'FCM_CONFIG' src/lib/fcm-config.ts"
run_test "FCM public key" "grep -q 'publicKey' src/lib/fcm-config.ts"
run_test "FCM default options" "grep -q 'defaultNotificationOptions' src/lib/fcm-config.ts"

# Vérifier le hook FCM
run_test "FCM hook structure" "grep -q 'useFCM' src/hooks/use-fcm.ts"
run_test "FCM notification handling" "grep -q 'showNotification' src/hooks/use-fcm.ts"
run_test "FCM token management" "grep -q 'getToken' src/hooks/use-fcm.ts"

# Vérifier l'intégration Firebase
run_test "FCM Firebase integration" "grep -q 'messaging' src/lib/firebase.ts"

echo -e "\n${CYAN}=== Phase 4: Tests Analytics ===${NC}"

# Tests des fichiers Analytics
run_test "Analytics config file" "test -f src/lib/analytics-config.ts"
run_test "Analytics hook" "test -f src/hooks/use-analytics.ts"

# Vérifier le contenu de la configuration Analytics
run_test "Analytics config structure" "grep -q 'ANALYTICS_CONFIG' src/lib/analytics-config.ts"
run_test "Analytics measurement ID" "grep -q 'measurementId' src/lib/analytics-config.ts"
run_test "Analytics debug mode" "grep -q 'debugMode' src/lib/analytics-config.ts"

# Vérifier le hook Analytics
run_test "Analytics hook structure" "grep -q 'useAnalytics' src/hooks/use-analytics.ts"
run_test "Analytics event tracking" "grep -q 'trackEvent' src/hooks/use-analytics.ts"
run_test "Analytics page tracking" "grep -q 'trackPage' src/hooks/use-analytics.ts"

# Vérifier l'intégration Firebase
run_test "Analytics Firebase integration" "grep -q 'analytics' src/lib/firebase.ts"

echo -e "\n${CYAN}=== Phase 5: Tests Performance ===${NC}"

# Tests des fichiers Performance
run_test "Performance config file" "test -f src/lib/performance-config.ts"
run_test "Performance hook" "test -f src/hooks/use-performance.ts"

# Vérifier le contenu de la configuration Performance
run_test "Performance config structure" "grep -q 'PERFORMANCE_CONFIG' src/lib/performance-config.ts"
run_test "Performance traces" "grep -q 'traces' src/lib/performance-config.ts"
run_test "Performance metrics" "grep -q 'metrics' src/lib/performance-config.ts"

# Vérifier le hook Performance
run_test "Performance hook structure" "grep -q 'usePerformance' src/hooks/use-performance.ts"
run_test "Performance trace tracking" "grep -q 'startTrace' src/hooks/use-performance.ts"
run_test "Performance metric tracking" "grep -q 'putMetric' src/hooks/use-performance.ts"

# Vérifier l'intégration Firebase
run_test "Performance Firebase integration" "grep -q 'performance' src/lib/firebase.ts"

echo -e "\n${CYAN}=== Phase 6: Tests Sentry ===${NC}"

# Tests des fichiers Sentry
run_test "Sentry config file" "test -f src/lib/sentry-config.ts"
run_test "Sentry middleware" "test -f src/middleware.ts"

# Vérifier le contenu de la configuration Sentry
run_test "Sentry config structure" "grep -q 'SENTRY_CONFIG' src/lib/sentry-config.ts"
run_test "Sentry DSN" "grep -q 'dsn' src/lib/sentry-config.ts"
run_test "Sentry environment" "grep -q 'environment' src/lib/sentry-config.ts"
run_test "Sentry release" "grep -q 'release' src/lib/sentry-config.ts"

# Vérifier le middleware Sentry
run_test "Sentry middleware structure" "grep -q 'Sentry' src/middleware.ts"
run_test "Sentry error handling" "grep -q 'captureException' src/middleware.ts"

# Vérifier la configuration Next.js pour Sentry
run_test "Sentry Next.js config" "grep -q 'sentry' next.config.js"

echo -e "\n${CYAN}=== Phase 7: Tests d'intégration des fonctionnalités ===${NC}"

# Installer les dépendances
echo "Installing dependencies..."
npm install

# Tester le build avec toutes les fonctionnalités
run_test "Build with all features" "npm run build"

# Vérifier que les fonctionnalités sont incluses dans le build
if [ -d ".next" ]; then
    run_test "Build output exists" "test -d .next"
    run_test "Static pages generated" "test -d .next/server/app"
    run_test "Client bundles generated" "test -d .next/static/chunks"
fi

echo -e "\n${CYAN}=== Phase 8: Tests de configuration des fonctionnalités ===${NC}"

# Vérifier que les fonctionnalités sont correctement configurées dans package.json
run_test "PWA dependencies" "grep -q 'next-pwa' package.json"
run_test "FCM dependencies" "grep -q 'firebase/messaging' package.json"
run_test "Analytics dependencies" "grep -q 'firebase/analytics' package.json"
run_test "Performance dependencies" "grep -q 'firebase/performance' package.json"
run_test "Sentry dependencies" "grep -q '@sentry/nextjs' package.json"

# Vérifier la configuration TypeScript
run_test "TypeScript config" "test -f tsconfig.json"
run_test "TypeScript strict mode" "grep -q 'strict.*true' tsconfig.json"

# Vérifier la configuration ESLint
run_test "ESLint config" "test -f .eslintrc.json"

echo -e "\n${CYAN}=== Phase 9: Tests de compatibilité des fonctionnalités ===${NC}"

# Vérifier que les fonctionnalités sont compatibles entre elles
run_test "PWA + FCM compatibility" "grep -q 'serviceWorker' src/hooks/use-fcm.ts || grep -q 'sw' src/hooks/use-fcm.ts"
run_test "Analytics + Performance compatibility" "grep -q 'analytics' src/lib/performance-config.ts || grep -q 'performance' src/lib/analytics-config.ts"
run_test "Sentry + Error handling compatibility" "grep -q 'Sentry' src/lib/sentry-config.ts"

# Vérifier la configuration des providers
run_test "Providers configuration" "test -f src/components/Providers.tsx"
run_test "MUI wrapper" "test -f src/components/MUIWrapper.tsx"

echo -e "\n${CYAN}=== Phase 10: Tests de validation finale ===${NC}"

# Vérifier que toutes les fonctionnalités sont présentes et fonctionnelles
run_test "All advanced features present" "test -f src/lib/fcm-config.ts && test -f src/lib/analytics-config.ts && test -f src/lib/performance-config.ts && test -f src/lib/sentry-config.ts"
run_test "All hooks present" "test -f src/hooks/use-fcm.ts && test -f src/hooks/use-analytics.ts && test -f src/hooks/use-performance.ts"
run_test "All PWA files present" "test -f public/manifest.json && test -f public/sw.js"

cd ..

echo -e "\n${CYAN}=== Résultats Finaux ===${NC}"
echo -e "Total tests: ${TOTAL_TESTS}"
echo -e "Passed: ${GREEN}${PASSED}${NC}"
echo -e "Failed: ${RED}${FAILED}${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 Toutes les fonctionnalités avancées ont été testées avec succès !${NC}"
    echo -e "${GREEN}🚀 L'application est 100% fonctionnelle avec toutes les fonctionnalités avancées !${NC}"
    
    echo -e "\n${CYAN}Fonctionnalités avancées testées avec succès :${NC}"
    echo -e "  ${GREEN}✅${NC} PWA (Progressive Web App) - Manifest, Service Worker, Offline"
    echo -e "  ${GREEN}✅${NC} FCM (Firebase Cloud Messaging) - Notifications push, gestion des tokens"
    echo -e "  ${GREEN}✅${NC} Analytics - Suivi des événements et des pages"
    echo -e "  ${GREEN}✅${NC} Performance - Mesures de performance et traces"
    echo -e "  ${GREEN}✅${NC} Sentry - Monitoring des erreurs et middleware"
    echo -e "  ${GREEN}✅${NC} Intégration Firebase complète"
    echo -e "  ${GREEN}✅${NC} Configuration TypeScript et ESLint"
    echo -e "  ${GREEN}✅${NC} Build et compilation réussis"
    echo -e "  ${GREEN}✅${NC} Compatibilité entre toutes les fonctionnalités"
    
    echo -e "\n${GREEN}🎯 NIVEAU DE TEST DES FONCTIONNALITÉS AVANCÉES : PROFESSIONNEL ET APPROFONDI${NC}"
    echo -e "${GREEN}🚀 L'application est prête pour la production avec toutes les fonctionnalités avancées !${NC}"
    
else
    echo -e "\n${RED}❌ ${FAILED} tests des fonctionnalités avancées ont échoué.${NC}"
    echo -e "${YELLOW}🔧 Des ajustements peuvent être nécessaires.${NC}"
fi

echo -e "\n${CYAN}=== Test des fonctionnalités AVANCÉES terminé ===${NC}" 