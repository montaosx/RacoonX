#!/bin/bash

# RacoonX - By montaosx - Personal OSINT

# Colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[1;36m'
LAVANDA='\033[1;35m'
RESET='\033[0m'

search_engine="https://www.google.com/search?q="

menu() {
    # Banners de menú
    clear
    echo -e "${LAVANDA}===================================${RESET}"
    echo -e "${LAVANDA}     🧑 BÚSQUEDAS SOBRE PERSONAS${RESET}"
    echo -e "${LAVANDA}===================================${RESET}"
    echo -e "${LAVANDA} 1)${RESET} ${AMARILLO}Buscar redes sociales por nombre o usuario${RESET}"
    echo -e "${LAVANDA} 2)${RESET} ${AMARILLO}Buscar documentos donde aparece una persona${RESET}"
    echo -e "${LAVANDA} 3)${RESET} ${AMARILLO}Buscar DNIs filtrados${RESET}"
    echo -e "${LAVANDA} 4)${RESET} ${AMARILLO}Buscar bases de datos filtradas (por email)${RESET}"
    echo -e "${LAVANDA} 5)${RESET} ${AMARILLO}Buscar documentos de backup que contengan nombre${RESET}"
    echo -e "${LAVANDA} 6)${RESET} ${AMARILLO}Buscar información en pastebins${RESET}"
    echo -e "${LAVANDA} 7)${RESET} ${AMARILLO}Buscar archivos en directorios abiertos${RESET}"
    echo -e "${LAVANDA} 8)${RESET} ${AMARILLO}Buscar archivos en la nube pública${RESET}"
    echo -e "${LAVANDA} 9)${RESET} ${AMARILLO}Buscar en redes sociales antiguas${RESET}"
    echo -e "${LAVANDA}10)${RESET} ${AMARILLO}Buscar en proyectos de GitHub/GitLab${RESET}"
    echo -e "${LAVANDA}11)${RESET} ${AMARILLO}Buscar contraseñas filtradas${RESET}"
    echo -e "${LAVANDA}12)${RESET} ${AMARILLO}Buscar teléfonos asociados${RESET}"
    echo -e "${LAVANDA}13)${RESET} ${AMARILLO}Buscar en documentos oficiales (.gov, BOE, universidades)${RESET}"
    echo -e "${LAVANDA}14)${RESET} ${AMARILLO}Buscar emails filtrados${RESET}"
    echo -e "${LAVANDA}15)${RESET} ${AMARILLO}Buscar combinaciones usuario/contraseña${RESET}"
    echo -e "${LAVANDA}16)${RESET} ${AMARILLO}Buscar trabajos académicos${RESET}"
    echo -e "${LAVANDA}17)${RESET} ${AMARILLO}Buscar cámaras web públicas${RESET}"
    echo -e "${LAVANDA}18)${RESET} ${AMARILLO}Buscar directorios /admin, /private, etc.${RESET}"
    echo -e "${LAVANDA}19)${RESET} ${AMARILLO}Buscar listas de empleados${RESET}"
    echo -e "${LAVANDA}20)${RESET} ${AMARILLO}Buscar direcciones postales${RESET}"
    echo -e "${LAVANDA}21)${RESET} ${AMARILLO}Buscar actividad en foros técnicos${RESET}"
    echo -e "${LAVANDA}22)${RESET} ${AMARILLO}Buscar API keys, tokens y client secrets${RESET}"
    echo -e "${LAVANDA}23)${RESET} ${AMARILLO}Buscar perfiles archivados en Wayback Machine${RESET}"
    echo -e "${LAVANDA}24)${RESET} ${AMARILLO}Buscar documentos de RRHH filtrados${RESET}"
    echo -e "${LAVANDA}25)${RESET} ${AMARILLO}Buscar datos de contacto${RESET}"
    echo -e "${LAVANDA}26)${RESET} ${AMARILLO}Buscar backups de correos electrónicos${RESET}"
    echo -e "${LAVANDA}27)${RESET} ${AMARILLO}Buscar filtraciones de credenciales${RESET}"
    echo -e "${LAVANDA}28)${RESET} ${AMARILLO}Buscar pasaportes, DNIs o licencias${RESET}"
    echo -e "${LAVANDA}29)${RESET} ${AMARILLO}Buscar participaciones públicas${RESET}"
    echo -e "${LAVANDA}30)${RESET} ${AMARILLO}Buscar documentos personales en Drive${RESET}"
    echo -e "${LAVANDA}31)${RESET} ${AMARILLO}Buscar documentos oficiales${RESET}"
    echo -e "${LAVANDA}32)${RESET} ${AMARILLO}Buscar chats filtrados${RESET}"
    echo -e "${LAVANDA}33)${RESET} ${AMARILLO}Buscar publicaciones antiguas fuera de redes actuales${RESET}"
    echo
}

