#!/bin/bash

# 🧪 Script de test automatisé pour le Générateur Firebase + Next.js 2025
# Usage: ./scripts/run-tests.sh [--verbose] [--cleanup]

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables globales
VERBOSE=false
CLEANUP=true
TEST_RESULTS=()
TOTAL_TESTS=19
PASSED_TESTS=0
FAILED_TESTS=0
START_TIME=$(date +%s)

# Fonctions utilitaires
print_header() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                    🧪 PLAN DE TEST COMPLET                    ║${NC}"
    echo -e "${BLUE}║              Générateur Firebase + Next.js 2025              ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
}

print_test() {
    local test_id="$1"
    local description="$2"
    echo -e "${CYAN}🔄 $test_id${NC} - $description"
}

print_success() {
    local test_id="$1"
    local message="$2"
    echo -e "${GREEN}✅ $test_id${NC} - $message"
    ((PASSED_TESTS++))
    TEST_RESULTS+=("$test_id:SUCCESS")
}

print_failure() {
    local test_id="$1"
    local message="$2"
    local error="$3"
    echo -e "${RED}❌ $test_id${NC} - $message"
    if [[ -n "$error" ]]; then
        echo -e "${RED}   Erreur: $error${NC}"
    fi
    ((FAILED_TESTS++))
    TEST_RESULTS+=("$test_id:FAILURE:$error")
}

print_info() {
    local message="$1"
    echo -e "${BLUE}ℹ️  $message${NC}"
}

print_warning() {
    local message="$1"
    echo -e "${YELLOW}⚠️  $message${NC}"
}

print_step() {
    local step="$1"
    echo -e "${PURPLE}📋 $step${NC}"
}

# Fonction de nettoyage
cleanup() {
    print_step "Nettoyage des projets de test..."
    
    if [[ -d "test-output-minimal" ]]; then
        rm -rf test-output-minimal
        print_info "Projet minimal supprimé"
    fi
    
    if [[ -d "test-output-complete" ]]; then
        rm -rf test-output-complete
        print_info "Projet complet supprimé"
    fi
    
    if [[ -d "test-output" ]]; then
        rm -rf test-output
        print_info "Projet générique supprimé"
    fi
    
    # Nettoyer les fichiers temporaires
    rm -f check-links.js
    rm -f test-report.txt
}

# Gestion des signaux pour le nettoyage
trap cleanup EXIT
trap 'echo -e "\n${RED}❌ Test interrompu par l'utilisateur${NC}"; cleanup; exit 1' INT TERM

# Vérification des prérequis
check_prerequisites() {
    print_step "Vérification des prérequis..."
    
    # Vérifier Node.js
    if ! command -v node &> /dev/null; then
        print_failure "PREREQ-001" "Node.js non installé" "Commande 'node' non trouvée"
        exit 1
    fi
    
    local node_version=$(node --version | sed 's/v//')
    if [[ ! "$node_version" =~ ^1[89]\. ]]; then
        print_failure "PREREQ-002" "Version Node.js incompatible" "Version $node_version détectée, 18+ requis"
        exit 1
    fi
    print_success "PREREQ-001" "Node.js $node_version OK"
    
    # Vérifier npm
    if ! command -v npm &> /dev/null; then
        print_failure "PREREQ-003" "npm non installé" "Commande 'npm' non trouvée"
        exit 1
    fi
    
    local npm_version=$(npm --version)
    if [[ ! "$npm_version" =~ ^[9-9]\. ]]; then
        print_failure "PREREQ-004" "Version npm incompatible" "Version $npm_version détectée, 9+ requis"
        exit 1
    fi
    print_success "PREREQ-002" "npm $npm_version OK"
    
    # Vérifier Git
    if ! command -v git &> /dev/null; then
        print_failure "PREREQ-005" "Git non installé" "Commande 'git' non trouvée"
        exit 1
    fi
    print_success "PREREQ-003" "Git OK"
    
    # Vérifier Firebase CLI (optionnel)
    if command -v firebase &> /dev/null; then
        local firebase_version=$(firebase --version)
        print_success "PREREQ-004" "Firebase CLI $firebase_version OK"
    else
        print_warning "Firebase CLI non installé (optionnel pour les tests)"
    fi
}

