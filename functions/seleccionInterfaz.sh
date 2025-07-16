# Colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[1;36m'
LAVANDA='\033[1;35m'
RESET='\033[0m'

function seleccionInterfaz(){
    if [ $numeroInterfaces -eq 0 ]; then
        echo -e "\n${ROJO}[!]${RESET} ${ROJO}No tienes ninguna interfaz activa, regresa cuando la tengas. Saliendo...${RESET}\n"
        exit 1
    elif [ $numeroInterfaces -eq 1 ]; then
        interfaz=$(ifconfig | awk '/^[a-z]/ {iface=$1} /inet / && $2 != "127.0.0.1" {print iface}' | sed s/://)
        ip=$(ifconfig | awk '/inet / && $2 != "127.0.0.1" {print $2}')
        echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}La auditoría se realizará en la interfaz${RESET} ${AZUL}$interfaz${RESET} ${LAVANDA}con IP${RESET} ${AZUL}$ip${RESET} \n"
    else
        mapfile -t interfaces < <(ifconfig | awk '/^[a-z]/ {iface=$1; gsub(":", "", iface)} /inet / && $2 != "127.0.0.1" {print iface, $2}')
        echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Seleccione la interfaz por la que se realizará la auditoría${LAVANDA}:${RESET}\n"
        let -i num=1
        for element in "${interfaces[@]}"; do
            echo -e "  ${LAVANDA}$num)${RESET} ${AMARILLO}$element${RESET}"
            ((num++))
        done

        read -p "$(echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Introduzca el número de la opción deseada${LAVANDA}:${RESET} ")" seleccion

        if [ -z "${interfaces[$((seleccion - 1))]}" ]; then
            while [ -z "${interfaces[$((seleccion - 1))]}" ]; do
                echo -e "\n${ROJO}[!]${RESET} ${ROJO}Opción inválida, seleccione una interfaz válida. [ej: 1, 2, 3...]${RESET}\n"
                read -p "$(echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Introduzca el número de la opción deseada${LAVANDA}:${RESET} ")" seleccion
            done

            interfaz=$(echo "${interfaces[$((seleccion - 1))]}" | awk '{print $1}')
            ip=$(echo "${interfaces[$((seleccion - 1))]}" | awk '{print $2}')
            echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}La auditoría se realizará en la interfaz${RESET} ${AZUL}$interfaz${RESET} ${LAVANDA}con IP${RESET} ${AZUL}$ip${RESET} \n"
        else
            interfaz=$(echo "${interfaces[$((seleccion - 1))]}" | awk '{print $1}')
            ip=$(echo "${interfaces[$((seleccion - 1))]}" | awk '{print $2}')
            echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}La auditoría se realizará en la interfaz${RESET} ${AZUL}$interfaz${RESET} ${LAVANDA}con IP${RESET} ${AZUL}$ip${RESET} \n"
        fi
    fi
}
