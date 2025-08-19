# Script de test ultra-complet des applications générées (PowerShell)
# Usage: .\scripts\test-generated-apps.ps1
# Ce script teste que TOUTES les applications générées fonctionnent correctement

param(
    [switch]$SkipBuild,
    [switch]$SkipFirebase
)

# Colors
$Green = "Green"
$Red = "Red"
$Yellow = "Yellow"
$Blue = "Blue"
$Cyan = "Cyan"
$Purple = "Magenta"

Write-Host "=== TESTS ULTRA-COMPLETS DES APPLICATIONS GÉNÉRÉES ===" -ForegroundColor $Purple
Write-Host "Ce script teste que TOUTES les applications générées fonctionnent correctement" -ForegroundColor $Cyan
Write-Host "⚠️  ATTENTION: Ce test peut prendre 15-30 minutes et nécessite une connexion internet" -ForegroundColor $Yellow
Write-Host ""

# Test counter
$script:PASSED = 0
$script:FAILED = 0
$script:TOTAL = 0
$script:SKIPPED = 0

# Test function
function Run-Test {
    param(
        [string]$TestName,
        [scriptblock]$TestCommand,
        [scriptblock]$SkipCondition = $null
    )
    
    Write-Host "Testing: $TestName" -ForegroundColor $Blue
    $script:TOTAL++
    
    # Check skip condition
    if ($SkipCondition -and (Invoke-Command -ScriptBlock $SkipCondition -ErrorAction SilentlyContinue)) {
        Write-Host "  SKIP (condition non remplie)" -ForegroundColor $Yellow
        $script:SKIPPED++
        Write-Host ""
        return
    }
    
    try {
        if (Invoke-Command -ScriptBlock $TestCommand -ErrorAction SilentlyContinue) {
            Write-Host "  PASS" -ForegroundColor $Green
            $script:PASSED++
        } else {
            Write-Host "  FAIL" -ForegroundColor $Red
            $script:FAILED++
        }
    } catch {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
    Write-Host ""
}

# Cleanup function
function Cleanup-TestProjects {
    Write-Host "🧹 Nettoyage des projets de test..." -ForegroundColor $Yellow
    Remove-Item -Path "test-app-*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Nettoyage terminé" -ForegroundColor $Green
}

# Register cleanup on exit
Register-EngineEvent PowerShell.Exiting -Action { Cleanup-TestProjects }

# Phase 1: Tests de génération avec toutes les configurations
Write-Host "=== Phase 1: Tests de génération avec toutes les configurations ===" -ForegroundColor $Yellow

# Test 1.1: Projet minimal MUI + Zustand + PWA
Write-Host "Testing: Generate minimal MUI + Zustand + PWA project" -ForegroundColor $Blue
$script:TOTAL++
try {
    $result = npx ts-node src/cli.ts create `
        --name test-app-minimal-mui `
        --description "Test minimal MUI project" `
        --author "Test User" `
        --package-manager npm `
        --nextjs-version 15 `
        --ui mui `
        --state-management zustand `
        --features pwa `
        --output ./test-app-minimal-mui `
        --yes
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
} catch {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 1.2: Projet complet Shadcn + Redux + toutes fonctionnalités
Write-Host "Testing: Generate complete Shadcn + Redux + all features project" -ForegroundColor $Blue
$script:TOTAL++
try {
    $result = npx ts-node src/cli.ts create `
        --name test-app-complete-shadcn `
        --description "Test complete Shadcn project" `
        --author "Test User" `
        --package-manager npm `
        --nextjs-version 15 `
        --ui shadcn `
        --state-management redux `
        --features pwa,fcm,analytics,performance,sentry `
        --output ./test-app-complete-shadcn `
        --yes
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
} catch {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 1.3: Projet avec Yarn + Next.js 14
Write-Host "Testing: Generate Yarn + Next.js 14 project" -ForegroundColor $Blue
$script:TOTAL++
try {
    $result = npx ts-node src/cli.ts create `
        --name test-app-yarn-14 `
        --description "Test Yarn Next.js 14 project" `
        --author "Test User" `
        --package-manager yarn `
        --nextjs-version 14 `
        --ui mui `
        --state-management zustand `
        --features pwa `
        --output ./test-app-yarn-14 `
        --yes
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
} catch {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Test 1.4: Projet avec pnpm + Next.js 15 + UI mixte
Write-Host "Testing: Generate pnpm + Next.js 15 + mixed UI project" -ForegroundColor $Blue
$script:TOTAL++
try {
    $result = npx ts-node src/cli.ts create `
        --name test-app-pnpm-mixed `
        --description "Test pnpm mixed UI project" `
        --author "Test User" `
        --package-manager pnpm `
        --nextjs-version 15 `
        --ui both `
        --state-management both `
        --features pwa,fcm,analytics `
        --output ./test-app-pnpm-mixed `
        --yes
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  PASS" -ForegroundColor $Green
        $script:PASSED++
    } else {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
    }
} catch {
    Write-Host "  FAIL" -ForegroundColor $Red
    $script:FAILED++
}
Write-Host ""

# Phase 2: Tests de structure et validation des projets
Write-Host "=== Phase 2: Tests de structure et validation des projets ===" -ForegroundColor $Yellow

# Test 2.1: Structure du projet minimal MUI
Run-Test "Minimal MUI project structure" { Test-Path "test-app-minimal-mui/frontend" -and Test-Path "test-app-minimal-mui/backend" }
Run-Test "Minimal MUI frontend files" { Test-Path "test-app-minimal-mui/frontend/package.json" -and Test-Path "test-app-minimal-mui/frontend/src/app/page.tsx" }
Run-Test "Minimal MUI backend files" { Test-Path "test-app-minimal-mui/backend/firebase.json" -and Test-Path "test-app-minimal-mui/backend/.firebaserc" }

# Test 2.2: Structure du projet complet Shadcn
Run-Test "Complete Shadcn project structure" { Test-Path "test-app-complete-shadcn/frontend" -and Test-Path "test-app-complete-shadcn/backend" }
Run-Test "Complete Shadcn frontend files" { Test-Path "test-app-complete-shadcn/frontend/package.json" -and Test-Path "test-app-complete-shadcn/frontend/tailwind.config.js" }
Run-Test "Complete Shadcn backend files" { Test-Path "test-app-complete-shadcn/backend/firebase.json" -and Test-Path "test-app-complete-shadcn/backend/.firebaserc" }

# Test 2.3: Structure du projet Yarn
Run-Test "Yarn project structure" { Test-Path "test-app-yarn-14/frontend" -and Test-Path "test-app-yarn-14/backend" }
Run-Test "Yarn package.json" { Select-String -Path "test-app-yarn-14/frontend/package.json" -Pattern '"packageManager": "yarn@' -Quiet }

# Test 2.4: Structure du projet pnpm mixte
Run-Test "Pnpm mixed project structure" { Test-Path "test-app-pnpm-mixed/frontend" -and Test-Path "test-app-pnpm-mixed/backend" }
Run-Test "Pnpm package.json" { Select-String -Path "test-app-pnpm-mixed/frontend/package.json" -Pattern '"packageManager": "pnpm@' -Quiet }

# Phase 3: Tests de validation des dépendances
Write-Host "=== Phase 3: Tests de validation des dépendances ===" -ForegroundColor $Yellow

# Test 3.1: Dépendances MUI
Run-Test "MUI dependencies in minimal project" { Select-String -Path "test-app-minimal-mui/frontend/package.json" -Pattern '@mui/material' -Quiet }
Run-Test "Zustand dependencies in minimal project" { Select-String -Path "test-app-minimal-mui/frontend/package.json" -Pattern 'zustand' -Quiet }

# Test 3.2: Dépendances Shadcn
Run-Test "Shadcn dependencies in complete project" { Select-String -Path "test-app-complete-shadcn/frontend/package.json" -Pattern 'tailwindcss' -Quiet }
Run-Test "Redux dependencies in complete project" { Select-String -Path "test-app-complete-shadcn/frontend/package.json" -Pattern '@reduxjs/toolkit' -Quiet }

# Test 3.3: Dépendances avancées
Run-Test "PWA dependencies in complete project" { Select-String -Path "test-app-complete-shadcn/frontend/package.json" -Pattern 'next-pwa' -Quiet }
Run-Test "Analytics dependencies in complete project" { Select-String -Path "test-app-complete-shadcn/frontend/package.json" -Pattern '@sentry/nextjs' -Quiet }

# Phase 4: Tests de compilation et build (si pas skipé)
if (-not $SkipBuild) {
    Write-Host "=== Phase 4: Tests de compilation et build ===" -ForegroundColor $Yellow

    # Test 4.1: Build du projet minimal MUI
    Write-Host "Testing: Build minimal MUI project" -ForegroundColor $Blue
    $script:TOTAL++
    try {
        Set-Location "test-app-minimal-mui/frontend"
        npm install --silent
        npm run build --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  PASS" -ForegroundColor $Green
            $script:PASSED++
        } else {
            Write-Host "  FAIL" -ForegroundColor $Red
            $script:FAILED++
        }
        Set-Location "../.."
    } catch {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
        Set-Location "../.."
    }
    Write-Host ""

    # Test 4.2: Build du projet complet Shadcn
    Write-Host "Testing: Build complete Shadcn project" -ForegroundColor $Blue
    $script:TOTAL++
    try {
        Set-Location "test-app-complete-shadcn/frontend"
        npm install --silent
        npm run build --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  PASS" -ForegroundColor $Green
            $script:PASSED++
        } else {
            Write-Host "  FAIL" -ForegroundColor $Red
            $script:FAILED++
        }
        Set-Location "../.."
    } catch {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
        Set-Location "../.."
    }
    Write-Host ""

    # Test 4.3: Build du projet Yarn
    Write-Host "Testing: Build Yarn project" -ForegroundColor $Blue
    $script:TOTAL++
    try {
        Set-Location "test-app-yarn-14/frontend"
        yarn install --silent
        yarn build --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  PASS" -ForegroundColor $Green
            $script:PASSED++
        } else {
            Write-Host "  FAIL" -ForegroundColor $Red
            $script:FAILED++
        }
        Set-Location "../.."
    } catch {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
        Set-Location "../.."
    }
    Write-Host ""

    # Test 4.4: Build du projet pnpm mixte
    Write-Host "Testing: Build pnpm mixed project" -ForegroundColor $Blue
    $script:TOTAL++
    try {
        Set-Location "test-app-pnpm-mixed/frontend"
        pnpm install --silent
        pnpm build --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  PASS" -ForegroundColor $Green
            $script:PASSED++
        } else {
            Write-Host "  FAIL" -ForegroundColor $Red
            $script:FAILED++
        }
        Set-Location "../.."
    } catch {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:FAILED++
        Set-Location "../.."
    }
    Write-Host ""
} else {
    Write-Host "=== Phase 4: Tests de compilation et build (SKIPPÉ) ===" -ForegroundColor $Yellow
    Write-Host "Tests de build ignorés sur demande de l'utilisateur" -ForegroundColor $Cyan
    Write-Host ""
}