while true; do
    menu

    read -p "$(echo -e "\n${LAVANDA}Introduce opciones separadas por espacios:${RESET} ")" opciones

    for opcion in $opciones; do
        case $opcion in
            1) read -p "Nombre o usuario: " persona; query="\"$persona\" site:facebook.com | site:twitter.com | site:linkedin.com";;
            2) read -p "Nombre completo: " persona; query="\"$persona\" filetype:pdf | filetype:docx";;
            3) read -p "Nombre completo: " persona; query="\"$persona\" \"DNI\" filetype:pdf | filetype:docx";;
            4) read -p "Correo: " correo; query="intext:\"$correo\" filetype:sql | filetype:csv | filetype:txt";;
            5) read -p "Nombre: " persona; query="intext:\"$persona\" ext:bak | ext:old | ext:backup";;
            6) read -p "Nombre: " persona; query="\"$persona\" site:pastebin.com | site:justpaste.it";;
            7) read -p "Nombre: " persona; query="intitle:\"index of\" \"$persona\" (pdf | docx | txt | csv)";;
            8) read -p "Nombre: " persona; query="\"$persona\" site:drive.google.com | site:dropbox.com | site:onedrive.live.com | site:mega.nz";;
            9) read -p "Nombre: " persona; query="\"$persona\" site:myspace.com | site:livejournal.com | site:hi5.com | site:orkut.com";;
            10) read -p "Nombre: " persona; query="\"$persona\" site:github.com | site:gitlab.com";;
            11) read -p "Nombre: " persona; query="intext:password \"$persona\" filetype:txt | filetype:log";;
            12) read -p "Nombre: " persona; query="\"$persona\" \"teléfono\" | \"móvil\" site:.es";;
            13) read -p "Nombre: " persona; query="\"$persona\" (site:.gov | site:.edu | site:boe.es | site:audienciasnacionales.es)";;
            14) read -p "Correo: " correo; query="intext:\"$correo\" (filetype:html | filetype:txt | filetype:log)";;
            15) read -p "Nombre de usuario: " usuario; query="\"$usuario\" intext:password filetype:txt | filetype:csv";;
            16) read -p "Nombre: " persona; query="\"$persona\" (site:.edu | site:academia.edu | site:researchgate.net) (filetype:pdf | filetype:docx)";;
            17) query="inurl:view/index.shtml OR intitle:\"webcamXP 5\" inurl:8080";;
            18) query="intext:\"Index of /admin\" | intext:\"Index of /private\" | intext:\"restricted access\"";;
            19) read -p "Nombre: " persona; query="\"$persona\" filetype:xls | filetype:csv site:.gov | site:.org | site:.edu";;
            20) read -p "Nombre: " persona; query="\"$persona\" \"calle\" | \"avenida\" | \"plaza\" site:.es";;
            21) read -p "Nombre: " persona; query="\"$persona\" site:support.microsoft.com | site:community.spiceworks.com | site:stackexchange.com";;
            22) read -p "Nombre: " persona; query="\"$persona\" intext:apikey | intext:token | intext:client_secret";;
            23) read -p "Nombre de usuario: " usuario; query="\"$usuario\" site:archive.org";;
            24) read -p "Nombre: " persona; query="inurl:/hr/ \"$persona\" (filetype:pdf | filetype:xls | filetype:csv)";;
            25) read -p "Nombre: " persona; query="\"$persona\" (filetype:xls | filetype:csv | filetype:txt) intext:phone | intext:email";;
            26) read -p "Nombre: " persona; query="filetype:mbox | filetype:eml | filetype:pst \"$persona\"";;
            27) read -p "Nombre: " persona; query="intext:\"$persona\" (intext:username | intext:password | intext:credentials) (filetype:txt | filetype:log)";;
            28) read -p "Nombre: " persona; query="\"$persona\" (intext:passport | intext:dni | intext:license) (filetype:pdf | filetype:jpg | filetype:png)";;
            29) read -p "Nombre: " persona; query="\"$persona\" intext:participants | intext:winners | intext:attendees";;
            30) read -p "Nombre: " persona; query="site:drive.google.com \"$persona\"";;
            31) read -p "Nombre: " persona; query="\"$persona\" site:.gob.es | site:.gov | site:.edu filetype:pdf";;
            32) read -p "Nombre: " persona; query="\"$persona\" (filetype:txt | filetype:json) intext:chat";;
            33) read -p "Nombre: " persona; query="\"$persona\" -site:facebook.com -site:twitter.com";;

            *) echo "Opción inválida."; exit 1;;
        esac

        if [[ ! -z "$query" ]]; then
            query_encoded=$(echo "$query" | sed 's/ /+/g')
            xdg-open "${search_engine}${query_encoded}" &
        fi
    done

    read -p "$(echo -e \"\n${LAVANDA}¿Quieres realizar otra búsqueda?${RESET} ${AZUL}[S/n]${RESET}: \")" respuesta
    [[ "$respuesta" =~ ^([nN][oO]?|NO?|no)$ ]] && break
done
