# UT03: LENGUAJES DE SCRIPTING EN LINUX: BASH


## 2.- Entrada y salida de datos

### 2.1.- Parámetros en la línea de comandos

#### 2.1.1.- Referenciando los parámetros

La forma más sencilla de pasar datos a un script es mediante parámetros en la línea de comandos. Bash asigna el valor de cada parámetro a unas variables especiales denominadas parámetros posicionales. Las denominaciones de estas variables son `$1`, `$2`,… y así sucesivamente. Además, Bash también tiene una variable especial, `$0`, que almacena el nombre del propio script.

Hay que tener en cuenta que Bash interpreta que los parámetros van a estar separados por espacios, por lo que si deseamos que un parámetro esté compuesto por varias palabras debemos entrecomillarlo.

Si el script necesita más de 9 parámetros la forma de referenciarlos es la misma, pero difiere ligeramente en la sintaxis. A partir del noveno parámetro la forma de hacerlo es rodeando el número de la variable posicional entre llaves, de la forma `${10}`, `${11}`, …

Como se dijo anteriormente la variable posicional (`$0`) almacena el nombre del propio script. Esta variable almacena no solo el nombre del script, sino también la ruta completa en la que se encuentra.
Si queremos obtener únicamente el nombre del script, omitiendo la ruta, podemos utilizar el comando `basename`. Este comando admite como parámetro una ruta completa y devuelve el nombre del comando sin los directorios de la ruta.

```bash
#!/bin/bash

nombre=`basename $0`
echo "El nombre del fichero de este script es $nombre"
```

A la hora de utilizar parámetros hay que ser muy cuidadoso para referenciarlos ya que si se referencia un parámetro que no ha sido introducido por el usuario obtendremos un mensaje de error. Por ello es una buena práctica verificar al principio de los scripts si existen realmente los parámetros antes de utilizarlos.

```bash
#!/bin/bash

if [ -n "$1" ]
then
   echo "Hola $1"
else
   echo "Lo siento, no te has identificado"
fi
```



#### 2.1.2.- Variable de parámetros especiales

Además de las variables que vimos en el punto anterior Bash proporciona una serie de variables especiales que proporcionan más información acerca de los parámetros del script.

La primera de estas variables es **la variable `$#`**, que nos devuelve **el número de parámetros** que el usuario ha introducido.

```bash
victor@SERVER:~$ cat script.sh
#!/bin/bash

echo "Se han pasado $# parámetros"
victor@SERVER:~$ ./script.sh a b c d e
Se han pasado 5 parámetros
```

En muchos scripts puede ser necesario obtener todos los parámetros en una única variable. Para ellos Bash proporciona dos variables más: las variables `$*` y `$@`.

Estas dos variables tienen un contenido idéntico, pero varían en su utilidad:
- La primera de ellas, `$*`, almacena todos los parámetros como si fueran un único parámetro.
- La segunda variable, `$@`, almacena también todos los parámetros, pero como palabras separadas dentro de una lista. Esto nos permitirá iterar sobre los valores de estas listas, por ejemplo, en un bucle `for`.

```bash
vagrant@ubuntu2204:~$ cat script.sh
#!/bin/bash

count=1
for param in "$*"
do
   echo "\$*) Parámetro #$count = $param"
   count=$[ $count + 1 ]
done

count=1
for param in "$@"
do
   echo "\$@ Parámetro #$count = $param"
   count=$[ $count + 1 ]
done
vagrant@ubuntu2204:~$ ./script.sh a b c d e
$*) Parámetro #1 = a b c d e
$@ Parámetro #1 = a
$@ Parámetro #2 = b
$@ Parámetro #3 = c
$@ Parámetro #4 = d
$@ Parámetro #5 = e
```
 
### 2.2.- Obteniendo datos del usuario

#### 2.2.1.- Lectura básica

El comando `read` acepta una entrada desde la entrada estándar (o de un descriptor de fichero) y la almacena en una variable. El uso más sencillo sería el siguiente:

```bash
#!/bin/bash

echo -n "Introduce tu nombre: "
read nombre
echo "Hola $nombre, bienvenido"
```

Si en el comando `read` se indica una única variable guarda todos los datos introducidos por el usuario en esa variable. Sin embargo, podemos indicar varias variables, en cuyo caso separará la entrada en varios valores (teniendo en cuenta que el separador entre valores será el espacio o el tabulador) y asignará a la primera variable el primer valor, en la segunda variable el segundo valor y así sucesivamente. Si hay más valores que variables indicadas se asigna un valor a cada variable y en la última de las variables todos los valores que queden sin asignar.

Otra opción que tenemos con el comando `read` es no indicar ninguna variable, en cuyo caso la entrada del usuario se guardará en la variable de entorno `$REPLY`.

El comando `read` tiene algunos modificadores interesantes:

- `-p`: aunque en el ejemplo anterior hemos introducido el texto a mostrar en pantalla en el comando anterior, el propio comando `read` nos permite indicar el mensaje con este modificador

```bash
 `read –p “Introduce tu edad: “ edad`.
 ```

- `t`: permite especificar el tiempo que esperará a que el usuario introduzca el valor, si transcurrido ese tiempo no ha introducido ningún valor el comando finalizará con un valor de estado distinto de cero. 

```bash
#!/bin/bash

if read -t 5 -p "Introduce tu nombre: " nombre
then
   echo "Hola $nombre, bienvenido"
else
   echo -e "\nLo siento, muy lento"
fi
```

- `-n`: permite especificar el número de caracteres que puede introducir el usuario, por ejemplo, cuando queremos que introduzca un único carácter.

```bash
read –n1 –p “Desea continuar? (S/N)”`
```

- `-s`: oculta la entrada del usuario, útil si queremos leer una contraseña por teclado.