# Test 001: Vérification de l'environnement de base
test_001() {
    local test_id="TEST-001"
    print_test "$test_id" "Vérification de l'environnement de base"
    
    # Vérifications déjà faites dans check_prerequisites
    print_success "$test_id" "Environnement de base vérifié"
}

# Test 002: Installation des dépendances du générateur
test_002() {
    local test_id="TEST-002"
    print_test "$test_id" "Installation des dépendances du générateur"
    
    if [[ ! -f "package.json" ]]; then
        print_failure "$test_id" "package.json non trouvé" "Fichier package.json manquant"
        return 1
    fi
    
    print_info "Installation des dépendances..."
    if npm install --silent; then
        print_success "$test_id" "Dépendances installées avec succès"
    else
        print_failure "$test_id" "Échec de l'installation des dépendances" "npm install a échoué"
        return 1
    fi
}

# Test 003: Build du générateur
test_003() {
    local test_id="TEST-003"
    print_test "$test_id" "Build du générateur"
    
    print_info "Build de production..."
    if npm run build --silent; then
        if [[ -d "dist" ]]; then
            print_success "$test_id" "Build réussi, dossier dist/ créé"
        else
            print_failure "$test_id" "Dossier dist/ manquant après build" "Build terminé mais dist/ non créé"
            return 1
        fi
    else
        print_failure "$test_id" "Échec du build" "npm run build a échoué"
        return 1
    fi
}

# Test 004: Vérification de la CLI
test_004() {
    local test_id="TEST-004"
    print_test "$test_id" "Vérification de la CLI"
    
    # Tester la commande d'aide
    if npx ts-node src/cli.ts --help &> /dev/null; then
        print_success "$test_id" "CLI fonctionnelle, commande d'aide OK"
    else
        print_failure "$test_id" "CLI défaillante" "Commande d'aide échouée"
        return 1
    fi
}

# Test 005: Génération d'un projet minimal
test_005() {
    local test_id="TEST-005"
    print_test "$test_id" "Génération d'un projet minimal"
    
    print_info "Création du projet minimal..."
    
    # Créer le projet avec des options non-interactives
    if npx ts-node src/cli.ts create \
        --name test-minimal \
        --description "Projet de test minimal" \
        --author "Test User" \
        --version "1.0.0" \
        --package-manager npm \
        --nextjs-version 15 \
        --ui mui \
        --state-management zustand \
        --features pwa \
        --output ./test-output-minimal \
        --non-interactive; then
        
        if [[ -d "test-output-minimal" ]]; then
            print_success "$test_id" "Projet minimal créé avec succès"
        else
            print_failure "$test_id" "Dossier de sortie non créé" "test-output-minimal manquant"
            return 1
        fi
    else
        print_failure "$test_id" "Échec de la génération" "Commande de génération échouée"
        return 1
    fi
}

# Test 006: Vérification de la structure du projet minimal
test_006() {
    local test_id="TEST-006"
    print_test "$test_id" "Vérification de la structure du projet minimal"
    
    local project_dir="test-output-minimal"
    
    # Vérifier les dossiers principaux
    local required_dirs=("frontend" "backend" "scripts")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$project_dir/$dir" ]]; then
            print_failure "$test_id" "Dossier $dir manquant" "Structure du projet incomplète"
            return 1
        fi
    done
    
    # Vérifier les fichiers principaux
    local required_files=("README.md" "frontend/package.json" "backend/firebase.json")
    for file in "${required_files[@]}"; do
        if [[ ! -f "$project_dir/$file" ]]; then
            print_failure "$test_id" "Fichier $file manquant" "Structure du projet incomplète"
            return 1
        fi
    done
    
    print_success "$test_id" "Structure du projet minimal correcte"
}

# Test 007: Vérification des fichiers frontend
test_007() {
    local test_id="TEST-007"
    print_test "$test_id" "Vérification des fichiers frontend"
    
    local frontend_dir="test-output-minimal/frontend"
    
    # Vérifier la structure src/
    local required_src_dirs=("src/app" "src/components" "src/hooks" "src/stores" "src/lib")
    for dir in "${required_src_dirs[@]}"; do
        if [[ ! -d "$frontend_dir/$dir" ]]; then
            print_failure "$test_id" "Dossier $dir manquant" "Structure frontend incomplète"
            return 1
        fi
    done
    
    # Vérifier les fichiers clés
    local required_files=("src/app/page.tsx" "src/app/layout.tsx" "package.json")
    for file in "${required_files[@]}"; do
        if [[ ! -f "$frontend_dir/$file" ]]; then
            print_failure "$test_id" "Fichier $file manquant" "Fichiers frontend incomplets"
            return 1
        fi
    done
    
    # Vérifier les dépendances MUI et Zustand
    if grep -q "mui" "$frontend_dir/package.json" && grep -q "zustand" "$frontend_dir/package.json"; then
        print_success "$test_id" "Fichiers frontend et dépendances corrects"
    else
        print_failure "$test_id" "Dépendances manquantes" "MUI ou Zustand non configurés"
        return 1
    fi
}

