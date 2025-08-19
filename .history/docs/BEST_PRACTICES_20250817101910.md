# 📚 Guide des bonnes pratiques

> **Meilleures pratiques pour utiliser le Générateur Firebase + Next.js 2025**

## 📋 Table des matières

- [🎯 Principes fondamentaux](#-principes-fondamentaux)
- [🏗️ Architecture et structure](#️-architecture-et-structure)
- [🔒 Sécurité](#-sécurité)
- [📱 Performance](#-performance)
- [🧪 Tests et qualité](#-tests-et-qualité)
- [🚀 Déploiement](#-déploiement)
- [📊 Monitoring](#-monitoring)

## 🎯 Principes fondamentaux

### 1. **SOLID Principles**

#### **Single Responsibility Principle (SRP)**

```typescript
// ❌ Mauvais : Une classe qui fait trop de choses
class UserManager {
  async createUser(userData: UserData) {
    /* ... */
  }
  async sendEmail(to: string, content: string) {
    /* ... */
  }
  async validateUser(user: User) {
    /* ... */
  }
  async backupUserData(userId: string) {
    /* ... */
  }
}

// ✅ Bon : Séparation des responsabilités
class UserService {
  async createUser(userData: UserData) {
    /* ... */
  }
  async validateUser(user: User) {
    /* ... */
  }
}

class EmailService {
  async sendEmail(to: string, content: string) {
    /* ... */
  }
}

class BackupService {
  async backupUserData(userId: string) {
    /* ... */
  }
}
```

#### **Open/Closed Principle (OCP)**

```typescript
// ❌ Mauvais : Modification de la classe existante
class PaymentProcessor {
  processPayment(payment: Payment) {
    if (payment.type === "credit_card") {
      // Logique pour carte de crédit
    } else if (payment.type === "paypal") {
      // Logique pour PayPal
    }
    // Ajouter un nouveau type = modifier cette classe
  }
}

// ✅ Bon : Extension sans modification
interface PaymentMethod {
  process(payment: Payment): Promise<PaymentResult>;
}

class CreditCardPayment implements PaymentMethod {
  async process(payment: Payment): Promise<PaymentResult> {
    // Logique pour carte de crédit
  }
}

class PayPalPayment implements PaymentMethod {
  async process(payment: Payment): Promise<PaymentResult> {
    // Logique pour PayPal
  }
}

class PaymentProcessor {
  constructor(private methods: PaymentMethod[]) {}

  async processPayment(payment: Payment): Promise<PaymentResult> {
    const method = this.methods.find((m) => m.canHandle(payment));
    return method.process(payment);
  }
}
```

### 2. **Clean Code**

#### **Noms explicites**

```typescript
// ❌ Mauvais : Noms peu clairs
const d = new Date();
const u = await getUser();
const p = await getPosts();

// ✅ Bon : Noms explicites
const currentDate = new Date();
const currentUser = await getUser();
const userPosts = await getPosts();
```

#### **Fonctions courtes et focalisées**

```typescript
// ❌ Mauvais : Fonction trop longue
async function processUserData(userId: string) {
  // 50+ lignes de logique mélangée
  const user = await getUser(userId);
  if (user) {
    // Validation
    if (user.email && user.email.includes("@")) {
      // Traitement email
      const emailDomain = user.email.split("@")[1];
      if (emailDomain === "company.com") {
        // Logique spécifique
      }
    }
    // Autres traitements...
  }
}

// ✅ Bon : Fonctions courtes et focalisées
async function processUserData(userId: string) {
  const user = await getUser(userId);
  if (!user) return;

  await validateUser(user);
  await processUserEmail(user);
  await updateUserStatus(user);
}

async function validateUser(user: User) {
  if (!user.email || !isValidEmail(user.email)) {
    throw new Error("Email invalide");
  }
}

async function processUserEmail(user: User) {
  if (isCompanyEmail(user.email)) {
    await applyCompanyPolicies(user);
  }
}
```

## 🏗️ Architecture et structure

### 1. **Structure des composants**

#### **Composants fonctionnels avec hooks**

```typescript
// ✅ Bon : Composant fonctionnel moderne
import React, { useState, useEffect, useCallback } from 'react';
import { useAuth } from '@/hooks/use-auth';
import { usePosts } from '@/hooks/use-posts';

interface PostListProps {
  category?: string;
  limit?: number;
}

export function PostList({ category, limit = 10 }: PostListProps) {
  const { user } = useAuth();
  const { posts, loading, error, fetchPosts } = usePosts();

  const handleRefresh = useCallback(() => {
    fetchPosts({ category, limit });
  }, [category, limit, fetchPosts]);

  useEffect(() => {
    fetchPosts({ category, limit });
  }, [category, limit, fetchPosts]);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage error={error} onRetry={handleRefresh} />;

  return (
    <div className="post-list">
      {posts.map(post => (
        <PostCard key={post.id} post={post} />
      ))}
    </div>
  );
}
```

#### **Séparation des préoccupations**

```typescript
// ✅ Bon : Logique métier séparée
// hooks/use-posts.ts
export function usePosts() {
  const [posts, setPosts] = useState<Post[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  const fetchPosts = useCallback(async (params: FetchParams) => {
    try {
      setLoading(true);
      setError(null);
      const data = await postsApi.fetch(params);
      setPosts(data);
    } catch (err) {
      setError(err as Error);
    } finally {
      setLoading(false);
    }
  }, []);

  return { posts, loading, error, fetchPosts };
}

// components/PostList.tsx
export function PostList() {
  const { posts, loading, error, fetchPosts } = usePosts();
  // Logique d'affichage uniquement
}
```

### 2. **Gestion d'état**

#### **Zustand pour l'état local**

```typescript
// stores/ui-store.ts
import { create } from "zustand";
import { persist } from "zustand/middleware";

interface UIState {
  theme: "light" | "dark";
  sidebarOpen: boolean;
  notifications: Notification[];
  setTheme: (theme: "light" | "dark") => void;
  toggleSidebar: () => void;
  addNotification: (notification: Notification) => void;
  removeNotification: (id: string) => void;
}

export const useUIStore = create<UIState>()(
  persist(
    (set, get) => ({
      theme: "light",
      sidebarOpen: false,
      notifications: [],

      setTheme: (theme) => set({ theme }),
      toggleSidebar: () =>
        set((state) => ({ sidebarOpen: !state.sidebarOpen })),
      addNotification: (notification) =>
        set((state) => ({
          notifications: [...state.notifications, notification],
        })),
      removeNotification: (id) =>
        set((state) => ({
          notifications: state.notifications.filter((n) => n.id !== id),
        })),
    }),
    {
      name: "ui-storage",
      partialize: (state) => ({ theme: state.theme }),
    }
  )
);
```

#### **React Query pour l'état serveur**

```typescript
// hooks/use-posts-query.ts
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { postsApi } from "@/api/posts";

export function usePosts(category?: string) {
  return useQuery({
    queryKey: ["posts", category],
    queryFn: () => postsApi.fetch({ category }),
    staleTime: 5 * 60 * 1000, // 5 minutes
    cacheTime: 10 * 60 * 1000, // 10 minutes
  });
}

export function useCreatePost() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: postsApi.create,
    onSuccess: (newPost) => {
      // Invalider et mettre à jour le cache
      queryClient.invalidateQueries({ queryKey: ["posts"] });
      queryClient.setQueryData(["posts", newPost.category], (old: Post[]) => [
        newPost,
        ...old,
      ]);
    },
  });
}
```

## 🔒 Sécurité

### 1. **Validation des données**

#### **Validation côté client et serveur**

```typescript
// lib/validation/user-schema.ts
import { z } from "zod";

export const userSchema = z.object({
  email: z.string().email("Email invalide"),
  password: z
    .string()
    .min(8, "Le mot de passe doit contenir au moins 8 caractères")
    .regex(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
      "Le mot de passe doit contenir au moins une minuscule, une majuscule et un chiffre"
    ),
  name: z.string().min(2, "Le nom doit contenir au moins 2 caractères"),
  age: z.number().min(13, "Vous devez avoir au moins 13 ans"),
});

export type UserInput = z.infer<typeof userSchema>;

// hooks/use-form.ts
export function useForm<T>(schema: z.ZodSchema<T>) {
  const [errors, setErrors] = useState<Record<string, string>>({});

  const validate = useCallback(
    (data: unknown) => {
      try {
        const result = schema.parse(data);
        setErrors({});
        return { success: true, data: result };
      } catch (error) {
        if (error instanceof z.ZodError) {
          const fieldErrors: Record<string, string> = {};
          error.errors.forEach((err) => {
            if (err.path[0]) {
              fieldErrors[err.path[0] as string] = err.message;
            }
          });
          setErrors(fieldErrors);
        }
        return { success: false, errors };
      }
    },
    [schema]
  );

  return { validate, errors };
}
```

#### **Sanitisation des entrées**

```typescript
// lib/sanitization.ts
import DOMPurify from "dompurify";

export function sanitizeHtml(html: string): string {
  return DOMPurify.sanitize(html, {
    ALLOWED_TAGS: ["b", "i", "em", "strong", "a", "p", "br"],
    ALLOWED_ATTR: ["href", "target"],
  });
}

export function sanitizeInput(input: string): string {
  return input
    .trim()
    .replace(/[<>]/g, "") // Supprimer les balises HTML
    .replace(/javascript:/gi, "") // Supprimer les protocoles dangereux
    .substring(0, 1000); // Limiter la longueur
}
```

### 2. **Authentification et autorisation**

#### **Middleware d'authentification**

```typescript
// middleware/auth.ts
import { NextRequest, NextResponse } from "next/server";
import { verifyAuthToken } from "@/lib/auth";

export async function authMiddleware(request: NextRequest) {
  const token = request.headers.get("authorization")?.replace("Bearer ", "");

  if (!token) {
    return NextResponse.json({ error: "Token manquant" }, { status: 401 });
  }

  try {
    const user = await verifyAuthToken(token);
    request.headers.set("user", JSON.stringify(user));
    return NextResponse.next();
  } catch (error) {
    return NextResponse.json({ error: "Token invalide" }, { status: 401 });
  }
}

// middleware.ts
import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import { authMiddleware } from "./middleware/auth";

export function middleware(request: NextRequest) {
  // Appliquer l'authentification aux routes protégées
  if (request.nextUrl.pathname.startsWith("/api/protected")) {
    return authMiddleware(request);
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/api/protected/:path*", "/dashboard/:path*"],
};
```

#### **Règles Firestore sécurisées**

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Règles par défaut - tout refuser
    match /{document=**} {
      allow read, write: if false;
    }

    // Utilisateurs : lecture/écriture de son propre profil
    match /users/{userId} {
      allow read, write: if request.auth != null &&
        request.auth.uid == userId;
    }

    // Posts : lecture publique, écriture par l'auteur
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null &&
        request.auth.uid == resource.data.authorId;
    }

    // Commentaires : lecture publique, écriture par l'auteur
    match /comments/{commentId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null &&
        request.auth.uid == resource.data.authorId;
    }

    // Admin : accès complet pour les administrateurs
    match /admin/{document=**} {
      allow read, write: if request.auth != null &&
        exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## 📱 Performance

### 1. **Optimisation Next.js**

#### **Lazy Loading des composants**

```typescript
// components/LazyComponents.tsx
import dynamic from 'next/dynamic';

// Composants chargés à la demande
export const HeavyChart = dynamic(() => import('./HeavyChart'), {
  loading: () => <ChartSkeleton />,
  ssr: false, // Désactiver le SSR pour les composants complexes
});

export const PDFViewer = dynamic(() => import('./PDFViewer'), {
  loading: () => <div>Chargement du visualiseur PDF...</div>,
});

// Composants avec préchargement
export const Dashboard = dynamic(() => import('./Dashboard'), {
  loading: () => <DashboardSkeleton />,
  ssr: true,
});
```

#### **Optimisation des images**

```typescript
// components/OptimizedImage.tsx
import Image from 'next/image';

interface OptimizedImageProps {
  src: string;
  alt: string;
  width: number;
  height: number;
  priority?: boolean;
}

export function OptimizedImage({
  src,
  alt,
  width,
  height,
  priority = false
}: OptimizedImageProps) {
  return (
    <Image
      src={src}
      alt={alt}
      width={width}
      height={height}
      priority={priority}
      placeholder="blur"
      blurDataURL="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAABAAEDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAX/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCdABmX/9k="
      sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
    />
  );
}
```

#### **Optimisation du bundle**

```javascript
// next.config.js
const nextConfig = {
  experimental: {
    optimizeCss: true,
    optimizePackageImports: ["@mui/material", "@mui/icons-material"],
  },

  webpack: (config, { dev, isServer }) => {
    // Optimisations pour la production
    if (!dev && !isServer) {
      config.optimization.splitChunks.cacheGroups = {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: "vendors",
          chunks: "all",
        },
        mui: {
          test: /[\\/]node_modules[\\/]@mui[\\/]/,
          name: "mui",
          chunks: "all",
        },
      };
    }

    return config;
  },
};
```

### 2. **Optimisation Firebase**

#### **Requêtes Firestore optimisées**

```typescript
// hooks/use-optimized-query.ts
import { useQuery } from "@tanstack/react-query";
import {
  collection,
  query,
  where,
  orderBy,
  limit,
  getDocs,
} from "firebase/firestore";

export function useOptimizedPosts(category?: string, limitCount = 10) {
  return useQuery({
    queryKey: ["posts", category, limitCount],
    queryFn: async () => {
      let q = query(
        collection(db, "posts"),
        where("published", "==", true),
        orderBy("publishedAt", "desc"),
        limit(limitCount)
      );

      if (category) {
        q = query(q, where("category", "==", category));
      }

      const snapshot = await getDocs(q);
      return snapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
    },
    staleTime: 5 * 60 * 1000, // 5 minutes
    cacheTime: 10 * 60 * 1000, // 10 minutes
  });
}
```

#### **Pagination efficace**

```typescript
// hooks/use-pagination.ts
import { useState, useCallback } from "react";
import {
  collection,
  query,
  orderBy,
  limit,
  startAfter,
  getDocs,
} from "firebase/firestore";

export function usePagination<T>(
  collectionName: string,
  pageSize: number = 10
) {
  const [items, setItems] = useState<T[]>([]);
  const [loading, setLoading] = useState(false);
  const [hasMore, setHasMore] = useState(true);
  const [lastDoc, setLastDoc] = useState<any>(null);

  const loadMore = useCallback(async () => {
    if (loading || !hasMore) return;

    setLoading(true);
    try {
      let q = query(
        collection(db, collectionName),
        orderBy("createdAt", "desc"),
        limit(pageSize)
      );

      if (lastDoc) {
        q = query(q, startAfter(lastDoc));
      }

      const snapshot = await getDocs(q);
      const newItems = snapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));

      setItems((prev) => [...prev, ...newItems]);
      setLastDoc(snapshot.docs[snapshot.docs.length - 1]);
      setHasMore(snapshot.docs.length === pageSize);
    } catch (error) {
      console.error("Erreur lors du chargement:", error);
    } finally {
      setLoading(false);
    }
  }, [collectionName, pageSize, loading, hasMore, lastDoc]);

  return { items, loading, hasMore, loadMore };
}
```

## 🧪 Tests et qualité

### 1. **Tests unitaires**

#### **Tests des composants**

```typescript
// __tests__/components/PostCard.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { PostCard } from '@/components/PostCard';
import { mockPost } from '@/__mocks__/post';

describe('PostCard', () => {
  it('affiche les informations du post', () => {
    render(<PostCard post={mockPost} />);

    expect(screen.getByText(mockPost.title)).toBeInTheDocument();
    expect(screen.getByText(mockPost.excerpt)).toBeInTheDocument();
    expect(screen.getByText(mockPost.author.name)).toBeInTheDocument();
  });

  it('gère le clic sur le bouton like', () => {
    const onLike = jest.fn();
    render(<PostCard post={mockPost} onLike={onLike} />);

    const likeButton = screen.getByRole('button', { name: /like/i });
    fireEvent.click(likeButton);

    expect(onLike).toHaveBeenCalledWith(mockPost.id);
  });

  it('affiche le badge premium pour les posts premium', () => {
    const premiumPost = { ...mockPost, isPremium: true };
    render(<PostCard post={premiumPost} />);

    expect(screen.getByText('Premium')).toBeInTheDocument();
  });
});
```

#### **Tests des hooks**

```typescript
// __tests__/hooks/use-auth.test.ts
import { renderHook, act } from "@testing-library/react";
import { useAuth } from "@/hooks/use-auth";
import { mockUser } from "@/__mocks__/user";

describe("useAuth", () => {
  it("gère la connexion utilisateur", async () => {
    const { result } = renderHook(() => useAuth());

    expect(result.current.user).toBeNull();
    expect(result.current.isAuthenticated).toBe(false);

    await act(async () => {
      await result.current.signIn("test@example.com", "password");
    });

    expect(result.current.user).toEqual(mockUser);
    expect(result.current.isAuthenticated).toBe(true);
  });

  it("gère la déconnexion", async () => {
    const { result } = renderHook(() => useAuth());

    // Simuler un utilisateur connecté
    act(() => {
      result.current.user = mockUser;
      result.current.isAuthenticated = true;
    });

    await act(async () => {
      await result.current.logout();
    });

    expect(result.current.user).toBeNull();
    expect(result.current.isAuthenticated).toBe(false);
  });
});
```

### 2. **Tests d'intégration**

#### **Tests des API routes**

```typescript
// __tests__/api/posts.test.ts
import { createMocks } from "node-mocks-http";
import { handler } from "@/pages/api/posts";

describe("/api/posts", () => {
  it("récupère la liste des posts", async () => {
    const { req, res } = createMocks({
      method: "GET",
    });

    await handler(req, res);

    expect(res._getStatusCode()).toBe(200);
    const data = JSON.parse(res._getData());
    expect(Array.isArray(data.posts)).toBe(true);
  });

  it("crée un nouveau post", async () => {
    const postData = {
      title: "Test Post",
      content: "Test content",
      category: "test",
    };

    const { req, res } = createMocks({
      method: "POST",
      body: postData,
    });

    await handler(req, res);

    expect(res._getStatusCode()).toBe(201);
    const data = JSON.parse(res._getData());
    expect(data.post.title).toBe(postData.title);
  });

  it("retourne une erreur 400 pour des données invalides", async () => {
    const { req, res } = createMocks({
      method: "POST",
      body: { title: "" }, // Titre vide
    });

    await handler(req, res);

    expect(res._getStatusCode()).toBe(400);
    const data = JSON.parse(res._getData());
    expect(data.error).toBeDefined();
  });
});
```

## 🚀 Déploiement

### 1. **Environnements multiples**

#### **Configuration par environnement**

```typescript
// config/environments.ts
export const environments = {
  development: {
    firebase: {
      projectId: "myapp-dev",
      region: "us-central1",
    },
    api: {
      baseUrl: "http://localhost:3000/api",
    },
    features: {
      analytics: false,
      sentry: false,
    },
  },

  staging: {
    firebase: {
      projectId: "myapp-staging",
      region: "us-central1",
    },
    api: {
      baseUrl: "https://staging.myapp.com/api",
    },
    features: {
      analytics: true,
      sentry: true,
    },
  },

  production: {
    firebase: {
      projectId: "myapp-prod",
      region: "us-central1",
    },
    api: {
      baseUrl: "https://myapp.com/api",
    },
    features: {
      analytics: true,
      sentry: true,
    },
  },
} as const;

export type Environment = keyof typeof environments;
```

#### **Scripts de déploiement**

```bash
#!/bin/bash
# scripts/deploy.sh

ENVIRONMENT=$1
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo "❌ Environnement invalide. Utilisez: dev, staging, ou prod"
    exit 1
fi

echo "🚀 Déploiement en $ENVIRONMENT..."

# Build
npm run build:$ENVIRONMENT

# Tests
npm run test

# Déploiement Firebase
firebase use $ENVIRONMENT
firebase deploy

echo "✅ Déploiement terminé!"
```

### 2. **CI/CD automatisé**

#### **GitHub Actions**

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "18"
          cache: "npm"

      - run: npm ci
      - run: npm run lint
      - run: npm run test
      - run: npm run build

  deploy-staging:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    environment: staging

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "18"
          cache: "npm"

      - run: npm ci
      - run: npm run build:staging

      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_STAGING }}"
          projectId: myapp-staging
          channelId: live

  deploy-production:
    needs: [test, deploy-staging]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "18"
          cache: "npm"

      - run: npm ci
      - run: npm run build:production

      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_PROD }}"
          projectId: myapp-prod
          channelId: live
```

## 📊 Monitoring

### 1. **Logs structurés**

#### **Configuration Winston**

```typescript
// lib/logger.ts
import winston from "winston";

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: "myapp" },
  transports: [
    new winston.transports.File({ filename: "logs/error.log", level: "error" }),
    new winston.transports.File({ filename: "logs/combined.log" }),
  ],
});

