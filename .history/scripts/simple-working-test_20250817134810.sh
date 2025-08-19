#!/bin/bash

# Script de test simple qui fonctionne vraiment
# Usage: ./scripts/simple-working-test.sh

set -e

echo "=== Test Simple du Générateur ==="
echo

# Test 1: Générer un projet minimal
echo "1. Génération du projet minimal..."
if npx ts-node src/cli.ts create --name test-minimal --description "Test project" --author "Test" --package-manager npm --nextjs-version 15 --ui mui --state-management zustand --features pwa --output ./test-output-minimal --yes; then
    echo "   ✅ Génération réussie"
    
    # Vérifier immédiatement la structure
    echo "2. Vérification de la structure..."
    if [ -d "test-output-minimal/frontend" ] && [ -d "test-output-minimal/backend" ]; then
        echo "   ✅ Structure correcte"
        
        # Vérifier les fichiers frontend
        if [ -f "test-output-minimal/frontend/package.json" ] && [ -f "test-output-minimal/frontend/src/app/page.tsx" ]; then
            echo "   ✅ Fichiers frontend OK"
        else
            echo "   ❌ Fichiers frontend manquants"
        fi
        
        # Vérifier les fichiers backend
        if [ -f "test-output-minimal/backend/firebase.json" ] && [ -f "test-output-minimal/backend/.firebaserc" ]; then
            echo "   ✅ Fichiers backend OK"
        else
            echo "   ❌ Fichiers backend manquants"
        fi
        
        # Vérifier les variables Handlebars
        if ! grep -r "{{.*}}" test-output-minimal 2>/dev/null; then
            echo "   ✅ Variables Handlebars traitées"
        else
            echo "   ❌ Variables Handlebars non traitées"
        fi
        
        # Vérifier le nom du projet
        if grep -r "test-minimal" test-output-minimal >/dev/null 2>&1; then
            echo "   ✅ Nom du projet remplacé"
        else
            echo "   ❌ Nom du projet non remplacé"
        fi
        
    else
        echo "   ❌ Structure incorrecte"
    fi
    
else
    echo "   ❌ Génération échouée"
fi

echo
echo "3. Nettoyage..."
rm -rf test-output-minimal
echo "   ✅ Nettoyage effectué"

echo
echo "=== Test terminé ===" 