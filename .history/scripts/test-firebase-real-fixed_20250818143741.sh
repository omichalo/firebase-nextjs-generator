#!/bin/bash

# 🔥 Test des fonctionnalités Firebase RÉELLES avec émulateurs - VERSION CORRIGÉE
# Ce script teste l'intégration Firebase complète : Auth, Firestore, Storage, Functions

set -e  # Arrêter sur la première erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Compteurs de tests
TOTAL_TESTS=0
PASSED=0
FAILED=0

# Fonction de test avec compteur
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -e "\n${BLUE}Testing: ${test_name}${NC}"
    
    if eval "$test_command"; then
        echo -e "  ${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "  ${RED}FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
}

# Fonction de nettoyage
cleanup() {
    echo -e "\n${YELLOW}Cleaning up Firebase emulators...${NC}"
    
    # Arrêter les émulateurs
    if [ -n "$EMULATOR_PID" ]; then
        kill $EMULATOR_PID 2>/dev/null || true
        wait $EMULATOR_PID 2>/dev/null || true
    fi
    
    echo "Cleanup completed"
}

# Trapper les signaux pour le nettoyage
trap cleanup EXIT INT TERM

echo -e "${PURPLE}=== Test des fonctionnalités Firebase RÉELLES avec émulateurs - VERSION CORRIGÉE ===${NC}"
echo "Ce script teste l'intégration Firebase complète en utilisant les émulateurs locaux"

echo -e "\n${CYAN}=== Phase 1: Tests d'environnement Firebase ===${NC}"

# Tests d'environnement Firebase
run_test "Firebase CLI installation" "firebase --version"

echo -e "\n${CYAN}=== Phase 2: Utilisation du projet de test existant ===${NC}"

# Utiliser le projet de test existant
if [ ! -d "./test-firebase-real" ]; then
    echo -e "${RED}❌ Projet de test non trouvé. Veuillez d'abord exécuter le générateur.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Projet de test existant trouvé!${NC}"

# Vérification de la structure
run_test "Project structure" "test -d ./test-firebase-real/frontend && test -d ./test-firebase-real/backend"
run_test "Firebase config files" "test -f ./test-firebase-real/backend/firebase.json && test -f ./test-firebase-real/backend/.firebaserc"
run_test "Firebase functions" "test -d ./test-firebase-real/backend/functions"
run_test "Frontend Firebase config" "test -f ./test-firebase-real/frontend/src/lib/firebase.ts"

echo -e "\n${CYAN}=== Phase 3: Configuration des émulateurs Firebase ===${NC}"

cd ./test-firebase-real/backend

# Vérifier la configuration des émulateurs
run_test "Emulators config in firebase.json" "grep -q 'emulators' firebase.json"
run_test "Auth emulator config" "grep -q 'auth' firebase.json"
run_test "Firestore emulator config" "grep -q 'firestore' firebase.json"
run_test "Functions emulator config" "grep -q 'functions' firebase.json"
run_test "Storage emulator config" "grep -q 'storage' firebase.json"

# Installer les dépendances des fonctions
echo "Installing Firebase Functions dependencies..."
cd functions
npm install
cd ..

echo -e "\n${CYAN}=== Phase 4: Démarrage des émulateurs Firebase ===${NC}"

# Démarrer les émulateurs Firebase
echo -e "\n${YELLOW}Starting Firebase emulators...${NC}"

# Démarrer les émulateurs en arrière-plan
firebase emulators:start --only auth,firestore,functions,storage > emulators.log 2>&1 &
EMULATOR_PID=$!

# Attendre que les émulateurs démarrent (plus de temps pour macOS)
echo "Waiting for emulators to start..."
echo "This may take up to 45 seconds on macOS..."
sleep 45

# Vérifier que les émulateurs fonctionnent avec les bonnes réponses
run_test "Auth emulator running" "curl -s http://localhost:9099 | grep -q 'authEmulator'"
run_test "Firestore emulator running" "curl -s http://localhost:8080 | grep -q 'Ok'"
run_test "Functions emulator running" "curl -s http://localhost:5001 | grep -q 'Not Found'"
run_test "Storage emulator running" "curl -s http://localhost:9199 | grep -q 'Not Implemented'"

echo -e "\n${CYAN}=== Phase 5: Tests d'authentification Firebase ===${NC}"

# Tests d'authentification avec l'émulateur
cd ../frontend

# Installer les dépendances
echo "Installing frontend dependencies..."
npm install

# Créer un fichier de test d'authentification corrigé
cat > test-auth.js << 'EOF'
const { initializeApp } = require('firebase/app');
const { getAuth, createUserWithEmailAndPassword, signInWithEmailAndPassword, signOut } = require('firebase/auth');

// Configuration Firebase pour les émulateurs
const firebaseConfig = {
  apiKey: "demo-api-key",
  authDomain: "demo-project.firebaseapp.com",
  projectId: "demo-project",
  storageBucket: "demo-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "demo-app-id"
};

// Initialiser Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

// Connecter aux émulateurs (méthode corrigée)
if (auth.useEmulator) {
  auth.useEmulator('http://localhost:9099');
} else {
  console.log('useEmulator not available, using production endpoints');
}

async function testAuth() {
  try {
    console.log('Testing Firebase Auth...');
    
    // Test de création d'utilisateur
    const userCredential = await createUserWithEmailAndPassword(auth, 'test@example.com', 'password123');
    console.log('✅ User created:', userCredential.user.email);
    
    // Test de connexion
    const signInCredential = await signInWithEmailAndPassword(auth, 'test@example.com', 'password123');
    console.log('✅ User signed in:', signInCredential.user.email);
    
    // Test de déconnexion
    await signOut(auth);
    console.log('✅ User signed out');
    
    return true;
  } catch (error) {
    console.error('❌ Auth test failed:', error.message);
    return false;
  }
}

