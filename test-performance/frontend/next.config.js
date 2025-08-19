/** @type {import('next').Config} */
const nextConfig = {
  // Configuration pour Firebase App Hosting (avec API routes)
  experimental: {
    appDir: true,
  },
  // Configuration PWA
  async headers() {
    return [
      {
        source: '/sw.js',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=0, must-revalidate',
          },
        ],
      },
    ];
  },
  // Configuration des images
  images: {
    domains: ['firebasestorage.googleapis.com'],
  },
  // Configuration TypeScript
  typescript: {
    ignoreBuildErrors: false,
  },
  // Configuration ESLint
  eslint: {
    ignoreDuringBuilds: false,
  },
};

module.exports = nextConfig; 