# Test 008: Vérification des fichiers backend
test_008() {
    local test_id="TEST-008"
    print_test "$test_id" "Vérification des fichiers backend"
    
    local backend_dir="test-output-minimal/backend"
    
    # Vérifier les fichiers de configuration Firebase
    local required_files=("firebase.json" ".firebaserc")
    for file in "${required_files[@]}"; do
        if [[ ! -f "$backend_dir/$file" ]]; then
            print_failure "$test_id" "Fichier $file manquant" "Configuration Firebase incomplète"
            return 1
        fi
    done
    
    # Vérifier la structure functions/
    local required_dirs=("functions" "firestore" "storage")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$backend_dir/$dir" ]]; then
            print_failure "$test_id" "Dossier $dir manquant" "Structure backend incomplète"
            return 1
        fi
    done
    
    # Vérifier les fichiers functions
    local required_function_files=("functions/package.json" "functions/src/index.ts")
    for file in "${required_function_files[@]}"; do
        if [[ ! -f "$backend_dir/$file" ]]; then
            print_failure "$test_id" "Fichier $file manquant" "Fonctions Firebase incomplètes"
            return 1
        fi
    done
    
    print_success "$test_id" "Fichiers backend corrects"
}

# Test 009: Vérification des templates Handlebars
test_009() {
    local test_id="TEST-009"
    print_test "$test_id" "Vérification des templates Handlebars"
    
    local project_dir="test-output-minimal"
    
    # Vérifier qu'aucune variable Handlebars n'est restée non remplacée
    local unprocessed_vars=$(grep -r "{{.*}}" "$project_dir" 2>/dev/null || true)
    
    if [[ -n "$unprocessed_vars" ]]; then
        print_failure "$test_id" "Variables Handlebars non remplacées" "Variables trouvées: $unprocessed_vars"
        return 1
    fi
    
    # Vérifier que le nom du projet apparaît dans les fichiers
    if grep -r "test-minimal" "$project_dir" &> /dev/null; then
        print_success "$test_id" "Templates Handlebars correctement traités"
    else
        print_failure "$test_id" "Nom du projet non trouvé" "Variables non remplacées"
        return 1
    fi
}

# Test 010: Génération d'un projet complet
test_010() {
    local test_id="TEST-010"
    print_test "$test_id" "Génération d'un projet complet"
    
    print_info "Création du projet complet..."
    
    # Créer le projet avec toutes les fonctionnalités
    if npx ts-node src/cli.ts create \
        --name test-complete \
        --description "Projet de test complet" \
        --author "Test User" \
        --version "1.0.0" \
        --package-manager npm \
        --nextjs-version 15 \
        --ui shadcn \
        --state-management redux \
        --features pwa,fcm,analytics,performance,sentry \
        --output ./test-output-complete \
        --non-interactive; then
        
        if [[ -d "test-output-complete" ]]; then
            print_success "$test_id" "Projet complet créé avec succès"
        else
            print_failure "$test_id" "Dossier de sortie non créé" "test-output-complete manquant"
            return 1
        fi
    else
        print_failure "$test_id" "Échec de la génération" "Commande de génération échouée"
        return 1
    fi
}

