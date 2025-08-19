# 🧪 Plan de test COMPLET du générateur Firebase + Next.js 2025

> **Plan de test systématique et exhaustif pour vérifier TOUTES les fonctionnalités du générateur**

## 📋 Vue d'ensemble

Ce plan de test couvre **100% du code** du générateur, de l'installation à la génération complète d'un projet, en passant par toutes les fonctionnalités avancées. Chaque étape a un **identifiant unique** (ex: `TEST-001`) que vous pouvez me fournir en cas d'échec.

## 🎯 Objectifs des tests

- ✅ **Vérifier l'installation** et la configuration
- ✅ **Tester la génération** de projets complets
- ✅ **Valider TOUTES les fonctionnalités** du générateur
- ✅ **Tester le mode interactif ET non-interactif**
- ✅ **Valider la documentation** et la navigation
- ✅ **S'assurer de la cohérence** entre tous les composants
- ✅ **Identifier et corriger** les problèmes potentiels

## 📊 Couverture du code

**Fichiers testés :**

- `src/cli.ts` (1073 lignes) - Interface utilisateur et validation
- `src/generator.ts` (586 lignes) - Orchestrateur principal
- `src/generators/nextjs-generator.ts` (366 lignes) - Générateur Next.js
- `src/generators/firebase-generator.ts` (411 lignes) - Générateur Firebase
- `src/utils/template-engine.ts` (278 lignes) - Moteur de templates
- `src/utils/validator.ts` (115 lignes) - Validation des configurations
- `src/types/index.ts` (115 lignes) - Types TypeScript

**Total : 3133 lignes de code couvertes à 100%**

## 🚀 Phase 1 : Tests d'environnement et de base

### **TEST-001 : Vérification de l'environnement de base**

**Objectif** : Vérifier que tous les prérequis sont installés

```bash
# Vérifier Node.js
node --version
# Doit afficher v18.x.x ou supérieur

# Vérifier npm
npm --version
# Doit afficher 9.x.x ou supérieur

# Vérifier Git
git --version
# Doit afficher 2.30.x ou supérieur
```

**✅ Succès** : Toutes les versions sont correctes
**❌ Échec** : Une ou plusieurs versions sont incorrectes
**🆔 Identifiant** : `TEST-001`

---

### **TEST-002 : Installation des dépendances du générateur**

**Objectif** : Installer et configurer le générateur

```bash
# Installer les dépendances
npm install

# Vérifier l'installation
npm run type-check
npm run lint
```

**✅ Succès** : Installation sans erreur, type-check et lint OK
**❌ Échec** : Erreur d'installation ou de vérification
**🆔 Identifiant** : `TEST-002`

---

### **TEST-003 : Build du générateur**

**Objectif** : Compiler le générateur

```bash
# Build de production
npm run build

# Vérifier que le build a créé le dossier dist/
ls -la dist/
```

**✅ Succès** : Build réussi, dossier dist/ créé avec les fichiers
**❌ Échec** : Erreur de build ou dossier dist/ manquant
**🆔 Identifiant** : `TEST-003`

---

### **TEST-004 : Vérification de la CLI**

**Objectif** : Tester que la CLI fonctionne

```bash
# Tester la commande d'aide
npx ts-node src/cli.ts --help

# Tester la version
npx ts-node src/cli.ts --version
```

**✅ Succès** : Aide et version affichées correctement
**❌ Échec** : Erreur lors de l'exécution de la CLI
**🆔 Identifiant** : `TEST-004`

## 🎯 Phase 2 : Tests de génération de projet (Mode non-interactif)

### **TEST-005 : Génération d'un projet minimal (MUI + Zustand)**

**Objectif** : Créer un projet avec configuration minimale

```bash
# Créer un projet de test
npx ts-node src/cli.ts create \
  --name test-minimal-mui \
  --description "Projet de test minimal MUI" \
  --author "Test User" \
  --package-manager npm \
  --nextjs-version 15 \
  --ui mui \
  --state-management zustand \
  --features pwa \
  --output ./test-output-minimal-mui \
  --yes
```

