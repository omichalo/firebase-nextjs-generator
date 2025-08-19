'use client';

import { Container, Typography, Box, Button } from '@mui/material';

export default function Home() {
  const boxStyles = {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: '100vh',
    textAlign: 'center',
  };

  return (
    <Container maxWidth="lg">
      <Box sx={boxStyles}>
        <Typography variant="h2" component="h1" gutterBottom>
          Bienvenue sur test-debug-fixed
        </Typography>
        <Typography
          variant="h5"
          component="h2"
          gutterBottom
          color="text.secondary"
        >
          Test project
        </Typography>
        <Typography variant="body1" paragraph>
          Votre application Firebase + Next.js est prête !
        </Typography>
        <Button variant="contained" size="large">
          Commencer
        </Button>
      </Box>
    </Container>
  );
}
