#!/bin/bash

# CORES
RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; BLUE='\033[1;34m'; CYAN='\033[1;36m'; WHITE='\033[1;37m'; BG_RED='\033[41m'; NC='\033[0m'

header() {
    clear
    echo -e "${BLUE}┬────────────────────────────────────────────────────────────────────────┬${NC}"
    echo -e "${BLUE}│${BG_RED}${WHITE}                 ↖ ALIEN VPN SSH PRO MANAGER ↘                  ${NC}${BLUE}│${NC}"
    echo -e "${BLUE}┴────────────────────────────────────────────────────────────────────────┴${NC}"
}

# --- SUB-MENU XRAY (8 OPÇÕES) ---
submenu_xray() {
    while true; do
        header
        echo -e "${CYAN}--- GERENCIAMENTO XRAY CORE ---${NC}"
        echo -e " [1] Ativar Xray"
        echo -e " [2] Reiniciar Xray"
        echo -e " [3] Mudar Porta"
        echo -e " [4] Mudar IP/Host"
        echo -e " [5] Mudar SNI"
        echo -e " [6] Escolher Porta Manualmente"
        echo -e " [7] Remover Xray"
        echo -e " [0] Voltar"
        read -p " Opção: " sub
        case $sub in
            1) systemctl start xray; echo "Xray ativado!"; sleep 2 ;;
            2) systemctl restart xray; echo "Xray reiniciado!"; sleep 2 ;;
            3|6) read -p "Digite a nova porta: " p; sed -i "s/\"port\": [0-9]*/\"port\": $p/" /etc/xray/config.json; systemctl restart xray; echo "Porta alterada para $p!"; sleep 2 ;;
            4) read -p "Digite novo IP/Host: " h; sed -i "s/dest\": \".*\"/dest\": \"$h\"/" /etc/xray/config.json; systemctl restart xray; echo "Host alterado!"; sleep 2 ;;
            5) read -p "Digite novo SNI: " s; sed -i "s/serverNames\": \[\".*\"\]/serverNames\": \[\"$s\"\]/" /etc/xray/config.json; systemctl restart xray; echo "SNI alterado!"; sleep 2 ;;
            7) apt purge xray -y; rm -rf /etc/xray; echo "Xray removido!"; sleep 2 ;;
            0) break ;;
            *) echo "Opção inválida!"; sleep 1 ;;
        esac
    done
}

# --- MENU PRINCIPAL ---
while true; do
    header
    echo -e " [01] Criar SSH      [10] Xray Core [19] SSH-PLUS [00] Sair"
    read -p " ESCOLHA: " opt
    case $opt in
        01|1) echo "Função Criar SSH"; read ;;
        10) submenu_xray ;;
        19) rm -f /root/Plus; wget -q https://raw.githubusercontent.com/jenbhie/SSH-PLUS-MANAGER/main/Plus -O /root/Plus && chmod 777 /root/Plus && ./Plus ;;
        00|0) exit 0 ;;
        *) echo "Em desenvolvimento..."; sleep 1 ;;
    esac
done
