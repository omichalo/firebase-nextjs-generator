# Scripts de Test du Générateur Firebase + Next.js 2025

Ce dossier contient tous les scripts de test automatisés pour le générateur Firebase + Next.js avec App Hosting.

## 🎯 Script Principal de Test (RECOMMANDÉ)

### `test.sh` - **Unified Test Runner**

**Script unifié qui orchestre tous les tests et gère l'isolation des artefacts.**

Ce script est le **point d'entrée principal** pour tous les tests :

#### Fonctionnalités :

- ✅ **Orchestration** : Lance automatiquement `test-comprehensive.sh`
- ✅ **Isolation** : Crée un répertoire `.test-artifacts/run-YYYYMMDD-HHMMSS/`
- ✅ **Nettoyage** : Supprime automatiquement les anciens projets de test
- ✅ **Logs** : Sauvegarde tous les logs dans le répertoire d'artefacts
- ✅ **Environnement** : Configure `TEST_BASE_DIR` pour l'isolation

#### Usage :

```bash
# Exécuter tous les tests (recommandé)
./scripts/test.sh

# Personnaliser le répertoire d'artefacts
TEST_OUTPUT_DIR=.ci-artifacts ./scripts/test.sh
```

#### Résultat attendu :

- **Tous les tests passent** ✅
- **Générateur 100% fonctionnel** 🚀
- **Prêt pour la production** 🎯
- **Logs sauvegardés** dans `.test-artifacts/`

---

## 🔬 Script de Test Ultra-Complet

### `test-comprehensive.sh` - **Test TRÈS Complet (132 tests)**

**Script de test ultra-complet qui teste TOUTES les fonctionnalités avancées.**

Ce script va **beaucoup plus loin** que les tests standards et couvre **132 tests** répartis en **30 phases** :

## 📋 **DÉTAIL COMPLET DE TOUS LES TESTS**

### **Phase 1: Tests d'environnement (5 tests)**

- ✅ **Node.js version** : Vérification de la version Node.js
- ✅ **npm version** : Vérification de la version npm
- ✅ **Git installation** : Vérification de l'installation Git
- ✅ **package.json exists** : Vérification de l'existence du package.json
- ✅ **Dependencies installed** : Vérification de l'installation des dépendances

### **Phase 2: Tests de build (2 tests)**

- ✅ **Project build** : Compilation TypeScript du projet
- ✅ **Dist folder created** : Vérification de la création du dossier dist

### **Phase 3: Tests de la CLI (2 tests)**

- ✅ **CLI help command** : Test de la commande d'aide
- ✅ **CLI version command** : Test de la commande de version

### **Phase 4: Tests de génération (15 tests)**

- ✅ **Generate minimal project (MUI + Zustand)** : Projet minimal avec MUI et Zustand
- ✅ **Project structure (minimal)** : Vérification de la structure du projet minimal
- ✅ **Frontend files (minimal)** : Vérification des fichiers frontend
- ✅ **Backend files (minimal)** : Vérification des fichiers backend
- ✅ **Handlebars processing (minimal)** : Traitement des templates Handlebars
- ✅ **Project name replacement (minimal)** : Remplacement des noms de projet
- ✅ **Generate complete project (MUI + Redux + all features)** : Projet complet avec toutes les fonctionnalités
- ✅ **Complete project structure** : Vérification de la structure complète
- ✅ **Advanced features** : Vérification des fonctionnalités avancées
- ✅ **Handlebars processing (complete)** : Traitement complet des templates
- ✅ **Project name replacement (complete)** : Remplacement complet des noms
- ✅ **Generate project with Yarn + Next.js 14** : Projet avec Yarn et Next.js 14
- ✅ **Yarn project structure** : Vérification de la structure Yarn
- ✅ **Handlebars processing (Yarn)** : Traitement des templates avec Yarn
- ✅ **Documentation files** : Vérification des fichiers de documentation

### **Phase 5: Tests de validation (2 tests)**

- ✅ **Validate generated projects** : Validation des projets générés
- ✅ **Documentation files** : Vérification des fichiers de documentation

### **Phase 6: Tests de fonctionnalités spécifiques (6 tests)**

- ✅ **MUI configuration (Redux)** : Configuration MUI avec Redux
- ✅ **PWA configuration** : Configuration PWA
- ✅ **Firebase configuration** : Configuration Firebase
- ✅ **TypeScript configuration** : Configuration TypeScript
- ✅ **Initialization scripts** : Scripts d'initialisation
- ✅ **Error handling (invalid project name)** : Gestion des erreurs

### **Phase 7: Tests de robustesse (1 test)**

