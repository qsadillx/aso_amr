#!/bin/bash
red='\033[31m'
green='\033[32m'
yellow='\033[33m'
blue='\033[34m'
reset='\033[0m'

if [ "$#" -ne 3 ]; then
    echo -e "${red}Uso: $0 <red> <rango_de_puertos> <archivo_salida>${reset}"
    echo -e "${green}Ejemplo: $0 192.168.1.0/24 1-54 asd.json${reset}"
    exit 1
fi

red=$1
rango_puertos=$2
archivo=$3

inicio=$(date +%s)

echo -e "${blue}Escaneando red $red y guardando los resultados en $archivo...${reset}"

red2=$(echo $red | cut -d '/' -f 1)
mascara=$(echo $red | cut -d '/' -f 2)

echo "[" > "$archivo"

ttlscanner() {
    ttl=$1
    if [[ "$ttl" == "64" ]]; then
        echo -e "${yellow}Linux${reset}"
    elif [[ "$ttl" == "128" ]]; then
        echo -e "${yellow}Windows${reset}"
    else
        echo -e "${red}No es ni Windows ni Linux, tu sabras lo que es${reset}"
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
        for a in {0..255}; do
            for b in {0..255}; do
                for c in {0..255}; do
                    ip="$red2.$a.$b.$c"
                    ttl=$(ping -c 1 -W 1 $ip | grep -oP 'ttl=\K\d+')
                    if [[ $? -eq 0 && -n "$ttl" ]]; then
                        echo -e "${green}[+] Host activo: $ip${reset}"
                        sis=$(ttlscanner $ttl)
                        echo "  {" >> "$archivo"
                        echo "    \"ip\": \"$ip\"," >> "$archivo"
                        echo "    \"sistema\": \"$sis\"," >> "$archivo"
                        echo "    \"puertos\": [" >> "$archivo"
                        for p in $(seq $puerto2 $puerto3); do
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
                        done
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
                    echo "  {" >> "$archivo"
                    echo "    \"ip\": \"$ip\"," >> "$archivo"
                    echo "    \"sistema\": \"$sis\"," >> "$archivo"
                    echo "    \"puertos\": [" >> "$archivo"
                    for p in $(seq $puerto2 $puerto3); do
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
                    done
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
                echo "  {" >> "$archivo"
                echo "    \"ip\": \"$ip\"," >> "$archivo"
                echo "    \"sistema\": \"$sis\"," >> "$archivo"
                echo "    \"puertos\": [" >> "$archivo"
                for p in $(seq $puerto2 $puerto3); do
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
                done
                sed -i '$ s/,$//' "$archivo"
                echo "    ]" >> "$archivo"
                echo "  }," >> "$archivo"
            fi
        done
        ;;
    *)
        echo -e "${red}[-] Esa dirección no es válida...${reset}"
        exit 1
        ;;
esac

sed -i '$ s/,$//' "$archivo"
echo "]" >> "$archivo"
finalizacion=$(date +%s)
duracion=$((finalizacion - inicio))
echo -e "${green}[+] Escaneo completo"
echo -e "${greem} [%] Tiempo transcurrido: $duracion segundos.${reset}"