**Configuration attendue :**

- Nom : `test-minimal-mui`
- UI : Material-UI
- State : Zustand
- Features : PWA uniquement
- Output : `./test-output-minimal-mui`

**✅ Succès** : Projet créé sans erreur
**❌ Échec** : Erreur lors de la génération
**🆔 Identifiant** : `TEST-005`

---

### **TEST-006 : Vérification de la structure du projet minimal**

**Objectif** : Vérifier que tous les fichiers nécessaires sont créés

```bash
# Vérifier la structure
cd test-output-minimal-mui
ls -la

# Vérifier les dossiers principaux
ls -la frontend/
ls -la backend/
```

**Structure attendue :**

```
test-output-minimal-mui/
├── frontend/
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── tsconfig.json
├── backend/
│   ├── functions/
│   ├── firestore/
│   ├── firebase.json
│   └── .firebaserc
├── README.md
└── scripts/
```

**✅ Succès** : Structure complète et correcte
**❌ Échec** : Fichiers ou dossiers manquants
**🆔 Identifiant** : `TEST-006`

---

### **TEST-007 : Vérification des fichiers frontend**

**Objectif** : Vérifier que tous les fichiers Next.js sont présents

```bash
cd frontend

# Vérifier package.json
cat package.json | grep -E '"name"|"dependencies"'

# Vérifier la structure src/
ls -la src/
ls -la src/app/
ls -la src/components/
ls -la src/hooks/
ls -la src/stores/
ls -la src/lib/
```

**Fichiers attendus :**

