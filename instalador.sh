#!/bin/bash

# Definições de Cores
C_AZUL='\033[1;36m'   # Bordas
C_AMARELO='\033[1;33m' # Nomes das opções
C_VERDE_FUNDO_PRETO='\033[40;32m' # Verde com fundo preto
NC='\033[0m' # Reset

while true; do
    clear
    # Título em Verde com Fundo Preto
    echo -e "${C_VERDE_FUNDO_PRETO} ↖ ALIEN VPN SSH HIPER ↘ ${NC}"
    
    echo -e "${C_AZUL}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e " SISTEMA        MEMORIA RAM       PROCESSADOR"
    echo -e " OS: $(lsb_release -d | awk '{print $2, $3}') | RAM: $(free -h | awk '/^Mem:/{print $2}') | CPU: $(nproc)"
    echo -e "${C_AZUL}├─────────────────────────────────────────────────────────┤${NC}"
    
    # Opções em Amarelo
    printf "${C_AMARELO} [01] • CRIAR USUARIO        [13] • SPEEDTEST\n [02] • CRIAR TESTE          [14] • OTIMIZAR\n [03] • REMOVER USUARIO      [15] • TRAFEGO\n [04] • RENOVAR USUARIO      [16] • FIREWALL\n [05] • USUARIOS ONLINE      [17] • INFO SISTEMA\n [06] • ALTERAR DATA         [18] • BANNER\n [07] • ALTERAR LIMITE       [19] • LIMITAR SSH\n [08] • ALTERAR SENHA        [20] • BADVPN\n [09] • REMOVER EXPIRADOS    [21] • AUTO MENU\n [10] • RELATORIO USUARIOS   [22] • CHATBOTS\n [11] • BACKUP DE USUARIOS   [23] • MAIS OPCOES\n [12] • MODOS DE CONEXAO     [00] • SAIR\n${NC}"
    
    echo -e "${C_AZUL}└─────────────────────────────────────────────────────────┘${NC}"
    read -p "INFORME UMA OPCAO: " opt
    # ... resto do case ...
done
