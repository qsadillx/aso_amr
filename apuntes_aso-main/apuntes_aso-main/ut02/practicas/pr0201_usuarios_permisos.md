# PR0201: Usuarios y permisos en Linux

## Aspectos generales

### Objetivos de la práctica

Esta práctica servirá para profundizar tus conocimientos sobre usuarios y permisos en sistemas Linux.


### Recursos

1. [Box Ubuntu 22.04](https://app.vagrantup.com/generic/boxes/ubuntu2204)
2. [Ficheros /etc/passwd /etc/shadow y /etc/group en GNU/Linux](https://blog.elhacker.net/2022/02/icheros-etc-passwd-shadow-y-group.html)ç
3. [Understanding /etc/shadow file format on Linux](https://www.cyberciti.biz/faq/understanding-etcshadow-file/)
4. [How to create SHA512 password hashes on command line](https://unix.stackexchange.com/questions/52108/how-to-create-sha512-password-hashes-on-command-line)
5. [Rockyou.txt](https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt)
6. [SecLists](https://github.com/danielmiessler/SecLists/tree/master)
7. [How to use John the Ripper](https://www.varonis.com/blog/john-the-ripper)


### Entorno de trabajo

Esta práctica la realizaremos en un Ubuntu Server 22.04 LTS, para utilizar todos el mismo entorno usarás el box denominado `generic/ubuntu2204`.


## Enunciado

### 1. Permisos de usuarios

A no ser que se indique lo contrario realiza todas las operaciones desde el directorio personal de tu usuario.

1.	Crea el directorio `pr0201` dentro de tu directorio personal y dentro de él crea los directorios `dir1` y `dir2` ¿Cuáles son los permisos del directorio `dir1`? No pongas una captura, explica quiénes tienen permisos sobre el directorio y qué pueden hacer en él.

2.	Utilizando   la   notación   simbólica, elimina   todos   los   permisos de   escritura (propietario, grupo, otros) del directorio `dir2`.

3.	Utilizando la notación octal, elimina el permiso de lectura del directorio `dir2`, al resto de los usuarios.

4.	¿Cuáles son ahora los permisos asociados a `dir2`?

5.	Crear bajo `dir2`, un directorio llamado `dir21`.

6.	Concédete a ti mismo permiso de escritura en el directorio `dir2` e intenta de nuevo el paso anterior.



### 2. Notación octal y simbólica

1.	Supón que el fichero `~/file` tiene los permisos `rw-r--r--`. Escribe el comando o comandos que necesitarías para establecer los siguientes permisos en el fichero anterior utilizando **notación simbólica**. 

- `rwxrwxr-x` :
- `rwxr--r--` :
- `r--r-----` :
- `rwxr-xr-x` :
- `rwxr-xr-x` :
- `r-x--x--x` :
- `-w-r----x` :
- `-----xrwx` :
- `r---w---x` :
- `-w-------` :
- `rw-r-----` :
- `rwx--x--x` :

2.	Escribe el comando que necesitarías para establecer los siguientes permisos en el fichero anterior utilizando **notación octal**.

- `rwx rwx rwx` : 111 111 111  777
- `--x --x --x` : 001 001 001  111
- `r-- -w- --x` : 100 010 001  421
- `-w- --- ---` : 010 000 000  200
- `rw- r-- ---` :
- `rwx --x --x` :
- `rwx r-x r-x` :
- `r-x --x --x` :
- `-w- r-- --x` :
- `--- --x rwx` :


### 3. El bit setgid

Vamos a ver ahora cómo funciona y para qué sirve el **bit setgid**. Realiza los siguientes pasos:

1. Crea un grupo llamado `asir` y los usuarios `{iniciales}1` e `{iniciales}2`, donde `{iniciales}` son las iniciales de tu nombre. Por ejemplo, en mi caso se llamarían `vjgr1` y `vjgr2`. Haz que los usuarios pertenezcan al grupo.
2. Crea el directorio `/compartido` y asigna propietario: `root` como usuario propietario y `asir` como grupo propietario.
3.  Asigna al directorio creado permisos de lectura, escritura y ejecución para el usuario y el grupo propietario. El resto de usuarios no tendrá ningún tipo de permiso.
4.  Establece el **bit setgid** en el directorio y verifica que se haya asignado.
5.  Inicia sesión con `usuario1`, accede al directorio y crea un fichero llamado `fichero1` con algo de contenido. Comprueba los permisos del fichero que has creado.
6.  Ahora inicia sesión con `usuario2` y comprueba si puedes acceder a `/compartido/fichero1` y si puedes añadirle contenido.
7.  Responde las siguientes preguntas:
    - ¿Qué ventajas tiene usar el bit setgid en entornos colaborativos?
    - ¿Qué sucede si no se aplica el bit setgid en un entorno colaborativo?
8. Cuando hayas acabado, limpia el sistema eliminando los usuarios y el directorio creado para la práctica.


### 4. El sticky bit

Ahora vamos a practicar con el **sticky  bit**. Realiza los siguientes pasos:

1. Crea el directorio `/compartido` con todos los permisos para todos los usuarios.
2. Crea dos usuarios `{iniciales}1` e `{iniciales}2`
3. Vamos a probar primero el funcionamiento sin el sticky bit. Inicia sesión con el primer usuario, crea un fichero y luego, con el segundo usuario, intenta eliminarlo.
4. Ahora establece el sticky bit en el directorio y verifica que se ve en los permisos.
5. Vuelve a iniciar sesión con el primer usuario, crea un fichero e intenta eliminarlo con el segundo usuario.
6. Responde las siguientes preguntas:
   - ¿Qué efecto tiene el sticky bit en un directorio?
   - Si tienes habilitado el sticky bit, ¿cómo tendrías que hacer para eliminar un fichero dentro del directorio?


### 5. El fichero `/etc/shadow` (**OPCIONAL**)

El fichero `/etc/shadow` es un directorio cuya protección es vital en un sistema Linux ya que contiene los hashes de las contraseñas de los usuarios. 

Para esta parte de la práctica tienes que utilizar la imagen `generic/ubuntu2004` de Vagrant.

1. Crea un usuario llamado `{iniciales}` con contraseña `asir2`.
2. Muestra la línea de l fichero `/etc/shadow` que contiene la contraseña de este usuario.
3. En el segundo enlace del apartado [recursos](#recursos) puedes ver un listado de los diferentes tipos de hash soportados por este fichero. ¿Cuáles son?
4. ¿Cuál es el tipo de hash utilizado en tu sistema?
5. Seguro que has observado que hay un segundo campo en el hash que llama la **sal**. ¿Para qué sirve este campo?
6. Dos tipos de ataque muy comunes para obtener las contraseñas de los usuarios son los **ataques de diccionario** y las **tablas rainbow**. Busca por Internet y averigua en qué consisten ambos tipos de ataque.
7. En el tercer enlace de los [recursos](#recursos) puedes ver cómo se genera un hash SHA512 desde la línea de comandos. Verifica que el hash que hay guardado en el fichero `/etc/shadow` es el hash de la contraseña `asir1`


### 6. Rompiendo hashes con John the Ripper (**OPCIONAL**)

Como una parte importante de la administración de sistemas es la protección de los mismos, vamos a ver cómo funciona una de las herramientas más utilizadas para obtenerlas a partir de los hash. Esta herramienta se llama **John the Ripper**, y, aunque permite varios tipos de ataque, la usaremos para realizar un **ataque de diccionario**.

Realiza los siguientes pasos:

- Instálala a partir de los repositorios. 
- Obviamente, para un ataque de diccionario necesitamos el diccionario de palabras. Uno de los más conocidos es el denominado `rockyou.txt`, que contiene casi 15 millones de contraseñas. Tienes la URL en el apartado recursos, descárgalo y guárdalo en `/usr/share/wordlists`
- Si `rockyou.txt` se te queda pequeño siempre puedes utilizar alguno de los diccionarios del proyecto SecLists (enlace en recursos), que contiene diccionarios para todo tipo de ataques.
- A continuación, extrae la cadena con el hash de la contraseña en un fichero que llamaremos `passwordfile`.
- Ya es momento the utilizar JtR, si investigas un poco verás que dispone de tres modos: single mode, dictionary e incremental. Realiza una breve investigación y explica en qué consiste cada uno de los modos.
- Utiliza JtR para descifrar la contraseña, recuerda que los modificadores que puedes utilizar son:
  - `--single`
  - `--wordlist dict_file`
  - `--incremental`


### ¿Qué hay que entregar?

Debes entregar:

- Documentación de los pasos más relevantes



[Volver al índice](../index.html)