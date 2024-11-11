# UT03: LENGUAJES DE SCRIPTING EN LINUX: BASH


## 3.- Ejecución condicional

### 3.1.- Bifurcación condicional


El comando estructurado más sencillo de que disponemos es el comando `if-then`. La sintaxis de este comando es la siguiente:

```bash
if comando
then
	comandos
fi
```

El formato de este comando puede resultar confuso al principio ya que no funciona como en otros lenguajes de programación en los que se evalúa una expresión para saber si es falsa o verdadera.

El comando `if` ejecuta el comando indicado en la misma línea que el `if`. Si el estado de salida de este comando es cero (el comando se ha ejecutado con éxito), los comandos indicados en las siguientes líneas se ejecutan. Si el estado de salida del comando tiene otro valor el entonces el `shell` se salta todas las líneas y continúa ejecutando el comando después de la línea con el comando `fi`.

```bash
#!/bin/bash
usuario=victor
if grep $usuario /etc/passwd > /dev/null
then
        echo "Los ficheros bash para $usuario son"
        ls -a /home/$usuario/.b*
fi
```
 
### 3.2. - El comando `if-then-else`

El comando `if-then-else` va un poco más allá del comando `if-then` permitiendo especificar dos grupos de comandos, uno que se ejecutará si el estado de salida del comando es cero y otro para ejecutar si el estado del comando no es cero.

La sintaxis del comando es:

```bash
if comando
then
	comandos
else
	comandos
fi
```

### 3.3.- El comando `test`

Por lo que se ha visto hasta ahora el comando `if` es poco versátil ya que únicamente es capaz de evaluar si el resultado de la ejecución de un comando es correcta o no.

Para subsanar este inconveniente podemos recurrir al comando `test`. Este comando toma como parámetro una condición y si el resultado de evaluar esa condición de verdadero finaliza con el código de estado de salida 0.

La sintaxis de este comando es muy sencilla:

```bash
test condición
```

Por lo que su utilización junto con el comando `if-then` será de la forma:

```bash
if test condición
then
comandos
fi
```

El shell Bash proporciona una forma alternativa de declarar el comando test dentro de un comando `if-then`.

```bash
if [ condición ]
then
comandos
fi
```

Con esta sintaxis hay que ser muy cuidadoso ya que requiere un espacio en blanco después del corchete de apertura y otro espacio en blanco antes del corchete de cierre. En caso contrario el comando dará error.

Hay tres tipos de condiciones que el comando test puede evaluar:
- Comparaciones numéricas
- Comparaciones de cadenas
- Comparaciones de ficheros

#### 3.3.1.- Comparaciones numéricas

El uso más común del comando `test` es para realizar comparaciones entre dos números. Los valores a comparar pueden venir dados tanto por un número como por una variable.

```bash
if [ $val1 -gt 5 ]
then
        echo "El valor $val1 es mayor que 5"
fi
```

Los diferentes operandos que podemos utilizar cuando realizamos comparaciones entre números vienen dados en la siguiente tabla.

**Comparaciones Numéricas en el comando test**

| Comparación  | Descripción                             |
|--------------|-----------------------------------------|
| `n1 –eq n2` | Comprueba si n1 es igual a n2           |
| `n1 –ge n2` | Comprueba si n1 es mayor o igual que n2 |
| `n1 –gt n2` | Comprueba si n1 es mayor que n2         |
| `n1 –le n2` | Comprueba si n1 es menor o igual que n2 |
| `n1 –lt n2` | Comprueba si n1 es menor que n2         |
| `n1 –ne n2` | Comprueba si n1 no es igual a n2        |

#### 3.3.2.- Comparaciones de cadenas

El comando `test` dispone de las siguientes comparaciones de cadenas:

**Comparaciones de Cadenas en el comando `test`**

| Comparación   | Descripción                                          |
|---------------|------------------------------------------------------|
| str1 = str2	| Comprueba si str1 es la misma cadena que str2        |
| str1 ¡= str2	| Comprueba si str1 no es la misma cadena que str2     |
| str1 < str2	| Comprueba si str1 es menor que str2                  |
| str1 > str2	| Comprueba si str1 es mayor que str2                  |
| -n str1	    | Comprueba si str1 tiene una longitud mayor que cero  |
| -z str1	    | Comprueba si str1 tiene una longitud de cero         |

Las comparaciones de igualdad o desigualdad tienen una funcionalidad bastante clara, determinando si las cadenas son iguales o si por el contrario son diferentes.

