#!/bin/bash

# --- PAINEL ALIEN VPN SSH HIPER ---
# Instalador Otimizado e Limpo

clear
echo -e "\033[1;32m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "           ⇱ ALIEN VPN SSH HIPER ⇲             "
echo -e "\033[1;32m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Iniciando a instalação, aguarde..."

# 1. ATUALIZAÇÃO BÁSICA
apt-get update -y && apt-get upgrade -y

# 2. INSTALAÇÃO DO SSH-PLUS (Executável)
if [ ! -f /root/Plus ]; then
    wget -O /root/Plus https://raw.githubusercontent.com/zumgabutm/donomodderajuda/main/Plus
    chmod 777 /root/Plus
fi

# 3. CRIAÇÃO DO GERENCIADOR XRAY (Simples e funcional)
cat << 'EOF' > /root/xray_manager.sh
#!/bin/bash
while true; do
    clear
    echo -e "\033[1;36m--- XRAY CORE MANAGER ---\033[0m"
    echo -e " [1] Reiniciar Xray | [2] Mudar Porta | [0] Voltar"
    read -p "Opção: " sub
    case $sub in
        1) systemctl restart xray; echo "Reiniciado!"; sleep 1 ;;
        2) read -p "Porta: " p; sed -i "s/\"port\": [0-9]*/\"port\": $p/" /etc/xray/config.json; systemctl restart xray; echo "Porta alterada!"; sleep 1 ;;
        0) break ;;
    esac
done
EOF
chmod +x /root/xray_manager.sh

# 4. CRIAÇÃO DO MENU CENTRAL
cat << 'EOF' > /usr/bin/menu
#!/bin/bash
while true; do
    clear
    echo -e "\033[1;32m======================================"
    echo -e "      ALIEN VPN SSH HIPER - PRO       "
    echo -e "======================================"
    echo -e " [01] ABRIR SSH-PLUS"
    echo -e " [20] ABRIR XRAY"
    echo -e " [00] SAIR"
    echo -e "======================================"
    read -p "ESCOLHA: " opt
    case $opt in
        01|1) cd /root && ./Plus ;;
        20) /root/xray_manager.sh ;;
        00|0) exit 0 ;;
        *) echo "Opção inválida!"; sleep 1 ;;
    esac
done
EOF
chmod +x /usr/bin/menu

echo -e "\033[1;32mINSTALAÇÃO FINALIZADA COM SUCESSO!\033[0m"
echo -e "Para abrir o painel, digite: \033[1;33mmenu\033[0m"