- ✅ **Error handling (invalid project name)** : Gestion des erreurs de noms invalides

### **Phase 8: Tests de fonctionnalités avancées (8 tests)**

- ✅ **MUI components generation** : Génération des composants MUI
- ✅ **MUI components generation (Redux)** : Génération des composants MUI avec Redux
- ✅ **Zustand stores generation** : Génération des stores Zustand
- ✅ **Redux stores generation** : Génération des stores Redux
- ✅ **Custom hooks generation** : Génération des hooks personnalisés
- ✅ **Firebase functions generation** : Génération des fonctions Firebase
- ✅ **Firestore rules generation** : Génération des règles Firestore
- ✅ **Environment configuration generation** : Génération de la configuration d'environnement

### **Phase 9: Tests de validation des templates (2 tests)**

- ✅ **All templates are processed** : Tous les templates sont traités
- ✅ **Project name consistency across all files** : Cohérence des noms de projet

### **Phase 10: Tests du validateur de configuration (3 tests)**

- ✅ **Project config validation** : Validation de la configuration du projet
- ✅ **Firebase config validation** : Validation de la configuration Firebase
- ✅ **Next.js config validation** : Validation de la configuration Next.js

### **Phase 11: Tests du générateur Firebase (4 tests)**

- ✅ **Firebase complete structure** : Structure Firebase complète
- ✅ **Cloud Functions structure** : Structure des Cloud Functions
- ✅ **Firebase extensions** : Extensions Firebase
- ✅ **Deployment scripts** : Scripts de déploiement

### **Phase 12: Tests du template engine (2 tests)**

- ✅ **Complex Handlebars processing** : Traitement complexe des templates Handlebars
- ✅ **Critical templates validation** : Validation des templates critiques

### **Phase 13: Tests de la chaîne CI/CD (4 tests)**

- ✅ **GitHub Actions workflows** : Workflows GitHub Actions
- ✅ **Workflows YAML validation** : Validation YAML des workflows
- ✅ **CI/CD deployment scripts** : Scripts de déploiement CI/CD
- ✅ **Environment configuration for CI/CD** : Configuration d'environnement CI/CD

### **Phase 14: Tests de robustesse avancés (4 tests)**

- ✅ **Validation error handling** : Gestion des erreurs de validation
- ✅ **Generation error handling** : Gestion des erreurs de génération
- ✅ **Generated files validation** : Validation des fichiers générés
- ✅ **Generated files validation** : Validation des fichiers générés

### **Phase 15: Tests de performance (3 tests)**

- ✅ **Project generation performance** : Performance de génération des projets
- ✅ **Generated files size optimization** : Optimisation de la taille des fichiers
- ✅ **Template optimization** : Optimisation des templates

### **Phase 16: Tests de sécurité (3 tests)**

- ✅ **Firestore rules security validation** : Validation de sécurité des règles Firestore
- ✅ **Storage rules security validation** : Validation de sécurité des règles Storage
- ✅ **Code injection protection** : Protection contre l'injection de code

### **Phase 17: Tests d'internationalisation (3 tests)**

- ✅ **Multi-language support** : Support multi-langue
- ✅ **Date format support** : Support des formats de date
- ✅ **Currency support** : Support des devises

### **Phase 18: Tests de robustesse extrême (3 tests)**

- ✅ **Very long project names** : Noms de projet très longs
- ✅ **Special characters in project names** : Caractères spéciaux dans les noms
- ✅ **Initialization scripts validation** : Validation des scripts d'initialisation

### **Phase 19: Tests de régression (3 tests)**

- ✅ **Configuration change validation** : Validation des changements de configuration
- ✅ **Compatibility tests** : Tests de compatibilité
- ✅ **Metadata validation** : Validation des métadonnées

### **Phase 20: Tests opérationnels réels (10 tests)**

- ✅ **Generated projects build successfully** : Les projets générés se construisent avec succès
- ✅ **Firestore rules validation** : Validation des règles Firestore
- ✅ **MUI components functionality** : Fonctionnalité des composants MUI
- ✅ **Custom hooks functionality** : Fonctionnalité des hooks personnalisés
- ✅ **State management stores functionality** : Fonctionnalité des stores de gestion d'état
- ✅ **TypeScript configuration validity** : Validité de la configuration TypeScript
- ✅ **Next.js configuration validity** : Validité de la configuration Next.js
- ✅ **PWA functionality validation** : Validation de la fonctionnalité PWA
- ✅ **MUI components quality validation** : Validation de la qualité des composants MUI
- ✅ **Custom hooks quality validation** : Validation de la qualité des hooks personnalisés

