#!/bin/bash

# Definir códigos de color
GREEN='\e[32m'
GREEN_BOLD='\e[1;32m'
BLUE='\033[0;34m'
BLUE_BOLD='\e[1;34m'
YELLOW='\e[33m'
YELLOW_BOLD='\e[1;33m'
RED='\e[31m'
RED_BOLD='\e[1;31m'
RESET='\033[0m'

# Directorio de búsqueda raíz
busqueda='/'

# Directorios fijos
fixed_dirs='tmp,opt,home'

# Comprobar si se han pasado parámetros
if [ $# -gt 0 ]; then
    # Leer parámetros y convertirlos en una lista separada por comas
    param_dirs=$1
    dirs_list="$fixed_dirs,$param_dirs"
else
    # Si no se pasan parámetros, usar solo los directorios fijos
    dirs_list="$fixed_dirs"
fi

# Convertir la lista de directorios en una lista de opciones para find
find_opts=$(echo "$dirs_list" | sed 's/,/ -o -name /g' | sed 's/^/-name /')

# Mostrar banner
echo -e "${BLUE_BOLD}                                             ${RESET}"
echo -e "${BLUE_BOLD}+===========================================+${RESET}"
echo -e "${BLUE_BOLD}|            _ _      _     _     _         |${RESET}"
echo -e "${BLUE_BOLD}|         __| (_)_ __| |   (_)___| |_       |${RESET}"
echo -e "${BLUE_BOLD}|        / _' | | '__| |   | / __| __|      |${RESET}"
echo -e "${BLUE_BOLD}|       | (_| | | |  | |___| \__ \ |_       |${RESET}"
echo -e "${BLUE_BOLD}|        \__,_|_|_|  |_____|_|___/\__|      |${RESET}"
echo -e "${BLUE_BOLD}|                                           |${RESET}"
echo -e "${BLUE_BOLD}|                           ${YELLOW}@by K0nki\$hell${YELLOW}  ${BLUE_BOLD}|${RESET}"
echo -e "${BLUE_BOLD}+===========================================+${RESET}"
echo -e "${BLUE_BOLD}                                             ${RESET}"

# Buscar directorios y archivos, incluyendo ocultos
find "$busqueda" -type d \( $find_opts \) 2>/dev/null | while read -r dir; do
    if [ -d "$dir" ]; then
        echo -e "${BLUE_BOLD}Estructura de directorio para ${RESET}${dir}:${RESET}"

        # Usar `find` para listar todos los archivos y directorios, incluyendo ocultos, dentro del directorio actual
        find "$dir" -type f -o -type d 2>&1 | while read -r file; do
            # Excluir las líneas que contienen `.` y `..`
            if [[ "$file" != *"/." && "$file" != *"/.."* ]]; then
                # Extraer solo el nombre del archivo o directorio
                base_dir=$(dirname "$file")
                base_name=$(basename "$file")

                # Verificar si hay un mensaje de error de "Permiso denegado"
                if [[ "$file" == *"Permission denied"* ]]; then
                    message="${base_dir}/${RED_BOLD}${base_name}${RESET}"
                    clean_message=$(echo "$message" | sed "s/^find: ‘//" | sed "s/’//")

                    # Mostrar el mensaje limpio
                    echo -e "${clean_message}"
                else

                    # Si es un archivo, mostrar el nombre en amarillo
                    if [[ -f "$file" ]]; then
                        echo -e "${base_dir}/${YELLOW}${base_name}${RESET}"
                    # Si es un directorio distinto al de búsqueda, mostrar el nombre en verde
                    #elif [[ -d "$file" && "$file" != "$dir" ]]; then
                    #   echo -e "${base_dir}/${GREEN}${base_name}${RESET}"
                    fi
                fi

            fi # Cierra el if de exclusión de "." y ".."
        done

        echo
    else
        echo -e "${RED_BOLD}Permiso denegado o el directorio ${dir} no existe.${RESET}"
    fi
done

