"use client";

import Link from "next/link";
import { Container, Box, Typography, Button } from "@mui/material";

export default function NotFoundClient() {
  const containerStyles = {
    minHeight: "100vh",
    display: "grid",
    placeItems: "center"
  };

  const textStyles = {
    mb: 3
  };

  return (
    <Container sx={containerStyles}>
      <Box textAlign="center">
        <Typography variant="h3" gutterBottom>Page introuvable</Typography>
        <Typography variant="body1" sx={textStyles}>
          La page que vous cherchez n'existe pas ou a été déplacée.
        </Typography>
        <Button variant="contained" component={Link} href="/">
          Retour à l'accueil
        </Button>
      </Box>
    </Container>
  );
} 