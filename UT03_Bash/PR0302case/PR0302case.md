# PR0302: Comando `case`


Realiza las siguientes tareas:

## Ejercicio 1: Menú de operaciones matemáticas

Crea un script que muestre un menú con opciones para sumar, restar, multiplicar y dividir dos números. Debe pedir primero un operando, luego el otro y finalmente la operación a realizar. Usa `case` para realizar la operación seleccionada por el usuario.
solicitar nombre de un grupo yh mostrar por pantalla el listado de todos los usuarios que pertenecen a dicho grupo
```bash
#!/bin/bash

echo  "Que operacion quieres hacer: "
echo "1) Suma"
echo "2) Resta"
echo "3) Multiplicación"
echo "4) División"

read -p "Elige una opción del 1 al 4: " respuesta

if [ -n $respuesta ];
then
        read -p "Introduce el primer numero: " numero1
        read -p "Introduce el segundo numero: " numero2
                case $respuesta in
                        1)
                                suma=$((numero1 + numero2))
                                echo "La suma de $numero1 y $numero2 es: $suma";;
                        2)
                                resta=$((numero1 - numero2))
                                echo "La resta de $numero1 y $numero2 es: $resta";;
                        3)
                                multi=$((numero1 * numero2))
                                echo "La multiplicación de $numero1 y $numero2 es: $multi";;
                        4)
                                division=$((numero1 / numero2))
                                echo "La división de $numero1 y $numero2 es: $division";;
                esac
else
        echo "Escribe algo";
fi

```


## Ejercicio 2: Verificar días de la semana

```bash
#!/bin/bash

read -p "Introduce un día de la semana: " dia
dia=$(echo "$dia")

case $dia in
    lunes|martes|miercoles|jueves|viernes)
        echo "$dia es  laboral."
        ;;
    sabado|domingo)
        echo "$dia es fin de semana."
        ;;
    *)
        echo "Por favor, introduce un día válido de la semana."
        ;;
esac
```

## Ejercicio 3: Clasificar calificaciones

Crea un script que reciba una calificación numérica del 0 al 10 e indique la nota correspondiente: sobresaliente (9 o 10), notable (7 u 8), bien (6), suficiente (5) o suspenso (0 a 4).

```bash
#!/bin/bash

read -p "Introduce un numero del 1 al 10: " numero
numero=$(echo "$numero")

case $numero in
        0|1|2|3|4)
                echo "$numero es un suspenso";;
        5)
                echo "$numero es un suficiente";;
        6)
                echo "$numero es un bien";;
        7|8)
                echo "$numero es un notable";;

        9|10)
                echo "$numero es un sobresaliente";;
        *)
                echo "El numero $numero no esta entre 0 y 10";
esac
```

## Ejercicio 4: Determinar la estación del año

El usuario ingresa un mes del año, y el script responde con la estación correspondiente (primavera, verano, otoño o invierno). 

**Opcionalmente** puedes intentar mejorar el script preguntando también el día del mes para responder con más precisión.

```bash
#!/bin/bash

read -p "Ingresa un mes del año: " mes
mes=$(echo "$mes")

case $mes in 
        enero|febrero|marzo)
                echo "Invierno"
                ;;
        abril|mayo)
                echo "Primavera"
                ;;
        junio|julio|agosto)
                echo "Verano"
                ;;
        septiembre|octubre|noviembre|diciembre)
                echo "Otoño"
                ;;
esac
```

## Ejercicio 5: Identificar el tipo de archivo

Pide al usuario que ingrese la extensión de un archivo (.txt, .jpg, .pdf, etc.), y usa `case` para mostrar el tipo de archivo (texto, imagen, documento, etc.).

```bash
#!/bin/bash

read -p "Escribe el tipo de extensión que quieres mostrar en pantalla: " extension
extension=$(echo "$extension")

case $extension in
                .txt)
                        echo "La extensión elegida ha sido txt"
                        ;;
                .png)
                        echo "La extensión elegida ha sido png"
                        ;;
                .jpg)
                        echo "La extensión elegida ha sido jpg"
                        ;;
                .pdf)
                        echo "La extensión elegida ha sido pdf"
                        ;;
esac

```

