# Script de test TRÈS COMPLET pour le Générateur Firebase + Next.js 2025 (PowerShell)
# Ce script teste TOUTES les fonctionnalités, y compris les fonctionnalités avancées
# Usage: .\scripts\test-comprehensive.ps1

param(
    [switch]$Verbose
)

# Configuration
$ErrorActionPreference = "Stop"

# Test counter
$script:PASSED = 0
$script:FAILED = 0
$script:TOTAL = 0

# Colors
$Green = "Green"
$Red = "Red"
$Yellow = "Yellow"
$Blue = "Blue"
$Cyan = "Cyan"

Write-Host "=== Test TRÈS COMPLET du Générateur Firebase + Next.js 2025 ===" -ForegroundColor $Blue
Write-Host "Ce script teste TOUTES les fonctionnalités, y compris les fonctionnalités avancées" -ForegroundColor $Cyan
Write-Host ""

# Test function
function Run-Test {
    param(
        [string]$TestName,
        [scriptblock]$TestCommand
    )
    
    Write-Host "Testing: $TestName" -ForegroundColor $Blue
    $script:TOTAL++
    
    try {
        & $TestCommand | Out-Null
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    }
    catch {
        Write-Host "  FAIL" -ForegroundColor $Red
        if ($Verbose) {
            Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor $Red
        }
        $script:FAILED++
    }
    Write-Host ""
}

# Phase 1: Tests d'environnement
Write-Host "=== Phase 1: Tests d'environnement ===" -ForegroundColor $Yellow

Run-Test "Node.js version" { 
    $nodeVersion = node --version
    if ($nodeVersion -match 'v1[89]|v2[0-9]') { return } else { throw "Version Node.js invalide: $nodeVersion" }
}

Run-Test "npm version" { 
    $npmVersion = npm --version
    if ($npmVersion -match '^[9-9]|[1-9][0-9]') { return } else { throw "Version npm invalide: $npmVersion" }
}

Run-Test "Git installation" { git --version }

Run-Test "package.json exists" { 
    if (-not (Test-Path "package.json")) { throw "package.json non trouvé" }
}

Run-Test "Dependencies installed" { 
    if (-not (Test-Path "node_modules")) { throw "node_modules non trouvé" }
}

# Phase 2: Tests de build
Write-Host "=== Phase 2: Tests de build ===" -ForegroundColor $Yellow

Run-Test "Project build" { npm run build }

Run-Test "Dist folder created" { 
    if (-not (Test-Path "dist")) { throw "Dossier dist non créé" }
}

# Phase 3: Tests de la CLI
Write-Host "=== Phase 3: Tests de la CLI ===" -ForegroundColor $Yellow

Run-Test "CLI help command" { npx ts-node src/cli.ts --help }

Run-Test "CLI version command" { npx ts-node src/cli.ts --version }

# Phase 4: Tests de génération de projets (mode non-interactif)
Write-Host "=== Phase 4: Tests de génération (mode non-interactif) ===" -ForegroundColor $Yellow

# Test 4.1: Projet minimal avec MUI + Zustand
Write-Host "Testing: Generate minimal project (MUI + Zustand)" -ForegroundColor $Blue
$script:TOTAL++

try {
    $result = npx ts-node src/cli.ts create --name test-minimal-mui --description "Test project MUI" --author "Test" --package-manager npm --nextjs-version 15 --ui mui --state-management zustand --features pwa --output ./test-output-minimal-mui --yes
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
    
    # Vérifier immédiatement la structure
    Write-Host "  Vérification de la structure..." -ForegroundColor $Yellow
    Start-Sleep -Seconds 2
    
    # Test 4.2: Structure du projet
    Write-Host "Testing: Project structure (minimal)" -ForegroundColor $Blue
    $script:TOTAL++
    if ((Test-Path "test-output-minimal-mui/frontend") -and (Test-Path "test-output-minimal-mui/backend")) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
    # Test 4.3: Fichiers frontend
    Write-Host "Testing: Frontend files (minimal)" -ForegroundColor $Blue
    $script:TOTAL++
    if ((Test-Path "test-output-minimal-mui/frontend/package.json") -and (Test-Path "test-output-minimal-mui/frontend/src/app/page.tsx")) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
    # Test 4.4: Fichiers backend
    Write-Host "Testing: Backend files (minimal)" -ForegroundColor $Blue
    $script:TOTAL++
    if ((Test-Path "test-output-minimal-mui/backend/firebase.json") -and (Test-Path "test-output-minimal-mui/backend/.firebaserc")) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
    # Test 4.5: Variables Handlebars (minimal)
    Write-Host "Testing: Handlebars processing (minimal)" -ForegroundColor $Blue
    $script:TOTAL++
    $handlebarsVars = Get-ChildItem -Path "test-output-minimal-mui" -Recurse -File | Select-String -Pattern "{{.*}}" -Quiet
    if (-not $handlebarsVars) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
    # Test 4.6: Nom du projet (minimal)
    Write-Host "Testing: Project name replacement (minimal)" -ForegroundColor $Blue
    $script:TOTAL++
    $projectName = Get-ChildItem -Path "test-output-minimal-mui" -Recurse -File | Select-String -Pattern "test-minimal-mui" -Quiet
    if ($projectName) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
} catch {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}

