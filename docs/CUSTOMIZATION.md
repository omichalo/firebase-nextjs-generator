# 🎨 Guide de personnalisation complet

> **Personnalisez le Générateur Firebase + Next.js 2025 selon vos besoins**

## 📋 Table des matières

- [🎯 Vue d'ensemble](#-vue-densemble)
- [🔧 Personnalisation des templates](#-personnalisation-des-templates)
- [🎨 Création de thèmes personnalisés](#-création-de-thèmes-personnalisés)
- [🔌 Développement d'extensions](#-développement-dextensions)
- [⚙️ Configuration avancée](#️-configuration-avancée)
- [🚀 Intégration de nouvelles fonctionnalités](#-intégration-de-nouvelles-fonctionnalités)

## 🎯 Vue d'ensemble

Ce guide vous accompagne dans la personnalisation du générateur pour l'adapter à vos besoins spécifiques, créer vos propres thèmes et étendre ses fonctionnalités.

### 🎯 Objectifs de personnalisation

- **Adaptabilité** : Adapter le générateur à vos standards de code
- **Réutilisabilité** : Créer des templates réutilisables
- **Extensibilité** : Ajouter de nouvelles fonctionnalités
- **Maintenabilité** : Garder le code organisé et maintenable

## 🔧 Personnalisation des templates

### 1. Structure des templates

```
templates/
├── nextjs/                    # Templates Next.js
│   ├── app/                   # App Router
│   ├── components/            # Composants UI
│   ├── hooks/                 # Hooks personnalisés
│   ├── stores/                # Gestion d'état
│   ├── lib/                   # Utilitaires
│   └── tests/                 # Tests
└── firebase/                  # Templates Firebase
    ├── functions/             # Cloud Functions
    ├── firestore/             # Règles et index
    ├── storage/               # Règles de stockage
    └── scripts/               # Scripts de déploiement
```

### 2. Modification d'un template existant

#### **Exemple : Personnaliser le composant Button**

```handlebars
{{!-- templates/nextjs/components/ui/button.tsx.hbs --}}
import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/utils"

const buttonVariants = cva(
  "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline: "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
        {{!-- Ajouter vos variantes personnalisées --}}
        custom: "bg-gradient-to-r from-purple-500 to-pink-500 text-white hover:from-purple-600 hover:to-pink-600",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10",
        {{!-- Ajouter vos tailles personnalisées --}}
        xl: "h-14 px-10 py-4 text-lg",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean
  {{!-- Ajouter vos props personnalisées --}}
  loading?: boolean
  icon?: React.ReactNode
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, loading, icon, children, ...props }, ref) => {
    const Comp = asChild ? Slot : "button"

    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        disabled={loading || props.disabled}
        {...props}
      >
        {{!-- Ajouter l'icône de chargement --}}
        {loading && (
          <svg className="animate-spin -ml-1 mr-3 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        )}

        {{!-- Afficher l'icône personnalisée --}}
        {icon && !loading && <span className="mr-2">{icon}</span>}

        {children}
      </Comp>
    )
  }
)

Button.displayName = "Button"

export { Button, buttonVariants }
```

### 3. Ajouter un nouveau composant

#### **Étape 1 : Créer le template**

```handlebars
{{!-- templates/nextjs/components/ui/avatar.tsx.hbs --}}
import * as React from "react"
import * as AvatarPrimitive from "@radix-ui/react-avatar"
import { cn } from "@/lib/utils"

const Avatar = React.forwardRef<
  React.ElementRef<typeof AvatarPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Root>
>(({ className, ...props }, ref) => (
  <AvatarPrimitive.Root
    ref={ref}
    className={cn(
      "relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full",
      className
    )}
    {...props}
  />
))
Avatar.displayName = AvatarPrimitive.Root.displayName

const AvatarImage = React.forwardRef<
  React.ElementRef<typeof AvatarPrimitive.Image>,
  React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Image>
>(({ className, ...props }, ref) => (
  <AvatarPrimitive.Image
    ref={ref}
    className={cn("aspect-square h-full w-full", className)}
    {...props}
  />
))
AvatarImage.displayName = AvatarPrimitive.Image.displayName

const AvatarFallback = React.forwardRef<
  React.ElementRef<typeof AvatarPrimitive.Fallback>,
  React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Fallback>
>(({ className, ...props }, ref) => (
  <AvatarPrimitive.Fallback
    ref={ref}
    className={cn(
      "flex h-full w-full items-center justify-center rounded-full bg-muted",
      className
    )}
    {...props}
  />
))
AvatarFallback.displayName = AvatarPrimitive.Fallback.displayName

export { Avatar, AvatarImage, AvatarFallback }
```

#### **Étape 2 : Modifier le générateur**

```typescript
// src/generators/nextjs-generator.ts

async generateComponents(): Promise<void> {
  // ... code existant ...

  // Ajouter le nouveau composant Avatar
  await this.copyTemplateFile(
    "nextjs/components/ui/avatar.tsx.hbs",
    path.join(outputDir, "components/ui/avatar.tsx")
  );

  // ... code existant ...
}
```

#### **Étape 3 : Ajouter les dépendances**

```json
// templates/nextjs/package.json.hbs
{
  "dependencies": {
    // ... dépendances existantes ...
    "@radix-ui/react-avatar": "^1.0.0"
  }
}
```

### 4. Personnaliser les hooks

#### **Exemple : Hook de gestion des formulaires**

```handlebars
{{!-- templates/nextjs/hooks/forms/use-form.ts.hbs --}}
import { useState, useCallback } from 'react';

export interface FormField {
  name: string;
  value: any;
  error?: string;
  touched: boolean;
}

export interface UseFormOptions<T> {
  initialValues: T;
  validationSchema?: (values: T) => Record<string, string>;
  onSubmit: (values: T) => Promise<void> | void;
}

export function useForm<T extends Record<string, any>>({
  initialValues,
  validationSchema,
  onSubmit,
}: UseFormOptions<T>) {
  const [values, setValues] = useState<T>(initialValues);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [touched, setTouched] = useState<Record<string, boolean>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const setValue = useCallback((name: keyof T, value: any) => {
    setValues(prev => ({ ...prev, [name]: value }));

    // Réinitialiser l'erreur du champ
    if (errors[name as string]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
  }, [errors]);

  const setFieldTouched = useCallback((name: keyof T) => {
    setTouched(prev => ({ ...prev, [name]: true }));
  }, []);

  const validate = useCallback(() => {
    if (!validationSchema) return true;

    const validationErrors = validationSchema(values);
    setErrors(validationErrors);

    return Object.keys(validationErrors).length === 0;
  }, [values, validationSchema]);

  const handleSubmit = useCallback(async (e?: React.FormEvent) => {
    e?.preventDefault();

    if (!validate()) return;

    setIsSubmitting(true);
    try {
      await onSubmit(values);
    } catch (error) {
      console.error('Erreur lors de la soumission:', error);
    } finally {
      setIsSubmitting(false);
    }
  }, [values, validate, onSubmit]);

  const reset = useCallback(() => {
    setValues(initialValues);
    setErrors({});
    setTouched({});
  }, [initialValues]);

  return {
    values,
    errors,
    touched,
    isSubmitting,
    setValue,
    setFieldTouched,
    handleSubmit,
    reset,
  };
}
```

## 🎨 Création de thèmes personnalisés

### 1. Structure d'un thème

```typescript
// src/types/index.ts

export interface ThemeConfig {
  name: string;
  version: string;
  description: string;
  author: string;
  category: "business" | "portfolio" | "ecommerce" | "blog" | "dashboard";
  tags: string[];
  files: string[];
  dependencies: string[];
  config: {
    colors: {
      primary: string;
      secondary: string;
      accent: string;
      background: string;
      foreground: string;
    };
    fonts: {
      heading: string;
      body: string;
    };
    spacing: {
      xs: string;
      sm: string;
      md: string;
      lg: string;
      xl: string;
    };
  };
}
```

### 2. Exemple de thème : Dashboard Business

```typescript
// themes/business-dashboard/theme.json
{
  "name": "business-dashboard",
  "version": "1.0.0",
  "description": "Thème professionnel pour tableaux de bord d'entreprise",
  "author": "Votre Nom",
  "category": "dashboard",
  "tags": ["business", "dashboard", "professional", "corporate"],
  "files": [
    "components/dashboard/Sidebar.tsx",
    "components/dashboard/Header.tsx",
    "components/dashboard/StatsCard.tsx",
    "components/dashboard/Chart.tsx",
    "components/dashboard/DataTable.tsx",
    "layouts/DashboardLayout.tsx",
    "pages/dashboard/index.tsx",
    "pages/dashboard/analytics.tsx",
    "pages/dashboard/users.tsx",
    "styles/dashboard.css"
  ],
  "dependencies": [
    "recharts",
    "react-table",
    "date-fns",
    "lucide-react"
  ],
  "config": {
    "colors": {
      "primary": "#1e40af",
      "secondary": "#64748b",
      "accent": "#f59e0b",
      "background": "#f8fafc",
      "foreground": "#0f172a"
    },
    "fonts": {
      "heading": "Inter, system-ui, sans-serif",
      "body": "Inter, system-ui, sans-serif"
    },
    "spacing": {
      "xs": "0.25rem",
      "sm": "0.5rem",
      "md": "1rem",
      "lg": "1.5rem",
      "xl": "2rem"
    }
  }
}
```

### 3. Composants du thème

#### **Sidebar personnalisée**

```handlebars
{{!-- themes/business-dashboard/components/dashboard/Sidebar.tsx.hbs --}}
import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { cn } from '@/lib/utils';
import {
  HomeIcon,
  ChartBarIcon,
  UsersIcon,
  CogIcon,
  DocumentTextIcon,
} from '@heroicons/react/24/outline';

const navigation = [
  { name: 'Tableau de bord', href: '/dashboard', icon: HomeIcon },
  { name: 'Analytics', href: '/dashboard/analytics', icon: ChartBarIcon },
  { name: 'Utilisateurs', href: '/dashboard/users', icon: UsersIcon },
  { name: 'Documents', href: '/dashboard/documents', icon: DocumentTextIcon },
  { name: 'Paramètres', href: '/dashboard/settings', icon: CogIcon },
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <div className="flex h-full w-64 flex-col bg-white border-r border-gray-200">
      <div className="flex h-16 items-center justify-center border-b border-gray-200">
        <h1 className="text-xl font-bold text-gray-900">{{project.name}}</h1>
      </div>

      <nav className="flex-1 space-y-1 px-2 py-4">
        {navigation.map((item) => {
          const isActive = pathname === item.href;
          return (
            <Link
              key={item.name}
              href={item.href}
              className={cn(
                'group flex items-center px-2 py-2 text-sm font-medium rounded-md',
                isActive
                  ? 'bg-blue-100 text-blue-900'
                  : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
              )}
            >
              <item.icon
                className={cn(
                  'mr-3 h-5 w-5 flex-shrink-0',
                  isActive ? 'text-blue-500' : 'text-gray-400 group-hover:text-gray-500'
                )}
              />
              {item.name}
            </Link>
          );
        })}
      </nav>
    </div>
  );
}
```

#### **Layout du tableau de bord**

```handlebars
{{! themes/business-dashboard/layouts/DashboardLayout.tsx.hbs }}
import React from 'react'; import { Sidebar } from
'@/components/dashboard/Sidebar'; import { Header } from
'@/components/dashboard/Header'; interface DashboardLayoutProps { children:
React.ReactNode; } export function DashboardLayout({ children }:
DashboardLayoutProps) { return (
<div className="flex h-screen bg-gray-50">
  <Sidebar />
  <div className="flex flex-1 flex-col overflow-hidden">
    <Header />
    <main className="flex-1 overflow-y-auto p-6">
      {children}
    </main>
  </div>
</div>
); }
```

### 4. Intégration du thème dans le générateur

```typescript
// src/generators/theme-generator.ts

export class ThemeGenerator extends BaseGenerator {
  async generateTheme(theme: ThemeConfig): Promise<void> {
    const themeDir = path.join(this.options.templateDir, "themes", theme.name);
    const outputDir = path.join(this.options.outputDir, "themes", theme.name);

    // Créer le répertoire de sortie
    await fs.ensureDir(outputDir);

    // Copier tous les fichiers du thème
    for (const file of theme.files) {
      const sourcePath = path.join(themeDir, file);
      const targetPath = path.join(outputDir, file);

      if (await fs.pathExists(sourcePath)) {
        await this.copyTemplateFile(sourcePath, targetPath);
      }
    }

    // Générer le fichier de configuration du thème
    await this.generateThemeConfig(theme, outputDir);

    // Mettre à jour package.json avec les dépendances du thème
    await this.updatePackageJson(theme, outputDir);
  }

  private async generateThemeConfig(
    theme: ThemeConfig,
    outputDir: string
  ): Promise<void> {
    const configContent = JSON.stringify(theme, null, 2);
    await fs.writeFile(path.join(outputDir, "theme.json"), configContent);
  }

  private async updatePackageJson(
    theme: ThemeConfig,
    outputDir: string
  ): Promise<void> {
    const packageJsonPath = path.join(outputDir, "package.json");

    if (await fs.pathExists(packageJsonPath)) {
      const packageJson = JSON.parse(
        await fs.readFile(packageJsonPath, "utf-8")
      );

      // Ajouter les dépendances du thème
      for (const dep of theme.dependencies) {
        if (!packageJson.dependencies[dep]) {
          packageJson.dependencies[dep] = "latest";
        }
      }

      await fs.writeFile(packageJsonPath, JSON.stringify(packageJson, null, 2));
    }
  }
}
```

## 🔌 Développement d'extensions

### 1. Structure d'une extension

```yaml
# extensions/my-extension/extension.yaml
name: my-extension
version: 1.0.0
specVersion: v1beta

displayName: Mon Extension
description: Description de mon extension personnalisée

author:
  authorName: Votre Nom
  url: https://github.com/your-username

license: Apache-2.0

roles:
  - role: firebaseauth.admin
    reason: Gestion des utilisateurs

resources:
  - name: my-extension-function
    type: firebaseextensions.v1beta.function
    description: Fonction Cloud pour mon extension
    properties:
      runtime: nodejs20
      location: us-central1
      httpsTrigger: {}

params:
  - param: PARAM1
    label: Paramètre 1
    description: Description du paramètre
    type: string
    default: "valeur_par_défaut"
    required: false

  - param: PARAM2
    label: Paramètre 2
    description: Description du paramètre 2
    type: select
    options:
      - label: Option 1
        value: "option1"
      - label: Option 2
        value: "option2"
    default: "option1"
    required: true
```

### 2. Fonction de l'extension

```typescript
// extensions/my-extension/functions/src/index.ts
import * as functions from "firebase-functions";
import { defineString } from "firebase-functions/params";

// Paramètres de l'extension
const param1 = defineString("PARAM1");
const param2 = defineString("PARAM2");

export const myExtensionFunction = functions.https.onRequest((req, res) => {
  try {
    // Logique de votre extension
    const result = {
      message: "Extension exécutée avec succès",
      param1: param1.value(),
      param2: param2.value(),
      timestamp: new Date().toISOString(),
    };

    res.status(200).json(result);
  } catch (error) {
    console.error("Erreur dans l'extension:", error);
    res.status(500).json({ error: "Erreur interne" });
  }
});
```

### 3. Intégration dans le générateur

```typescript
// src/generators/firebase-generator.ts

async generateExtensions(): Promise<void> {
  for (const extension of this.options.firebase.extensions) {
    await this.generateExtension(extension);
  }
}

private async generateExtension(extension: FirebaseExtension): Promise<void> {
  const extensionDir = path.join(this.options.templateDir, 'extensions', extension.name);
  const outputDir = path.join(this.options.outputDir, 'extensions', extension.name);

  // Créer le répertoire de sortie
  await fs.ensureDir(outputDir);

  // Copier les fichiers de l'extension
  await this.copyTemplateDirectory(extensionDir, outputDir);

  // Traiter les templates avec le contexte de l'extension
  await this.processExtensionTemplates(extension, outputDir);

  // Installer l'extension
  await this.installExtension(extension, outputDir);
}

private async processExtensionTemplates(extension: FirebaseExtension, outputDir: string): Promise<void> {
  const context = {
    ...this.options,
    extension,
  };

  // Traiter tous les fichiers .hbs
  const files = await glob('**/*.hbs', { cwd: outputDir });

  for (const file of files) {
    const filePath = path.join(outputDir, file);
    const template = await fs.readFile(filePath, 'utf-8');
    const processed = this.templateEngine.processTemplate(template, context);

    // Remplacer l'extension .hbs
    const targetPath = filePath.replace('.hbs', '');
    await fs.writeFile(targetPath, processed);
    await fs.remove(filePath);
  }
}

private async installExtension(extension: FirebaseExtension, outputDir: string): Promise<void> {
  try {
    // Installer l'extension avec Firebase CLI
    const { execSync } = require('child_process');
    execSync(`firebase ext:install ${extension.name} --local`, {
      cwd: outputDir,
      stdio: 'inherit',
    });

    console.log(`✅ Extension ${extension.name} installée avec succès`);
  } catch (error) {
    console.error(`❌ Erreur lors de l'installation de l'extension ${extension.name}:`, error);
  }
}
```

## ⚙️ Configuration avancée

### 1. Configuration personnalisée du générateur

```typescript
// src/config/generator-config.ts

export interface GeneratorConfig {
  templates: {
    nextjs: {
      components: string[];
      hooks: string[];
      stores: string[];
      pages: string[];
    };
    firebase: {
      functions: string[];
      triggers: string[];
      extensions: string[];
    };
  };
  features: {
    pwa: boolean;
    fcm: boolean;
    analytics: boolean;
    performance: boolean;
    sentry: boolean;
    testing: boolean;
    linting: boolean;
  };
  defaults: {
    ui: "mui" | "shadcn";
    stateManagement: "zustand" | "redux";
    testing: "jest" | "vitest";
    linting: "eslint" | "biome";
  };
}

export const defaultConfig: GeneratorConfig = {
  templates: {
    nextjs: {
      components: ["Button", "Card", "Input", "Modal"],
      hooks: ["useAuth", "useForm", "useLocalStorage"],
      stores: ["authStore", "uiStore"],
      pages: ["index", "auth/login", "auth/register"],
    },
    firebase: {
      functions: ["auth", "firestore", "storage"],
      triggers: ["user-created", "document-updated"],
      extensions: ["firebase-auth-ui"],
    },
  },
  features: {
    pwa: true,
    fcm: true,
    analytics: true,
    performance: true,
    sentry: true,
    testing: true,
    linting: true,
  },
  defaults: {
    ui: "mui",
    stateManagement: "zustand",
    testing: "jest",
    linting: "eslint",
  },
};
```

### 2. Validation personnalisée

```typescript
// src/utils/custom-validator.ts

export class CustomValidator {
  static validateProjectName(name: string): ValidationResult {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Vérifications personnalisées
    if (name.length < 3) {
      errors.push("Le nom du projet doit contenir au moins 3 caractères");
    }

    if (name.length > 50) {
      errors.push("Le nom du projet ne peut pas dépasser 50 caractères");
    }

    if (!/^[a-z0-9-]+$/.test(name)) {
      errors.push(
        "Le nom du projet ne peut contenir que des lettres minuscules, chiffres et tirets"
      );
    }

    // Vérifications de mots réservés
    const reservedWords = ["admin", "api", "app", "www", "mail", "ftp"];
    if (reservedWords.includes(name.toLowerCase())) {
      warnings.push(
        `Le nom "${name}" est un mot réservé, évitez de l'utiliser`
      );
    }

    return { isValid: errors.length === 0, errors, warnings };
  }

  static validateFirebaseConfig(config: FirebaseConfig): ValidationResult {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Vérifications personnalisées
    if (config.environments.length === 0) {
      errors.push("Au moins un environnement est requis");
    }

    // Vérifier les noms d'environnement
    const validEnvNames = ["dev", "staging", "prod", "test"];
    for (const env of config.environments) {
      if (!validEnvNames.includes(env.name)) {
        warnings.push(`Nom d'environnement non standard: ${env.name}`);
      }
    }

    // Vérifier les régions
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

    for (const env of config.environments) {
      if (env.region && !validRegions.includes(env.region)) {
        warnings.push(`Région non standard pour ${env.name}: ${env.region}`);
      }
    }

    return { isValid: errors.length === 0, errors, warnings };
  }
}
```

### 3. Hooks personnalisés du générateur

```typescript
// src/hooks/generator-hooks.ts

export interface GeneratorHooks {
  beforeGeneration?: (options: GeneratorOptions) => Promise<void>;
  afterGeneration?: (outputDir: string) => Promise<void>;
  beforeTemplateProcessing?: (template: string, context: any) => string;
  afterTemplateProcessing?: (processedTemplate: string, context: any) => string;
  onError?: (error: Error, context: any) => void;
}

export class HookManager {
  private hooks: GeneratorHooks = {};

  registerHooks(hooks: GeneratorHooks): void {
    this.hooks = { ...this.hooks, ...hooks };
  }

  async executeBeforeGeneration(options: GeneratorOptions): Promise<void> {
    if (this.hooks.beforeGeneration) {
      await this.hooks.beforeGeneration(options);
    }
  }

  async executeAfterGeneration(outputDir: string): Promise<void> {
    if (this.hooks.afterGeneration) {
      await this.hooks.afterGeneration(outputDir);
    }
  }

  processTemplateBefore(template: string, context: any): string {
    if (this.hooks.beforeTemplateProcessing) {
      return this.hooks.beforeTemplateProcessing(template, context);
    }
    return template;
  }

  processTemplateAfter(processedTemplate: string, context: any): string {
    if (this.hooks.afterTemplateProcessing) {
      return this.hooks.afterTemplateProcessing(processedTemplate, context);
    }
    return processedTemplate;
  }

  handleError(error: Error, context: any): void {
    if (this.hooks.onError) {
      this.hooks.onError(error, context);
    } else {
      console.error("Erreur du générateur:", error);
    }
  }
}
```

## 🚀 Intégration de nouvelles fonctionnalités

### 1. Ajouter un nouveau type de projet

```typescript
// src/types/index.ts

export type ProjectType = "web" | "mobile" | "desktop" | "api" | "fullstack";

export interface ProjectConfig {
  name: string;
  description: string;
  version: string;
  author: string;
  type: ProjectType;
  // ... autres propriétés
}
```

### 2. Générateur pour applications mobiles

```typescript
// src/generators/mobile-generator.ts

export class MobileGenerator extends BaseGenerator {
  async generateMobileApp(): Promise<void> {
    const outputDir = path.join(this.options.outputDir, "mobile");

    // Créer la structure React Native
    await this.generateReactNativeStructure(outputDir);

    // Générer les composants mobiles
    await this.generateMobileComponents(outputDir);

    // Configurer Firebase pour mobile
    await this.configureFirebaseMobile(outputDir);

    // Configurer les tests mobiles
    await this.configureMobileTesting(outputDir);
  }

  private async generateReactNativeStructure(outputDir: string): Promise<void> {
    // Créer package.json pour React Native
    const packageJson = {
      name: this.options.project.name,
      version: this.options.project.version,
      scripts: {
        android: "react-native run-android",
        ios: "react-native run-ios",
        start: "react-native start",
        test: "jest",
      },
      dependencies: {
        "react-native": "0.72.0",
        react: "18.2.0",
        "react-dom": "18.2.0",
        "@react-navigation/native": "6.1.0",
        "@react-navigation/stack": "6.3.0",
        "react-native-firebase": "18.0.0",
      },
    };

    await fs.writeFile(
      path.join(outputDir, "package.json"),
      JSON.stringify(packageJson, null, 2)
    );
  }
}
```

### 3. Intégration dans le CLI

```typescript
// src/cli.ts

async function promptForProjectType(): Promise<ProjectType> {
  const { projectType } = await inquirer.prompt([
    {
      type: "list",
      name: "projectType",
      message: "Type de projet:",
      choices: [
        { name: "🌐 Application Web (Next.js)", value: "web" },
        { name: "📱 Application Mobile (React Native)", value: "mobile" },
        { name: "🖥️ Application Desktop (Electron)", value: "desktop" },
        { name: "🔌 API Backend (Node.js)", value: "api" },
        { name: "🚀 Full Stack (Web + Mobile + API)", value: "fullstack" },
      ],
    },
  ]);

  return projectType;
}

async function generateProject(options: GeneratorOptions): Promise<void> {
  const generator = new Generator(options);

  // Ajouter des hooks personnalisés
  generator.registerHooks({
    beforeGeneration: async (opts) => {
      console.log("🚀 Début de la génération...");
      // Logique personnalisée avant génération
    },
    afterGeneration: async (outputDir) => {
      console.log("✅ Génération terminée!");
      // Logique personnalisée après génération
    },
  });

  await generator.generate();
}
```

## ✅ Checklist de personnalisation

### Templates

- [ ] Composants UI personnalisés créés
- [ ] Hooks personnalisés implémentés
- [ ] Stores de gestion d'état adaptés
- [ ] Pages et layouts personnalisés
- [ ] Tests pour les composants personnalisés

### Thèmes

- [ ] Structure du thème définie
- [ ] Composants du thème créés
- [ ] Configuration du thème implémentée
- [ ] Intégration dans le générateur
- [ ] Documentation du thème

### Extensions

- [ ] Structure de l'extension définie
- [ ] Fonctionnalités de l'extension implémentées
- [ ] Configuration de l'extension
- [ ] Tests de l'extension
- [ ] Documentation de l'extension

### Configuration

- [ ] Configuration personnalisée implémentée
- [ ] Validation personnalisée ajoutée
- [ ] Hooks du générateur configurés
- [ ] Tests de la configuration
- [ ] Documentation de la configuration

## 🎉 Félicitations !

Vous avez maintenant un générateur personnalisé et extensible qui répond parfaitement à vos besoins !

**Prochaines étapes :**

- [Guide des bonnes pratiques](BEST_PRACTICES.md) 📚
- [Guide de maintenance](MAINTENANCE.md) 🔧
- [Guide de contribution](CONTRIBUTING.md) 🤝

---

**💡 Astuce :** Commencez par personnaliser les templates existants avant de créer de nouveaux composants !
