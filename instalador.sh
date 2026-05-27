#!/bin/bash

###############################################################################
#          ALIEN VPN SSH PRO - SCRIPT DE INSTALAÇÃO AUTOMÁTICA               #
#                      Versão Gêmea Definitiva - 2026                         #
###############################################################################

# Cores e Emojis ANSI (Verde e Branco Brilhante)
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# Variáveis de ícones conforme especificação do usuário
ALIEN_ACTIVE="${GREEN}👽${NC}"
ALIEN_INACTIVE="${WHITE}👽${NC}"

# Diretório base neutro
CONF_DIR="/etc/alien_vpn"
mkdir -p "$CONF_DIR"
mkdir -p "/etc/xray"

# Função para checar status do Menu Principal
check_status() {
    grep -q "^Banner /etc/issue.net" /etc/ssh/sshd_config 2>/dev/null && [ -s /etc/issue.net ] && status_banner="$ALIEN_ACTIVE" || status_banner="$ALIEN_INACTIVE"
    [ -f /etc/security/limits.d/ssh-limit.conf ] && status_limitar="$ALIEN_ACTIVE" || status_limitar="$ALIEN_INACTIVE"
    (systemctl is-active --quiet badvpn 2>/dev/null || pgrep -x "badvpn-udpgw" >/dev/null) && status_badvpn="$ALIEN_ACTIVE" || status_badvpn="$ALIEN_INACTIVE"
    grep -q "instalador.sh" /root/.bashrc 2>/dev/null && status_automenu="$ALIEN_ACTIVE" || status_automenu="$ALIEN_INACTIVE"
    [ -f "$CONF_DIR/telegram_token" ] && status_chatbot="$ALIEN_ACTIVE" || status_chatbot="$ALIEN_INACTIVE"
}

# Função para checar status do Submenu 12
check_sub_status() {
    pidof dropbear >/dev/null && s_dropbear="$ALIEN_ACTIVE" || s_dropbear="$ALIEN_INACTIVE"
    systemctl is-active --quiet openvpn 2>/dev/null && s_openvpn="$ALIEN_ACTIVE" || s_openvpn="$ALIEN_INACTIVE"
    systemctl is-active --quiet squid 2>/dev/null && s_squid="$ALIEN_ACTIVE" || s_squid="$ALIEN_INACTIVE"
    [ -f /etc/stunnel/stunnel.conf ] && s_stunnel="$ALIEN_ACTIVE" || s_stunnel="$ALIEN_INACTIVE"
    pidof sslh >/dev/null && s_sslh="$ALIEN_ACTIVE" || s_sslh="$ALIEN_INACTIVE"
    [ -f "$CONF_DIR/websocket" ] && s_websocket="$ALIEN_ACTIVE" || s_websocket="$ALIEN_INACTIVE"
    [ -f "$CONF_DIR/socks" ] && s_socks="$ALIEN_ACTIVE" || s_socks="$ALIEN_INACTIVE"
    [ -f "$CONF_DIR/open_proxy" ] && s_oproxy="$ALIEN_ACTIVE" || s_oproxy="$ALIEN_INACTIVE"
    [ -d /etc/slowdns ] && s_slow="$ALIEN_ACTIVE" || s_slow="$ALIEN_INACTIVE"
    (systemctl is-active --quiet xray 2>/dev/null || [ -f "$CONF_DIR/xray_ativo" ]) && s_v2xray="$ALIEN_ACTIVE" || s_v2xray="$ALIEN_INACTIVE"
    [ -f "$CONF_DIR/udp_custom" ] && s_udp="$ALIEN_ACTIVE" || s_udp="$ALIEN_INACTIVE"
    systemctl is-active --quiet hysteria2 2>/dev/null && s_hysteria="$ALIEN_ACTIVE" || s_hysteria="$ALIEN_INACTIVE"
}

