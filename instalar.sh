#!/bin/bash
# ========================================================
# SCRIPT REFEITO - SUA ESTRUTURA ORIGINAL COM CORES DA VPS2
# PERSONALIZADO PARA: ROBERT.GARCIA
# ========================================================

# Cores Exatas da VPS 2
VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
CENARIO='\033[1;36m'
BRANCO='\033[1;37m'
SEM_COR='\033[0m'

# Puxando dados reais da sua máquina
OS_VERSAO=$(lsb_release -si 2>/dev/null || echo "Ubuntu")
OS_RELEASE=$(lsb_release -sr 2>/dev/null || echo "22.04")
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
RAM_USO=$(free | awk '/^Mem:/ {printf("%.2f%%"), $3/$2*100}')
NUCLEOS=$(nproc)
CPU_USO=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-7.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
TOTAL_USER=$(awk -F : '$3 >= 500 {print $1}' /etc/passwd | grep -v '^nobody' | wc -l)
ONLINES=$(ps aux | grep -E "sshd|dropbear" | grep -v grep | wc -l)

clear
while true; do
    HORA_ATUAL=$(date +%H:%M:%S)
    
    # Cabeçalho idêntico ao modelo da VPS 2 (Azul com Nome Branco/Verde)
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR}          ${VERDE}█▓▒░${BRANCO} ROBERT.GARCIA ${VERDE}░▒▓█${SEM_COR}          ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${AZUL}│ ${VERDE}SISTEMA${SEM_COR}             ${VERDE}MEMORIA RAM${SEM_COR}           ${VERDE}PROCESSADOR${SEM_COR}  ${AZUL}│${SEM_COR}"
    printf "${AZUL}│ ${VERMELHO}OS: ${BRANCO}%-15s${VERMELHO}Total: ${BRANCO}%-14s${VERMELHO}Nucleos: ${BRANCO}%-5s${AZUL}│\n" "$OS_VERSAO $OS_RELEASE" "$RAM_TOTAL" "$NUCLEOS"
    printf "${AZUL}│ ${VERMELHO}Hora: ${BRANCO}%-13s${VERMELHO}Em Uso: ${BRANCO}%-13s${VERMELHO}Em Uso: ${BRANCO}%-6s${AZUL}│\n" "$HORA_ATUAL" "$RAM_USO" "$CPU_USO"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    printf "${AZUL}│ ${VERDE}Onlines: ${BRANCO}%-10s${VERMELHO}Expirados: ${BRANCO}%-9s${AMARELO}Total: ${BRANCO}%-12s${AZUL}│\n" "$ONLINES" "0" "$TOTAL_USER"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    
    # Sua estrutura de opções exatamente como na foto bb11cd.jpg
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 1 "CRIAR USUARIO" 13 "SPEEDTEST"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 2 "CRIAR TESTE" 14 "OTIMIZAR"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 3 "REMOVER USUARIO" 15 "TRAFEGO"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 4 "RENOVAR USUARIO" 16 "FIREWALL"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 5 "USUARIOS ONLINE" 17 "INFO SISTEMA"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 6 "ALTERAR DATA" 18 "BANNER"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 7 "ALTERAR LIMITE" 19 "LIMITAR SSH"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 8 "ALTERAR SENHA" 20 "BADVPN"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 9 "REMOVER EXPIRADOS" 21 "AUTO MENU"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 10 "MODOS DE CONEXAO" 22 "CHATBOTS"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 11 "BACKUP DE USUARIOS" 23 "MAIS OPCOES"
    printf "${AZUL}│${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-19s ${AZUL}[${BRANCO}%02d${AZUL}] ${AZUL}• ${BRANCO}%-16s${AZUL}│\n" 12 "RELATORIO USUARIOS" 0 "SAIR DO MENU"
    
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    echo ""
    echo -ne "${VERDE}INFORME UMA OPÇÃO: ${BRANCO}"
    read opcao

    # Redirecionamentos para os scripts internos originais da sua VPS
    case $opcao in
        1|01) menu_criarusuario ;;
        2|02) menu_criarteste ;;
        3|03) menu_removerusuario ;;
        4|04) menu_renovarusuario ;;
        5|05) menu_usuariosonline ;;
        6|06) menu_alterardata ;;
        7|07) menu_alterarlimite ;;
        8|08) menu_alterarsenha ;;
        9|09) menu_removerexpirados ;;
        10) menu_modosdeconexao || menu_conexao ;; # Sua Opção 10 Original!
        11) menu_backupusuarios ;;
        12) menu_relatoriousuarios ;;
        13) menu_speedtest ;;
        14) menu_otimizar ;;
        15) menu_trafego ;;
        16) menu_firewall ;;
        17) menu_infosistema ;;
        18) menu_banner ;;
        19) menu_limitarssh ;;
        20) menu_badvpn ;;
        21) menu_automenu ;;
        22) menu_chatbots ;;
        23) menu_maisopcoes ;;
        0|00) clear; exit 0 ;;
        *) echo -e "\n${VERMELHO}Opção Inválida!${SEM_COR}"; sleep 1 ;;
    esac
done
