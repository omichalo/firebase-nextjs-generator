#!/bin/bash

# Simple test script for Firebase Next.js Generator
# Usage: ./scripts/simple-test.sh

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Firebase Next.js Generator Test Suite ===${NC}"
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
run_test "Generate minimal project" "npx ts-node src/cli.ts create --name test-minimal --description 'Test project' --author 'Test' --version '1.0.0' --package-manager npm --nextjs-version 15 --ui mui --state-management zustand --features pwa --output ./test-output-minimal --non-interactive"

# Test 10: Check project structure
run_test "Project structure" "test -d test-output-minimal/frontend && test -d test-output-minimal/backend"

# Test 11: Check frontend files
run_test "Frontend files" "test -f test-output-minimal/frontend/package.json && test -f test-output-minimal/frontend/src/app/page.tsx"

# Test 12: Check backend files
run_test "Backend files" "test -f test-output-minimal/backend/firebase.json && test -f test-output-minimal/backend/.firebaserc"

# Test 13: Check Handlebars processing
run_test "Handlebars processing" "! grep -r '{{.*}}' test-output-minimal"

# Test 14: Check project name replacement
run_test "Project name replacement" "grep -r 'test-minimal' test-output-minimal"

# Test 15: Generate complete project
run_test "Generate complete project" "npx ts-node src/cli.ts create --name test-complete --description 'Complete test project' --author 'Test' --version '1.0.0' --package-manager npm --nextjs-version 15 --ui shadcn --state-management redux --features pwa,fcm,analytics,performance,sentry --output ./test-output-complete --non-interactive"

# Test 16: Check complete project structure
run_test "Complete project structure" "test -d test-output-complete/frontend && test -d test-output-complete/backend"

# Test 17: Check advanced features
run_test "Advanced features" "test -f test-output-complete/frontend/public/manifest.json && test -f test-output-complete/frontend/src/fcm/fcm-config.ts"

# Test 18: Check documentation
run_test "Documentation files" "test -f docs/README.md && test -f docs/INSTALLATION.md && test -f docs/USAGE.md"

# Test 19: Validate generated projects
run_test "Validate package.json files" "node -e \"JSON.parse(require('fs').readFileSync('test-output-minimal/frontend/package.json', 'utf8'))\" && node -e \"JSON.parse(require('fs').readFileSync('test-output-complete/frontend/package.json', 'utf8'))\""

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
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi 