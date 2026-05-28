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

criar_ssh() {
    header
    read -p "Usuario: " u
    read -p "Senha: " p
    useradd -M -s /usr/sbin/nologin "$u" && echo "$u:$p" | chpasswd
    echo -e "${GREEN}Usuário criado com sucesso!${NC}"
    read -p "Enter para voltar..."
}

remover_ssh() {
    header
    read -p "Usuario a remover: " u
    userdel -r "$u"
    echo -e "${RED}Usuário removido!${NC}"
    read -p "Enter para voltar..."
}

listar_ssh() {
    header
    cat /etc/passwd | grep -vE '^(root|nobody|syslog|www-data)' | cut -d: -f1
    read -p "Enter para voltar..."
}

submenu_xray() {
    while true; do
        header
        echo -e "${CYAN}--- GERENCIAMENTO XRAY (Manual) ---${NC}"
        echo -e " [1] Reiniciar Xray"
        echo -e " [2] Mudar Porta"
        echo -e " [3] Mudar SNI"
        echo -e " [4] Mudar Host/IP"
        echo -e " [0] Voltar"
        read -p " Opção: " sub
        case $sub in
            1) systemctl restart xray; echo "Xray Reiniciado!"; sleep 1 ;;
            2) read -p "Nova porta: " p; sed -i "s/\"port\": [0-9]*/\"port\": $p/" /etc/xray/config.json; systemctl restart xray; echo "Porta alterada!"; sleep 1 ;;
            0) break ;;
            *) echo "Opção inválida!"; sleep 1 ;;
        esac
    done
}

# MENU PRINCIPAL
while true; do
    header
    echo -e " ${GREEN}[01]${NC} Criar SSH      ${GREEN}[02]${NC} Remover SSH    ${GREEN}[03]${NC} Listar SSH"
    echo -e " ${CYAN}[10]${NC} Xray Core ⚡    ${RED}[00]${NC} Sair"
    echo ""
    read -p " 🔹 ESCOLHA UMA OPÇÃO: " opt
    case $opt in
        01|1) criar_ssh ;;
        02|2) remover_ssh ;;
        03|3) listar_ssh ;;
        10) submenu_xray ;;
        00|0) exit 0 ;;
        *) echo "Opção inválida"; sleep 1 ;;
    esac
done
