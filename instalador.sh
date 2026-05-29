#!/bin/bash

###############################################################################
#             ALIEN VPN SSH HIPER - SCRIPT DE INSTALAÇÃO                    #
#                  Versão: 2.0 - 2026                                         #
#             Compatível: Ubuntu 22.04 / Debian 11+                           #
#             Desenvolvido com suporte a Xray Core                            #
###############################################################################

# Cores
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NC='\033[0m'

# Variáveis globais
SCRIPT_DIR="/root/alienvpnsshhiper"
BACKUP_DIR="/root/ssh_backups"

# Funções de cabeçalho
header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║            ALIEN VPN SSH HIPER - v2.0                  ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Funções de atualização e BadVPN apontando para o seu repo
update_script() {
    header
    echo -e "${BLUE}→ Atualizando ALIEN VPN SSH HIPER...${NC}"
    cd /root
    # Ajustado para o seu repositório
    git clone https://github.com/robertvps/alienvpnsshhiper.git 2>/dev/null || cd alienvpnsshhiper && git pull
    echo -e "${GREEN}✓ Sistema atualizado com sucesso!${NC}"
    sleep 2
}

manage_badvpn() {
    header
    echo -e "${BLUE}→ Instalando BadVPN do repositório oficial ALIEN...${NC}"
    # Ajustado para o link do seu repositório
    wget -q https://raw.githubusercontent.com/robertvps/alienvpnsshhiper/main/badvpn-udpgw -O /usr/bin/badvpn-udpgw
    chmod +x /usr/bin/badvpn-udpgw
    echo -e "${GREEN}✓ BadVPN instalado com sucesso!${NC}"
    read -p "Pressione enter..."
}

# Início do menu principal
show_menu() {
    while true; do
        header
        echo -e "${CYAN}📋 ALIEN VPN SSH HIPER - MENU PRINCIPAL${NC}"
        echo "════════════════════════════════════════"
        echo -e "${GREEN}[01]${NC} Gerenciar SSH"
        echo -e "${GREEN}[07]${NC} BadVPN Manager"
        echo -e "${GREEN}[10]${NC} Xray Core Manager"
        echo -e "${GREEN}[19]${NC} Atualizar Script"
        echo -e "${RED}[00]${NC} Sair"
        echo "════════════════════════════════════════"
        read -p "Escolha uma opção: " opt
        
        case $opt in
            07|7) manage_badvpn ;;
            19) update_script ;;
            00|0) exit 0 ;;
            *) echo "Opção inválida"; sleep 1 ;;
        esac
    done
}

# Execução
header
echo -e "${GREEN}Iniciando instalação do ALIEN VPN SSH HIPER...${NC}"
show_menu
