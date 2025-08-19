import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

import { MUIWrapper } from '@/components/MUIWrapper'

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'


const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'test-mui-only',
  description: 'Test MUI uniquement sans Shadcn',
  manifest: '/manifest.json',
}

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60 * 1000,
    },
  },
})

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className={inter.className}>
        <QueryClientProvider client={queryClient}>
        <MUIWrapper>
          {children}
        </MUIWrapper>
        </QueryClientProvider>
      </body>
    </html>
  )
} 