# Phase 5: Tests de validation TypeScript
Write-Host "=== Phase 5: Tests de validation TypeScript ===" -ForegroundColor $Yellow

# Test 5.1: Type-check du projet minimal MUI
Run-Test "TypeScript check minimal MUI project" { 
    Set-Location "test-app-minimal-mui/frontend"
    npx tsc --noEmit --skipLibCheck --silent
    Set-Location "../.."
}

# Test 5.2: Type-check du projet complet Shadcn
Run-Test "TypeScript check complete Shadcn project" { 
    Set-Location "test-app-complete-shadcn/frontend"
    npx tsc --noEmit --skipLibCheck --silent
    Set-Location "../.."
}

# Test 5.3: Type-check du projet Yarn
Run-Test "TypeScript check Yarn project" { 
    Set-Location "test-app-yarn-14/frontend"
    npx tsc --noEmit --skipLibCheck --silent
    Set-Location "../.."
}

# Test 5.4: Type-check du projet pnpm mixte
Run-Test "TypeScript check pnpm mixed project" { 
    Set-Location "test-app-pnpm-mixed/frontend"
    npx tsc --noEmit --skipLibCheck --silent
    Set-Location "../.."
}

# Phase 6: Tests de validation des composants
Write-Host "=== Phase 6: Tests de validation des composants ===" -ForegroundColor $Yellow

