'use client';

import { useEffect, useState } from 'react';
import { Container, Typography, Box, Card, CardContent, Grid, Avatar, Chip, Button } from '@mui/material';
import { useAuth } from '@/hooks/use-auth';
import { useRouter } from 'next/navigation';

export default function DashboardPage() {
  const { user, isAuthenticated, isInitialized, logout } = useAuth();
  const router = useRouter();
  const [stats, setStats] = useState({
    totalUsers: 0,
    activeProjects: 0,
    recentActivity: 0
  });

  useEffect(() => {
    if (isInitialized && !isAuthenticated) {
      router.push('/auth/login');
    }
  }, [isAuthenticated, isInitialized, router]);

  useEffect(() => {
    // Simuler le chargement des statistiques depuis Firebase
    if (isAuthenticated) {
      // Ici vous pourriez appeler vos fonctions Firebase
      setStats({
        totalUsers: 1250,
        activeProjects: 8,
        recentActivity: 23
      });
    }
  }, [isAuthenticated]);

  if (!isInitialized) {
    const loadingStyles = {
      minHeight: '100vh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    };

    return (
      <Container>
        <Box sx={loadingStyles}>
          <Typography>Chargement...</Typography>
        </Box>
      </Container>
    );
  }

  if (!isAuthenticated) {
    return null; // Redirection en cours
  }

  const handleLogout = async () => {
    try {
      await logout();
      router.push('/');
    } catch (error) {
      console.error('Erreur de déconnexion:', error);
    }
  };

  const mainStyles = {
    py: 8
  };

  const headerStyles = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    mb: 8
  };

  const userCardStyles = {
    mb: 6
  };

  const userBoxStyles = {
    display: 'flex',
    alignItems: 'center',
    gap: 4
  };

  const avatarStyles = {
    width: 64,
    height: 64
  };

  const chipStyles = {
    mt: 2
  };

  const statsStyles = {
    mb: 8
  };

  const centerBoxStyles = {
    textAlign: 'center'
  };

  const actionsBoxStyles = {
    display: 'flex',
    gap: 2
  };

  return (
    <Container maxWidth="lg">
      <Box sx={mainStyles}>
        {/* Header */}
        <Box sx={headerStyles}>
          <Typography variant="h3" component="h1">
            Dashboard
          </Typography>
          <Button variant="outlined" onClick={handleLogout}>
            Déconnexion
          </Button>
        </Box>

        {/* User Info */}
        <Card sx={userCardStyles}>
          <CardContent>
            <Box sx={userBoxStyles}>
              <Avatar sx={avatarStyles}>
                {user?.displayName?.[0] || user?.email?.[0] || 'U'}
              </Avatar>
              <Box>
                <Typography variant="h5">
                  {user?.displayName || user?.email || 'Utilisateur'}
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  {user?.email || 'utilisateur@example.com'}
                </Typography>
                <Chip label="Connecté" color="success" size="small" sx={chipStyles} />
              </Box>
            </Box>
          </CardContent>
        </Card>

        {/* Stats Grid */}
        <Grid container spacing={3} sx={statsStyles}>
          <Grid item xs={12} md={4}>
            <Card>
              <CardContent>
                <Box sx={centerBoxStyles}>
                  <Typography variant="h4" color="primary">
                    {stats.totalUsers}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    Utilisateurs totaux
                  </Typography>
                </Box>
              </CardContent>
            </Card>
          </Grid>
          
          <Grid item xs={12} md={4}>
            <Card>
              <CardContent>
                <Box sx={centerBoxStyles}>
                  <Typography variant="h4" color="secondary">
                    {stats.activeProjects}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    Projets actifs
                  </Typography>
                </Box>
              </CardContent>
            </Card>
          </Grid>
          
          <Grid item xs={12} md={4}>
            <Card>
              <CardContent>
                <Box sx={centerBoxStyles}>
                  <Typography variant="h4" color="success">
                    {stats.recentActivity}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    Activités récentes
                  </Typography>
                </Box>
              </CardContent>
            </Card>
          </Grid>
        </Grid>

        {/* Quick Actions */}
        <Card>
          <CardContent>
            <Typography variant="h6" gutterBottom>
              Actions rapides
            </Typography>
            <Box sx={actionsBoxStyles}>
              <Button variant="contained" color="primary">
                Nouveau projet
              </Button>
              <Button variant="outlined">
                Voir les rapports
              </Button>
              <Button variant="outlined">
                Paramètres
              </Button>
            </Box>
          </CardContent>
        </Card>
      </Box>
    </Container>
  );
} 