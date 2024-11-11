# UT02: INSTALACIÓN Y PUESTA EN MARCHA DE LINUX SERVER

## 1.- Gestión de usuarios y permisos

## Índice

- 1.1.- [La seguridad en Linux](#11--la-seguridad-en-linux)
- 1.2.- [Añadir un nuevo usuario](#12--añadir-un-nuevo-usuario)
- 1.3.- [Eliminación de un usuario](#13--eliminación-de-un-usuario)
- 1.4.- [Modificando un usuario](#14--modificando-un-usuario)
- 1.5.- [Grupos en Linux](#15--grupos-en-linux)
- 1.6.- [Permisos](#16--permisos)
- 1.7.- [Compartición de ficheros](#17--compartición-de-ficheros)

### 1.1.- La seguridad en Linux

El elemento clave para gestionar la seguridad en Linux es la **cuenta de usuario**. Cada persona que acceda al sistema ha de hacerlo a través de la cuenta de usuario que tenga asignada. Los permisos que tenga entonces serán los mismos que tenga la cuenta con la que se loguee.

De forma similar a Windows, donde cada usuario tiene asignado un SID único, en Linux cada usuario tiene asignado un **identificador de usuario**, denominado **UID** único. Sin embargo, el usuario no utiliza este UID para identificarse, sino que utiliza su **nombre de usuario** o de **login**, una cadena alfanumérica más comprensible para el usuario.	

Para gestionar la seguridad un sistema Linux utiliza una serie de ficheros y utilidades que veremos a continuación.

#### 1.1.1.- El fichero `/etc/passwd`

Los sistemas Linux utilizan un fichero especial denominado `/etc/passwd` para almacenar las correspondencias entre los nombres de usuario y sus correspondientes UIDs. 
 
```
vgonzalez@ubuntu:~$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
...
```

Un usuario especial que está en todos los sistemas es el usuario **root**, el cual siempre tiene asignado el **UID 0**. Además, los sistemas Linux tienen un gran número de usuarios que son utilizados internamente por el sistema denominados **cuentas del sistema**. Una cuenta del sistema es una cuenta que utilizan determinados servicios que se están ejecutando en el sistema para obtener acceso a los recursos que necesiten. Todos los servicios que se ejecutan en segundo plano tienen que obtener acceso al sistema mediante una cuenta del sistema. Linux reserva los UIDs por debajo de 500 para las cuentas del sistema.

Aparte del nombre de usuario y el UID el fichero passwd muestra mucha más información:

- El nombre de usuario
- La contraseña del usuario
- El UID del usuario
- El identificador del grupo del usuario (GID)
- Una descripción de la cuenta del usuario
- La localización del directorio HOME del usuario
- El shell por defecto del usuario


#### 1.1.2.- El fichero `/etc/shadow`

Aunque el campo de contraseña se utilizaba anteriormente para almacenar la función hash de la contraseña del usuario, esto suponía un problema de seguridad porque muchos programas y usuarios debían acceder al directorio `/etc/passwd` por diversos motivos. Por ello se quitó la contraseña del usuario de este fichero (por ello en todos los usuarios hay un x en su lugar) y ahora se almacenan en un fichero diferente situado en `/etc/shadow`. El acceso a este fichero está **restringido** a unos pocos programas, como por ejemplo el de login.

El fichero `/etc/shadow` solo puede ser accedido por el usuario root y contiene un registro por cada usuario del sistema de la siguiente forma:

```
vgonzalez:$6$NzqR2ONSyVUF8diD$iwr3RRcnQQVTCPrUxvYnifDI5Mkq/5l8PuypVGa5lWxc15sJBeBlzTDecQ.jufOTrM/jKzl.7XkncTXO8fhCn.:19056:0:99999:7:::
```

Los nueve campos de cada fila son:
- El nombre de login del usuario
- La función hash de la contraseña
- El número de días transcurridos desde el 1 de enero de 1970 hasta que la contraseña fue cambiada por última vez
- El número mínimo de días hasta que la contraseña pueda ser cambiada
- El número mínimo de días antes de que la contraseña deba ser cambiada
- El número de días antes de la expiración de la contraseña en los que se avisará al usuario
- El número de días desde que la contraseña expire hasta que la cuenta sea deshabilitada
- La fecha (indicada como número de días desde el 01-01-1970) desde que la cuenta de usuario fue deshabilitada
- Campo reservado


### 1.2.- Añadir un nuevo usuario

Ubuntu dispone de dos comandos para crear usuarios: `useradd` y `adduser` siendo la única diferencia entre ellos que el segundo es interactivo. Así, si queremos crear un usuario en la línea de comandos es más cómodo usar `adduser`, que nos irá preguntando de forma interactiva por los diferentes datos que necesita, mientras que si queremos crear un usuario en un script utilizaremos `useradd` que toma todos los datos de sus parámetros y, por tanto, se puede ejecutar sin interacción por parte del usuario.

#### Creación de usuarios de forma interactiva: `adduser`

Este comando es en realidad un script de Perl que invoca al comando `useradd` y su funcionamiento es muy sencillo, se le pasa como parámetro el nombre del usuario y preguntará por todos valores que necesita.

```
vagrant@ubuntu2004:~$ sudo adduser victor
Adding user `victor' ...
Adding new group `victor' (1001) ...
Adding new user `victor' (1001) with group `victor' ...
Creating home directory `/home/victor' ...
Copying files from `/etc/skel' ...
New password:
Retype new password:
passwd: password updated successfully
Changing the user information for victor
Enter the new value, or press ENTER for the default
        Full Name []:
        Room Number []:
        Work Phone []:
        Home Phone []:
        Other []:
Is the information correct? [Y/n] Y
```

#### Creación de usuarios automática: `useradd`

El comando `useradd` crea un usuario, pero de forma limitada, ya que no realizará algunas funciones básicas como asignarle un directorio personal o contraseña. Para ello debemos utilizar algunos de los siguientes modificadores:

- `-d`: para indicar cuál será el directorio personal del usuario
- `-u`: UID personalizado del usuario
- `-g`: GID personalizado del usuario
- `-e`: indica la fecha de caducidad del usuario, el formato será de la forma `2024-02-28`
- `-c`: añadimos un comentario al usuario
- `-s`: shell que usará el usuario
- `-D`: aplica una serie de configuraciones por defecto al usuario (estas se pueden ver ejecutando el comando `useradd -D` o también en el fichero `/etc/default/useradd`). Si se usa este modificador y alguno de los anteriores aplicará los valores por defecto salvo en el caso del modificador que hayamos indicado explícitamente.

Ten en cuenta también que el usuario creado con `useradd` no tendrá contraseña, por lo que tendrás que asignarla posteriormente con el comando `passwd`.


### 1.3.- Eliminación de un usuario

Para eliminar un usuario del sistema el comando que hay que utilizar es `userdel`. Por defecto, este comando solo elimina la información del usuario del fichero `/etc/passwd`. **No elimina ningún fichero de la cuenta.**

Si se utiliza `userdel` con el parámetro `–r` también eliminará el directorio HOME del usuario, junto con el directorio de correo del usuario.

### 1.4.- Modificando un usuario

Linux proporciona unas pocas utilidades para modificar la información para cuentas de usuario existentes.

#### 1.4.1.- El comando `usermod`

El comando usermod proporciona opciones para modificar la mayoría de los campos del fichero `/etc/passwd`. Para hacer esto solo es necesario utilizarlo con el parámetro correspondiente al campo que se quiere modificar. Algunos de estos parámetros son:

- `-c` para cambiar el campo de comentario
- `-e` para cambiar la fecha de expiración
- `-g` para cambiar el grupo de login por defecto
- `-l` para cambiar el nombre de login del usuario
- `-p` para cambiar la contraseña del usuario
- `-L` para bloquear la cuenta
- `-U` para desbloquear la cuenta.


#### 1.4.2.- Los comandos `passwd` y `chpasswd`

La forma más rápida de cambiar la contraseña de un usuario es mediante el comando `passwd`. Si no se le indican parámetros modificará la contraseña del usuario actual. Si se le indica un nombre de usuario cambiará la contraseña de dicho usuario. Únicamente el usuario **root** puede cambiar la contraseña del resto de usuarios.

El parámetro `–e` forzará al usuario a modificar su contraseña la próxima vez que se inicie sesión en el equipo. Es útil para dar una contraseña sencilla a los usuarios cuando se creen sus cuentas y luego obligarles a modificarla.

Si necesitas modificar la contraseña de un gran número de usuario la mejor opción es el comando `chpasswd`. Este comando lee una lista de pares nombre de `usuario, contraseña` (separados por una coma) de la entrada estándar y automática asigna cada contraseña a cada usuario.


### 1.5.- Grupos en Linux

Las cuentas de usuario son útiles para controlar la seguridad de usuarios individuales, pero no son muy útiles a la hora de permitir a grupos de usuarios compartir recursos. Para esta labor Linux dispone del concepto de **grupos**.

Cada grupo tiene su propio **GID**, que, al igual que las UIDs es un valor único en el sistema.

La información relativa a los grupos de usuarios se almacena en el fichero `/etc/group`. La información de este fichero es:

- El nombre del grupo
- La contraseña del grupo sirve para que los usuarios que no pertenecen a este grupo puedan ser miembros del mismo temporalmente.
- El GID del grupo. Los grupos utilizados por cuentas del sistema tienen GIDs por debajo del número 500, mientras que los grupos de usuarios tienen el GID por encima de este valor.
- Lista de las cuentas de usuario que pertenecen a este grupo.

El comando para añadir un nuevo grupo al sistema es `groupadd`. Cuando se crea un grupo nuevo no se le añaden usuarios por defecto y dicho comando no permite hacer esto. Para ello debemos utilizar el comando `usermod`.

```
vgonzalez@SERVER2:~$ sudo usermod -G miGrupo alumno
vgonzalez@SERVER2:~$ tail /etc/group
uuidd:x:112:
tcpdump:x:113:
ssh:x:114:
landscape:x:115:
lxd:x:116:vgonzalez
systemd-coredump:x:999:
vgonzalez:x:1000:
remote:x:1001:
alumno:x:1002:
miGrupo:x:1003:alumno
```

El comando `usermod` también permite cambiar otra información de los grupos. El parámetro `–g` permitirá modificar el GID del grupo mientras que el parámetro `–n` permite cambiar el nombre del grupo.


### 1.6.- Permisos

Como se ha visto anteriormente, al ejecutar el comando `ls` con el modificador `–l` se nos muestra una serie de caracteres al principio de cada línea. El primero de estos caracteres define el tipo del objeto.

- `-` para ficheros
- `d` para directorios
- `l` para enlaces
- `c` para dispositivos de caracteres
- `b` para dispositivos de bloque
- `n` para dispositivos de red

A continuación, hay tres conjuntos de tres caracteres. Cada conjunto de caracteres define tres tipos de permisos:

- `r` para el permiso de lectura del objeto
- `w` para el permiso de escritura del objeto
- `x` para el permiso de ejecución del objeto

Si un permiso está negado se mostrará con el símbolo guion en su posición. Los tres conjuntos de caracteres definen los tres niveles de seguridad del objeto:

- El **propietario** del objeto
- El **grupo** al que pertenece el objeto
- El **resto** de los usuarios del sistema

Cuando creamos un fichero nuevo este tiene unos permisos por defectos predefinidos. Estos permisos predefinidos vienen dados por el comando `umask`, el cual establece los permisos por defecto para cualquier fichero o directorio que crees.


#### 1.6.1.- El comando `umask`

El comando `umask` nos servirá para modificar los permisos por defecto que se asignarán a cada nuevo fichero o directorio creado en el sistema. Si lo ejecutamos veremos que nos muestra por pantalla 4 dígitos octales que representan los permisos por defecto. El primero corresponde al denomina **sticky bit**. Los otros tres son los permisos por defecto para el usuario que crea el objeto, el grupo del usuario y el resto de los usuarios respectivamente en la representación octal.

Sin embargo, el comando `umask` no muestra los permisos que se asignan tal cual, sino que lo hace mediante una máscara, es decir, los permisos indicados por este comando serán los que se restarán de los permisos máximos que puede tener el objeto. Los permisos máximos de un objeto serán:

- Para los ficheros los permisos 666 (lectura y escritura para todos)
- Para los directorios los permisos 777 (lectura, escritura y ejecución, es decir, recorrido, para todos)

Esto quiere decir que si tenemos una máscara definida como 022 los permisos efectivos que se aplicarán a un fichero serán los resultantes de quitar los permisos de la máscara (022) a los permisos máximos (666), quedando unos permisos efectivos de 644 (lectura/escritura para el usuario y lectura para el resto).	


#### 1.6.2.- Modificando permisos con `chmod`

El comando `chmod` es el que nos permitirá modificar los permisos asociados a un fichero o directorio. El formato de este comando es:

```
chmod opciones modo fichero
```

El parámetro `modo` permite establecer los permisos utilizando una **notación simbólica u octal**. La **notación octal** consiste en asignar a cada grupo de permisos un dígito octal (3 bits). Cada bit de ese dígito corresponderá a cada uno de los permisos diferentes disponibles. Por ejemplo, el permiso de lectura y escritura (`rw-`) correspondería con la secuencia de bits 110, cuyo valor en octal es el dígito 6.

```
vgonzalez@SERVER2:~$ ls -l
total 0
-rw-rw-r-- 1 vgonzalez vgonzalez 0 May 22 06:29 fichero
vgonzalez@SERVER2:~$ chmod 760 fichero
vgonzalez@SERVER2:~$ ls -l
total 0
-rwxrw---- 1 vgonzalez vgonzalez 0 May 22 06:29 fichero
```

Si queremos utilizar la habitual secuencia de caracteres (`rwx`), el comando `chmod` toma una aproximación diferente. El formato para especificar un permiso en el modo simbólico es:

```
	[ugoa...][+-=][rwxXstugo...]
```
 
El primer grupo de caracteres define a quien se le aplicarán los nuevos permisos:

- `u` para el usuario
- `g` para el grupo
- `o` para otros
- `a` para todos los anteriores
- 
El siguiente carácter se utiliza para indicar si quieres añadir el permiso a los existentes (`+`), quitar el permiso de los existentes (`-`), o establecer el permiso a un valor (`=`).

Finalmente, el último símbolo es el permiso que se va a modificar. Hay muchas opciones, pero las más comunes son:

- `r` para permisos de lectura
- `w` para permiso de escritura
- `x` para permiso de ejecución
- `s` para establecer el SUID o el SGID


#### 1.6.3.- Cambio de propietario

Para cambiar el propietario de un fichero Linux dispone de dos comandos. El comando `chown` para cambiar el usuario propietario y el comando `chgrp` para cambiar el grupo propietario del objeto.

El formato de `chown` es:

```
chown opciones owner[.grupo] file
```

Se puede especificar tanto el nombre de usuario como su UID para referenciar al usuario. Además, este comando también nos permite modificar el grupo propietario.

```
vgonzalez@SERVER2:~$ ls -l
total 0
-rw-rw-r-- 1 vgonzalez vgonzalez 0 May 22 06:29 fichero
vgonzalez@SERVER2:~$ sudo chown alumno.alumno fichero
vgonzalez@SERVER2:~$ ls -l
total 0
-rw-rw-r-- 1 alumno alumno 0 May 22 06:29 fichero
```

Incluso yendo más lejos se podría modificar únicamente el grupo propietario del objeto aplicando el comando de la siguiente forma:

```
vgonzalez@SERVER2:~$ sudo chown .vgonzalez fichero
vgonzalez@SERVER2:~$ ls -l
total 0
-rw-rw-r-- 1 alumno vgonzalez 0 May 22 06:29 fichero
```

El funcionamiento del comando `chgrp` es muy similar al anterior, con la única excepción de que el valor modificado es el grupo propietario y no el usuario propietario.


### 1.7.- Compartición de ficheros

El mecanismo que hemos visto para compartir fichero en Linux hasta ahora se basa en el establecimiento de permisos para usuarios y grupos. Así si queremos que un determinado usuario pueda acceder a un objeto podemos incluirlo en el grupo propietario de ese objeto y así obtener los permisos que tenga ese grupo.

Sin embargo, en entornos con múltiples usuarios este proceso puede ser complicado y nada cómodo de utilizar. Para ello Linux dispone de una solución muy simple que viene ligada a 3 bits adicionales que almacena para cada fichero y directorio.

- **El set user id (SUID)**: cuando un fichero es ejecutado por un usuario, el programa se ejecuta bajo los permisos del propietario.
- **El set group id (SGID)**: en fichero el programa se ejecuta utilizando los permisos del grupo propietario del fichero. Para directorios, los nuevos ficheros creados bajo ese directorio utilizan el grupo del directorio como grupo por defecto.
- **El sticky bit**: es un permiso especial en Linux que se aplica a directorios compartidos para evitar el borrado accidental de archivos o directorios.

Estos tres bits se pueden establecer con el comando `chmod`. Se añaden anteponiendo al valor de 3 dígitos octales de los permisos (quedando en ese caso 4 dígitos), o se puede utilizarse la notación simbólica.

| Binario	| Octal	| Descripción |
| --------- | ----- | ----------- |
|  000      |  0    | Ningún bit activado   |
|  001      |  1    | Activado el *sticky bit*   |
|  010      |  2    | Activado el bit *SGID*   |
|  011      |  3    | Activado los bits *SGID* y *sticky bit*   |
|  100      |  4    | Activado el bit *SUID*   |
|  101      |  5    | Activados los bits *SUID* y *sticky bit*   |
|  110      |  6    | Activados los bits *SUID* y *SGID*   |
|  111      |  7    | Activados todos los bits (*sticky bit*, *SUID* y *SGID*)   |

Si en lugar de utilizar notación decimal usamos notación simbólica en el comando `chmod`, lo haríamos de la forma:

- Bit SUID: **`u+s`**
- Bit SGID: **`g+s`**
- Sticky Bit: **`+t`**


#### 1.7.1.- El bit SUID

El **bit SUID* se usa para que un archivo ejecutable se ejecute con los permisos del propietario del archivo, en lugar de los permisos del usuario que lo ejecuta. Este bit es útil para programas que necesitan permisos elevados temporalmente, como `passwd`.

**Ejemplo de uso**

```bash
victor@SERVER:/tmp$ touch script.sh
victor@SERVER:/tmp$ echo "echo SHADOW; cat /etc/shadow" > script.sh
victor@SERVER:/tmp$ chmod a+x script.sh
victor@SERVER:/tmp$ ls -l script.sh
-rwxr-xr-x 1 victor victor 29 Sep 23 17:57 script.sh
victor@SERVER:/tmp$ su alumno           # Cambio al usuario alumno
Password:
alumno@SERVER:/tmp$ ./script.sh
SHADOW                                  # Aquí veo que puedo ejecutar el script
cat: /etc/shadow: Permission denied     # pero al acceder a /etc/shadow da permiso denegado
victor@SERVER:/tmp$ su victor           # Cambio al usuario victor
victor@SERVER:/tmp$ sudo chown root script.sh   # Hago a root propietario
victor@SERVER:/tmp$ sudo chmod u+s script.sh    # Activo el bit SUID
victor@SERVER:/tmp$ ls -l script.sh
-rwsr-xr-x 1 root victor 29 Sep 23 17:57 script.sh



```

#### 1.7.2.- El bit SGID

El **bit SGID** es importante para compartir ficheros. Habilitando el bit SGID, puedes forzar que todos los ficheros creados en un directorio compartido pertenezcan al grupo del directorio y no al grupo del usuario individual que lo ha creado.

**Ejemplo de uso**




#### 1.7.3.- El sticky bit

La función principal del **sticky bit** es restringir la eliminación o modificación de los archivos dentro de un directorio, de modo que solo el propietario del archivo (o root) pueda eliminar o renombrar sus propios archivos, aunque otros usuarios tengan permisos de escritura en ese directorio.

Es útil en directorios compartidos, como `/tmp`, donde múltiples usuarios tienen permisos de escritura y sería problemático que un usuario pudiera borrar los archivos de otro.

**Ejemplo de uso**

Supón que tienes un directorio `/compartido` en tu sistema y necesitas que todos los usuarios puedan escribir en él, pero quieres que nadie pueda eliminar archivos o modificar archivos creados por otros usuarios. Los pasos serían:

```bash
victor@SERVER:/$ sudo mkdir compartido          # Creamos el directorio
victor@SERVER:/$ sudo chmod 777 /compartido     # Permiso RW para todo el mundo
victor@SERVER:/$ sudo chmod +t /compartido      # Activamos el sticky bit
victor@SERVER:/$ ls -ld /compartido
drwxrwxrwt 2 root root 4096 Sep 23 17:40 /compartido
```

Observa que ahora podemos ver la **t** en los permisos de directorio. Ahora cualquier usuario del sistema podrá crear archivos dentro de ese directorio, pero no podrán eliminarlos ni modificarlos.







---
---

[Volver al índice de la unidad](index.md)

[Volver al índice del módulo](../../index.md)