## Ejercicio 6: Convertir temperaturas

Haz un script que convierta una temperatura ingresada por el usuario de Celsius a Fahrenheit, de Fahrenheit a Celsius o de Celsius a Kelvin, usando `case` para seleccionar la conversión deseada.

La fórmula para realizar las conversiones es:

- `Grados Fahrenheit = Grados Celsius * 1.8 + 32`
- `Grados Celsius = ( Grados Fahrenheit - 32) / 1.8`

```bash
#!/bin/bash

echo "¿A que quieres convertir?"
echo "1) Celsius"
echo "2) Farenheit"

read -p "Elige una opción: " respuesta
if [ -n $respuesta ];
then 
        read -p "Introduce la temperatura que quieres calcular: " calculo
                case $respuesta in
                1)
                        calculadora=$((calculo - 32 / 1,8))
                        echo "La temperatura sería de $calculadora"
                        ;;
                2)
                        calculadora=$((calculo * 1,8 + 32))
                        echo "La temperatura sería de $calculadora"
                        ;;
                esac
else 
        echo "Numero invalido"
fi
```
## Ejercicio 7: Estado del servicio

Escribe un script que reciba el nombre de un servicio (por ejemplo, "apache" o "mysql") y, usando `case`, muestre opciones para iniciar, detener o reiniciar el servicio.

```bash
#!/bin/bash

echo "¿Que servicio quieres usar?"
echo "1) Cron"
echo "2) Mysql"

read -p "Elige una opción: " respuesta
case $respuesta in 
        1) 
                echo "¿Que quieres hacer ahora?"
                echo "1) Iniciar"
                echo "2) Detener"
                echo "3) Reiniciar"

                read -p "Introduce la opción que quieras realizar: " respuesta2
                case $respuesta2 in
                        1) 
                                sudo service cron start
                                ;;
                        2)
                                sudo service  cron stop
                                ;;
                        3)
                                sudo service cron restart
                                ;;
                esac
                ;;
        2)
                echo "¿Que quieres hacer ahora?"
                echo "1) Iniciar"
                echo "2) Detener"
                echo "3) Reiniciar"

                read -p "Introduce la opción que quieras realizar: " respuesta2
                case $respuesta2 in
                        1) 
                                sudo service mysql init
                                ;;
                        2)
                                sudo service mysql stop
                                ;;
                        3)
                                sudo service mysql restart
                                ;;
                esac
                ;;
esac
```

## Ejercicio 8: Conversión de unidades de longitud

Desarrolla un script que permita al usuario convertir metros a kilómetros, metros a centímetros, o metros a milímetros, utilizando `case` para manejar cada opción de conversión.

```bash
#!/bin/bash

echo "De que unidad a que unidad quieres convertir: "
echo "1) Metros a Kilometros"
echo "2) Metros a Centimetros"
echo "3) Metros a Milimetros"

read -p "Escribe un numero entre (1-3): " opcion

case $opcion in
        1)
                echo "Has elegido la opción: Metros a Kilometros"
                read -p "¿Cuanto quieres pasar a Kilometros?: " suma
                suma2=$((suma / 1000))
                echo "$suma Metros serían $suma2 Kilometros"
                ;;
        2)
                echo "Has elegido la opción: Metros a Centimetros"
                read -p "¿Cuanto quieres pasar a centimetros?: " suma
                suma2=$((suma * 100))
                echo "$suma Metros serían $suma2 Centimetros"
                ;;
        3)
                echo "Has elegido la opción: Metros a Milimetros"
                read -p "¿Cuanto quieres pasar a milimetros?: " suma
                suma2=$((suma * 1000))
                echo "$suma Metros serían $suma2 Milimetros"
esac
```

[Volver al inicio](./../../index.md)