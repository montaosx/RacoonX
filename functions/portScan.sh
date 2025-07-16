# Colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[1;36m'
LAVANDA='\033[1;35m'
RESET='\033[0m'

function portScan() {
    echo -e "${AZUL}[+]${RESET} ${LAVANDA}COMENZANDO CON EL ESCANEO DE PUERTOS...${RESET}"
    echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}¿Desea escanear todos los hosts detectados o seleccionar manualmente?${RESET}"
    echo -e "  ${LAVANDA}1)${RESET} ${AMARILLO}Escanear TODOS${RESET}"
    echo -e "  ${LAVANDA}2)${RESET} ${AMARILLO}Seleccionar manualmente${RESET}"
    read -p "$(echo -e "\n${LAVANDA}Introduzca su elección${RESET} ${AZUL}[1/2]${RESET}${LAVANDA}:${RESET} ")" eleccion
    echo

    # SELECCIÓN MANUAL
    if [[ "$eleccion" == "2" ]]; then
        echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Hosts detectados${LAVANDA}:${RESET}"
        for i in "${!ips_detectadas[@]}"; do
            echo -e " ${LAVANDA}$((i+1)))${RESET} ${AMARILLO}${ips_detectadas[$i]}${RESET}"
        done

        read -p "$(echo -e "\n${LAVANDA}Introduzca los números, separados por espacios, correspondientes a los hosts a escanear${RESET} ${AZUL}(ej: 1 3 4)${LAVANDA}:${RESET} ")" seleccion
        echo
        echo
        echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}¿Seleccione cómo quiere visualizar el escaneo?${RESET}"
        echo -e "  ${LAVANDA}1)${RESET} ${AMARILLO}Escaneo secuencial - salida en tiempo real${RESET}"
        echo -e "  ${LAVANDA}2)${RESET} ${AMARILLO}Escaneo paralelo - Sin salida visible - MÁS RÁPIDO${RESET}"
        read -p "$(echo -e "\n${LAVANDA}Introduzca su elección${RESET} ${AZUL}[1/2]${RESET}${LAVANDA}:${RESET} ")" tiempo
        echo
        echo
        echo -e "\n\n${AZUL}[+]${RESET} ${LAVANDA}ESCANEANDO LOS HOSTS SELECCIONADOS...${RESET}\n"

        # PARALELO
        if [[ "$tiempo" == "2" ]]; then
            for num in $seleccion; do
                ip="${ips_detectadas[$((num-1))]}"
                (
                    mkdir PortScan_$ip &>/dev/null
                    echo -e "${AZUL}[+]${RESET} ${LAVANDA}Escaneando puertos en${RESET} ${AZUL}$ip${RESET}${LAVANDA}...${RESET}"
                    nmap -p- --open -sS --min-rate 5000 -n -Pn $ip -oG Ports_$ip &>/dev/null
                    echo -e "${AZUL}[+]${RESET} ${LAVANDA}Escaneo de${RESET} ${AZUL}$ip${RESET} ${LAVANDA}completado. Resultado en${RESET} ${AZUL}Ports_$ip${RESET}"
                    mv Ports_$ip PortScan_$ip/
                    puertos=($(grep "Ports:" PortScan_$ip/Ports_$ip | sed -E 's/.*Ports: //' | tr ',' '\n' | cut -d '/' -f1 | tr -d ' '))
                    sleep 2
                    echo -e "${AZUL}[+]${RESET} ${LAVANDA}Escaneando cada puerto de${RESET} ${AZUL}$ip${RESET} ${LAVANDA}en profundidad. Resultados en${RESET} ${AZUL}PortScan_${ip}/${RESET}"

                    for port in "${puertos[@]}"; do
                        nmap -sCV -p$port $ip -oN Port_${ip}_$port &>/dev/null
                        mv Port_${ip}_$port PortScan_$ip/
                    done
                ) &
            done

        # SECUENCIAL
        else 
            for num in $seleccion; do
                ip="${ips_detectadas[$((num-1))]}"
                (
                    mkdir PortScan_$ip &>/dev/null
                    echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Escaneando puertos en${RESET} ${AZUL}$ip${RESET}${LAVANDA}...${RESET}"
                    nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn $ip -oG Ports_$ip
                    echo -e "${AZUL}[+]${RESET} ${LAVANDA}Escaneo de${RESET} ${AZUL}$ip${RESET} ${LAVANDA}completado. Resultado en${RESET} ${AZUL}Ports_$ip${RESET}"
                    mv Ports_$ip PortScan_$ip/
                    puertos=($(grep "Ports:" PortScan_$ip/Ports_$ip | sed -E 's/.*Ports: //' | tr ',' '\n' | cut -d '/' -f1 | tr -d ' '))

                    for port in "${puertos[@]}"; do
                        echo -e "\n\n${AZUL}[+]${RESET} ${LAVANDA}ESCANEANDO PUERTO${RESET} ${AZUL}$port${RESET} ${LAVANDA}...${RESET}"
                        sleep 0.1
                        nmap -sCV -p$port $ip -oN Port_${ip}_$port
                        mv Port_${ip}_$port PortScan_$ip/
                        echo
                        echo
                        echo
                    done
                )
            done
        fi

    # TODOS LOS HOSTS
    else
        echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}¿Seleccione cómo quiere visualizar el escaneo?${RESET}"
        echo -e "  ${LAVANDA}1)${RESET} ${AMARILLO}Escaneo secuencial - salida en tiempo real${RESET}"
        echo -e "  ${LAVANDA}2)${RESET} ${AMARILLO}Escaneo paralelo - Sin salida visible - MÁS RÁPIDO${RESET}"
        read -p "$(echo -e "\n${LAVANDA}Introduzca su elección${RESET} ${AZUL}[1/2]${RESET}${LAVANDA}:${RESET} ")" tiempo
        echo
        echo
        echo -e "\n\n${AZUL}[+]${RESET} ${LAVANDA}ESCANEANDO TODOS LOS HOSTS DETECTADOS...${RESET}\n"

        # PARALELO
        if [[ "$tiempo" == "2" ]]; then
            for ip in "${ips_detectadas[@]}"; do
                (
                    mkdir PortScan_$ip &>/dev/null
                    echo -e "${AZUL}[+]${RESET} ${LAVANDA}Escaneando puertos en${RESET} ${AZUL}$ip${RESET}${LAVANDA}...${RESET}"
                    nmap -p- --open -sS --min-rate 5000 -n -Pn $ip -oG Ports_$ip &>/dev/null
                    echo -e "${AZUL}[+]${RESET} ${LAVANDA}Escaneo de${RESET} ${AZUL}$ip${RESET} ${LAVANDA}completado. Resultado en${RESET} ${AZUL}Ports_$ip${RESET}"
                    mv Ports_$ip PortScan_$ip/
                    puertos=($(grep "Ports:" PortScan_$ip/Ports_$ip | sed -E 's/.*Ports: //' | tr ',' '\n' | cut -d '/' -f1 | tr -d ' '))
                    sleep 2
                    echo -e "${AZUL}[+]${RESET} ${LAVANDA}Escaneando cada puerto de${RESET} ${AZUL}$ip${RESET} ${LAVANDA}en profundidad. Resultados en${RESET} ${AZUL}PortScan_${ip}/${RESET}"

                    for port in "${puertos[@]}"; do
                        nmap -sCV -p$port $ip -oN Port_${ip}_$port &>/dev/null
                        mv Port_${ip}_$port PortScan_$ip/
                    done
                ) &
            done

        # SECUENCIAL
        else
            for ip in "${ips_detectadas[@]}"; do
                (
                    mkdir PortScan_$ip &>/dev/null
                    echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Escaneando puertos en${RESET} ${AZUL}$ip${RESET}${LAVANDA}...${RESET}"
                    nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn $ip -oG Ports_$ip
                    echo -e "${AZUL}[+]${RESET} ${LAVANDA}Escaneo de${RESET} ${AZUL}$ip${RESET} ${LAVANDA}completado. Resultado en${RESET} ${AZUL}Ports_$ip${RESET}"
                    mv Ports_$ip PortScan_$ip/
                    puertos=($(grep "Ports:" PortScan_$ip/Ports_$ip | sed -E 's/.*Ports: //' | tr ',' '\n' | cut -d '/' -f1 | tr -d ' '))

                    for port in "${puertos[@]}"; do
                        echo -e "\n\n${AZUL}[+]${RESET} ${LAVANDA}ESCANEANDO PUERTO${RESET} ${AZUL}$port${RESET} ${LAVANDA}...${RESET}"
                        sleep 0.1
                        nmap -sCV -p$port $ip -oN Port_${ip}_$port 
                        mv Port_${ip}_$port PortScan_$ip/
                        echo
                        echo
                        echo
                    done
                )
            done
        fi
    fi

    wait
    echo -e "\n${AZUL}[+]${RESET} ${VERDE}Todos los escaneos de puertos han finalizado.${RESET}\n"
}
