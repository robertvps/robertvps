#!/bin/bash

# --- ALIEN VPN SSH HIPER - INSTALADOR OTIMIZADO ---

# Remove possíveis resíduos anteriores para evitar conflitos
rm -f /root/Plus
rm -f /usr/bin/menu

clear
echo -e "\033[1;32m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "           ⇱ ALIEN VPN SSH HIPER ⇲             "
echo -e "\033[1;32m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Iniciando a instalação, aguarde..."

# 1. ATUALIZAÇÃO DO SISTEMA
apt-get update -y && apt-get upgrade -y

# 2. INSTALAÇÃO DO EXECUTÁVEL SSH-PLUS
wget -O /root/Plus https://raw.githubusercontent.com/zumgabutm/donomodderajuda/main/Plus
chmod 777 /root/Plus

# 3. CRIAÇÃO DO MENU UNIFICADO (Tudo em um só para evitar erros)
cat << 'EOF' > /usr/bin/menu
#!/bin/bash
while true; do
    clear
    echo -e "\033[1;36m=============================================="
    echo -e "         👽 ALIEN VPN SSH HIPER 👽            "
    echo -e "=============================================="
    echo -e "  [01] GERENCIAR USUÁRIOS (SSH-PLUS)"
    echo -e "  [02] REINICIAR SERVIÇO XRAY"
    echo -e "  [03] MUDAR PORTA DO XRAY"
    echo -e "  [04] VERIFICAR STATUS DO SERVIDOR"
    echo -e "  [00] SAIR"
    echo -e "=============================================="
    read -p "ESCOLHA UMA OPÇÃO: " opt

    case $opt in
        01|1) cd /root && ./Plus ;;
        02|2) systemctl restart xray; echo "Xray reiniciado!"; sleep 2 ;;
        03|3) read -p "Nova Porta: " p; sed -i "s/\"port\": [0-9]*/\"port\": $p/" /etc/xray/config.json; systemctl restart xray; echo "Porta alterada para $p!"; sleep 2 ;;
        04|4) clear; echo "--- STATUS ---"; uptime; free -m; read -p "Pressione Enter...";;
        00|0) exit 0 ;;
        *) echo "Opção inválida!"; sleep 1 ;;
    esac
done
EOF
chmod +x /usr/bin/menu

# 4. FINALIZAÇÃO
echo -e "\033[1;32mINSTALAÇÃO FINALIZADA COM SUCESSO!\033[0m"
echo -e "Para acessar o painel, digite: \033[1;33mmenu\033[0m"