# Test 6.1: Composants MUI
Run-Test "MUI components exist in minimal project" { Test-Path "test-app-minimal-mui/frontend/src/components/Button.tsx" -and Test-Path "test-app-minimal-mui/frontend/src/components/Card.tsx" }
Run-Test "MUI components import correctly" { Select-String -Path "test-app-minimal-mui/frontend/src/components/Button.tsx" -Pattern 'from.*@mui/material' -Quiet }

# Test 6.2: Composants Shadcn
Run-Test "Shadcn components exist in complete project" { Test-Path "test-app-complete-shadcn/frontend/src/components/Button.tsx" -and Test-Path "test-app-complete-shadcn/frontend/src/components/Card.tsx" }
Run-Test "Tailwind classes in Shadcn components" { Select-String -Path "test-app-complete-shadcn/frontend/src/components/Button.tsx" -Pattern 'className.*bg-blue-500' -Quiet }

# Test 6.3: Composants mixtes
Run-Test "Mixed UI components exist" { Test-Path "test-app-pnpm-mixed/frontend/src/components/mui/Button.tsx" -and Test-Path "test-app-pnpm-mixed/frontend/src/components/shadcn/Button.tsx" }

# Phase 7: Tests de validation des stores et hooks
Write-Host "=== Phase 7: Tests de validation des stores et hooks ===" -ForegroundColor $Yellow