// Exécuter le test
testAuth().then(success => {
  if (success) {
    console.log('🎉 All auth tests passed!');
    process.exit(0);
  } else {
    console.log('💥 Some auth tests failed!');
    process.exit(1);
  }
});
EOF

# Tester l'authentification
run_test "Firebase Auth integration" "node test-auth.js"

echo -e "\n${CYAN}=== Phase 6: Tests de Firestore ===${NC}"

# Tests de Firestore avec l'émulateur
cat > test-firestore.js << 'EOF'
const { initializeApp } = require('firebase/app');
const { getFirestore, collection, addDoc, getDocs, doc, updateDoc, deleteDoc } = require('firebase/firestore');

// Configuration Firebase pour les émulateurs
const firebaseConfig = {
  apiKey: "demo-api-key",
  authDomain: "demo-project.firebaseapp.com",
  projectId: "demo-project",
  storageBucket: "demo-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "demo-app-id"
};

// Initialiser Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// Connecter aux émulateurs
if (db.useEmulator) {
  db.useEmulator('localhost', 8080);
} else {
  console.log('useEmulator not available, using production endpoints');
}

async function testFirestore() {
  try {
    console.log('Testing Firestore...');
    
    // Test de création de document
    const docRef = await addDoc(collection(db, 'test'), {
      name: 'Test Document',
      timestamp: new Date(),
      value: 42
    });
    console.log('✅ Document created with ID:', docRef.id);
    
    // Test de lecture de documents
    const querySnapshot = await getDocs(collection(db, 'test'));
    console.log('✅ Documents read:', querySnapshot.size);
    
    // Test de mise à jour
    await updateDoc(doc(db, 'test', docRef.id), {
      value: 84,
      updated: true
    });
    console.log('✅ Document updated');
    
    // Test de suppression
    await deleteDoc(doc(db, 'test', docRef.id));
    console.log('✅ Document deleted');
    
    return true;
  } catch (error) {
    console.error('❌ Firestore test failed:', error.message);
    return false;
  }
}

// Exécuter le test
testFirestore().then(success => {
  if (success) {
    console.log('🎉 All Firestore tests passed!');
    process.exit(0);
  } else {
    console.log('💥 Some Firestore tests failed!');
    process.exit(1);
  }
});
EOF

# Tester Firestore
run_test "Firestore integration" "node test-firestore.js"

echo -e "\n${CYAN}=== Phase 7: Tests de Firebase Functions ===${NC}"

# Tests de Firebase Functions
run_test "Functions TypeScript compilation" "cd ../backend/functions && npm run build"

# Tester les fonctions HTTP
run_test "Functions HTTP endpoints" "curl -s http://localhost:5001/demo-project/us-central1/helloWorld | grep -q 'Hello from Firebase Functions'"

echo -e "\n${CYAN}=== Phase 8: Tests de Firebase Storage ===${NC}"

# Tests de Firebase Storage
cat > test-storage.js << 'EOF'
const { initializeApp } = require('firebase/app');
const { getStorage, ref, uploadBytes, getDownloadURL, deleteObject } = require('firebase/storage');

// Configuration Firebase pour les émulateurs
const firebaseConfig = {
  apiKey: "demo-api-key",
  authDomain: "demo-project.firebaseapp.com",
  projectId: "demo-project",
  storageBucket: "demo-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "demo-app-id"
};

// Initialiser Firebase
const app = initializeApp(firebaseConfig);
const storage = getStorage(app);

// Connecter aux émulateurs
if (storage.useEmulator) {
  storage.useEmulator('localhost', 9199);
} else {
  console.log('useEmulator not available, using production endpoints');
}

async function testStorage() {
  try {
    console.log('Testing Firebase Storage...');
    
    // Créer un fichier de test
    const testData = 'Hello Firebase Storage!';
    const testBlob = new Blob([testData], { type: 'text/plain' });
    
    // Test d'upload
    const storageRef = ref(storage, 'test/test-file.txt');
    const snapshot = await uploadBytes(storageRef, testBlob);
    console.log('✅ File uploaded:', snapshot.metadata.name);
    
    // Test de téléchargement
    const downloadURL = await getDownloadURL(storageRef);
    console.log('✅ Download URL:', downloadURL);
    
    // Test de suppression
    await deleteObject(storageRef);
    console.log('✅ File deleted');
    
    return true;
  } catch (error) {
    console.error('❌ Storage test failed:', error.message);
    return false;
  }
}

// Exécuter le test
testStorage().then(success => {
  if (success) {
    console.log('🎉 All Storage tests passed!');
    process.exit(0);
  } else {
    console.log('💥 Some Storage tests failed!');
    process.exit(1);
  }
});
EOF

# Tester Storage
run_test "Firebase Storage integration" "node test-storage.js"

echo -e "\n${CYAN}=== Phase 9: Tests d'intégration frontend ===${NC}"

# Tests d'intégration frontend
run_test "Frontend Firebase config" "test -f src/lib/firebase.ts"

# Test de build
echo "Testing frontend build..."
run_test "Frontend build with Firebase" "npm run build"

echo -e "\n${CYAN}=== RÉSULTATS FINAUX ===${NC}"
echo -e "🎯 Tests totaux: ${TOTAL_TESTS}"
echo -e "✅ Tests réussis: ${GREEN}${PASSED}${NC}"
echo -e "❌ Tests échoués: ${RED}${FAILED}${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 TOUS LES TESTS FIREBASE SONT RÉUSSIS ! 🎉${NC}"
    exit 0
else
    echo -e "\n${RED}💥 ${FAILED} test(s) ont échoué. Vérifiez les logs ci-dessus.${NC}"
    exit 1
fi 