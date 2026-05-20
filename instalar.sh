#!/bin/bash
# ========================================================
# INSTALADOR - MENU ORIGINAL RECUPERADO
# PERSONALIZADO PARA: ROBERT.GARCIA
# ========================================================

# Definição de Cores Exatas (Visual Azul Escuro do Print)
VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
CENARIO='\033[1;36m'
SEM_COR='\033[0m'

# Captura de Dados do Sistema Originais
OS_VERSAO=$(lsb_release -si 2>/dev/null || echo "Linux")
OS_RELEASE=$(lsb_release -sr 2>/dev/null || echo "")
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
RAM_USO=$(free | awk '/^Mem:/ {printf("%.0f%%"), $3/$2*100}')
NUCLEOS=$(nproc)
CPU_USO=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-7.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
TOTAL_USER=$(awk -F : '$3 >= 500 {print $1}' /etc/passwd | grep -v '^nobody' | wc -l)
ONLINES=$(ps aux | grep -E "sshd|dropbear" | grep -v grep | wc -l)

clear
while true; do
    HORA_ATUAL=$(date +%H:%M:%S)
    
    # Desenho do Menu - Cores e Alinhamento ROBERT.GARCIA
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR}          ${VERDE}█▓▒░${SEM_COR} ROBERT.GARCIA ${VERDE}░▒▓█${SEM_COR}          ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    printf "${AZUL}│${CENARIO} SISTEMA             MEMORIA RAM           PROCESSADOR  ${AZUL}│\n"
    printf "${AZUL}│${VERMELHO} OS: ${SEM_COR}%-15s${VERMELHO}Total: ${SEM_COR}%-14s${VERMELHO}Nucleos: ${SEM_COR}%-4s${AZUL}│\n" "$OS_VERSAO $OS_RELEASE" "$RAM_TOTAL" "$NUCLEOS"
    printf "${AZUL}│${VERMELHO} Hora: ${SEM_COR}%-13s${VERMELHO}Em Uso: ${SEM_COR}%-13s${VERMELHO}Em Uso: ${SEM_COR}%-5s${AZUL}│\n" "$HORA_ATUAL" "$RAM_USO" "$CPU_USO"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    printf "${AZUL}│${VERDE} Onlines: ${SEM_COR}%-10s${VERMELHO}Expirados: ${SEM_COR}%-9s${AMARELO}Total: ${SEM_COR}%-11s${AZUL}│\n" "$ONLINES" "0" "$TOTAL_USER"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    
    # Suas opções originais do primeiro script restauradas
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 1 "CRIAR USUARIO" 13 "SPEEDTEST"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 2 "CRIAR TESTE" 14 "OTIMIZAR"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 3 "REMOVER USUARIO" 15 "TRAFEGO"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 4 "RENOVAR USUARIO" 16 "FIREWALL"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 5 "USUARIOS ONLINE" 17 "INFO SISTEMA"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 6 "ALTERAR DATA" 18 "BANNER"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 7 "ALTERAR LIMITE" 19 "LIMITAR SSH"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 8 "ALTERAR SENHA" 20 "BADVPN"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 9 "REMOVER EXPIRADOS" 21 "AUTO MENU"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 10 "RELATORIO USUARIOS" 22 "CHATBOTS"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 11 "BACKUP DE USUARIOS" 23 "MAIS OPCOES"
    printf "${AZUL}│${AMARELO} [%02d] ${AZUL}• ${SEM_COR}%-20s ${AMARELO}[%02d] ${AZUL}• ${SEM_COR}%-17s${AZUL}│\n" 12 "MODOS DE CONEXAO" 0 "SAIR DO MENU"
    
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    echo ""
    echo -ne "${VERDE}┤INFORME UMA OPCAO:${SEM_COR} "
    read opcao

    # Execução dos comandos internos originais da sua VPS
    case $opcao in
        1|01) bash /etc/sshplus/criarusuario ;;
        2|02) bash /etc/sshplus/criarteste ;;
        3|03) bash /etc/sshplus/removerusuario ;;
        4|04) bash /etc/sshplus/renovarusuario ;;
        5|05) bash /etc/sshplus/usuariosonline ;;
        6|06) bash /etc/sshplus/alterardata ;;
        7|07) bash /etc/sshplus/alterarlimite ;;
        8|08) bash /etc/sshplus/alterarsenha ;;
        9|09) bash /etc/sshplus/removerexpirados ;;
        10) bash /etc/sshplus/relatoriousuarios ;;
        11) bash /etc/sshplus/backupusuarios ;;
        12) bash /etc/sshplus/conexao ;;
        13) speedtest-cli ;;
        14) bash /etc/sshplus/otimizar ;;
        15) bash /etc/sshplus/trafego ;;
        16) ufw status ;;
        17) screen -version ;;
        0|00) clear; exit 0 ;;
        *) echo -e "\n${VERMELHO}Opção Inválida!${SEM_COR}"; sleep 1 ;;
    esac
done
