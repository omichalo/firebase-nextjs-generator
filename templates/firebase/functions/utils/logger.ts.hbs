import * as functions from 'firebase-functions';

export interface LogLevel {
  DEBUG: 'debug';
  INFO: 'info';
  WARN: 'warn';
  ERROR: 'error';
}

export const LOG_LEVELS: LogLevel = {
  DEBUG: 'debug',
  INFO: 'info',
  WARN: 'warn',
  ERROR: 'error',
};

export class Logger {
  private context: string;
  private functionName: string;

  constructor(context: string, functionName: string) {
    this.context = context;
    this.functionName = functionName;
  }

  private formatMessage(level: string, message: string, data?: any): string {
    const timestamp = new Date().toISOString();
    const baseMessage = `[${timestamp}] [${level.toUpperCase()}] [${this.context}] [${this.functionName}] ${message}`;
    
    if (data) {
      return `${baseMessage} | Data: ${JSON.stringify(data)}`;
    }
    
    return baseMessage;
  }

  debug(message: string, data?: any): void {
    if (process.env.NODE_ENV === 'development') {
      console.log(this.formatMessage(LOG_LEVELS.DEBUG, message, data));
    }
  }

  info(message: string, data?: any): void {
    console.log(this.formatMessage(LOG_LEVELS.INFO, message, data));
  }

  warn(message: string, data?: any): void {
    console.warn(this.formatMessage(LOG_LEVELS.WARN, message, data));
  }

  error(message: string, error?: any): void {
    console.error(this.formatMessage(LOG_LEVELS.ERROR, message, error));
    
    // Log dans Firestore pour le monitoring
    if (process.env.NODE_ENV === 'production') {
      this.logErrorToFirestore(message, error);
    }
  }

  private async logErrorToFirestore(message: string, error: any): Promise<void> {
    try {
      const { db } = await import('../admin');
      
      await db.collection('error_logs').add({
        context: this.context,
        functionName: this.functionName,
        message: message,
        error: error?.message || error,
        stack: error?.stack,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        environment: process.env.NODE_ENV || 'development',
      });
    } catch (logError) {
      console.error('Erreur lors de la sauvegarde du log d\'erreur:', logError);
    }
  }
}

export function createLogger(context: string, functionName: string): Logger {
  return new Logger(context, functionName);
} 