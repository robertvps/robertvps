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

    case ${opt#0} in
        1) criar_usuario ;; 2) criar_teste ;; 3) remover_usuario ;;
        4) renovar_usuario ;; 5) listar_online ;; 6) alterar_data ;;
        7) alterar_limite ;; 8) alterar_senha ;; 9) remover_expirados ;;
        10) relatorio_usuarios ;; 11) backup_usuarios ;; 12) modos_conexao ;;
        13) f_speedtest ;; 14) f_otimizar ;; 15) f_trafego ;;
        16) f_firewall ;; 17) f_info ;; 18) f_banner ;;
        19) f_limitar ;; 20) manage_badvpn ;; 21) automenu ;;
        22) chatbots ;; 23) mais_opcoes ;; 0) exit 0 ;;
        *) echo "Opção inválida!"; sleep 1 ;;
    esac
done