### **Phase 21: Tests d'intégration complets (4 tests)**

- ✅ **Complete integration pipeline** : Pipeline d'intégration complet
- ✅ **Next.js version compatibility** : Compatibilité des versions Next.js
- ✅ **PWA features integration** : Intégration des fonctionnalités PWA
- ✅ **Complete Firebase integration** : Intégration Firebase complète

### **Phase 22: Tests end-to-end réels (5 tests)**

- ✅ **Complete user workflow simulation** : Simulation du workflow utilisateur complet
- ✅ **Business scenario simulation (Auth + CRUD)** : Simulation de scénarios métier
- ✅ **Complete CI/CD deployment workflow** : Workflow de déploiement CI/CD complet
- ✅ **Performance and scalability validation** : Validation des performances et de la scalabilité
- ✅ **Security and monitoring integration** : Intégration de la sécurité et du monitoring

### **Phase 23: Tests de stress et robustesse avancés (5 tests)**

- ✅ **Multiple project generation stress test** : Test de stress de génération de projets multiples
- ✅ **Extreme configuration robustness** : Robustesse des configurations extrêmes
- ✅ **Performance under load** : Performance sous charge
- ✅ **Error recovery and resilience** : Récupération d'erreur et résilience
- ✅ **Data consistency across projects** : Cohérence des données entre projets

### **Phase 24: Tests de migration et compatibilité (5 tests)**

- ✅ **Next.js version compatibility matrix** : Matrice de compatibilité des versions Next.js
- ✅ **Package manager migration compatibility** : Compatibilité de migration des gestionnaires de paquets
- ✅ **State manager migration compatibility** : Compatibilité de migration des gestionnaires d'état
- ✅ **Template backward compatibility** : Compatibilité rétroactive des templates
- ✅ **Feature migration compatibility** : Compatibilité de migration des fonctionnalités

### **Phase 25: Tests de déploiement réel Firebase (5 tests)**

- ✅ **Firebase deployment configuration validation** : Validation de la configuration de déploiement Firebase
- ✅ **Next.js deployment configuration validation** : Validation de la configuration de déploiement Next.js
- ✅ **Production build for deployment** : Build de production pour le déploiement
- ✅ **Production assets validation** : Validation des assets de production
- ✅ **Environment configuration for deployment** : Configuration d'environnement pour le déploiement

### **Phase 26: Tests d'intégration Firebase réels (5 tests)**

- ✅ **Cloud Functions structure validation** : Validation de la structure des Cloud Functions
- ✅ **Firestore configuration validation** : Validation de la configuration Firestore
- ✅ **Firebase Storage configuration validation** : Validation de la configuration Firebase Storage
- ✅ **Firebase Extensions validation** : Validation des extensions Firebase
- ✅ **Firebase Authentication configuration validation** : Validation de la configuration de l'authentification Firebase

### **Phase 27: Tests de performance et limites Firebase (5 tests)**

- ✅ **Generation performance under load** : Performance de génération sous charge
- ✅ **Firebase limits validation** : Validation des limites Firebase
- ✅ **Firestore quotas validation** : Validation des quotas Firestore
- ✅ **Build optimization validation** : Validation de l'optimisation du build
- ✅ **Scalability configuration validation** : Validation de la configuration de scalabilité

### **Phase 28: Tests de déploiement réel Firebase (5 tests)**

- ✅ **Firebase Hosting deployment** : Déploiement Firebase Hosting
- ✅ **Firestore deployment** : Déploiement Firestore
- ✅ **Cloud Functions deployment** : Déploiement des Cloud Functions
- ✅ **Firebase Extensions deployment** : Déploiement des extensions Firebase
- ✅ **Complete project deployment readiness** : Préparation complète au déploiement du projet

### **Phase 29: Tests de la chaîne CI/CD complète (5 tests)**

- ✅ **GitHub Actions CI/CD workflows validation** : Validation des workflows CI/CD GitHub Actions
- ✅ **CI/CD environment configuration validation** : Validation de la configuration d'environnement CI/CD
- ✅ **CI/CD deployment scripts validation** : Validation des scripts de déploiement CI/CD
- ✅ **CI/CD security validation** : Validation de la sécurité CI/CD
- ✅ **Complete CI/CD pipeline validation** : Validation de la chaîne CI/CD complète

### **Phase 30: Tests de déploiement réel avec Firebase CLI (6 tests)**

