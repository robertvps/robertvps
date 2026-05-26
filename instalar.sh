#!/bin/bash

###############################################################################
#          SSH PLUS MANAGER PRO - SCRIPT DE INSTALAÇÃO AUTOMÁTICA            #
#                        Versão: 2.0 - 2026                                   #
#                     Compatível: Ubuntu 22.04 / Debian 11+                   #
#                    Desenvolvido com suporte a Xray Core                     #
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
SCRIPT_DIR="/root/SSH-PLUS-MANAGER"
BACKUP_DIR="/root/ssh_backups"
XRAY_BIN="/usr/local/bin/xray"
XRAY_CONFIG="/etc/xray/config.json"

###############################################################################
# FUNÇÕES DE UTILIDADE
###############################################################################

header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║        SSH PLUS MANAGER PRO - v2.0                     ║${NC}"
    echo -e "${CYAN}║     Ubuntu 22.04 | Xray | V2Ray | Hysteria | Trojan   ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

press_enter() {
    echo -e "\n${YELLOW}Pressione [ENTER] para continuar...${NC}"
    read -r
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}✗ Este script deve ser executado como root!${NC}"
        echo -e "${YELLOW}Use: sudo ./install.sh${NC}"
        exit 1
    fi
}
check_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
            echo -e "${RED}✗ Sistema não suportado! Use Ubuntu ou Debian.${NC}"
            exit 1
        fi
        echo -e "${GREEN}✓ Sistema detectado: $NAME $VERSION_ID${NC}"
    else
        echo -e "${RED}✗ Não foi possível detectar o sistema operacional${NC}"
        exit 1
    fi
}

get_ip() {
    curl -s https://api.ipify.org 2>/dev/null || echo "0.0.0.0"
}

###############################################################################
# INSTALAÇÃO DO SISTEMA
###############################################################################

update_system() {
    header
    echo -e "${BLUE}→ Atualizando repositórios...${NC}"
    apt-get update -y > /dev/null 2>&1
    apt-get upgrade -y > /dev/null 2>&1
    echo -e "${GREEN}✓ Sistema atualizado${NC}"
    sleep 1
}

install_dependencies() {
    header
    echo -e "${BLUE}→ Instalando dependências...${NC}"
    
    DEPS=(
        curl wget nano zip unzip git bc jq screen net-tools 
        openssh-server apache2-utils python3 python3-pip lsb-release 
        ca-certificates gnupg socat cron
    )
    
    for dep in "${DEPS[@]}"; do
        echo -n "  • $dep... "
        apt-get install -y $dep > /dev/null 2>&1 && echo -e "${GREEN}OK${NC}" || echo -e "${RED}FALHA${NC}"
    done
    echo -e "${GREEN}✓ Dependências instaladas${NC}"
    sleep 1
}

setup_ssh() {    header
    echo -e "${BLUE}→ Configurando SSH...${NC}"
    
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    
    # Permitir autenticação por senha
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    
    # Permitir tunneling
    sed -i 's/#PermitTunnel yes/PermitTunnel yes/g' /etc/ssh/sshd_config
    sed -i 's/PermitTunnel no/PermitTunnel yes/g' /etc/ssh/sshd_config
    
    # Ajustar keepalive
    echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
    echo "ClientAliveCountMax 2" >> /etc/ssh/sshd_config
    
    systemctl restart ssh
    systemctl enable ssh
    
    echo -e "${GREEN}✓ SSH configurado${NC}"
    sleep 1
}

setup_firewall() {
    header
    echo -e "${BLUE}→ Configurando firewall (UFW)...${NC}"
    
    apt-get install -y ufw > /dev/null 2>&1
    ufw --force reset > /dev/null 2>&1
    
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 7300/udp  # BadVPN
    ufw allow 443/udp   # Hysteria
    
    echo "y" | ufw enable > /dev/null 2>&1
    
    echo -e "${GREEN}✓ Firewall configurado${NC}"
    sleep 1
}

