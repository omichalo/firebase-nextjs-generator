import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    const { email, password } = await request.json();

    if (!email || !password) {
      return NextResponse.json(
        { error: 'Email et mot de passe requis' },
        { status: 400 }
      );
    }

    // Note: Cette API route est un exemple
    // En production, utilisez Firebase Admin SDK pour l'authentification côté serveur
    // ou déplacez l'authentification côté client
    
    return NextResponse.json({
      success: true,
      message: 'Authentification gérée côté client',
      note: 'Utilisez Firebase Auth directement dans le composant React'
    });
  } catch (error) {
    console.error('Erreur de connexion:', error);
    
    return NextResponse.json(
      { error: 'Erreur serveur' },
      { status: 500 }
    );
  }
} 