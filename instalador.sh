#!/bin/bash
clear

# Configurações do seu Repositório
USUARIO_GITHUB="robertvps"
REPOSITORIO="robertvps"
BRANCH="main"
URL_RAW="https://raw.githubusercontent.com/$USUARIO_GITHUB/$REPOSITORIO/$BRANCH"

# Verificar se o usuário é root
[[ "$(whoami)" != "root" ]] && {
    echo -e "\033[1;37m[\033[1;31mErro\033[1;37m] - Você precisa executar como root\033[0m"
    exit 1
}

cd $HOME

# Tela de Boas-Vindas Personalizada
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[38;5;118m        ⇱ GERENCIADOR ROBERT.VPS ATUALIZADO ⇲               "
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "                \033[1;32mINSTALADOR LEGÍTIMO E AUTÔNOMO\033[0m"
echo ""
echo -e "\033[1;31m• \033[1;37mInstalação de ferramentas de gerenciamento VPS\033[0m"
echo ""
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""

echo -ne "\033[38;5;118mENTER \033[1;37mpara continuar a \033[1;31mINSTALAÇÃO : \033[0m"; read x
[[ "$x" = @(n|N) ]] && exit 1

clear
echo -e "\033[1;32m[+] ATUALIZANDO O SISTEMA (Aguarde...)\033[0m"
apt-get update -y > /dev/null 2>&1
apt-get install lolcat figlet curl git boxes lsb-release -y > /dev/null 2>&1

echo -e "\033[1;32m[+] INSTALANDO DEPENDÊNCIAS PYTHON ESSENCIAIS...\033[0m"
apt install pip python3-pip uuid-runtime socat python3 -y > /dev/null 2>&1

_pacotes=("bc" "screen" "nano" "unzip" "lsof" "netstat" "net-tools" "dos2unix" "nload" "jq" "firewalld")
for _prog in ${_pacotes[@]}; do
    echo -e "    -> Instalando ferramenta: $_prog"
    apt install $_prog -y > /dev/null 2>&1
done

pip install speedtest-cli --break-system-packages > /dev/null 2>&1

# Sincronizando e baixando o menu corrigido do seu repositório
echo -e "\n\033[1;33m[+] Baixando componentes do seu repositório...\033[0m"
mkdir -p /bin/vps_modulos > /dev/null 2>&1

# Baixa o seu 'instalar.sh' do git e joga pra pasta global como 'menu'
wget -O /bin/menu "$URL_RAW/instalar.sh" > /dev/null 2>&1
chmod +x /bin/menu > /dev/null 2>&1

echo "/bin/menu" > /bin/h && chmod +x /bin/h > /dev/null 2>&1

cd $HOME

# Gerenciamento de Base de Dados Existente
if [[ -f "$HOME/usuarios.db" ]]; then
    awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > $HOME/usuarios.db
fi

echo -e "\033[1;32m[+] CONFIGURANDO PORTAS E REGRAS DE FIREWALL...\033[0m"
[[ -f "/usr/sbin/ufw" ]] && { ufw allow 443/tcp; ufw allow 80/tcp; ufw allow 3128/tcp; ufw allow 8799/tcp; ufw allow 8080/tcp; } > /dev/null 2>&1

clear
echo ""
cd $HOME

# Customizando o seu terminal (.bashrc)
cat /dev/null > /root/.bashrc
echo "clear" >> /root/.bashrc
echo 'DATE=$(date +"%d-%m-%y")' >>/root/.bashrc
echo 'TIME=$(date +"%T")' >>/root/.bashrc
echo 'echo -e "\033[1;35m======================================\033[0m"' >>/root/.bashrc
echo 'echo -e "\033[1;36m         ROBERT.VPS MANAGER           \033[0m"' >>/root/.bashrc
echo 'echo -e "\033[1;35m======================================\033[0m"' >>/root/.bashrc
echo 'echo -e "\033[1;32m NOME DO SERVIDOR : \033[38;5;196m$HOSTNAME"' >>/root/.bashrc
echo 'echo -e "\033[1;32m SERVIDOR LIGADO À : \033[1;31m$(uptime -p)"' >>/root/.bashrc
echo 'echo -e "\033[1;32m DATA : \033[1;31m$DATE"' >>/root/.bashrc
echo 'echo -e "\033[1;32m HORA : \033[1;31m$TIME"' >>/root/.bashrc
echo 'echo -e "\033[1;32m DIGITE : \033[1;31mmenu\033[1;37m"' >>/root/.bashrc
echo 'echo -e ""' >>/root/.bashrc

date=$(date '+%Y-%m-%d <> %H:%M:%S')
echo -e "\033[1;37m Servidor                            $date"
echo -e "\033[1;37m                INSTALACAO CONCLUIDA                \033[1;33m "
echo -e "\033[1;33mPARA INICIAR DIGITE: \033[1;36mmenu\033[1;33m E DÊ ENTER \033[0m"

rm -f $HOME/instalador.sh && cat /dev/null > ~/.bash_history && history -c
