#!/bin/bash
red3='\033[31m'
green='\033[32m'
yellow='\033[33m'
blue='\033[34m'
reset='\033[0m'

echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠁⠸⢳⡄⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠃⠀⠀⢸⠸⠀⡠⣄⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠃⠀⠀⢠⣞⣀⡿⠀⠀⣧⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡖⠁⠀⠀⠀⢸⠈⢈⡇⠀⢀⡏⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠩⢠⡴⠀⠀⠀⠀⠀⠈⡶⠉⠀⠀⡸⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⢀⠎⢠⣇⠏⠀⠀⠀⠀⠀⠀⠀⠁⠀⢀⠄⡇⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⢠⠏⠀⢸⣿⣴⠀⠀⠀⠀⠀⠀⣆⣀⢾⢟⠴⡇⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⢀⣿⠀⠠⣄⠸⢹⣦⠀⠀⡄⠀⠀⢋⡟⠀⠀⠁⣇⠀⠀⠀⠀⠀ Trabajando duro"
echo "⠀⠀⠀⠀⢀⡾⠁⢠⠀⣿⠃⠘⢹⣦⢠⣼⠀⠀⠉⠀⠀⠀⠀⢸⡀⠀⠀⠀⠀"
echo "⠀⠀⢀⣴⠫⠤⣶⣿⢀⡏⠀⠀⠘⢸⡟⠋⠀⠀⠀⠀⠀⠀⠀⠀⢳⠀⠀⠀⠀"
echo "⠐⠿⢿⣿⣤⣴⣿⣣⢾⡄⠀⠀⠀⠀⠳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀"
echo "⠀⠀⠀⣨⣟⡍⠉⠚⠹⣇⡄⠀⠀⠀⠀⠀⠀⠀⠀⠈⢦⠀⠀⢀⡀⣾⡇⠀⠀"
echo "⠀⠀⢠⠟⣹⣧⠃⠀⠀⢿⢻⡀⢄⠀⠀⠀⠀⠐⣦⡀⣸⣆⠀⣾⣧⣯⢻⠀⠀"
echo "⠀⠀⠘⣰⣿⣿⡄⡆⠀⠀⠀⠳⣼⢦⡘⣄⠀⠀⡟⡷⠃⠘⢶⣿⡎⠻⣆⠀⠀"
echo "⠀⠀⠀⡇⡿⢿⡿⠀⠀⠀⠀⠀⠙⠀⠻⢯⢷⣼⠁⠁⠀⠀⠀⠙⢿⡄⡈⢆⠀"
echo "⠀⠀⠀⠀⡇⣿⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠦⠀⠀⠀⠀⠀⠀⡇⢹⢿⡀"
echo "⠀⠀⠀⠀⠁⠛⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠼⠇⠁"

if [ "$#" -ne 3 ]; then
    echo -e "${red}Uso: $0 <red> <rango_de_puertos> <archivo_salida>${reset}"
    echo -e "${green}Ejemplo: $0 192.168.1.0/24 1-54 asd${reset}"
    exit 1
fi

red=$1
rango_puertos=$2
archivo="$3.json"

# Iniciamos date +%s para calcular los segundos que tardará nuestro script, mas adelante la restaremos a otro date que generemos al finalizar el script.
inicio=$(date +%s)

echo -e "${blue}Escaneando red $red y guardando los resultados en $archivo...${reset}"

red2=$(echo $red | cut -d '/' -f 1)
mascara=$(echo $red | cut -d '/' -f 2)

# Aqui abrimos nuestro json y lo enviamos al archivo que especifiquemos
echo "[" > "$archivo"

# Esta funcion disminuye la redundancia, por lo que podremos usarla dentro de nuestro case y ahorrarnos 10 lineas de codigo
ttlscanner() {
    ttl=$1
    # Aqui realizaremos una comprobacion, si el ttl es de 64
    if [[ "$ttl" == "64" ]]; then
        echo -e "${yellow}Linux${reset}"
    # Ahora haremos lo mismo pero con el ttl 128 asignandolo a windows
    elif [[ "$ttl" == "128" ]]; then
        echo -e "${yellow}Windows${reset}"
    else
        # Si no es ni 64 ni 128 devuelve que no sabra lo que és.
        echo -e "${red3}No es ni Windows ni Linux, tu sabras lo que es${reset}"
    fi
}

