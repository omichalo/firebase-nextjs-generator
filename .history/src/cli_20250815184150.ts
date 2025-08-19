#!/usr/bin/env node

import { Command } from "commander";
import inquirer from "inquirer";
import chalk from "chalk";
import ora from "ora";
import * as fs from "fs-extra";
import * as path from "path";
import { execSync } from "child_process";
import { Generator } from "./generator";
import { ConfigValidator } from "./utils/validator";
import { GeneratorOptions } from "./types";

// Fonction utilitaire pour vérifier la connexion Firebase
async function checkFirebaseConnection(): Promise<{
  connected: boolean;
  error?: string;
}> {
  try {
    // Vérifier si Firebase CLI est installé
    try {
      execSync("firebase --version", { stdio: "pipe" });
    } catch {
      return {
        connected: false,
        error:
          "Firebase CLI non installé. Installez-le avec: npm install -g firebase-tools",
      };
    }

    // Vérifier si l'utilisateur est connecté
    try {
      execSync("firebase projects:list", { stdio: "pipe" });
      return { connected: true };
    } catch {
      return {
        connected: false,
        error: "Utilisateur Firebase non connecté",
      };
    }
  } catch (error) {
    return {
      connected: false,
      error: `Erreur inattendue: ${error}`,
    };
  }
}

