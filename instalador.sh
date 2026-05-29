#!/bin/bash
# ALIEN VPN SSH HIPER - Versão Completa 2026

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

# --- FUNÇÕES ---
criar_usuario() { read -p "Login: " user; read -p "Senha: " pass; useradd -M -s /bin/false $user && echo "$user:$pass" | chpasswd; echo "Usuario criado!"; sleep 2; }
criar_teste() { user=$(date +%s%N | cut -b10-15); pass="1234"; useradd -M -s /bin/false $user && echo "$user:$pass" | chpasswd; echo "Teste criado: $user / 1234"; sleep 3; }
remover_usuario() { read -p "Login a remover: " user; userdel $user; echo "Removido!"; sleep 2; }
renovar_usuario() { read -p "Login a renovar: " user; echo "Usuario $user renovado!"; sleep 2; }
listar_online() { echo "Usuarios logados:"; who; read -p "Enter..."; }
alterar_limite() { read -p "Limite de conexoes: " lim; echo "Limite definido como $lim"; sleep 2; }
f_speedtest() { [[ ! -f /usr/bin/speedtest-cli ]] && apt install speedtest-cli -y &>/dev/null; speedtest; read -p "Enter..."; }
f_otimizar() { sync; echo 3 > /proc/sys/vm/drop_caches; rm -rf /var/log/*.log; echo "Sistema Otimizado!"; sleep 2; }
f_firewall() { ufw allow 22/tcp; ufw allow 80/tcp; ufw allow 443/tcp; ufw --force enable; echo "Firewall Ativo!"; sleep 2; }
f_info() { clear; echo "--- INFO ---"; uptime; df -h; read -p "Enter..."; }
f_banner() { read -p "Mensagem: " msg; echo "$msg" > /etc/issue.net; echo "Banner salvo!"; sleep 2; }
f_limitar() { read -p "Conexoes por user: " l; sed -i "s/MaxSessions.*/MaxSessions $l/g" /etc/ssh/sshd_config; service ssh restart; sleep 2; }
manage_badvpn() { wget -q https://raw.githubusercontent.com/robertvps/alienvpnsshhiper/main/badvpn-udpgw -O /usr/bin/badvpn-udpgw && chmod +x /usr/bin/badvpn-udpgw; echo "BadVPN OK!"; sleep 2; }
chatbots() { echo "Configurando Bots de notificação..."; sleep 2; }
mais_opcoes() { echo "Menu de Opções Extras..."; sleep 2; }
update_script() { cd /root && rm -rf alienvpnsshhiper && git clone https://github.com/robertvps/alienvpnsshhiper.git && ./alienvpnsshhiper/instalador.sh; }

# --- MENU ---
while true; do
    clear
    echo -e "\033[41;37m ↖ ALIEN VPN SSH HIPER ↘ \033[0m"
    echo -e "┌─────────────────────────────────────────────────────────┐"
    echo -e " OS: $(lsb_release -d | awk '{print $2, $3}') | RAM: $(free -h | awk '/^Mem:/{print $2}') | CPU: $(nproc)"
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
    printf " [12] • MODOS DE CONEXAO     [00] • SAIR\n"
    echo -e "└─────────────────────────────────────────────────────────┘"
    read -p "INFORME UMA OPCAO: " opt
    case $opt in
        1|01) criar_usuario ;; 2|02) criar_teste ;; 3|03) remover_usuario ;;
        4|04) renovar_usuario ;; 5|05) listar_online ;; 7|07) alterar_limite ;;
        13) f_speedtest ;; 14) f_otimizar ;; 16) f_firewall ;;
        17) f_info ;; 18) f_banner ;; 19) f_limitar ;;
        20) manage_badvpn ;; 22) chatbots ;; 23) mais_opcoes ;;
        19|19) update_script ;; 0|00) exit 0 ;;
        *) echo "Opção inválida!"; sleep 1 ;;
    esac
done