Hay que tener en cuenta al realizar estas comparaciones que las mayúsculas y las minúsculas son tratadas como caracteres diferentes.

```bash
#!/bin/bash

usuario=victor
if [ $USER != $usuario ]
then
        echo "¿Quién eres?"
else
        echo "Bienvenido, Victor"
fi
```

En lo que respecta a las comparaciones mayor que y menor que entre cadenas nos podemos encontrar con dos problemas importantes:
- Los símbolos `>` y `<` tienen un significado especial para el *shell* (redireccionamiento de ficheros) por lo que se hace necesario escaparlos para poder utilizarlos. En caso de no escaparlos el script no dará ningún mensaje de error, pero el resultado no será el esperado.
 
```bash
victor@SERVER:~$ cat script.sh 
#!/bin/bash

val1=27
val2=42

if [ $val1 > $val2 ]
then
        echo "$val1 es mayor que $val2"
else
        echo "$val2 es mayor que $val1"
fi
victor@SERVER:~$ ./script.sh 
27 es mayor que 42
victor@SERVER:~$ ls
42  find.txt  nmap.out  script.sh  uptime.log
```
 
 - El segundo problema es que **el orden que utiliza el comando test no es el mismo que el utilizado por el comando `sort`**. Esto se debe a que el comando `test` utilizar la comparación en función de los valores ASCII de los caracteres (las mayúsculas aparecen antes que las minúsculas) mientras que el comando `sort` utiliza el orden definido por la configuración local del sistema.

Las otras dos comparaciones serán útiles para comprobar si una cadena contiene datos o no.


#### 3.3.3.- Comparaciones de ficheros

La última categoría de comparaciones nos va a permitir verificar el estado de ficheros y directorios en el sistema de ficheros. Las diferentes opciones vienen dadas por la siguiente tabla:

**Comparaciones de Ficheros en el comando `test`**

| Comparación       | Descripción                                                                    |
|-------------------|--------------------------------------------------------------------------------|
| `-d file`         | Comprueba si file existe y es un directorio                                    |
| `-e file`         | Comprueba si file existe                                                       |
| `-f file`         | Comprueba si file existe y es un fichero                                       |
| `-r file`         | Comprueba si file existe y tiene permisos de lectura                           |
| `-s file`         | Comprueba si file existe y no está vacío                                       |
| `-w file`         | Comprueba si file existe y tiene permisos de escritura                         |
| `-x file`         | Comprueba si file existe y tiene permisos de ejecución                         |
| `-O file`         | Comprueba si file existe y el propietario es el usuario actual                 |
| `-G file`         | Comprueba si file existe y el grupo propietario es el grupo del usuario actual |
| `file1 –nt file2`	| Comprueba si file1 es más reciente que file2                                   |
| `file1 –ot file2`	| Comprueba si file2 es más antiguo que file2                                    |

Las opciones son:

- **Comprobando objetos**: El comando `–d` comprueba si valor indicado corresponde a un directorio existente en el sistema. Es útil para comprobar si un directorio existe antes de copiar un fichero en él o antes de moverse a ese directorio. La comparación `–e` permite verificar si un directorio o fichero existe. Finalmente, la comparación `–f` nos va a permitir averiguar si un fichero indicado existe en el sistema de ficheros.

```bash
#!/bin/bash

if [ -e $HOME ]
then
        echo "El directorio existe, vamos a comprobar ahora el fichero"
        if [ -e $HOME/testing ]
        then
                # El fichero existe. Anexamos los datos
                echo "Añadiendo datos al fichero"
                date >> $HOME/testing
        else
                # El fichero no existe. Creamos uno nuevo
                echo "Creando un fichero nuevo"
                date > $HOME/testing
        fi
else
        echo "Error. No tienes directorio HOME"
fi

test
```
 
