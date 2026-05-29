#!/bin/bash
# ALIEN VPN SSH HIPER - Instalação e Gerenciamento

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

# --- FUNÇÕES DE CADA BOTÃO ---
criar_usuario() { read -p "Login: " user; read -p "Senha: " pass; useradd -M -s /bin/false $user && echo "$user:$pass" | chpasswd; echo "Usuario $user criado!"; sleep 2; }
criar_teste() { user=$(date +%s%N | cut -b10-15); pass="1234"; useradd -M -s /bin/false $user && echo "$user:$pass" | chpasswd; echo "Teste: $user / Senha: $pass"; sleep 5; }
remover_usuario() { read -p "Login a remover: " user; userdel $user; echo "Removido!"; sleep 2; }
renovar_usuario() { echo "Função Renovar Usuário (Logica de expiração)"; sleep 2; }
listar_online() { ps -u --no-headers | awk '{print $1}'; read -p "Enter..."; }
alterar_limite() { echo "Configurar limite de conexões simultâneas"; sleep 2; }
manage_badvpn() { wget -q https://raw.githubusercontent.com/robertvps/alienvpnsshhiper/main/badvpn-udpgw -O /usr/bin/badvpn-udpgw && chmod +x /usr/bin/badvpn-udpgw; echo "BadVPN pronto!"; sleep 2; }
update_script() { cd /root && rm -rf alienvpnsshhiper && git clone https://github.com/robertvps/alienvpnsshhiper.git && echo "Atualizado!"; sleep 2; }

# --- MENU PRINCIPAL ---
show_menu() {
    while true; do
        clear
        echo -e "\033[41;37m ↖ ALIEN VPN SSH HIPER ↘ \033[0m"
        echo -e "┌─────────────────────────────────────────────────────────┐"
        echo -e " SISTEMA        MEMORIA RAM       PROCESSADOR"
        echo -e " OS: $(lsb_release -d | awk '{print $2, $3}')    Total: $(free -h | awk '/^Mem:/{print $2}')      Nucleos: $(nproc)"
        echo -e " Hora: $(date +%H:%M:%S)   Em Uso: $(free | awk '/^Mem:/{printf("%.0f%"), $3/$2*100}')    Em Uso: $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print int(usage)"%"}')"
        echo -e "├─────────────────────────────────────────────────────────┤"
        printf " [01] • CRIAR USUARIO        [13] • SPEEDTEST\n"
        printf " [02] • CRIAR TESTE          [14] • OTIMIZAR\n"
        printf " [03] • REMOVER USUARIO      [15] • TRAFEGO\n"
        printf " [04] • RENOVAR USUARIO      [16] • FIREWALL\n"
        printf " [05] • USUARIOS ONLINE      [17] • INFO SISTEMA\n"
        printf " [06] • ALTERAR DATA         [18] • BANNER\n"
        printf " [07] • ALTERAR LIMITE       [19] • LIMITAR SSH\n"
        printf " [08] • ALTERAR SENHA        [20] • BADVPN\n"
        printf " [09] • REMOVER EXPIRADOS    [21] • AUTO MENU\n"
        printf " [10] • RELATORIO USUARIOS   [22] • CHATBOTS\n"
        printf " [11] • BACKUP DE USUARIOS   [23] • MAIS OPCOES\n"
        printf " [12] • MODOS DE CONEXAO     [00] • SAIR DO MENU\n"
        echo -e "└─────────────────────────────────────────────────────────┘"
        read -p "INFORME UMA OPCAO: " opt
        case $opt in
            01|1) criar_usuario ;;
            02|2) criar_teste ;;
            03|3) remover_usuario ;;
            04|4) renovar_usuario ;;
            05|5) listar_online ;;
            07|7) alterar_limite ;;
            19) update_script ;;
            20) manage_badvpn ;;
            00|0) exit 0 ;;
            *) echo "Opção inválida!"; sleep 1 ;;
        esac
    done
}

show_menu
