#!/bin/bash

# Script pour corriger les Firebase Functions générées
# Supprime les fichiers complexes et recrée un index.ts simplifié

set -e

FUNCTIONS_DIR="./functions"
SRC_DIR="$FUNCTIONS_DIR/src"

echo "🔧 Correction des Firebase Functions dans $FUNCTIONS_DIR..."

# Supprimer les sous-dossiers complexes
rm -rf "$SRC_DIR/auth" \
       "$SRC_DIR/firestore" \
       "$SRC_DIR/https" \
       "$SRC_DIR/scheduled" \
       "$SRC_DIR/storage" \
       "$SRC_DIR/utils" \
       "$SRC_DIR/admin.ts" \
       "$SRC_DIR/lib" \
       "$SRC_DIR/utils" \
       "$SRC_DIR/config" \
       "$SRC_DIR/constants" \
       "$SRC_DIR/interfaces" \
       "$SRC_DIR/types" \
       "$SRC_DIR/validators" \
       "$SRC_DIR/services" \
       "$SRC_DIR/triggers" \
       "$SRC_DIR/middleware" \
       "$SRC_DIR/routes" \
       "$SRC_DIR/controllers" \
       "$SRC_DIR/models" \
       "$SRC_DIR/helpers" \
       "$SRC_DIR/templates" \
       "$SRC_DIR/emails" \
       "$SRC_DIR/storage" \
       "$SRC_DIR/pubsub" \
       "$SRC_DIR/callable" \
       "$SRC_DIR/tasks" \
       "$SRC_DIR/extensions" \
       "$SRC_DIR/integrations" \
       "$SRC_DIR/admin" \
       "$SRC_DIR/auth" \
       "$SRC_DIR/firestore" \
       "$SRC_DIR/https" \
       "$SRC_DIR/scheduled" \
       "$SRC_DIR/storage" \
       "$SRC_DIR/utils" \
       "$SRC_DIR/index.ts" # Supprimer l'ancien index.ts aussi

# Recréer un index.ts ultra-simplifié
mkdir -p "$SRC_DIR" # S'assurer que src existe
cat > "$SRC_DIR/index.ts" << 'EOF'
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const helloWorld = functions.https.onRequest((request, response) => {
  response.json({ message: "Hello from Firebase Functions!" });
});

export const healthCheck = functions.https.onRequest((request, response) => {
  response.json({
    status: "healthy",
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || "development"
  });
});

export const scheduledFunction = functions.pubsub
  .schedule('every 24 hours')
  .timeZone('UTC')
  .onRun(async (context) => {
    console.log('Scheduled function executed at:', new Date().toISOString());
    return null;
  });
EOF

echo "✅ Firebase Functions corrigées et simplifiées." 