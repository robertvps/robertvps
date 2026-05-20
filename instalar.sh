#!/bin/bash
# ========================================================
# SCRIPT ATUALIZADO - ROBERT.GARCIA
# ========================================================

VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
CENARIO='\033[1;36m'
BRANCO='\033[1;37m'
PRETO='\033[1;30m'
SEM_COR='\033[0m'

OS_VERSAO=$(lsb_release -si 2>/dev/null || echo "Ubuntu")
OS_RELEASE=$(lsb_release -sr 2>/dev/null || echo "22.04")
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
RAM_USO=$(free | awk '/^Mem:/ {printf("%.0f%%"), $3/$2*100}')
NUCLEOS=$(nproc)
CPU_USO=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-7.]*\)%* id.*/\1/" | awk '{printf("%.1f%%"), 100 - $1}')
TOTAL_USER=$(awk -F : '$3 >= 500 {print $1}' /etc/passwd | grep -v '^nobody' | wc -l)
ONLINES=$(ps aux | grep -E "sshd|dropbear" | grep -v grep | wc -l)

clear
while true; do
    HORA_ATUAL=$(date +%H:%M:%S)
    
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR}          ${VERDE}█▓▒░${BRANCO} ROBERT.GARCIA ${VERDE}░▒▓█${SEM_COR}          ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${AZUL}│ ${VERDE}SISTEMA${SEM_COR}             ${VERDE}MEMORIA RAM${SEM_COR}           ${VERDE}PROCESSADOR${SEM_COR}  ${AZUL}│${SEM_COR}"
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
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]
