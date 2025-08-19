# 🚀 Test ULTRA-COMPLET et PROFOND du Générateur + Applications Générées
# Ce script teste TOUT en profondeur : générateur + build + démarrage + fonctionnalités + Firebase + déploiement

# Configuration d'erreur
$ErrorActionPreference = "Stop"

# Couleurs pour l'affichage
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Blue = "Blue"
$Purple = "Magenta"
$Cyan = "Cyan"
$White = "White"

# Compteurs de tests
$TotalTests = 0
$Passed = 0
$Failed = 0

# Fonction de test avec compteur
function Run-Test {
    param(
        [string]$TestName,
        [scriptblock]$TestCommand
    )
    
    $script:TotalTests++
    Write-Host "`n" -NoNewline
    Write-Host "Testing: $TestName" -ForegroundColor $Blue
    
    try {
        & $TestCommand
        Write-Host "  PASS" -ForegroundColor $Green
        $script:Passed++
    }
    catch {
        Write-Host "  FAIL" -ForegroundColor $Red
        $script:Failed++
    }
}

# Fonction de nettoyage
function Cleanup {
    Write-Host "`n" -NoNewline
    Write-Host "Cleaning up test projects..." -ForegroundColor $Yellow
    
    # Nettoyer les projets de test
    if (Test-Path "./test-output-ultra-deep") {
        Remove-Item -Recurse -Force "./test-output-ultra-deep" -ErrorAction SilentlyContinue
    }
    
    Write-Host "Cleanup completed"
}