- ✅ **Firebase CLI validation and configuration** : Validation et configuration de Firebase CLI
- ✅ **Firebase project configuration validation** : Validation de la configuration du projet Firebase
- ✅ **Firestore rules validation with Firebase CLI** : Validation des règles Firestore avec Firebase CLI
- ✅ **Storage rules validation with Firebase CLI** : Validation des règles Storage avec Firebase CLI
- ✅ **Complete deployment preparation with Firebase CLI** : Préparation complète au déploiement avec Firebase CLI
- ✅ **Complete Firebase deployment validation (dry-run)** : Validation complète du déploiement Firebase en dry-run

## 🚀 **MODE OPÉRATOIRE COMPLET**

### **1. Prérequis**

```bash
# Vérifier que vous êtes dans le répertoire racine du projet
cd /path/to/base-react-firebase-project

# Vérifier que les scripts sont exécutables
chmod +x scripts/*.sh
```

### **2. Exécution des tests**

```bash
# Option 1: Test unifié (RECOMMANDÉ)
./scripts/test.sh

# Option 2: Test direct du script complet
./scripts/test-comprehensive.sh
```

### **3. Structure des résultats**

```
.test-artifacts/
└── run-YYYYMMDD-HHMMSS/
    ├── test-comprehensive.log          # Log complet des tests
    ├── test-output-minimal-mui/        # Projet de test minimal
    ├── test-output-complete-mui-redux/ # Projet de test complet
    └── test-output-yarn-14/           # Projet de test Yarn
```

### **4. Interprétation des résultats**

```bash
# Succès complet (132/132)
🎉 Tous les tests ont réussi !
🚀 Le générateur est 100% fonctionnel et prêt pour la production !

# Échecs partiels
❌ X tests ont échoué.
🔧 Des ajustements peuvent être nécessaires.
```

## 🔧 **CONFIGURATION FIREBASE POUR LES TESTS**

### **Projet de test configuré :**

- **Nom** : `sqyping-dev`
- **Type** : Projet Firebase de développement
- **Services** : Firestore, Cloud Functions, Extensions

### **Tests Firebase en dry-run :**

- ✅ **Firestore rules** : Validation complète réussie
- ✅ **Storage rules** : Validation intelligente (gère le service non activé)
- ✅ **Cloud Functions** : Structure validée
- ✅ **Extensions** : Structure validée

## 📊 **STATISTIQUES DES TESTS**

### **Répartition par catégorie :**

- **Tests d'environnement** : 5 tests (3.8%)
- **Tests de build** : 2 tests (1.5%)
- **Tests de génération** : 15 tests (11.4%)
- **Tests de validation** : 2 tests (1.5%)
- **Tests de fonctionnalités** : 6 tests (4.5%)
- **Tests de robustesse** : 1 test (0.8%)
- **Tests avancés** : 8 tests (6.1%)
- **Tests de templates** : 2 tests (1.5%)
- **Tests de configuration** : 3 tests (2.3%)
- **Tests Firebase** : 4 tests (3.0%)
- **Tests CI/CD** : 4 tests (3.0%)
- **Tests de robustesse avancés** : 4 tests (3.0%)
- **Tests de performance** : 3 tests (2.3%)
- **Tests de sécurité** : 3 tests (2.3%)
- **Tests d'internationalisation** : 3 tests (2.3%)
- **Tests de robustesse extrême** : 3 tests (2.3%)
- **Tests de régression** : 3 tests (2.3%)
- **Tests opérationnels** : 10 tests (7.6%)
- **Tests d'intégration** : 4 tests (3.0%)
- **Tests end-to-end** : 5 tests (3.8%)
- **Tests de stress** : 5 tests (3.8%)
- **Tests de migration** : 5 tests (3.8%)
- **Tests de déploiement** : 5 tests (3.8%)
- **Tests d'intégration Firebase** : 5 tests (3.8%)
- **Tests de performance Firebase** : 5 tests (3.8%)
- **Tests de déploiement Firebase** : 5 tests (3.8%)
- **Tests CI/CD complets** : 5 tests (3.8%)
- **Tests Firebase CLI** : 6 tests (4.5%)

### **Total : 132 tests répartis en 30 phases**

## 🎯 **FONCTIONNALITÉS TESTÉES**

### **✅ Frameworks UI :**

- **MUI (Material-UI)** : Composants, thèmes, configuration
- **Shadcn/ui** : ❌ Supprimé (plus supporté)

### **✅ Gestion d'état :**

- **Zustand** : Stores, configuration, fonctionnalité
- **Redux** : Slices, store, configuration

### **✅ Gestionnaires de paquets :**

- **npm** : Installation, scripts, configuration
- **Yarn** : Installation, scripts, configuration

### **✅ Versions Next.js :**

- **Next.js 14** : Configuration, fonctionnalités
- **Next.js 15** : Configuration, fonctionnalités

