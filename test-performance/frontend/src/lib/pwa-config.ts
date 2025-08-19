// Configuration PWA pour test-performance
export const PWA_CONFIG = {
  name: 'test-performance',
  shortName: 'test-performance',
  description: 'Test performance',
  startUrl: '/',
  display: 'standalone' as const,
  backgroundColor: '#ffffff',
  themeColor: '#000000',
  scope: '/',
  icons: [
    {
      src: '/icon-192x192.png',
      sizes: '192x192',
      type: 'image/png',
      purpose: 'any maskable'
    },
    {
      src: '/icon-512x512.png',
      sizes: '512x512',
      type: 'image/png',
      purpose: 'any maskable'
    }
  ],
  categories: ['productivity', 'utilities'],
  lang: 'fr',
  dir: 'ltr',
  orientation: 'portrait-primary',
  preferRelatedApplications: false,
  relatedApplications: [],
  screenshots: []
};

// Configuration du Service Worker
export const SW_CONFIG = {
  cacheName: 'test-performance-v1',
  urlsToCache: [
    '/',
    '/offline',
    '/manifest.json',
    '/api/health'
  ],
  maxAge: 7 * 24 * 60 * 60 * 1000, // 7 jours
  strategy: 'cache-first' as const
};

// Configuration des notifications push (FCM)
export const PUSH_CONFIG = {
  vapidKey: process.env.NEXT_PUBLIC_VAPID_KEY || '',
  publicKey: process.env.NEXT_PUBLIC_FCM_PUBLIC_KEY || '',
  supported: typeof window !== 'undefined' && 'serviceWorker' in navigator && 'PushManager' in window
};

// Configuration du cache
export const CACHE_CONFIG = {
  version: '1.0.0',
  strategies: {
    'cache-first': ['/static/', '/images/', '/fonts/'],
    'network-first': ['/api/', '/'],
    'stale-while-revalidate': ['/manifest.json']
  }
}; 