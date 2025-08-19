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

    // Générer package.json
    await this.generatePackageJson(outputDir);

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

    // Générer la documentation
    await this.generateDocumentation(outputDir);

    // Générer les workflows GitHub Actions
    await this.generateGitHubActions(outputDir);

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
    // package.json - avec dépendances dynamiques
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

    // tailwind.config.js (si Shadcn/ui est activé)
    if (
      this.options.nextjs.ui === 'shadcn' ||
      this.options.nextjs.ui === 'both'
    ) {
      await this.templateEngine.processTemplate(
        path.join(this.options.templateDir, 'nextjs/tailwind.config.js.hbs'),
        path.join(outputDir, 'tailwind.config.js')
      );
    }

    // .env.local
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/env.local.hbs'),
      path.join(outputDir, '.env.local')
    );
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
      const zustandTemplateDir = path.join(
        this.options.templateDir,
        'nextjs/stores/zustand'
      );

      if (await fs.pathExists(zustandTemplateDir)) {
        await this.templateEngine.processDirectory(
          zustandTemplateDir,
          storesDir
        );
      } else {
        console.error('❌ Répertoire template Zustand non trouvé');
      }
    }

    // Redux stores (si demandé)
    if (
      this.options.nextjs.stateManagement === 'redux' ||
      this.options.nextjs.stateManagement === 'both'
    ) {
      const reduxTemplateDir = path.join(
        this.options.templateDir,
        'nextjs/stores/redux'
      );

      if (await fs.pathExists(reduxTemplateDir)) {
        await this.templateEngine.processDirectory(reduxTemplateDir, storesDir);
      } else {
        console.error('❌ Répertoire template Redux non trouvé');
      }
    }
  }

  private async generateCustomHooks(outputDir: string): Promise<void> {
    const hooksDir = path.join(outputDir, 'src/hooks');

    // Traiter tous les hooks Firebase avec le bon state management
    const firebaseHooksDir = path.join(
      this.options.templateDir,
      'nextjs/hooks/firebase'
    );

    // Hooks Firebase - avec gestion d'état appropriée
    if (this.options.nextjs.stateManagement === 'redux') {
      // Pour Redux, utiliser use-auth-redux.ts
      await this.templateEngine.processTemplate(
        path.join(firebaseHooksDir, 'use-auth-redux.ts.hbs'),
        path.join(hooksDir, 'use-auth.ts')
      );
    } else {
      // Pour Zustand ou par défaut, utiliser use-auth.ts normal
      await this.templateEngine.processTemplate(
        path.join(firebaseHooksDir, 'use-auth.ts.hbs'),
        path.join(hooksDir, 'use-auth.ts')
      );
    }

    // Traiter tous les autres hooks Firebase (en excluant les hooks d'auth déjà traités)
    const firebaseHooks = await fs.readdir(firebaseHooksDir);
    for (const hook of firebaseHooks) {
      if (hook !== 'use-auth.ts.hbs' && hook !== 'use-auth-redux.ts.hbs') {
        const outputHookName = hook.replace('.hbs', '');
        await this.templateEngine.processTemplate(
          path.join(firebaseHooksDir, hook),
          path.join(hooksDir, outputHookName)
        );
      }
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
    // Service Worker
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/pwa/sw.js.hbs'),
      path.join(outputDir, 'public/sw.js')
    );

    // Manifest
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/pwa/manifest.json.hbs'),
      path.join(outputDir, 'public/manifest.json')
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

    // Middleware Sentry
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        'nextjs/sentry/sentry-middleware.ts.hbs'
      ),
      path.join(outputDir, 'src/middleware.ts')
    );
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

  private async generatePackageJson(outputDir: string): Promise<void> {
    // Utiliser le TemplateEngine pour traiter les Handlebars de base
    const tempPackageJsonPath = path.join(outputDir, 'package.json.temp');
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/package.json.hbs'),
      tempPackageJsonPath
    );

    // Lire le contenu traité
    let packageJsonContent = await fs.readFile(tempPackageJsonPath, 'utf-8');

    // Remplacer les dépendances selon la gestion d'état
    if (this.options.nextjs.stateManagement === 'redux') {
      // Remplacer zustand par redux
      packageJsonContent = packageJsonContent.replace(
        '"zustand": "^4.0.0"',
        '"@reduxjs/toolkit": "^2.0.0",\n    "react-redux": "^9.0.0"'
      );
    }

    // Ajouter les dépendances des fonctionnalités activées
    if (this.options.nextjs.features.sentry) {
      packageJsonContent = packageJsonContent.replace(
        '"clsx": "^2.0.0"',
        '"clsx": "^2.0.0",\n    "@sentry/nextjs": "^7.0.0"'
      );
    }

    // Écrire le package.json final
    await fs.writeFile(
      path.join(outputDir, 'package.json'),
      packageJsonContent
    );

    // Supprimer le fichier temporaire
    await fs.unlink(tempPackageJsonPath);
  }

  private async generateDocumentation(outputDir: string): Promise<void> {
    // Documentation README principal uniquement
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'docs/README.md.hbs'),
      path.join(outputDir, 'README.md')
    );

    // Autres documentations temporairement désactivées
    // await this.templateEngine.processTemplate(
    //   path.join(this.options.templateDir, 'docs/API.md.hbs'),
    //   path.join(outputDir, 'docs/API.md')
    // );

    // await this.templateEngine.processTemplate(
    //   path.join(this.options.templateDir, 'docs/DEPLOYMENT.md.hbs'),
    //   path.join(outputDir, 'docs/DEPLOYMENT.md')
    // );
  }

  private async generateGitHubActions(outputDir: string): Promise<void> {
    const githubDir = path.join(outputDir, '.github/workflows');

    // Workflow CI/CD principal uniquement
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'github/workflows/ci-cd.yml.hbs'),
      path.join(githubDir, 'ci-cd.yml')
    );

    // Autres workflows temporairement désactivés
    // await this.templateEngine.processTemplate(
    //   path.join(this.options.templateDir, 'github/workflows/security.yml.hbs'),
    //   path.join(githubDir, 'security.yml')
    // );

    // await this.templateEngine.processTemplate(
    //   path.join(this.options.templateDir, 'github/workflows/deploy.yml.hbs'),
    //   path.join(githubDir, 'deploy.yml')
    // );
  }
}
