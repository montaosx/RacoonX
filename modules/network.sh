#!/bin/bash


# RacoonX - By montaosx - Network Audit

source functions/ctrl_c.sh
source functions/procesar_ips.sh
source functions/seleccionInterfaz.sh
source functions/create_workspace.sh
source functions/hostScan.sh
source functions/SoDetect.sh
source functions/portScan.sh


trap ctrl_c SIGINT
let -i numeroInterfaces=$(ifconfig | awk '/^[a-z]/ {iface=$1} /inet / && $2 != "127.0.0.1" {print iface, $2}' | wc -l)


seleccionInterfaz
create_workspace
hostScan
SoDetect
portScan