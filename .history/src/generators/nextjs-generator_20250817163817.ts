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
    // package.json
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, 'nextjs/package.json.hbs'),
      path.join(outputDir, 'package.json')
    );

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

    // Composants MUI
    if (this.options.nextjs.ui === 'mui' || this.options.nextjs.ui === 'both') {
      await this.templateEngine.processDirectory(
        path.join(this.options.templateDir, 'nextjs/components/mui'),
        componentsDir
      );
    }

    // Composants Shadcn/ui
    if (
      this.options.nextjs.ui === 'shadcn' ||
      this.options.nextjs.ui === 'both'
    ) {
      await this.templateEngine.processDirectory(
        path.join(this.options.templateDir, 'nextjs/components/shadcn'),
        componentsDir
      );
    }

    // Composants communs
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/components/common'),
      componentsDir
    );
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

    // Hooks Firebase
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, 'nextjs/hooks/firebase'),
      hooksDir
    );

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
}
