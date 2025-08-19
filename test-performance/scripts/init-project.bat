@echo off
REM Script d'initialisation automatique pour Windows
REM Usage: scripts\init-project.bat [environment]
REM Exemple: scripts\init-project.bat dev

setlocal enabledelayedexpansion

set ENVIRONMENT=%1
if "%ENVIRONMENT%"=="" set ENVIRONMENT=dev

echo 🚀 Initialisation automatique de test-performance en %ENVIRONMENT%...

REM Vérifier l'environnement
if not "%ENVIRONMENT%"=="dev" if not "%ENVIRONMENT%"=="staging" if not "%ENVIRONMENT%"=="prod" (
    echo ❌ Environnement invalide. Utilisez: dev, staging, ou prod
    exit /b 1
)

REM Installer les dépendances frontend
echo 📦 Installation des dépendances frontend...
cd frontend
npm install

REM Vérifier Firebase CLI
echo 🔥 Vérification de Firebase CLI...
firebase --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Firebase CLI non installé. Installez-le avec: npm install -g firebase-tools
    exit /b 1
)

REM Connexion Firebase
echo 🔐 Connexion Firebase...
firebase login

REM Configurer l'environnement Firebase
echo ⚙️ Configuration de l'environnement %ENVIRONMENT%...
cd ..\backend
firebase use %ENVIRONMENT%

REM Lancer l'application
echo 🚀 Lancement de l'application...
cd ..\frontend
npm run dev

echo ✅ Initialisation terminée!
echo 🌐 Application disponible sur: http://localhost:3000
