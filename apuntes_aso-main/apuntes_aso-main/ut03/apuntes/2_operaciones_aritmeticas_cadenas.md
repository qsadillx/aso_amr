# UT03: LENGUAJES DE SCRIPTING EN LINUX: BASH


## 3.- Operaciones aritméticas y de cadenas

Bash permite realizar operaciones aritméticas y manipular cadenas de texto de forma sencilla, pero debido a que Bash es un lenguaje de scripting más orientado a la gestión de comandos, su soporte para operaciones aritméticas y cadenas es limitado en comparación con lenguajes de programación completos. A continuación, se explica cómo realizar cálculos y trabajar con cadenas de texto en Bash.

### 3.1. Operaciones aritméticas

En Bash, las operaciones aritméticas se pueden realizar utilizando diversas herramientas como `expr`, doble paréntesis `$(())` y otros operadores. Sin embargo, es importante recordar que Bash solo trabaja con números enteros para operaciones aritméticas (no soporta decimales por defecto).

#### 3.1.1. Uso de `expr`

El comando `expr` se utiliza para realizar operaciones aritméticas básicas. Se usa ejecutándolo en una línea de comando o en un script.

Ejemplo básico: Sumar dos números

```bash
#!/bin/bash
resultado=$(expr 5 + 3)
echo "El resultado de la suma es: $resultado"
```

El comando `expr` admite las siguientes operaciones:

- Suma: `expr 5 + 3`
- Resta: `expr 5 - 3`
- Multiplicación: `expr 5 \* 3` (se debe escapar el `*` con `\`)
- División: `expr 6 / 2`
- Módulo: `expr 5 % 2`

#### 4.1.2. Uso de `$(())`

Una manera más moderna y limpia de realizar operaciones aritméticas en Bash es utilizando `$(())`. Este método es más eficiente que `expr` y no requiere el uso de comillas ni escapes de caracteres.

Ejemplo:

```bash
#!/bin/bash
num1=5
num2=3
resultado=$(($num1 + $num2))
echo "El resultado de la suma es: $resultado"
```

Operaciones admitidas con `$(())`:

- Suma: `$(($a + $b))`
- Resta: `$(($a - $b))`
- Multiplicación: `$(($a * $b))`
- División: `$(($a / $b))`
- Módulo: `$(($a % $b))`

Además, con `$(())`, se pueden utilizar operadores de incremento y decremento:

- Incremento: `((a++))`
- Decremento: `((a--))`

Ejemplo:

```bash
a=10
((a++))
echo "Valor de a después del incremento: $a"  # a será 11
```


### 4.2. Manipulación de cadenas de texto

En Bash, las cadenas de texto pueden manipularse de diversas maneras, incluyendo la concatenación, la extracción de subcadenas y la búsqueda de su longitud.

#### 4.2.1. Concatenación de cadenas

Para concatenar cadenas en Bash, simplemente coloca las variables o los literales de texto uno junto al otro sin espacios.

Ejemplo:

```bash

#!/bin/bash
cadena1="Hola"
cadena2="Mundo"
resultado="$cadena1 $cadena2"
echo $resultado
```

#### 4.2.2. Longitud de una cadena

Para obtener la longitud de una cadena en Bash, utiliza la sintaxis `${#variable}`.

Ejemplo:

```bash

#!/bin/bash
cadena="Hola Mundo"
longitud=${#cadena}
echo "La longitud de la cadena es: $longitud"
```

#### 4.2.3. Subcadenas

Se pueden extraer subcadenas de una cadena usando la sintaxis `${variable:posición_inicial:longitud}`.

Ejemplo:

```bash

#!/bin/bash
cadena="Hola Mundo"
subcadena=${cadena:0:4}  # Extrae "Hola"
echo "La subcadena es: $subcadena"
```


#### 4.2.4. Reemplazo de subcadenas

Bash permite reemplazar partes de una cadena mediante `${variable/patrón/nuevo_valor}`.

Ejemplo:

```bash

#!/bin/bash
cadena="Hola Mundo"
nueva_cadena=${cadena/Mundo/Universo}
echo "Cadena modificada: $nueva_cadena"
```


#### 4.2.5. Comparaciones de cadenas

Bash permite comparar cadenas usando los operadores ==, != y >, < (en sentido lexicográfico).

Ejemplo de comparación:

```bash

#!/bin/bash
cadena1="hola"
cadena2="mundo"

if [ "$cadena1" == "$cadena2" ]; then
    echo "Las cadenas son iguales"
else
    echo "Las cadenas son diferentes"
fi
```