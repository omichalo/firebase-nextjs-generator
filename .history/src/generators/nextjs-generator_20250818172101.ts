import * as fs from 'fs-extra';
import * as path from 'path';
import { TemplateEngine } from '../utils/template-engine';
import { GeneratorOptions } from '../types';

export class NextJSGenerator {
  private templateEngine: TemplateEngine;
  private options: GeneratorOptions;

  constructor(options: GeneratorOptions) {
    this.options = options;
    this.templateEngine = new TemplateEngine(options);
  }

  async generate(): Promise<void> {
    console.log('🚀 Génération du projet Next.js...');

    const outputDir = path.join(this.options.outputDir, 'frontend');

    // Créer la structure de base
    await this.createBaseStructure(outputDir);

    // Générer les fichiers de configuration
    await this.generateConfigFiles(outputDir);

    // Générer les fichiers de base (Firebase, globals.css)
    await this.generateBaseFiles(outputDir);

    // Générer les composants UI
    await this.generateUIComponents(outputDir);

    // Générer la gestion d'état
    await this.generateStateManagement(outputDir);

    // Générer les hooks personnalisés
    await this.generateCustomHooks(outputDir);

    // Générer les API routes
    await this.generateAPIRoutes(outputDir);

    // Générer les pages et layouts
    await this.generatePagesAndLayouts(outputDir);

    // Générer les fonctionnalités avancées
    await this.generateAdvancedFeatures(outputDir);

    // Générer les tests
    await this.generateTests(outputDir);

    console.log('✅ Projet Next.js généré avec succès!');
  }

  private async createBaseStructure(outputDir: string): Promise<void> {
    const directories = [
      'src/app',
      'src/components',
      'src/hooks',
      'src/lib',
      'src/stores',
      'src/types',
      'src/utils',
      'src/styles',
      'public',
      'tests',
    ];

    for (const dir of directories) {
      await fs.ensureDir(path.join(outputDir, dir));
    }
  }

  private async generateConfigFiles(outputDir: string): Promise<void> {
    // package.json - généré dynamiquement selon les options
    await this.generatePackageJson(outputDir);

    // next.config.js
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/next.config.js.hbs'),
      path.join(outputDir, 'next.config.js')
    );