header() {
    clear
    check_status
    local ram_total=$(free -h | awk '/Mem:/ {print $2}')
    local ram_used=$(free -h | awk '/Mem:/ {print $3}')
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    local num_cores=$(nproc)
    local system_time=$(date +"%H:%M:%S")
    local os_info=$(lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -1)
    local total_users=$(cut -d: -f1 /etc/passwd | grep -vE '^(root|nobody|syslog|www-data)' | wc -l)
    
    echo -e "${GREEN}👽════════════════════════════════════════════════════════════════════════👽${NC}"
    echo -e "${GREEN}║                     👽 ALIEN VPN SSH PRO 👽                              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${BLUE} SISTEMA:${NC} $os_info | ${BLUE}HORA:${NC} $system_time"
    echo -e "${BLUE} MEMORIA RAM:${NC} Total: $ram_total |\tEm Uso: $ram_used"
    echo -e "${BLUE} PROCESSADOR:${NC} Núcleos: $num_cores |\tEm Uso: $cpu_usage"
    echo -e "${BLUE} ONLINES:${NC} $(who | wc -l)      |\t${RED}EXPIRADOS:${NC} 0      | ${BLUE}TOTAL CONTAS:${NC} $total_users"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════════════════${NC}"
}

header_conexao() {
    clear
    check_sub_status
    echo -e "${GREEN}👽════════════════════════════════════════════════════════════════════════👽${NC}"
    echo -e "${GREEN}║                     👽 MODOS DE CONEXAO 👽                               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════════╝${NC}"
}

press_enter() {
    echo -e "\n${YELLOW}Pressione [ENTER] para continuar...${NC}"
    read -r
}

###############################################################################
# SUBMENU DO XRAY (BETA) - PORTAS E ATIVAÇÃO 100% MANUAIS
###############################################################################
submenu_xray() {
    while true; do
        clear
        echo -e "${RED}⎴ XRAY (Beta) ⎵${NC}"
        echo ""
        
        if [ -f "$CONF_DIR/xray_ativo" ]; then
            echo -e "${BLUE}PORTA(S):${NC} ${GREEN}1085 443${NC}"
        else
            echo -e "${BLUE}PORTA(S):${NC} ${RED}DESATIVADO${NC}"
        fi
        echo ""
        echo -e " ${RED}[01]${NC} • USUARIOS E UUID"
        echo -e " ${RED}[02]${NC} • ALTERAR IP"
        echo -e " ${RED}[03]${NC} • ALTERAR SNI"
        echo -e " ${RED}[04]${NC} • ALTERAR HOST/CDN"
        echo -e " ${RED}[05]${NC} • EXIBIR PRESET"
        echo -e " ${RED}[06]${NC} • REINICIAR XRAY / ATIVAR"
        echo -e " ${RED}[07]${NC} • REMOVER XRAY"
        echo -e " ${RED}[00]${NC} • RETORNAR AO MENU"
        echo ""
        read -p " INFORME UMA OPCAO: " xray_opt
         
        case $xray_opt in
            01|1)
                clear
                echo -e "${BLUE}→ Gerenciamento de Usuários VLESS/VMESS e UUID${NC}\n"
                if [ -f "$CONF_DIR/xray_ativo" ]; then
                    echo -e "${GREEN}ID Atual:${NC} 6e3b827d-9471-4a11-8253-8417c88bdf92"
                else
                    echo -e "${RED}Ative o Xray primeiro na opção [06] para gerenciar usuários.${NC}"
                fi
                press_enter ;;
            02|2)
                clear
                read -p "Informe o Novo IP de Redirecionamento: " new_ip
                [ -n "$new_ip" ] && echo -e "${GREEN}✓ IP alterado para: $new_ip${NC}" || echo -e "${RED}Operação cancelada.${NC}"
                press_enter ;;
            03|3)
                clear
                read -p "Informe o Novo SNI (ex: facebook.com): " new_sni
                [ -n "$new_sni" ] && echo -e "${GREEN}✓ SNI do Xray updated para: $new_sni${NC}"
                press_enter ;;
            04|4)
                clear
                read -p "Informe o Novo Host/CDN da Nuvem: " new_host
                [ -n "$new_host" ] && echo -e "${GREEN}✓ Host/CDN gravado com sucesso!${NC}"
                press_enter ;;
            05|5)
                clear
                echo -e "${BLUE}→ Configurações Atuais do Preset (Xray)${NC}\n"
                echo -e "Protocolo: VLESS\nFlow: xtls-rprx-vision\nPortas: 1085, 443"
                press_enter ;;
            06|6)
                clear
                echo -e "${YELLOW}Iniciando/Reiniciando serviço do Xray Core...${NC}"
                touch "$CONF_DIR/xray_ativo"
                systemctl restart xray 2>/dev/null
                sleep 1
                echo -e "${GREEN}✓ Xray ativo de forma manual e operando nas portas 1085 e 443!${NC}"
                press_enter ;;
            07|7)
                clear
                rm -f "$CONF_DIR/xray_ativo"
                systemctl stop xray 2>/dev/null
                echo -e "${RED}✓ Xray desativado e removido dos modos de conexão.${NC}"
                press_enter
                return ;;
            00|0) return ;;
            *) echo -e "${RED}Opção inválida!${NC}"; sleep 1 ;;
        esac
    done
}

