cat << 'EOF' > /bin/menu
#!/bin/bash
# ========================================================
# MENU OFICIAL ROBERT.GARCIA - CORES CORRIGIDAS DIRETO NA VPS
# ========================================================

VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
CENARIO='\033[1;36m'
BRANCO='\033[1;37m'
PRETO='\033[0;30m'
SEM_COR='\033[0m'

OS_VERSAO=$(lsb_release -si 2>/dev/null || echo "Ubuntu")
OS_RELEASE=$(lsb_release -sr 2>/dev/null || echo "22.04")
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
RAM_USO=$(free | awk '/^Mem:/ {printf("%.0f%%"), $3/$2*100}')
NUCLEOS=$(nproc)
CPU_USO=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-7.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
TOTAL_USER=$(awk -F : '$3 >= 500 {print $1}' /etc/passwd | grep -v '^nobody' | wc -l)
ONLINES=$(ps aux | grep -E "sshd|dropbear" | grep -v grep | wc -l)

clear
while true; do
    HORA_ATUAL=$(date +%H:%M:%S)
    
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR}          ${VERDE}█▓▒░${BRANCO} ROBERT.GARCIA ${VERDE}░▒▓█${SEM_COR}          ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${AZUL}│ ${VERDE}Sistema${SEM_COR}             ${VERDE}Memória Ram${SEM_COR}           ${VERDE}Processador${SEM_COR}  ${AZUL}│${SEM_COR}"
    printf "${AZUL}│ ${VERMELHO}Os: ${BRANCO}%-15s${VERMELHO}Total: ${BRANCO}%-14s${VERMELHO}Nucleo: ${BRANCO}%-5s${AZUL}│\n" "$OS_VERSAO $OS_RELEASE" "$RAM_TOTAL" "$NUCLEOS"
    printf "${AZUL}│ ${VERMELHO}Horário: ${BRANCO}%-10s${VERMELHO}Em Uso: ${BRANCO}%-13s${VERMELHO}Em Uso: ${BRANCO}%-5s${AZUL}│\n" "$HORA_ATUAL" "$RAM_USO" "$CPU_USO"
    printf "${AZUL}│ ${VERMELHO}Conectados: ${BRANCO}%-7s${VERMELHO}Vencidos: ${BRANCO}%-11s${VERMELHO}Criados: ${BRANCO}%-5s${AZUL}│\n" "$ONLINES" "0" "$TOTAL_USER"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    
    # Exatamente a sua estrutura de opções (NÚMEROS BRANCOS e COLCHETES PRETOS)
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 1 "CRIAR CONTA" 12 "OTIMIZAR"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 2 "CRIAR CONTA TESTE" 13 "BACKUP"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 3 "REMOVER CONTA" 14 "LIMITAR X"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 4 "CONTAS ONLINE" 15 "BAD VPN"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 5 "MUDAR DATA" 16 "INFO VPS"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 6 "ALTERAR LIMITE" 17 "AVANÇADO"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 7 "MUDAR SENHA" 18 "CHECKUSERS"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 8 "REMOVER EXPIRADOS" 19 "ONLINE APP X"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 9 "RELATORIO DE USUARIOS" 20 "SPEEDTEST"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 10 "MODOS DE CONEXAO" 21 "BANNER"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 11 "SUSPENDER USUARIO" 22 "TRAFEGO"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${AZUL}  %-23s${AZUL}│\n" 0 "SAIR" ""
    
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    echo ""
    echo -ne "${AZUL}O QUE DESEJA FAZER ? : ${BRANCO}"
    read opcao

    case $opcao in
        1|01) criarusuario ;;
        2|02) criarteste ;;
        3|03) remover ;;
        4|04) onlines ;;
        5|05) mudardata ;;
        6|06) alterarlimite ;;
        7|07) mudarsenha ;;
        8|08) expirados ;;
        9|09) relatorio ;;
        10) conexao ;; # Sua Opção 10 funcional!
        11) suspender ;;
        12) otimizar ;;
        13) backup ;;
        14) limitar ;;
        15) badvpn ;;
        16) infovps ;;
        17) avancado ;;
        18) checkusers ;;
        19) onlineapp ;;
        20) speedtest ;;
        21) banner ;;
        22) trafego ;;
        0|00) clear; exit 0 ;;
        *) echo -e "\n${VERMELHO}Opção Inválida!${SEM_COR}"; sleep 1 ;;
    esac
done
EOF
chmod +x /bin/menu