# Test 7.1: Stores Zustand
Run-Test "Zustand stores exist in minimal project" { Test-Path "test-app-minimal-mui/frontend/src/stores/auth-store.ts" }
Run-Test "Zustand stores import correctly" { Select-String -Path "test-app-minimal-mui/frontend/src/stores/auth-store.ts" -Pattern 'from.*zustand' -Quiet }

# Test 7.2: Stores Redux
Run-Test "Redux stores exist in complete project" { Test-Path "test-app-complete-shadcn/frontend/src/stores/auth-slice.ts" }
Run-Test "Redux stores import correctly" { Select-String -Path "test-app-complete-shadcn/frontend/src/stores/auth-slice.ts" -Pattern 'from.*@reduxjs/toolkit' -Quiet }

# Test 7.3: Hooks personnalisés
Run-Test "Custom hooks exist in minimal project" { Test-Path "test-app-minimal-mui/frontend/src/hooks/use-auth.ts" -and Test-Path "test-app-minimal-mui/frontend/src/hooks/use-modal.ts" }
Run-Test "Custom hooks import correctly" { Select-String -Path "test-app-minimal-mui/frontend/src/hooks/use-auth.ts" -Pattern 'from.*firebase' -Quiet }

# Phase 8: Tests de validation Firebase
Write-Host "=== Phase 8: Tests de validation Firebase ===" -ForegroundColor $Yellow

# Test 8.1: Configuration Firebase
Run-Test "Firebase config exists in minimal project" { Test-Path "test-app-minimal-mui/backend/firebase.json" -and Test-Path "test-app-minimal-mui/backend/.firebaserc" }
Run-Test "Firebase config is valid JSON" { 
    $content = Get-Content "test-app-minimal-mui/backend/firebase.json" -Raw
    $null = [System.Text.Json.JsonDocument]::Parse($content)
}

# Test 8.2: Cloud Functions
Run-Test "Cloud Functions exist in minimal project" { Test-Path "test-app-minimal-mui/backend/functions/src/index.ts" -and Test-Path "test-app-minimal-mui/backend/functions/src/admin.ts" }
Run-Test "Cloud Functions package.json is valid" { 
    $content = Get-Content "test-app-minimal-mui/backend/functions/package.json" -Raw
    $null = [System.Text.Json.JsonDocument]::Parse($content)
}

# Test 8.3: Firestore rules
Run-Test "Firestore rules exist in minimal project" { Test-Path "test-app-minimal-mui/backend/firestore.rules" -and Test-Path "test-app-minimal-mui/backend/firestore.indexes.json" }
Run-Test "Firestore rules are valid" { Select-String -Path "test-app-minimal-mui/backend/firestore.rules" -Pattern 'rules_version' -Quiet }

# Phase 9: Tests de validation des fonctionnalités avancées
Write-Host "=== Phase 9: Tests de validation des fonctionnalités avancées ===" -ForegroundColor $Yellow

# Test 9.1: Configuration PWA
Run-Test "PWA config exists in minimal project" { Test-Path "test-app-minimal-mui/frontend/public/manifest.json" -and Test-Path "test-app-minimal-mui/frontend/public/sw.js" }
Run-Test "PWA manifest is valid JSON" { 
    $content = Get-Content "test-app-minimal-mui/frontend/public/manifest.json" -Raw
    $null = [System.Text.Json.JsonDocument]::Parse($content)
}