IFS='-' read -r puerto2 puerto3 <<< "$rango_puertos"

if [ -z "$puerto3" ]; then
    puerto3=$puerto2
fi

case $mascara in
    8)
        red2=$(echo $red2 | cut -d '.' -f 1)
        echo -e "${blue}[-] Escaneando red $red2.0.0.0/8...${reset}"
        # Realizamos 3 bucles for para calcular los 3 octetos
        for a in {0..255}; do
            for b in {0..255}; do
                for c in {0..255}; do
                    ip="$red2.$a.$b.$c"
                    ttl=$(ping -c 1 -W 1 $ip | grep -oP 'ttl=\K\d+')
                    if [[ $? -eq 0 && -n "$ttl" ]]; then
                        echo -e "${green}[+] Host activo: $ip${reset}"
                        # Llamamos sis a nuestra nueva variable, en la cual almacenaremos la variable $ttl de nuestra funcion ttlscanner()
                        sis=$(ttlscanner $ttl)
                        ip_local=$(hostname -I | awk '{print $1}')
                        if [ "$ip" == "$ip_local" ]; then
                            mimac=$(ip a | grep 'link/ether' | awk '{print $2}')
                            mac=$mimac
                        else
                            mac=$(arp -n $ip | sed 's/HWaddress //g' | grep -v 'Flags' | awk '/^[^ ]/{print $3}')
                        fi
                        echo "  {" >> "$archivo"
                        echo "    \"ip\": \"$ip\"," >> "$archivo"
                        echo "    \"sistema\": \"$sis\"," >> "$archivo"
                        echo "    \"mac\": \"$mac\"," >> "$archivo"
                        echo "    \"puertos\": [" >> "$archivo"
                        # Ahora iniciamos un for para detectar los puertos dentro de la red
                        for p in $(seq $puerto2 $puerto3); do {
                            # Usaremos los parametros, -z, -v y -w (-z para que solo escanee puertos sin escanearlos) (-v Para habilitar el modo verbose y nos muestre informacion adicional) y -w 1 para que haga un wait de 1 segundo antes de pasar al siguiente. Los errores serán redirigidos al dev/null
                            nc -zv -w 1 $ip $p > /dev/null 2>&1
                            # Con $? retornaremos el ultimo comando usado, por lo tanto si nos da igual a 0 será que funciona
                            if [ $? -eq 0 ]; then
                                # Mediante la variable "servicio" haremos un grep, acompañado del parametro -w para que se busque la palabra completa, usaremos $p que representa a un puerto y lo buscaremos dentro del archivo "tcp.csv"
                                servicio=$(grep -w ",$p," tcp.csv | cut -d ',' -f 3 | tr -d '"')
                                if [ -z "$servicio" ]; then
                                    servicio="Desconocido"
                                fi
                                # Aqui almacenaremos el contenido dentro de nuestro json una vez terminado el script
                                echo "      {" >> "$archivo"
                                echo "        \"puerto\": $p," >> "$archivo"
                                echo "        \"servicio\": \"$servicio\"" >> "$archivo"
                                echo "      }," >> "$archivo"
                            fi
                        # Como la version original del script tardaba aproximadamente 600 segundos en finalizar le he añadido varios hilos metiendo entre corchetes todo nuestro codigo y añadiendo un &, de esta manera tardará un poco menos.
                        } & done
                        sed -i '$ s/,$//' "$archivo"
                        echo "    ]" >> "$archivo"
                        echo "  }," >> "$archivo"
                    fi
                done
            done
        done
        ;;

    16)
        red2=$(echo $red2 | cut -d '.' -f 1,2)
        echo -e "${blue}[-] Escaneando red $red2.0.0/16...${reset}"
        for b in {0..255}; do
            for c in {0..255}; do
                ip="$red2.$b.$c"
                ttl=$(ping -c 1 -W 1 $ip | grep -oP 'ttl=\K\d+')
                if [[ $? -eq 0 && -n "$ttl" ]]; then
                    echo -e "${green}[+] Host activo: $ip${reset}"
                    sis=$(ttlscanner $ttl)
                    ip_local=$(hostname -I | awk '{print $1}')
                    if [ "$ip" == "$ip_local" ]; then
                        mimac=$(ip a | grep 'link/ether' | awk '{print $2}')
                        mac=$mimac
                    else
                        mac=$(arp -n $ip | sed 's/HWaddress //g' | grep -v 'Flags' | awk '/^[^ ]/{print $3}')
                    fi
                    echo "  {" >> "$archivo"
                    echo "    \"ip\": \"$ip\"," >> "$archivo"
                    echo "    \"sistema\": \"$sis\"," >> "$archivo"
                    echo "    \"mac\": \"$mac\"," >> "$archivo"
                    echo "    \"puertos\": [" >> "$archivo"
                    for p in $(seq $puerto2 $puerto3); do {
                        nc -zv -w 1 $ip $p > /dev/null 2>&1
                        if [ $? -eq 0 ]; then
                            servicio=$(grep -w ",$p," tcp.csv | cut -d ',' -f 3 | tr -d '"')
                            if [ -z "$servicio" ]; then
                                servicio="Desconocido"
                            fi
                            echo "      {" >> "$archivo"
                            echo "        \"puerto\": $p," >> "$archivo"
                            echo "        \"servicio\": \"$servicio\"" >> "$archivo"
                            echo "      }," >> "$archivo"
                        fi
                    } & done
                    sed -i '$ s/,$//' "$archivo"
                    echo "    ]" >> "$archivo"
                    echo "  }," >> "$archivo"
                fi
            done
        done
        ;;

    24)
        red2=$(echo $red2 | cut -d '.' -f 1,2,3)
        echo -e "${blue}[-] Escaneando red $red2.0/24...${reset}"
        for c in {0..255}; do
            ip="$red2.$c"
            ttl=$(ping -c 1 -W 1 $ip | grep -oP 'ttl=\K\d+')
            if [[ $? -eq 0 && -n "$ttl" ]]; then
                echo -e "${green}[+] Host activo: $ip${reset}"
                sis=$(ttlscanner $ttl)
                ip_local=$(hostname -I | awk '{print $1}')
                if [ "$ip" == "$ip_local" ]; then
                    mimac=$(ip a | grep 'link/ether' | awk '{print $2}')
                    mac=$mimac
                else
                    mac=$(arp -n $ip | sed 's/HWaddress //g' | grep -v 'Flags' | awk '/^[^ ]/{print $3}')
                fi
                echo "  {" >> "$archivo"
                echo "    \"ip\": \"$ip\"," >> "$archivo"
                echo "    \"sistema\": \"$sis\"," >> "$archivo"
                echo "    \"mac\": \"$mac\"," >> "$archivo"
                echo "    \"puertos\": [" >> "$archivo"

                for p in $(seq $puerto2 $puerto3); do {
                    nc -zv -w 1 $ip $p > /dev/null 2>&1
                    if [ $? -eq 0 ]; then
                        servicio=$(grep -w ",$p," tcp.csv | cut -d ',' -f 3 | tr -d '"')
                        if [ -z "$servicio" ]; then
                            servicio="Desconocido"
                        fi
                        echo "      {" >> "$archivo"
                        echo "        \"puerto\": $p," >> "$archivo"
                        echo "        \"servicio\": \"$servicio\"" >> "$archivo"
                        echo "      }," >> "$archivo"
                    fi
                } & done
                sed -i '$ s/,$//' "$archivo"
                echo "    ]" >> "$archivo"
                echo "  }," >> "$archivo"
            fi
        done
        ;;
    *)
        echo -e "${red3}[-] Esa dirección no es válida...${reset}"
        exit 1
        ;;
esac

# Ahora usaremos "sed" para modificar el contenido de un archivo
# Usando -i le indicamos que se debe modificar el archivo original, el signo de $ se refiere a la ultima linea del archivo
sed -i '$ s/,$//' "$archivo"
# Aqui cerraremos nuestro json
echo "]" >> "$archivo"

# ¿Te acuerdas de la variable arriba del script la cual nos iniciaba un date +%s para calcular los segundos que tarde?
# Pues con este nuevo date solo tendremos que restarlas.
finalizacion=$(date +%s)
duracion=$((finalizacion - inicio))

echo -e "${green}[+] Escaneo completo"
echo -e "${green}[%] Tiempo transcurrido: $duracion segundos.${reset}"
