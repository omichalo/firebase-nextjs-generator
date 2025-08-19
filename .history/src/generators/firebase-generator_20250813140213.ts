import * as fs from "fs-extra";
import * as path from "path";
import { TemplateEngine } from "../utils/template-engine";
import { GeneratorOptions } from "../types";

export class FirebaseGenerator {
  private templateEngine: TemplateEngine;
  private options: GeneratorOptions;

  constructor(options: GeneratorOptions) {
    this.options = options;
    this.templateEngine = new TemplateEngine(options);
  }

  async generate(): Promise<void> {
    console.log("🔥 Génération du projet Firebase...");

    const outputDir = path.join(this.options.outputDir, "backend");

    // Créer la structure de base
    await this.createBaseStructure(outputDir);

    // Générer les fichiers de configuration Firebase
    await this.generateFirebaseConfig(outputDir);

    // Générer les Cloud Functions
    await this.generateCloudFunctions(outputDir);

    // Générer les règles Firestore
    await this.generateFirestoreRules(outputDir);

    // Générer les extensions Firebase
    await this.generateFirebaseExtensions(outputDir);

    // Générer les scripts de déploiement
    await this.generateDeploymentScripts(outputDir);

    // Générer les tests
    await this.generateTests(outputDir);

    console.log("✅ Projet Firebase généré avec succès!");
  }

  private async createBaseStructure(outputDir: string): Promise<void> {
    const directories = [
      "functions",
      "firestore",
      "storage",
      "extensions",
      "scripts",
      "tests",
    ];

    for (const dir of directories) {
      await fs.ensureDir(path.join(outputDir, dir));
    }

    // Structure des Cloud Functions
    const functionsDirs = [
      "functions/src",
      "functions/src/auth",
      "functions/src/firestore",
      "functions/src/storage",
      "functions/src/https",
      "functions/src/scheduled",
      "functions/src/utils",
      "functions/tests",
    ];

    for (const dir of functionsDirs) {
      await fs.ensureDir(path.join(outputDir, dir));
    }
  }

