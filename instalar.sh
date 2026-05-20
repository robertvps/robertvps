cat << 'EOF' > /bin/menu
#!/bin/bash
# ========================================================
# MENU COMPLETO - ESTRUTURA CLÁSSICA REPARADA - ROBERT.GARCIA
# ========================================================

VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
CENARIO='\033[1;36m'
BRANCO='\033[1;37m'
PRETO='\033[1;30m'
SEM_COR='\033[0m'

# Estatísticas leves e reais (Idênticas ao seu print original)
OS_VERSAO=$(lsb_release -si 2>/dev/null || echo "Ubuntu")
OS_RELEASE=$(lsb_release -sr 2>/dev/null || echo "22.04")
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
RAM_USO=$(free | awk '/^Mem:/ {printf("%.0f%%"), $3/$2*100}')
NUCLEOS=$(nproc)
CPU_USO=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-7.]*\)%* id.*/\1/" | awk '{printf("%.1f"), 100 - $1}')
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
    
    # A SUA ORDEM EXATA DE OPÇÕES DO PRINT (Números Brancos / Colchetes Pretos)
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 1 "CRIAR USUARIO" 13 "SPEEDTEST"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 2 "CRIAR TESTE" 14 "OTIMIZAR"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 3 "REMOVER USUARIO" 15 "TRAFEGO"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 4 "RENOVAR USUARIO" 16 "FIREWALL"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 5 "USUARIOS ONLINE" 17 "INFO SISTEMA"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 6 "ALTERAR DATA" 18 "BANNER"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 7 "ALTERAR LIMITE" 19 "LIMITAR SSH"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 8 "ALTERAR SENHA" 20 "BADVPN"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 9 "REMOVER EXPIRADOS" 21 "AUTO MENU"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 10 "RELATORIO USUARIOS" 22 "CHATBOTS"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 11 "BACKUP DE USUARIOS" 23 "MAIS OPCOES"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} ➔ ${BRANCO}%-16s${AZUL}│\n" 12 "MODOS DE CONEXAO" 0 "SAIR DO MENU"
    
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    echo ""
    echo -ne "${AZUL}O QUE DESEJA FAZER ? : ${BRANCO}"
    read opcao

    # SISTEMA DE ATALHOS DIRETOS (Chama os arquivos originais da VPS se as funções falharem)
    case $opcao in
        1|01) criarusuario || bash /etc/sshplus/criarusuario || menu ;;
        2|02) criarteste || bash /etc/sshplus/criarteste || menu ;;
        3|03) removerusuario || bash /etc/sshplus/removerusuario || remover ;;
        4|04) renovarusuario || bash /etc/sshplus/renovarusuario || renovar ;;
        5|05) usuariosonline || bash /etc/sshplus/usuariosonline || onlines ;;
        6|06) alterardata || bash /etc/sshplus/alterardata ;;
        7|07) alterarlimite || bash /etc/sshplus/alterarlimite ;;
        8|08) alterarsenha || bash /etc/sshplus/alterarsenha ;;
        9|09) removerexpirados || bash /etc/sshplus/removerexpirados || expirados ;;
        10) relatoriousuarios || bash /etc/sshplus/relatoriousuarios || relatorio ;;
        11) backupusuarios || bash /etc/sshplus/backupusuarios || backup ;;
        12) modosdeconexao || bash /etc/sshplus/modosdeconexao || conexao ;;
        13) speedtest-cli || speedtest ;;
        14) otimizar || bash /etc/sshplus/otimizar ;;
        15) trafego || bash /etc/sshplus/trafego ;;
        16) firewall || ufw status || dados ;;
        17) infosistema || nload ;;
        18) banner || dados ;;
        19) limitarssh || dados ;;
        20) badvpn || dados ;;
        21) automenu || dados ;;
        22) chatbots || dados ;;
        23) maisopcoes || dados ;;
        0|00) clear; exit 0 ;;
        *) echo -e "\n${VERMELHO}Opção Inválida!${SEM_COR}"; sleep 1 ;;
    esac
done
EOF
chmod +x /bin/menu
