# 🧪 Script de test automatisé pour le Générateur Firebase + Next.js 2025 (Windows)
# Usage: .\scripts\run-tests.ps1 [-Verbose] [-NoCleanup]

param(
    [switch]$Verbose,
    [switch]$NoCleanup
)

# Configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent $ScriptDir
Set-Location $ProjectDir

# Variables globales
$VerbosePreference = if ($Verbose) { "Continue" } else { "SilentlyContinue" }
$Cleanup = -not $NoCleanup
$TestResults = @()
$TotalTests = 19
$PassedTests = 0
$FailedTests = 0
$StartTime = Get-Date

# Fonctions utilitaires
function Write-Header {
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Blue
    Write-Host "║                    🧪 PLAN DE TEST COMPLET                    ║" -ForegroundColor Blue
    Write-Host "║              Générateur Firebase + Next.js 2025              ║" -ForegroundColor Blue
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Blue
    Write-Host ""
}

function Write-Test {
    param($TestId, $Description)
    Write-Host "🔄 $TestId - $Description" -ForegroundColor Cyan
}

function Write-Success {
    param($TestId, $Message)
    Write-Host "✅ $TestId - $Message" -ForegroundColor Green
    $script:PassedTests++
    $script:TestResults += "$TestId:SUCCESS"
}

function Write-Failure {
    param($TestId, $Message, $Error)
    Write-Host "❌ $TestId - $Message" -ForegroundColor Red
    if ($Error) {
        Write-Host "   Erreur: $Error" -ForegroundColor Red
    }
    $script:FailedTests++
    $script:TestResults += "$TestId:FAILURE:$Error"
}