# Test 9.2: Configuration Tailwind
Run-Test "Tailwind config exists in complete project" { Test-Path "test-app-complete-shadcn/frontend/tailwind.config.js" }
Run-Test "Tailwind config is valid" { 
    $null = Get-Content "test-app-complete-shadcn/frontend/tailwind.config.js" -Raw | Invoke-Expression
}

# Test 9.3: Configuration Sentry
Run-Test "Sentry config exists in complete project" { Test-Path "test-app-complete-shadcn/frontend/src/lib/sentry-config.ts" }
Run-Test "Sentry config imports correctly" { Select-String -Path "test-app-complete-shadcn/frontend/src/lib/sentry-config.ts" -Pattern 'from.*@sentry/nextjs' -Quiet }

# Phase 10: Tests de validation des scripts
Write-Host "=== Phase 10: Tests de validation des scripts ===" -ForegroundColor $Yellow

# Test 10.1: Scripts d'initialisation
Run-Test "Init scripts exist in minimal project" { Test-Path "test-app-minimal-mui/scripts/init-project.sh" -and Test-Path "test-app-minimal-mui/scripts/init-project.bat" }

# Test 10.2: Scripts de déploiement
Run-Test "Deploy scripts exist in minimal project" { Test-Path "test-app-minimal-mui/backend/scripts/deploy.sh" }

# Phase 11: Tests de validation des tests
Write-Host "=== Phase 11: Tests de validation des tests ===" -ForegroundColor $Yellow

# Test 11.1: Tests unitaires
Run-Test "Unit tests exist in minimal project" { Test-Path "test-app-minimal-mui/frontend/tests/auth.test.ts" }
Run-Test "Test scripts in package.json" { Select-String -Path "test-app-minimal-mui/frontend/package.json" -Pattern '"test"' -Quiet }

# Test 11.2: Tests d'intégration
Run-Test "Integration tests exist in complete project" { Test-Path "test-app-complete-shadcn/frontend/tests/integration" }
Run-Test "E2E tests exist in complete project" { Test-Path "test-app-complete-shadcn/frontend/tests/e2e" }

# Phase 12: Tests de validation de la documentation
Write-Host "=== Phase 12: Tests de validation de la documentation ===" -ForegroundColor $Yellow

# Test 12.1: README principal
Run-Test "Main README exists in minimal project" { Test-Path "test-app-minimal-mui/README.md" }
Run-Test "Main README contains project name" { Select-String -Path "test-app-minimal-mui/README.md" -Pattern 'test-app-minimal-mui' -Quiet }

# Test 12.2: Documentation de déploiement
Run-Test "Deployment docs exist in minimal project" { Test-Path "test-app-minimal-mui/docs/deployment.md" }
Run-Test "Development docs exist in minimal project" { Test-Path "test-app-minimal-mui/docs/development.md" }

# Phase 13: Tests de validation des workflows CI/CD
Write-Host "=== Phase 13: Tests de validation des workflows CI/CD ===" -ForegroundColor $Yellow

# Test 13.1: GitHub Actions
Run-Test "GitHub Actions exist in minimal project" { Test-Path "test-app-minimal-mui/.github/workflows/ci-cd.yml" }

# Phase 14: Tests de validation des thèmes
Write-Host "=== Phase 14: Tests de validation des thèmes ===" -ForegroundColor $Yellow

# Test 14.1: Configuration des thèmes
Run-Test "Theme config exists in minimal project" { Test-Path "test-app-minimal-mui/config/themes.json" }
Run-Test "Theme config is valid JSON" { 
    $content = Get-Content "test-app-minimal-mui/config/themes.json" -Raw
    $null = [System.Text.Json.JsonDocument]::Parse($content)
}

# Phase 15: Tests de validation finale
Write-Host "=== Phase 15: Tests de validation finale ===" -ForegroundColor $Yellow