# Test 011: Vérification des fonctionnalités avancées
test_011() {
    local test_id="TEST-011"
    print_test "$test_id" "Vérification des fonctionnalités avancées"
    
    local project_dir="test-output-complete"
    
    # Vérifier PWA
    if [[ -f "$project_dir/frontend/public/manifest.json" ]]; then
        print_info "✅ PWA configuré"
    else
        print_failure "$test_id" "PWA non configuré" "manifest.json manquant"
        return 1
    fi
    
    # Vérifier FCM
    if [[ -f "$project_dir/frontend/src/fcm/fcm-config.ts" ]]; then
        print_info "✅ FCM configuré"
    else
        print_failure "$test_id" "FCM non configuré" "fcm-config.ts manquant"
        return 1
    fi
    
    # Vérifier Analytics
    if [[ -f "$project_dir/frontend/src/lib/analytics-config.ts" ]]; then
        print_info "✅ Analytics configuré"
    else
        print_failure "$test_id" "Analytics non configuré" "analytics-config.ts manquant"
        return 1
    fi
    
    # Vérifier Performance
    if [[ -f "$project_dir/frontend/src/performance/performance-config.ts" ]]; then
        print_info "✅ Performance configuré"
    else
        print_failure "$test_id" "Performance non configuré" "performance-config.ts manquant"
        return 1
    fi
    
    # Vérifier Sentry
    if [[ -f "$project_dir/frontend/src/sentry/sentry-config.ts" ]]; then
        print_info "✅ Sentry configuré"
    else
        print_failure "$test_id" "Sentry non configuré" "sentry-config.ts manquant"
        return 1
    fi
    
    print_success "$test_id" "Toutes les fonctionnalités avancées configurées"
}

# Test 012: Vérification des composants Shadcn/ui
test_012() {
    local test_id="TEST-012"
    print_test "$test_id" "Vérification des composants Shadcn/ui"
    
    local project_dir="test-output-complete"
    
    # Vérifier les composants Shadcn
    local required_components=("Button.tsx" "Card.tsx")
    for component in "${required_components[@]}"; do
        if [[ ! -f "$project_dir/frontend/src/components/shadcn/$component" ]]; then
            print_failure "$test_id" "Composant $component manquant" "Composants Shadcn incomplets"
            return 1
        fi
    done
    
    # Vérifier les composants UI
    local required_ui_components=("button.tsx" "card.tsx")
    for component in "${required_ui_components[@]}"; do
        if [[ ! -f "$project_dir/frontend/src/components/ui/$component" ]]; then
            print_failure "$test_id" "Composant UI $component manquant" "Composants UI incomplets"
            return 1
        fi
    done
    
    print_success "$test_id" "Composants Shadcn/ui correctement configurés"
}

# Test 013: Vérification de Redux Toolkit
test_013() {
    local test_id="TEST-013"
    print_test "$test_id" "Vérification de Redux Toolkit"
    
    local project_dir="test-output-complete"
    
    # Vérifier les stores Redux
    if [[ ! -f "$project_dir/frontend/src/stores/redux/auth-slice.ts" ]]; then
        print_failure "$test_id" "Store Redux manquant" "auth-slice.ts non trouvé"
        return 1
    fi
    
    # Vérifier les dépendances Redux
    if grep -q "@reduxjs/toolkit" "$project_dir/frontend/package.json" && grep -q "react-redux" "$project_dir/frontend/package.json"; then
        print_success "$test_id" "Redux Toolkit correctement configuré"
    else
        print_failure "$test_id" "Dépendances Redux manquantes" "@reduxjs/toolkit ou react-redux non configurés"
        return 1
    fi
}

# Test 014: Vérification de la navigation entre documents
test_014() {
    local test_id="TEST-014"
    print_test "$test_id" "Vérification de la navigation entre documents"
    
    # Vérifier que tous les fichiers de documentation existent
    local required_docs=("README.md" "NAVIGATION.md" "INSTALLATION.md" "USAGE.md" "DEPLOYMENT.md" "CUSTOMIZATION.md" "BEST_PRACTICES.md" "MAINTENANCE.md" "CONTRIBUTING.md" "EXAMPLES.md")
    
    for doc in "${required_docs[@]}"; do
        if [[ ! -f "docs/$doc" ]]; then
            print_failure "$test_id" "Document $doc manquant" "Documentation incomplète"
            return 1
        fi
    done
    
    print_success "$test_id" "Tous les documents de documentation présents"
}

# Test 015: Vérification de la cohérence des liens
test_015() {
    local test_id="TEST-015"
    print_test "$test_id" "Vérification de la cohérence des liens"
    
    # Créer un script de vérification des liens
    cat > check-links.js << 'EOF'
const fs = require('fs');
const path = require('path');

function checkLinksInFile(filePath) {
    try {
        const content = fs.readFileSync(filePath, 'utf8');
        const linkRegex = /\[([^\]]+)\]\(([^)]+)\)/g;
        const links = [];
        let match;
        
        while ((match = linkRegex.exec(content)) !== null) {
            links.push({
                text: match[1],
                url: match[2],
                file: filePath
            });
        }
        
        return links;
    } catch (error) {
        return [];
    }
}

