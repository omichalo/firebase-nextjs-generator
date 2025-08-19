#!/bin/bash

# Script de débogage pour identifier le problème de génération
# Usage: ./scripts/debug-test.sh

set -e

echo "=== Test de débogage de la génération ==="
echo

# Test 1: Vérifier que la CLI fonctionne
echo "1. Test de la CLI..."
if npx ts-node src/cli.ts --version; then
    echo "   ✅ CLI fonctionnelle"
else
    echo "   ❌ CLI défaillante"
    exit 1
fi
echo

# Test 2: Test de génération avec affichage des erreurs
echo "2. Test de génération avec affichage des erreurs..."
echo "   Commande: npx ts-node src/cli.ts create --name test-debug --description 'Debug project' --author 'Test' --package-manager npm --nextjs-version 15 --ui mui --state-management zustand --features pwa --output ./test-debug --yes"

# Exécuter la commande et capturer la sortie
if OUTPUT=$(npx ts-node src/cli.ts create --name test-debug --description "Debug project" --author "Test" --package-manager npm --nextjs-version 15 --ui mui --state-management zustand --features pwa --output ./test-debug --yes 2>&1); then
    echo "   ✅ Génération réussie"
    echo "   Sortie: $OUTPUT"
else
    echo "   ❌ Génération échouée"
    echo "   Sortie: $OUTPUT"
fi
echo

# Test 3: Vérifier si le projet a été créé
echo "3. Vérification de la création du projet..."
if [ -d "test-debug" ]; then
    echo "   ✅ Dossier test-debug créé"
    echo "   Contenu:"
    ls -la test-debug
    echo
    if [ -d "test-debug/frontend" ]; then
        echo "   ✅ Dossier frontend créé"
        ls -la test-debug/frontend
    else
        echo "   ❌ Dossier frontend manquant"
    fi
    echo
    if [ -d "test-debug/backend" ]; then
        echo "   ✅ Dossier backend créé"
        ls -la test-debug/backend
    else
        echo "   ❌ Dossier backend manquant"
    fi
else
    echo "   ❌ Dossier test-debug non créé"
fi
echo

# Test 4: Nettoyage
echo "4. Nettoyage..."
if [ -d "test-debug" ]; then
    rm -rf test-debug
    echo "   ✅ Nettoyage effectué"
else
    echo "   ℹ️  Rien à nettoyer"
fi

echo
echo "=== Fin du test de débogage ===" 