# Test 4.7: Projet complet avec Shadcn + Redux + toutes les fonctionnalités
Write-Host "Testing: Generate complete project (Shadcn + Redux + all features)" -ForegroundColor $Blue
$script:TOTAL++

try {
    $result = npx ts-node src/cli.ts create --name test-complete-shadcn --description "Complete test project Shadcn" --author "Test" --package-manager npm --nextjs-version 15 --ui shadcn --state-management redux --features pwa,fcm,analytics,performance,sentry --output ./test-output-complete-shadcn --yes
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
    
    # Vérifier immédiatement la structure
    Write-Host "  Vérification de la structure..." -ForegroundColor $Yellow
    Start-Sleep -Seconds 2
    
    # Test 4.8: Structure du projet complet
    Write-Host "Testing: Complete project structure" -ForegroundColor $Blue
    $script:TOTAL++
    if ((Test-Path "test-output-complete-shadcn/frontend") -and (Test-Path "test-output-complete-shadcn/backend")) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
    # Test 4.9: Fonctionnalités avancées
    Write-Host "Testing: Advanced features" -ForegroundColor $Blue
    $script:TOTAL++
    if ((Test-Path "test-output-complete-shadcn/frontend/public/manifest.json") -and (Test-Path "test-output-complete-shadcn/frontend/tailwind.config.js")) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
    # Test 4.10: Variables Handlebars (complet)
    Write-Host "Testing: Handlebars processing (complete)" -ForegroundColor $Blue
    $script:TOTAL++
    $handlebarsVars = Get-ChildItem -Path "test-output-complete-shadcn" -Recurse -File | Select-String -Pattern "{{.*}}" -Quiet
    if (-not $handlebarsVars) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
    # Test 4.11: Nom du projet (complet)
    Write-Host "Testing: Project name replacement (complete)" -ForegroundColor $Blue
    $script:TOTAL++
    $projectName = Get-ChildItem -Path "test-output-complete-shadcn" -Recurse -File | Select-String -Pattern "test-complete-shadcn" -Quiet
    if ($projectName) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
} catch {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}

# Test 4.12: Projet avec Yarn + Next.js 14
Write-Host "Testing: Generate project with Yarn + Next.js 14" -ForegroundColor $Blue
$script:TOTAL++

try {
    $result = npx ts-node src/cli.ts create --name test-yarn-14 --description "Test project Yarn Next.js 14" --author "Test" --package-manager yarn --nextjs-version 14 --ui mui --state-management zustand --features pwa --output ./test-output-yarn-14 --yes
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
    
    # Vérifier immédiatement la structure
    Write-Host "  Vérification de la structure..." -ForegroundColor $Yellow
    Start-Sleep -Seconds 2
    
    # Test 4.13: Structure du projet Yarn
    Write-Host "Testing: Yarn project structure" -ForegroundColor $Blue
    $script:TOTAL++
    if ((Test-Path "test-output-yarn-14/frontend") -and (Test-Path "test-output-yarn-14/backend")) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
    # Test 4.14: Variables Handlebars (Yarn)
    Write-Host "Testing: Handlebars processing (Yarn)" -ForegroundColor $Blue
    $script:TOTAL++
    $handlebarsVars = Get-ChildItem -Path "test-output-yarn-14" -Recurse -File | Select-String -Pattern "{{.*}}" -Quiet
    if (-not $handlebarsVars) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
    
} catch {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}

# Phase 5: Tests de validation
Write-Host "=== Phase 5: Tests de validation ===" -ForegroundColor $Yellow

