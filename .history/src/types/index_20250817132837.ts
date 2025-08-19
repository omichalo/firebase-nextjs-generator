export interface ProjectConfig {
  name: string;
  description: string;
  author: string;
  version: string;
  license: string;
  packageManager: 'npm' | 'yarn' | 'pnpm';
}

export interface FirebaseConfig {
  projectId?: string;
  region?: string;
  environments: Environment[];
  extensions: FirebaseExtension[];
}

export interface Environment {
  name: string;
  projectId: string;
  region: string;
  variables: Record<string, string>;
}

export interface FirebaseExtension {
  name: string;
  version: string;
  config: Record<string, any>;
}

export interface NextJSConfig {
  version: string;
  appRouter: boolean;
  typescript: boolean;
  strictMode: boolean;
  ui: 'mui' | 'shadcn' | 'both';
  stateManagement: 'zustand' | 'redux' | 'both';
  features: {
    pwa: boolean;
    fcm: boolean;
    analytics: boolean;
    performance: boolean;
    sentry: boolean;
  };
}

export interface CloudFunctionsConfig {
  runtime: string;
  region: string;
  triggers: FunctionTrigger[];
  scheduled: ScheduledFunction[];
}

export interface FunctionTrigger {
  name: string;
  type: 'auth' | 'firestore' | 'storage' | 'https';
  event: string;
  path?: string;
}

export interface ScheduledFunction {
  name: string;
  schedule: string;
  timeZone: string;
}

export interface FirestoreConfig {
  rules: string;
  indexes: string;
  migrations: Migration[];
}

export interface Migration {
  version: number;
  description: string;
  up: string;
  down: string;
}

export interface ThemeConfig {
  name: string;
  type: 'mui' | 'shadcn' | 'custom';
  variables: Record<string, string>;
  darkMode: boolean;
}

export interface GeneratorOptions {
  project: ProjectConfig;
  firebase: FirebaseConfig;
  nextjs: NextJSConfig;
  cloudFunctions: CloudFunctionsConfig;
  firestore: FirestoreConfig;
  themes: ThemeConfig[];
  outputDir: string;
  templateDir: string;
}

export interface TemplateContext {
  project: ProjectConfig;
  firebase: FirebaseConfig;
  nextjs: NextJSConfig;
  outputDir: string;
  cloudFunctions: CloudFunctionsConfig;
  firestore: FirestoreConfig;
  themes: ThemeConfig[];
  timestamp: string;
  year: number;
  environment?: Environment;
  migration?: Migration;
  extension?: FirebaseExtension;
}

export interface ValidationResult {
  valid: boolean;
  errors: string[];
  warnings: string[];
}