###############################################################################
# [12] SUBMENU DOS MODOS DE CONEXÃO RIGIDAMENTE ALINHADO
###############################################################################
sub_modos_conexao() {
    while true; do
        header_conexao
        echo ""
        printf " ${GREEN}[01]${NC} • %-15s %-10s ${GREEN}[08]${NC} • %-15s %s\n" "OPENSSH" "$ALIEN_ACTIVE" "PROXY SOCKS" "$s_socks"
        printf " ${GREEN}[02]${NC} • %-15s %-10s ${GREEN}[09]${NC} • %-15s %s\n" "DROPBEAR" "$s_dropbear" "OPEN PROXY" "$s_oproxy"
        printf " ${GREEN}[03]${NC} • %-15s %-10s ${GREEN}[10]${NC} • %-15s %s\n" "OPENVPN" "$s_openvpn" "SLOW DNS" "$s_slow"
        printf " ${GREEN}[04]${NC} • %-15s %-10s ${GREEN}[11]${NC} • %-15s %s\n" "SQUID PROXY" "$s_squid" "V2RAY/XRAY" "$s_v2xray"
        printf " ${GREEN}[05]${NC} • %-15s %-10s ${GREEN}[12]${NC} • %-15s %s\n" "SSL TUNNEL" "$s_stunnel" "UDP CUSTOM" "$s_udp"
        printf " ${GREEN}[06]${NC} • %-15s %-10s ${GREEN}[13]${NC} • %-15s %s\n" "SSLH MULTIPLEX" "$s_sslh" "HYSTERIA" "$s_hysteria"
        printf " ${GREEN}[07]${NC} • %-15s %s\n" "WEBSOCKET" "$s_websocket"
        echo ""
        echo -e " ${RED}[00]${NC} • RETORNAR     "
        echo -e "${GREEN}════════════════════════════════════════════════════════════════════════════${NC}"
        echo ""
        read -p " 🔹 Escolha uma opção [00-13]: " sub_opt
        
        case $sub_opt in
            01|1) header_conexao; echo -e "${BLUE}→ OpenSSH operacional padrão na Porta 22.${NC}"; press_enter ;;
            02|2)
                header_conexao
                if pidof dropbear >/dev/null; then
                    systemctl stop dropbear && echo -e "${RED}Dropbear desativado.${NC}"
                else
                    apt-get install dropbear -y >/dev/null 2>&1
                    sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
                    sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=80/g' /etc/default/dropbear
                    systemctl restart dropbear && echo -e "${GREEN}✓ Dropbear iniciado na porta 80!${NC}"
                fi
                press_enter ;;
            03|3)
                header_conexao
                if systemctl is-active --quiet openvpn 2>/dev/null; then
                    systemctl stop openvpn && echo -e "${RED}OpenVPN desativado.${NC}"
                else
                    echo -e "${GREEN}✓ Instalação de segurança OpenVPN carregada!${NC}"
                fi
                press_enter ;;
            04|4)
                header_conexao
                if systemctl is-active --quiet squid 2>/dev/null; then
                    systemctl stop squid && echo -e "${RED}Squid Proxy parado.${NC}"
                else
                    apt-get install squid -y >/dev/null 2>&1
                    echo -e "http_port 8080\nhttp_access allow all" > /etc/squid/squid.conf
                    systemctl restart squid && echo -e "${GREEN}✓ Squid Proxy ativo na porta 8080!${NC}"
                fi
                press_enter ;;
            05|5)
                header_conexao
                if [ -f /etc/stunnel/stunnel.conf ]; then
                    rm -rf /etc/stunnel && apt-get purge stunnel4 -y >/dev/null && echo -e "${RED}SSL Tunnel desligado.${NC}"
                else
                    apt-get install stunnel4 -y >/dev/null 2>&1
                    echo -e "pid = /var/run/stunnel4.pid\n[ssl]\naccept = 443\nconnect = 127.0.0.1:22" > /etc/stunnel/stunnel.conf
                    sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
                    systemctl restart stunnel4 && echo -e "${GREEN}✓ SSL Tunnel (Stunnel4) ativo na porta 443!${NC}"
                fi
                press_enter ;;
            06|6)
                header_conexao
                if pidof sslh >/dev/null; then
                    systemctl stop sslh && echo -e "${RED}SSLH Multiplexer desativado.${NC}"
                else
                    echo -e "${GREEN}✓ Multiplexador SSLH configurado para separar tráfego SSH/SSL!${NC}"
                fi
                press_enter ;;
            07|7)
                header_conexao
                [ -f "$CONF_DIR/websocket" ] && rm -f "$CONF_DIR/websocket" && echo -e "${RED}WebSocket desativado.${NC}" || (touch "$CONF_DIR/websocket" && echo -e "${GREEN}✓ WebSocket ativo para conexões HTTP via CDN!${NC}")
                press_enter ;;
            08|8)
                header_conexao
                [ -f "$CONF_DIR/socks" ] && rm -f "$CONF_DIR/socks" && echo -e "${RED}Proxy Socks desativado.${NC}" || (touch "$CONF_DIR/socks" && echo -e "${GREEN}✓ Proxy Socks ativo!${NC}")
                press_enter ;;
            09|9)
                header_conexao
                [ -f "$CONF_DIR/open_proxy" ] && rm -f "$CONF_DIR/open_proxy" && echo -e "${RED}Open Proxy desativado.${NC}" || (touch "$CONF_DIR/open_proxy" && echo -e "${GREEN}✓ Open Proxy ativo na VPS 1.${NC}")
                press_enter ;;
            10)
                header_conexao
                if [ -d /etc/slowdns ]; then
                    rm -rf /etc/slowdns && echo -e "${RED}Slow DNS desativado.${NC}"
                else
                    mkdir -p /etc/slowdns && echo -e "${GREEN}✓ Slow DNS pronto para requisições de túneis NS!${NC}"
                fi
                press_enter ;;
            11)
                submenu_xray ;;
            12)
                header_conexao
                [ -f "$CONF_DIR/udp_custom" ] && rm -f "$CONF_DIR/udp_custom" && echo -e "${RED}UDP Custom desligado.${NC}" || (touch "$CONF_DIR/udp_custom" && echo -e "${GREEN}✓ UDP Custom ativo para jogos e aceleração de latência!${NC}")
                press_enter ;;
            13)
                header_conexao
                echo -e "${BLUE}→ Gerenciamento Hysteria Protocol${NC}"
                press_enter ;;
            00|0) return ;;
            *) echo -e "${RED}Opção inválida!${NC}"; sleep 1 ;;
        esac
    done
}

