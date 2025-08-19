#!/usr/bin/env node

import { Command } from 'commander';
import { ProjectGenerator } from './generator';
import { ConfigValidator } from './utils/validator';

const program = new Command();

program
  .name('firebase-nextjs-generator')
  .description('Générateur de projets Firebase + Next.js avec App Hosting')
  .version('1.0.0');

program
  .command('create')
  .description('Créer un nouveau projet')
  .requiredOption('--name <name>', 'Nom du projet')
  .requiredOption('--output <output>', 'Répertoire de sortie')
  .option('--yes', 'Mode non-interactif')
  .option('--ui <ui>', 'Framework UI (mui, shadcn)', 'mui')
  .option(
    '--state-management <state>',
    "Gestion d'état (zustand, redux)",
    'zustand'
  )
  .option(
    '--features <features>',
    'Fonctionnalités (pwa,fcm,analytics,performance,sentry)',
    'pwa'
  )
  .action(async options => {
    try {
      const generator = new ProjectGenerator(options);
      await generator.generate();
    } catch (error) {
      console.error('Erreur lors de la génération:', error);
      process.exit(1);
    }
  });

program.parse();
