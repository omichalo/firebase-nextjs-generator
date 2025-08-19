# Guide de Déploiement

## 🚀 Déploiement Automatique

### GitHub Actions
Le projet utilise GitHub Actions pour le CI/CD automatique :

1. **Push sur develop** → Déploiement automatique en dev
2. **Push sur main** → Déploiement automatique en production
3. **Pull Request** → Tests automatiques

### Configuration des Secrets
Configurer les secrets suivants dans GitHub :
- `FIREBASE_SERVICE_ACCOUNT_DEV`
- `FIREBASE_SERVICE_ACCOUNT_PROD`

## 🔧 Déploiement Manuel

### Frontend
```bash
cd frontend
npm run build
firebase deploy --only hosting
```

### Backend
```bash
cd backend
firebase deploy --only functions,firestore
```

### Tout
```bash
firebase deploy
```

## 🌍 Environnements

### Développement
- **URL**: https://-dev.web.app
- **Firebase Project**: -dev

### Staging
- **URL**: https://-staging.web.app
- **Firebase Project**: -staging

### Production
- **URL**: https://.web.app
- **Firebase Project**: 

## 📊 Monitoring

### Firebase Console
- Performance Monitoring
- Analytics
- Crashlytics

### Sentry (si activé)
- Error tracking
- Performance monitoring
- Release tracking

## 🔄 Rollback

### Frontend
```bash
firebase hosting:clone :live:1.0.0 :live
```

### Backend
```bash
firebase functions:rollback defaultFunction 1.0.0
```