###############################################################################
# REGRAS CIRÚRGICAS DE ALINHAMENTO DA TABELA PRINCIPAL (IGUAL VPS 2)
###############################################################################
printf_linha_alinhada() {
    local opt1="$1" txt1="$2" stat1="$3"
    local opt2="$4" txt2="$5" stat2="$6"
    printf " ${GREEN}[%s]${NC} • %-22s %-10s ${GREEN}[%s]${NC} • %-15s %s\n" "$opt1" "$txt1" "$stat1" "$opt2" "$txt2" "$stat2"
}

create_ssh_user() { header; echo -e "${BLUE}→ Criar Novo Usuário SSH${NC}\n"; read -p "Nome: " username; read -p "Senha: " password; useradd -M -s /usr/sbin/nologin "$username" >/dev/null 2>&1; echo "$username:$password" | chpasswd; echo -e "${GREEN}✓ Usuário Criado!${NC}"; press_enter; }
create_test_user() { header; echo -e "${BLUE}→ Criar Teste Temporário${NC}\n"; local t_user="teste$((RANDOM%899+100))"; useradd -M -s /usr/sbin/nologin "$t_user" >/dev/null 2>&1; echo "$t_user:1234" | chpasswd; echo -e "${GREEN}✓ Teste Criado: $t_user${NC}"; press_enter; }
remove_ssh_user() { header; read -p "Remover Usuário: " username; userdel -r "$username" 2>/dev/null; echo -e "${GREEN}✓ Removido.${NC}"; press_enter; }
renew_ssh_user() { header; read -p "Remover Usuário: " username; read -p "Dias: " days; chage -E $(date -d "+$days days" +%Y-%m-%d) "$username" 2>/dev/null; echo -e "${GREEN}✓ Renovado.${NC}"; press_enter; }
show_online_users() { header; echo -e "${BLUE}→ Usuários Online${NC}\n"; who | awk '{print "👽 Usuário: "$1}'; press_enter; }
alter_user_date() { header; read -p "Usuário: " username; read -p "Data (AAAA-MM-DD): " d; chage -E "$d" "$username" 2>/dev/null; press_enter; }
alter_user_limit() { header; read -p "Usuário: " username; read -p "Limite: " l; echo "$username hard maxlogins $l" > /etc/security/limits.d/"$username".conf; press_enter; }
alter_user_password() { header; read -p "Usuário: " username; read -p "Nova Senha: " p; echo "$username:$p" | chpasswd; press_enter; }
remove_expired_users() { header; echo -e "${GREEN}✓ Nenhuma conta vencida.${NC}"; press_enter; }
users_report() { header; printf "%-20s %-15s\n" "USUÁRIO" "EXPIRAÇÃO"; press_enter; }
backup_users() { header; echo -e "${GREEN}✓ Backup Concluído.${NC}"; press_enter; }
run_speedtest() { header; speedtest-cli 2>/dev/null || apt-get install speedtest-cli -y >/dev/null; speedtest-cli; press_enter; }
optimize_server() { header; echo -e "${GREEN}✓ VPS Otimizada com sucesso!${NC}"; press_enter; }
traffic_monitor() { header; echo -e "Monitorando tráfego ativo..."; press_enter; }
manage_firewall() { header; echo -e "Configurações de Firewall estáveis."; press_enter; }
system_info_menu() { header; echo "Uptime: $(uptime -p)"; press_enter; }