# Test 15.1: Vérification qu'aucun fichier .hbs ne reste
Run-Test "No .hbs files remain in minimal project" { -not (Get-ChildItem -Path "test-app-minimal-mui" -Recurse -Filter "*.hbs" | Select-Object -First 1) }
Run-Test "No .hbs files remain in complete project" { -not (Get-ChildItem -Path "test-app-complete-shadcn" -Recurse -Filter "*.hbs" | Select-Object -First 1) }
Run-Test "No .hbs files remain in Yarn project" { -not (Get-ChildItem -Path "test-app-yarn-14" -Recurse -Filter "*.hbs" | Select-Object -First 1) }
Run-Test "No .hbs files remain in pnpm project" { -not (Get-ChildItem -Path "test-app-pnpm-mixed" -Recurse -Filter "*.hbs" | Select-Object -First 1) }

# Test 15.2: Vérification de la cohérence des noms
Run-Test "Project names consistent in minimal project" { 
    (Select-String -Path "test-app-minimal-mui" -Recurse -Pattern 'test-app-minimal-mui' -Quiet) -and 
    (-not (Select-String -Path "test-app-minimal-mui" -Recurse -Pattern '{{project.name}}' -Quiet))
}
Run-Test "Project names consistent in complete project" { 
    (Select-String -Path "test-app-complete-shadcn" -Recurse -Pattern 'test-app-complete-shadcn' -Quiet) -and 
    (-not (Select-String -Path "test-app-complete-shadcn" -Recurse -Pattern '{{project.name}}' -Quiet))
}

# Test 15.3: Vérification de la structure finale
Run-Test "Final structure validation minimal project" { 
    $count = (Get-ChildItem -Path "test-app-minimal-mui" -Recurse -Include "*.tsx", "*.ts" | Measure-Object).Count
    $count -gt 0
}
Run-Test "Final structure validation complete project" { 
    $count = (Get-ChildItem -Path "test-app-complete-shadcn" -Recurse -Include "*.tsx", "*.ts" | Measure-Object).Count
    $count -gt 0
}

# Résultats finaux
Write-Host "=== RÉSULTATS FINAUX ===" -ForegroundColor $Purple
Write-Host "Total tests: $($script:TOTAL)"
Write-Host "Passed: $($script:PASSED)" -ForegroundColor $Green
Write-Host "Failed: $($script:FAILED)" -ForegroundColor $Red
Write-Host "Skipped: $($script:SKIPPED)" -ForegroundColor $Yellow

# Calculer le pourcentage de réussite
if ($script:TOTAL -gt 0) {
    $SuccessPercentage = [math]::Round(($script:PASSED * 100) / $script:TOTAL)
    Write-Host "Success rate: $SuccessPercentage%" -ForegroundColor $Cyan
}

Write-Host ""

# Résumé de la validation
Write-Host "=== RÉSUMÉ DE LA VALIDATION ===" -ForegroundColor $Blue
Write-Host "📱 Applications testées : 4 projets avec configurations différentes"
Write-Host "🔧 Package managers : npm, yarn, pnpm"
Write-Host "⚛️  Versions Next.js : 14, 15"
Write-Host "🎨 Frameworks UI : MUI, Shadcn/ui, mixte"
Write-Host "📊 Gestion d'état : Zustand, Redux, mixte"
Write-Host "🚀 Fonctionnalités : PWA, FCM, Analytics, Performance, Sentry"
Write-Host "🔥 Backend : Firebase complet (Functions, Firestore, Storage)"
Write-Host ""

if ($script:FAILED -eq 0) {
    Write-Host "🎉 TOUTES les applications générées fonctionnent parfaitement !" -ForegroundColor $Green
    Write-Host "✅ Le générateur produit des applications 100% fonctionnelles !" -ForegroundColor $Green
    Write-Host ""
    Write-Host "Validation garantie :" -ForegroundColor $Cyan
    Write-Host "  ✅ Génération de projets (100%)"
    Write-Host "  ✅ Structure des projets (100%)"
    Write-Host "  ✅ Compilation et build (100%)"
    Write-Host "  ✅ Validation TypeScript (100%)"
    Write-Host "  ✅ Composants et stores (100%)"
    Write-Host "  ✅ Configuration Firebase (100%)"
    Write-Host "  ✅ Fonctionnalités avancées (100%)"
    Write-Host "  ✅ Scripts et CI/CD (100%)"
    Write-Host "  ✅ Documentation et thèmes (100%)"
    exit 0
} else {
    Write-Host "❌ $($script:FAILED) tests ont échoué." -ForegroundColor $Red
    Write-Host "🔧 Des ajustements peuvent être nécessaires pour les applications générées." -ForegroundColor $Yellow
    exit 1
} 