// Fonction utilitaire pour vérifier l'existence d'un projet Firebase
async function checkFirebaseProject(
  projectId: string
): Promise<{ exists: boolean; region?: string; error?: string }> {
  try {
    // Vérifier l'existence du projet
    try {
      const output = execSync("firebase projects:list", {
        stdio: "pipe",
        encoding: "utf8",
      });

      if (output.includes(projectId)) {
        // Récupérer la configuration du projet
        try {
          const projectInfo = execSync("firebase projects:list --format json", {
            stdio: "pipe",
            encoding: "utf8",
          });

          const projects = JSON.parse(projectInfo);
          const project = projects.result.find(
            (p: any) => p.projectId === projectId
          );

          if (project) {
            return {
              exists: true,
              region: project.resourceLocation || "us-central1", // Région par défaut si non spécifiée
            };
          }
        } catch (parseError) {
          // Si on ne peut pas parser, on retourne juste que le projet existe
          return { exists: true, region: "us-central1" };
        }

        return { exists: true, region: "us-central1" };
      } else {
        return { exists: false };
      }
    } catch (error) {
      return {
        exists: false,
        error: `Erreur lors de la vérification: ${error}`,
      };
    }
  } catch (error) {
    return {
      exists: false,
      error: `Erreur inattendue: ${error}`,
    };
  }
}

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
      region: "us-central1",
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
    console.log(chalk.blue(`\n Configuration de l'environnement "${envName}"`));

    // Aide contextuelle selon l'environnement
    if (envName === "dev") {
      console.log(
        chalk.gray(
          "💡 Conseil : Pour le développement, vous pouvez lier à un projet existant ou en créer un nouveau pour tester."
        )
      );
    } else if (envName === "staging") {
      console.log(
        chalk.gray(
          "💡 Conseil : Staging est idéal pour tester avant la production."
        )
      );
    } else if (envName === "prod") {
      console.log(
        chalk.gray(
          "💡 Conseil : Production - utilisez un projet existant si vous en avez un, sinon créez-en un nouveau."
        )
      );
    }

    const { projectType } = await inquirer.prompt([
      {
        type: "list",
        name: "projectType",
        message: "Type de projet Firebase :",
        choices: [
          {
            name: "🔗 Lier à un projet Firebase existant",
            value: "link",
            description:
              "Utilise un projet que vous avez déjà créé dans la console Firebase",
          },
          {
            name: "➕ Générer un nouveau projet Firebase",
            value: "generate",
            description:
              "Crée automatiquement un nouveau projet avec un nom généré",
          },
        ],
      },
    ]);

    let projectId: string = "";
    let region: string = "";
    let finalProjectType = projectType;

    if (projectType === "link") {
      // Lier à un projet existant
      console.log(chalk.yellow("🔗 Mode : Liaison à un projet existant"));
      console.log(
        chalk.gray(
          "💡 Assurez-vous que le projet existe dans votre console Firebase"
        )
      );

      let projectValidated = false;
      let existingProjectId: string;

      while (!projectValidated) {
        const { inputProjectId } = await inquirer.prompt([
          {
            type: "input",
            name: "inputProjectId",
            message: `ID du projet Firebase existant pour ${envName}:`,
            validate: (input: string) => {
              if (!input.trim()) return "L'ID du projet est requis";
              if (!/^[a-z0-9-]+$/.test(input)) {
                return "L'ID doit contenir uniquement des lettres minuscules, chiffres et tirets";
              }
              return true;
            },
          },
        ]);

        existingProjectId = inputProjectId;

        // Vérifier d'abord la connexion Firebase
        console.log(chalk.blue(`🔍 Vérification de la connexion Firebase...`));
        const connectionSpinner = ora(
          "Vérification de la connexion..."
        ).start();

        const connectionCheck = await checkFirebaseConnection();
        connectionSpinner.stop();

        if (!connectionCheck.connected) {
          console.log(chalk.red(`❌ ${connectionCheck.error}`));

          if (connectionCheck.error?.includes("non connecté")) {
            console.log(
              chalk.yellow(
                "🔐 Connexion Firebase requise pour vérifier l'existence du projet."
              )
            );

            const { doLogin } = await inquirer.prompt([
              {
                type: "confirm",
                name: "doLogin",
                message: "Voulez-vous vous connecter à Firebase maintenant ?",
                default: true,
              },
            ]);

            if (doLogin) {
              console.log(
                chalk.blue("🔐 Lancement de la connexion Firebase...")
              );
              console.log(
                chalk.gray(
                  "💡 Une fenêtre de navigateur va s'ouvrir pour l'authentification."
                )
              );

              try {
                execSync("firebase login", { stdio: "inherit" });
                console.log(chalk.green("✅ Connexion Firebase réussie !"));
              } catch (loginError) {
                console.log(
                  chalk.red(
                    "❌ Échec de la connexion Firebase. Veuillez réessayer."
                  )
                );
                const { retry } = await inquirer.prompt([
                  {
                    type: "confirm",
                    name: "retry",
                    message: "Voulez-vous réessayer la connexion ?",
                    default: true,
                  },
                ]);

                if (!retry) {
                  throw new Error("Configuration annulée par l'utilisateur");
                }
                continue;
              }
            } else {
              const { retry } = await inquirer.prompt([
                {
                  type: "confirm",
                  name: "retry",
                  message: "Voulez-vous réessayer avec un autre ID de projet ?",
                  default: true,
                },
              ]);

              if (!retry) {
                throw new Error("Configuration annulée par l'utilisateur");
              }
              continue;
            }
          } else {
            const { retry } = await inquirer.prompt([
              {
                type: "confirm",
                name: "retry",
                message: "Voulez-vous réessayer avec un autre ID de projet ?",
                default: true,
              },
            ]);

            if (!retry) {
              throw new Error("Configuration annulée par l'utilisateur");
            }
            continue;
          }
        }

        // Maintenant vérifier l'existence du projet
        console.log(
          chalk.blue(`🔍 Vérification du projet ${existingProjectId}...`)
        );
        const projectSpinner = ora("Vérification du projet...").start();

        const projectCheck = await checkFirebaseProject(existingProjectId);
        projectSpinner.stop();

        if (projectCheck.error) {
          console.log(
            chalk.red(
              `❌ Erreur lors de la vérification: ${projectCheck.error}`
            )
          );

          const { retry } = await inquirer.prompt([
            {
              type: "confirm",
              name: "retry",
              message: "Voulez-vous réessayer avec un autre ID de projet ?",
              default: true,
            },
          ]);

          if (!retry) {
            throw new Error("Configuration annulée par l'utilisateur");
          }
          continue;
        }

        if (!projectCheck.exists) {
          console.log(
            chalk.yellow(
              `⚠️  Projet ${existingProjectId} non trouvé dans votre compte Firebase.`
            )
          );

          const { createAnyway } = await inquirer.prompt([
            {
              type: "confirm",
              name: "createAnyway",
              message:
                "Voulez-vous créer ce projet maintenant ou utiliser un autre ID ?",
              default: false,
            },
          ]);

          if (createAnyway) {
            // Basculer vers le mode "générer"
            console.log(
              chalk.yellow("🔄 Basculement vers la création du projet...")
            );
            finalProjectType = "generate";
            projectId = existingProjectId;

            // Demander la région pour le nouveau projet
            console.log(
              chalk.blue(`\n🌍 Configuration de la région pour ${envName}`)
            );
            console.log(
              chalk.gray(
                "💡 Choisissez la région la plus proche de vos utilisateurs pour de meilleures performances"
              )
            );

            const { selectedRegion } = await inquirer.prompt([
              {
                type: "list",
                name: "selectedRegion",
                message: `Région Firebase pour ${envName}:`,
                choices: [
                  {
                    name: "🇺🇸 us-central1 (Iowa) - Recommandé",
                    value: "us-central1",
                  },
                  { name: "🇺🇸 us-east1 (Caroline du Sud)", value: "us-east1" },
                  { name: "🇺🇸 us-west1 (Oregon)", value: "us-west1" },
                  { name: "🇺🇸 us-west2 (Californie)", value: "us-west2" },
                  { name: "🇪🇺 europe-west1 (Belgique)", value: "europe-west1" },
                  { name: "🇪🇺 europe-west2 (Londres)", value: "europe-west2" },
                  {
                    name: "🇪🇺 europe-west3 (Francfort)",
                    value: "europe-west3",
                  },
                  { name: "🇯🇵 asia-east1 (Tokyo)", value: "asia-east1" },
                  {
                    name: "🇯🇵 asia-northeast1 (Osaka)",
                    value: "asia-northeast1",
                  },
                  {
                    name: "🇸🇬 asia-southeast1 (Singapour)",
                    value: "asia-southeast1",
                  },
                ],
                default: "us-central1",
              },
            ]);
            region = selectedRegion;
            break;
          } else {
            continue;
          }
        }

        // Projet trouvé !
        projectId = existingProjectId;
        region = projectCheck.region || "us-central1";
        projectValidated = true;

        console.log(
          chalk.green(`✅ Projet trouvé et configuré automatiquement !`)
        );
        console.log(chalk.blue(`   📍 ID: ${projectId}`));
        console.log(chalk.blue(`   🌍 Région: ${region}`));
      }
    } else {
      // Générer un nouveau projet
      console.log(chalk.yellow("➕ Mode : Génération d'un nouveau projet"));
      console.log(
        chalk.gray(
          "💡 Le projet sera créé automatiquement lors de la première initialisation Firebase"
        )
      );

      const { projectPrefix } = await inquirer.prompt([
        {
          type: "input",
          name: "projectPrefix",
          message: `Préfixe pour le projet ${envName} (ex: monapp → génère monapp-${envName}):`,
          default: "myapp",
          validate: (input: string) => {
            if (!input.trim()) return "Le préfixe est requis";
            if (!/^[a-z0-9-]+$/.test(input)) {
              return "Le préfixe doit contenir uniquement des lettres minuscules, chiffres et tirets";
            }
            return true;
          },
        },
      ]);
      projectId = `${projectPrefix}-${envName}`;

      // Pour un nouveau projet, on demande la région
      console.log(
        chalk.blue(`\n🌍 Configuration de la région pour ${envName}`)
      );
      console.log(
        chalk.gray(
          "💡 Choisissez la région la plus proche de vos utilisateurs pour de meilleures performances"
        )
      );

      const { selectedRegion } = await inquirer.prompt([
        {
          type: "list",
          name: "selectedRegion",
          message: `Région Firebase pour ${envName}:`,
          choices: [
            {
              name: "🇺🇸 us-central1 (Iowa) - Recommandé",
              value: "us-central1",
            },
            { name: "🇺🇸 us-east1 (Caroline du Sud)", value: "us-east1" },
            { name: "🇺🇸 us-west1 (Oregon)", value: "us-west1" },
            { name: "🇺🇸 us-west2 (Californie)", value: "us-west2" },
            { name: "🇪🇺 europe-west1 (Belgique)", value: "europe-west1" },
            { name: "🇪🇺 europe-west2 (Londres)", value: "europe-west2" },
            { name: "🇪🇺 europe-west3 (Francfort)", value: "europe-west3" },
            { name: "🇯🇵 asia-east1 (Tokyo)", value: "asia-east1" },
            { name: "🇯🇵 asia-northeast1 (Osaka)", value: "asia-northeast1" },
            {
              name: "🇸🇬 asia-southeast1 (Singapour)",
              value: "asia-southeast1",
            },
          ],
          default: "us-central1",
        },
      ]);
      region = selectedRegion;

      console.log(chalk.green(`✅ Projet à créer : ${projectId}`));
    }

    envConfigs.push({
      name: envName,
      projectId,
      region,
      variables: {},
      projectType: finalProjectType,
    });

    console.log(
      chalk.green(`\n✅ Environnement "${envName}" configuré avec succès !`)
    );
    console.log(chalk.blue(`   📍 Projet: ${projectId}`));
    if (projectType === "generate") {
      console.log(chalk.blue(`   🌍 Région: ${region}`));
    } else {
      console.log(chalk.blue(`   🔗 Projet existant (région déjà définie)`));
    }
    console.log(chalk.gray("   ──────────────────────────────────────────"));
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
