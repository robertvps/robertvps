#!/bin/bash

# 1. CRIAR O XRAY MANAGER (8 funções)
cat << 'EOF' > /root/xray_manager.sh
#!/bin/bash
header() { clear; echo -e "\033[1;36m========================================\n         XRAY CORE MANAGER - PRO        \n========================================\033[0m"; }
while true; do
    header
    echo -e " [1] Ativar Xray | [2] Reiniciar | [3] Mudar Porta | [4] Mudar IP/Host\n [5] Mudar SNI   | [6] Porta Man | [7] Remover Xray | [0] Voltar"
    read -p " Opção: " sub
    case $sub in
        1) systemctl start xray; echo "Xray ativado!"; sleep 2 ;;
        2) systemctl restart xray; echo "Xray reiniciado!"; sleep 2 ;;
        3|6) read -p "Nova porta: " p; sed -i "s/\"port\": [0-9]*/\"port\": $p/" /etc/xray/config.json; systemctl restart xray; echo "Porta $p aplicada!"; sleep 2 ;;
        4) read -p "Novo IP/Host: " h; sed -i "s/dest\": \".*\"/dest\": \"$h\"/" /etc/xray/config.json; systemctl restart xray; echo "Host alterado!"; sleep 2 ;;
        5) read -p "Novo SNI: " s; sed -i "s/serverNames\": \[\".*\"\]/serverNames\": \[\"$s\"\]/" /etc/xray/config.json; systemctl restart xray; echo "SNI alterado!"; sleep 2 ;;
        7) apt purge xray -y; rm -rf /etc/xray; echo "Xray removido!"; sleep 2 ;;
        0) break ;;
    esac
done
EOF
chmod +x /root/xray_manager.sh

# 2. INTEGRAR NO MENU DO SSH-PLUS
# Verifica se o menu já foi modificado para não duplicar a opção 20
if ! grep -q "XRAY MANAGER" /bin/menu; then
    sed -i '/\[19\]/a \echo -e " [20] \033[1;32mXRAY MANAGER\033[0m"' /bin/menu
    sed -i '/19)/a \        20) /root/xray_manager.sh ;;' /bin/menu
fi

echo -e "\033[1;32mINSTALAÇÃO CONCLUÍDA! DIGITE 'menu' PARA ACESSAR.\033[0m"
