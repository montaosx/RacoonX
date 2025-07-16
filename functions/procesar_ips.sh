function procesar_ips(){
    local resultado="$1"

    mapfile -t ips_detectadas < <(echo "$resultado" | grep -oP '\d{1,3}(\.\d{1,3}){3}' | sort -u)
    printf "%s\n" "${ips_detectadas[@]}" > ips_detectadas.txt

    if [ "${#ips_detectadas[@]}" -eq 0 ]; then
        echo -e "\n${ROJO}[!]${RESET} ${ROJO}No se ha detectado ningún host en la red.${RESET}"
        echo -e "${ROJO}[!]${RESET} ${ROJO}Es posible que se haya perdido la conexión a internet.${RESET}"
        echo -e "${ROJO}[!]${RESET} ${LAVANDA}Vuelva a intentarlo cuando esté conectado a Internet.${RESET}"
        exit 0

    elif [ "${#ips_detectadas[@]}" -eq 1 ]; then
        echo -e "\n${AMARILLO}[!]${RESET} ${LAVANDA}Solo se ha detectado su propio equipo en la red.${RESET}"
        read -p "$(echo -e "\n${AMARILLO}[!]${RESET} ${LAVANDA}¿Quiere escanear su propio equipo?${RESET} ${AZUL}[S/n(default)]${RESET} ")" election

        if [[ "$election" != "s" && "$election" != "S" ]]; then
            echo -e "\n${ROJO}[!]${RESET} ${ROJO}Saliendo...${RESET}"
            exit 0
        fi
    fi

    echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}IPs DETECTADAS${LAVANDA}:${RESET}"
    for i in "${ips_detectadas[@]}"; do
        echo -e " ${AZUL}-${RESET} ${AMARILLO}$i${RESET}"
    done

    echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Dispone de un archivo${RESET} ${AZUL}ips_detectadas.txt${RESET} ${LAVANDA}en${RESET} ${AZUL}$PWD${RESET}\n"
}
