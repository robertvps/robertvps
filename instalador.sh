#!/bin/bash

# --- CONFIGURAÇÃO DO PAINEL ---
NOME_PAINEL="ALIEN VPN SSH HIPER"
CONTATO="@alienvps" # Altere para o seu usuário

clear
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "           ⇱ $NOME_PAINEL ⇲             "
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "INSTALANDO O SISTEMA... AGUARDE."
echo ""

# 1. ATUALIZAÇÃO
apt-get update -y && apt-get upgrade -y

# 2. INSTALAÇÃO DO SSH-PLUS (Link original que você usava)
wget -O /root/Plus https://raw.githubusercontent.com/zumgabutm/donomodderajuda/main/Plus
chmod 777 /root/Plus

# 3. CRIAÇÃO DO MENU CENTRAL
cat << 'EOF' > /bin/menu
#!/bin/bash
while true; do
    clear
    echo -e "\033[1;32m════════════════════════════════════════════════════\033[0m"
    echo -e "           ALIEN VPN SSH HIPER - PAINEL PRO         "
    echo -e "\033[1;32m════════════════════════════════════════════════════\033[0m"
    echo -e " [01] ABRIR SSH-PLUS MANAGER"
    echo -e " [20] ABRIR XRAY CORE MANAGER"
    echo -e " [00] SAIR"
    echo -e "\033[1;32m════════════════════════════════════════════════════\033[0m"
    read -p "ESCOLHA UMA OPÇÃO: " opt
    case $opt in
        01|1) cd /root && ./Plus ;;
        20) /root/xray_manager.sh ;;
        00|0) exit 0 ;;
        *) echo "Opção inválida!"; sleep 1 ;;
    esac
done
EOF
chmod +x /bin/menu

# 4. CONFIGURAÇÃO DE BOAS-VINDAS
cat << 'EOF' > /etc/motd
Bem-vindo ao ALIEN VPN SSH HIPER!
Para acessar o painel, digite: menu
EOF

echo -e "\033[1;32mINSTALAÇÃO FINALIZADA COM SUCESSO!\033[0m"
echo -e "Para acessar, digite: \033[1;33mmenu\033[0m"
