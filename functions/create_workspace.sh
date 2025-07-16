# Colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[1;36m'
LAVANDA='\033[1;35m'
RESET='\033[0m'

function create_workspace(){
# CREACIÓN ESPACIO DE TRABAJO
    echo -e "\n\n\n${AZUL}[+]${RESET} ${LAVANDA}Creando directorio de trabajo y moviéndose a él...${RESET}"
    workdir="$HOME/Auditorias/"$(date +"%Y-%m-%d")"_$interfaz"
    mkdir -p "$workdir"
    cd "$workdir"
    echo -e "${AZUL}[+]${RESET} ${LAVANDA}El directorio de trabajo es:${RESET} ${AZUL}$workdir${RESET}"
}