if (process.env.NODE_ENV !== "production") {
  logger.add(
    new winston.transports.Console({
      format: winston.format.simple(),
    })
  );
}

export default logger;
```

#### **Middleware de logging**

```typescript
// middleware/logging.ts
import { NextRequest, NextResponse } from "next/server";
import logger from "@/lib/logger";

export function loggingMiddleware(request: NextRequest) {
  const start = Date.now();

  return NextResponse.next().then((response) => {
    const duration = Date.now() - start;

    logger.info("Request processed", {
      method: request.method,
      url: request.url,
      status: response.status,
      duration,
      userAgent: request.headers.get("user-agent"),
      ip: request.ip,
    });

    return response;
  });
}
```

### 2. **Métriques et alertes**

#### **Health checks**

```typescript
// pages/api/health.ts
import { NextApiRequest, NextApiResponse } from "next";
import { db } from "@/lib/firebase";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const health = {
    status: "healthy",
    timestamp: new Date().toISOString(),
    checks: {
      database: "unknown",
      firebase: "unknown",
      memory: "unknown",
    },
  };

  try {
    // Vérifier la base de données
    await db.collection("health").doc("check").get();
    health.checks.database = "healthy";
  } catch (error) {
    health.checks.database = "unhealthy";
    health.status = "unhealthy";
  }

  try {
    // Vérifier Firebase
    const auth = getAuth();
    health.checks.firebase = "healthy";
  } catch (error) {
    health.checks.firebase = "unhealthy";
    health.status = "unhealthy";
  }

  // Vérifier la mémoire
  const memUsage = process.memoryUsage();
  if (memUsage.heapUsed / memUsage.heapTotal > 0.9) {
    health.checks.memory = "warning";
  } else {
    health.checks.memory = "healthy";
  }

  const statusCode = health.status === "healthy" ? 200 : 503;
  res.status(statusCode).json(health);
}
```

## ✅ Checklist des bonnes pratiques

### Architecture

- [ ] Principes SOLID respectés
- [ ] Séparation des préoccupations
- [ ] Composants réutilisables
- [ ] Hooks personnalisés
- [ ] Gestion d'état optimisée

### Sécurité

- [ ] Validation des entrées
- [ ] Sanitisation des données
- [ ] Authentification robuste
- [ ] Autorisation fine
- [ ] Règles Firestore sécurisées

### Performance

- [ ] Lazy loading des composants
- [ ] Optimisation des images
- [ ] Requêtes Firestore optimisées
- [ ] Pagination efficace
- [ ] Bundle optimisé

### Tests

- [ ] Tests unitaires > 80%
- [ ] Tests d'intégration
- [ ] Tests des composants
- [ ] Tests des hooks
- [ ] Tests des API routes

### Déploiement

- [ ] Environnements multiples
- [ ] CI/CD automatisé
- [ ] Scripts de déploiement
- [ ] Rollback automatique
- [ ] Monitoring en place

## 🎉 Félicitations !

Vous appliquez maintenant les meilleures pratiques pour créer des applications Firebase + Next.js robustes et maintenables !

**Prochaines étapes :**

- [Guide de maintenance](MAINTENANCE.md) 🔧
- [Guide de contribution](CONTRIBUTING.md) 🤝
- [Exemples de projets](EXAMPLES.md) 📚

---

**💡 Astuce :** Commencez par appliquer une pratique à la fois pour ne pas être submergé !
