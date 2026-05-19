#!/bin/bash
# ========================================================
# INSTALADOR LIVRE - MENU COMPLETO PARA VPS 1 (SEM CHAVE)
# ========================================================

# Cores
VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
CENARIO='\033[1;36m'
SEM_COR='\033[0m'

# Variáveis
OS_VERSAO=$(lsb_release -si 2>/dev/null || echo "Linux")
OS_RELEASE=$(lsb_release -sr 2>/dev/null || echo "")
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
NUCLEOS=$(nproc)

clear
while true; do
    HORA_ATUAL=$(date +%H:%M:%S)
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR}                ${VERMELHO}« VPS MANAGER INDEPENDENTE »${SEM_COR}            ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${CENARIO}SISTEMA${SEM_COR}           ${CENARIO}MEMORIA RAM${SEM_COR}       ${CENARIO}PROCESSADOR${SEM_COR}    ${AZUL}│${SEM_COR}"
    printf "${AZUL}│${SEM_COR} OS: %-13s Total: %-11s Nucleos: %-10s ${AZUL}│\n${SEM_COR}" "$OS_VERSAO $OS_RELEASE" "$RAM_TOTAL" "$NUCLEOS"
    printf "${AZUL}│${SEM_COR} Hora: %-47s ${AZUL}│\n${SEM_COR}" "$HORA_ATUAL"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${VERDE}Onlines:${SEM_COR} $(ps aux | grep -E "sshd" | grep -v grep | wc -l)        ${VERMELHO}Expirados:${SEM_COR} 0      ${AMARELO}Total:${SEM_COR} $(cat /etc/passwd | grep -c "/false")         ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[01]${SEM_COR} • CRIAR USUARIO      ${AMARELO}[13]${SEM_COR} • SPEEDTEST            ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[02]${SEM_COR} • CRIAR TESTE        ${AMARELO}[14]${SEM_COR} • OTIMIZAR             ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[03]${SEM_COR} • REMOVER USUARIO    ${AMARELO}[15]${SEM_COR} • TRAFEGO              ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[04]${SEM_COR} • RENOVAR USUARIO    ${AMARELO}[16]${SEM_COR} • FIREWALL             ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[05]${SEM_COR} • USUARIOS ONLINE    ${AMARELO}[17]${SEM_COR} • INFO SISTEMA         ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[06]${SEM_COR} • ALTERAR DATA       ${AMARELO}[18]${SEM_COR} • BANNER               ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[07]${SEM_COR} • ALTERAR LIMITE     ${AMARELO}[19]${SEM_COR} • LIMITAR SSH          ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[08]${SEM_COR} • ALTERAR SENHA      ${AMARELO}[20]${SEM_COR} • BADVPN               ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[09]${SEM_COR} • REMOVER EXPIRADOS  ${AMARELO}[21]${SEM_COR} • AUTO MENU            ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[10]${SEM_COR} • RELATORIO USUARIOS ${AMARELO}[22]${SEM_COR} • CHATBOTS             ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[11]${SEM_COR} • BACKUP DE USUARIOS ${AMARELO}[23]${SEM_COR} • MAIS OPCOES          ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[12]${SEM_COR} • MODOS DE CONEXAO   ${AMARELO}[00]${SEM_COR} • SAIR DO MENU         ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    echo ""
    echo -n "INFORME UMA OPÇÃO: "
    read opcao

    case $opcao in
        1|01)
            echo -e "\n--- CRIAR USUÁRIO SSH ---"
            read -p "Nome do usuário: " user_ssh
            read -p "Senha: " pass_ssh
            read -p "Dias de validade: " dias_ssh
            useradd -M -s /bin/false -e $(date -d "$dias_ssh days" +%Y-%m-%d) $user_ssh 2>/dev/null
            echo "$user_ssh:$pass_ssh" | chpasswd
            echo -e "${VERDE}Usuário $user_ssh criado por $dias_ssh dias!${SEM_COR}"
            sleep 2
            ;;
        3|03)
            echo -e "\n--- REMOVER USUÁRIO ---"
            read -p "Digite o usuário para remover: " rem_user
            userdel -f $rem_user 2>/dev/null
            echo -e "${VERMELHO}Usuário removido do sistema.${SEM_COR}"
            sleep 2
            ;;
        5|05)
            echo -e "\n--- USUÁRIOS ONLINE ---"
            ps aux | grep -E "sshd" | grep -v grep
            read -p "Pressione Enter para voltar..."
            ;;
        11)
            echo -e "\n--- GERANDO BACKUP ---"
            tar -czf /root/backup_usuarios.tar.gz /etc/passwd /etc/shadow 2>/dev/null
            echo -e "${VERDE}Backup dos usuários salvo em /root/backup_usuarios.tar.gz${SEM_COR}"
            sleep 2
            ;;
        13)
            echo -e "\n--- TESTE DE VELOCIDADE ---"
            if ! command -v speedtest-cli &> /dev/null; then
                apt-get update && apt-get install speedtest-cli -y &>/dev/null
            fi
            speedtest-cli
            read -p "Pressione Enter para voltar..."
            ;;
        14)
            echo -e "\n--- OTIMIZANDO SISTEMA ---"
            sync && sysctl -w vm.drop_caches=3
            echo -e "${VERDE}Memória RAM limpa com sucesso!${SEM_COR}"
            sleep 2
            ;;
        17)
            echo -e "\n--- INFORMAÇÕES DO SISTEMA ---"
            echo "Tempo de atividade: $(uptime -p)"
            echo "Uso de Disco atual:"
            df -h /
            read -p "Pressione Enter para voltar..."
            ;;
        0|00)
            clear
            break
            ;;
        *)
            echo -e "\n${VERMELHO}Função em desenvolvimento ou requer instalação de pacotes.${SEM_COR}"
            sleep 2
            ;;
    esac
done
