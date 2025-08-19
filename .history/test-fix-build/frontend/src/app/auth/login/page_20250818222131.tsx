'use client';

import { useState } from 'react';
import {
  Container,
  Typography,
  Box,
  TextField,
  Button,
  Alert,
} from '@mui/material';
import { useAuth } from '@/hooks/use-auth';
import { useRouter } from 'next/navigation';

// Force le rendu dynamique pour éviter les erreurs de prérendu
export const dynamic = 'force-dynamic';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const { signIn, isLoading } = useAuth();
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    try {
      await signIn(email, password);
      router.push('/dashboard');
    } catch (error) {
      setError('Identifiants invalides');
      console.error('Erreur de connexion:', error);
    }
  };

  const containerStyles = {
    minHeight: '100vh',
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
  };

  const formStyles = {
    width: '100%',
    '& > *': { mb: 2 },
  };

  const alertStyles = {
    width: '100%',
    mb: 4,
  };

  const buttonStyles = {
    mt: 3,
  };

  const linkStyles = {
    mt: 4,
    textAlign: 'center',
  };

  return (
    <Container maxWidth="sm">
      <Box sx={containerStyles}>
        <Typography variant="h3" component="h1" gutterBottom>
          Connexion à votre compte
        </Typography>

        {error && (
          <Alert severity="error" sx={alertStyles}>
            {error}
          </Alert>
        )}

        <Box component="form" onSubmit={handleSubmit} sx={formStyles}>
          <TextField
            fullWidth
            label="Adresse email"
            type="email"
            value={email}
            onChange={e => setEmail(e.target.value)}
            required
            variant="outlined"
            placeholder="Adresse email"
          />

          <TextField
            fullWidth
            label="Mot de passe"
            type="password"
            value={password}
            onChange={e => setPassword(e.target.value)}
            required
            variant="outlined"
            placeholder="Mot de passe"
          />

          <Button
            type="submit"
            fullWidth
            variant="contained"
            size="large"
            disabled={isLoading}
            sx={buttonStyles}
          >
            {isLoading ? 'Connexion...' : 'Se connecter'}
          </Button>
        </Box>

        <Box sx={linkStyles}>
          <Button component="a" href="/" variant="text" color="primary">
            Retour à l'accueil
          </Button>
        </Box>
      </Box>
    </Container>
  );
}