optimize_system() {
    header
    echo -e "${BLUE}→ Aplicando otimizações...${NC}"
    
    # Limites de arquivos
    cat >> /etc/security/limits.conf << EOF
# SSH Plus Manager Optimizations* soft nofile 51200
* hard nofile 51200
* soft nproc 51200
* hard nproc 51200
root soft nofile 51200
root hard nofile 51200
EOF

    # Otimizações de rede
    cat >> /etc/sysctl.conf << EOF
# SSH Plus Manager Network Optimizations
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq
net.ipv4.tcp_fastopen = 3
EOF

    sysctl -p > /dev/null 2>&1
    
    # Ativar BBR se disponível
    if [[ $(sysctl net.ipv4.tcp_available_congestion_control | grep -c bbr) -ge 1 ]]; then
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        sysctl -p > /dev/null 2>&1
        echo -e "${GREEN}✓ BBR ativado${NC}"
    fi
    
    echo -e "${GREEN}✓ Otimizações aplicadas${NC}"
    sleep 1
}

###############################################################################
# FUNÇÕES DO MENU PRINCIPAL (23 OPÇÕES)
###############################################################################

# [01] Criar Conta SSH
create_ssh_user() {
    header
    echo -e "${BLUE}→ Criar Nova Conta SSH${NC}"
    echo ""
    
    read -p "Nome de usuário: " username
    read -p "Senha: " -s password
    echo ""
    read -p "Dias de validade: " days
    read -p "Limite de conexões: " limit
    
    # Criar usuário    useradd -M -s /usr/sbin/nologin "$username" > /dev/null 2>&1
    echo "$username:$password" | chpasswd
    
    # Definir expiração
    expiry_date=$(date -d "+$days days" +%Y-%m-%d)
    chage -E "$expiry_date" "$username"
    
    # Limitar conexões (via /etc/security/limits.d/)
    echo "$username hard maxlogins $limit" >> /etc/security/limits.d/ssh-limit.conf
    
    echo -e "${GREEN}✓ Usuário '$username' criado com sucesso!${NC}"
    echo -e "  IP: $(get_ip) | Porta: 22 | Validade: $expiry_date"
    press_enter
}

# [02] Remover Conta SSH
remove_ssh_user() {
    header
    echo -e "${BLUE}→ Remover Conta SSH${NC}"
    echo ""
    
    echo "Usuários SSH ativos:"
    cut -d: -f1 /etc/passwd | grep -vE '^(root|nobody|syslog|www-data)' | while read user; do
        id "$user" > /dev/null 2>&1 && echo "  • $user"
    done
    echo ""
    
    read -p "Usuário a remover: " username
    userdel -r "$username" 2>/dev/null && \
        echo -e "${GREEN}✓ Usuário '$username' removido${NC}" || \
        echo -e "${RED}✗ Erro ao remover usuário${NC}"
    press_enter
}

# [03] Listar Contas
list_ssh_users() {
    header
    echo -e "${BLUE}→ Contas SSH Ativas${NC}"
    echo ""
    printf "%-20s %-15s %-12s\n" "USUÁRIO" "VALIDADE" "CONEXÕES"
    echo "────────────────────────────────────────"
    
    for user in $(cut -d: -f1 /etc/passwd | grep -vE '^(root|nobody|syslog|www-data)'); do
        if id "$user" &>/dev/null; then
            expiry=$(chage -l "$user" 2>/dev/null | grep "Account expires" | cut -d: -f2 | xargs)
            [[ "$expiry" == "never" ]] && expiry="∞"
            connections=$(who | grep "$user" | wc -l)
            printf "%-20s %-15s %-12s\n" "$user" "$expiry" "$connections"
        fi
    done    echo ""
    press_enter
}

# [04] Usuários Online
show_online_users() {
    header
    echo -e "${BLUE}→ Usuários Online Agora${NC}"
    echo ""
    
    if [[ $(who | wc -l) -eq 0 ]]; then
        echo -e "${YELLOW}Nenhum usuário conectado${NC}"
    else
        who | while read line; do
            echo "  • $line"
        done
    fi
    echo ""
    press_enter
}