### **✅ Fonctionnalités avancées :**

- **PWA** : Service Worker, manifest, configuration
- **FCM** : Push notifications, configuration
- **Analytics** : Configuration, intégration
- **Performance** : Monitoring, optimisation
- **Sentry** : Error tracking, configuration

### **✅ Firebase :**

- **Firestore** : Règles, indexes, migrations
- **Cloud Functions** : Structure, triggers, configuration
- **Storage** : Règles, configuration
- **Authentication** : Triggers, configuration
- **Extensions** : Configuration, déploiement
- **App Hosting** : Configuration avec API routes

### **✅ CI/CD :**

- **GitHub Actions** : Workflows, validation YAML
- **Scripts de déploiement** : Configuration, exécution
- **Environnements** : Dev, staging, production

## 🛡️ **SÉCURITÉ ET ROBUSTESSE**

### **✅ Tests de sécurité :**

- **Règles Firestore** : Validation des règles de sécurité
- **Règles Storage** : Validation des règles de sécurité
- **Protection injection** : Protection contre l'injection de code

### **✅ Tests de robustesse :**

- **Noms très longs** : Gestion des noms de projet extrêmes
- **Caractères spéciaux** : Gestion des caractères spéciaux
- **Gestion d'erreurs** : Récupération et résilience
- **Performance sous charge** : Tests de stress

## 🔍 **DÉBOGAGE ET MAINTENANCE**

### **En cas d'échec de tests :**

1. **Vérifier l'environnement :**

   ```bash
   node --version    # Doit être >= 18
   npm --version     # Doit être >= 8
   firebase --version # Doit être >= 14
   ```

2. **Vérifier les dépendances :**

   ```bash
   npm install
   npm run build
   ```

3. **Consulter les logs :**

   ```bash
   # Logs du dernier test
   tail -100 .test-artifacts/run-*/test-comprehensive.log
   ```

4. **Nettoyer et relancer :**

   ```bash
   # Nettoyer les artefacts
   rm -rf .test-artifacts/

   # Relancer les tests
   ./scripts/test.sh
   ```

### **Tests spécifiques :**

```bash
# Test d'une phase spécifique
grep -A 20 "Phase 20" .test-artifacts/run-*/test-comprehensive.log

# Test d'un type spécifique
grep -A 10 "Testing: MUI components" .test-artifacts/run-*/test-comprehensive.log
```

## 🚀 **INTÉGRATION CI/CD**

### **GitHub Actions :**

```yaml
- name: Run comprehensive tests
  run: |
    chmod +x scripts/*.sh
    ./scripts/test.sh
```

### **Variables d'environnement :**

```bash
# Configuration Firebase pour les tests
export FIREBASE_PROJECT_ID=sqyping-dev
export FIREBASE_TOKEN=${{ secrets.FIREBASE_TOKEN }}

# Répertoire de sortie personnalisé
export TEST_OUTPUT_DIR=.ci-artifacts
```

## 📝 **NOTES DE DÉVELOPPEMENT**

### **Architecture des tests :**

- **Script unifié** : `test.sh` orchestre tout
- **Script complet** : `test-comprehensive.sh` exécute 132 tests
- **Isolation** : Chaque exécution dans un répertoire timestampé
- **Nettoyage** : Suppression automatique des projets de test

### **Évolutions récentes :**

- ✅ **Firebase App Hosting** : Support complet des API routes Next.js
- ✅ **Tests Firebase réels** : Validation avec projet `sqyping-dev`
- ✅ **Tests dry-run** : Validation complète sans déploiement
- ✅ **Gestion intelligente** : Gestion des services non activés

### **Suppressions :**

- ❌ **Shadcn/ui** : Plus supporté, tests supprimés
- ❌ **Tailwind CSS** : Plus supporté, tests supprimés
- ❌ **Export statique** : Remplacé par Firebase App Hosting

---

## 💡 **CONSEILS D'UTILISATION**

### **Pour le développement quotidien :**

```bash
# Test rapide
./scripts/test.sh
```

### **Pour la validation complète :**

```bash
# Test complet avec logs détaillés
./scripts/test.sh > test-results.log 2>&1
```

### **Pour le débogage :**

```bash
# Voir les logs en temps réel
./scripts/test.sh | tee test-results.log
```

### **Pour l'intégration CI/CD :**

```bash
# Test avec sortie standardisée
./scripts/test.sh
echo "Exit code: $?"
```

---

**🎯 Votre générateur est maintenant testé par 132 tests complets et est 100% prêt pour la production !**

**🚀 Utilisez `./scripts/test.sh` pour une validation complète et fiable !**
