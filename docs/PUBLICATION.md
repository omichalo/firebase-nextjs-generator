# 📤 Guide de Publication - Firebase Next.js Generator

## 🚀 Publication Automatique sur npm

Ce guide explique comment configurer la publication automatique sur npm via GitHub Actions.

## 🔐 Configuration des Secrets GitHub

### **1. Créer un token npm**

#### **Option A: Via CLI npm**

```bash
# Se connecter à npm
npm login

# Créer un token de publication
npm token create
```

#### **Option B: Via npmjs.com**

1. Aller sur [npmjs.com](https://www.npmjs.com)
2. Se connecter à votre compte
3. **Profile** → **Access Tokens**
4. **Generate New Token** → **Automation**
5. Copier le token généré

### **2. Ajouter le secret sur GitHub**

1. Aller sur votre repository GitHub
2. **Settings** → **Secrets and variables** → **Actions**
3. **New repository secret**
4. **Name** : `NPM_TOKEN`
5. **Value** : Votre token npm
6. **Add secret**

## 🔧 Configuration du Workflow

### **Structure du workflow :**

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  release:
    types: [published]

jobs:
  test: # Tests automatiques
  integration-test: # Tests d'intégration
  release: # Publication npm + GitHub release
```

### **Déclenchement de la publication :**

La publication se déclenche **UNIQUEMENT** lors de la création d'une **release GitHub** :

```yaml
release:
  if: github.event_name == 'release' && github.event.action == 'published'
```

## 📦 Processus de Publication

### **1. Tests automatiques (chaque push/PR)**

- ✅ Lint du code
- ✅ Vérification TypeScript
- ✅ Tests unitaires
- ✅ Build du projet
- ✅ Tests d'intégration
- ✅ Upload coverage

### **2. Publication (sur release GitHub)**

- ✅ Build final
- ✅ Vérification taille package
- ✅ Publication sur npm
- ✅ Création release GitHub

## 🎯 Comment Publier une Nouvelle Version

### **Option 1: Script automatisé (recommandé)**

```bash
# Depuis le répertoire du projet
./scripts/publish.sh patch    # 0.1.0 → 0.1.1
./scripts/publish.sh minor    # 0.1.0 → 0.2.0
./scripts/publish.sh major    # 0.1.0 → 1.0.0
```

### **Option 2: Manuel via GitHub**

1. **Créer un tag** : `git tag v0.1.1`
2. **Pousser le tag** : `git push origin v0.1.1`
3. **Créer une release** sur GitHub
4. **Le workflow se déclenche automatiquement**

### **Option 3: Publication manuelle**

```bash
# Se connecter à npm
npm login

# Publier
npm publish
```

## 🔍 Vérification de la Publication

### **1. Vérifier npm**

```bash
# Vérifier la version publiée
npm view firebase-nextjs-generator version

# Vérifier les détails
npm view firebase-nextjs-generator
```

### **2. Vérifier GitHub**

- **Releases** : Nouvelle release créée automatiquement
- **Actions** : Workflow `release` exécuté avec succès
- **Tags** : Tag de version créé

## 🚨 Dépannage

### **Erreur: "NPM_TOKEN not found"**

- Vérifier que le secret `NPM_TOKEN` est configuré sur GitHub
- Vérifier que le nom du secret est exactement `NPM_TOKEN`

### **Erreur: "npm publish failed"**

- Vérifier que le token npm a les bonnes permissions
- Vérifier que vous êtes connecté au bon compte npm
- Vérifier que le nom du package est disponible

### **Workflow ne se déclenche pas**

- Vérifier que la release GitHub est bien créée
- Vérifier que le tag correspond à la release
- Vérifier les permissions du repository

## 📋 Checklist de Publication

### **Avant la publication :**

- [ ] Tous les tests passent
- [ ] Build réussi
- [ ] Version mise à jour dans `package.json`
- [ ] Changelog mis à jour
- [ ] Secrets GitHub configurés

### **Après la publication :**

- [ ] Package visible sur npm
- [ ] Release GitHub créée
- [ ] Workflow Actions réussi
- [ ] Installation testée : `npm install -g firebase-nextjs-generator`

## 🔗 Liens Utiles

- [npm Access Tokens](https://docs.npmjs.com/creating-and-viewing-access-tokens)
- [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [GitHub Actions](https://docs.github.com/en/actions)
- [npm Publishing](https://docs.npmjs.com/publishing-packages)

---

**🎯 Votre générateur est maintenant prêt pour la publication automatique !**
