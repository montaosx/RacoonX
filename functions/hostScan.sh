
# Colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[1;36m'
LAVANDA='\033[1;35m'
RESET='\033[0m'


function hostScan(){
    
    ip neigh flush all 


    #echo -e "\n\n\n${AZUL}[+]${RESET} ${LAVANDA}Ejecutando escaneo de Hosts en${RESET} ${AZUL}$interfaz${RESET}${LAVANDA}...${RESET}"

    
# ESCANEO HOSTS EN INTERFAZ SELECCIONADA
    echo -e "\n\n\n${AZUL}[+]${RESET} ${LAVANDA}ESCANEANDO HOSTS...${RESET}"
    resultadoHostScan=$(arp-scan -I $interfaz --localnet --ignoredups)
    echo "$resultadoHostScan" > hostScan
    #echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Podrá encontrar el resultado  del escaneo en el archivo ${AZUL}hostScan${RESET}${LAVANDA}, dentro del${RESET}${AZUL} directorio de trabajo${RESET}"
    procesar_ips "$resultadoHostScan"


