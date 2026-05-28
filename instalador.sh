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

# FUNÇÕES INTEGRADAS
criar_usuario() { header; read -p "Usuario: " u; read -p "Senha: " p; useradd -M -s /usr/sbin/nologin "$u" && echo "$u:$p" | chpasswd; echo -e "${GREEN}Criado!${NC}"; read; }
remover_usuario() { header; read -p "Usuario: " u; userdel -r "$u"; echo -e "${RED}Removido!${NC}"; read; }
listar_usuarios() { header; cut -d: -f1 /etc/passwd | grep -vE '^(root|nobody|syslog|www-data)'; read; }
monitorar_online() { header; who; read; }
gerir_badvpn() { header; echo "1) Iniciar BadVPN (7300) 0) Voltar"; read -p "Opção: " o; [[ $o == 1 ]] && nohup badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null 2>&1 &; read; }
gerir_squid() { header; apt install squid -y; echo "http_port 3128" > /etc/squid/squid.conf; systemctl restart squid; echo "Squid Ativo na 3128"; read; }
gerir_bbr() { header; echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf; echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf; sysctl -p; echo "BBR Ativo!"; read; }
gerir_firewall() { header; ufw allow 22/tcp; ufw allow 80/tcp; ufw allow 443/tcp; echo "Regras aplicadas!"; read; }
submenu_xray() {
    while true; do
        header
        echo -e "${CYAN}--- GERENCIAMENTO XRAY (Manual) ---${NC}"
        echo -e " [1] Reiniciar | [2] Mudar Porta | [3] Mudar SNI | [4] Mudar Host | [5] Desinstalar | [0] Voltar"
        read -p " Opção: " sub
        case $sub in
            1) systemctl restart xray ; echo "Reiniciado!" ; sleep 1 ;;
            2) read -p "Porta: " p ; sed -i "s/\"port\": [0-9]*/\"port\": $p/" /etc/xray/config.json ; systemctl restart xray ;;
            3) read -p "SNI: " s ; sed -i "s/serverNames\": \[\".*\"\]/serverNames\": \[\"$s\"\]/" /etc/xray/config.json ; systemctl restart xray ;;
            4) read -p "Host/IP: " h ; sed -i "s/dest\": \".*\"/dest\": \"$h\"/" /etc/xray/config.json ; systemctl restart xray ;;
            5) apt purge xray -y ; echo "Removido!" ; sleep 1 ;;
            0) break ;;
        esac
    done
}

# MENU PRINCIPAL
while true; do
    header
    echo -e " ${GREEN}[01]${NC} Criar SSH      ${GREEN}[02]${NC} Remover SSH    ${GREEN}[03]${NC} Listar"
    echo -e " ${GREEN}[04]${NC} Usuários Online ${GREEN}[05]${NC} BadVPN         ${GREEN}[06]${NC} Squid Proxy"
    echo -e " ${CYAN}[10]${NC} Xray Core ⚡    ${GREEN}[11]${NC} BBR Otimização  ${GREEN}[12]${NC} Firewall"
    echo -e " ${RED}[00]${NC} Sair"
    echo ""
    read -p " 🔹 ESCOLHA: " opt
    case $opt in
        01|1) criar_usuario ;; 02|2) remover_usuario ;; 03|3) listar_usuarios ;;
        04|4) monitorar_online ;; 05|5) gerir_badvpn ;; 06|6) gerir_squid ;;
        10) submenu_xray ;; 11|11) gerir_bbr ;; 12|12) gerir_firewall ;;
        00|0) exit 0 ;;
        *) echo "Opção inválida!"; sleep 1 ;;
    esac
done
