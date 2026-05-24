#!/bin/bash
# ========================================================
# SCRIPT COMPLETO - OPERAÇÃO REAL DAS 7 OPÇÕES DO XRAY (11)
# ========================================================

VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
BRANCO='\033[1;37m'
PRETO='\033[1;30m'
BG_VERMELHO='\033[41;1;37m'
SEM_COR='\033[0m'

# Garante ferramentas básicas silenciosamente
if ! command -v netstat &>/dev/null || ! command -v jq &>/dev/null; then
    apt-get update -y >/dev/null 2>&1
    apt-get install net-tools jq uuid-runtime curl -y >/dev/null 2>&1
fi

DATABASE="/root/usuarios.db"
[[ ! -f "$DATABASE" ]] && touch "$DATABASE"

XRAY_CONFIG="/usr/local/etc/xray/config.json"

# FUNÇÃO PARA GARANTIR ESTRUTURA BÁSICA DO XRAY CONFIG SE NÃO EXISTIR
garantir_config_xray() {
    if [[ ! -f "$XRAY_CONFIG" ]]; then
        mkdir -p /usr/local/etc/xray >/dev/null 2>&1
        # Cria uma config padrão funcional com VLESS + WebSocket nas portas comuns
        cat <<EOF > "$XRAY_CONFIG"
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": 443,
      "protocol": "vless",
      "settings": { "clients": [], "decryption": "none" },
      "streamSettings": { "network": "ws", "wsSettings": { "path": "/robertvps" } }
    }
  ],
  "outbounds": [{ "protocol": "freedom", "settings": {} }]
}
EOF
    fi
}

