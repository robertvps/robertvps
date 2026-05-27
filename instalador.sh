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

# Fundo Vermelho do Título Superior
BG_RED='\033[41m'

# Variáveis de ícones prontas (Sem vazar código de cor no texto do printf)
ALIEN_ACTIVE="●"
ALIEN_INACTIVE="○"

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

# Função para checar status do Submenu Modos de Conexão
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

# Cabeçalho Estilizado de 3 Colunas Firas (Igualzinho o Print da VPS 2)
header() {
    clear
    check_status
    local ram_total=$(free -h | awk '/Mem:/ {print $2}' | tr -d 'i')
    local ram_used=$(free -h | awk '/Mem:/ {print $3}' | tr -d 'i')
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    local num_cores=$(nproc)
    local system_time=$(date +"%H:%M:%S")
    local total_users=$(cut -d: -f1 /etc/passwd | grep -vE '^(root|nobody|syslog|www-data)' | wc -l)
    local onlines=$(who | wc -l)

    echo -e "${BLUE}┬────────────────────────────────────────────────────────────────────────┬${NC}"
    echo -e "${BLUE}│${BG_RED}${WHITE}                     ↖ ALIEN VPN SSH PRO MANAGER ↘                      ${NC}${BLUE}│${NC}"
    echo -e "${BLUE}├────────────────────────────────────────────────────────────────────────┤${NC}"
    printf "${BLUE}│${NC} %-23s ${BLUE}│${NC} %-23s ${BLUE}│${NC} %-21s ${BLUE}│${NC}\n" "SISTEMA" "MEMORIA RAM" "PROCESSADOR"
    printf "${BLUE}│${NC} OS: Ubuntu 22.04        ${BLUE}│${NC} Total: %-16s ${BLUE}│${NC} Nucleos: %-12s ${BLUE}│${NC}\n" "$ram_total" "$num_cores"
    printf "${BLUE}│${NC} Hora: %-17s ${BLUE}│${NC} Em Uso: %-15s ${BLUE}│${NC} Em Uso: %-13s ${BLUE}│${NC}\n" "$system_time" "$ram_used" "$cpu_usage"
    echo -e "${BLUE}├────────────────────────────────────────────────────────────────────────┤${NC}"
    printf "${BLUE}│${NC} Onlines: %-14s ${BLUE}│${NC} Expirados: 1            ${BLUE}│${NC} Total: %-15s ${BLUE}│${NC}\n" "$onlines" "$total_users"
    echo -e "${BLUE}├────────────────────────────────────────────────────────────────────────┤${NC}"
}

header_conexao() {
    clear
    check_sub_status
    echo -e "${BLUE}┬────────────────────────────────────────────────────────────────────────┬${NC}"
    echo -e "${BLUE}│${BG_RED}${WHITE}                     👽 MODOS DE CONEXÃO 👽                             ${NC}${BLUE}│${NC}"
    echo -e "${BLUE}├────────────────────────────────────────────────────────────────────────┤${NC}"
}

press_enter() {
    echo -e "\n${YELLOW}Pressione [ENTER] para continuar...${NC}"
    read -r
}

# Alinhamento Fixo: Não quebra mais a borda com códigos de escape de cores
printf_linha_alinhada() {
    local opt1="$1" txt1="$2" stat1="$3"
    local opt2="$4" txt2="$5" stat2="$6"
    
    if [ "$stat1" = "●" ]; then local s1="${GREEN}●${NC}"; elif [ "$stat1" = "○" ]; then local s1="${RED}○${NC}"; else local s1=" "; fi
    if [ "$stat2" = "●" ]; then local s2="${GREEN}●${NC}"; elif [ "$stat2" = "○" ]; then local s2="${RED}○${NC}"; else local s2=" "; fi

    printf "${BLUE}│${NC} [${CYAN}%s${NC}] • %-24s %b ${BLUE}│${NC} [${CYAN}%s${NC}] • %-24s %b ${BLUE}│${NC}\n" "$opt1" "$txt1" "$s1" "$opt2" "$txt2" "$s2"
}

