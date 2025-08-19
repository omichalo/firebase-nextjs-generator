import {
  ValidationResult,
  ProjectConfig,
  FirebaseConfig,
  NextJSConfig,
} from "../types";

export class ConfigValidator {
  static validateProjectConfig(config: ProjectConfig): ValidationResult {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Validation du nom du projet
    if (!config.name || !/^[a-z0-9-]+$/.test(config.name)) {
      errors.push(`Nom de projet invalide: ${config.name}`);
    }

    // Validation de la description
    if (!config.description || config.description.length < 10) {
      warnings.push("Description du projet trop courte");
    }

    // Validation de l'auteur
    if (!config.author) {
      errors.push("Auteur du projet requis");
    }

    // Validation de la version
    if (!/^\d+\.\d+\.\d+$/.test(config.version)) {
      errors.push("Version invalide (format: x.y.z)");
    }

    // Validation du package manager
    if (!["npm", "yarn", "pnpm"].includes(config.packageManager)) {
      errors.push("Package manager invalide");
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings,
    };
  }

  static validateFirebaseConfig(config: FirebaseConfig): ValidationResult {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Validation du project ID
    if (!config.projectId || !/^[a-z0-9-]+$/.test(config.projectId)) {
      errors.push("Project ID Firebase invalide");
    }

    // Validation de la région (optionnelle maintenant)
    if (config.region) {
      const validRegions = [
        "us-central1",
        "us-east1",
        "us-west1",
        "us-west2",
        "europe-west1",
        "europe-west2",
        "europe-west3",
        "asia-east1",
        "asia-northeast1",
        "asia-southeast1",
      ];
      if (!validRegions.includes(config.region)) {
        warnings.push(`Région Firebase non standard: ${config.region}`);
      }
    }

    // Validation des environnements
    if (config.environments.length === 0) {
      errors.push("Au moins un environnement requis");
    }

    const envNames = config.environments.map((env) => env.name);
    if (new Set(envNames).size !== envNames.length) {
      errors.push("Noms d'environnements dupliqués");
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings,
    };
  }

  static validateNextJSConfig(config: NextJSConfig): ValidationResult {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Validation de la version Next.js
    const validVersions = ["14", "15"];
    if (!validVersions.includes(config.version)) {
      warnings.push(`Version Next.js non standard: ${config.version}`);
    }

    // Validation de l'UI
    if (!["mui", "shadcn", "both"].includes(config.ui)) {
      errors.push("Type d'UI invalide");
    }

    // Validation de la gestion d'état
    if (!["zustand", "redux", "both"].includes(config.stateManagement)) {
      errors.push("Gestionnaire d'état invalide");
    }

    // Validation des fonctionnalités
    if (config.features.fcm && !config.features.pwa) {
      warnings.push("FCM recommandé avec PWA activé");
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings,
    };
  }

  static validateCompleteConfig(options: any): ValidationResult {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Validation du projet
    const projectValidation = this.validateProjectConfig(options.project);
    errors.push(...projectValidation.errors);
    warnings.push(...projectValidation.warnings);

    // Validation Firebase
    const firebaseValidation = this.validateFirebaseConfig(options.firebase);
    errors.push(...firebaseValidation.errors);
    warnings.push(...firebaseValidation.warnings);

    // Validation Next.js
    const nextjsValidation = this.validateNextJSConfig(options.nextjs);
    errors.push(...nextjsValidation.errors);
    warnings.push(...nextjsValidation.warnings);

    // Validation du répertoire de sortie
    if (!options.outputDir) {
      errors.push("Répertoire de sortie requis");
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings,
    };
  }
}
