
# Colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[1;36m'
LAVANDA='\033[1;35m'
RESET='\033[0m'

function SoDetect() {
    echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}DETECTANDO EL SISTEMA OPERATIVO DE LOS HOSTS...${RESET}" | tee deteccion_SO.txt

    for ip in "${ips_detectadas[@]}"; do
        (
            ttl=$(ping -c 1 "$ip" 2>/dev/null | grep ttl= | sed -E 's/.*ttl=([0-9]+).*/\1/')

            if [ -z "$ttl" ]; then
                resultado="${AZUL}[$ip]${RESET} ${AZUL}->${RESET} ${ROJO}Sin respuesta o TTL no detectado${RESET}"
            elif [ "$ttl" -le 64 ]; then
                resultado="${AZUL}[$ip]${RESET} ${AZUL}->${RESET} ${VERDE}Posible Linux/Unix${AZUL} (TTL=$ttl)${RESET}"
            elif [ "$ttl" -le 128 ]; then
                resultado="${AZUL}[$ip]${RESET} ${AZUL}->${RESET} ${AMARILLO}Posible Windows${AZUL} (TTL=$ttl)${RESET}"
            elif [ "$ttl" -le 255 ]; then
                resultado="${AZUL}[$ip]${RESET} ${AZUL}->${RESET} ${VERDE}Posible Cisco/Router${AZUL} (TTL=$ttl)${RESET}"
            else
                resultado="${AZUL}[$ip]${RESET} ${AZUL}->${RESET} ${ROJO}TTL desconocido${AZUL} ($ttl)${RESET}"
            fi

            echo -e "$resultado" | tee -a deteccion_SO.txt
        ) &
    done

    wait
    echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Detección de sistemas operativos finalizada. Resultados en${RESET} ${AZUL}deteccion_SO.txt${RESET}\n\n\n"
}
