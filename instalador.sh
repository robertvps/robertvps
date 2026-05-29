#!/bin/bash
# ALIEN VPN SSH HIPER - Versão Profissional com Sub-menus

C_AZUL='\033[1;36m'
C_RED='\033[41;37m'
NC='\033[0m'

pausa() { echo -e "\n${C_AZUL}---${NC}"; read -p "Pressione ENTER para voltar ao menu..." ; }

# --- SUB-MENU: CHATBOTS [22] ---
menu_chatbots() {
    while true; do
        clear
        echo -e "${C_AZUL}┌── MENU CHATBOTS ──┐${NC}"
        echo -e " [01] Configurar Bot Telegram"
        echo -e " [02] Status do Bot"
        echo -e " [00] Voltar ao Menu Principal"
        echo -e "${C_AZUL}└────────────────────┘${NC}"
        read -p "Opção: " sub
        case ${sub#0} in
            1) echo "Configurando Telegram..."; pausa ;;
            2) echo "Verificando Status..."; pausa ;;
            0) break ;;
            *) echo "Inválido!"; sleep 1 ;;
        esac
    done
}

# --- SUB-MENU: MAIS OPCOES [23] ---
menu_mais_opcoes() {
    while true; do
        clear
        echo -e "${C_AZUL}┌── MAIS OPCOES ──┐${NC}"
        echo -e " [01] Atualizar Sistema"
        echo -e " [02] Limpar Logs"
        echo -e " [00] Voltar ao Menu Principal"
        echo -e "${C_AZUL}└─────────────────┘${NC}"
        read -p "Opção: " sub
        case ${sub#0} in
            1) apt update && apt upgrade -y; pausa ;;
            2) rm -rf /var/log/*.log; echo "Logs limpos"; pausa ;;
            0) break ;;
            *) echo "Inválido!"; sleep 1 ;;
        esac
    done
}

# --- MENU PRINCIPAL ---
while true; do
    clear
    echo -e "${C_RED} ↖ ALIEN VPN SSH HIPER ↘ ${NC}"
    echo -e "${C_AZUL}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e " SISTEMA        MEMORIA RAM       PROCESSADOR"
    echo -e " OS: $(lsb_release -d | awk '{print $2, $3}') | RAM: $(free -h | awk '/^Mem:/{print $2}') | CPU: $(nproc)"
    echo -e "${C_AZUL}├─────────────────────────────────────────────────────────┤${NC}"
    printf "${C_AZUL} [01] • CRIAR USUARIO        [13] • SPEEDTEST\n [02] • CRIAR TESTE          [14] • OTIMIZAR\n [03] • REMOVER USUARIO      [15] • TRAFEGO\n [04] • RENOVAR USUARIO      [16] • FIREWALL\n [05] • USUARIOS ONLINE      [17] • INFO SISTEMA\n [06] • ALTERAR DATA         [18] • BANNER\n [07] • ALTERAR LIMITE       [19] • LIMITAR SSH\n [08] • ALTERAR SENHA        [20] • BADVPN\n [09] • REMOVER EXPIRADOS    [21] • AUTO MENU\n [10] • RELATORIO USUARIOS   [22] • CHATBOTS\n [11] • BACKUP DE USUARIOS   [23] • MAIS OPCOES\n [12] • MODOS DE CONEXAO     [00] • SAIR\n${NC}"
    echo -e "${C_AZUL}└─────────────────────────────────────────────────────────┘${NC}"
    read -p "INFORME UMA OPCAO: " opt
    
    case ${opt#0} in
        1) echo "Funcao Criar Usuário"; pausa ;;
        22) menu_chatbots ;;
        23) menu_mais_opcoes ;;
        0) exit 0 ;;
        *) echo "Opção ainda não configurada!"; sleep 1 ;;
    esac
done