# [05] Limitar Conexões
limit_connections() {
    header
    echo -e "${BLUE}→ Limitar Conexões por Usuário${NC}"
    echo ""
    
    read -p "Usuário: " username
    read -p "Máximo de conexões: " maxconn
    
    mkdir -p /etc/security/limits.d
    echo "$username hard maxlogins $maxconn" > /etc/security/limits.d/"$username".conf
    
    echo -e "${GREEN}✓ Limite definido: $maxconn conexões para '$username'${NC}"
    press_enter
}

# [06] Definir Expiração
set_expiry() {
    header
    echo -e "${BLUE}→ Definir Expiração de Conta${NC}"
    echo ""
    
    read -p "Usuário: " username
    read -p "Dias até expirar: " days
    
    expiry=$(date -d "+$days days" +%Y-%m-%d)
    chage -E "$expiry" "$username"
    
    echo -e "${GREEN}✓ Conta '$username' expirará em: $expiry${NC}"    press_enter
}

# [07] BadVPN Manager
manage_badvpn() {
    header
    echo -e "${BLUE}→ Gerenciar BadVPN (UDP Gateway)${NC}"
    echo ""
    echo "1) Instalar BadVPN"
    echo "2) Iniciar BadVPN"
    echo "3) Parar BadVPN"
    echo "4) Reiniciar BadVPN"
    echo "5) Remover BadVPN"
    echo "0) Voltar"
    echo ""
    read -p "Opção: " opt
    
    case $opt in
        1)
            echo -e "${BLUE}→ Instalando BadVPN...${NC}"
            cd /root
            [[ -f badvpn-udpgw ]] && rm -f badvpn-udpgw
            wget -q https://raw.githubusercontent.com/jenbhie/SSH-PLUS-MANAGER/main/badvpn-udpgw
            chmod +x badvpn-udpgw
            mv badvpn-udpgw /usr/bin/badvpn-udpgw
            
            # Criar serviço systemd
            cat > /etc/systemd/system/badvpn.service << EOF
[Unit]
Description=BadVPN UDP Gateway
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/screen -dmS badvpn /usr/bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
            systemctl daemon-reload
            systemctl enable badvpn
            echo -e "${GREEN}✓ BadVPN instalado${NC}"
            ;;
        2) systemctl start badvpn && echo -e "${GREEN}✓ BadVPN iniciado${NC}" ;;
        3) systemctl stop badvpn && echo -e "${YELLOW}✓ BadVPN parado${NC}" ;;
        4) systemctl restart badvpn && echo -e "${GREEN}✓ BadVPN reiniciado${NC}" ;;
        5) 
            systemctl stop badvpn            systemctl disable badvpn
            rm -f /etc/systemd/system/badvpn.service /usr/bin/badvpn-udpgw
            systemctl daemon-reload
            echo -e "${GREEN}✓ BadVPN removido${NC}"
            ;;
        0) return ;;
        *) echo -e "${RED}Opção inválida${NC}" ;;
    esac
    press_enter
}

# [08] Squid Proxy
manage_squid() {
    header
    echo -e "${BLUE}→ Gerenciar Squid Proxy${NC}"
    echo ""
    
    read -p "Porta do Squid (padrão 3128): " squid_port
    squid_port=${squid_port:-3128}
    
    apt-get install -y squid > /dev/null 2>&1
    
    cat > /etc/squid/squid.conf << EOF
http_port $squid_port
http_access allow all
coredump_dir /var/spool/squid
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
EOF
    
    systemctl restart squid
    systemctl enable squid
    
    echo -e "${GREEN}✓ Squid instalado na porta $squid_port${NC}"
    echo -e "  Configuração: http://$(get_ip):$squid_port"
    press_enter
}

# [09] OpenVPN Manager
manage_openvpn() {
    header
    echo -e "${YELLOW}⚠ OpenVPN requer configuração manual avançada${NC}"
    echo "Recomendamos usar: https://github.com/Nyr/openvpn-install"
    echo ""
    read -p "Deseja instalar o script automático do OpenVPN? (s/n): " confirm
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        wget -O openvpn-install.sh https://get.vpnsetup.net
        chmod +x openvpn-install.sh        ./openvpn-install.sh
    fi
    press_enter
}

