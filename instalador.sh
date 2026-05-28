#!/bin/bash

# CORES
RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; BLUE='\033[1;34m'; CYAN='\033[1;36m'; WHITE='\033[1;37m'; BG_RED='\033[41m'; NC='\033[0m'

header() {
    clear
    local ram=$(free -h | awk '/Mem:/ {print $2}' | tr -d 'i')
    local cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    echo -e "${BLUE}┬────────────────────────────────────────────────────────────────────────┬${NC}"
    echo -e "${BLUE}│${BG_RED}${WHITE}                 ↖ ALIEN VPN SSH PRO MANAGER ↘                  ${NC}${BLUE}│${NC}"
    echo -e "${BLUE}├────────────────────────────────────────────────────────────────────────┤${NC}"
    printf "${BLUE}│${NC} %-23s ${BLUE}│${NC} %-23s ${BLUE}│${NC} %-21s ${BLUE}│${NC}\n" "SISTEMA" "RAM" "CPU"
    printf "${BLUE}│${NC} OS: Ubuntu 22.04        ${BLUE}│${NC} %-23s ${BLUE}│${NC} %-21s ${BLUE}│${NC}\n" "$ram" "$cpu"
    echo -e "${BLUE}┴────────────────────────────────────────────────────────────────────────┴${NC}"
}

# FUNÇÕES
criar_ssh() { header; read -p "Usuario: " u; read -p "Senha: " p; useradd -M -s /usr/sbin/nologin "$u" && echo "$u:$p" | chpasswd; echo -e "${GREEN}Sucesso!${NC}"; read -p "Enter..."; }
remover_ssh() { header; read -p "Usuario: " u; userdel -r "$u"; echo -e "${RED}Removido!${NC}"; read -p "Enter..."; }
listar_ssh() { header; cut -d: -f1 /etc/passwd | grep -vE '^(root|nobody|syslog|www-data)'; read -p "Enter..."; }

# FUNÇÃO SSH-PLUS (ADICIONADA)
instalar_sshplus() {
    header
    echo -e "${YELLOW}Instalando SSH-PLUS-MANAGER...${NC}"
    rm -f /usr/bin/menu /bin/menu /bin/Plus /root/Plus
    wget -q https://raw.githubusercontent.com/jenbhie/SSH-PLUS-MANAGER/main/Plus -O /root/Plus
    chmod 777 /root/Plus
    echo -e "${GREEN}SSH-PLUS instalado com sucesso em /root/Plus${NC}"
    read -p "Enter para voltar..."
}

# SUB-MENU XRAY
submenu_xray() {
    while true; do
        header
        echo -e "${CYAN}--- GERENCIAMENTO XRAY ---${NC}"
        echo -e " [1] Reiniciar | [2] Trocar Porta | [3] Trocar SNI | [0] Voltar"
        read -p " Opção: " sub
        case $sub in
            1) systemctl restart xray; echo "Reiniciado!"; sleep 1 ;;
            2) read -p "Porta: " p; sed -i "s/\"port\": [0-9]*/\"port\": $p/" /etc/xray/config.json; systemctl restart xray; echo "OK!"; sleep 1 ;;
            3) read -p "SNI: " s; sed -i "s/serverNames\": \[\".*\"\]/serverNames\": \[\"$s\"\]/" /etc/xray/config.json; systemctl restart xray; echo "OK!"; sleep 1 ;;
            0) break ;;
        esac
    done
}

# MENU PRINCIPAL
while true; do
    header
    echo -e " ${GREEN}[01]${NC} Criar SSH      ${GREEN}[02]${NC} Remover SSH    ${GREEN}[03]${NC} Listar"
    echo -e " ${CYAN}[10]${NC} Xray Core      ${GREEN}[19]${NC} Instalar SSH-PLUS"
    echo -e " ${RED}[00]${NC} Sair"
    echo ""
    read -p " 🔹 ESCOLHA: " opt
    case $opt in
        01|1) criar_ssh ;;
        02|2) remover_ssh ;;
        03|3) listar_ssh ;;
        10) submenu_xray ;;
        19) instalar_sshplus ;;
        00|0) exit 0 ;;
        *) echo "Inválido"; sleep 1 ;;
    esac
done