- **Verificación de la lectura**: Antes de intentar leer datos de un fichero es interesante comprobar si realmente podemos leer de ese fichero. Esta verificación la podemos realizar con el comparador `–r`.
- **Verificando si un fichero está vacío**: La comparación `–s` permite verificar si un fichero existe, pero está vacío, es decir, no tienen ningún dato almacenado en él. Hay que tener en cuenta que esta comparación devuelve verdadero si el fichero contiene datos.
- **Verificación de la escritura**: De forma similar a la verificación de la escritura, el comparador `–w` nos permitirá verificar si tenemos permisos para escribir en un fichero antes de hacerlo.
- **Verificación de la ejecución**: Dado que existe un comparador para verificar la lectura y otro para verificar la escritura resulta obvio que haya un tercero para comprobar si tenemos permisos de ejecución sobre un fichero. Este será el comparador `–x`.
- **Comprobando el propietario**: Con el comparador `–O` podremos verificar la pertenencia del objeto. Hay que tener en cuenta que esta opción no nos permite comprobar si el propietario es otro usuario, solamente si es el usuario actual. De forma similar el comparador `–G` nos permitirá saber si el grupo propietario del objeto es el del usuario actual.

```bash
victor@SERVER:~$ cat script.sh 
#!/bin/bash
# Comprobamos el propietario
if [ -O /etc/passwd ]
then
        echo "Eres el propietario del fichero /etc/passwd"
else
        echo "NO eres el propietario del fichero /etc/passwd"
fi
victor@SERVER:~$ ./script.sh 
NO eres el propietario del fichero /etc/passwd
victor@SERVER:~$ sudo ./script.sh 
Eres el propietario del fichero /etc/passwd
```

- **Fecha del fichero**: El último grupo de comparaciones nos permite evaluar dos ficheros y saber cuál tiene una fecha de creación anterior. Esto puede ser útil al escribir scripts que instalen software para evitar instalar ficheros anteriores a los que ya tenemos en el sistema. La comparación `–nt` nos sirve para saber si un fichero es más nuevo que otro mientras que la comparación `–ot` nos indica si es más antiguo.


### 3.4.- Condiciones compuestas

El comando `if-then` nos permite también utilizar **lógica booleana** para combinar comprobaciones. Se puede utilizar dos operadores booleanos:

- `[ condición 1 ] && [ condición 2 ]`
- `[ condición 1 ] || [ condición 2 ]`

El primer operador realiza el **AND booleano** para combinar las dos condiciones, debiendo cumplirse ambas. Mientras que el segundo operador corresponde al **OR booleano**, en el que únicamente es necesario que se cumpla una de las dos condiciones.

Otra utilidad de los operadores `&&` y `||` es enlazar diversos comandos condicionando la ejecución de al resultado de la ejecución de los anteriores.

El operador `&&` ejecuta el segundo comando únicamente si el primer comando se ejecuta con éxito. Por ejemplo, la siguiente línea comprueba si un directorio existe y en caso afirmativo entra en él.
 
```bash
victor@SERVER:~$ echo $dir
/etc
victor@SERVER:~$ test -d $dir && cd $dir
victor@SERVER:/etc$
```

El operador `||` ejecuta el segundo comando únicamente si el primer comando falla en la ejecución. Por ejemplo, la siguiente orden intenta acceder a un directorio y si falla sale con el código de error 1.

```bash
victor@SERVER:/etc$ cd $HOME/bin || exit 1
```

Incluso se pueden combinar ambos operadores.

```bash
victor@SERVER:~$ mkdir $HOME/bin && cd $HOME/bin || exit 1
```

### 3.5.- El comando `case`

Hay ocasiones en las que se quieren ejecutar diferentes secuencias de código en función del valor de una variable. Aunque esta operación se puede realizar con varios comandos `if`, el shell nos proporciona un comando más adecuado para ello. Este es el comando `case`. Este comando compara una variable con múltiples valores y ejecuta secuencias de código diferentes para cada valor.

Su sintaxis es:

```bash
case variable in
	patron1 | patron2) comandos;;
	patron3) comandos;;
	*) comandos;;
esac
```
El comando `case` compara la variable especificada con los diferentes patrones. Si la variable coincide con un patrón, el *shell* ejecuta los comandos especificados para dicho patrón. Se puede indicar más de un patrón en una línea utilizando el símbolo barra para separarlos. El símbolo `*` permitirá especificar los comandos por defecto a ejecutar para el caso de que la variable no coincida con ningún patrón.

```bash
#!/bin/bash
case $USER in
    victor | jesus)
        echo "Bienvenido $USER"
        echo "Disfruta de la visita";;
    test)
        echo "Cuenta especial de prueba";;
    oscar)
        echo "No olvides cerrar sesión cuando acabes";;
    *)
        echo "No eres un usuario autorizado";;
esac
```

 
### 3.6.- Bucles