# [10] Xray Core Manager ⭐
manage_xray() {
    header
    echo -e "${MAGENTA}→ Xray Core Manager${NC}"
    echo ""
    echo "1) Instalar Xray Core"
    echo "2) Configurar VLESS + TLS"
    echo "3) Configurar VMESS + WebSocket"
    echo "4) Configurar Trojan"
    echo "5) Ver Status do Xray"
    echo "6) Reiniciar Xray"
    echo "0) Voltar"
    echo ""
    read -p "Opção: " opt
    
    case $opt in
        1)
            echo -e "${BLUE}→ Instalando Xray Core...${NC}"
            bash <(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh) @ install
            echo -e "${GREEN}✓ Xray Core instalado${NC}"
            ;;
        2)
            echo -e "${BLUE}→ Configurando VLESS + TLS${NC}"
            read -p "Seu domínio (para certificado TLS): " domain
            read -p "UUID do cliente (ou deixe vazio para gerar): " uuid
            [[ -z "$uuid" ]] && uuid=$(cat /proc/sys/kernel/random/uuid)
            
            # Instalar certbot se necessário
            apt-get install -y certbot > /dev/null 2>&1
            
            mkdir -p /etc/xray /etc/xray/certs
            certbot certonly --standalone -d "$domain" --agree-tos --non-interactive --email admin@"$domain"
            cp /etc/letsencrypt/live/"$domain"/fullchain.pem /etc/xray/certs/cert.pem
            cp /etc/letsencrypt/live/"$domain"/privkey.pem /etc/xray/certs/key.pem
            
            cat > "$XRAY_CONFIG" << EOF
{
  "inbounds": [{
    "port": 443,
    "protocol": "vless",
    "settings": {
      "clients": [{"id": "$uuid", "level": 0, "email": "user@vless"}],
      "decryption": "none"
    },
    "streamSettings": {      "network": "tcp",
      "security": "tls",
      "tlsSettings": {
        "certificates": [{"certificateFile": "/etc/xray/certs/cert.pem", "keyFile": "/etc/xray/certs/key.pem"}]
      }
    }
  }],
  "outbounds": [{"protocol": "freedom"}]
}
EOF
            systemctl restart xray
            echo -e "${GREEN}✓ VLESS+TLS configurado${NC}"
            echo -e "  UUID: $uuid"
            echo -e "  Endereço: $domain:443"
            ;;
        3)
            echo -e "${BLUE}→ Configurando VMESS + WebSocket${NC}"
            read -p "Domínio: " domain
            read -p "Path do WebSocket (ex: /vmess): " ws_path
            ws_path=${ws_path:-/vmess}
            uuid=${uuid:-$(cat /proc/sys/kernel/random/uuid)}
            
            cat > "$XRAY_CONFIG" << EOF
{
  "inbounds": [{
    "port": 80,
    "listen": "0.0.0.0",
    "protocol": "vmess",
    "settings": {
      "clients": [{"id": "$uuid", "level": 1, "email": "user@vmess"}]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {"path": "$ws_path"}
    }
  }],
  "outbounds": [{"protocol": "freedom"}]
}
EOF
            systemctl restart xray
            echo -e "${GREEN}✓ VMESS+WebSocket configurado${NC}"
            echo -e "  UUID: $uuid | Path: $ws_path"
            echo -e "  Endereço: http://$domain$ws_path"
            ;;
        4)
            echo -e "${BLUE}→ Configurando Trojan${NC}"
            read -p "Domínio: " domain
            read -p "Senha do Trojan: " trojan_pass
            
            mkdir -p /etc/xray/certs            certbot certonly --standalone -d "$domain" --agree-tos --non-interactive --email admin@"$domain" 2>/dev/null
            
            cat > "$XRAY_CONFIG" << EOF
{
  "inbounds": [{
    "port": 443,
    "protocol": "trojan",
    "settings": {
      "clients": [{"password": "$trojan_pass", "email": "user@trojan"}]
    },
    "streamSettings": {
      "network": "tcp",
      "security": "tls",
      "tlsSettings": {
        "certificates": [{"certificateFile": "/etc/xray/certs/cert.pem", "keyFile": "/etc/xray/certs/key.pem"}]
      }
    }
  }],
  "outbounds": [{"protocol": "freedom"}]
}
EOF
            systemctl restart xray
            echo -e "${GREEN}✓ Trojan configurado${NC}"
            echo -e "  Senha: $trojan_pass | Endereço: $domain:443"
            ;;
        5) systemctl status xray --no-pager -l ;;
        6) systemctl restart xray && echo -e "${GREEN}✓ Xray reiniciado${NC}" ;;
        0) return ;;
        *) echo -e "${RED}Opção inválida${NC}" ;;
    esac
    press_enter
}