  private async generateFirebaseConfig(outputDir: string): Promise<void> {
    // firebase.json
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, "firebase/firebase.json.hbs"),
      path.join(outputDir, "firebase.json")
    );

    // .firebaserc
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, "firebase/firebaserc.hbs"),
      path.join(outputDir, ".firebaserc")
    );

    // firestore.rules
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, "firebase/firestore.rules.hbs"),
      path.join(outputDir, "firestore.rules")
    );

    // firestore.indexes.json
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/firestore.indexes.json.hbs"
      ),
      path.join(outputDir, "firestore.indexes.json")
    );

    // storage.rules
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, "firebase/storage.rules.hbs"),
      path.join(outputDir, "storage.rules")
    );
  }

  private async generateCloudFunctions(outputDir: string): Promise<void> {
    const functionsDir = path.join(outputDir, "functions");

    // package.json des fonctions
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/package.json.hbs"
      ),
      path.join(functionsDir, "package.json")
    );

    // tsconfig.json des fonctions
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/tsconfig.json.hbs"
      ),
      path.join(functionsDir, "tsconfig.json")
    );

    // index.ts principal
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, "firebase/functions/index.ts.hbs"),
      path.join(functionsDir, "src/index.ts")
    );

    // Configuration Firebase Admin
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, "firebase/functions/admin.ts.hbs"),
      path.join(functionsDir, "src/admin.ts")
    );

    // Générer les triggers d'authentification
    await this.generateAuthTriggers(functionsDir);

    // Générer les triggers Firestore
    await this.generateFirestoreTriggers(functionsDir);

    // Générer les triggers Storage
    await this.generateStorageTriggers(functionsDir);

    // Générer les fonctions HTTP
    await this.generateHTTPFunctions(functionsDir);

    // Générer les fonctions programmées
    await this.generateScheduledFunctions(functionsDir);

    // Générer les utilitaires
    await this.generateFunctionUtils(functionsDir);
  }

  private async generateAuthTriggers(functionsDir: string): Promise<void> {
    const authDir = path.join(functionsDir, "src/auth");

    // Trigger de création d'utilisateur
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/auth/user-created.ts.hbs"
      ),
      path.join(authDir, "user-created.ts")
    );

    // Trigger de suppression d'utilisateur
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/auth/user-deleted.ts.hbs"
      ),
      path.join(authDir, "user-deleted.ts")
    );

    // Trigger de mise à jour d'utilisateur
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/auth/user-updated.ts.hbs"
      ),
      path.join(authDir, "user-updated.ts")
    );
  }

  private async generateFirestoreTriggers(functionsDir: string): Promise<void> {
    const firestoreDir = path.join(functionsDir, "src/firestore");

    // Trigger de création de document
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/firestore/document-created.ts.hbs"
      ),
      path.join(firestoreDir, "document-created.ts")
    );

    // Trigger de mise à jour de document
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/firestore/document-updated.ts.hbs"
      ),
      path.join(firestoreDir, "document-updated.ts")
    );

    // Trigger de suppression de document
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/firestore/document-deleted.ts.hbs"
      ),
      path.join(firestoreDir, "document-deleted.ts")
    );
  }

  private async generateStorageTriggers(functionsDir: string): Promise<void> {
    const storageDir = path.join(functionsDir, "src/storage");

    // Trigger de téléchargement de fichier
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/storage/file-uploaded.ts.hbs"
      ),
      path.join(storageDir, "file-uploaded.ts")
    );

    // Trigger de suppression de fichier
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/storage/file-deleted.ts.hbs"
      ),
      path.join(storageDir, "file-deleted.ts")
    );
  }

  private async generateHTTPFunctions(functionsDir: string): Promise<void> {
    const httpsDir = path.join(functionsDir, "src/https");

    // Fonction de health check
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/https/health.ts.hbs"
      ),
      path.join(httpsDir, "health.ts")
    );

    // Fonction d'API générique
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/https/api.ts.hbs"
      ),
      path.join(httpsDir, "api.ts")
    );
  }

  private async generateScheduledFunctions(
    functionsDir: string
  ): Promise<void> {
    const scheduledDir = path.join(functionsDir, "src/scheduled");

    // Fonction de nettoyage quotidien
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/scheduled/daily-cleanup.ts.hbs"
      ),
      path.join(scheduledDir, "daily-cleanup.ts")
    );

    // Fonction de backup hebdomadaire
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/scheduled/weekly-backup.ts.hbs"
      ),
      path.join(scheduledDir, "weekly-backup.ts")
    );
  }

  private async generateFunctionUtils(functionsDir: string): Promise<void> {
    const utilsDir = path.join(functionsDir, "src/utils");

    // Utilitaires de logging
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/utils/logger.ts.hbs"
      ),
      path.join(utilsDir, "logger.ts")
    );

    // Utilitaires de validation
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/utils/validation.ts.hbs"
      ),
      path.join(utilsDir, "validation.ts")
    );

    // Utilitaires de sécurité
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/functions/utils/security.ts.hbs"
      ),
      path.join(utilsDir, "security.ts")
    );
  }

  private async generateFirestoreRules(outputDir: string): Promise<void> {
    const firestoreDir = path.join(outputDir, "firestore");

    // Règles de sécurité par environnement
    for (const env of this.options.firebase.environments) {
      await this.templateEngine.processTemplate(
        path.join(this.options.templateDir, "firebase/firestore/rules.hbs"),
        path.join(firestoreDir, `rules.${env.name}.firestore`),
        { environment: env }
      );
    }

    // Index optimisés
    await this.templateEngine.processTemplate(
      path.join(
        this.options.templateDir,
        "firebase/firestore/indexes.json.hbs"
      ),
      path.join(firestoreDir, "indexes.json")
    );

    // Migrations
    await this.generateMigrations(firestoreDir);
  }

  private async generateMigrations(firestoreDir: string): Promise<void> {
    const migrationsDir = path.join(firestoreDir, "migrations");

    for (const migration of this.options.firestore.migrations) {
      await this.templateEngine.processTemplate(
        path.join(
          this.options.templateDir,
          "firebase/firestore/migration.ts.hbs"
        ),
        path.join(
          migrationsDir,
          `v${migration.version}-${migration.description}.ts`
        ),
        { migration }
      );
    }
  }

  private async generateFirebaseExtensions(outputDir: string): Promise<void> {
    const extensionsDir = path.join(outputDir, "extensions");

    for (const extension of this.options.firebase.extensions) {
      const extensionDir = path.join(extensionsDir, extension.name);
      await fs.ensureDir(extensionDir);

      await this.templateEngine.processTemplate(
        path.join(
          this.options.templateDir,
          "firebase/extensions/extension.yaml.hbs"
        ),
        path.join(extensionDir, "extension.yaml"),
        { extension }
      );
    }
  }

  private async generateDeploymentScripts(outputDir: string): Promise<void> {
    const scriptsDir = path.join(outputDir, "scripts");

    // Script de déploiement principal
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, "firebase/scripts/deploy.sh.hbs"),
      path.join(scriptsDir, "deploy.sh")
    );

    // Script de déploiement par environnement
    for (const env of this.options.firebase.environments) {
      await this.templateEngine.processTemplate(
        path.join(
          this.options.templateDir,
          "firebase/scripts/deploy-env.sh.hbs"
        ),
        path.join(scriptsDir, `deploy-${env.name}.sh`),
        { environment: env }
      );
    }

    // Script de rollback
    await this.templateEngine.processTemplate(
      path.join(this.options.templateDir, "firebase/scripts/rollback.sh.hbs"),
      path.join(scriptsDir, "rollback.sh")
    );
  }

  private async generateTests(outputDir: string): Promise<void> {
    const testsDir = path.join(outputDir, "tests");

    // Tests des Cloud Functions
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, "firebase/tests/functions"),
      path.join(testsDir, "functions")
    );

    // Tests des règles Firestore
    await this.templateEngine.processDirectory(
      path.join(this.options.templateDir, "firebase/tests/firestore"),
      path.join(testsDir, "firestore")
    );
  }
}
