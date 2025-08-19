#!/bin/bash

# 🚀 Script de monitoring de progression des tests
# Usage: ./scripts/monitor-progress.sh [log_file]

LOG_FILE=${1:-"test-ultra-deep.log"}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_ROOT"

echo "🔍 Monitoring de progression: $LOG_FILE"
echo "📁 Répertoire: $(pwd)"
echo "⏱️  Démarrage: $(date)"
echo ""

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Monitoring en temps réel
while true; do
    if [ -f "$LOG_FILE" ]; then
        # Nettoyer l'écran
        clear
        
        echo "🔍 Monitoring de progression: $LOG_FILE"
        echo "⏱️  Temps écoulé: $(date)"
        echo "📊 Taille du log: $(wc -l < "$LOG_FILE") lignes"
        echo ""
        
        # Afficher les dernières lignes
        echo "📝 Dernières lignes du log:"
        echo "----------------------------------------"
        tail -10 "$LOG_FILE" 2>/dev/null || echo "Log vide ou inaccessible"
        echo "----------------------------------------"
        echo ""
        
        # Analyser la progression
        echo "📈 Analyse de progression:"
        
        if grep -q "Phase 1:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 1: Tests d'environnement${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 1: En attente...${NC}"
        fi
        
        if grep -q "Phase 2:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 2: Build du générateur${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 2: En attente...${NC}"
        fi
        
        if grep -q "Phase 3:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 3: Tests CLI${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 3: En attente...${NC}"
        fi
        
        if grep -q "Phase 4:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 4: Génération de projets${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 4: En attente...${NC}"
        fi
        
        if grep -q "Phase 5:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 5: Build des applications${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 5: En attente...${NC}"
        fi
        
        if grep -q "Phase 6:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 6: Tests de santé des pages${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 6: En attente...${NC}"
        fi
        
        if grep -q "Phase 7:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 7: Tests de configuration${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 7: En attente...${NC}"
        fi
        
        if grep -q "Phase 8:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 8: Tests Firebase${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 8: En attente...${NC}"
        fi
        
        if grep -q "Phase 9:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 9: Validation finale${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 9: En attente...${NC}"
        fi
        
        if grep -q "Phase 10:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 10: Tests de robustesse${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 10: En attente...${NC}"
        fi
        
        if grep -q "Phase 11:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 11: Performance et qualité${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 11: En attente...${NC}"
        fi
        
        if grep -q "Phase 12:" "$LOG_FILE"; then
            echo -e "  ${GREEN}✅ Phase 12: Tests de compatibilité${NC}"
        else
            echo -e "  ${YELLOW}⏳ Phase 12: En attente...${NC}"
        fi
        
        # Vérifier si terminé
        if grep -q "Test ULTRA-COMPLET et PROFOND terminé" "$LOG_FILE"; then
            echo ""
            echo -e "${GREEN}🎉🎉🎉 TESTS TERMINÉS AVEC SUCCÈS ! 🎉🎉🎉${NC}"
            break
        fi
        
        echo ""
        echo -e "${BLUE}🔄 Actualisation dans 5 secondes... (Ctrl+C pour arrêter)${NC}"
        
    else
        echo "⏳ En attente du fichier de log: $LOG_FILE"
    fi
    
    sleep 5
done

echo ""
echo "✅ Monitoring terminé" 