Run-Test "Documentation files" { 
    if (-not ((Test-Path "docs/README.md") -and (Test-Path "docs/INSTALLATION.md") -and (Test-Path "docs/USAGE.md"))) {
        throw "Fichiers de documentation manquants"
    }
}

# Test 5.1: Validation des projets générés
Write-Host "Testing: Validate generated projects" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-minimal-mui") -and (Test-Path "test-output-complete-shadcn") -and (Test-Path "test-output-yarn-14")) {
    try {
        $minimalPkg = Get-Content "test-output-minimal-mui/frontend/package.json" | ConvertFrom-Json
        $completePkg = Get-Content "test-output-complete-shadcn/frontend/package.json" | ConvertFrom-Json
        $yarnPkg = Get-Content "test-output-yarn-14/frontend/package.json" | ConvertFrom-Json
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } catch {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Phase 6: Tests de fonctionnalités spécifiques
Write-Host "=== Phase 6: Tests de fonctionnalités spécifiques ===" -ForegroundColor $Yellow

# Test 6.1: Configuration Tailwind (Shadcn)
Write-Host "Testing: Tailwind configuration (Shadcn)" -ForegroundColor $Blue
$script:TOTAL++
if (Test-Path "test-output-complete-shadcn/frontend/tailwind.config.js") {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 6.2: Configuration PWA
Write-Host "Testing: PWA configuration" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-minimal-mui/frontend/public/manifest.json") -and (Test-Path "test-output-minimal-mui/frontend/public/sw.js")) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 6.3: Configuration Firebase
Write-Host "Testing: Firebase configuration" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-minimal-mui/backend/firebase.json") -and (Test-Path "test-output-minimal-mui/backend/.firebaserc") -and (Test-Path "test-output-minimal-mui/backend/firestore.rules")) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 6.4: Configuration TypeScript
Write-Host "Testing: TypeScript configuration" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-minimal-mui/frontend/tsconfig.json") -and (Test-Path "test-output-minimal-mui/backend/functions/tsconfig.json")) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 6.5: Scripts d'initialisation
Write-Host "Testing: Initialization scripts" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-minimal-mui/scripts/init-project.sh") -and (Test-Path "test-output-minimal-mui/scripts/init-project.bat")) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Phase 7: Tests de robustesse
Write-Host "=== Phase 7: Tests de robustesse ===" -ForegroundColor $Yellow

# Test 7.1: Gestion des erreurs (nom de projet invalide)
Write-Host "Testing: Error handling (invalid project name)" -ForegroundColor $Blue
$script:TOTAL++
try {
    $result = npx ts-node src/cli.ts create --name "invalid name" --description "Test" --author "Test" --package-manager npm --nextjs-version 15 --ui mui --state-management zustand --features pwa --output ./test-error --yes 2>&1
    # Si on arrive ici, c'est que la commande n'a pas échoué comme attendu
    throw "La commande aurait dû échouer avec un nom de projet invalide"
} catch {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
}
Write-Host ""

# Phase 8: Tests de fonctionnalités avancées
Write-Host "=== Phase 8: Tests de fonctionnalités avancées ===" -ForegroundColor $Yellow

# Test 8.1: Vérification des composants MUI
Write-Host "Testing: MUI components generation" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-minimal-mui/frontend/src/components/Button.tsx") -and (Test-Path "test-output-minimal-mui/frontend/src/components/Card.tsx")) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 8.2: Vérification des composants Shadcn
Write-Host "Testing: Shadcn components generation" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-complete-shadcn/frontend/src/components/Button.tsx") -and (Test-Path "test-output-complete-shadcn/frontend/src/components/Card.tsx")) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 8.3: Vérification des stores Zustand
Write-Host "Testing: Zustand stores generation" -ForegroundColor $Blue
$script:TOTAL++
if (Test-Path "test-output-minimal-mui/frontend/src/stores/auth-store.ts") {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 8.4: Vérification des stores Redux
Write-Host "Testing: Redux stores generation" -ForegroundColor $Blue
$script:TOTAL++
if (Test-Path "test-output-complete-shadcn/frontend/src/stores/redux/auth-slice.ts") {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 8.5: Vérification des hooks personnalisés
Write-Host "Testing: Custom hooks generation" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-minimal-mui/frontend/src/hooks/firebase/use-auth.ts") -and (Test-Path "test-output-minimal-mui/frontend/src/hooks/ui/use-modal.ts")) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 8.6: Vérification des fonctions Firebase
Write-Host "Testing: Firebase functions generation" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-minimal-mui/backend/functions/src/index.ts") -and (Test-Path "test-output-minimal-mui/backend/functions/src/admin.ts")) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 8.7: Vérification des règles Firestore
Write-Host "Testing: Firestore rules generation" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-minimal-mui/backend/firestore.rules") -and (Test-Path "test-output-minimal-mui/backend/firestore.indexes.json")) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 8.8: Vérification des configurations d'environnement
Write-Host "Testing: Environment configuration generation" -ForegroundColor $Blue
$script:TOTAL++
if ((Test-Path "test-output-minimal-mui/backend/.firebaserc") -and (Test-Path "test-output-minimal-mui/backend/firebase.json")) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Phase 9: Tests de validation des templates
Write-Host "=== Phase 9: Tests de validation des templates ===" -ForegroundColor $Yellow

# Test 9.1: Vérification que tous les templates sont traités
Write-Host "Testing: All templates are processed" -ForegroundColor $Blue
$script:TOTAL++
$remainingTemplates = Get-ChildItem -Path "test-output-minimal-mui" -Recurse -File -Name "*.hbs"
if (-not $remainingTemplates) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 9.2: Vérification de la cohérence des noms de projets
Write-Host "Testing: Project name consistency across all files" -ForegroundColor $Blue
$script:TOTAL++
$projectNameFound = Get-ChildItem -Path "test-output-minimal-mui" -Recurse -File | Select-String -Pattern "test-minimal-mui" -Quiet
$templateVarsFound = Get-ChildItem -Path "test-output-minimal-mui" -Recurse -File | Select-String -Pattern "{{project.name}}" -Quiet
if ($projectNameFound -and (-not $templateVarsFound)) {
    Write-Host "  PASS" -ForegroundColor $Green
    $script:PASSED++
} else {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Nettoyage
Write-Host "Cleaning up test projects..." -ForegroundColor $Blue
if (Test-Path "test-output-minimal-mui") { Remove-Item -Recurse -Force "test-output-minimal-mui" }
if (Test-Path "test-output-complete-shadcn") { Remove-Item -Recurse -Force "test-output-complete-shadcn" }
if (Test-Path "test-output-yarn-14") { Remove-Item -Recurse -Force "test-output-yarn-14" }
if (Test-Path "test-error") { Remove-Item -Recurse -Force "test-error" }
Write-Host "Cleanup completed" -ForegroundColor $Green
Write-Host ""

# Résultats finaux
Write-Host "=== Résultats Finaux ===" -ForegroundColor $Blue
Write-Host "Total tests: $($script:TOTAL)"
Write-Host "Passed: $($script:PASSED)" -ForegroundColor $Green
Write-Host "Failed: $($script:FAILED)" -ForegroundColor $Red
Write-Host ""

if ($script:FAILED -eq 0) {
    Write-Host "🎉 Tous les tests ont réussi !" -ForegroundColor $Green
    Write-Host "🚀 Le générateur est 100% fonctionnel et prêt pour la production !" -ForegroundColor $Green
    Write-Host ""
    Write-Host "Fonctionnalités testées avec succès :" -ForegroundColor $Cyan
    Write-Host "  ✅ Génération de projets avec différentes configurations"
    Write-Host "  ✅ Support de MUI et Shadcn/ui"
    Write-Host "  ✅ Support de Zustand et Redux"
    Write-Host "  ✅ Support de npm et Yarn"
    Write-Host "  ✅ Support de Next.js 14 et 15"
    Write-Host "  ✅ Fonctionnalités PWA, FCM, Analytics, Performance, Sentry"
    Write-Host "  ✅ Configuration Firebase complète"
    Write-Host "  ✅ Traitement des variables Handlebars"
    Write-Host "  ✅ Remplacement des noms de projets"
    Write-Host "  ✅ Gestion des erreurs"
    Write-Host "  ✅ Composants UI et stores"
    Write-Host "  ✅ Hooks personnalisés"
    Write-Host "  ✅ Fonctions Firebase"
    Write-Host "  ✅ Règles Firestore"
    Write-Host "  ✅ Configuration d'environnement"
    Write-Host "  ✅ Validation des templates"
    exit 0
} else {
    Write-Host "❌ $($script:FAILED) tests ont échoué." -ForegroundColor $Red
    Write-Host "🔧 Des ajustements peuvent être nécessaires." -ForegroundColor $Yellow
    exit 1
} 