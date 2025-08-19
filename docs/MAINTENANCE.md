# 🔧 Guide de maintenance

> **Maintenez et évoluez votre Générateur Firebase + Next.js 2025**

## 📋 Table des matières

- [🔄 Mise à jour des dépendances](#-mise-à-jour-des-dépendances)
- [📦 Gestion des versions](#-gestion-des-versions)
- [🐛 Résolution des problèmes](#-résolution-des-problèmes)
- [📊 Monitoring et alertes](#-monitoring-et-alertes)
- [🔒 Sécurité](#-sécurité)
- [📈 Performance](#-performance)
- [📚 Documentation](#-documentation)

## 🔄 Mise à jour des dépendances

### 1. **Vérification des mises à jour**

#### **Script de vérification automatique**

```bash
#!/bin/bash
# scripts/check-updates.sh

echo "🔍 Vérification des mises à jour disponibles..."

# Vérifier les dépendances npm
echo "📦 Dépendances npm:"
npm outdated

# Vérifier les dépendances globales
echo "🌍 Dépendances globales:"
npm list -g --depth=0

# Vérifier Firebase CLI
echo "🔥 Firebase CLI:"
firebase --version
npm list -g firebase-tools

# Vérifier Node.js
echo "🟢 Node.js:"
node --version
npm --version

echo "✅ Vérification terminée!"
```

#### **Configuration des mises à jour automatiques**

```json
// .github/dependabot.yml
version: 2
updates:
  # Mises à jour npm
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
    open-pull-requests-limit: 10
    reviewers:
      - "your-username"
    assignees:
      - "your-username"
    commit-message:
      prefix: "chore"
      include: "scope"
    labels:
      - "dependencies"
      - "npm"

  # Mises à jour GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
    open-pull-requests-limit: 5
    reviewers:
      - "your-username"
    assignees:
      - "your-username"
    commit-message:
      prefix: "ci"
      include: "scope"
    labels:
      - "dependencies"
      - "github-actions"
```

### 2. **Processus de mise à jour**

#### **Étapes de mise à jour sécurisée**

```bash
#!/bin/bash
# scripts/update-dependencies.sh

set -e

echo "🚀 Mise à jour des dépendances..."

# 1. Sauvegarder l'état actuel
echo "📋 Sauvegarde de l'état actuel..."
git add .
git commit -m "chore: sauvegarde avant mise à jour des dépendances"

# 2. Vérifier les changements
echo "🔍 Vérification des changements..."
npm outdated

# 3. Mise à jour des dépendances
echo "📦 Mise à jour des dépendances..."
npm update

# 4. Mise à jour des dépendances de développement
echo "🔧 Mise à jour des dépendances de développement..."
npm update --dev

# 5. Vérifier la compatibilité
echo "✅ Vérification de la compatibilité..."
npm run build
npm run test

# 6. Commit des changements
echo "💾 Commit des changements..."
git add package*.json
git commit -m "chore: mise à jour des dépendances"

echo "✅ Mise à jour terminée avec succès!"
```

#### **Mise à jour des versions majeures**

```bash
#!/bin/bash
# scripts/update-major.sh

set -e

PACKAGE=$1
if [ -z "$PACKAGE" ]; then
    echo "Usage: ./update-major.sh <package-name>"
    exit 1
fi

echo "🚀 Mise à jour majeure de $PACKAGE..."

# 1. Vérifier la version actuelle
CURRENT_VERSION=$(npm list $PACKAGE --depth=0 | grep $PACKAGE | awk '{print $2}')
echo "📋 Version actuelle: $CURRENT_VERSION"

# 2. Installer la dernière version majeure
echo "📦 Installation de la dernière version majeure..."
npm install $PACKAGE@latest

# 3. Vérifier les changements breaking
echo "🔍 Vérification des changements breaking..."
npm run build
npm run test

# 4. Si tout va bien, commit
echo "💾 Commit des changements..."
git add package*.json
git commit -m "feat: mise à jour majeure de $PACKAGE"

echo "✅ Mise à jour majeure terminée!"
```

## 📦 Gestion des versions

### 1. **Stratégie de versioning**

#### **Semantic Versioning (SemVer)**

```bash
# Version format: MAJOR.MINOR.PATCH
# MAJOR: Changements incompatibles
# MINOR: Nouvelles fonctionnalités compatibles
# PATCH: Corrections de bugs compatibles

# Exemple de workflow de version
git flow release start 1.2.0
# Faire les changements nécessaires
git flow release finish 1.2.0
git tag -a v1.2.0 -m "Version 1.2.0"
git push origin v1.2.0
```

#### **Script de release automatique**

```bash
#!/bin/bash
# scripts/release.sh

set -e

VERSION=$1
if [ -z "$VERSION" ]; then
    echo "Usage: ./release.sh <version>"
    echo "Exemple: ./release.sh 1.2.0"
    exit 1
fi

echo "🚀 Release de la version $VERSION..."

# 1. Vérifier que tout est commité
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Des fichiers non commités existent"
    git status
    exit 1
fi

# 2. Vérifier que les tests passent
echo "🧪 Exécution des tests..."
npm run test

# 3. Build de production
echo "📦 Build de production..."
npm run build

# 4. Mise à jour de la version
echo "📝 Mise à jour de la version..."
npm version $VERSION --no-git-tag-version

# 5. Commit et tag
git add package*.json
git commit -m "chore: bump version to $VERSION"
git tag -a v$VERSION -m "Version $VERSION"

# 6. Push
git push origin main
git push origin v$VERSION

echo "✅ Release $VERSION terminée avec succès!"
```

### 2. **Changelog automatique**

#### **Configuration Conventional Changelog**

```json
// .versionrc
{
  "types": [
    { "type": "feat", "section": "✨ Nouvelles fonctionnalités" },
    { "type": "fix", "section": "🐛 Corrections de bugs" },
    { "type": "docs", "section": "📚 Documentation" },
    { "type": "style", "section": "🎨 Style et formatage" },
    { "type": "refactor", "section": "♻️ Refactoring" },
    { "type": "perf", "section": "⚡ Améliorations de performance" },
    { "type": "test", "section": "🧪 Tests" },
    { "type": "chore", "section": "🔧 Maintenance" }
  ]
}
```

#### **Script de génération du changelog**

```bash
#!/bin/bash
# scripts/generate-changelog.sh

set -e

echo "📝 Génération du changelog..."

# Installer conventional-changelog si nécessaire
if ! command -v conventional-changelog &> /dev/null; then
    echo "📦 Installation de conventional-changelog..."
    npm install -g conventional-changelog-cli
fi

# Générer le changelog
conventional-changelog -p angular -i CHANGELOG.md -s

echo "✅ Changelog généré avec succès!"
```

## 🐛 Résolution des problèmes

### 1. **Diagnostic des problèmes**

#### **Script de diagnostic complet**

```bash
#!/bin/bash
# scripts/diagnose.sh

echo "🔍 Diagnostic du système..."

# Informations système
echo "🖥️ Informations système:"
echo "OS: $(uname -s)"
echo "Architecture: $(uname -m)"
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"

# Espace disque
echo "💾 Espace disque:"
df -h

# Mémoire
echo "🧠 Mémoire:"
free -h 2>/dev/null || vm_stat

# Processus Node.js
echo "🟢 Processus Node.js:"
ps aux | grep node | grep -v grep

# Ports utilisés
echo "🔌 Ports utilisés:"
lsof -i :3000 -i :5000 -i :8080 2>/dev/null || echo "Ports non vérifiés"

# Logs d'erreur
echo "📋 Logs d'erreur récents:"
tail -n 20 logs/error.log 2>/dev/null || echo "Aucun fichier de log trouvé"

echo "✅ Diagnostic terminé!"
```

#### **Vérification de la santé du projet**

```bash
#!/bin/bash
# scripts/health-check.sh

set -e

echo "🏥 Vérification de la santé du projet..."

# 1. Vérifier les dépendances
echo "📦 Vérification des dépendances..."
npm audit
npm ls --depth=0

# 2. Vérifier la configuration
echo "⚙️ Vérification de la configuration..."
npm run type-check
npm run lint

# 3. Vérifier les tests
echo "🧪 Vérification des tests..."
npm run test

# 4. Vérifier le build
echo "📦 Vérification du build..."
npm run build

# 5. Vérifier Firebase
echo "🔥 Vérification Firebase..."
firebase projects:list
firebase use --json

echo "✅ Vérification de santé terminée!"
```

### 2. **Problèmes courants et solutions**

#### **Erreur de mémoire**

```bash
# Problème: JavaScript heap out of memory
# Solution: Augmenter la limite de mémoire

# Dans package.json
{
  "scripts": {
    "build": "NODE_OPTIONS='--max-old-space-size=4096' next build",
    "dev": "NODE_OPTIONS='--max-old-space-size=2048' next dev"
  }
}

# Ou dans .env
NODE_OPTIONS=--max-old-space-size=4096
```

#### **Problème de permissions Firebase**

```bash
# Problème: Permission denied sur Firebase
# Solution: Vérifier et corriger les permissions

# 1. Vérifier la connexion
firebase login --reauth

# 2. Vérifier les projets accessibles
firebase projects:list

# 3. Vérifier les permissions sur le projet
firebase projects:get <project-id>

# 4. Si nécessaire, demander l'accès à l'administrateur
```

#### **Problème de build TypeScript**

```bash
# Problème: Erreurs TypeScript lors du build
# Solution: Vérifier et corriger les types

# 1. Vérifier les types en mode strict
npm run type-check

# 2. Corriger les erreurs une par une
# 3. Si nécessaire, ajuster la configuration TypeScript

# tsconfig.json - Ajustements temporaires
{
  "compilerOptions": {
    "strict": false, // Temporairement désactiver
    "noImplicitAny": false,
    "skipLibCheck": true
  }
}
```

## 📊 Monitoring et alertes

### 1. **Configuration du monitoring**

#### **Script de monitoring automatique**

```bash
#!/bin/bash
# scripts/monitor.sh

set -e

echo "📊 Monitoring du projet..."

# Vérifier l'espace disque
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    echo "🚨 ALERTE: Espace disque critique: ${DISK_USAGE}%"
    # Envoyer une alerte
    curl -X POST "https://hooks.slack.com/services/YOUR_WEBHOOK" \
         -H "Content-type: application/json" \
         -d "{\"text\":\"🚨 Espace disque critique: ${DISK_USAGE}%\"}"
fi

# Vérifier la mémoire
MEMORY_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
if [ "$MEMORY_USAGE" -gt 80 ]; then
    echo "🚨 ALERTE: Utilisation mémoire élevée: ${MEMORY_USAGE}%"
fi

# Vérifier les processus Node.js
NODE_PROCESSES=$(ps aux | grep node | grep -v grep | wc -l)
if [ "$NODE_PROCESSES" -gt 10 ]; then
    echo "🚨 ALERTE: Trop de processus Node.js: $NODE_PROCESSES"
fi

echo "✅ Monitoring terminé!"
```

#### **Configuration des alertes Slack**

```typescript
// lib/alerts.ts
interface AlertConfig {
  webhookUrl: string;
  channel: string;
  username: string;
}

export class AlertManager {
  private config: AlertConfig;

  constructor(config: AlertConfig) {
    this.config = config;
  }

  async sendAlert(
    message: string,
    level: "info" | "warning" | "error" = "info"
  ) {
    const emoji = {
      info: "ℹ️",
      warning: "⚠️",
      error: "🚨",
    };

    const payload = {
      text: `${emoji[level]} ${message}`,
      channel: this.config.channel,
      username: this.config.username,
      icon_emoji: ":robot_face:",
    };

    try {
      await fetch(this.config.webhookUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
    } catch (error) {
      console.error("Erreur lors de l'envoi de l'alerte:", error);
    }
  }

  async sendDiskAlert(usage: number) {
    if (usage > 90) {
      await this.sendAlert(`Espace disque critique: ${usage}%`, "error");
    } else if (usage > 80) {
      await this.sendAlert(`Espace disque faible: ${usage}%`, "warning");
    }
  }

  async sendMemoryAlert(usage: number) {
    if (usage > 80) {
      await this.sendAlert(`Utilisation mémoire élevée: ${usage}%`, "warning");
    }
  }
}
```

### 2. **Métriques de performance**

#### **Collecte de métriques**

```typescript
// lib/metrics.ts
interface PerformanceMetrics {
  buildTime: number;
  bundleSize: number;
  testCoverage: number;
  lighthouseScore: number;
}

export class MetricsCollector {
  private metrics: PerformanceMetrics[] = [];

  async collectBuildMetrics(): Promise<void> {
    const startTime = Date.now();

    try {
      // Build du projet
      await this.runBuild();

      const buildTime = Date.now() - startTime;
      const bundleSize = await this.getBundleSize();

      this.metrics.push({
        buildTime,
        bundleSize,
        testCoverage: await this.getTestCoverage(),
        lighthouseScore: await this.getLighthouseScore(),
      });

      // Sauvegarder les métriques
      await this.saveMetrics();
    } catch (error) {
      console.error("Erreur lors de la collecte des métriques:", error);
    }
  }

  private async runBuild(): Promise<void> {
    // Logique de build
  }

  private async getBundleSize(): Promise<number> {
    // Analyse de la taille du bundle
    return 0;
  }

  private async getTestCoverage(): Promise<number> {
    // Récupération de la couverture de tests
    return 0;
  }

  private async getLighthouseScore(): Promise<number> {
    // Score Lighthouse
    return 0;
  }

  private async saveMetrics(): Promise<void> {
    // Sauvegarde des métriques
  }

  getMetrics(): PerformanceMetrics[] {
    return this.metrics;
  }

  getAverageBuildTime(): number {
    if (this.metrics.length === 0) return 0;
    const total = this.metrics.reduce((sum, m) => sum + m.buildTime, 0);
    return total / this.metrics.length;
  }
}
```

## 🔒 Sécurité

### 1. **Audit de sécurité**

#### **Script d'audit automatique**

```bash
#!/bin/bash
# scripts/security-audit.sh

set -e

echo "🔒 Audit de sécurité..."

# 1. Audit npm
echo "📦 Audit des dépendances npm..."
npm audit --audit-level=moderate

# 2. Vérifier les secrets exposés
echo "🔐 Vérification des secrets..."
if grep -r "API_KEY\|SECRET\|PASSWORD" . --exclude-dir=node_modules --exclude-dir=.git; then
    echo "⚠️ ATTENTION: Secrets potentiellement exposés détectés!"
fi

# 3. Vérifier les permissions des fichiers
echo "📁 Vérification des permissions..."
find . -type f -name "*.sh" -exec ls -la {} \;

# 4. Vérifier les variables d'environnement
echo "🌍 Vérification des variables d'environnement..."
if [ -f .env ]; then
    echo "⚠️ Fichier .env détecté - vérifier qu'il n'est pas commité"
fi

echo "✅ Audit de sécurité terminé!"
```

#### **Configuration des secrets**

```bash
# .env.example (template pour les variables d'environnement)
NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key_here
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_project.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
NEXT_PUBLIC_FIREBASE_APP_ID=your_app_id

# Variables sensibles (non publiques)
FIREBASE_SERVICE_ACCOUNT_KEY=your_service_account_key
SENTRY_DSN=your_sentry_dsn
STRIPE_SECRET_KEY=your_stripe_secret_key
```

### 2. **Mise à jour de sécurité**

#### **Script de mise à jour de sécurité**

```bash
#!/bin/bash
# scripts/security-update.sh

set -e

echo "🔒 Mise à jour de sécurité..."

# 1. Vérifier les vulnérabilités critiques
echo "🚨 Vérification des vulnérabilités critiques..."
npm audit --audit-level=high

# 2. Mise à jour des dépendances avec vulnérabilités
echo "📦 Mise à jour des dépendances vulnérables..."
npm audit fix

# 3. Mise à jour forcée si nécessaire
echo "🔧 Mise à jour forcée si nécessaire..."
npm audit fix --force

# 4. Vérifier que les vulnérabilités sont résolues
echo "✅ Vérification finale..."
npm audit

echo "✅ Mise à jour de sécurité terminée!"
```

## 📈 Performance

### 1. **Optimisation continue**

#### **Script d'analyse de performance**

```bash
#!/bin/bash
# scripts/performance-analysis.sh

set -e

echo "📈 Analyse de performance..."

# 1. Build et mesure du temps
echo "⏱️ Mesure du temps de build..."
START_TIME=$(date +%s)
npm run build
END_TIME=$(date +%s)
BUILD_TIME=$((END_TIME - START_TIME))

echo "📦 Temps de build: ${BUILD_TIME} secondes"

# 2. Analyse de la taille du bundle
echo "📊 Analyse de la taille du bundle..."
npm run analyze

# 3. Tests de performance
echo "🧪 Tests de performance..."
npm run test:performance

# 4. Lighthouse CI
echo "🏗️ Analyse Lighthouse..."
npm run lighthouse

echo "✅ Analyse de performance terminée!"
```

#### **Configuration Lighthouse CI**

```yaml
# .lighthouserc.js
module.exports = {
  ci: {
    collect: {
      url: ['http://localhost:3000'],
      startServerCommand: 'npm run dev',
      startServerReadyPattern: 'ready on',
      startServerReadyTimeout: 30000,
    },
    assert: {
      assertions: {
        'categories:performance': ['warn', { minScore: 0.8 }],
        'categories:accessibility': ['error', { minScore: 0.9 }],
        'categories:best-practices': ['warn', { minScore: 0.8 }],
        'categories:seo': ['warn', { minScore: 0.8 }],
      },
    },
    upload: {
      target: 'temporary-public-storage',
    },
  },
};
```

### 2. **Monitoring des performances**

#### **Collecte de métriques de performance**

```typescript
// lib/performance-monitor.ts
interface PerformanceData {
  timestamp: number;
  buildTime: number;
  bundleSize: number;
  testCoverage: number;
  lighthouseScore: number;
}

export class PerformanceMonitor {
  private metrics: PerformanceData[] = [];

  async collectMetrics(): Promise<PerformanceData> {
    const startTime = Date.now();

    // Build du projet
    await this.runBuild();
    const buildTime = Date.now() - startTime;

    // Collecte des métriques
    const metrics: PerformanceData = {
      timestamp: Date.now(),
      buildTime,
      bundleSize: await this.getBundleSize(),
      testCoverage: await this.getTestCoverage(),
      lighthouseScore: await this.getLighthouseScore(),
    };

    this.metrics.push(metrics);
    await this.saveMetrics(metrics);

    return metrics;
  }

  getTrends(): {
    buildTime: { trend: "improving" | "stable" | "degrading"; change: number };
    bundleSize: { trend: "improving" | "stable" | "degrading"; change: number };
  } {
    if (this.metrics.length < 2) {
      return {
        buildTime: { trend: "stable", change: 0 },
        bundleSize: { trend: "stable", change: 0 },
      };
    }

    const recent = this.metrics.slice(-5);
    const older = this.metrics.slice(-10, -5);

    const buildTimeChange = this.calculateChange(
      recent.map((m) => m.buildTime),
      older.map((m) => m.buildTime)
    );

    const bundleSizeChange = this.calculateChange(
      recent.map((m) => m.bundleSize),
      older.map((m) => m.bundleSize)
    );

    return {
      buildTime: {
        trend: this.getTrend(buildTimeChange),
        change: buildTimeChange,
      },
      bundleSize: {
        trend: this.getTrend(bundleSizeChange),
        change: bundleSizeChange,
      },
    };
  }

  private calculateChange(recent: number[], older: number[]): number {
    const recentAvg = recent.reduce((a, b) => a + b, 0) / recent.length;
    const olderAvg = older.reduce((a, b) => a + b, 0) / older.length;
    return ((recentAvg - olderAvg) / olderAvg) * 100;
  }

  private getTrend(change: number): "improving" | "stable" | "degrading" {
    if (change < -5) return "improving";
    if (change > 5) return "degrading";
    return "stable";
  }
}
```

## 📚 Documentation

### 1. **Mise à jour automatique**

#### **Script de mise à jour de la documentation**

```bash
#!/bin/bash
# scripts/update-docs.sh

set -e

echo "📚 Mise à jour de la documentation..."

# 1. Générer le changelog
echo "📝 Génération du changelog..."
./scripts/generate-changelog.sh

# 2. Mettre à jour la version dans la documentation
echo "🔢 Mise à jour des versions..."
CURRENT_VERSION=$(node -p "require('./package.json').version")
sed -i "s/version: [0-9]\+\.[0-9]\+\.[0-9]\+/version: $CURRENT_VERSION/g" docs/*.md

# 3. Générer la documentation API
echo "🔌 Génération de la documentation API..."
npm run docs:generate

# 4. Vérifier les liens cassés
echo "🔗 Vérification des liens..."
npm run docs:check-links

# 5. Commit des changements
echo "💾 Commit des changements..."
git add docs/
git commit -m "docs: mise à jour de la documentation pour la version $CURRENT_VERSION"

echo "✅ Mise à jour de la documentation terminée!"
```

### 2. **Validation de la documentation**

#### **Script de validation**

```bash
#!/bin/bash
# scripts/validate-docs.sh

set -e

echo "✅ Validation de la documentation..."

# 1. Vérifier la syntaxe Markdown
echo "📝 Vérification de la syntaxe Markdown..."
npm run docs:lint

# 2. Vérifier les liens
echo "🔗 Vérification des liens..."
npm run docs:check-links

# 3. Vérifier les exemples de code
echo "💻 Vérification des exemples de code..."
npm run docs:validate-examples

# 4. Vérifier la cohérence
echo "🧠 Vérification de la cohérence..."
npm run docs:check-consistency

echo "✅ Validation de la documentation terminée!"
```

## ✅ Checklist de maintenance

### Mise à jour

- [ ] Dépendances npm à jour
- [ ] Firebase CLI à jour
- [ ] Node.js à jour
- [ ] Tests passent après mise à jour
- [ ] Build fonctionne après mise à jour

### Sécurité

- [ ] Audit de sécurité effectué
- [ ] Vulnérabilités corrigées
- [ ] Secrets sécurisés
- [ ] Permissions vérifiées
- [ ] Variables d'environnement sécurisées

### Performance

- [ ] Métriques collectées
- [ ] Tendances analysées
- [ ] Optimisations identifiées
- [ ] Tests de performance passent
- [ ] Lighthouse score acceptable

### Documentation

- [ ] Documentation à jour
- [ ] Exemples fonctionnels
- [ ] Liens vérifiés
- [ ] Changelog généré
- [ ] API documentée

## 🎉 Félicitations !

Vous maintenez maintenant votre générateur de manière professionnelle et efficace !

**Prochaines étapes :**

- [Guide de contribution](CONTRIBUTING.md) 🤝
- [Exemples de projets](EXAMPLES.md) 📚
- [Troubleshooting](TROUBLESHOOTING.md) 🔧

---

**💡 Astuce :** Automatisez le maximum de tâches de maintenance pour vous concentrer sur le développement !