# [11] V2Ray Manager
manage_v2ray() {
    header
    echo -e "${BLUE}→ V2Ray Manager${NC}"
    echo ""
    echo "1) Instalar V2Ray"
    echo "2) Gerar Config VMess"
    echo "3) Ver Status"
    echo "0) Voltar"
    echo ""
    read -p "Opção: " opt
    
    case $opt in
        1)
            echo -e "${BLUE}→ Instalando V2Ray...${NC}"
            bash <(curl -L https://raw.githubusercontent.com/v2fly/flyio/master/install-release.sh)
            echo -e "${GREEN}✓ V2Ray instalado${NC}"            ;;
        2)
            echo -e "${BLUE}→ Gerando configuração VMess...${NC}"
            uuid=$(cat /proc/sys/kernel/random/uuid)
            port=$((2000 + RANDOM % 1000))
            echo -e "  UUID: $uuid"
            echo -e "  Porta: $port"
            echo -e "  Altere /etc/v2ray/config.json com estes valores"
            ;;
        3) systemctl status v2ray --no-pager -l ;;
        0) return ;;
        *) echo -e "${RED}Opção inválida${NC}" ;;
    esac
    press_enter
}

# [12] Hysteria Manager
manage_hysteria() {
    header
    echo -e "${BLUE}→ Hysteria 2 Manager${NC}"
    echo ""
    
    read -p "Porta UDP (padrão 443): " hy_port
    hy_port=${hy_port:-443}
    read -p "Senha do Hysteria: " hy_pass
    
    # Baixar binário
    curl -fsSL https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64 -o /usr/local/bin/hysteria
    chmod +x /usr/local/bin/hysteria
    
    # Configurar
    mkdir -p /etc/hysteria
    cat > /etc/hysteria/config.yaml << EOF
listen: :$hy_port
tls:
  cert: /etc/hysteria/cert.pem
  key: /etc/hysteria/key.pem
auth:
  type: password
  password: "$hy_pass"
bandwidth:
  up: "100 mbps"
  down: "100 mbps"
EOF

    # Certificado auto-assinado se não tiver domínio
    openssl req -x509 -nodes -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
        -keyout /etc/hysteria/key.pem -out /etc/hysteria/cert.pem \
        -days 3650 -subj "/CN=hysteria.local" 2>/dev/null
        # Serviço systemd
    cat > /etc/systemd/system/hysteria.service << EOF
[Unit]
Description=Hysteria Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/hysteria server -c /etc/hysteria/config.yaml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable hysteria
    systemctl start hysteria
    
    echo -e "${GREEN}✓ Hysteria 2 configurado${NC}"
    echo -e "  Porta UDP: $hy_port | Senha: $hy_pass"
    echo -e "  Config client: hysteria client -s seu_ip:$hy_port -p $hy_pass"
    press_enter
}

