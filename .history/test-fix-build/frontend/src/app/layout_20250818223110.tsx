import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';

import { MUIWrapper } from '@/components/MUIWrapper';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'test-fix-build',
  description: 'Test project',
  manifest: '/manifest.json',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body className={inter.className}>
        <MUIWrapper>{children}</MUIWrapper>
      </body>
    </html>
  );
}
