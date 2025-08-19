'use client';

import { ReactNode, useState } from 'react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { MUIWrapper } from '@/components/MUIWrapper'; // doit être "use client"

export default function Providers({ children }: { children: ReactNode }) {
  // ✅ Instances créées côté client uniquement
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: { queries: { staleTime: 60 * 1000 } },
      })
  );

  return (
    <QueryClientProvider client={queryClient}>
      <MUIWrapper>{children}</MUIWrapper>
    </QueryClientProvider>
  );
}