# [13] Trojan-Go Manager
manage_trojan_go() {
    header
    echo -e "${BLUE}→ Trojan-Go Manager${NC}"
    echo ""
    echo -e "${YELLOW}⚠ Instalação manual recomendada via GitHub${NC}"
    echo "https://github.com/p4gefau1t/trojan-go"
    echo ""
    read -p "Deseja baixar o binário? (s/n): " confirm
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        LATEST=$(curl -s https://api.github.com/repos/p4gefau1t/trojan-go/releases/latest | grep "browser_download_url.*linux-amd64.zip" | cut -d '"' -f 4)
        wget -q "$LATEST" -O /tmp/trojan-go.zip
        unzip -o /tmp/trojan-go.zip -d /tmp/
        mv /tmp/trojan-go /usr/local/bin/
        chmod +x /usr/local/bin/trojan-go
        echo -e "${GREEN}✓ Trojan-Go baixado${NC}"
    fi
    press_enter
}

# [14] SlowDNS Manager
manage_slowdns() {
    header
    echo -e "${BLUE}→ SlowDNS Manager${NC}"    echo ""
    
    echo "1) Instalar SlowDNS Server"
    echo "2) Gerar Config Cliente"
    echo "0) Voltar"
    echo ""
    read -p "Opção: " opt
    
    case $opt in
        1)
            echo -e "${BLUE}→ Instalando SlowDNS...${NC}"
            cd /root
            git clone https://github.com/aryanrhino/slowdns-server.git 2>/dev/null
            cd slowdns-server
            chmod +x install.sh
            ./install.sh
            echo -e "${GREEN}✓ SlowDNS instalado${NC}"
            ;;
        2)
            echo -e "${BLUE}→ Configuração do Cliente SlowDNS${NC}"
            echo "  Nameserver: $(get_ip)"
            echo "  Porta: 53"
            echo "  Token: $(head -c 16 /dev/urandom | base64 | tr -d '=+/' | cut -c1-16)"
            ;;
        0) return ;;
        *) echo -e "${RED}Opção inválida${NC}" ;;
    esac
    press_enter
}

# [15] WebSocket + TLS
manage_wstls() {
    header
    echo -e "${BLUE}→ WebSocket + TLS/SSL${NC}"
    echo ""
    echo -e "${YELLOW}Configure via Xray ou Nginx como reverse proxy${NC}"
    echo ""
    read -p "Seu domínio: " domain
    apt-get install -y nginx certbot python3-certbot-nginx > /dev/null 2>&1
    certbot --nginx -d "$domain" --agree-tos --non-interactive --email admin@"$domain"
    echo -e "${GREEN}✓ TLS configurado para $domain${NC}"
    press_enter
}

# [16] BBR + Otimizações
manage_bbr() {
    header
    echo -e "${BLUE}→ BBR + Otimizações de Rede${NC}"
    echo ""
        if [[ $(sysctl net.ipv4.tcp_available_congestion_control | grep -c bbr) -ge 1 ]]; then
        echo -e "${GREEN}✓ BBR já está disponível${NC}"
        sysctl net.ipv4.tcp_congestion_control
    else
        echo -e "${YELLOW}⚠ Kernel muito antigo para BBR${NC}"
        echo "Atualize seu kernel ou use Ubuntu 22.04+"
    fi
    echo ""
    echo "Otimizações aplicadas em /etc/sysctl.conf"
    press_enter
}

# [17] Firewall Manager
manage_firewall_menu() {
    header
    echo -e "${BLUE}→ Gerenciar Firewall (UFW)${NC}"
    echo ""
    echo "1) Ver status"
    echo "2) Liberar porta"
    echo "3) Bloquear IP"
    echo "4) Resetar regras"
    echo "0) Voltar"
    echo ""
    read -p "Opção: " opt
    
    case $opt in
        1) ufw status verbose ;;
        2) 
            read -p "Porta a liberar (ex: 8080/tcp): " port
            ufw allow "$port" && echo -e "${GREEN}✓ Porta $port liberada${NC}"
            ;;
        3) 
            read -p "IP a bloquear: " ip
            ufw deny from "$ip" && echo -e "${GREEN}✓ IP $ip bloqueado${NC}"
            ;;
        4) 
            echo "y" | ufw reset
            echo -e "${GREEN}✓ Firewall resetado${NC}"
            ;;
        0) return ;;
        *) echo -e "${RED}Opção inválida${NC}" ;;
    esac
    press_enter
}