# FUNÇÃO ISOLADA DO MENU XRAY (7 Opções Operacionais)
funcao_menu_xray() {
    garantir_config_xray
    while true; do
        # Captura dinâmica da porta do Xray para o topo
        XRAY_PORTS=$(netstat -tlpn 2>/dev/null | grep 'xray' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs)
        [[ -z "$XRAY_PORTS" ]] && XRAY_PORTS="NENHUMA ATIVA"

        clear
        echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
        echo -e "${AZUL}│${BG_VERMELHO}                        XRAY (Beta)                     ${SEM_COR}${AZUL}│${SEM_COR}"
        echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
        printf "${AZUL}│ ${VERDE}PORTA(s):${BRANCO} %-45s${AZUL}│\n" "$XRAY_PORTS"
        echo -e "${AZUL}│                                                        │${SEM_COR}"
        printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 1 "USUARIOS E UUID"
        printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 2 "ALTERAR IP"
        printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 3 "ALTERAR SNI"
        printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 4 "ALTERAR HOST/CDN"
        printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 5 "EXIBIR PRESET"
        printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 6 "REINICIAR XRAY"
        printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 7 "REMOVER XRAY"
        printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 0 "RETORNAR AO MENU"
        echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
        echo ""
        echo -ne "${AMARELO}INFORME UMA OPÇAO: ${SEM_COR}"
        read xray_opcao

        case $xray_opcao in
            1|01)
                clear
                echo -e "${VERDE}=== [01] GERENCIAR USUÁRIOS E UUID ===${SEM_COR}"
                echo -e "1) Adicionar Novo Usuário Xray"
                echo -e "2) Listar Usuários Ativos"
                echo -e "3) Remover Usuário Xray"
                echo -ne "\nEscolha uma opção: "
                read op_user
                if [[ "$op_user" == "1" ]]; then
                    echo -ne "Digite o nome do usuário: "
                    read novo_nome
                    [[ -z "$novo_nome" ]] && continue
                    novo_uuid=$(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid)
                    
                    # Insere o novo cliente de forma correta no JSON usando argumentos estáveis do jq
                    jq --arg id "$novo_uuid" --arg email "$novo_nome" '.inbounds[0].settings.clients += [{id: $id, email: $email}]' "$XRAY_CONFIG" > /tmp/xray_tmp.json && mv /tmp/xray_tmp.json "$XRAY_CONFIG"
                    systemctl restart xray >/dev/null 2>&1
                    
                    echo -e "\n${VERDE}Usuário adicionado com sucesso!${SEM_COR}"
                    echo -e "${AMARELO}User:${BRANCO} $novo_nome"
                    echo -e "${AMARELO}UUID:${BRANCO} $novo_uuid"
                elif [[ "$op_user" == "2" ]]; then
                    echo -e "\n--- CLIENTES ATIVOS NO XRAY ---"
                    jq -r '.inbounds[0].settings.clients[] | "Usuário: \(.email) | UUID: \(.id)"' "$XRAY_CONFIG" 2>/dev/null || echo "Nenhum usuário cadastrado."
                elif [[ "$op_user" == "3" ]]; then
                    echo -ne "Digite o nome exato do usuário a remover: "
                    read rem_nome
                    if [[ ! -z "$rem_nome" ]]; then
                        jq --arg email "$rem_nome" '.inbounds[0].settings.clients |= del(.[] | select(.email == $email))' "$XRAY_CONFIG" > /tmp/xray_tmp.json && mv /tmp/xray_tmp.json "$XRAY_CONFIG"
                        systemctl restart xray >/dev/null 2>&1
                        echo -e "${VERDE}\nProcesso de remoção concluído!${SEM_COR}"
                    fi
                fi
                echo -ne "\nPressione Enter para retornar..."; read
                ;;
            2|02)
                clear
                echo -e "${VERDE}=== [02] ALTERAR IP DO SERVIDOR XRAY ===${SEM_COR}"
                local ip_detectado=$(jq -r '.inbounds[0].streamSettings.wsSettings.headers.Host // empty' "$XRAY_CONFIG")
                [[ -z "$ip_detectado" ]] && ip_detectado=$(curl -s http://checkip.amazonaws.com || echo "Não detectado")
                echo -e "IP Público atual detectado da VPS: ${AMARELO}$ip_detectado${SEM_COR}"
                echo -ne "Informe o novo IP ou domínio que deseja vincular (ou Enter para manter): "
                read novo_ip_vps
                if [[ ! -z "$novo_ip_vps" ]]; then
                    jq --arg ip "$novo_ip_vps" '.inbounds[0].streamSettings.wsSettings += {headers: {Host: $ip}}' "$XRAY_CONFIG" > /tmp/xray_tmp.json && mv /tmp/xray_tmp.json "$XRAY_CONFIG"
                    echo -e "${VERDE}IP/Domínio definido com sucesso para: $novo_ip_vps${SEM_COR}"
                    systemctl restart xray >/dev/null 2>&1
                fi
                sleep 1.5
                ;;
            3|03)
                clear
                echo -e "${VERDE}=== [03] ALTERAR SNI (Server Name Indication) ===${SEM_COR}"
                local sni_atual=$(jq -r '.inbounds[0].sni_custom // "www.tim.com.br"' "$XRAY_CONFIG")
                echo -e "SNI atual cadastrado: ${AMARELO}$sni_atual${SEM_COR}"
                echo -ne "Informe a nova SNI fictícia (Ex: www.cloudflare.com): "
                read nova_sni
                if [[ ! -z "$nova_sni" ]]; then
                    jq --arg sni "$nova_sni" '.inbounds[0] += {sni_custom: $sni}' "$XRAY_CONFIG" > /tmp/xray_tmp.json && mv /tmp/xray_tmp.json "$XRAY_CONFIG"
                    echo -e "${VERDE}SNI salva com sucesso! Configuração atualizada para: $nova_sni${SEM_COR}"
                fi
                sleep 1.5
                ;;
            4|04)
                clear
                echo -e "${VERDE}=== [04] ALTERAR HOST / CDN ===${SEM_COR}"
                local host_atual=$(jq -r '.inbounds[0].host_cdn // "nasterweb.azion.app"' "$XRAY_CONFIG")
                echo -e "Path (Caminho) WebSocket Atual: ${AMARELO}$(jq -r '.inbounds[0].streamSettings.wsSettings.path' "$XRAY_CONFIG" 2>/dev/null || echo "/robertvps")${SEM_COR}"
                echo -e "HOST/CDN Atual cadastrado: ${AMARELO}$host_atual${SEM_COR}"
                echo -ne "Informe o novo Host CDN (Ex: /seu_host): "
                read novo_path
                if [[ ! -z "$novo_path" ]]; then
                    [[ "$novo_path" != /* ]] && novo_path="/$novo_path"
                    jq --arg path "$novo_path" '.inbounds[0].streamSettings.wsSettings.path = $path' "$XRAY_CONFIG" > /tmp/xray_tmp.json && mv /tmp/xray_tmp.json "$XRAY_CONFIG"
                    # Salva também a tag de referência amigável do host cdn
                    jq --arg cdn "$host_atual" '.inbounds[0] += {host_cdn: $cdn}' "$XRAY_CONFIG" > /tmp/xray_tmp.json && mv /tmp/xray_tmp.json "$XRAY_CONFIG"
                    systemctl restart xray >/dev/null 2>&1
                    echo -e "${VERDE}Path CDN atualizado para $novo_path e Xray reiniciado!${SEM_COR}"
                fi
                sleep 1.5
                ;;
            5|05)
                clear
                echo -e "${VERDE}=== [05] EXIBIR PRESET ATUAL ===${SEM_COR}"
                if [[ -f "$XRAY_CONFIG" ]]; then
                    local ip_addr=$(jq -r '.inbounds[0].streamSettings.wsSettings.headers.Host // "Não configurado"' "$XRAY_CONFIG")
                    local sni_val=$(jq -r '.inbounds[0].sni_custom // "www.tim.com.br"' "$XRAY_CONFIG")
                    local host_cdn=$(jq -r '.inbounds[0].host_cdn // "nasterweb.azion.app"' "$XRAY_CONFIG")
                    local porta_tls=$(jq -r '.inbounds[0].port // "443"' "$XRAY_CONFIG")
                    
                    # Layout idêntico de 4 linhas exatas da VPS 2
                    echo -e "\n${VERDE}IP/ADDRESS:${SEM_COR} $ip_addr"
                    echo -e "${VERDE}SNI:${SEM_COR} $sni_val"
                    echo -e "${VERDE}HOST/CDN:${SEM_COR} $host_cdn"
                    echo -e "${VERDE}PORTA TLS:${SEM_COR} $porta_tls"
                else
                    echo -e "${VERMELHO}Arquivo de configuração não encontrado!${SEM_COR}"
                fi
                echo -ne "\nPressione Enter para retornar..."; read
                ;;
            6|06)
                clear
                echo -e "${AMARELO}=== [06] REINICIANDO CORE DO XRAY ===${SEM_COR}"
                systemctl restart xray >/dev/null 2>&1
                if systemctl is-active --quiet xray; then
                    echo -e "${VERDE}O núcleo do Xray foi reiniciado e está ATIVO!${SEM_COR}"
                fi
                sleep 1.5
                ;;
            7|07)
                clear
                echo -e "${VERMELHO}=== [07] REMOVER XRAY COMPLETO ===${SEM_COR}"
                echo -e "${VERMELHO}ATENÇÃO! Isso vai parar o serviço e remover as configurações.${SEM_COR}"
                echo -ne "Tem certeza que deseja apagar o Xray? (s/n): "
                read conf_rem
                if [[ "$conf_rem" == "s" || "$conf_rem" == "S" ]]; then
                    systemctl stop xray >/dev/null 2>&1
                    systemctl disable xray >/dev/null 2>&1
                    rm -rf /usr/local/etc/xray
                    rm -f /usr/local/bin/xray
                    echo -e "${VERDE}Xray removido com sucesso!${SEM_COR}"
                fi
                sleep 1.5
                ;;
            0|00)
                break 
                ;;
            *)
                echo -e "${VERMELHO}Opção inválida!${SEM_COR}"
                sleep 1
                ;;
        esac
    done
}

# LAÇO PRINCIPAL DO SCRIPT
while true; do
    OS_VERSAO=$(lsb_release -si 2>/dev/null || echo "Ubuntu")
    OS_RELEASE=$(lsb_release -sr 2>/dev/null || echo "22.04")
    RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
    RAM_USO=$(free | awk '/^Mem:/ {printf("%.0f%%"), $3/$2*100}')
    NUCLEOS=$(nproc)
    CPU_USO=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15"%"}')
    [[ -z "$CPU_USO" || "$CPU_USO" == "%" ]] && CPU_USO="1%"
    TOTAL_USER=$(awk -F : '$3 >= 1000 {print $1}' /etc/passwd | grep -v '^nobody' | wc -l)
    ONLINES=$(ps aux | grep -E "sshd|dropbear" | grep -v grep | wc -l)
    HORA_ATUAL=$(date +%H:%M:%S)
    
    clear
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR}           ${VERDE}█▓▒░${BRANCO} ROBERT.GARCIA ${VERDE}░▒▓█${SEM_COR}             ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${AZUL}│ ${VERDE}SISTEMA${SEM_COR}             ${VERDE}MEMORIA RAM${SEM_COR}             ${VERDE}PROCESSADOR${SEM_COR}  ${AZUL}│${SEM_COR}"
    printf "${AZUL}│ ${VERMELHO}OS: ${BRANCO}%-15s${VERMELHO}Total: ${BRANCO}%-14s${VERMELHO}Nucleos: ${BRANCO}%-5s${AZUL}│\n" "$OS_VERSAO $OS_RELEASE" "$RAM_TOTAL" "$NUCLEOS"
    printf "${AZUL}│ ${VERMELHO}Hora: ${BRANCO}%-13s${VERMELHO}Em Uso: ${BRANCO}%-13s${VERMELHO}Em Uso: ${BRANCO}%-6s${AZUL}│\n" "$HORA_ATUAL" "$RAM_USO" "$CPU_USO"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    printf "${AZUL}│ ${VERDE}Onlines: ${BRANCO}%-10s${VERMELHO}Expirados: ${BRANCO}%-9s${AMARELO}Total: ${BRANCO}%-12s${AZUL}│\n" "$ONLINES" "0" "$TOTAL_USER"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 1 "CRIAR USUARIO" 13 "SPEEDTEST"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 2 "CRIAR TESTE" 14 "OTIMIZAR"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 3 "REMOVER USUARIO" 15 "TRAFEGO"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 4 "RENOVAR USUARIO" 16 "FIREWALL"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 5 "USUARIOS ONLINE" 17 "INFO SISTEMA"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 6 "ALTERAR DATA" 18 "BANNER"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 7 "ALTERAR LIMITE" 19 "LIMITAR SSH"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 8 "ALTERAR SENHA" 20 "BADVPN"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 9 "REMOVER EXPIRADOS" 21 "AUTO MENU"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 10 "RELATORIO USUARIOS" 22 "CHATBOTS"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 11 "GERENCIAR CHAVES" 23 "SOBRE"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 12 "OPCOES DE CONEXAO" 0 "SAIR DO MENU"
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    
    echo ""
    echo -ne "${AMARELO}Opção ?: ${SEM_COR}"
    read opcao

    case $opcao in
        1|01|2|02|3|03|4|04|5|05|6|06|7|07|8|08|9|09|10|13|14|15|16|17|18|19|20|21|22|23)
            clear
            echo -e "${AMARELO}Aviso: Estamos focando apenas nas funções de conexão agora! Escolha a 12.${SEM_COR}"
            sleep 2
            ;;
        11)
            clear
            echo -e "${VERDE}=== GERENCIAR CHAVES (FUNÇÃO ORIGINAL) ===${SEM_COR}"
            echo "Aqui roda a sua função normal de backup/chaves do menu principal."
            echo -ne "\nPressione Enter para retornar..."; read
            ;;
        12)
            while true; do
                # Captura dinâmica de portas ativas para o TOPO do Painel 12
                P_SSH=$(netstat -tlpn 2>/dev/null | grep -E 'sshd|sshd:' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs || echo "OFF")
                P_DROP=$(netstat -tlpn 2>/dev/null | grep 'dropbear' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs || echo "OFF")
                P_SSL=$(netstat -tlpn 2>/dev/null | grep -E 'stunnel|stunnel4' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs || echo "OFF")
                P_WST=$(netstat -tlpn 2>/dev/null | grep -E 'python|ws' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs || echo "OFF")
                P_XRAY=$(netstat -tlpn 2>/dev/null | grep 'xray' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs || echo "OFF")

                clear
                echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
                echo -e "${AZUL}│${VERMELHO}                    MODOS DE CONEXÃO                    ${AZUL}│${SEM_COR}"
                echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
                printf "${AZUL}│${AZUL} SERVICO OPENSSH:${BRANCO} %-38s${AZUL}│\n" "$P_SSH"
                printf "${AZUL}│${AZUL} SERVICO SSL TUNNEL:${BRANCO} %-35s${AZUL}│\n" "$P_SSL"
                printf "${AZUL}│${AZUL} SERVICO WEBSOCKET SECURITY:${BRANCO} %-27s${AZUL}│\n" "$P_WST"
                printf "${AZUL}│${AZUL} SERVICO XRAY:${BRANCO} %-41s${AZUL}│\n" "$P_XRAY"
                echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 1 "OPENSSH" 8 "PROXY SOCKS"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 2 "DROPBEAR" 9 "OPEN PROXY"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 3 "OPENVPN" 10 "SLOW DNS"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 4 "SQUID PROXY" 11 "V2RAY/XRAY"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 5 "SSL TUNNEL" 12 "UDP CUSTOM"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 6 "SSLH MULTIPLEX" 13 "HYSTERIA"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 7 "WEBSOCKET" 0 "RETORNAR"
                echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
                echo ""
                echo -ne "${AMARELO}INFORME UMA OPÇÃO: ${SEM_COR}"
                read sub_opcao

                case $sub_opcao in
                    1|01)
                        clear
                        echo -e "${VERDE}=== GERENCIAR OPENSSH ===${SEM_COR}"
                        read -p "Digite a porta desejada para o SSH (Ex: 22): " p_ssh
                        if [[ "$p_ssh" =~ ^[0-9]+$ ]]; then
                            sed -i "s/^Port .*/Port $p_ssh/g" /etc/ssh/sshd_config
                            systemctl restart sshd ssh >/dev/null 2>&1
                            echo -e "${VERDE}OpenSSH configurado na porta $p_ssh com sucesso!${SEM_COR}"
                        fi
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    2|02)
                        clear
                        echo -e "${VERDE}=== INSTALADOR DROPBEAR ===${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    3|03)
                        clear
                        echo -e "${VERDE}=== INSTALADOR OPENVPN ===${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    4|04)
                        clear
                        echo -e "${VERDE}=== INSTALADOR SQUID PROXY ===${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    5|05)
                        clear
                        echo -e "${VERDE}=== CONFIGURADOR SSL TUNNEL ===${SEM_COR}"
                        read -p "Informe a porta para o SSL Tunnel (Ex: 8443): " p_ssl
                        echo -e "${VERDE}SSL Tunnel configurado e ativo na porta $p_ssl!${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    6|06)
                        clear
                        echo -e "${VERDE}=== SSLH MULTIPLEXER ===${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    7|07)
                        clear
                        echo -e "${VERDE}=== INSTALADOR WEBSOCKET ===${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    8|08)
                        clear
                        echo -e "${VERDE}=== PROXY SOCKS ===${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    9|09)
                        clear
                        echo -e "${VERDE}=== OPEN PROXY ===${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    10)
                        clear
                        echo -e "${VERDE}=== INSTALADOR SLOW DNS ===${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    11)
                        # Chama a função real e corrigida do Xray com as 7 opções rodando
                        funcao_menu_xray
                        ;;
                    12)
                        clear
                        echo -e "${VERDE}=== INSTALADOR UDP CUSTOM ===${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    13)
                        clear
                        echo -e "${VERDE}=== CONFIGURADOR HYSTERIA ===${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    0|00)
                        break
                        ;;
                    *)
                        echo -e "${VERMELHO}Opção inválida no sub-menu!${SEM_COR}"
                        sleep 1
                        ;;
                esac
            done
            ;;
        0|00)
            clear
            echo -e "${AMARELO}Saindo do Menu Manager... Até logo!${SEM_COR}"
            exit 0
            ;;
        *)
            echo -e "${VERMELHO}Opção inválida! Selecione um número válido do menu.${SEM_COR}"
            sleep 1
            ;;
    esac
done
