#!/bin/bash

# RacoonX - By montaosx - Domain OSINT

# Colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[1;36m'
LAVANDA='\033[1;35m'
RESET='\033[0m'

# Motor de búsqueda
search_engine="https://www.google.com/search?q="

menu() {
    clear
    echo -e "${LAVANDA}===================================${RESET}"
    echo -e "${LAVANDA}     🖥️ BÚSQUEDAS SOBRE DOMINIOS${RESET}"
    echo -e "${LAVANDA}===================================${RESET}"
    echo -e "${LAVANDA}1)${RESET} ${AMARILLO}Documentos públicos expuestos${RESET}"
    echo -e "${LAVANDA}2)${RESET} ${AMARILLO}Vulnerabilidades de listado de directorios${RESET}"
    echo -e "${LAVANDA}3)${RESET} ${AMARILLO}Archivos de configuración expuestos${RESET}"
    echo -e "${LAVANDA}4)${RESET} ${AMARILLO}Archivos de bases de datos expuestos${RESET}"
    echo -e "${LAVANDA}5)${RESET} ${AMARILLO}Archivos de logs expuestos${RESET}"
    echo -e "${LAVANDA}6)${RESET} ${AMARILLO}Archivos de backup o antiguos expuestos${RESET}"
    echo -e "${LAVANDA}7)${RESET} ${AMARILLO}Páginas de login${RESET}"
    echo -e "${LAVANDA}8)${RESET} ${AMARILLO}Errores SQL${RESET}"
    echo -e "${LAVANDA}9)${RESET} ${AMARILLO}Errores o advertencias PHP${RESET}"
    echo -e "${LAVANDA}10)${RESET} ${AMARILLO}Páginas con phpinfo()${RESET}"
    echo -e "${LAVANDA}11)${RESET} ${AMARILLO}Buscar en pastebin.com y sitios de pegado${RESET}"
    echo -e "${LAVANDA}12)${RESET} ${AMARILLO}Buscar en github.com y gitlab.com${RESET}"
    echo -e "${LAVANDA}13)${RESET} ${AMARILLO}Buscar en stackoverflow.com${RESET}"
    echo -e "${LAVANDA}14)${RESET} ${AMARILLO}Páginas de registro (signup)${RESET}"
    echo -e "${LAVANDA}15)${RESET} ${AMARILLO}Buscar subdominios${RESET}"
    echo -e "${LAVANDA}16)${RESET} ${AMARILLO}Buscar sub-subdominios${RESET}"
    echo -e "${LAVANDA}17)${RESET} ${AMARILLO}Buscar en la Wayback Machine${RESET}"
    echo -e "${LAVANDA}18)${RESET} ${AMARILLO}Mostrar solo direcciones IP${RESET}"
    echo
}

while true; do
    menu

    read -p "$(echo -e "\n${LAVANDA}Introduce opciones separadas por espacios:${RESET} ")" opciones

    read -p "Dominio: " dominio

    for opcion in $opciones; do
        case $opcion in
            1) query="site:$dominio ext:doc | ext:docx | ext:odt | ext:rtf | ext:ppt | ext:pptx | ext:csv";;
            2) query="site:$dominio intitle:index.of";;
            3) query="site:$dominio ext:xml | ext:conf | ext:cfg | ext:ini";;
            4) query="site:$dominio ext:sql | ext:dbf | ext:mdb";;
            5) query="site:$dominio ext:log";;
            6) query="site:$dominio ext:bak | ext:old | ext:backup";;
            7) query="site:$dominio inurl:login | inurl:signin | intitle:Login | intitle:\"sign in\" | inurl:auth";;
            8) query="site:$dominio intext:\"sql syntax near\" | intext:\"Warning: mysql_connect()\"";;
            9) query="site:$dominio \"PHP Parse error\" | \"PHP Warning\"";;
            10) query="site:$dominio ext:php intitle:phpinfo";;
            11) query="site:pastebin.com | site:paste2.org | site:justpaste.it \"$dominio\"";;
            12) query="site:github.com | site:gitlab.com \"$dominio\"";;
            13) query="site:stackoverflow.com \"$dominio\"";;
            14) query="site:$dominio inurl:signup | inurl:register";;
            15) query="site:*.$dominio";;
            16) query="site:*.*.$dominio";;
            17) xdg-open "https://web.archive.org/web/*/$dominio/*" & continue;;
            18) query="site:*.*.$dominio (29.* | 28.* | 27.* | 26.*)";;
            *) echo -e "${ROJO}Opción inválida: $opcion${RESET}"; continue;;
        esac

        if [[ ! -z "$query" ]]; then
            query_encoded=$(echo "$query" | sed 's/ /+/g')
            xdg-open "${search_engine}${query_encoded}" &
        fi
    done

    read -p "$(echo -e \"\n${LAVANDA}¿Quieres realizar otra búsqueda?${RESET} ${AZUL}[S/n]${RESET}: \")" respuesta
    [[ "$respuesta" =~ ^([nN][oO]?|NO?|no)$ ]] && break
done
