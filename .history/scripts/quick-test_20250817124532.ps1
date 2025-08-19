# 🧪 Test rapide du générateur (Windows)
# Usage: .\scripts\quick-test.ps1

param(
    [switch]$Verbose
)

# Configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent $ScriptDir
Set-Location $ProjectDir

# Variables
$VerbosePreference = if ($Verbose) { "Continue" } else { "SilentlyContinue" }

# Couleurs
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    
    $Colors = @{
        "Green" = "Green"
        "Red" = "Red"
        "Yellow" = "Yellow"
        "Blue" = "Blue"
        "Cyan" = "Cyan"
        "Magenta" = "Magenta"
    }
    
    if ($Colors.ContainsKey($Color)) {
        Write-Host $Message -ForegroundColor $Colors[$Color]
    } else {
        Write-Host $Message
    }
}

Write-ColorOutput "🧪 Test rapide du générateur Firebase + Next.js 2025" "Blue"
Write-ColorOutput "==================================================" "Blue"
Write-Host ""

# Test 1: Vérification de l'environnement
Write-ColorOutput "1. Vérification de l'environnement..." "Blue"

try {
    $NodeVersion = node --version
    Write-ColorOutput "   ✅ Node.js: $NodeVersion" "Green"
} catch {
    Write-ColorOutput "   ❌ Node.js non installé" "Red"
    exit 1
}

try {
    $NpmVersion = npm --version
    Write-ColorOutput "   ✅ npm: $NpmVersion" "Green"
} catch {
    Write-ColorOutput "   ❌ npm non installé" "Red"
    exit 1
}

try {
    $GitVersion = git --version
    Write-ColorOutput "   ✅ Git: OK" "Green"
} catch {
    Write-ColorOutput "   ❌ Git non installé" "Red"
    exit 1
}

Write-Host ""

# Test 2: Vérification des dépendances
Write-ColorOutput "2. Vérification des dépendances..." "Blue"

if (Test-Path "package.json") {
    Write-ColorOutput "   ✅ package.json trouvé" "Green"
} else {
    Write-ColorOutput "   ❌ package.json manquant" "Red"
    exit 1
}

if (Test-Path "node_modules") {
    Write-ColorOutput "   ✅ node_modules trouvé" "Green"
} else {
    Write-ColorOutput "   ⚠️  node_modules manquant, installation..." "Yellow"
    try {
        npm install --silent
        Write-ColorOutput "   ✅ Installation terminée" "Green"
    } catch {
        Write-ColorOutput "   ❌ Installation échouée" "Red"
        exit 1
    }
}

Write-Host ""

# Test 3: Build du projet
Write-ColorOutput "3. Build du projet..." "Blue"

try {
    npm run build --silent
    Write-ColorOutput "   ✅ Build réussi" "Green"
} catch {
    Write-ColorOutput "   ❌ Build échoué" "Red"
    exit 1
}

Write-Host ""

# Test 4: Vérification de la CLI
Write-ColorOutput "4. Vérification de la CLI..." "Blue"

try {
    $null = npx ts-node src/cli.ts --help 2>$null
    Write-ColorOutput "   ✅ CLI fonctionnelle" "Green"
} catch {
    Write-ColorOutput "   ❌ CLI défaillante" "Red"
    exit 1
}

Write-Host ""

# Test 5: Test de génération rapide
Write-ColorOutput "5. Test de génération rapide..." "Blue"

if (Test-Path "test-quick") {
    Remove-Item -Recurse -Force "test-quick"
}

try {
    # Créer le projet avec des options non-interactives
    $null = npx ts-node src/cli.ts create `
        --name test-quick `
        --description "Test rapide" `
        --author "Test" `
        --version "1.0.0" `
        --package-manager npm `
        --nextjs-version 15 `
        --ui mui `
        --state-management zustand `
        --features pwa `
        --output ./test-quick `
        --non-interactive
    
    Write-ColorOutput "   ✅ Génération réussie" "Green"
    
    # Vérification rapide de la structure
    if ((Test-Path "test-quick/frontend") -and (Test-Path "test-quick/backend")) {
        Write-ColorOutput "   ✅ Structure correcte" "Green"
    } else {
        Write-ColorOutput "   ❌ Structure incorrecte" "Red"
    }
    
    # Nettoyage
    Remove-Item -Recurse -Force "test-quick"
    Write-ColorOutput "   ✅ Nettoyage effectué" "Green"
    
} catch {
    Write-ColorOutput "   ❌ Génération échouée" "Red"
    exit 1
}

Write-Host ""
Write-ColorOutput "🎉 Tous les tests rapides ont réussi !" "Green"
Write-ColorOutput "Le générateur est prêt pour les tests complets." "Blue"
Write-Host ""

Write-ColorOutput "Pour exécuter tous les tests :" "Yellow"
Write-ColorOutput "   .\scripts\run-tests.ps1" "Cyan"
Write-Host ""

Write-ColorOutput "Pour exécuter les tests sur Linux/macOS :" "Yellow"
Write-ColorOutput "   ./scripts/run-tests.sh" "Cyan" 