# [18] Monitoramento
manage_monitoring() {
    header
    echo -e "${BLUE}→ Monitoramento do Servidor${NC}"
    echo ""    
    echo "1) Instalar Netdata (web dashboard)"
    echo "2) Ver uso de CPU/RAM (htop)"
    echo "3) Ver tráfego de rede (iftop)"
    echo "0) Voltar"
    echo ""
    read -p "Opção: " opt
    
    case $opt in
        1)
            echo -e "${BLUE}→ Instalando Netdata...${NC}"
            bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait --dont-start-it
            systemctl start netdata
            echo -e "${GREEN}✓ Netdata instalado${NC}"
            echo -e "  Acesse: http://$(get_ip):19999"
            ;;
        2) 
            apt-get install -y htop > /dev/null 2>&1
            htop
            ;;
        3) 
            apt-get install -y iftop > /dev/null 2>&1
            iftop -P -n
            ;;
        0) return ;;
        *) echo -e "${RED}Opção inválida${NC}" ;;
    esac
}

# [19] Atualizar Script
update_script() {
    header
    echo -e "${BLUE}→ Atualizar SSH Plus Manager${NC}"
    echo ""
    
    echo -e "${YELLOW}⚠ Isso substituirá seu script atual${NC}"
    read -p "Continuar? (s/n): " confirm
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        cd /root
        rm -rf SSH-PLUS-MANAGER
        git clone https://github.com/jenbhie/SSH-PLUS-MANAGER.git 2>/dev/null
        echo -e "${GREEN}✓ Script atualizado${NC}"
    fi
    press_enter
}

# [20] Backup
backup_configs() {
    header
    echo -e "${BLUE}→ Backup de Configurações${NC}"    echo ""
    
    mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="$BACKUP_DIR/backup-$(date +%Y%m%d-%H%M).tar.gz"
    
    tar -czf "$BACKUP_FILE" \
        /etc/ssh/sshd_config \
        /etc/xray/ 2>/dev/null \
        /etc/v2ray/ 2>/dev/null \
        /etc/hysteria/ 2>/dev/null \
        /etc/squid/ 2>/dev/null \
        /etc/security/limits.d/ 2>/dev/null
    
    echo -e "${GREEN}✓ Backup criado: $BACKUP_FILE${NC}"
    press_enter
}

# [21] Uninstall
uninstall_all() {
    header
    echo -e "${RED}→ Remover SSH Plus Manager${NC}"
    echo ""
    echo -e "${RED}⚠ ATENÇÃO: Isso removerá TODAS as configurações!${NC}"
    read -p "Tem certeza? Digite SIM para confirmar: " confirm
    
    if [[ "$confirm" == "SIM" ]]; then
        # Remover serviços
        systemctl stop xray v2ray hysteria badvpn squid netdata 2>/dev/null
        systemctl disable xray v2ray hysteria badvpn squid netdata 2>/dev/null
        
        # Remover pacotes
        apt-get remove -y squid ufw netdata htop iftop 2>/dev/null
        
        # Remover arquivos
        rm -rf /etc/xray /etc/v2ray /etc/hysteria /usr/local/bin/xray /usr/local/bin/hysteria
        rm -f /etc/systemd/system/{xray,v2ray,hysteria,badvpn}.service
        
        # Restaurar SSH
        [[ -f /etc/ssh/sshd_config.bak ]] && mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
        systemctl restart ssh
        
        echo -e "${GREEN}✓ Desinstalação concluída${NC}"
    else
        echo -e "${YELLOW}Operação cancelada${NC}"
    fi
    press_enter
}

# [22] Configurações do Servidor
server_settings() {    header
    echo -e "${BLUE}→ Configurações do Servidor${NC}"
    echo ""
    
    echo "IP Público: $(get_ip)"
    echo "Hostname: $(hostname)"
    echo "Sistema: $(lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -1)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo ""
    echo "1) Alterar hostname"
    echo "2) Alterar senha root"
    echo "3) Ver logs do sistema"
    echo "0) Voltar"
    echo ""
    read -p "Opção: " opt
    
    case $opt in
        1) 
            read -p "Novo hostname: " newhost
            hostnamectl set-hostname "$newhost"
            echo -e "${GREEN}✓ Hostname alterado${NC}"
            ;;
        2) passwd root ;;
        3) tail -100 /var/log/syslog ;;
        0) return ;;
        *) echo -e "${RED}Opção inválida${NC}" ;;
    esac
    press_enter
}