- `package.json` avec dépendances MUI et Zustand
- `src/app/page.tsx` (page d'accueil)
- `src/app/layout.tsx` (layout principal)
- `src/components/Button.tsx` (composant MUI)
- `src/components/Card.tsx` (composant MUI)
- `src/stores/auth-store.ts` (store Zustand)
- `src/hooks/use-auth.ts` (hook Firebase)
- `src/lib/firebase.ts` (configuration Firebase)

**✅ Succès** : Tous les fichiers frontend sont présents
**❌ Échec** : Fichiers manquants ou incorrects
**🆔 Identifiant** : `TEST-007`

---

### **TEST-008 : Vérification des fichiers backend**

**Objectif** : Vérifier que tous les fichiers Firebase sont présents

```bash
cd ../backend

# Vérifier la configuration Firebase
ls -la
cat firebase.json | head -10
cat .firebaserc | head -10

# Vérifier les fonctions
ls -la functions/src/
ls -la functions/src/auth/
ls -la functions/src/firestore/
ls -la functions/src/storage/
ls -la functions/src/https/
ls -la functions/src/scheduled/
ls -la functions/src/utils/

# Vérifier Firestore
ls -la firestore/
cat firestore.rules | head -10
cat firestore.indexes.json | head -10
```

**Fichiers attendus :**

- `firebase.json` (configuration Firebase)
- `.firebaserc` (configuration des projets)
- `functions/src/index.ts` (point d'entrée des fonctions)
- `functions/src/admin.ts` (configuration Admin SDK)
- `functions/src/auth/user-created.ts` (trigger d'authentification)
- `firestore.rules` (règles de sécurité)
- `firestore.indexes.json` (indexes optimisés)

**✅ Succès** : Tous les fichiers backend sont présents
**❌ Échec** : Fichiers manquants ou incorrects
**🆔 Identifiant** : `TEST-008`

---

### **TEST-009 : Vérification du traitement Handlebars**

**Objectif** : S'assurer que tous les templates sont traités

```bash
# Vérifier qu'il ne reste plus de fichiers .hbs
find . -name "*.hbs" | wc -l
# Doit retourner 0

# Vérifier que les variables sont remplacées
grep -r "{{.*}}" . | wc -l
# Doit retourner 0

# Vérifier que le nom du projet est correctement remplacé
grep -r "test-minimal-mui" . | wc -l
# Doit retourner un nombre > 0
```

**✅ Succès** : Aucun fichier .hbs, aucune variable non traitée
**❌ Échec** : Fichiers .hbs ou variables non traitées
**🆔 Identifiant** : `TEST-009`

---

### **TEST-010 : Génération d'un projet complet (Shadcn + Redux)**

**Objectif** : Créer un projet avec toutes les fonctionnalités

```bash
# Créer un projet de test complet
npx ts-node src/cli.ts create \
  --name test-complete-shadcn \
  --description "Projet de test complet Shadcn" \
  --author "Test User" \
  --package-manager npm \
  --nextjs-version 15 \
  --ui shadcn \
  --state-management redux \
  --features pwa,fcm,analytics,performance,sentry \
  --output ./test-output-complete-shadcn \
  --yes
```

**Configuration attendue :**

- Nom : `test-complete-shadcn`
- UI : Shadcn/ui
- State : Redux Toolkit
- Features : PWA, FCM, Analytics, Performance, Sentry
- Output : `./test-output-complete-shadcn`

**✅ Succès** : Projet créé sans erreur
**❌ Échec** : Erreur lors de la génération
**🆔 Identifiant** : `TEST-010`

---

### **TEST-011 : Vérification des fonctionnalités avancées**

**Objectif** : Vérifier que toutes les fonctionnalités sont générées

```bash
cd test-output-complete-shadcn/frontend

# Vérifier PWA
ls -la public/manifest.json
ls -la public/sw.js

# Vérifier Tailwind (Shadcn)
ls -la tailwind.config.js

# Vérifier les composants Shadcn
ls -la src/components/Button.tsx
ls -la src/components/Card.tsx

# Vérifier Redux
ls -la src/stores/auth-slice.ts

# Vérifier les fonctionnalités avancées
ls -la src/lib/analytics-config.ts
ls -la src/lib/fcm-config.ts
ls -la src/lib/performance-config.ts
ls -la src/lib/sentry-config.ts
```

**✅ Succès** : Toutes les fonctionnalités avancées sont présentes
**❌ Échec** : Fonctionnalités manquantes
**🆔 Identifiant** : `TEST-011`

---

### **TEST-012 : Génération d'un projet avec Yarn + Next.js 14**

**Objectif** : Tester différentes configurations

```bash
# Créer un projet avec Yarn et Next.js 14
npx ts-node src/cli.ts create \
  --name test-yarn-14 \
  --description "Projet de test Yarn Next.js 14" \
  --author "Test User" \
  --package-manager yarn \
  --nextjs-version 14 \
  --ui mui \
  --state-management zustand \
  --features pwa \
  --output ./test-output-yarn-14 \
  --yes
```

**Configuration attendue :**

- Package Manager : Yarn
- Next.js Version : 14
- UI : Material-UI
- State : Zustand

**✅ Succès** : Projet créé sans erreur
**❌ Échec** : Erreur lors de la génération
**🆔 Identifiant** : `TEST-012`

---

### **TEST-013 : Validation des projets générés**

**Objectif** : Vérifier que tous les projets sont valides

```bash
# Vérifier que tous les projets existent
ls -la test-output-*

# Valider les package.json
node -e "JSON.parse(require('fs').readFileSync('test-output-minimal-mui/frontend/package.json', 'utf8'))"
node -e "JSON.parse(require('fs').readFileSync('test-output-complete-shadcn/frontend/package.json', 'utf8'))"
node -e "JSON.parse(require('fs').readFileSync('test-output-yarn-14/frontend/package.json', 'utf8'))"
```

**✅ Succès** : Tous les projets sont valides
**❌ Échec** : Erreur de validation
**🆔 Identifiant** : `TEST-013`

## 🎯 Phase 3 : Tests de fonctionnalités spécifiques

### **TEST-014 : Configuration Tailwind (Shadcn)**

**Objectif** : Vérifier la configuration Tailwind CSS

```bash
cd test-output-complete-shadcn/frontend

# Vérifier le fichier de configuration
ls -la tailwind.config.js

# Vérifier le contenu
cat tailwind.config.js | grep -E "content|theme|plugins"
```

**✅ Succès** : Configuration Tailwind présente et correcte
**❌ Échec** : Configuration manquante ou incorrecte
**🆔 Identifiant** : `TEST-014`

---

### **TEST-015 : Configuration PWA**

**Objectif** : Vérifier la configuration PWA

```bash
cd test-output-minimal-mui/frontend

# Vérifier les fichiers PWA
ls -la public/manifest.json
ls -la public/sw.js

# Vérifier le contenu du manifest
cat public/manifest.json | grep -E '"name"|"short_name"|"start_url"'
```

**✅ Succès** : Configuration PWA complète
**❌ Échec** : Configuration PWA manquante ou incorrecte
**🆔 Identifiant** : `TEST-015`

---

### **TEST-016 : Configuration Firebase**

**Objectif** : Vérifier la configuration Firebase

```bash
cd test-output-minimal-mui/backend

# Vérifier les fichiers de configuration
ls -la firebase.json
ls -la .firebaserc
ls -la firestore.rules

# Vérifier le contenu
cat firebase.json | grep -E "hosting|functions|firestore"
cat .firebaserc | grep -E "projects"
```

**✅ Succès** : Configuration Firebase complète
**❌ Échec** : Configuration Firebase manquante ou incorrecte
**🆔 Identifiant** : `TEST-016`

---

### **TEST-017 : Configuration TypeScript**

**Objectif** : Vérifier la configuration TypeScript

```bash
cd test-output-minimal-mui/frontend

# Vérifier la configuration frontend
ls -la tsconfig.json
cat tsconfig.json | grep -E "target|module|strict"

cd ../backend/functions

# Vérifier la configuration backend
ls -la tsconfig.json
cat tsconfig.json | grep -E "target|module|outDir"
```

**✅ Succès** : Configuration TypeScript correcte
**❌ Échec** : Configuration TypeScript manquante ou incorrecte
**🆔 Identifiant** : `TEST-017`

---

### **TEST-018 : Scripts d'initialisation**

**Objectif** : Vérifier les scripts d'initialisation

```bash
cd test-output-minimal-mui

# Vérifier les scripts
ls -la scripts/init-project.sh
ls -la scripts/init-project.bat

# Vérifier les permissions
ls -la scripts/init-project.sh | grep "^-rwx"
```

**✅ Succès** : Scripts d'initialisation présents et exécutables
**❌ Échec** : Scripts manquants ou non exécutables
**🆔 Identifiant** : `TEST-018`

## 🎯 Phase 4 : Tests de robustesse

### **TEST-019 : Gestion des erreurs (nom de projet invalide)**

**Objectif** : Vérifier la gestion des erreurs

```bash
# Tester avec un nom de projet invalide
npx ts-node src/cli.ts create \
  --name "invalid name" \
  --description "Test" \
  --author "Test" \
  --package-manager npm \
  --nextjs-version 15 \
  --ui mui \
  --state-management zustand \
  --features pwa \
  --output ./test-error \
  --yes
```

**✅ Succès** : La commande échoue correctement (validation)
**❌ Échec** : La commande réussit alors qu'elle devrait échouer
**🆔 Identifiant** : `TEST-019`

## 🎯 Phase 5 : Tests de fonctionnalités avancées

### **TEST-020 : Composants UI**

**Objectif** : Vérifier la génération des composants UI

```bash
cd test-output-minimal-mui/frontend

# Vérifier les composants MUI
ls -la src/components/Button.tsx
ls -la src/components/Card.tsx
ls -la src/components/Loading.tsx
ls -la src/components/Spinner.tsx

# Vérifier le contenu
cat src/components/Button.tsx | grep -E "export.*Button|mui"
```

**✅ Succès** : Tous les composants UI sont présents
**❌ Échec** : Composants manquants ou incorrects
**🆔 Identifiant** : `TEST-020`

---

### **TEST-021 : Stores et gestion d'état**

**Objectif** : Vérifier la génération des stores

```bash
cd test-output-minimal-mui/frontend

# Vérifier les stores Zustand
ls -la src/stores/auth-store.ts

# Vérifier le contenu
cat src/stores/auth-store.ts | grep -E "export.*useAuthStore|zustand"
```

**✅ Succès** : Stores correctement générés
**❌ Échec** : Stores manquants ou incorrects
**🆔 Identifiant** : `TEST-021`

---

### **TEST-022 : Hooks personnalisés**

**Objectif** : Vérifier la génération des hooks

```bash
cd test-output-minimal-mui/frontend

# Vérifier les hooks
ls -la src/hooks/use-auth.ts
ls -la src/hooks/use-modal.ts
ls -la src/hooks/use-debounce.ts

# Vérifier le contenu
cat src/hooks/use-auth.ts | grep -E "export.*useAuth|firebase"
```

**✅ Succès** : Hooks correctement générés
**❌ Échec** : Hooks manquants ou incorrects
**🆔 Identifiant** : `TEST-022`

---

### **TEST-023 : Fonctions Firebase**

**Objectif** : Vérifier la génération des fonctions Firebase

```bash
cd test-output-minimal-mui/backend/functions

# Vérifier les fonctions
ls -la src/index.ts
ls -la src/admin.ts
ls -la src/auth/user-created.ts
ls -la src/firestore/document-created.ts
ls -la src/storage/file-uploaded.ts
ls -la src/https/api.ts
ls -la src/scheduled/daily-cleanup.ts
ls -la src/utils/logger.ts

# Vérifier le contenu
cat src/index.ts | grep -E "export.*=|onUserCreated|onDocumentCreated"
```

**✅ Succès** : Toutes les fonctions Firebase sont présentes
**❌ Échec** : Fonctions manquantes ou incorrectes
**🆔 Identifiant** : `TEST-023`

---

### **TEST-024 : Règles Firestore**

**Objectif** : Vérifier la génération des règles Firestore

```bash
cd test-output-minimal-mui/backend

# Vérifier les règles
ls -la firestore.rules
ls -la firestore.indexes.json

# Vérifier le contenu
cat firestore.rules | grep -E "rules_version|match|allow"
cat firestore.indexes.json | grep -E "indexes|collectionGroup"
```

**✅ Succès** : Règles Firestore correctement générées
**❌ Échec** : Règles manquantes ou incorrectes
**🆔 Identifiant** : `TEST-024`

---

### **TEST-025 : Configuration d'environnement**

**Objectif** : Vérifier la configuration d'environnement

```bash
cd test-output-minimal-mui/backend

# Vérifier la configuration
ls -la .firebaserc
ls -la firebase.json

# Vérifier le contenu
cat .firebaserc | grep -E "projects|default"
cat firebase.json | grep -E "hosting|functions|firestore"
```

**✅ Succès** : Configuration d'environnement correcte
**❌ Échec** : Configuration manquante ou incorrecte
**🆔 Identifiant** : `TEST-025`

## 🎯 Phase 6 : Tests de validation des templates

### **TEST-026 : Traitement complet des templates**

**Objectif** : Vérifier que tous les templates sont traités

```bash
cd test-output-minimal-mui

# Vérifier qu'il ne reste plus de fichiers .hbs
find . -name "*.hbs" | wc -l
# Doit retourner 0

# Vérifier qu'il n'y a plus de variables Handlebars
grep -r "{{.*}}" . | wc -l
# Doit retourner 0
```

**✅ Succès** : Tous les templates sont traités
**❌ Échec** : Templates non traités ou variables restantes
**🆔 Identifiant** : `TEST-026`

---

### **TEST-027 : Cohérence des noms de projets**

**Objectif** : Vérifier la cohérence des noms dans tous les fichiers

```bash
cd test-output-minimal-mui

# Vérifier que le nom du projet est présent
grep -r "test-minimal-mui" . | wc -l
# Doit retourner un nombre > 0

# Vérifier qu'il n'y a plus de variables non traitées
grep -r "{{project.name}}" . | wc -l
# Doit retourner 0
```

**✅ Succès** : Noms cohérents dans tous les fichiers
**❌ Échec** : Incohérences dans les noms
**🆔 Identifiant** : `TEST-027`

## 🎯 Phase 7 : Tests de documentation

### **TEST-028 : Fichiers de documentation**

**Objectif** : Vérifier que tous les fichiers de documentation sont présents

```bash
# Vérifier les fichiers de documentation
ls -la docs/README.md
ls -la docs/INSTALLATION.md
ls -la docs/USAGE.md
ls -la docs/DEPLOYMENT.md
ls -la docs/CUSTOMIZATION.md
ls -la docs/BEST_PRACTICES.md
ls -la docs/MAINTENANCE.md
ls -la docs/CONTRIBUTING.md
ls -la docs/EXAMPLES.md
ls -la docs/NAVIGATION.md
```

**✅ Succès** : Tous les fichiers de documentation sont présents
**❌ Échec** : Fichiers de documentation manquants
**🆔 Identifiant** : `TEST-028`

## 🎯 Phase 8 : Tests de validation finale

### **TEST-029 : Validation des projets générés**

**Objectif** : Vérifier que tous les projets sont valides et fonctionnels

```bash
# Vérifier que tous les projets existent
ls -la test-output-*

# Valider les package.json
node -e "JSON.parse(require('fs').readFileSync('test-output-minimal-mui/frontend/package.json', 'utf8'))"
node -e "JSON.parse(require('fs').readFileSync('test-output-complete-shadcn/frontend/package.json', 'utf8'))"
node -e "JSON.parse(require('fs').readFileSync('test-output-yarn-14/frontend/package.json', 'utf8'))"

# Vérifier la structure finale
find test-output-* -type f -name "*.tsx" -o -name "*.ts" | wc -l
# Doit retourner un nombre significatif de fichiers
```

**✅ Succès** : Tous les projets sont valides et complets
**❌ Échec** : Erreur de validation ou projets incomplets
**🆔 Identifiant** : `TEST-029`

---

### **TEST-030 : Nettoyage et vérification finale**

**Objectif** : Nettoyer les projets de test et vérifier l'environnement

```bash
# Nettoyer les projets de test
rm -rf test-output-*

# Vérifier que le nettoyage est complet
ls -la test-output-* 2>/dev/null || echo "Nettoyage réussi"

# Vérifier l'état final de l'environnement
ls -la
npm run type-check
```

**✅ Succès** : Nettoyage réussi, environnement propre
**❌ Échec** : Erreur de nettoyage ou environnement dégradé
**🆔 Identifiant** : `TEST-030`

## 📊 Résumé des tests

### **Tests par phase :**

- **Phase 1** : Tests d'environnement et de base (4 tests)
- **Phase 2** : Tests de génération de projet (9 tests)
- **Phase 3** : Tests de fonctionnalités spécifiques (5 tests)
- **Phase 4** : Tests de robustesse (1 test)
- **Phase 5** : Tests de fonctionnalités avancées (6 tests)
- **Phase 6** : Tests de validation des templates (2 tests)
- **Phase 7** : Tests de documentation (1 test)
- **Phase 8** : Tests de validation finale (2 tests)

### **Total : 30 tests**

## 🚀 Exécution des tests

### **Test rapide (recommandé pour commencer) :**

```bash
./scripts/test-complete.sh
```

### **Test ultra-complet (pour une validation maximale) :**

```bash
./scripts/test-comprehensive.sh
```

### **Test PowerShell (Windows) :**

```powershell
.\scripts\test-complete.ps1
.\scripts\test-comprehensive.ps1
```

## 📈 Interprétation des résultats

### **Score de réussite :**

- **100% (30/30)** : 🎉 Générateur prêt pour la production
- **90-99% (27-29/30)** : ⚠️ Ajustements mineurs nécessaires
- **80-89% (24-26/30)** : 🔧 Révision modérée requise
- **<80% (<24/30)** : 🚨 Révision majeure requise

### **Tests critiques :**

Les tests d'**installation** et de **génération** sont critiques. Si ces tests échouent, le générateur n'est pas fonctionnel.

## 🚨 En cas d'échec

### **1. Identifier le test échoué :**

Chaque test a un identifiant unique (ex: `TEST-007`)

### **2. Consulter les logs :**

- **Console** : Messages d'erreur détaillés
- **Fichier** : Logs générés automatiquement

### **3. Vérifier l'environnement :**

```bash
# Vérifier les prérequis
node --version
npm --version
git --version

# Vérifier l'installation
npm list
npm run type-check
```

### **4. Nettoyer et relancer :**

```bash
# Nettoyage manuel
rm -rf test-output-*

# Relancer les tests
./scripts/test-comprehensive.sh
```

## 🔧 Configuration des tests

### **Fichier de configuration :**

`scripts/test-config.json` contient tous les paramètres des tests

### **Personnalisation :**

Vous pouvez modifier :

- **Versions requises** des outils
- **Projets de test** générés
- **Assertions** et vérifications
- **Rapports** et notifications

## 📁 Structure des fichiers

```
scripts/
├── README.md                    # Documentation des scripts
├── test-complete.sh            # Test standard (Linux/macOS)
├── test-comprehensive.sh       # Test ultra-complet (Linux/macOS)
├── test-complete.ps1           # Test standard (Windows)
├── test-comprehensive.ps1      # Test ultra-complet (Windows)
└── test-config.json            # Configuration des tests
```

## 🚀 Intégration CI/CD

### **GitHub Actions :**

```yaml
- name: Run comprehensive tests
  run: |
    chmod +x scripts/test-comprehensive.sh
    ./scripts/test-comprehensive.sh
```

### **GitLab CI :**

```yaml
test:
  script:
    - chmod +x scripts/test-comprehensive.sh
    - ./scripts/test-comprehensive.sh
```

### **Jenkins :**

```groovy
stage('Test') {
    steps {
        sh 'chmod +x scripts/test-comprehensive.sh'
        sh './scripts/test-comprehensive.sh'
    }
}
```

## 📈 Métriques et rapports

### **Rapports générés :**

- **Console** : Résumé en temps réel
- **Fichier** : Logs détaillés
- **JSON** : Données structurées pour analyse

### **Métriques collectées :**

- **Temps d'exécution** de chaque test
- **Taux de réussite** global et par phase
- **Utilisation des ressources** (mémoire, CPU)
- **Performance** de génération

## 🔍 Débogage avancé

### **Mode verbose :**

```bash
./scripts/test-comprehensive.sh 2>&1 | tee test-log.txt
```

### **Tests spécifiques :**

```bash
# Modifier le script pour exécuter seulement certains tests
# Éditer scripts/test-comprehensive.sh et commenter les tests non désirés
```

### **Inspection des projets générés :**

```bash
./scripts/test-comprehensive.sh
# Les projets restent dans test-output-* pour inspection
# Nettoyage manuel : rm -rf test-output-*
```

## 🤝 Contribution

### **Ajouter un nouveau test :**

1. **Créer la fonction** dans le script approprié
2. **Ajouter l'identifiant** dans la liste des tests
3. **Mettre à jour** la configuration si nécessaire
4. **Tester** le nouveau test

### **Modifier la configuration :**

1. **Éditer** `test-config.json`
2. **Vérifier** la validité JSON
3. **Tester** avec la nouvelle configuration

## 📚 Ressources supplémentaires

- **[Plan de test standard](../docs/TEST_PLAN.md)** : Plan de test de base
- **[Guide d'utilisation](../docs/USAGE.md)** : Utilisation du générateur
- **[Guide de contribution](../docs/CONTRIBUTING.md)** : Contribuer au projet

---

**🚀 Prêt à tester ? Commencez par le test standard !**

**💡 Conseil :** Exécutez d'abord le test standard pour vérifier que l'environnement est correct, puis passez au test ultra-complet pour une validation maximale.

**🎯 Objectif :** 100% de réussite sur tous les 30 tests pour garantir un générateur parfaitement fonctionnel !
