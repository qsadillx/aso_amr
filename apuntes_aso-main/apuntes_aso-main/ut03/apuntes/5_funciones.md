# UT03: LENGUAJES DE SCRIPTING EN LINUX: BASH


## 5.- Funciones en Bash

### 5.1.- Funciones

Al igual que la mayoría de lenguajes de programación, Bash permite la definición de **funciones**. Una función se puede definir como **un bloque de código identificado por un nombre, cada vez que la función es invocada se ejecuta su código, permitiendo así la reutilización del código**.

#### 5.1.1.- Declaración de funciones

En Bash hay dos formas de declarar funciones:

```bash
function nombre_funcion {
	comandos
	}
```

o bien

```bash
nombre_funcion() {
	comandos
}
```

El símbolo de apertura de llaves se puede poner después del nombre de la función o en la siguiente línea.
Para invocar la función simplemente hay que poner su nombre. Una llamada a función es equivalente a un comando.

```bash
victor@SERVER:~$ cat script.sh
#!/bin/bash

function saludo {
   echo "Hola mundo!!!"
}

saludo
victor@SERVER:~$ ./script.sh
Hola mundo!!!
```
 
También es posible declarar toda la función en una misma línea separando los comandos por el símbolo punto y coma (`;`)

```bash
function saludo {    echo "Hola mundo!!!"; echo "Esto es una función"; }
```

Es importante que las funciones se declaren antes de invocarlas, ya que en caso contrario daría error.


#### 5.1.2.- Paso de parámetros a funciones

También es posible pasarle **parámetros** a una función, los parámetros son valores que se pasan a la función al invocarla que pueden condicionar su ejecución. Para invocar una función pasándole parámetros simplemente hay que indicar sus valores después de su nombre.

Dentro de la función, se puede acceder a los valores de los parámetros mediante las variables `$1`, `$2`,… Asimismo, también dispone de las variables `$@` con la lista de todos los parámetros y `$#` que indica el número de parámetros pasados.

```bash
#!/bin/bash

sumar() {
    resultado=$(($1 + $2))
    echo "La suma de $1 y $2 es: $resultado"
}

sumar 5 10
```

#### 5.1.3.- Valor de retorno de la función

Aunque Bash, al contrario qeu otros lenguajes de programación, no tiene una palabra clave específica para devolver el valor de una función, hay formas de devolver un resultado.

**Usando `echo` para retornar resultados**

Una función puede imprimir el resultado con `echo`, que luego puede ser capturado y usado por el código que la llamó.

Ejemplo:

```bash
#!/bin/bash

multiplicar() {
    echo $(($1 * $2))
}

resultado=$(multiplicar 4 5)
echo "El resultado de la multiplicación es: $resultado"
```
 
**Devolver un código de estado**

En Bash, una función puede devolver un código de estado usando el comando `return`. 

```bash
#!/bin/bash

es_par() {
    if [ $(($1 % 2)) -eq 0 ]; then
        return 0  # Éxito, es par
    else
        return 1  # Error, no es par
    fi
}

if es_par 4; then
    echo "El número es par"
else
    echo "El número es impar"
fi

```

#### 5.1.4.- Ámbito de las variables en Bash

Por defecto, todas las variables declaradas en Bash tienen un ámbito global, lo que significa que son accesibles tanto dentro como fuera de las funciones. Para evitar que una función modifique accidentalmente una variable global, puedes declarar variables locales dentro de una función.

Para declarar una variable con ámbito local dentro de una función hay que utilizar la palabra clave `local`.

```bash
#!/bin/bash

contar() {
    local contador=0
    contador=$(($contador + $1))
    echo "El contador local es: $contador"
}

contador=100
contar 5
echo "El contador global es: $contador"
```

#### 5.1.5.- Buenas prácticas para funciones en Bash

- **Uso de variables locales**: Siempre que sea posible, utiliza variables locales dentro de las funciones para evitar interferencias con variables globales.

- **Nombrado descriptivo**: Usa nombres de funciones descriptivos que indiquen claramente lo que hace la función. Por ejemplo, calcular_suma en lugar de funcion1.

- **Comentarios**: Documenta funciones complejas con comentarios que expliquen su propósito y los parámetros que reciben.

- **Evita funciones demasiado largas**: Divide las funciones grandes en funciones más pequeñas y específicas. Esto mejora la legibilidad y el mantenimiento del script.