Los bucles sirven para ejecutar varias veces un conjunto de comandos. El *shell* proporciona tres tipos de bucles: `while`, `until` y `for`. Los dos primeros se ejecutan hasta que una condición sea verdadera o falsa, y el tercer itera sobre una lista de valores.

#### 3.6.1.- El comando `while`

El comando `while` ejecuta un conjunto de comandos mientras la condición sea verdadera. Su sintaxis es:

```bash
while <condición>
do
	<comandos>
done
```

Por ejemplo, incrementando una variable en cada iteración, se puede forzar que se ejecute un número determinado de veces. 

```bash
#!/bin/bash

n=1
while [ $n -lt 10 ]
do
   echo $n
   n=$(( $n + 1 ))
done
```

Observa en el ejemplo anterior la sintaxis utilizada para realizar una operación matemática sobre una variable utilizando **el símbolo $ y con la operación entre dobles paréntesis**. Alternativamente, se podría haber utilizado el comando `let`.

```bash
victor@SERVER:~$ a=10
victor@SERVER:~$ let b=a+5
victor@SERVER:~$ echo $b
15
victor@SERVER:~$ let b+=15
victor@SERVER:~$ echo $b
30
```

Los bucles `while` pueden ser utilizados para leer un fichero línea a línea:
 
```bash
#!/bin/bash

IFS=				# Establecemos el Internal Field Separator (IFS) para que sea la cadena vacía
while read line		# El comando read lee lineas de la entrada estándar, devuelve verdadero mientras queden líneas
do
   echo $line
done < fichero		# Redireccionamos el fichero a la entrada del read
```

Un tema interesante que puedes ver aquí es el uso de la variable `IFS`, que establece el separador de campos que utilizará el comando `read`. En este ejemplo se deja vacío, lo que indica que se leerán líneas completas, pero podemos indicar otro valor, por ejemplo, para leer ficheros en formato CSV (Comma Separated Values).

```bash
victor@SERVER:~$ cat script.sh
#!/bin/bash
IFS=','
while read nombre apellido nif
do
   echo "Nombre: $nombre - Apellidos: $apellido - NIF: $nif"
done < fichero
victor@SERVER:~$ cat fichero
Victor, González, 10100100Z
Pepe, Alonso, 12345678D
victor@SERVER:~$ ./script.sh
Nombre: Victor - Apellidos:  González - NIF:  10100100Z
Nombre: Pepe - Apellidos:  Alonso - NIF:  12345678D
```


#### 3.6.2.- El comando `until`

Es el opuesto al comando `while`, se ejecutan los comandos mientras la condición sea falsa.

```bash
#!/bin/bash

n=1
until [ $n -gt 10 ]
do
   echo "$n"
   n=$(( $n +1 ))
done
```

#### 3.6.3.- El comando `for`

El comando `for` nos permitirá iterar una variable sobre una serie de valores. Cada iteración ejecutará los comandos definidos tomando el valor que le corresponda a la variable para esa iteración. El formato básico para este comando es:

```bash
for var in lista
do
   comandos
done
```
Los valores que va a tener la variable se pueden especificar de varias maneras.

##### 3.6.3.1.- Indicando los valores en una lista

La forma más sencilla es enumerar los valores uno a uno en una lista dentro del propio comando `for`.

```bash
#!/bin/bash

for provincia in Leon Zamora Salamanca Valladolid
do
   echo La siguiente provincia es $provincia
done
```

Un problema con el que nos podemos encontrar aquí es cuando queremos que alguno de los valores no sea una palabra, sino que sea una frase o una palabra compuesta. La solución pasa por rodear los valores compuestos de más de una palabra entre comillas.

```bash
for localidad in Ponferrada León "San Andrés"
```


##### 3.6.3.2.- Recorriendo un rango de números

Si queremos que la variable itere sobre un rango de números podemos hacerlo especificándolo de la siguiente manera:

```bash
for var in {1..10}
```

Esto realizará 10 iteraciones en el bucle asignándole a la variable `i` los valores 1, 2, 3,…

##### 3.6.3.3.- Leyendo la lista de una variable

Otra opción que tenemos es que podemos utilizar una variable para ir acumulando los valores en la lista y luego indicar dicha variable en el comando `for`, como se puede ver en el siguiente ejemplo.

```bash
#!/bin/bash

lista="León Zamora Salamanca"
lista=$lista" Valladolid"     # Ojo, observa cómo hacemos para concatenar cadenas

for provincia in $lista
do
   echo "Alguna vez has visitado $provincia?"
done
```
 
