#!/bin/bash

# 1. CRIAR O SCRIPT DO XRAY MANAGER
cat << 'EOF' > /root/xray_manager.sh
#!/bin/bash
while true; do
    clear
    echo -e "\033[1;36m========================================\n         XRAY CORE MANAGER - PRO        \n========================================\033[0m"
    echo -e " [1] Ativar Xray    | [2] Reiniciar Xray"
    echo -e " [3] Mudar Porta    | [4] Mudar IP/Host"
    echo -e " [5] Mudar SNI      | [7] Remover Xray"
    echo -e " [0] Voltar ao Menu Principal"
    read -p " Opção: " sub
    case $sub in
        1) systemctl start xray; echo "Xray ativado!"; sleep 2 ;;
        2) systemctl restart xray; echo "Xray reiniciado!"; sleep 2 ;;
        3) read -p "Nova porta: " p; sed -i "s/\"port\": [0-9]*/\"port\": $p/" /etc/xray/config.json; systemctl restart xray; echo "Porta $p aplicada!"; sleep 2 ;;
        4) read -p "Novo IP: " h; sed -i "s/dest\": \".*\"/dest\": \"$h\"/" /etc/xray/config.json; systemctl restart xray; echo "Host alterado!"; sleep 2 ;;
        5) read -p "Novo SNI: " s; sed -i "s/serverNames\": \[\".*\"\]/serverNames\": \[\"$s\"\]/" /etc/xray/config.json; systemctl restart xray; echo "SNI alterado!"; sleep 2 ;;
        7) apt purge xray -y; rm -rf /etc/xray; echo "Xray removido!"; sleep 2 ;;
        0) break ;;
    esac
done
EOF
chmod +x /root/xray_manager.sh

# 2. CRIAR O MENU CENTRAL (Ajustado para abrir o Plus corretamente)
cat << 'EOF' > /bin/menu
#!/bin/bash
while true; do
    clear
    echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
    tput setaf 7 ; tput setab 4 ; tput bold ; printf '%40s%s%-12s\n' "ALIEN VPN - PAINEL PRO" ; tput sgr0
    echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
    echo -e " [01] ABRIR SSH-PLUS MANAGER"
    echo -e " [20] ABRIR XRAY CORE MANAGER"
    echo -e " [00] SAIR"
    echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
    read -p "ESCOLHA UMA OPÇÃO: " opt
    case $opt in
        01|1) ./Plus ;;
        20) /root/xray_manager.sh ;;
        00|0) exit 0 ;;
        *) echo "Opção inválida!"; sleep 1 ;;
    esac
done
EOF
chmod +x /bin/menu

echo -e "\033[1;32mINSTALAÇÃO FINALIZADA COM SUCESSO!\033[0m"
echo -e "\033[1;33mDIGITE 'menu' PARA ACESSAR.\033[0m"