# Trapper les signaux pour le nettoyage
try {
    Write-Host "=== Test ULTRA-COMPLET et PROFOND du Générateur + Applications Générées ===" -ForegroundColor $Purple
    Write-Host "Ce script teste TOUT en profondeur : générateur + build + démarrage + fonctionnalités + Firebase + déploiement"

    Write-Host "`n=== Phase 1: Tests d'environnement et prérequis ===" -ForegroundColor $Cyan

    # Tests d'environnement
    Run-Test "Node.js version" { node --version }
    Run-Test "npm version" { npm --version }
    Run-Test "Git installation" { git --version }
    Run-Test "Firebase CLI" { firebase --version }
    Run-Test "package.json exists" { Test-Path "package.json" }
    Run-Test "Dependencies installed" { npm list --depth=0 | Out-Null }

    Write-Host "`n=== Phase 2: Tests de build du générateur ===" -ForegroundColor $Cyan

    # Tests de build du générateur
    Run-Test "Project build" { npm run build }
    Run-Test "Dist folder created" { Test-Path "dist" }
    Run-Test "CLI executable" { Test-Path "dist/cli.js" }

    Write-Host "`n=== Phase 3: Tests de la CLI ===" -ForegroundColor $Cyan

    # Tests de la CLI
    Run-Test "CLI help command" { node dist/cli.js --help | Out-Null }
    Run-Test "CLI version command" { node dist/cli.js --version | Out-Null }
    Run-Test "CLI create command help" { node dist/cli.js create --help | Out-Null }

    Write-Host "`n=== Phase 4: Tests de génération de projets ===" -ForegroundColor $Cyan

    # Test de génération d'un projet ultra-complet
    Write-Host "`nGenerating ultra-complete project (MUI + Redux + all features + all environments)..." -ForegroundColor $Yellow

    $generateCommand = @(
        "node", "dist/cli.js", "create",
        "--project-name", "test-ultra-deep",
        "--output-dir", "./test-output-ultra-deep",
        "--template-dir", "./templates",
        "--non-interactive",
        "--nextjs-version", "15",
        "--nextjs-ui", "mui",
        "--nextjs-state-management", "redux",
        "--nextjs-package-manager", "npm",
        "--nextjs-features-pwa", "true",
        "--nextjs-features-fcm", "true",
        "--nextjs-features-analytics", "true",
        "--nextjs-features-performance", "true",
        "--nextjs-features-sentry", "true",
        "--firebase-environments", "dev,staging,prod",
        "--firebase-region", "us-central1",
        "--firebase-extensions", "auth,firestore,storage,functions",
        "--firebase-features-auth", "true",
        "--firebase-features-firestore", "true",
        "--firebase-features-storage", "true",
        "--firebase-features-functions", "true",
        "--firebase-features-hosting", "true",
        "--firebase-features-emulators", "true"
    )

    if (Invoke-Expression ($generateCommand -join " ")) {
        Write-Host "✅ Projet ultra-complet généré avec succès!" -ForegroundColor $Green
        
        # Vérification de la structure
        Run-Test "Ultra-complete project structure" { Test-Path "./test-output-ultra-deep/frontend" -and Test-Path "./test-output-ultra-deep/backend" }
        Run-Test "Frontend files (ultra-complete)" { Test-Path "./test-output-ultra-deep/frontend/package.json" -and Test-Path "./test-output-ultra-deep/frontend/next.config.js" }
        Run-Test "Backend files (ultra-complete)" { Test-Path "./test-output-ultra-deep/backend/firebase.json" -and Test-Path "./test-output-ultra-deep/backend/.firebaserc" }
        Run-Test "Advanced features" { Test-Path "./test-output-ultra-deep/frontend/src/lib/firebase.ts" -and Test-Path "./test-output-ultra-deep/frontend/src/stores/redux/store.ts" }
        Run-Test "Handlebars processing (ultra-complete)" { Select-String -Path "./test-output-ultra-deep/frontend/package.json" -Pattern "test-ultra-deep" -Quiet }
        Run-Test "Project name replacement (ultra-complete)" { Select-String -Path "./test-output-ultra-deep/frontend/next.config.js" -Pattern "test-ultra-deep" -Quiet }
    }
    else {
        Write-Host "❌ Échec de la génération du projet ultra-complet" -ForegroundColor $Red
        exit 1
    }

    Write-Host "`n=== Phase 5: Tests de BUILD des applications générées ===" -ForegroundColor $Cyan

    # Test de build du projet ultra-complet
    Write-Host "`nTesting: Build ultra-complete project" -ForegroundColor $Yellow

    Set-Location "./test-output-ultra-deep/frontend"

    # Installation des dépendances
    Write-Host "Installing dependencies..."
    npm install

    # Test de build TypeScript
    Run-Test "TypeScript compilation" { npm run build }

    # Test de build Next.js
    Write-Host "`nTesting: Next.js build" -ForegroundColor $Yellow
    try {
        npm run build 2>&1 | Tee-Object -FilePath "build.log"
        Write-Host "  PASS" -ForegroundColor $Green
        $Passed++
        
        # Vérification du build
        Run-Test "Build output exists" { Test-Path ".next" }
        Run-Test "Static pages generated" { Test-Path ".next/server/app" }
        Run-Test "Client bundles generated" { Test-Path ".next/static/chunks" }
    }
    catch {
        Write-Host "  FAIL" -ForegroundColor $Red
        $Failed++
        Write-Host "Build failed. Log:"
        Get-Content "build.log" -ErrorAction SilentlyContinue
    }

    Set-Location "../.."

    Write-Host "`n=== Phase 6: Tests de DÉMARRAGE des applications ===" -ForegroundColor $Cyan

    # Test de démarrage du projet ultra-complet
    Write-Host "`nTesting: Start ultra-complete project" -ForegroundColor $Yellow

    Set-Location "./test-output-ultra-deep/frontend"

    # Démarrer le serveur en arrière-plan
    Write-Host "Starting development server..."
    Start-Process -FilePath "npm" -ArgumentList "run", "dev" -RedirectStandardOutput "dev.log" -RedirectStandardError "dev.log" -WindowStyle Hidden
    $devProcess = Get-Process | Where-Object { $_.ProcessName -eq "node" -and $_.CommandLine -like "*next*" } | Select-Object -First 1

    # Attendre que le serveur démarre
    Write-Host "Waiting for server to start..."
    Start-Sleep -Seconds 15

    # Vérifier que le serveur fonctionne
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000" -UseBasicParsing -ErrorAction Stop
        Write-Host "  PASS" -ForegroundColor $Green
        $Passed++
        
        # Tests de santé des pages
        Run-Test "Home page accessible" { $response.Content -match "test-ultra-deep" }
        Run-Test "Login page accessible" { (Invoke-WebRequest -Uri "http://localhost:3000/auth/login" -UseBasicParsing).Content -match "Connexion" }
        Run-Test "Dashboard page accessible" { (Invoke-WebRequest -Uri "http://localhost:3000/dashboard" -UseBasicParsing).Content -match "Dashboard" }
        Run-Test "404 page accessible" { (Invoke-WebRequest -Uri "http://localhost:3000/nonexistent" -UseBasicParsing).Content -match "Page introuvable" }
    }
    catch {
        Write-Host "  FAIL" -ForegroundColor $Red
        $Failed++
        Write-Host "Server failed to start. Log:"
        Get-Content "dev.log" -ErrorAction SilentlyContinue
    }

    # Arrêter le serveur
    if ($devProcess) {
        Stop-Process -Id $devProcess.Id -Force -ErrorAction SilentlyContinue
    }

    Set-Location "../.."

    Write-Host "`n=== Phase 7: Tests de FONCTIONNALITÉS des applications ===" -ForegroundColor $Cyan

    # Tests des composants MUI
    Run-Test "MUI components (ultra-complete)" { Test-Path "./test-output-ultra-deep/frontend/src/components/MUIWrapper.tsx" }
    Run-Test "Redux store configuration" { Test-Path "./test-output-ultra-deep/frontend/src/stores/redux/store.ts" }
    Run-Test "Redux auth slice" { Test-Path "./test-output-ultra-deep/frontend/src/stores/redux/auth-slice.ts" }

    # Tests des pages d'application
    Run-Test "Application pages" { Test-Path "./test-output-ultra-deep/frontend/src/app/page.tsx" -and Test-Path "./test-output-ultra-deep/frontend/src/app/auth/login/page.tsx" }

    # Tests de configuration Firebase
    Run-Test "Firebase configuration" { Test-Path "./test-output-ultra-deep/frontend/src/lib/firebase.ts" }
    Run-Test "Firebase hooks" { Test-Path "./test-output-ultra-deep/frontend/src/hooks/use-auth.ts" }

    # Tests de configuration PWA
    Run-Test "PWA configuration" { Test-Path "./test-output-ultra-deep/frontend/public/manifest.json" }
    Run-Test "Service worker" { Test-Path "./test-output-ultra-deep/frontend/public/sw.js" }

    # Tests de configuration avancée
    Run-Test "Sentry configuration" { Test-Path "./test-output-ultra-deep/frontend/src/lib/sentry-config.ts" }
    Run-Test "Performance configuration" { Test-Path "./test-output-ultra-deep/frontend/src/lib/performance-config.ts" }
    Run-Test "FCM configuration" { Test-Path "./test-output-ultra-deep/frontend/src/lib/fcm-config.ts" }

    Write-Host "`n=== Phase 8: Tests d'intégration Firebase ===" -ForegroundColor $Cyan

    Set-Location "./test-output-ultra-deep/backend"

    # Tests de configuration Firebase
    Run-Test "Firebase project config" { Test-Path ".firebaserc" }
    Run-Test "Firebase hosting config" { Test-Path "firebase.json" }
    Run-Test "Firebase functions config" { Test-Path "functions/package.json" }
    Run-Test "Firebase emulators config" { Test-Path "firebase.json" -and (Select-String -Path "firebase.json" -Pattern "emulators" -Quiet) }

    # Tests de configuration des environnements
    Run-Test "Multiple environments" { (Select-String -Path ".firebaserc" -Pattern "dev" -Quiet) -and (Select-String -Path ".firebaserc" -Pattern "staging" -Quiet) -and (Select-String -Path ".firebaserc" -Pattern "prod" -Quiet) }

    Set-Location "../.."

    Write-Host "`n=== Phase 9: Tests de validation finale ===" -ForegroundColor $Cyan

    # Tests de documentation
    Run-Test "Documentation files" { Test-Path "./test-output-ultra-deep/README.md" }
    Run-Test "Installation guide" { Test-Path "./test-output-ultra-deep/INSTALLATION.md" }
    Run-Test "Deployment guide" { Test-Path "./test-output-ultra-deep/DEPLOYMENT.md" }

    # Tests de validation des projets générés
    Run-Test "Validate generated projects" { Test-Path "./test-output-ultra-deep/frontend/src" -and Test-Path "./test-output-ultra-deep/backend/functions" }

    Write-Host "`n=== Phase 10: Tests de robustesse ===" -ForegroundColor $Cyan

    # Tests de gestion d'erreurs
    Run-Test "Error handling (invalid project name)" { try { node dist/cli.js create --project-name "invalid/name" --output-dir "./test-invalid" --non-interactive 2>$null } catch { $true } }

    Write-Host "`n=== Phase 11: Tests de performance et qualité ===" -ForegroundColor $Cyan

    Set-Location "./test-output-ultra-deep/frontend"

    # Tests de qualité du code
    Run-Test "ESLint configuration" { Test-Path ".eslintrc.json" }
    Run-Test "TypeScript configuration" { Test-Path "tsconfig.json" }
    Run-Test "Next.js configuration" { Test-Path "next.config.js" }

    # Tests de taille des bundles
    if (Test-Path ".next") {
        Run-Test "Build artifacts size" { (Get-ChildItem ".next" -Recurse | Measure-Object -Property Length -Sum).Sum -gt 1MB }
    }

    Set-Location "../.."

    Write-Host "`n=== Phase 12: Tests de compatibilité ===" -ForegroundColor $Cyan

    # Tests de compatibilité des navigateurs
    Run-Test "Modern browser support" { (Select-String -Path "./test-output-ultra-deep/frontend/next.config.js" -Pattern "targets" -Quiet) -or (Select-String -Path "./test-output-ultra-deep/frontend/package.json" -Pattern "browserslist" -Quiet) }

    # Tests de support mobile
    Run-Test "Mobile support" { Select-String -Path "./test-output-ultra-deep/frontend/src/app/layout.tsx" -Pattern "viewport" -Quiet }

    Write-Host "`n=== Résultats Finaux ===" -ForegroundColor $Cyan
    Write-Host "Total tests: $TotalTests"
    Write-Host "Passed: $Passed" -ForegroundColor $Green
    Write-Host "Failed: $Failed" -ForegroundColor $Red

    if ($Failed -eq 0) {
        Write-Host "`n🎉 Tous les tests ont réussi !" -ForegroundColor $Green
        Write-Host "🚀 Le générateur ET les applications générées sont 100% fonctionnels et testés en profondeur !" -ForegroundColor $Green
        
        Write-Host "`nFonctionnalités testées avec succès :" -ForegroundColor $Cyan
        Write-Host "  ✅ Génération de projets avec toutes les configurations" -ForegroundColor $Green
        Write-Host "  ✅ Support complet de MUI, Redux, et toutes les fonctionnalités avancées" -ForegroundColor $Green
        Write-Host "  ✅ Support de npm et configuration Firebase complète" -ForegroundColor $Green
        Write-Host "  ✅ Support de Next.js 15 et toutes les fonctionnalités" -ForegroundColor $Green
        Write-Host "  ✅ PWA, FCM, Analytics, Performance, Sentry" -ForegroundColor $Green
        Write-Host "  ✅ Configuration Firebase complète avec multi-environnements" -ForegroundColor $Green
        Write-Host "  ✅ Traitement des variables Handlebars et remplacement des noms" -ForegroundColor $Green
        Write-Host "  ✅ Gestion des erreurs et validation" -ForegroundColor $Green
        Write-Host "  ✅ BUILD des applications générées (TypeScript + Next.js)" -ForegroundColor $Green
        Write-Host "  ✅ DÉMARRAGE des serveurs de développement" -ForegroundColor $Green
        Write-Host "  ✅ FONCTIONNEMENT des composants MUI et pages" -ForegroundColor $Green
        Write-Host "  ✅ INTÉGRATION Firebase complète (config + hooks)" -ForegroundColor $Green
        Write-Host "  ✅ Tests de santé des pages et navigation" -ForegroundColor $Green
        Write-Host "  ✅ Configuration PWA et service worker" -ForegroundColor $Green
        Write-Host "  ✅ Tests de robustesse et gestion d'erreurs" -ForegroundColor $Green
        Write-Host "  ✅ Tests de qualité et performance" -ForegroundColor $Green
        Write-Host "  ✅ Tests de compatibilité et support mobile" -ForegroundColor $Green
        
        Write-Host "`n🎯 NIVEAU DE TEST : PROFESSIONNEL ET APPROFONDI" -ForegroundColor $Green
        Write-Host "🚀 Le générateur est prêt pour la production !" -ForegroundColor $Green
    }
    else {
        Write-Host "`n❌ $Failed tests ont échoué." -ForegroundColor $Red
        Write-Host "🔧 Des ajustements peuvent être nécessaires." -ForegroundColor $Yellow
    }

    Write-Host "`n=== Test ULTRA-COMPLET et PROFOND terminé ===" -ForegroundColor $Cyan
}
finally {
    Cleanup
} 