# [00] Sair
exit_script() {
    header
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     SSH PLUS MANAGER PRO - Encerrando...              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Obrigado por usar o SSH Plus Manager Pro!${NC}"
    echo -e "${YELLOW}Dúvidas? Suporte: github.com/jenbhie/SSH-PLUS-MANAGER${NC}"
    echo ""
    exit 0
}

###############################################################################
# MENU PRINCIPAL
###############################################################################

show_menu() {
    while true; do        header
        echo -e "${CYAN}📋 MENU PRINCIPAL - 23 OPÇÕES${NC}"
        echo "════════════════════════════════════════"
        echo -e "${GREEN}[01]${NC} Criar Conta SSH          ${GREEN}[02]${NC} Remover Conta SSH"
        echo -e "${GREEN}[03]${NC} Listar Contas            ${GREEN}[04]${NC} Usuários Online"
        echo -e "${GREEN}[05]${NC} Limitar Conexões         ${GREEN}[06]${NC} Definir Expiração"
        echo -e "${GREEN}[07]${NC} BadVPN Manager           ${GREEN}[08]${NC} Squid Proxy"
        echo -e "${GREEN}[09]${NC} OpenVPN Manager          ${MAGENTA}[10]${NC} Xray Core Manager ⭐"
        echo -e "${GREEN}[11]${NC} V2Ray Manager            ${GREEN}[12]${NC} Hysteria 2 Manager"
        echo -e "${GREEN}[13]${NC} Trojan-Go Manager        ${GREEN}[14]${NC} SlowDNS Manager"
        echo -e "${GREEN}[15]${NC} WebSocket + TLS          ${GREEN}[16]${NC} BBR + Otimizações"
        echo -e "${GREEN}[17]${NC} Firewall Manager         ${GREEN}[18]${NC} Monitoramento"
        echo -e "${GREEN}[19]${NC} Atualizar Script         ${GREEN}[20]${NC} Backup Configs"
        echo -e "${RED}[21]${NC} Uninstall All             ${GREEN}[22]${NC} Server Settings"
        echo "────────────────────────────────────────"
        echo -e "${RED}[00]${NC} Sair"
        echo "════════════════════════════════════════"
        echo ""
        read -p "🔹 Escolha uma opção [00-22]: " option
        
        case $option in
            01|1) create_ssh_user ;;
            02|2) remove_ssh_user ;;
            03|3) list_ssh_users ;;
            04|4) show_online_users ;;
            05|5) limit_connections ;;
            06|6) set_expiry ;;
            07|7) manage_badvpn ;;
            08|8) manage_squid ;;
            09|9) manage_openvpn ;;
            10) manage_xray ;;
            11) manage_v2ray ;;
            12) manage_hysteria ;;
            13) manage_trojan_go ;;
            14) manage_slowdns ;;
            15) manage_wstls ;;
            16) manage_bbr ;;
            17) manage_firewall_menu ;;
            18) manage_monitoring ;;
            19) update_script ;;
            20) backup_configs ;;
            21) uninstall_all ;;
            22) server_settings ;;
            00|0) exit_script ;;
            *) echo -e "${RED}✗ Opção inválida! Tente novamente.${NC}"; sleep 1 ;;
        esac
    done
}

################################################################################ FUNÇÃO PRINCIPAL DE INSTALAÇÃO
###############################################################################

main_install() {
    check_root
    check_os
    update_system
    install_dependencies
    setup_ssh
    setup_firewall
    optimize_system
    
    # Criar diretórios
    mkdir -p "$SCRIPT_DIR" "$BACKUP_DIR"
    
    header
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     ✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📁 Script instalado em: ${SCRIPT_DIR}${NC}"
    echo -e "${CYAN}📁 Backups em: ${BACKUP_DIR}${NC}"
    echo ""
    echo -e "${YELLOW}▶ O menu principal será iniciado em 3 segundos...${NC}"
    sleep 3
    
    show_menu
}

###############################################################################
# INÍCIO DO SCRIPT
###############################################################################

# Se o script for executado diretamente, roda a instalação
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main_install
fi