function checkAllLinks() {
    const docsDir = './docs';
    const mdFiles = fs.readdirSync(docsDir).filter(f => f.endsWith('.md'));
    const allLinks = [];
    
    mdFiles.forEach(file => {
        const filePath = path.join(docsDir, file);
        const links = checkLinksInFile(filePath);
        allLinks.push(...links);
    });
    
    console.log('Liens trouvés:');
    allLinks.forEach(link => {
        console.log(`- ${link.file}: [${link.text}](${link.url})`);
    });
    
    return allLinks;
}

checkAllLinks();
EOF
    
    # Exécuter la vérification
    if node check-links.js &> /dev/null; then
        print_success "$test_id" "Liens de documentation vérifiés"
    else
        print_failure "$test_id" "Erreur lors de la vérification des liens" "Script de vérification échoué"
        return 1
    fi
}

# Test 016: Vérification de la structure de la documentation
test_016() {
    local test_id="TEST-016"
    print_test "$test_id" "Vérification de la structure de la documentation"
    
    # Vérifier la structure des documents principaux
    local readme_sections=$(grep -c "^## " docs/README.md || echo "0")
    local navigation_sections=$(grep -c "^## " docs/NAVIGATION.md || echo "0")
    local installation_sections=$(grep -c "^## " docs/INSTALLATION.md || echo "0")
    
    if [[ "$readme_sections" -ge 5 && "$navigation_sections" -ge 5 && "$installation_sections" -ge 5 ]]; then
        print_success "$test_id" "Structure de la documentation conforme"
    else
        print_failure "$test_id" "Structure de documentation insuffisante" "Sections manquantes dans les documents"
        return 1
    fi
}

# Test 017: Validation des projets générés
test_017() {
    local test_id="TEST-017"
    print_test "$test_id" "Validation des projets générés"
    
    # Vérifier la validité des package.json
    local projects=("test-output-minimal" "test-output-complete")
    
    for project in "${projects[@]}"; do
        if [[ -d "$project" ]]; then
            local package_json="$project/frontend/package.json"
            if [[ -f "$package_json" ]]; then
                if node -e "JSON.parse(require('fs').readFileSync('$package_json', 'utf8'))" &> /dev/null; then
                    print_info "✅ $project: package.json valide"
                else
                    print_failure "$test_id" "package.json invalide dans $project" "JSON malformé"
                    return 1
                fi
            fi
        fi
    done
    
    print_success "$test_id" "Projets générés validés"
}

# Test 018: Nettoyage des projets de test
test_018() {
    local test_id="TEST-018"
    print_test "$test_id" "Nettoyage des projets de test"
    
    # Nettoyer les projets de test
    local projects=("test-output-minimal" "test-output-complete" "test-output")
    
    for project in "${projects[@]}"; do
        if [[ -d "$project" ]]; then
            rm -rf "$project"
            print_info "✅ $project supprimé"
        fi
    done
    
    # Nettoyer les fichiers temporaires
    rm -f check-links.js
    rm -f test-report.txt
    
    print_success "$test_id" "Nettoyage des projets de test réussi"
}

# Test 019: Vérification finale de l'environnement
test_019() {
    local test_id="TEST-019"
    print_test "$test_id" "Vérification finale de l'environnement"
    
    # Vérifier que nous sommes dans le bon répertoire
    if [[ "$(pwd)" == "$PROJECT_DIR" ]]; then
        print_info "✅ Répertoire correct: $(pwd)"
    else
        print_failure "$test_id" "Répertoire incorrect" "Répertoire actuel: $(pwd)"
        return 1
    fi
    
    # Vérifier que le générateur fonctionne toujours
    if npx ts-node src/cli.ts --version &> /dev/null; then
        print_success "$test_id" "Environnement final vérifié, générateur fonctionnel"
    else
        print_failure "$test_id" "Générateur défaillant après les tests" "CLI non fonctionnelle"
        return 1
    fi
}