    // tsconfig.json
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/tsconfig.json.hbs'),
      path.join(outputDir, 'tsconfig.json')
    );

    // .env.local
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/env.local.hbs'),
      path.join(outputDir, '.env.local')
    );

    // Script de démarrage avec port dynamique
    await this.generateDevScript(outputDir);
  }

  private async generateDevScript(outputDir: string): Promise<void> {
    const devScriptContent = `#!/bin/bash
# Script de démarrage avec port dynamique
# Trouve automatiquement un port disponible

PORT=3000

find_free_port() {
  local port=3000
  while lsof -i :$port >/dev/null 2>&1; do
    echo "⚠️  Port $port occupé, essai du port suivant..."
    port=$((port + 1))
    if [ $port -gt 3010 ]; then
      echo "❌ Impossible de trouver un port libre entre 3000-3010"
      exit 1
    fi
  done
  echo "✅ Port $port libre trouvé"
  PORT=$port
}

find_free_port
echo "🚀 Démarrage de l'application sur le port $PORT..."

# Démarrage avec le port trouvé
PORT=$PORT npm run dev
`;

    await fs.writeFile(
      path.join(outputDir, 'dev-dynamic.sh'),
      devScriptContent
    );
    await fs.chmod(path.join(outputDir, 'dev-dynamic.sh'), 0o755);

    console.log('✅ Script de démarrage dynamique généré');
  }

  private async generatePackageJson(outputDir: string): Promise<void> {
    // Créer un fichier temporaire avec le contenu modifié
    const tempPackageJsonPath = path.join(
      this.options.templateDir,
      'nextjs/package.json.temp.hbs'
    );
    const originalPackageJsonPath = path.join(
      this.options.templateDir,
      'nextjs/package.json.hbs'
    );

    // Lire le contenu original
    let packageJsonContent = await fs.readFile(originalPackageJsonPath, 'utf8');

    // Ajouter les dépendances Redux si nécessaire
    if (
      this.options.nextjs.stateManagement === 'redux' ||
      this.options.nextjs.stateManagement === 'both'
    ) {
      const reduxDeps =
        '"@reduxjs/toolkit": "^2.0.0",\n    "react-redux": "^9.0.0",';

      // Insérer après zustand
      packageJsonContent = packageJsonContent.replace(
        '"zustand": "^4.0.0",',
        `"zustand": "^4.0.0",\n    ${reduxDeps}`
      );
    }

    // Ajouter les dépendances conditionnelles selon les fonctionnalités
    const additionalDeps: string[] = [];

    if (this.options.nextjs.features.sentry) {
      additionalDeps.push('"@sentry/nextjs": "^8.0.0"');
    }

    // Firebase est déjà inclus par défaut, pas besoin de l'ajouter à nouveau
    // Les modules spécifiques (messaging, analytics, performance) sont inclus dans firebase

    // Ajouter les dépendances supplémentaires si elles existent
    if (additionalDeps.length > 0) {
      const depsToAdd = additionalDeps.join(',\n    ');
      packageJsonContent = packageJsonContent.replace(
        '"clsx": "^2.0.0",',
        `"clsx": "^2.0.0",\n    ${depsToAdd}`
      );
    }

    // Créer un fichier temporaire
    await fs.writeFile(tempPackageJsonPath, packageJsonContent);

    // Traiter le template temporaire avec Handlebars
    await this.templateEngine.processTemplate(
      tempPackageJsonPath,
      path.join(outputDir, 'package.json')
    );

    // Nettoyer le fichier temporaire
    await fs.remove(tempPackageJsonPath);

    // Supprimer le package-lock.json s'il existe pour éviter les conflits
    const packageLockPath = path.join(outputDir, 'package-lock.json');
    try {
      if (await fs.pathExists(packageLockPath)) {
        await fs.unlink(packageLockPath);
        console.log('✅ package-lock.json supprimé pour éviter les conflits');
      }
    } catch (error) {
      console.warn('⚠️  Impossible de supprimer package-lock.json:', error);
    }
  }

  private async generateUIComponents(outputDir: string): Promise<void> {
    const componentsDir = path.join(outputDir, 'src/components');

    // Composants racine (comme NotFoundClient) - seulement pour MUI
    if (this.options.nextjs.ui === 'mui' || this.options.nextjs.ui === 'both') {
      await this.templateEngine.processDirectory(
        path.join(this.options.templateDir, 'nextjs/components'),
        componentsDir
      );
    }

    // Composants MUI
    if (this.options.nextjs.ui === 'mui' || this.options.nextjs.ui === 'both') {
      await this.templateEngine.processDirectory(
        path.join(this.options.templateDir, 'nextjs/components/mui'),
        componentsDir
      );
    }

    // Composants communs - seulement si pas MUI (pour éviter les conflits)
    if (this.options.nextjs.ui !== 'mui') {
      await this.templateEngine.processDirectory(
        path.join(this.options.templateDir, 'nextjs/components/common'),
        componentsDir
      );
    }
  }

  private async generateStateManagement(outputDir: string): Promise<void> {
    const storesDir = path.join(outputDir, 'src/stores');

    // Zustand stores
    if (
      this.options.nextjs.stateManagement === 'zustand' ||
      this.options.nextjs.stateManagement === 'both'
    ) {
      await this.templateEngine.processDirectory(
        path.join(this.options.templateDir, 'nextjs/stores/zustand'),
        storesDir
      );
    }

    // Redux stores (si demandé)
    if (
      this.options.nextjs.stateManagement === 'redux' ||
      this.options.nextjs.stateManagement === 'both'
    ) {
      await this.templateEngine.processDirectory(
        path.join(this.options.templateDir, 'nextjs/stores/redux'),
        storesDir
      );
    }
  }

  private async generateCustomHooks(outputDir: string): Promise<void> {
    const hooksDir = path.join(outputDir, 'src/hooks');

    // Hooks Firebase - utiliser le bon hook selon le state management
    if (this.options.nextjs.stateManagement === 'redux') {
      // Pour Redux, copier le hook Redux
      await this.templateEngine.processTemplate(
        path.join(
          this.options.templateDir,
          'nextjs/hooks/firebase/use-auth-redux.ts.hbs'
        ),
        path.join(hooksDir, 'use-auth.ts')
      );
    } else {
      // Pour Zustand, utiliser le hook Zustand par défaut
      await this.templateEngine.processTemplate(
        path.join(
          this.options.templateDir,
          'nextjs/hooks/firebase/use-auth.ts.hbs'
        ),
        path.join(hooksDir, 'use-auth.ts')
      );
    }

    // Hooks UI
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/hooks/ui'),
      hooksDir
    );

    // Hooks utilitaires
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/hooks/utils'),
      hooksDir
    );
  }

  private async generateAPIRoutes(outputDir: string): Promise<void> {
    const apiDir = path.join(outputDir, 'src/app/api');

    // Routes d'authentification
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/api/auth'),
      path.join(apiDir, 'auth')
    );

    // Routes Firestore
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/api/firestore'),
      path.join(apiDir, 'firestore')
    );

    // Routes utilitaires
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/api/utils'),
      apiDir
    );
  }

  private async generatePagesAndLayouts(outputDir: string): Promise<void> {
    const appDir = path.join(outputDir, 'src/app');

    // Layout principal
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/app/layout.tsx.hbs'),
      path.join(appDir, 'layout.tsx')
    );

    // Page d'accueil
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/app/page.tsx.hbs'),
      path.join(appDir, 'page.tsx')
    );

    // Page 404
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/app/not-found.tsx.hbs'),
      path.join(appDir, 'not-found.tsx')
    );

    // Pages d'authentification
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/app/auth'),
      path.join(appDir, 'auth')
    );

    // Pages de dashboard
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/app/dashboard'),
      path.join(appDir, 'dashboard')
    );
  }

  private async generateAdvancedFeatures(outputDir: string): Promise<void> {
    // PWA
    if (this.options.nextjs.features.pwa) {
      await this.generatePWA(outputDir);
    }

    // FCM
    if (this.options.nextjs.features.fcm) {
      await this.generateFCM(outputDir);
    }

    // Analytics
    if (this.options.nextjs.features.analytics) {
      await this.generateAnalytics(outputDir);
    }

    // Performance Monitoring
    if (this.options.nextjs.features.performance) {
      await this.generatePerformanceMonitoring(outputDir);
    }

    // Sentry
    if (this.options.nextjs.features.sentry) {
      await this.generateSentry(outputDir);
    }
  }

  private async generatePWA(outputDir: string): Promise<void> {
    // Créer le dossier public s'il n'existe pas
    const publicDir = path.join(outputDir, 'public');
    await fs.ensureDir(publicDir);

    // Service Worker
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/pwa/sw.js.hbs'),
      path.join(publicDir, 'sw.js')
    );

    // Manifest
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/pwa/manifest.json.hbs'),
      path.join(publicDir, 'manifest.json')
    );

    // Configuration PWA
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/pwa/pwa-config.ts.hbs'),
      path.join(outputDir, 'src/lib/pwa-config.ts')
    );
  }

  private async generateFCM(outputDir: string): Promise<void> {
    // Configuration FCM
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/fcm/fcm-config.ts.hbs'),
      path.join(outputDir, 'src/lib/fcm-config.ts')
    );

    // Hooks FCM
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/fcm/use-fcm.ts.hbs'),
      path.join(outputDir, 'src/hooks/use-fcm.ts')
    );
  }

  private async generateAnalytics(outputDir: string): Promise<void> {
    // Configuration Analytics
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        'nextjs/analytics/analytics-config.ts.hbs'
      ),
      path.join(outputDir, 'src/lib/analytics-config.ts')
    );

    // Hooks Analytics
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        'nextjs/analytics/use-analytics.ts.hbs'
      ),
      path.join(outputDir, 'src/hooks/use-analytics.ts')
    );
  }

  private async generatePerformanceMonitoring(
    outputDir: string
  ): Promise<void> {
    // Configuration Performance
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        'nextjs/performance/performance-config.ts.hbs'
      ),
      path.join(outputDir, 'src/lib/performance-config.ts')
    );
  }

  private async generateSentry(outputDir: string): Promise<void> {
    // Configuration Sentry
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/sentry/sentry-config.ts.hbs'),
      path.join(outputDir, 'src/lib/sentry-config.ts')
    );

    // Middleware Sentry - seulement si Sentry est activé
    if (this.options.nextjs.features.sentry) {
      await this.templateEngine.processTemplate(
        path.join(
          this.options.templateDir,
          'nextjs/sentry/sentry-middleware.ts.hbs'
        ),
        path.join(outputDir, 'src/middleware.ts')
      );
    }
  }

  private async generateBaseFiles(outputDir: string): Promise<void> {
    // Fichier Firebase de base (toujours nécessaire)
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/lib/firebase.ts.hbs'),
      path.join(outputDir, 'src/lib/firebase.ts')
    );

    // Fichier globals.css (toujours nécessaire)
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/app/globals.css.hbs'),
      path.join(outputDir, 'src/app/globals.css')
    );
  }

  private async generateTests(outputDir: string): Promise<void> {
    const testsDir = path.join(outputDir, 'tests');

    // Tests unitaires
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/tests/unit'),
      testsDir
    );

    // Tests d'intégration
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/tests/integration'),
      testsDir
    );

    // Tests E2E
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/tests/e2e'),
      testsDir
    );
  }
}
