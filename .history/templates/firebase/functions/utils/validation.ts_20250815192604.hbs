export interface ValidationRule {
  field: string;
  required?: boolean;
  type?: 'string' | 'number' | 'boolean' | 'email' | 'url';
  minLength?: number;
  maxLength?: number;
  min?: number;
  max?: number;
  pattern?: RegExp;
  custom?: (value: any) => boolean | string;
}

export interface ValidationResult {
  isValid: boolean;
  errors: string[];
}

export class Validator {
  private rules: ValidationRule[];

  constructor(rules: ValidationRule[]) {
    this.rules = rules;
  }

  validate(data: any): ValidationResult {
    const errors: string[] = [];

    for (const rule of this.rules) {
      const value = data[rule.field];
      const error = this.validateField(value, rule, rule.field);
      
      if (error) {
        errors.push(error);
      }
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  private validateField(value: any, rule: ValidationRule, fieldName: string): string | null {
    // Vérification required
    if (rule.required && (value === undefined || value === null || value === '')) {
      return `Le champ ${fieldName} est requis`;
    }

    // Si la valeur n'est pas définie et pas requise, pas d'erreur
    if (value === undefined || value === null) {
      return null;
    }

    // Vérification du type
    if (rule.type && !this.checkType(value, rule.type)) {
      return `Le champ ${fieldName} doit être de type ${rule.type}`;
    }

    // Vérification de la longueur pour les chaînes
    if (typeof value === 'string') {
      if (rule.minLength && value.length < rule.minLength) {
        return `Le champ ${fieldName} doit contenir au moins ${rule.minLength} caractères`;
      }
      
      if (rule.maxLength && value.length > rule.maxLength) {
        return `Le champ ${fieldName} doit contenir au maximum ${rule.maxLength} caractères`;
      }
    }

    // Vérification des valeurs numériques
    if (typeof value === 'number') {
      if (rule.min !== undefined && value < rule.min) {
        return `Le champ ${fieldName} doit être supérieur ou égal à ${rule.min}`;
      }
      
      if (rule.max !== undefined && value > rule.max) {
        return `Le champ ${fieldName} doit être inférieur ou égal à ${rule.max}`;
      }
    }

    // Vérification du pattern
    if (rule.pattern && typeof value === 'string' && !rule.pattern.test(value)) {
      return `Le champ ${fieldName} ne respecte pas le format attendu`;
    }

    // Vérification personnalisée
    if (rule.custom) {
      const customResult = rule.custom(value);
      if (typeof customResult === 'string') {
        return customResult;
      } else if (!customResult) {
        return `Le champ ${fieldName} n'est pas valide`;
      }
    }

    return null;
  }

  private checkType(value: any, type: string): boolean {
    switch (type) {
      case 'string':
        return typeof value === 'string';
      case 'number':
        return typeof value === 'number' && !isNaN(value);
      case 'boolean':
        return typeof value === 'boolean';
      case 'email':
        return typeof value === 'string' && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
      case 'url':
        try {
          new URL(value);
          return true;
        } catch {
          return false;
        }
      default:
        return true;
    }
  }
}

// Règles de validation communes
export const commonValidationRules = {
  email: (fieldName: string = 'email'): ValidationRule => ({
    field: fieldName,
    required: true,
    type: 'email',
  }),
  
  password: (fieldName: string = 'password'): ValidationRule => ({
    field: fieldName,
    required: true,
    type: 'string',
    minLength: 8,
    pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$/,
    custom: (value) => {
      if (!/(?=.*[a-z])/.test(value)) return 'Le mot de passe doit contenir au moins une minuscule';
      if (!/(?=.*[A-Z])/.test(value)) return 'Le mot de passe doit contenir au moins une majuscule';
      if (!/(?=.*\d)/.test(value)) return 'Le mot de passe doit contenir au moins un chiffre';
      return true;
    },
  }),
  
  required: (fieldName: string): ValidationRule => ({
    field: fieldName,
    required: true,
  }),
}; 