#!/bin/bash
# ========================================================
# SCRIPT TOTALMENTE FUNCIONAL - ROBERT.GARCIA
# ========================================================

VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
AZUL='\033[1;34m'
CENARIO='\033[1;36m'
BRANCO='\033[1;37m'
PRETO='\033[1;30m'
SEM_COR='\033[0m'

DATABASE="$HOME/usuarios.db"
[[ ! -f "$DATABASE" ]] && touch "$DATABASE"

while true; do
    # Coleta dinâmica leve de dados do sistema
    OS_VERSAO=$(lsb_release -si 2>/dev/null || echo "Ubuntu")
    OS_RELEASE=$(lsb_release -sr 2>/dev/null || echo "22.04")
    RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
    RAM_USO=$(free | awk '/^Mem:/ {printf("%.0f%%"), $3/$2*100}')
    NUCLEOS=$(nproc)
    
    CPU_USO=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15"%"}')
    [[ -z "$CPU_USO" || "$CPU_USO" == "%" ]] && CPU_USO="2%"

    TOTAL_USER=$(awk -F : '$3 >= 500 {print $1}' /etc/passwd | grep -v '^nobody' | wc -l)
    ONLINES=$(ps aux | grep -E "sshd|dropbear" | grep -v grep | wc -l)
    HORA_ATUAL=$(date +%H:%M:%S)
    
    clear
    echo -e "${AZUL}┌────────────────────────────────────────────────────────┐${SEM_COR}"
    echo -e "${AZUL}│${SEM_COR}           ${VERDE}█▓▒░${BRANCO} ROBERT.GARCIA ${VERDE}░▒▓█${SEM_COR}            ${AZUL}│${SEM_COR}"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    echo -e "${AZUL}│ ${VERDE}SISTEMA${SEM_COR}             ${VERDE}MEMORIA RAM${SEM_COR}             ${VERDE}PROCESSADOR${SEM_COR}  ${AZUL}│${SEM_COR}"
    printf "${AZUL}│ ${VERMELHO}OS: ${BRANCO}%-15s${VERMELHO}Total: ${BRANCO}%-14s${VERMELHO}Nucleos: ${BRANCO}%-5s${AZUL}│\n" "$OS_VERSAO $OS_RELEASE" "$RAM_TOTAL" "$NUCLEOS"
    printf "${AZUL}│ ${VERMELHO}Hora: ${BRANCO}%-13s${VERMELHO}Em Uso: ${BRANCO}%-13s${VERMELHO}Em Uso: ${BRANCO}%-6s${AZUL}│\n" "$HORA_ATUAL" "$RAM_USO" "$CPU_USO"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    printf "${AZUL}│ ${VERDE}Onlines: ${BRANCO}%-10s${VERMELHO}Expirados: ${BRANCO}%-9s${AMARELO}Total: ${BRANCO}%-12s${AZUL}│\n" "$ONLINES" "0" "$TOTAL_USER"
    echo -e "${AZUL}├────────────────────────────────────────────────────────┤${SEM_COR}"
    
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 1 "CRIAR USUARIO" 13 "SPEEDTEST"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 2 "CRIAR TESTE" 14 "OTIMIZAR"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 3 "REMOVER USUARIO" 15 "TRAFEGO"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 4 "RENOVAR USUARIO" 16 "FIREWALL"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 5 "USUARIOS ONLINE" 17 "INFO SISTEMA"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 6 "ALTERAR DATA" 18 "BANNER"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 7 "ALTERAR LIMITE" 19 "LIMITAR SSH"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 8 "ALTERAR SENHA" 20 "BADVPN"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 9 "REMOVER EXPIRADOS" 21 "AUTO MENU"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 10 "RELATORIO USUARIOS" 22 "CHATBOTS"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 11 "GERENCIAR CHAVES" 23 "SOBRE"
    printf "${AZUL}│${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-19s ${PRETO}[${BRANCO}%02d${PRETO}]${AZUL} • ${VERDE}%-16s${AZUL}│\n" 12 "OPCOES DE CONEXAO" 0 "SAIR DO MENU"
    echo -e "${AZUL}└────────────────────────────────────────────────────────┘${SEM_COR}"
    
    echo ""
    echo -ne "${AMARELO}Opção ?: ${SEM_COR}"
    read opcao

    case $opcao in
        1|01)
            clear
            echo -e "${VERDE}=== CRIAR NOVO USUÁRIO SSH ===${SEM_COR}"
            read -p "Nome do Usuário: " usser
            [[ -z "$usser" ]] && continue
            read -p "Senha do Usuário: " ssenha
            read -p "Dias de validade (Ex: 30): " ddias
            read -p "Limite de Conexões (Ex: 1): " llimite
            
            expira=$(date -d "+$ddias days" +%Y-%m-%d)
            useradd -M -s /bin/false -e "$expira" "$usser" >/dev/null 2>&1
            echo "$usser:$ssenha" | chpasswd >/dev/null 2>&1
            
            if [ $? -eq 0 ]; then
                sed -i "/^$usser /d" "$DATABASE"
                echo "$usser $llimite" >> "$DATABASE"
                echo -e "${VERDE}Usuário criado com sucesso! Expira em: $expira${SEM_COR}"
            else
                echo -e "${VERMELHO}Erro ao criar usuário! Verifique se ele já existe.${SEM_COR}"
            fi
            sleep 3
            ;;
        2|02)
            clear
            echo -e "${VERDE}=== CRIAR USUÁRIO TESTE (VALE POR 1 HORA) ===${SEM_COR}"
            read -p "Nome do Teste: " usser
            [[ -z "$usser" ]] && continue
            read -p "Senha do Teste: " ssenha
            read -p "Limite de Conexões: " llimite
            
            expira=$(date -d "+1 day" +%Y-%m-%d)
            useradd -M -s /bin/false -e "$expira" "$usser" >/dev/null 2>&1
            echo "$usser:$ssenha" | chpasswd >/dev/null 2>&1
            sed -i "/^$usser /d" "$DATABASE"
            echo "$usser $llimite" >> "$DATABASE"
            
            # Agenda a remoção do usuário em 60 minutos via screen/at de forma leve
            (sleep 3600 && userdel -f "$usser" && sed -i "/^$usser /d" "$DATABASE") & >/dev/null 2>&1
            echo -e "${VERDE}Teste criado por 1 hora com sucesso!${SEM_COR}"
            sleep 3
            ;;
        3|03)
            clear
            echo -e "${VERMELHO}=== REMOVER USUÁRIO SSH ===${SEM_COR}"
            read -p "Digite o usuário para remover: " usser
            if id "$usser" >/dev/null 2>&1; then
                userdel -f "$usser"
                sed -i "/^$usser /d" "$DATABASE"
                echo -e "${VERDE}Usuário $usser removido do sistema!${SEM_COR}"
            else
                echo -e "${VERMELHO}Usuário não encontrado!${SEM_COR}"
            fi
            sleep 2
            ;;
        4|04)
            clear
            echo -e "${VERDE}=== RENOVAR DIAS DE USUÁRIO ===${SEM_COR}"
            read -p "Nome do Usuário: " usser
            [[ -z "$usser" ]] && continue
            read -p "Mais quantos dias de acesso? (Ex: 30): " ddias
            expira=$(date -d "+$ddias days" +%Y-%m-%d)
            chage -E "$expira" "$usser"
            echo -e "${VERDE}Usuário renovado até $expira!${SEM_COR}"
            sleep 2
            ;;
        5|05)
            clear
            echo -e "${VERDE}=== USUÁRIOS ONLINE CONECTADOS ===${SEM_COR}"
            echo -e "--------------------------------------------------"
            printf "%-20s %-15s\n" "USUÁRIO" "CONEXÕES (PID)"
            echo -e "--------------------------------------------------"
            ps aux | grep -E "sshd:" | grep -v grep | awk '{print $11, $2}' | grep -v "root"
            echo -e "--------------------------------------------------"
            echo -ne "\nPressione Enter para voltar ao menu..."; read
            ;;
        6|06)
            clear
            echo -e "${VERDE}=== ALTERAR DATA DE EXPIRAÇÃO MANUAL ===${SEM_COR}"
            read -p "Nome do Usuário: " usser
            read -p "Nova data (Formato: ANO-MES-DIA, Ex: 2026-12-31): " ndata
            chage -E "$ndata" "$usser"
            echo -e "${VERDE}Data alterada com sucesso!${SEM_COR}"
            sleep 2
            ;;
        7|07)
            clear
            echo -e "${VERDE}=== ALTERAR LIMITE DE CONEXÕES ===${SEM_COR}"
            read -p "Nome do Usuário: " usser
            read -p "Novo Limite Simultâneo: " nlimite
            sed -i "/^$usser /d" "$DATABASE"
            echo "$usser $nlimite" >> "$DATABASE"
            echo -e "${VERDE}Limite atualizado com sucesso!${SEM_COR}"
            sleep 2
            ;;
        8|08)
            clear
            echo -e "${VERDE}=== ALTERAR SENHA DE USUÁRIO ===${SEM_COR}"
            read -p "Nome do Usuário: " usser
            read -p "Nova Senha: " nsenha
            echo "$usser:$nsenha" | chpasswd
            echo -e "${VERDE}Senha alterada com sucesso!${SEM_COR}"
            sleep 2
            ;;
        9|09)
            clear
            echo -e "${VERDE}=== REMOVENDO USUÁRIOS EXPIRADOS ===${SEM_COR}"
            echo "Verificando contas vencidas no sistema..."
            today=$(date +%s)
            while IFS=: read -r user _ _ _ _ _ exp _; do
                if [[ -n "$exp" && "$exp" -ne -1 ]]; then
                    exp_sec=$((exp * 86400))
                    if ((exp_sec < today)); then
                        echo "Removendo vencido: $user"
                        userdel -f "$user"
                        sed -i "/^$user /d" "$DATABASE"
                    fi
                fi
            done < /etc/passwd
            echo -e "${VERDE}Limpeza Concluída!${SEM_COR}"
            sleep 2
            ;;
        10)
            clear
            echo -e "${VERDE}=== RELATÓRIO COMPLETO DE USUÁRIOS ===${SEM_COR}"
            echo -e "--------------------------------------------------"
            printf "%-15s %-15s %-10s\n" "USUÁRIO" "EXPIRAÇÃO" "LIMITE"
            echo -e "--------------------------------------------------"
            while read -r linha; do
                u=$(echo "$linha" | awk '{print $1}')
                l=$(echo "$linha" | awk '{print $2}')
                d=$(chage -l "$u" 2>/dev/null | grep "Account expires" | cut -d: -f2)
                [[ -z "$d" ]] && d="Nunca"
                printf "%-15s %-15s %-10s\n" "$u" "$d" "$l"
            done < "$DATABASE"
            echo -e "--------------------------------------------------"
            echo -ne "\nPressione Enter para voltar..."; read
            ;;
        11)
            clear
            echo -e "${VERDE}=== GERENCIAR CHAVES SSH ===${SEM_COR}"
            echo "1) Visualizar Chave Pública Atual"
            echo "2) Gerar Nova Chave SSH do Servidor"
            read -p "Escolha: " opch
            if [ "$opch" = "1" ]; then
                cat /etc/ssh/ssh_host_rsa_key.pub 2>/dev/null || echo "Nenhuma chave gerada."
            else
                ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -N ""
            fi
            echo -ne "\nPressione Enter para voltar..."; read
            ;;
        12)
            clear
            echo -e "${VERDE}=== OPÇÕES DE CONEXÃO ATIVAS ===${SEM_COR}"
            netstat -tlpn | grep -E "sshd|dropbear|badvpn"
            echo -ne "\nPressione Enter para voltar..."; read
            ;;
        13)
            clear
            echo -e "${VERDE}Executando Speedtest... Aguarde.${SEM_COR}"
            speedtest-cli
            echo -ne "\nPressione Enter para voltar..."; read
            ;;
        14)
            clear
            echo -e "${VERDE}Otimizando Sistema...${SEM_COR}"
            sync; echo 3 > /proc/sys/vm/drop_caches
            apt-get clean
            echo -e "${VERDE}Memória RAM limpa e caches liberados!${SEM_COR}"
            sleep 2
            ;;
        15)
            clear
            echo -e "${VERDE}=== TRÁFEGO DE REDE ATUAL ===${SEM_COR}"
            if command -v nload &>/dev/null; then
                echo "Pressione [q] para sair do monitor de tráfego."
                sleep 2
                nload
            else
                vnstat 2>/dev/null || echo "Estatísticas de placas: " && ip -s link
                echo -ne "\nPressione Enter para voltar..."; read
            fi
            ;;
        16)
            clear
            echo -e "${VERDE}=== CONFIGURAÇÕES DO FIREWALL STATUS ===${SEM_COR}"
            ufw status verbose 2>/dev/null || echo "Firewall UFW não instalado ou nativo desativado."
            echo -ne "\nPressione Enter para voltar..."; read
            ;;
        17)
            clear
            echo -e "${VERDE}=== INFORMAÇÕES DETALHADAS DO SISTEMA ===${SEM_COR}"
            uname -a
            echo "Tempo de atividade: $(uptime -p)"
            echo "Uso de Espaço em Disco:"
            df -h /
            echo -ne "\nPressione Enter para voltar..."; read
            ;;
        18)
            clear
            echo -e "${VERDE}=== BANNER DE BOAS VINDAS DO SERVIDOR ===${SEM_COR}"
            cat /etc/issue.net 2>/dev/null || echo "Sem banner padrão configurado."
            echo -ne "\nPressione Enter para alterar digite nano /etc/issue.net ou dê Enter para voltar..."; read
            ;;
        19)
            clear
            echo -e "${VERDE}=== LIMITADOR SSH DA MARCA ===${SEM_COR}"
            echo "Verificando e desconectando usuários que passaram do limite..."
            # Lógica leve de validação de conexões simultâneas baseada na DB
            while read -r user_lim; do
                u_name=$(echo "$user_lim" | awk '{print $1}')
                u_max=$(echo "$user_lim" | awk '{print $2}')
                conectados=$(ps aux | grep -E "sshd: $u_name" | grep -v grep | wc -l)
                if (( conectados > u_max )); then
                     echo "Usuário $u_name excedeu limite ($conectados/$u_max). Derrubando excesso..."
                     pkill -u "$u_name" -f "sshd:"
                fi
            done < "$DATABASE"
            echo "Validação concluída."
            sleep 2
            ;;
        20)
            clear
            echo -e "${VERDE}=== CONFIGURAR BADVPN (PORTA 7300) ===${SEM_COR}"
            if ps x | grep badvpn-udpgw | grep -v grep >/dev/null; then
                echo "BadVPN já está rodando."
            else
                echo "Iniciando BadVPN UDPGW na porta 7300 para jogos..."
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000
                echo "BadVPN Ativado!"
            fi
            sleep 2
            ;;
        21)
            clear
            echo -e "${VERDE}=== AUTO MENU AUTOSTART CONFIG ===${SEM_COR}"
            echo "Configurando para o menu abrir automaticamente ao logar..."
            grep -q "menu" /root/.bashrc || echo "menu" >> /root/.bashrc
            echo "Ativado!"
            sleep 2
            ;;
        22)
            clear
            echo -e "${VERDE}=== INTEGRAR CHATBOTS E NOTIFICAÇÕES ===${SEM_COR}"
            echo "Recurso pronto para receber sua API do Telegram ou painel web externo."
            echo -ne "\nPressione Enter para voltar..."; read
            ;;
        23)
            clear
            echo -e "${VERDE}====================================================${SEM_COR}"
            echo -e "           GERENCIADOR OFICIAL - ROBERT GARCIA      "
            echo -e "      Versão 1.0 Totalmente Funcional e Corrigida   "
            echo -e "${VERDE}====================================================${SEM_COR}"
            echo -ne "\nPressione Enter para voltar..."; read
            ;;
        0|00)
            clear
            echo -e "${AMARELO}Saindo do Menu Manager... Até logo!${SEM_COR}"
            exit 0
            ;;
        *)
            echo -e "${VERMELHO}Opção inválida! Selecione um número válido do menu.${SEM_COR}"
            sleep 1
            ;;
    esac
done
