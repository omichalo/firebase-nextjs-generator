#!/usr/bin/env node

import { Command } from "commander";
import inquirer from "inquirer";
import chalk from "chalk";
import ora from "ora";
import * as fs from "fs-extra";
import * as path from "path";
import { Generator } from "./generator";
import { ConfigValidator } from "./utils/validator";
import { GeneratorOptions } from "./types";

const program = new Command();

program
  .name("firebase-nextjs-generator")
  .description(
    "Générateur complet pour projets Firebase + Next.js avec App Hosting"
  )
  .version("1.0.0");

program
  .command("create")
  .description("Créer un nouveau projet Firebase + Next.js")
  .option("-n, --name <name>", "Nom du projet")
  .option("-d, --description <description>", "Description du projet")
  .option("-o, --output <output>", "Répertoire de sortie")
  .option("-y, --yes", "Répondre oui à toutes les questions")
  .action(async (options) => {
    try {
      const config = await promptForConfiguration(options);
      await generateProject(config);
    } catch (error) {
      console.error(chalk.red("❌ Erreur lors de la génération:"), error);
      process.exit(1);
    }
  });

program
  .command("validate")
  .description("Valider une configuration existante")
  .option("-c, --config <path>", "Chemin vers le fichier de configuration")
  .action(async (options) => {
    try {
      await validateConfiguration(options.config);
    } catch (error) {
      console.error(chalk.red("❌ Erreur lors de la validation:"), error);
      process.exit(1);
    }
  });

async function promptForConfiguration(
  cliOptions: any
): Promise<GeneratorOptions> {
  console.log(chalk.blue("🚀 Générateur Firebase + Next.js avec App Hosting"));
  console.log(chalk.gray("Configuration du projet...\n"));

  const answers = await inquirer.prompt([
    {
      type: "input",
      name: "projectName",
      message: "Nom du projet:",
      default: cliOptions.name || "my-firebase-nextjs-app",
      validate: (input: string) => {
        if (!input.trim()) return "Le nom du projet est requis";
        if (!/^[a-z0-9-]+$/.test(input)) {
          return "Le nom doit contenir uniquement des lettres minuscules, chiffres et tirets";
        }
        return true;
      },
    },
    {
      type: "input",
      name: "description",
      message: "Description du projet:",
      default:
        cliOptions.description || "Application Firebase + Next.js moderne",
      validate: (input: string) => {
        if (!input.trim()) return "La description est requise";
        if (input.length < 10)
          return "La description doit faire au moins 10 caractères";
        return true;
      },
    },
    {
      type: "input",
      name: "author",
      message: "Auteur:",
      default: "Your Name <your.email@example.com>",
    },
    {
      type: "list",
      name: "packageManager",
      message: "Gestionnaire de paquets:",
      choices: ["npm", "yarn", "pnpm"],
      default: "npm",
    },
    {
      type: "input",
      name: "firebaseProjectId",
      message: "ID du projet Firebase:",
      validate: (input: string) => {
        if (!input.trim()) return "L'ID du projet Firebase est requis";
        if (!/^[a-z0-9-]+$/.test(input)) {
          return "L'ID doit contenir uniquement des lettres minuscules, chiffres et tirets";
        }
        return true;
      },
    },
    {
      type: "list",
      name: "firebaseRegion",
      message: "Région Firebase:",
      choices: [
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
      ],
      default: "us-central1",
    },
    {
      type: "list",
      name: "nextjsVersion",
      message: "Version Next.js:",
      choices: ["15", "14"],
      default: "15",
    },
    {
      type: "list",
      name: "uiFramework",
      message: "Framework UI:",
      choices: [
        { name: "Material-UI (MUI)", value: "mui" },
        { name: "Shadcn/ui", value: "shadcn" },
        { name: "Les deux", value: "both" },
      ],
      default: "mui",
    },
    {
      type: "list",
      name: "stateManagement",
      message: "Gestion d'état:",
      choices: [
        { name: "Zustand", value: "zustand" },
        { name: "Redux Toolkit", value: "redux" },
        { name: "Les deux", value: "both" },
      ],
      default: "zustand",
    },
    {
      type: "checkbox",
      name: "features",
      message: "Fonctionnalités avancées:",
      choices: [
        { name: "PWA (Progressive Web App)", value: "pwa" },
        { name: "FCM (Firebase Cloud Messaging)", value: "fcm" },
        { name: "Firebase Analytics", value: "analytics" },
        { name: "Performance Monitoring", value: "performance" },
        { name: "Sentry (Monitoring d'erreurs)", value: "sentry" },
      ],
      default: ["pwa", "analytics"],
    },
    {
      type: "input",
      name: "outputDir",
      message: "Répertoire de sortie:",
      default: cliOptions.output || "./generated-project",
      validate: (input: string) => {
        if (!input.trim()) return "Le répertoire de sortie est requis";
        return true;
      },
    },
  ]);

  // Configuration des environnements
  const environments = await promptForEnvironments();

  // Configuration des extensions Firebase
  const extensions = await promptForExtensions();

  // Configuration des thèmes
  const themes = await promptForThemes();

  return {
    project: {
      name: answers.projectName,
      description: answers.description,
      author: answers.author,
      version: "1.0.0",
      license: "MIT",
      packageManager: answers.packageManager,
    },
    firebase: {
      projectId: answers.firebaseProjectId,
      region: answers.firebaseRegion,
      environments,
      extensions,
    },
    nextjs: {
      version: answers.nextjsVersion,
      appRouter: true,
      typescript: true,
      strictMode: true,
      ui: answers.uiFramework,
      stateManagement: answers.stateManagement,
      features: {
        pwa: answers.features.includes("pwa"),
        fcm: answers.features.includes("fcm"),
        analytics: answers.features.includes("analytics"),
        performance: answers.features.includes("performance"),
        sentry: answers.features.includes("sentry"),
      },
    },
    cloudFunctions: {
      runtime: "nodejs20",
      region: answers.firebaseRegion,
      triggers: [
        {
          name: "userCreated",
          type: "auth",
          event: "user.create",
        },
        {
          name: "userDeleted",
          type: "auth",
          event: "user.delete",
        },
      ],
      scheduled: [
        {
          name: "dailyCleanup",
          schedule: "0 2 * * *",
          timeZone: "UTC",
        },
      ],
    },
    firestore: {
      rules:
        'rules_version = "2";\nservice cloud.firestore {\n  match /databases/{database}/documents {\n    // Règles par défaut\n  }\n}',
      indexes: "[]",
      migrations: [],
    },
    themes,
    outputDir: answers.outputDir,
    templateDir: path.join(__dirname, "../templates"),
  };
}