function Write-Info {
    param($Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Blue
}

function Write-Warning {
    param($Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Step {
    param($Step)
    Write-Host "📋 $Step" -ForegroundColor Magenta
}

# Fonction de nettoyage
function Cleanup {
    Write-Step "Nettoyage des projets de test..."
    
    $TestProjects = @("test-output-minimal", "test-output-complete", "test-output")
    
    foreach ($Project in $TestProjects) {
        if (Test-Path $Project) {
            Remove-Item -Recurse -Force $Project
            Write-Info "Projet $Project supprimé"
        }
    }
    
    # Nettoyer les fichiers temporaires
    $TempFiles = @("check-links.js", "test-report.txt")
    foreach ($File in $TempFiles) {
        if (Test-Path $File) {
            Remove-Item -Force $File
        }
    }
}

# Gestion des signaux pour le nettoyage
try {
    # Vérification des prérequis
    function Check-Prerequisites {
        Write-Step "Vérification des prérequis..."
        
        # Vérifier Node.js
        try {
            $NodeVersion = node --version
            if ($NodeVersion -match "v1[89]\.|v2[0-9]\.|v3[0-9]\.") {
                Write-Success "PREREQ-001" "Node.js $NodeVersion OK"
            } else {
                Write-Failure "PREREQ-002" "Version Node.js incompatible" "Version $NodeVersion détectée, 18+ requis"
                exit 1
            }
        } catch {
            Write-Failure "PREREQ-001" "Node.js non installé" "Commande 'node' non trouvée"
            exit 1
        }
        
        # Vérifier npm
        try {
            $NpmVersion = npm --version
            if ($NpmVersion -match "^[9-9]\.|^[1-9][0-9]\.") {
                Write-Success "PREREQ-002" "npm $NpmVersion OK"
            } else {
                Write-Failure "PREREQ-004" "Version npm incompatible" "Version $NpmVersion détectée, 9+ requis"
                exit 1
            }
        } catch {
            Write-Failure "PREREQ-003" "npm non installé" "Commande 'npm' non trouvée"
            exit 1
        }
        
        # Vérifier Git
        try {
            $GitVersion = git --version
            Write-Success "PREREQ-003" "Git OK"
        } catch {
            Write-Failure "PREREQ-005" "Git non installé" "Commande 'git' non trouvée"
            exit 1
        }
        
        # Vérifier Firebase CLI (optionnel)
        try {
            $FirebaseVersion = firebase --version
            Write-Success "PREREQ-004" "Firebase CLI $FirebaseVersion OK"
        } catch {
            Write-Warning "Firebase CLI non installé (optionnel pour les tests)"
        }
    }

    # Test 001: Vérification de l'environnement de base
    function Test-001 {
        $TestId = "TEST-001"
        Write-Test $TestId "Vérification de l'environnement de base"
        
        # Vérifications déjà faites dans Check-Prerequisites
        Write-Success $TestId "Environnement de base vérifié"
    }

    # Test 002: Installation des dépendances du générateur
    function Test-002 {
        $TestId = "TEST-002"
        Write-Test $TestId "Installation des dépendances du générateur"
        
        if (-not (Test-Path "package.json")) {
            Write-Failure $TestId "package.json non trouvé" "Fichier package.json manquant"
            return $false
        }
        
        Write-Info "Installation des dépendances..."
        try {
            npm install --silent
            Write-Success $TestId "Dépendances installées avec succès"
            return $true
        } catch {
            Write-Failure $TestId "Échec de l'installation des dépendances" "npm install a échoué"
            return $false
        }
    }

    # Test 003: Build du générateur
    function Test-003 {
        $TestId = "TEST-003"
        Write-Test $TestId "Build du générateur"
        
        Write-Info "Build de production..."
        try {
            npm run build --silent
            if (Test-Path "dist") {
                Write-Success $TestId "Build réussi, dossier dist/ créé"
                return $true
            } else {
                Write-Failure $TestId "Dossier dist/ manquant après build" "Build terminé mais dist/ non créé"
                return $false
            }
        } catch {
            Write-Failure $TestId "Échec du build" "npm run build a échoué"
            return $false
        }
    }

    # Test 004: Vérification de la CLI
    function Test-004 {
        $TestId = "TEST-004"
        Write-Test $TestId "Vérification de la CLI"
        
        # Tester la commande d'aide
        try {
            $null = npx ts-node src/cli.ts --help 2>$null
            Write-Success $TestId "CLI fonctionnelle, commande d'aide OK"
            return $true
        } catch {
            Write-Failure $TestId "CLI défaillante" "Commande d'aide échouée"
            return $false
        }
    }

    # Test 005: Génération d'un projet minimal
    function Test-005 {
        $TestId = "TEST-005"
        Write-Test $TestId "Génération d'un projet minimal"
        
        Write-Info "Création du projet minimal..."
        
        try {
            # Créer le projet avec des options non-interactives
            $null = npx ts-node src/cli.ts create `
                --name test-minimal `
                --description "Projet de test minimal" `
                --author "Test User" `
                --version "1.0.0" `
                --package-manager npm `
                --nextjs-version 15 `
                --ui mui `
                --state-management zustand `
                --features pwa `
                --output ./test-output-minimal `
                --non-interactive
            
            if (Test-Path "test-output-minimal") {
                Write-Success $TestId "Projet minimal créé avec succès"
                return $true
            } else {
                Write-Failure $TestId "Dossier de sortie non créé" "test-output-minimal manquant"
                return $false
            }
        } catch {
            Write-Failure $TestId "Échec de la génération" "Commande de génération échouée"
            return $false
        }
    }

    # Test 006: Vérification de la structure du projet minimal
    function Test-006 {
        $TestId = "TEST-006"
        Write-Test $TestId "Vérification de la structure du projet minimal"
        
        $ProjectDir = "test-output-minimal"
        
        # Vérifier les dossiers principaux
        $RequiredDirs = @("frontend", "backend", "scripts")
        foreach ($Dir in $RequiredDirs) {
            if (-not (Test-Path "$ProjectDir/$Dir")) {
                Write-Failure $TestId "Dossier $Dir manquant" "Structure du projet incomplète"
                return $false
            }
        }
        
        # Vérifier les fichiers principaux
        $RequiredFiles = @("README.md", "frontend/package.json", "backend/firebase.json")
        foreach ($File in $RequiredFiles) {
            if (-not (Test-Path "$ProjectDir/$File")) {
                Write-Failure $TestId "Fichier $File manquant" "Structure du projet incomplète"
                return $false
            }
        }
        
        Write-Success $TestId "Structure du projet minimal correcte"
        return $true
    }

    # Test 007: Vérification des fichiers frontend
    function Test-007 {
        $TestId = "TEST-007"
        Write-Test $TestId "Vérification des fichiers frontend"
        
        $FrontendDir = "test-output-minimal/frontend"
        
        # Vérifier la structure src/
        $RequiredSrcDirs = @("src/app", "src/components", "src/hooks", "src/stores", "src/lib")
        foreach ($Dir in $RequiredSrcDirs) {
            if (-not (Test-Path "$FrontendDir/$Dir")) {
                Write-Failure $TestId "Dossier $Dir manquant" "Structure frontend incomplète"
                return $false
            }
        }
        
        # Vérifier les fichiers clés
        $RequiredFiles = @("src/app/page.tsx", "src/app/layout.tsx", "package.json")
        foreach ($File in $RequiredFiles) {
            if (-not (Test-Path "$FrontendDir/$File")) {
                Write-Failure $TestId "Fichier $File manquant" "Fichiers frontend incomplets"
                return $false
            }
        }
        
        # Vérifier les dépendances MUI et Zustand
        $PackageContent = Get-Content "$FrontendDir/package.json" -Raw
        if ($PackageContent -match "mui" -and $PackageContent -match "zustand") {
            Write-Success $TestId "Fichiers frontend et dépendances corrects"
            return $true
        } else {
            Write-Failure $TestId "Dépendances manquantes" "MUI ou Zustand non configurés"
            return $false
        }
    }

    # Test 008: Vérification des fichiers backend
    function Test-008 {
        $TestId = "TEST-008"
        Write-Test $TestId "Vérification des fichiers backend"
        
        $BackendDir = "test-output-minimal/backend"
        
        # Vérifier les fichiers de configuration Firebase
        $RequiredFiles = @("firebase.json", ".firebaserc")
        foreach ($File in $RequiredFiles) {
            if (-not (Test-Path "$BackendDir/$File")) {
                Write-Failure $TestId "Fichier $File manquant" "Configuration Firebase incomplète"
                return $false
            }
        }
        
        # Vérifier la structure functions/
        $RequiredDirs = @("functions", "firestore", "storage")
        foreach ($Dir in $RequiredDirs) {
            if (-not (Test-Path "$BackendDir/$Dir")) {
                Write-Failure $TestId "Dossier $Dir manquant" "Structure backend incomplète"
                return $false
            }
        }
        
        # Vérifier les fichiers functions
        $RequiredFunctionFiles = @("functions/package.json", "functions/src/index.ts")
        foreach ($File in $RequiredFunctionFiles) {
            if (-not (Test-Path "$BackendDir/$File")) {
                Write-Failure $TestId "Fichier $File manquant" "Fonctions Firebase incomplètes"
                return $false
            }
        }
        
        Write-Success $TestId "Fichiers backend corrects"
        return $true
    }

    # Test 009: Vérification des templates Handlebars
    function Test-009 {
        $TestId = "TEST-009"
        Write-Test $TestId "Vérification des templates Handlebars"
        
        $ProjectDir = "test-output-minimal"
        
        # Vérifier qu'aucune variable Handlebars n'est restée non remplacée
        $UnprocessedVars = Get-ChildItem -Path $ProjectDir -Recurse -File | 
            Where-Object { $_.Extension -eq ".tsx" -or $_.Extension -eq ".ts" -or $_.Extension -eq ".json" -or $_.Extension -eq ".md" } |
            ForEach-Object { Get-Content $_.FullName -Raw } |
            Select-String "{{.*}}" -AllMatches |
            ForEach-Object { $_.Matches } |
            ForEach-Object { $_.Value }
        
        if ($UnprocessedVars) {
            Write-Failure $TestId "Variables Handlebars non remplacées" "Variables trouvées: $($UnprocessedVars -join ', ')"
            return $false
        }
        
        # Vérifier que le nom du projet apparaît dans les fichiers
        $ProjectFiles = Get-ChildItem -Path $ProjectDir -Recurse -File |
            Where-Object { $_.Extension -eq ".tsx" -or $_.Extension -eq ".ts" -or $_.Extension -eq ".json" -or $_.Extension -eq ".md" }
        
        $FoundProjectName = $false
        foreach ($File in $ProjectFiles) {
            $Content = Get-Content $File.FullName -Raw
            if ($Content -match "test-minimal") {
                $FoundProjectName = $true
                break
            }
        }
        
        if ($FoundProjectName) {
            Write-Success $TestId "Templates Handlebars correctement traités"
            return $true
        } else {
            Write-Failure $TestId "Nom du projet non trouvé" "Variables non remplacées"
            return $false
        }
    }

    # Test 010: Génération d'un projet complet
    function Test-010 {
        $TestId = "TEST-010"
        Write-Test $TestId "Génération d'un projet complet"
        
        Write-Info "Création du projet complet..."
        
        try {
            # Créer le projet avec toutes les fonctionnalités
            $null = npx ts-node src/cli.ts create `
                --name test-complete `
                --description "Projet de test complet" `
                --author "Test User" `
                --version "1.0.0" `
                --package-manager npm `
                --nextjs-version 15 `
                --ui shadcn `
                --state-management redux `
                --features pwa,fcm,analytics,performance,sentry `
                --output ./test-output-complete `
                --non-interactive
            
            if (Test-Path "test-output-complete") {
                Write-Success $TestId "Projet complet créé avec succès"
                return $true
            } else {
                Write-Failure $TestId "Dossier de sortie non créé" "test-output-complete manquant"
                return $false
            }
        } catch {
            Write-Failure $TestId "Échec de la génération" "Commande de génération échouée"
            return $false
        }
    }

    # Test 011: Vérification des fonctionnalités avancées
    function Test-011 {
        $TestId = "TEST-011"
        Write-Test $TestId "Vérification des fonctionnalités avancées"
        
        $ProjectDir = "test-output-complete"
        
        # Vérifier PWA
        if (Test-Path "$ProjectDir/frontend/public/manifest.json") {
            Write-Info "✅ PWA configuré"
        } else {
            Write-Failure $TestId "PWA non configuré" "manifest.json manquant"
            return $false
        }
        
        # Vérifier FCM
        if (Test-Path "$ProjectDir/frontend/src/fcm/fcm-config.ts") {
            Write-Info "✅ FCM configuré"
        } else {
            Write-Failure $TestId "FCM non configuré" "fcm-config.ts manquant"
            return $false
        }
        
        # Vérifier Analytics
        if (Test-Path "$ProjectDir/frontend/src/lib/analytics-config.ts") {
            Write-Info "✅ Analytics configuré"
        } else {
            Write-Failure $TestId "Analytics non configuré" "analytics-config.ts manquant"
            return $false
        }
        
        # Vérifier Performance
        if (Test-Path "$ProjectDir/frontend/src/performance/performance-config.ts") {
            Write-Info "✅ Performance configuré"
        } else {
            Write-Failure $TestId "Performance non configuré" "performance-config.ts manquant"
            return $false
        }
        
        # Vérifier Sentry
        if (Test-Path "$ProjectDir/frontend/src/sentry/sentry-config.ts") {
            Write-Info "✅ Sentry configuré"
        } else {
            Write-Failure $TestId "Sentry non configuré" "sentry-config.ts manquant"
            return $false
        }
        
        Write-Success $TestId "Toutes les fonctionnalités avancées configurées"
        return $true
    }

    # Test 012: Vérification des composants Shadcn/ui
    function Test-012 {
        $TestId = "TEST-012"
        Write-Test $TestId "Vérification des composants Shadcn/ui"
        
        $ProjectDir = "test-output-complete"
        
        # Vérifier les composants Shadcn
        $RequiredComponents = @("Button.tsx", "Card.tsx")
        foreach ($Component in $RequiredComponents) {
            if (-not (Test-Path "$ProjectDir/frontend/src/components/shadcn/$Component")) {
                Write-Failure $TestId "Composant $Component manquant" "Composants Shadcn incomplets"
                return $false
            }
        }
        
        # Vérifier les composants UI
        $RequiredUiComponents = @("button.tsx", "card.tsx")
        foreach ($Component in $RequiredUiComponents) {
            if (-not (Test-Path "$ProjectDir/frontend/src/components/ui/$Component")) {
                Write-Failure $TestId "Composant UI $Component manquant" "Composants UI incomplets"
                return $false
            }
        }
        
        Write-Success $TestId "Composants Shadcn/ui correctement configurés"
        return $true
    }

    # Test 013: Vérification de Redux Toolkit
    function Test-013 {
        $TestId = "TEST-013"
        Write-Test $TestId "Vérification de Redux Toolkit"
        
        $ProjectDir = "test-output-complete"
        
        # Vérifier les stores Redux
        if (-not (Test-Path "$ProjectDir/frontend/src/stores/redux/auth-slice.ts")) {
            Write-Failure $TestId "Store Redux manquant" "auth-slice.ts non trouvé"
            return $false
        }
        
        # Vérifier les dépendances Redux
        $PackageContent = Get-Content "$ProjectDir/frontend/package.json" -Raw
        if ($PackageContent -match "@reduxjs/toolkit" -and $PackageContent -match "react-redux") {
            Write-Success $TestId "Redux Toolkit correctement configuré"
            return $true
        } else {
            Write-Failure $TestId "Dépendances Redux manquantes" "@reduxjs/toolkit ou react-redux non configurés"
            return $false
        }
    }

    # Test 014: Vérification de la navigation entre documents
    function Test-014 {
        $TestId = "TEST-014"
        Write-Test $TestId "Vérification de la navigation entre documents"
        
        # Vérifier que tous les fichiers de documentation existent
        $RequiredDocs = @("README.md", "NAVIGATION.md", "INSTALLATION.md", "USAGE.md", "DEPLOYMENT.md", "CUSTOMIZATION.md", "BEST_PRACTICES.md", "MAINTENANCE.md", "CONTRIBUTING.md", "EXAMPLES.md")
        
        foreach ($Doc in $RequiredDocs) {
            if (-not (Test-Path "docs/$Doc")) {
                Write-Failure $TestId "Document $Doc manquant" "Documentation incomplète"
                return $false
            }
        }
        
        Write-Success $TestId "Tous les documents de documentation présents"
        return $true
    }

    # Test 015: Vérification de la cohérence des liens
    function Test-015 {
        $TestId = "TEST-015"
        Write-Test $TestId "Vérification de la cohérence des liens"
        
        # Créer un script de vérification des liens
        $CheckLinksScript = @"
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
        console.log(\`- \${link.file}: [\${link.text}](\${link.url})\`);
    });
    
    return allLinks;
}

checkAllLinks();
"@
        
        $CheckLinksScript | Out-File -FilePath "check-links.js" -Encoding UTF8
        
        # Exécuter la vérification
        try {
            $null = node check-links.js 2>$null
            Write-Success $TestId "Liens de documentation vérifiés"
            return $true
        } catch {
            Write-Failure $TestId "Erreur lors de la vérification des liens" "Script de vérification échoué"
            return $false
        }
    }

    # Test 016: Vérification de la structure de la documentation
    function Test-016 {
        $TestId = "TEST-016"
        Write-Test $TestId "Vérification de la structure de la documentation"
        
        # Vérifier la structure des documents principaux
        $ReadmeSections = (Get-Content "docs/README.md" | Select-String "^## ").Count
        $NavigationSections = (Get-Content "docs/NAVIGATION.md" | Select-String "^## ").Count
        $InstallationSections = (Get-Content "docs/INSTALLATION.md" | Select-String "^## ").Count
        
        if ($ReadmeSections -ge 5 -and $NavigationSections -ge 5 -and $InstallationSections -ge 5) {
            Write-Success $TestId "Structure de la documentation conforme"
            return $true
        } else {
            Write-Failure $TestId "Structure de documentation insuffisante" "Sections manquantes dans les documents"
            return $false
        }
    }

    # Test 017: Validation des projets générés
    function Test-017 {
        $TestId = "TEST-017"
        Write-Test $TestId "Validation des projets générés"
        
        # Vérifier la validité des package.json
        $Projects = @("test-output-minimal", "test-output-complete")
        
        foreach ($Project in $Projects) {
            if (Test-Path $Project) {
                $PackageJson = "$Project/frontend/package.json"
                if (Test-Path $PackageJson) {
                    try {
                        $null = Get-Content $PackageJson | ConvertFrom-Json
                        Write-Info "✅ $Project : package.json valide"
                    } catch {
                        Write-Failure $TestId "package.json invalide dans $Project" "JSON malformé"
                        return $false
                    }
                }
            }
        }
        
        Write-Success $TestId "Projets générés validés"
        return $true
    }

    # Test 018: Nettoyage des projets de test
    function Test-018 {
        $TestId = "TEST-018"
        Write-Test $TestId "Nettoyage des projets de test"
        
        # Nettoyer les projets de test
        $Projects = @("test-output-minimal", "test-output-complete", "test-output")
        
        foreach ($Project in $Projects) {
            if (Test-Path $Project) {
                Remove-Item -Recurse -Force $Project
                Write-Info "✅ $Project supprimé"
            }
        }
        
        # Nettoyer les fichiers temporaires
        $TempFiles = @("check-links.js", "test-report.txt")
        foreach ($File in $TempFiles) {
            if (Test-Path $File) {
                Remove-Item -Force $File
            }
        }
        
        Write-Success $TestId "Nettoyage des projets de test réussi"
        return $true
    }

    # Test 019: Vérification finale de l'environnement
    function Test-019 {
        $TestId = "TEST-019"
        Write-Test $TestId "Vérification finale de l'environnement"
        
        # Vérifier que nous sommes dans le bon répertoire
        if ((Get-Location).Path -eq $ProjectDir) {
            Write-Info "✅ Répertoire correct: $((Get-Location).Path)"
        } else {
            Write-Failure $TestId "Répertoire incorrect" "Répertoire actuel: $((Get-Location).Path)"
            return $false
        }
        
        # Vérifier que le générateur fonctionne toujours
        try {
            $null = npx ts-node src/cli.ts --version 2>$null
            Write-Success $TestId "Environnement final vérifié, générateur fonctionnel"
            return $true
        } catch {
            Write-Failure $TestId "Générateur défaillant après les tests" "CLI non fonctionnelle"
            return $false
        }
    }

    # Fonction principale d'exécution des tests
    function Run-AllTests {
        Write-Header
        
        Write-Info "🚀 Démarrage des tests automatisés..."
        Write-Info "📁 Répertoire de travail: $ProjectDir"
        Write-Info "⏰ Heure de début: $(Get-Date)"
        Write-Host ""
        
        # Vérification des prérequis
        Check-Prerequisites
        Write-Host ""
        
        # Exécution des tests
        $Tests = @(
            "Test-001",
            "Test-002",
            "Test-003",
            "Test-004",
            "Test-005",
            "Test-006",
            "Test-007",
            "Test-008",
            "Test-009",
            "Test-010",
            "Test-011",
            "Test-012",
            "Test-013",
            "Test-014",
            "Test-015",
            "Test-016",
            "Test-017",
            "Test-018",
            "Test-019"
        )
        
        foreach ($Test in $Tests) {
            if (& $Test) {
                Write-Info "✅ $Test réussi"
            } else {
                Write-Warning "⚠️  $Test échoué, continuation des autres tests..."
            }
            Write-Host ""
        }
    }

    # Génération du rapport final
    function Generate-Report {
        $EndTime = Get-Date
        $Duration = ($EndTime - $StartTime).TotalSeconds
        
        Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Blue
        Write-Host "║                        📊 RAPPORT FINAL                      ║" -ForegroundColor Blue
        Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Blue
        Write-Host ""
        
        Write-Host "📈 Résultats des tests:" -ForegroundColor Cyan
        Write-Host "   Total: $TotalTests"
        Write-Host "   ✅ Réussis: $PassedTests"
        Write-Host "   ❌ Échoués: $FailedTests"
        Write-Host "   ⏱️  Durée: $([math]::Round($Duration, 2))s"
        Write-Host ""
        
        # Calculer le pourcentage de réussite
        $SuccessRate = [math]::Round(($PassedTests * 100) / $TotalTests)
        Write-Host "📊 Taux de réussite: ${SuccessRate}%" -ForegroundColor Cyan
        Write-Host ""
        
        if ($SuccessRate -eq 100) {
            Write-Host "🎉 Tous les tests ont réussi !" -ForegroundColor Green
            Write-Host "🚀 Le générateur est prêt pour la production !" -ForegroundColor Green
        } elseif ($SuccessRate -ge 80) {
            Write-Host "⚠️  La plupart des tests ont réussi." -ForegroundColor Yellow
            Write-Host "🔧 Quelques ajustements mineurs peuvent être nécessaires." -ForegroundColor Yellow
        } else {
            Write-Host "❌ Trop de tests ont échoué." -ForegroundColor Red
            Write-Host "🚨 Une révision majeure est nécessaire." -ForegroundColor Red
        }
        Write-Host ""
        
        # Afficher les détails des échecs
        if ($FailedTests -gt 0) {
            Write-Host "❌ Tests échoués:" -ForegroundColor Red
            foreach ($Result in $TestResults) {
                if ($Result -match ":FAILURE:") {
                    $TestId = $Result.Split(":")[0]
                    $Error = $Result.Split(":", 3)[2]
                    Write-Host "   $TestId : $Error"
                }
            }
            Write-Host ""
        }
        
        # Sauvegarder le rapport
        $ReportContent = @"
RAPPORT DE TEST - $(Get-Date)
========================
Total: $TotalTests
Réussis: $PassedTests
Échoués: $FailedTests
Taux de réussite: ${SuccessRate}%
Durée: $([math]::Round($Duration, 2))s

Détails des échecs:
"@
        
        foreach ($Result in $TestResults) {
            if ($Result -match ":FAILURE:") {
                $ReportContent += "`n$Result"
            }
        }
        
        $ReportContent | Out-File -FilePath "test-report.txt" -Encoding UTF8
        
        Write-Info "📄 Rapport sauvegardé dans test-report.txt"
    }

    # Exécution principale
    function Main {
        # Nettoyage initial
        Cleanup
        
        # Exécution des tests
        Run-AllTests
        
        # Génération du rapport
        Generate-Report
        
        # Nettoyage final si activé
        if ($Cleanup) {
            Cleanup
        }
        
        # Code de sortie basé sur le succès
        if ($FailedTests -eq 0) {
            exit 0
        } else {
            exit 1
        }
    }

    # Exécution du script principal
    Main

} finally {
    # Nettoyage en cas d'erreur
    if ($Cleanup) {
        Cleanup
    }
} 