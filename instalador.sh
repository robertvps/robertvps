mkdir -p /etc/sshplus
mkdir -p /etc/sshplus/v2ray
mkdir -p /etc/sshplus/vessas

# 2. EMULAÇÃO DOS SUBMÓDULOS (Arquivos internos que o instalador baixa)
# Opção 01 - Criar Usuário
cat << 'EOF' > /etc/sshplus/criarusuario
#!/bin/bash
clear
echo -e "\033[1;32m--- CRIAR USUÁRIO SSH/VPN ---\033[0m"
read -p "Nome do Usuário: " user
read -p "Senha: " pass
read -p "Dias de Validade: " dias
if id "$user" &>/dev/null; then
    echo -e "\033[1;31mUsuário já existe!\033[0m"
else
    useradd -M -s /bin/false -e $(date -d "$dias days" +%Y-%m-%d) "$user" 2>/dev/null
    echo "$user:$pass" | chpasswd
    echo -e "\033[1;32mUsuário $user criado com sucesso!\033[0m"
fi
sleep 2
EOF
chmod +x /etc/sshplus/criarusuario

# Opção 12 - Modos de Conexão (Submenu de Protocolos)
cat << 'EOF' > /etc/sshplus/conexao
#!/bin/bash
clear
while true; do
    echo -e "\033[1;34m┌────────────────────────────────────────┐\033[0m"
    echo -e "\033[1;34m│\033[0m         \033[1;33mSUBMENU: MODOS DE CONEXÃO\033[0m      \033[1;34m│\033[0m"
    echo -e "\033[1;34m├────────────────────────────────────────┤\033[0m"
    echo -e "\033[1;34m│\033[0m [1] ATIVAR SSH DIRECTO                  \033[1;34m│\033[0m"
    echo -e "\033[1;34m│\033[0m [2] CONFIGURAR SSL/PROXY                \033[1;34m│\033[0m"
    echo -e "\033[1;34m│\033[0m [3] GERENCIAR V2RAY (SUBPASTA)          \033[1;34m│\033[0m"
    echo -e "\033[1;34m│\033[0m [0] VOLTAR AO MENU PRINCIPAL            \033[1;34m│\033[0m"
    echo -e "\033[1;34m└────────────────────────────────────────┘\033[0m"
    read -p "Opção: " subopt
    case $subopt in
        1) echo "Configurando SSH nas portas padrão..."; sleep 2 ;;
        2) echo "Gerenciando túnel SSL..."; sleep 2 ;;
        3) 
            # Chama o script que fica dentro da subpasta v2ray
            if [ -f /etc/sshplus/v2ray/v2raymenu ]; then
                bash /etc/sshplus/v2ray/v2raymenu
            else
                echo "Módulo V2Ray não instalado."
                sleep 2
            fi
            ;;
        0) break ;;
    esac
done
EOF
chmod +x /etc/sshplus/conexao

# Script da Subpasta v2ray
cat << 'EOF' > /etc/sshplus/v2ray/v2raymenu
#!/bin/bash
clear
echo -e "\033[1;35m--- GERENCIADOR V2RAY (PASTA INTERNA) ---\033[0m"
echo "[1] Adicionar Usuário V2Ray"
echo "[2] Deletar Usuário V2Ray"
echo "[0] Voltar"
read -p "Escolha: " v2opt
sleep 1
EOF
chmod +x /etc/sshplus/v2ray/v2raymenu


# 3. CÓDIGO DO MENU DIRECIONADOR PRINCIPAL
VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
CENARIO='\033[1;36m'
SEM_COR='\033[0m'

OS_VERSAO=$(lsb_release -si 2>/dev/null || echo "Ubuntu")
OS_RELEASE=$(lsb_release -sr 2>/dev/null || echo "22.04")
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
NUCLEOS=$(nproc)

while true; do
    HORA_ATUAL=$(date +%H:%M:%S)
    clear
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR}                ${VERMELHO}« SSHPLUS MANAGER PRO »${SEM_COR}                ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${CENARIO}SISTEMA${SEM_COR}           ${CENARIO}MEMORIA RAM${SEM_COR}       ${CENARIO}PROCESSADOR${SEM_COR}    ${AZUL}│${SEM_COR}"
    printf "${AZUL}│${SEM_COR} OS: %-13s Total: %-11s Nucleos: %-10s ${AZUL}│\n${SEM_COR}" "$OS_VERSAO $OS_RELEASE" "$RAM_TOTAL" "$NUCLEOS"
    printf "${AZUL}│${SEM_COR} Hora: %-47s ${AZUL}│\n${SEM_COR}" "$HORA_ATUAL"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${VERDE}Onlines:${SEM_COR} 0        ${VERMELHO}Expirados:${SEM_COR} 0      ${AMARELO}Total:${SEM_COR} 0         ${AZUL}│${SEM_COR}"
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
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[11]${SEM_COR} • BACKUP DE USUARIOS ${AMARELO}[23]${SEM_COR} • MAIS OPCOES    →     ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR} ${AMARELO}[12]${SEM_COR} • MODOS DE CONEXAO   ${AMARELO}[00]${SEM_COR} • SAIR DO MENU         ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    echo ""
    echo -n "INFORME UMA OPÇÃO: "
    read opcao

    case $opcao in
        1|01) [ -f /etc/sshplus/criarusuario ] && bash /etc/sshplus/criarusuario ;;
        12) [ -f /etc/sshplus/conexao ] && bash /etc/sshplus/conexao ;;
        0|00) clear; exit 0 ;;
        *) echo -e "\n${VERMELHO}Módulo em execução ou aguardando dependências...${SEM_COR}"; sleep 1 ;;
    esac
done