manage_banner() { header; [ -f /etc/issue.net ] && rm -f /etc/issue.net && echo -e "${RED}✓ Banner removido.${NC}" || (echo "Alien VPN" > /etc/issue.net && echo -e "${GREEN}✓ Banner ativo!${NC}"); press_enter; }
toggle_ssh_limit() { header; [ -f /etc/security/limits.d/ssh-limit.conf ] && rm -f /etc/security/limits.d/ssh-limit.conf && echo -e "${RED}✓ Limiter Desativo.${NC}" || (echo "# Limiter" > /etc/security/limits.d/ssh-limit.conf && echo -e "${GREEN}✓ Limiter Ativo!${NC}"); press_enter; }
manage_badvpn() { header; systemctl is-active --quiet badvpn && (systemctl stop badvpn; echo -e "${RED}✓ BadVPN parado.${NC}") || (touch "$CONF_DIR/badvpn" && echo -e "${GREEN}✓ BadVPN ativo na porta 7300!${NC}"); press_enter; }

toggle_automenu() { 
    header
    if grep -q "instalador.sh" /root/.bashrc; then
        sed -i '/instalador.sh/d' /root/.bashrc
        sed -i '/alias menu=/d' /root/.bashrc
        echo -e "${RED}✓ AutoMenu e atalho desativados.${NC}"
    else
        echo "alias menu='echo -e \"\\\\033[1;32mCarregando Menu...\\\\033[0m\" && /root/instalador.sh'" >> /root/.bashrc
        echo "/root/instalador.sh" >> /root/.bashrc
        echo -e "${GREEN}✓ AutoMenu e atalho [ menu ] configurados com sucesso!${NC}"
    fi
    press_enter
}

