import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

// Initialize Firebase Admin
admin.initializeApp()

// Import auth triggers
import { onUserCreated } from './auth/user-created'
import { onUserDeleted } from './auth/user-deleted'
import { onUserCreated } from './auth/user-created'
import { onUserDeleted } from './auth/user-deleted'

// Import Firestore triggers

// Import HTTP functions
import { healthCheck } from './https/health'
import { apiHandler } from './https/api'

// Import scheduled functions
import { dailyCleanup } from './scheduled/dailyCleanup'

// Export auth triggers
export const userCreated = onUserCreated
export const userDeleted = onUserDeleted

// Export Firestore triggers

// Export HTTP functions
export const health = healthCheck
export const api = apiHandler

// Export scheduled functions
export const dailyCleanupScheduled = functions.pubsub
  .schedule('0 2 * * *')
  .timeZone('UTC')
  .onRun(dailyCleanup)
