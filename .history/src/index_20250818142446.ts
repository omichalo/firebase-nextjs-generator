import * as functions from 'firebase-functions';

// Export basic functions for testing
export const helloWorld = functions.https.onRequest((request, response) => {
  response.json({ message: 'Hello from Firebase Functions!' });
});

export const healthCheck = functions.https.onRequest((request, response) => {
  response.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
  });
});

// Export scheduled function for testing
export const scheduledFunction = functions.pubsub
  .schedule('every 24 hours')
  .timeZone('UTC')
  .onRun(async context => {
    console.log('Scheduled function executed at:', new Date().toISOString());
    return null;
  });