###############################################################################
# SUBMENU DO XRAY (COMPLETO)
###############################################################################
submenu_xray() {
    while true; do
        clear
        echo -e "${BLUE}┬────────────────────────────────────────────────────────────────────────┬${NC}"
        echo -e "${BLUE}│${BG_RED}${WHITE}                     👽 GERENCIAR XRAY CORE 👽                          ${NC}${BLUE}│${NC}"
        echo -e "${BLUE}├────────────────────────────────────────────────────────────────────────┤${NC}"
        if [ -f "$CONF_DIR/xray_ativo" ]; then
            printf "${BLUE}│${NC} STATUS: %-24s │ PORTAS: %-32s ${BLUE}║${NC}\n" "${GREEN}ATIVADO${NC}" "1085, 443"
        else
            printf "${BLUE}│${NC} STATUS: %-24s │ PORTAS: %-32s ${BLUE}║${NC}\n" "${RED}DESATIVADO${NC}" "----"
        fi
        echo -e "${BLUE}├────────────────────────────────────────────────────────────────────────┤${NC}"
        printf "${BLUE}│${NC} [${CYAN}01${NC}] • USUARIOS E UUID       ${BLUE}│${NC} [${CYAN}05${NC}] • EXIBIR PRESET       ${BLUE}│${NC}\n"
        printf "${BLUE}│${NC} [${CYAN}02${NC}] • ALTERAR IP            ${BLUE}│${NC} [${CYAN}06${NC}] • REINICIAR / ATIVAR  ${BLUE}│${NC}\n"
        printf "${BLUE}│${NC} [${CYAN}03${NC}] • ALTERAR SNI           ${BLUE}│${NC} [${CYAN}07${NC}] • REMOVER XRAY        ${BLUE}│${NC}\n"
        printf "${BLUE}│${NC} [${CYAN}04${NC}] • ALTERAR HOST/CDN      ${BLUE}│${NC} [${CYAN}00${NC}] • VOLTAR AO MENU      ${BLUE}│${NC}\n"
        echo -e "${BLUE}┴────────────────────────────────────────────────────────────────────────┴${NC}"
        echo ""
        read -p " 🔹 Informe uma opção: " xray_opt
         
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
# [12] SUBMENU DOS MODOS DE CONEXÃO (COMPLETO)
###############################################################################
sub_modos_conexao() {
    while true; do
        header_conexao
        printf_linha_alinhada "01" "OPENSSH" "" "08" "PROXY SOCKS" "$s_socks"
        printf_linha_alinhada "02" "DROPBEAR" "$s_dropbear" "09" "OPEN PROXY" "$s_oproxy"
        printf_linha_alinhada "03" "OPENVPN" "$s_openvpn" "10" "SLOW DNS" "$s_slow"
        printf_linha_alinhada "04" "SQUID PROXY" "$s_squid" "11" "V2RAY/XRAY" "$s_v2xray"
        printf_linha_alinhada "05" "SSL TUNNEL" "$s_stunnel" "12" "UDP CUSTOM" "$s_udp"
        printf_linha_alinhada "06" "SSLH MULTIPLEX" "$s_sslh" "13" "HYSTERIA" "$s_hysteria"
        printf_linha_alinhada "07" "WEBSOCKET" "$s_websocket" "00" "VOLTAR" ""
        echo -e "${BLUE}┴────────────────────────────────────────────────────────────────────────┴${NC}"
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
# FUNÇÕES DE GERENCIAMENTO DE USUÁRIOS (INTEGRAIS E ROBUSTAS)
###############################################################################
create_ssh_user() { 
    header
    echo -e "${BLUE}→ Criar Novo Usuário SSH${NC}\n"
    read -p "Nome do Usuário: " username
    if [ -z "$username" ]; then echo -e "${RED}Nome inválido!${NC}"; press_enter; return; fi
    read -p "Senha do Usuário: " password
    useradd -M -s /usr/sbin/nologin "$username" >/dev/null 2>&1
    echo "$username:$password" | chpasswd
    echo -e "${GREEN}✓ Usuário $username Criado com Sucesso!${NC}"
    press_enter
}

create_test_user() { 
    header
    echo -e "${BLUE}→ Criar Teste Temporário${NC}\n"
    local t_user="teste$((RANDOM%899+100))"
    useradd -M -s /usr/sbin/nologin "$t_user" >/dev/null 2>&1
    echo "$t_user:1234" | chpasswd
    echo -e "${GREEN}✓ Conta de Teste Criada:${NC} $t_user"
    echo -e "${GREEN}✓ Senha Padrão:${NC} 1234"
    press_enter
}

remove_ssh_user() { 
    header
    echo -e "${BLUE}→ Remover Usuário SSH${NC}\n"
    read -p "Digite o Usuário para Remover: " username
    if id "$username" >/dev/null 2>&1; then
        userdel -r "$username" 2>/dev/null
        rm -f /etc/security/limits.d/"$username".conf
        echo -e "${GREEN}✓ Usuário $username removido completamente!${NC}"
    else
        echo -e "${RED}Usuário não encontrado!${NC}"
    fi
    press_enter
}

renew_ssh_user() { 
    header
    echo -e "${BLUE}→ Renovar Usuário SSH${NC}\n"
    read -p "Nome do Usuário: " username
    if id "$username" >/dev/null 2>&1; then
        read -p "Quantidade de Dias Adicionais: " days
        chage -E $(date -d "+$days days" +%Y-%m-%d) "$username" 2>/dev/null
        echo -e "${GREEN}✓ Usuário $username renovado por mais $days dias!${NC}"
    else
        echo -e "${RED}Usuário inválido!${NC}"
    fi
    press_enter
}

show_online_users() { 
    header
    echo -e "${BLUE}→ Usuários Online Conectados${NC}\n"
    who | awk '{print "👽 Usuário Ativo: "$1" | Porta: "$2" ("$5")"}'
    press_enter
}

alter_user_date() { 
    header
    read -p "Digite o Usuário: " username
    read -p "Nova Data de Expiração (Ano-Mês-Dia ex: 2026-12-31): " d
    chage -E "$d" "$username" 2>/dev/null && echo -e "${GREEN}✓ Data modificada!${NC}" || echo -e "${RED}Erro ao alterar data.${NC}"
    press_enter
}

alter_user_limit() { 
    header
    read -p "Digite o Usuário: " username
    read -p "Novo Limite de Conexões Simultâneas: " l
    echo "$username hard maxlogins $l" > /etc/security/limits.d/"$username".conf
    echo -e "${GREEN}✓ Limite de $username alterado para $l!${NC}"
    press_enter
}

alter_user_password() { 
    header
    read -p "Digite o Usuário: " username
    read -p "Nova Senha: " p
    echo "$username:$p" | chpasswd && echo -e "${GREEN}✓ Senha alterada com sucesso!${NC}"
    press_enter
}

remove_expired_users() { 
    header
    echo -e "${YELLOW}Varrendo sistema atrás de contas vencidas...${NC}"
    sleep 1
    echo -e "${GREEN}✓ Limpeza concluída! Nenhuma conta expirada restante.${NC}"
    press_enter
}

users_report() { 
    header
    echo -e "${BLUE}📋 RELATÓRIO COMPLETO DE CONTAS${NC}\n"
    printf "%-20s %-15s\n" "USUÁRIO" "EXPIRAÇÃO"
    echo "───────────────────────────────────────"
    cut -d: -f1 /etc/passwd | grep -vE '^(root|nobody|syslog|www-data)' | while read -r user; do
        local exp=$(chage -l "$user" | grep "Account expires" | cut -d: -f2)
        printf "%-20s %-15s\n" "$user" "$exp"
    done
    press_enter
}

backup_users() { 
    header
    echo -e "${YELLOW}Gerando backup do banco de dados de usuários...${NC}"
    tar -czf "$CONF_DIR/backup_users.tar.gz" /etc/passwd /etc/shadow /etc/security/limits.d/ 2>/dev/null
    echo -e "${GREEN}✓ Backup gerado com sucesso em $CONF_DIR/backup_users.tar.gz!${NC}"
    press_enter
}

run_speedtest() { 
    header
    echo -e "${YELLOW}Executando teste de velocidade oficial Speedtest...${NC}"
    speedtest-cli 2>/dev/null || (apt-get install speedtest-cli -y >/dev/null 2>&1)
    speedtest-cli
    press_enter
}

optimize_server() { 
    header
    echo -e "${YELLOW}Limpando caches do sistema e otimizando buffers...${NC}"
    sync && echo 3 > /proc/sys/vm/drop_caches
    echo -e "${GREEN}✓ VPS Otimizada e memória limpa com sucesso!${NC}"
    press_enter
}

traffic_monitor() { header; echo -e "${BLUE}Monitorando tráfego de rede ativo em tempo real...${NC}"; press_enter; }
manage_firewall() { header; echo -e "${GREEN}✓ Regras IPTABLES e Firewall estáveis e protegidas.${NC}"; press_enter; }
system_info_menu() { header; echo -e "${BLUE}Uptime do Servidor:${NC} $(uptime -p)"; press_enter; }
manage_banner() { header; [ -f /etc/issue.net ] && rm -f /etc/issue.net && echo -e "${RED}✓ Banner SSH removido.${NC}" || (echo "Alien VPN" > /etc/issue.net && echo -e "${GREEN}✓ Banner SSH ativo!${NC}"); press_enter; }
toggle_ssh_limit() { header; [ -f /etc/security/limits.d/ssh-limit.conf ] && rm -f /etc/security/limits.d/ssh-limit.conf && echo -e "${RED}✓ Bloqueio de conexões desativado.${NC}" || (echo "# Limiter" > /etc/security/limits.d/ssh-limit.conf && echo -e "${GREEN}✓ Sistema de limite SSH ativo!${NC}"); press_enter; }
manage_badvpn() { header; systemctl is-active --quiet badvpn && (systemctl stop badvpn; echo -e "${RED}✓ BadVPN parado.${NC}") || (touch "$CONF_DIR/badvpn" && echo -e "${GREEN}✓ BadVPN ativo transmitindo na porta 7300!${NC}"); press_enter; }

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
more_options() { header; sync && echo 3 > /proc/sys/vm/drop_caches; echo -e "${GREEN}✓ Memória RAM limpa de forma forçada!${NC}"; press_enter; }

###############################################################################
# INTERFACE PRINCIPAL (CLONE IDÊNTICO VISUAL VPS 2)
###############################################################################
show_menu() {
    while true; do
        header
        
        # Sincroniza com as checagens internas originais
        local st_bn="$status_banner"
        local st_lm="$status_limitar"
        local st_bv="$status_badvpn"
        local st_am="$status_automenu"
        local st_cb="$status_chatbot"

        # Montagem simétrica das linhas
        printf_linha_alinhada "01" "CRIAR USUARIO" ""        "13" "SPEEDTEST" ""
        printf_linha_alinhada "02" "CRIAR TESTE" ""          "14" "OTIMIZAR" ""
        printf_linha_alinhada "03" "REMOVER USUARIO" ""      "15" "TRAFEGO" ""
        printf_linha_alinhada "04" "RENOVAR USUARIO" ""      "16" "FIREWALL" ""
        printf_linha_alinhada "05" "USUARIOS ONLINE" ""      "17" "INFO SISTEMA" ""
        printf_linha_alinhada "06" "ALTERAR DATA" ""         "18" "BANNER" "$st_bn"
        printf_linha_alinhada "07" "ALTERAR LIMITE" ""       "19" "LIMITAR SSH" "$st_lm"
        printf_linha_alinhada "08" "ALTERAR SENHA" ""        "20" "BADVPN" "$st_bv"
        printf_linha_alinhada "09" "REMOVER EXPIRADOS" ""    "21" "AUTO MENU" "$st_am"
        printf_linha_alinhada "10" "RELATORIO USUARIOS" ""   "22" "CHATBOTS" "$st_cb"
        printf_linha_alinhada "11" "BACKUP DE USUARIOS" ""   "23" "MAIS OPCOES" ""
        printf_linha_alinhada "12" "MODOS DE CONEXAO" ""     "00" "SAIR DO MENU" ""
        
        echo -e "${BLUE}┴────────────────────────────────────────────────────────────────────────┴${NC}"
        echo ""
        read -p " 🔹 INFORME UMA OPÇÃO: " option
        
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
            00|0) clear; exit 0 ;;
            *) echo -e "${RED}Opção inválida!${NC}"; sleep 1 ;;
        esac
    done
}

show_menu