##### 3.6.3.4.- Leyendo los valores de un comando

Otra opción más es obtener los diferentes valores que va a tener la variable en las sucesivas iteraciones de la ejecución de un comando. Para ello utilizamos `$( )`. 

```bash
#!/bin/bash

file=provincias

for provincia in $(cat provincias)
do
   echo "Has visitado $provincia"
done
```

Un aspecto que hay que tener en cuenta cuando utilizamos esta opción es el carácter que utiliza el *shell* para separar los diferentes valores que tomará la variable. Si en el ejemplo anterior en una línea hay más de una palabra veremos que la variable no tomará el valor de la línea completa, sino que realizará una iteración para cada una de las palabras del texto.

La causa de este comportamiento se debe a la **variable de entorno `IFS`**, denominada separador interno de caracteres (*internal field separator*). La variable de entorno IFS define una lista de caracteres que utiliza el `shell` como separadores de campo.

Por defecto esta variable define los siguientes separadores:
- El espacio
- El carácter de tabulador
- El salto de línea

Por lo tanto, si queremos por ejemplo que solamente nos tome los saltos de línea como separadores de campo, la solución será modificar temporalmente el valor de la variable IFS, indicándolo de la forma:

```bash
IFS=$'\n' 
```

Hay que tener cuidado de volver a dejar el valor anterior que tenía esta variable, por lo que es aconsejable almacenar en una variable temporal su valor y volver a restablecerlo antes de finalizar el script.

```bash
IFS_OLD=$IFS
IFS=$'\n'
# Aquí usamos la variable IFS
IFS=$IFS_OLD
```

También podemos utilizar esta variable para definir otros separadores. Si por ejemplo queremos recorrer todos los valores individuales del fichero `/etc/passwd`, que están separados por el símbolo dos puntos (`:`), lo podemos hacer de la forma:

```bash
IFS=$'/n:' 
```
 
##### 3.6.3.5.- Leyendo un directorio utilizando caracteres comodín

Finalmente, la última posibilidad del comando `for` es recorrer una serie de ficheros de un directorio. Para hacer esto podemos utilizar los caracteres comodín dentro de una ruta especificada en el comando `for`.

```bash
#!/bin/bash

for file in /home/victor/test/*
do
   if [ -d "$file" ]
   then
      echo '$file es un directorio'
   elif [ -f "$file" ]
   then
      echo '$file es un fichero'
   fi
done
```

En este ejemplo hay que fijarse en que rodeamos la variable en el comando `if` entre comillas dobles. Esto es porque en Linux es posible definir nombres de ficheros que tengan espacios en medio, por lo que al rodearlo de comillas forzamos a que trate a estos nombres compuestos como una única cadena. Si no hacemos esto, y hay algún nombre compuesto, el comando `if` nos dará un error ya que encontrará más parámetros de lo esperado.
Por último, señalar que también podemos especificar varias rutas dentro del comando for de la siguiente manera.
 
```bash
for file in /home/victor/.b* /home/victor/test
```
 

### 3.7.- Lectura de ficheros de texto

Ya vimos en el apartado anterior que podíamos leer un fichero de texto utilizando el comando `for`, que nos permite ir almacenando en una variabla, línea a línea, el contenido del fichero (salvo que modifiquemos la variable `$IFS`).

Aunque este método es muy útil, hay ocasiones en que puede que necesitemos más control sobre los datos que leemos, especialmente si leemos ficheros donde cada línea contiene una serie de datos separados por algún carácter especial, como puede ser el caso de los ficheros CSV o ficheros del sistema como `/etc/passwd`.

En estos casos es mejor utilizar el comando `while`, utilizando la estructura que se puede ver en el siguiente ejemplo.

```bash
#!/bin/bash

while IFS=:
read user pass uid gid desc home_path shell
do
   echo "El usuario $user tiene el UID $uid"
done < /etc/passwd
```

Algunas cosas a tener en cuenta del código anterior:

- Utilizamos la variable `$IFS` para indicar cuál será el separador de campos (en el caso del fichero `/etc/passwd` el carácter `:`)
- En el comando `read` indicamos las variables en que se volcarán los datos de cada línea del fichero en cada iteración.
- Si indicamos menos variables que campos tiene cada línea, almacenará varios campos en la última variable como una lista.
- Observa cómo utilizamos el redireccionamiento de entrada para enviar el contenido del fichero `/etc/passwd` al comando `while`