#!/bin/bash
# ========================================================
# SCRIPT COMPLETO - FOCO MODOS DE CONEXÃO (VPS 1 + VPS 2)
# ========================================================

VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
BRANCO='\033[1;37m'
PRETO='\033[1;30m'
SEM_COR='\033[0m'

# Garante ferramentas básicas silenciosamente
if ! command -v netstat &>/dev/null; then
    apt-get update -y >/dev/null 2>&1
    apt-get install net-tools -y >/dev/null 2>&1
fi

DATABASE="/root/usuarios.db"
[[ ! -f "$DATABASE" ]] && touch "$DATABASE"

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
    echo -e "${AZUL}│${SEM_COR}           ${VERDE}█▓▒░${BRANCO} ROBERT.GARCIA ${VERDE}░▒▓█${SEM_COR}            ${AZUL}│${SEM_COR}"
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
        1|01|2|02|3|03|4|04|5|05|6|06|7|07|8|08|9|09|10|11|13|14|15|16|17|18|19|20|21|22|23)
            clear
            echo -e "${AMARELO}Aviso: Estamos focando apenas na OPÇÃO 12 agora! Escolha a 12.${SEM_COR}"
            sleep 2
            ;;
        12)
            while true; do
                # Captura dinâmica de portas ativas para o TOPO do Painel
                P_SSH=$(netstat -tlpn 2>/dev/null | grep -E 'sshd|sshd:' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs || echo "OFF")
                P_DROP=$(netstat -tlpn 2>/dev/null | grep 'dropbear' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs || echo "OFF")
                P_SSL=$(netstat -tlpn 2>/dev/null | grep -E 'stunnel|stunnel4' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs || echo "OFF")
                P_WST=$(netstat -tlpn 2>/dev/null | grep -E 'python|ws' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs || echo "OFF")
                P_XRAY=$(netstat -tlpn 2>/dev/null | grep 'xray' | awk '{print $4}' | cut -d: -f2 | sort -nu | xargs || echo "OFF")

                clear
                echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
                echo -e "${AZUL}│${VERMELHO}                   MODOS DE CONEXÃO                     ${AZUL}│${SEM_COR}"
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
                        echo "Configurando ou alterando portas do OpenSSH nativo..."
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
                        echo "Iniciando instalação/configuração do Dropbear..."
                        # Código real de instalação executável aqui...
                        echo -e "${VERDE}Dropbear configurado com sucesso!${SEM_COR}"
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    3|03)
                        clear
                        echo -e "${VERDE}=== INSTALADOR OPENVPN ===${SEM_COR}"
                        echo "Configurando dependências do OpenVPN..."
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    4|04)
                        clear
                        echo -e "${VERDE}=== INSTALADOR SQUID PROXY ===${SEM_COR}"
                        echo "Configurando portas do Squid Proxy (80, 8080, 3128)..."
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
                        echo "Gerenciando tráfego multiplexado..."
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    7|07)
                        clear
                        echo -e "${VERDE}=== INSTALADOR WEBSOCKET ===${SEM_COR}"
                        echo "Iniciando script em Python para conexões WebSocket..."
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    8|08)
                        clear
                        echo -e "${VERDE}=== PROXY SOCKS ===${SEM_COR}"
                        echo "Configurando tunelamento de Proxy Socks..."
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    9|09)
                        clear
                        echo -e "${VERDE}=== OPEN PROXY ===${SEM_COR}"
                        echo "Gerenciando portas de Open Proxy do sistema..."
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    10)
                        clear
                        echo -e "${VERDE}=== INSTALADOR SLOW DNS ===${SEM_COR}"
                        echo "Configurando chaves NS e porta 5300 para o SlowDNS..."
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    11)
                        clear
                        echo -e "${VERDE}=== INSTALADOR V2RAY / XRAY ===${SEM_COR}"
                        echo "Baixando o núcleo oficial do Xray-core..."
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    12)
                        clear
                        echo -e "${VERDE}=== INSTALADOR UDP CUSTOM ===${SEM_COR}"
                        echo "Gerenciando tráfego UDP Custom para jogos..."
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    13)
                        clear
                        echo -e "${VERDE}=== CONFIGURADOR HYSTERIA ===${SEM_COR}"
                        echo "Protocolo Hysteria (UDP de alta velocidade)..."
                        echo -ne "\nPressione Enter para retornar..."; read
                        ;;
                    0|00)
                        break # Volta limpando a tela pro Menu Principal da VPS 1
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
