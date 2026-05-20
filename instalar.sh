#!/bin/bash
# ========================================================
# SCRIPT REFEITO - ALINHAMENTO E LAYOUT COMPACTO
# PERSONALIZADO PARA: ROBERT.GARCIA
# ========================================================

# Configuração do seu GitHub para o Auto-Update invisível
USUARIO_GITHUB="robertvps"
REPOSITORIO="robertvps"
URL_RAW="https://raw.githubusercontent.com/$USUARIO_GITHUB/$REPOSITORIO/main"

# Função secreta para atualizar o menu pelo seu próprio GitHub
_auto_update_menu() {
    wget -q -O /bin/menu.tmp "$URL_RAW/instalar.sh"
    if [ $? -eq 0 ] && [ -s /bin/menu.tmp ]; then
        mv /bin/menu.tmp /bin/menu
        chmod +x /bin/menu
    else
        rm -f /bin/menu.tmp
    fi
}
# Executa a checagem em segundo plano para não travar o menu
_auto_update_menu &

# Definição das Cores Exatas do Print
VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
MAGENTA='\033[1;35m'
CENARIO='\033[1;36m'
SEM_COR='\033[0m'

# Captura de Dados do Sistema
OS_VERSAO=$(lsb_release -si 2>/dev/null || echo "Ubuntu")
OS_RELEASE=$(lsb_release -sr 2>/dev/null || echo "22")
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
RAM_USO=$(free | awk '/^Mem:/ {printf("%.2f%%"), $3/$2*100}')
NUCLEOS=$(nproc)
CPU_USO=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-7.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
TOTAL_USER=$(awk -F : '$3 >= 500 {print $1}' /etc/passwd | grep -v '^nobody' | wc -l)

menu_principal() {
    clear
    HORA_ATUAL=$(date +%H:%M:%S)
    
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR}          ${VERDE}█▓▒░${SEM_COR} ROBERT.GARCIA ${VERDE}░▒▓█${SEM_COR}          ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${VERDE} Sistema${SEM_COR}           │${VERDE} Memoria Ram${SEM_COR}          │${VERDE} Processador${SEM_COR}"
    printf "${VERMELHO} Os: ${SEM_COR}%-13s│${VERMELHO} Total: ${SEM_COR}%-13s│${VERMELHO} Nucleo: ${SEM_COR}%-5s\n" "$OS_VERSAO $OS_RELEASE" "$RAM_TOTAL" "$NUCLEOS"
    printf "${VERMELHO} Horário: ${SEM_COR}%-8s│${VERMELHO} Em Uso: ${SEM_COR}%-12s│${VERMELHO} Em Uso: ${SEM_COR}%-5s\n" "$HORA_ATUAL" "$RAM_USO" "$CPU_USO"
    printf "${VERMELHO} Conectados: ${SEM_COR}%-4s│${VERMELHO} Vencidos: ${SEM_COR}%-10s│${VERMELHO} Criados: ${SEM_COR}%-5s\n" "0" "0" "$TOTAL_USER"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    
    # Colunas idênticas ao primeiro print (01 a 22)
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-17s${AZUL}│\n" 1 "CRIAR CONTA" 12 "OTIMIZAR"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-17s${AZUL}│\n" 2 "CRIAR CONTA TESTE" 13 "BACKUP"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-11s ${VERMELHO}×${AZUL} │\n" 3 "REMOVER CONTA" 14 "LIMITER"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-11s ${VERDE}✓${AZUL} │\n" 4 "CONTAS ONLINE" 15 "BAD VPN"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-17s${AZUL}│\n" 5 "MUDAR DATA" 16 "INFO VPS"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-17s${AZUL}│\n" 6 "ALTERAR LIMITE" 17 "AVANÇADO"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-17s${AZUL}│\n" 7 "MUDAR SENHA" 18 "CHECKUSERS"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-11s ${VERMELHO}×${AZUL} │\n" 8 "REMOVER EXPIRADOS" 19 "ONLINE APP"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-17s${AZUL}│\n" 9 "RELATORIO DE USUARIOS" 20 "SPEEDTEST"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-17s${AZUL}│\n" 10 "MODOS DE CONEXAO" 21 "BANNER"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-17s${AZUL}│\n" 11 "SUSPENDER USUARIO" 22 "TRAFEGO"
    printf "${AZUL}│${VERMELHO}│%02d│${SEM_COR} ➔ %-20s ${AZUL}│${VERMELHO}│  │${SEM_COR}                   ${AZUL}│\n" 0 "SAIR"
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    echo ""
    echo -ne "${VERDE}➔ O QUE DESEJA FAZER ?${MAGENTA} :${SEM_COR} "
    read opcao

    case $opcao in
        1|01) bash /etc/sshplus/criarusuario ;;
        17) submenu_avancado ;;
        0|00) clear; exit 0 ;;
        *) echo -e "${VERMELHO}Opção inválida!${SEM_COR}"; sleep 1; menu_principal ;;
    esac
}

submenu_avancado() {
    clear
    # Cabeçalho simulando a navegação do segundo print
    echo -e "${AZUL}│${VERMELHO}03│${SEM_COR} ➔ REMOVER CONTA             ${VERMELHO}│14│${SEM_COR} ➔ LIMITER ${VERMELHO}×${SEM_COR}"
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${AZUL}                     AVANÇADO                           ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    
    # Opções do Submenu (Segundo print)
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-46s${AZUL}│\n" 1 "SYNC P-WEB"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-46s${AZUL}│\n" 2 "MEMORIA VIRTUAL"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-42s ${VERMELHO}×${AZUL}│\n" 3 "BOT TELEGRAM (GERENCIAR MAQUINA)"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-42s ${VERMELHO}×${AZUL}│\n" 4 "BOT TELEGRAM (CRIAR LOGINS GRATIS)"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-46s${AZUL}│\n" 5 "BLOQUEAR TORRENT"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-46s${AZUL}│\n" 6 "CONTROLE FAMILIA"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-42s ${VERDE}✓${AZUL}│\n" 7 "AUTO EXECUCAO (INICIAR MENU AUTOMATICAMENTE)"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-46s${AZUL}│\n" 8 "ALTERAR SENHA ROOT"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-46s${AZUL}│\n" 9 "REINICIAR SERVICOS"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-46s${AZUL}│\n" 10 "REINICIAR SISTEMA"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-46s${AZUL}│\n" 11 "REMOVER SCRIPT"
    printf "${AZUL}│${CENARIO}│%02d│${SEM_COR} ➔ %-46s${AZUL}│\n" 0 "MENU"
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    echo ""
    echo -ne "${VERDE}OQUE DESEJA FAZER ${VERMELHO}??${MAGENTA} :${SEM_COR} "
    read subopt
    
    case $subopt in
        0|00) menu_principal ;;
        *) echo -e "${VERMELHO}Função em desenvolvimento no submódulo!${SEM_COR}"; sleep 1; submenu_avancado ;;
    esac
}

# Inicializa o Menu principal
while true; do
    menu_principal
done
