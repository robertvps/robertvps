#!/bin/bash
# ========================================================
# SCRIPT FOCO TOTAL NA OPÇÃO 12 E SEUS SUB-MENUS
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
            # Travado temporariamente para mantermos o foco total na 12
            clear
            echo -e "${AMARELO}Aviso: Estamos focando apenas na OPÇÃO 12 agora! Escolha a 12.${SEM_COR}"
            sleep 2
            ;;
        12)
            # Início do Loop do Sub-Menu das Opções de Conexão
            while true; do
                clear
                echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
                echo -e "${AZUL}│${SEM_COR}         ${VERDE}█▓▒░${BRANCO} SUB-MENU: OPÇÕES DE CONEXÃO ${VERDE}░▒▓█${SEM_COR}      ${AZUL}│${SEM_COR}"
                echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 1 "VER PORTAS E CONEXÕES ATIVAS"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 2 "ALTERAR PORTA DO OPENSSH (PADRÃO)"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 3 "REINICIAR TODOS OS SERVIÇOS DE REDE"
                printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-43s${AZUL}│\n" 4 "VOLTAR AO MENU PRINCIPAL"
                echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
                echo ""
                echo -ne "${AMARELO}Escolha uma sub-opção ?: ${SEM_COR}"
                read sub_opcao

                case $sub_opcao in
                    1|01)
                        clear
                        echo -e "${VERDE}=== PORTAS EM EXECUÇÃO NO SERVIDOR ===${SEM_COR}"
                        echo -e "--------------------------------------------------"
                        netstat -tlpn | grep -E "sshd|dropbear|badvpn|squid|apache|nginx" || echo "Nenhum protocolo ativo encontrado."
                        echo -e "--------------------------------------------------"
                        echo ""
                        echo -ne "${AMARELO}Pressione Enter para retornar ao Sub-Menu...${SEM_COR}"; read
                        ;;
                    2|02)
                        clear
                        echo -e "${VERDE}=== CONFIGURAR NOVA PORTA DO OPENSSH ===${SEM_COR}"
                        echo -e "Portas ativas no arquivo de configuração:"
                        grep -i "^Port" /etc/ssh/sshd_config || echo "Porta padrão ativa: 22"
                        echo ""
                        echo -ne "${AMARELO}Digite a nova porta desejada (Ex: 443, 2222): ${SEM_COR}"
                        read nova_porta
                        if [[ "$nova_porta" =~ ^[0-9]+$ ]]; then
                            # Altera ou adiciona a nova porta no arquivo do SSH
                            sed -i "s/^#Port .*/Port $nova_porta/g" /etc/ssh/sshd_config
                            sed -i "s/^Port .*/Port $nova_porta/g" /etc/ssh/sshd_config
                            systemctl restart sshd ssh >/dev/null 2>&1
                            echo -e "\n${VERDE}Sucesso! Porta alterada para $nova_porta e SSH reiniciado.${SEM_COR}"
                        else
                            echo -e "\n${VERMELHO}Erro: Porta inválida (digite apenas números).${SEM_COR}"
                        fi
                        echo ""
                        echo -ne "${AMARELO}Pressione Enter para retornar ao Sub-Menu...${SEM_COR}"; read
                        ;;
                    3|03)
                        clear
                        echo -e "${AMARELO}=== REINICIANDO PROTOCOLOS DO SERVIDOR ===${SEM_COR}"
                        echo -e "[+] Reiniciando OpenSSH..."
                        systemctl restart sshd ssh >/dev/null 2>&1
                        echo -e "[+] Reiniciando Dropbear..."
                        systemctl restart dropbear >/dev/null 2>&1
                        echo -e "[+] Reiniciando Squid (se houver)..."
                        systemctl restart squid squid3 >/dev/null 2>&1
                        echo -e "${VERDE}Todos os serviços de conexão foram reiniciados com sucesso!${SEM_COR}"
                        echo ""
                        echo -ne "${AMARELO}Pressione Enter para retornar ao Sub-Menu...${SEM_COR}"; read
                        ;;
                    4|04)
                        # Sai do laço interno do sub-menu e volta automaticamente para o painel principal
                        break
                        ;;
                    *)
                        echo -e "${VERMELHO}Opção incorreta! Escolha de 1 a 4.${SEM_COR}"
                        sleep 1.5
                        ;;
                esac
            done
            ;;
        0|00)
            clear
            echo -e "${AMARELO}Saindo... Obrigado Robert!${SEM_COR}"
            exit 0
            ;;
        *)
            echo -e "${VERMELHO}Opção inválida! Selecione um número válido do menu.${SEM_COR}"
            sleep 1
            ;;
    esac
done