async function promptForEnvironments(): Promise<any[]> {
  const { environments } = await inquirer.prompt([
    {
      type: "checkbox",
      name: "environments",
      message: "Sélectionner les environnements souhaités:",
      choices: [
        { name: "Développement (dev)", value: "dev" },
        { name: "Staging/Test (staging)", value: "staging" },
        { name: "Production (prod)", value: "prod" },
        { name: "Local (local)", value: "local" },
      ],
      default: ["dev", "prod"],
      validate: (input: string[]) => {
        if (input.length === 0) return "Au moins un environnement est requis";
        return true;
      },
    },
  ]);

  const envConfigs = [];

  for (const envName of environments) {
    const { projectId, region } = await inquirer.prompt([
      {
        type: "input",
        name: "projectId",
        message: `ID du projet Firebase pour ${envName}:`,
        default: `my-app-${envName}`,
        validate: (input: string) => {
          if (!input.trim()) return "L'ID du projet est requis";
          if (!/^[a-z0-9-]+$/.test(input)) {
            return "L'ID doit contenir uniquement des lettres minuscules, chiffres et tirets";
          }
          return true;
        },
      },
      {
        type: "list",
        name: "region",
        message: `Région Firebase pour ${envName}:`,
        choices: [
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
        ],
        default: "us-central1",
      },
    ]);

    envConfigs.push({
      name: envName,
      projectId,
      region,
      variables: {},
    });
  }

  return envConfigs;
}

async function promptForExtensions(): Promise<any[]> {
  const { useExtensions } = await inquirer.prompt([
    {
      type: "confirm",
      name: "useExtensions",
      message: "Utiliser des extensions Firebase?",
      default: false,
    },
  ]);

  if (!useExtensions) return [];

  const { extensions } = await inquirer.prompt([
    {
      type: "checkbox",
      name: "extensions",
      message: "Sélectionner les extensions:",
      choices: [
        { name: "Firebase Auth UI", value: "firebase-auth-ui" },
        { name: "Firestore Exports", value: "firestore-exports" },
        { name: "Firebase Storage", value: "firebase-storage" },
        { name: "Firebase Emulator", value: "firebase-emulator" },
      ],
    },
  ]);

  return extensions.map((ext: string) => ({
    name: ext,
    version: "latest",
    config: {},
  }));
}

