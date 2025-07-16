#!/bin/bash

# RacoonX - By montaosx


# Colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[1;36m'
LAVANDA='\033[1;35m'
RESET='\033[0m'

source functions/ctrl_c.sh
source functions/mostrar_banner.sh
trap ctrl_c SIGINT

chmod +x modules/network.sh
chmod +x modules/domain_osint.sh
chmod +x modules/personal_osint.sh
chmod +x modules/ssh_BruteForce.sh
chmod +x modules/install_tools.sh

mostrar_banner

echo -e "\n\n${AZUL}[+]${RESET} ${LAVANDA}Seleccione el tipo de actividad que desea realizar${RESET}\n"
echo -e "  ${LAVANDA}1)${RESET} ${AMARILLO}Auditoría a una determinada red${RESET}"
echo -e "  ${LAVANDA}2)${RESET} ${AMARILLO}Reconocimiento mediante Google Dorks a un DOMINIO${RESET}"
echo -e "  ${LAVANDA}3)${RESET} ${AMARILLO}Reconocimiento mediante Google Dorks a una PERSONA${RESET}"
echo -e "  ${LAVANDA}4)${RESET} ${AMARILLO}Ataque por fuerza bruta a un host mediante SSH${RESET}"
read -p "$(echo -e "\n${LAVANDA}Seleccione una opción${LAVANDA}:${RESET} ")" opcion

case $opcion in

1) ./modules/network.sh ;;
2) ./modules/domain_osint.sh ;;
3) ./modules/personal_osint.sh ;;
4) ./modules/ssh_BruteForce.sh ;;
*) echo -e "${ROJO}[!]${RESET} ${ROJO}Opción inválida${RESET}" ;;

esac