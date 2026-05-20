#!/bin/bash
# ========================================================
# INSTALADOR - MENU ORIGINAL COM AS CORES DO SEGUNDO PRINT
# PERSONALIZADO PARA: ROBERT.GARCIA
# ========================================================

# Paleta de Cores baseada na VPS 2
VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
CENARIO='\033[1;36m'
BRANCO='\033[1;37m'
SEM_COR='\033[0m'

# Captura de Dados do Sistema Originais da sua VPS
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
    
    # Cabeçalho Estilo VPS 2 com as cores desejadas
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR}          ${VERDE}█▓▒░${BRANCO} ROBERT.GARCIA ${VERDE}░▒▓█${SEM_COR}          ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${VERDE} Sistema${SEM_COR}           │${VERDE} Memoria Ram${SEM_COR}          │${VERDE} Processador${SEM_COR}"
    printf "${VERMELHO} Os: ${BRANCO}%-13s${SEM_COR}│${VERMELHO} Total: ${BRANCO}%-13s${SEM_COR}│${VERMELHO} Nucleo: ${BRANCO}%-5s\n" "$OS_VERSAO $OS_RELEASE" "$RAM_TOTAL" "$NUCLEOS"
    printf "${VERMELHO} Horário: ${BRANCO}%-8s${SEM_COR}│${VERMELHO} Em Uso: ${BRANCO}%-12s${SEM_COR}│${VERMELHO} Em Uso: ${BRANCO}%-5s\n" "$HORA_ATUAL" "$RAM_USO" "$CPU_USO"
    printf "${VERMELHO} Conectados: ${BRANCO}%-4s${SEM_COR}│${VERMELHO} Vencidos: ${BRANCO}%-10s${SEM_COR}│${VERMELHO} Criados: ${BRANCO}%-5s\n" "$ONLINES" "0" "$TOTAL_USER"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    
    # Suas opções originais com as cores novas (Números brancos, textos brancos)
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 1 "CRIAR USUARIO" 13 "SPEEDTEST"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 2 "CRIAR TESTE" 14 "OTIMIZAR"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 3 "REMOVER USUARIO" 15 "TRAFEGO"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 4 "RENOVAR USUARIO" 16 "FIREWALL"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 5 "USUARIOS ONLINE" 17 "INFO SISTEMA"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 6 "ALTERAR DATA" 18 "BANNER"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 7 "ALTERAR LIMITE" 19 "LIMITAR SSH"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 8 "ALTERAR SENHA" 20 "BADVPN"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 9 "REMOVER EXPIRADOS" 21 "AUTO MENU"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 10 "RELATORIO USUARIOS" 22 "CHATBOTS"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 11 "BACKUP DE USUARIOS" 23 "MAIS OPCOES"
    printf "${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-20s ${AZUL}│${BRANCO} [%02d] ${AZUL}• ${BRANCO}%-17s${AZUL}│\n" 12 "MODOS DE CONEXAO" 0 "SAIR DO MENU"
    
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    echo ""
    echo -ne "${VERDE}┤INFORME UMA OPCAO:${BRANCO} "
    read opcao

    # Comandos originais restaurados exatamente como eram
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
        10) bash /etc/sshplus/modosdeconexao || bash /etc/sshplus/conexao ;; # Garante a execução do Modos de Conexão
        11) bash /etc/sshplus/backupusuarios ;;
        12) bash /etc/sshplus/relatoriousuarios ;; # Mantendo o mapeamento correto do script original
        13) speedtest-cli ;;
        14) bash /etc/sshplus/otimizar ;;
        15) bash /etc/sshplus/trafego ;;
        16) ufw status ;;
        17) screen -version ;;
        0|00) clear; exit 0 ;;
        *) echo -e "\n${VERMELHO}Opção Inválida!${SEM_COR}"; sleep 1 ;;
    esac
done