async function promptForThemes(): Promise<any[]> {
  const { useThemes } = await inquirer.prompt([
    {
      type: "confirm",
      name: "useThemes",
      message: "Configurer des thèmes personnalisés?",
      default: false,
    },
  ]);

  if (!useThemes) {
    return [
      {
        name: "default",
        type: "mui",
        variables: {},
        darkMode: true,
      },
    ];
  }

  const themes = [];
  const { themeCount } = await inquirer.prompt([
    {
      type: "number",
      name: "themeCount",
      message: "Nombre de thèmes:",
      default: 2,
      min: 1,
      max: 5,
    },
  ]);

  for (let i = 0; i < themeCount; i++) {
    const { name, type, darkMode } = await inquirer.prompt([
      {
        type: "input",
        name: "name",
        message: `Nom du thème ${i + 1}:`,
        default: `theme-${i + 1}`,
      },
      {
        type: "list",
        name: "type",
        message: `Type du thème ${i + 1}:`,
        choices: ["mui", "shadcn", "custom"],
        default: "mui",
      },
      {
        type: "confirm",
        name: "darkMode",
        message: `Mode sombre pour le thème ${i + 1}?`,
        default: true,
      },
    ]);

    themes.push({
      name,
      type,
      variables: {},
      darkMode,
    });
  }

  return themes;
}

async function generateProject(config: GeneratorOptions): Promise<void> {
  const spinner = ora("Génération du projet...").start();

  try {
    // Valider la configuration
    const validation = ConfigValidator.validateCompleteConfig(config);
    if (!validation.valid) {
      spinner.fail("Configuration invalide");
      console.error(chalk.red("Erreurs:"));
      validation.errors.forEach((error) =>
        console.error(chalk.red(`  - ${error}`))
      );
      if (validation.warnings.length > 0) {
        console.warn(chalk.yellow("Avertissements:"));
        validation.warnings.forEach((warning) =>
          console.warn(chalk.yellow(`  - ${warning}`))
        );
      }
      return;
    }

    // Créer le répertoire de sortie
    await fs.ensureDir(config.outputDir);

    // Générer le projet
    const generator = new Generator(config);
    await generator.generate();

    spinner.succeed("Projet généré avec succès!");

    console.log(chalk.green("\n🎉 Projet créé avec succès!"));
    console.log(chalk.blue(`📁 Répertoire: ${config.outputDir}`));
    console.log(
      chalk.blue(`🔥 Firebase Project ID: ${config.firebase.projectId}`)
    );
    console.log(chalk.blue(`⚛️  Next.js ${config.nextjs.version}`));

    console.log(chalk.yellow("\n📋 Prochaines étapes:"));
    console.log(chalk.gray("1. cd " + config.outputDir));
    console.log(chalk.gray("2. npm install"));
    console.log(chalk.gray("3. firebase login"));
    console.log(chalk.gray("4. firebase init"));
    console.log(chalk.gray("5. npm run dev"));
  } catch (error) {
    spinner.fail("Erreur lors de la génération");
    throw error;
  }
}

async function validateConfiguration(configPath: string): Promise<void> {
  if (!configPath) {
    console.error(
      chalk.red("❌ Chemin vers le fichier de configuration requis")
    );
    return;
  }

  try {
    const configContent = await fs.readFile(configPath, "utf-8");
    const config = JSON.parse(configContent);

    const validation = ConfigValidator.validateCompleteConfig(config);

    if (validation.valid) {
      console.log(chalk.green("✅ Configuration valide"));
    } else {
      console.log(chalk.red("❌ Configuration invalide"));
      validation.errors.forEach((error) =>
        console.error(chalk.red(`  - ${error}`))
      );
    }

    if (validation.warnings.length > 0) {
      console.warn(chalk.yellow("⚠️  Avertissements:"));
      validation.warnings.forEach((warning) =>
        console.warn(chalk.yellow(`  - ${warning}`))
      );
    }
  } catch (error) {
    console.error(
      chalk.red("❌ Erreur lors de la lecture du fichier de configuration:"),
      error
    );
  }
}

program.parse();
