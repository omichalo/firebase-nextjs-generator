#!/bin/bash

# Script de test qui fonctionne vraiment pour le Générateur Firebase + Next.js 2025
# Usage: ./scripts/working-test.sh

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Test Fonctionnel du Générateur Firebase + Next.js 2025 ===${NC}"
echo

# Test counter
PASSED=0
FAILED=0
TOTAL=0

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -e "${BLUE}Testing: $test_name${NC}"
    TOTAL=$((TOTAL + 1))
    
    if eval "$test_command" 2>/dev/null; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
}

# Test 1: Check Node.js
run_test "Node.js version" "node --version | grep -q 'v1[89]\\|v2[0-9]'"

# Test 2: Check npm
run_test "npm version" "npm --version | grep -q '^[9-9]\\|[1-9][0-9]'"

# Test 3: Check Git
run_test "Git installation" "git --version"

# Test 4: Check package.json
run_test "package.json exists" "test -f package.json"

# Test 5: Check dependencies
run_test "Dependencies installed" "test -d node_modules"

# Test 6: Build project
run_test "Project build" "npm run build"

# Test 7: Check dist folder
run_test "Dist folder created" "test -d dist"

# Test 8: CLI help
run_test "CLI help command" "npx ts-node src/cli.ts --help"

# Test 9: Generate minimal project
echo -e "${BLUE}Testing: Generate minimal project${NC}"
TOTAL=$((TOTAL + 1))

if npx ts-node src/cli.ts create --name test-minimal --description "Test project" --author "Test" --version "1.0.0" --package-manager npm --nextjs-version 15 --ui mui --state-management zustand --features pwa --output ./test-output-minimal --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
    
    # Wait for project to be fully created
    echo -e "${YELLOW}  Waiting for project files to be created...${NC}"
    sleep 3
    
    # Test 10: Check project structure (immediately after generation)
    echo -e "${BLUE}Testing: Project structure${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -d "test-output-minimal/frontend" ] && [ -d "test-output-minimal/backend" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 11: Check frontend files (immediately after generation)
    echo -e "${BLUE}Testing: Frontend files${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -f "test-output-minimal/frontend/package.json" ] && [ -f "test-output-minimal/frontend/src/app/page.tsx" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 12: Check backend files (immediately after generation)
    echo -e "${BLUE}Testing: Backend files${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -f "test-output-minimal/backend/firebase.json" ] && [ -f "test-output-minimal/backend/.firebaserc" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 13: Check Handlebars processing (immediately after generation)
    echo -e "${BLUE}Testing: Handlebars processing${NC}"
    TOTAL=$((TOTAL + 1))
    if ! grep -r "{{.*}}" test-output-minimal 2>/dev/null; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 14: Check project name replacement (immediately after generation)
    echo -e "${BLUE}Testing: Project name replacement${NC}"
    TOTAL=$((TOTAL + 1))
    if grep -r "test-minimal" test-output-minimal >/dev/null 2>&1; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi

# Test 15: Generate complete project
echo -e "${BLUE}Testing: Generate complete project${NC}"
TOTAL=$((TOTAL + 1))

if npx ts-node src/cli.ts create --name test-complete --description "Complete test project" --author "Test" --version "1.0.0" --package-manager npm --nextjs-version 15 --ui shadcn --state-management redux --features pwa,fcm,analytics,performance,sentry --output ./test-output-complete --yes; then
    echo -e "${GREEN}  PASS${NC}"
    PASSED=$((PASSED + 1))
    
    # Wait for project to be fully created
    echo -e "${YELLOW}  Waiting for project files to be created...${NC}"
    sleep 3
    
    # Test 16: Check complete project structure (immediately after generation)
    echo -e "${BLUE}Testing: Complete project structure${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -d "test-output-complete/frontend" ] && [ -d "test-output-complete/backend" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
    # Test 17: Check advanced features (immediately after generation)
    echo -e "${BLUE}Testing: Advanced features${NC}"
    TOTAL=$((TOTAL + 1))
    if [ -f "test-output-complete/frontend/public/manifest.json" ]; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo
    
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi

# Test 18: Check documentation
run_test "Documentation files" "test -f docs/README.md && test -f docs/INSTALLATION.md && test -f docs/USAGE.md"

# Test 19: Validate generated projects (immediately after generation)
echo -e "${BLUE}Testing: Validate package.json files${NC}"
TOTAL=$((TOTAL + 1))
if [ -d "test-output-minimal" ] && [ -d "test-output-complete" ]; then
    if node -e "JSON.parse(require('fs').readFileSync('test-output-minimal/frontend/package.json', 'utf8'))" 2>/dev/null && node -e "JSON.parse(require('fs').readFileSync('test-output-complete/frontend/package.json', 'utf8'))" 2>/dev/null; then
        echo -e "${GREEN}  PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
else
    echo -e "${RED}  FAIL${NC}"
    FAILED=$((FAILED + 1))
fi
echo

# Cleanup
echo -e "${BLUE}Cleaning up test projects...${NC}"
rm -rf test-output-minimal test-output-complete
echo -e "${GREEN}Cleanup completed${NC}"
echo

# Results
echo -e "${BLUE}=== Test Results ===${NC}"
echo -e "Total tests: $TOTAL"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 Tous les tests ont réussi !${NC}"
    echo -e "${GREEN}🚀 Le générateur est prêt pour la production !${NC}"
    exit 0
else
    echo -e "${RED}❌ $FAILED tests ont échoué.${NC}"
    echo -e "${YELLOW}🔧 Des ajustements peuvent être nécessaires.${NC}"
    exit 1
fi 