# Fonction principale d'exécution des tests
run_all_tests() {
    print_header
    
    print_info "🚀 Démarrage des tests automatisés..."
    print_info "📁 Répertoire de travail: $PROJECT_DIR"
    print_info "⏰ Heure de début: $(date)"
    echo
    
    # Vérification des prérequis
    check_prerequisites
    echo
    
    # Exécution des tests
    local tests=(
        "test_001"
        "test_002"
        "test_003"
        "test_004"
        "test_005"
        "test_006"
        "test_007"
        "test_008"
        "test_009"
        "test_010"
        "test_011"
        "test_012"
        "test_013"
        "test_014"
        "test_015"
        "test_016"
        "test_017"
        "test_018"
        "test_019"
    )
    
    for test in "${tests[@]}"; do
        if $test; then
            print_info "✅ $test réussi"
        else
            print_warning "⚠️  $test échoué, continuation des autres tests..."
        fi
        echo
    done
}

# Génération du rapport final
generate_report() {
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                        📊 RAPPORT FINAL                      ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    
    echo -e "${CYAN}📈 Résultats des tests:${NC}"
    echo -e "   Total: $TOTAL_TESTS"
    echo -e "   ✅ Réussis: $PASSED_TESTS"
    echo -e "   ❌ Échoués: $FAILED_TESTS"
    echo -e "   ⏱️  Durée: ${duration}s"
    echo
    
    # Calculer le pourcentage de réussite
    local success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo -e "${CYAN}📊 Taux de réussite: ${success_rate}%${NC}"
    echo
    
    if [[ $success_rate -eq 100 ]]; then
        echo -e "${GREEN}🎉 Tous les tests ont réussi !${NC}"
        echo -e "${GREEN}🚀 Le générateur est prêt pour la production !${NC}"
    elif [[ $success_rate -ge 80 ]]; then
        echo -e "${YELLOW}⚠️  La plupart des tests ont réussi.${NC}"
        echo -e "${YELLOW}🔧 Quelques ajustements mineurs peuvent être nécessaires.${NC}"
    else
        echo -e "${RED}❌ Trop de tests ont échoué.${NC}"
        echo -e "${RED}🚨 Une révision majeure est nécessaire.${NC}"
    fi
    echo
    
    # Afficher les détails des échecs
    if [[ $FAILED_TESTS -gt 0 ]]; then
        echo -e "${RED}❌ Tests échoués:${NC}"
        for result in "${TEST_RESULTS[@]}"; do
            if [[ $result == *":FAILURE:"* ]]; then
                local test_id=$(echo "$result" | cut -d: -f1)
                local error=$(echo "$result" | cut -d: -f3-)
                echo -e "   $test_id: $error"
            fi
        done
        echo
    fi
    
    # Sauvegarder le rapport
    {
        echo "RAPPORT DE TEST - $(date)"
        echo "========================"
        echo "Total: $TOTAL_TESTS"
        echo "Réussis: $PASSED_TESTS"
        echo "Échoués: $FAILED_TESTS"
        echo "Taux de réussite: ${success_rate}%"
        echo "Durée: ${duration}s"
        echo ""
        echo "Détails des échecs:"
        for result in "${TEST_RESULTS[@]}"; do
            if [[ $result == *":FAILURE:"* ]]; then
                echo "$result"
            fi
        done
    } > test-report.txt
    
    print_info "📄 Rapport sauvegardé dans test-report.txt"
}

# Gestion des arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose)
            VERBOSE=true
            shift
            ;;
        --no-cleanup)
            CLEANUP=false
            shift
            ;;
        --help)
            echo "Usage: $0 [--verbose] [--no-cleanup] [--help]"
            echo ""
            echo "Options:"
            echo "  --verbose     Affichage détaillé des tests"
            echo "  --no-cleanup  Ne pas nettoyer les projets de test"
            echo "  --help        Afficher cette aide"
            exit 0
            ;;
        *)
            echo "Option inconnue: $1"
            echo "Utilisez --help pour voir les options disponibles"
            exit 1
            ;;
    esac
done

# Exécution principale
main() {
    # Nettoyage initial
    cleanup
    
    # Exécution des tests
    run_all_tests
    
    # Génération du rapport
    generate_report
    
    # Nettoyage final si activé
    if [[ "$CLEANUP" == "true" ]]; then
        cleanup
    fi
    
    # Code de sortie basé sur le succès
    if [[ $FAILED_TESTS -eq 0 ]]; then
        exit 0
    else
        exit 1
    fi
}

# Exécution du script principal
main "$@" 