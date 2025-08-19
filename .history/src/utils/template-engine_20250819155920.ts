import * as fs from 'fs-extra';
import * as path from 'path';
import * as glob from 'glob';
import Handlebars from 'handlebars';
import { TemplateContext, GeneratorOptions } from '../types';

export class TemplateEngine {
  private context: TemplateContext;

  constructor(options: GeneratorOptions) {
    this.context = this.buildContext(options);
    this.registerHelpers();
  }

  private buildContext(options: GeneratorOptions): TemplateContext {
    return {
      project: options.project,
      firebase: options.firebase,
      nextjs: options.nextjs,
      cloudFunctions: options.cloudFunctions,
      firestore: options.firestore,
      themes: options.themes,
      outputDir: options.outputDir,
      // Variables supplémentaires pour les templates
      version: options.project.version,
      functionName: 'defaultFunction',
      envName: 'dev',
      timestamp: new Date().toISOString(),
      year: new Date().getFullYear(),
    };
  }

  private registerHelpers(): void {
    // Helper pour la casse camelCase
    Handlebars.registerHelper('camelCase', (str: string) => {
      return typeof str === 'string'
        ? str.replace(/-([a-z])/g, g => (g && g[1] ? g[1].toUpperCase() : ''))
        : str;
    });

    // Helper pour la casse PascalCase
    Handlebars.registerHelper('pascalCase', (str: string) => {
      return typeof str === 'string'
        ? str.replace(/(^|-)([a-z])/g, g =>
            g && g[2] ? g[2].toUpperCase() : ''
          )
        : str;
    });

    // Helper pour la casse kebab-case
    Handlebars.registerHelper('kebabCase', (str: string) => {
      return typeof str === 'string'
        ? str.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase()
        : str;
    });

    // Helper pour les conditions
    Handlebars.registerHelper(
      'ifEquals',
      function (this: any, arg1: any, arg2: any, options: any) {
        return arg1 === arg2 ? options.fn(this) : options.inverse(this);
      }
    );

    // Helper pour les conditions multiples
    Handlebars.registerHelper(
      'ifIn',
      function (this: any, elem: any, list: any[], options: any) {
        return list.includes(elem) ? options.fn(this) : options.inverse(this);
      }
    );

    // Helper pour l'indentation
    Handlebars.registerHelper(
      'indent',
      function (this: any, level: number, options: any) {
        const spaces = '  '.repeat(level);
        return options
          .fn(this)
          .split('\n')
          .map((line: string) => spaces + line)
          .join('\n');
      }
    );

    // Helper pour les variables d'environnement
    Handlebars.registerHelper(
      'envVar',
      function (key: string, defaultValue?: string) {
        return process.env[key] || defaultValue || '';
      }
    );

    // Helper pour les imports conditionnels
    Handlebars.registerHelper(
      'importIf',
      function (
        this: any,
        condition: boolean,
        importPath: string,
        options: any
      ) {
        return condition
          ? `import ${options.fn(this)} from '${importPath}';`
          : '';
      }
    );
  }

  compileTemplate(templateContent: string): HandlebarsTemplateDelegate<any> {
    return Handlebars.compile(templateContent);
  }

  async processTemplate(
    templatePath: string,
    outputPath: string,
    context?: Partial<TemplateContext>
  ): Promise<void> {
    try {
      // Lire le template
      const templateContent = await fs.readFile(templatePath, 'utf-8');

      // Compiler le template
      const template = Handlebars.compile(templateContent);

      // Fusionner les contextes
      const finalContext = { ...this.context, ...context };

      // Rendre le template
      const renderedContent = template(finalContext);

      // Créer le répertoire de sortie si nécessaire
      await fs.ensureDir(path.dirname(outputPath));

      // Écrire le fichier
      await fs.writeFile(outputPath, renderedContent, 'utf-8');
    } catch (error) {
      throw new Error(
        `Erreur lors du traitement du template ${templatePath}: ${error}`
      );
    }
  }

  async processDirectory(
    templateDir: string,
    outputDir: string,
    context?: Partial<TemplateContext>
  ): Promise<void> {
    try {
      // Trouver tous les fichiers template
      const templateFiles = glob.sync('**/*', {
        cwd: templateDir,
        nodir: true,
        ignore: [
          '**/node_modules/**',
          '**/.git/**',
          '**/dist/**',
          '**/build/**',
        ],
      });

      for (const templateFile of templateFiles) {
        const templatePath = path.join(templateDir, templateFile);
        const outputPath = path.join(outputDir, templateFile);

        // Vérifier si c'est un fichier binaire
        const stats = await fs.stat(templatePath);
        if (stats.isFile()) {
          if (this.isBinaryFile(templatePath)) {
            // Copier directement les fichiers binaires
            await fs.copy(templatePath, outputPath);
          } else {
            // Traiter les fichiers texte avec Handlebars
            // Enlever l'extension .hbs pour les fichiers de sortie
            const cleanOutputPath = outputPath.replace(/\.hbs$/, '');
            await this.processTemplate(templatePath, cleanOutputPath, context);
          }
        }
      }
    } catch (error) {
      throw new Error(
        `Erreur lors du traitement du répertoire ${templateDir}: ${error}`
      );
    }
  }

  private isBinaryFile(filePath: string): boolean {
    const binaryExtensions = [
      '.png',
      '.jpg',
      '.jpeg',
      '.gif',
      '.svg',
      '.ico',
      '.woff',
      '.woff2',
      '.ttf',
      '.eot',
      '.mp4',
      '.mp3',
      '.wav',
      '.avi',
      '.zip',
      '.tar',
      '.gz',
      '.rar',
      '.pdf',
      '.doc',
      '.docx',
      '.xls',
      '.xlsx',
    ];

    const ext = path.extname(filePath).toLowerCase();
    return binaryExtensions.includes(ext);
  }

  async processConditionalTemplates(
    templateDir: string,
    outputDir: string,
    conditions: Record<string, boolean>,
    context?: Partial<TemplateContext>
  ): Promise<void> {
    try {
      const templateFiles = glob.sync('**/*', {
        cwd: templateDir,
        nodir: true,
        ignore: [
          '**/node_modules/**',
          '**/.git/**',
          '**/dist/**',
          '**/build/**',
        ],
      });

      for (const templateFile of templateFiles) {
        // Vérifier les conditions pour ce fichier
        const shouldProcess = this.checkFileConditions(
          templateFile,
          conditions
        );

        if (shouldProcess) {
          const templatePath = path.join(templateDir, templateFile);
          const outputPath = path.join(outputDir, templateFile);

          const stats = await fs.stat(templatePath);
          if (stats.isFile()) {
            if (this.isBinaryFile(templatePath)) {
              await fs.copy(templatePath, outputPath);
            } else {
              await this.processTemplate(templatePath, outputPath, context);
            }
          }
        }
      }
    } catch (error) {
      throw new Error(
        `Erreur lors du traitement des templates conditionnels: ${error}`
      );
    }
  }

  private checkFileConditions(
    templateFile: string,
    conditions: Record<string, boolean>
  ): boolean {
    // Vérifier si le fichier correspond à une condition
    for (const [condition, enabled] of Object.entries(conditions)) {
      if (enabled && templateFile.includes(condition)) {
        return true;
      }
      if (!enabled && templateFile.includes(condition)) {
        return false;
      }
    }
    return true; // Par défaut, traiter le fichier
  }
}
