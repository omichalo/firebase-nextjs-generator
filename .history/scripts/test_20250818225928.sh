#!/bin/bash

# Unified test entrypoint for the Firebase + Next.js generator
# Usage:
#   ./scripts/test.sh                # Run comprehensive tests only
#   ./scripts/test.sh --full         # Run comprehensive + generated-apps tests
#   TEST_OUTPUT_DIR=.custom-dir ./scripts/test.sh --full

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

MODE="comprehensive"
if [[ "${1-}" == "--full" ]]; then
	MODE="full"
fi

# Artifacts directory (non-committed)
BASE_ARTIFACTS_DIR="${TEST_OUTPUT_DIR:-.test-artifacts}"
RUN_ID="run-$(date +%Y%m%d-%H%M%S)"
ARTIFACTS_DIR="${BASE_ARTIFACTS_DIR}/${RUN_ID}"
mkdir -p "${ARTIFACTS_DIR}"

echo -e "${BLUE}=== Unified Test Runner ===${NC}"
echo -e "${CYAN}Artifacts directory:${NC} ${ARTIFACTS_DIR}"

echo -e "${YELLOW}Pre-cleaning any stale test projects in repo root...${NC}"
# Only remove known generated patterns in repo root (keep fixtures like test-clean/ etc.)
rm -rf test-output-* test-app-* 2>/dev/null || true

echo -e "${YELLOW}Running comprehensive tests...${NC}"
COMPREHENSIVE_LOG="${ARTIFACTS_DIR}/test-comprehensive.log"
set +e
./scripts/test-comprehensive.sh 2>&1 | tee "${COMPREHENSIVE_LOG}"
COMPREHENSIVE_EXIT=${PIPESTATUS[0]}
set -e

echo -e "${BLUE}Comprehensive tests log:${NC} ${COMPREHENSIVE_LOG}"

GENERATED_EXIT=0
if [[ "${MODE}" == "full" ]]; then
	echo -e "${YELLOW}Running generated-apps tests...${NC}"
	GENERATED_LOG="${ARTIFACTS_DIR}/test-generated-apps.log"
	set +e
	./scripts/test-generated-apps.sh 2>&1 | tee "${GENERATED_LOG}"
	GENERATED_EXIT=${PIPESTATUS[0]}
	set -e
	echo -e "${BLUE}Generated-apps tests log:${NC} ${GENERATED_LOG}"
fi

# Final cleanup to ensure repo root remains clean
rm -rf test-output-* test-app-* 2>/dev/null || true

echo
if [[ ${COMPREHENSIVE_EXIT} -eq 0 && ${GENERATED_EXIT} -eq 0 ]]; then
	echo -e "${GREEN}All selected test suites passed.${NC}"
	exit 0
else
	echo -e "${RED}One or more test suites failed.${NC}"
	echo -e "${YELLOW}See logs in:${NC} ${ARTIFACTS_DIR}"
	exit 1
fi 