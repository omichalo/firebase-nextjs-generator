#!/bin/bash

# Script de débogage final pour identifier le problème de structure
# Usage: ./scripts/debug-final.sh

set -e

echo "=== Débogage Final du Générateur ==="
echo

# Test 1: Générer un projet minimal
echo "1. Génération du projet minimal..."
if npx ts-node src/cli.ts create --name test-minimal --description "Test project" --author "Test" --version "1.0.0" --package-manager npm --nextjs-version 15 --ui mui --state-management zustand --features pwa --output ./test-output-minimal --yes; then
    echo "   ✅ Génération réussie"
else
    echo "   ❌ Génération échouée"
    exit 1
fi

echo
echo "2. Vérification de la création..."
sleep 2

if [ -d "test-output-minimal" ]; then
    echo "   ✅ Dossier test-output-minimal créé"
    echo "   Contenu:"
    ls -la test-output-minimal
    echo
    
    if [ -d "test-output-minimal/frontend" ]; then
        echo "   ✅ Dossier frontend créé"
        echo "   Contenu frontend:"
        ls -la test-output-minimal/frontend
        echo
    else
        echo "   ❌ Dossier frontend manquant"
    fi
    
    if [ -d "test-output-minimal/backend" ]; then
        echo "   ✅ Dossier backend créé"
        echo "   Contenu backend:"
        ls -la test-output-minimal/backend
        echo
    else
        echo "   ❌ Dossier backend manquant"
    fi
else
    echo "   ❌ Dossier test-output-minimal non créé"
fi

echo
echo "3. Vérification des variables Handlebars..."
if grep -r "{{.*}}" test-output-minimal 2>/dev/null; then
    echo "   ⚠️  Variables Handlebars non remplacées trouvées:"
    grep -r "{{.*}}" test-output-minimal
else
    echo "   ✅ Toutes les variables Handlebars remplacées"
fi

echo
echo "4. Vérification du nom du projet..."
if grep -r "test-minimal" test-output-minimal >/dev/null 2>&1; then
    echo "   ✅ Nom du projet correctement remplacé"
else
    echo "   ❌ Nom du projet non trouvé"
fi

echo
echo "5. Test de génération d'un projet complet..."
if npx ts-node src/cli.ts create --name test-complete --description "Complete test project" --author "Test" --version "1.0.0" --package-manager npm --nextjs-version 15 --ui shadcn --state-management redux --features pwa,fcm,analytics,performance,sentry --output ./test-output-complete --yes; then
    echo "   ✅ Génération complète réussie"
    
    echo "   Vérification de la structure complète..."
    sleep 2
    
    if [ -d "test-output-complete/frontend" ] && [ -d "test-output-complete/backend" ]; then
        echo "   ✅ Structure complète correcte"
        
        if [ -f "test-output-complete/frontend/public/manifest.json" ]; then
            echo "   ✅ PWA configuré"
        else
            echo "   ❌ PWA non configuré"
        fi
        
        if [ -f "test-output-complete/frontend/src/fcm/fcm-config.ts" ]; then
            echo "   ✅ FCM configuré"
        else
            echo "   ❌ FCM non configuré"
        fi
    else
        echo "   ❌ Structure complète incorrecte"
    fi
else
    echo "   ❌ Génération complète échouée"
fi

echo
echo "=== Résumé ==="
echo "Projets créés:"
if [ -d "test-output-minimal" ]; then
    echo "  ✅ test-output-minimal"
else
    echo "  ❌ test-output-minimal"
fi

if [ -d "test-output-complete" ]; then
    echo "  ✅ test-output-complete"
else
    echo "  ❌ test-output-complete"
fi

echo
echo "⚠️  Les projets ne seront PAS nettoyés automatiquement."
echo "   Pour les nettoyer manuellement: rm -rf test-output-*"
echo
echo "=== Fin du débogage ===" 