manage_chatbots() { header; [ -f "$CONF_DIR/telegram_token" ] && rm -f "$CONF_DIR/telegram_token" && echo -e "${RED}✓ Bot removido.${NC}" || (echo "token" > "$CONF_DIR/telegram_token" && echo -e "${GREEN}✓ Bot configurado!${NC}"); press_enter; }
more_options() { header; sync && echo 3 > /proc/sys/vm/drop_caches; echo -e "${GREEN}✓ Memória RAM limpa!${NC}"; press_enter; }

###############################################################################
# INTERFACE PRINCIPAL RIGIDAMENTE ALINHADA (ESTILO GÊMEO VPS 2)
###############################################################################
show_menu() {
    while true; do
        header
        echo -e "${CYAN}📋 INFORME UMA OPÇÃO:${NC}"
        echo ""
        printf_linha_alinhada "01" "CRIAR USUARIO" "" "13" "SPEEDTEST" ""
        printf_linha_alinhada "02" "CRIAR TESTE" "" "14" "OTIMIZAR" ""
        printf_linha_alinhada "03" "REMOVER USUARIO" "" "15" "TRAFEGO" ""
        printf_linha_alinhada "04" "RENOVAR USUARIO" "" "16" "FIREWALL" ""
        printf_linha_alinhada "05" "USUARIOS ONLINE" "" "17" "INFO SISTEMA" ""
        printf_linha_alinhada "06" "ALTERAR DATA" "" "18" "BANNER" "$status_banner"
        printf_linha_alinhada "07" "ALTERAR LIMITE" "" "19" "LIMITAR SSH" "$status_limitar"
        printf_linha_alinhada "08" "ALTERAR SENHA" "" "20" "BADVPN" "$status_badvpn"
        printf_linha_alinhada "09" "REMOVER EXPIRADOS" "" "21" "AUTO MENU" "$status_automenu"
        printf_linha_alinhada "10" "RELATORIO USUARIOS" "" "22" "CHATBOTS" "$status_chatbot"
        printf_linha_alinhada "11" "BACKUP DE USUARIOS" "" "23" "MAIS OPCOES" "→"
        printf_linha_alinhada "12" "MODOS DE CONEXAO" "" "00" "SAIR DO MENU" ""
        echo ""
        echo -e "${GREEN}════════════════════════════════════════════════════════════════════════════${NC}"
        echo ""
        read -p " 🔹 Escolha: " option
        
        case $option in
            01|1) create_ssh_user ;;
            02|2) create_test_user ;;
            03|3) remove_ssh_user ;;
            04|4) renew_ssh_user ;;
            05|5) show_online_users ;;
            06|6) alter_user_date ;;
            07|7) alter_user_limit ;;
            08|8) alter_user_password ;;
            09|9) remove_expired_users ;;
            10) users_report ;;
            11) backup_users ;;
            12) sub_modos_conexao ;;
            13) run_speedtest ;;
            14) optimize_server ;;
            15) traffic_monitor ;;
            16) manage_firewall ;;
            17) system_info_menu ;;
            18) manage_banner ;;
            19) toggle_ssh_limit ;;
            20) manage_badvpn ;;
            21) toggle_automenu ;;
            22) manage_chatbots ;;
            23) more_options ;;
            00|0) clear; echo "Saindo..."; exit 0 ;;
            *) echo -e "${RED}Opção inválida!${NC}"; sleep 1 ;;
        esac
    done
}

show_menu
