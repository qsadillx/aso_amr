# UT02: INSTALACIÓN Y PUESTA EN MARCHA DE LINUX SERVER


## 4.- Almacenamiento y discos

### Índice

- 4.1.- [Introducción](#41--introducción)
- 4.2.- [Monitorizar el espacio en disco](#42--monitorizar-el-espacio-en-disco)
- 4.3.- [Particionamiento con `fdisk`](#43--particionamiento-con-fdisk)
- 4.4.- [Formatear y montar particiones](#44--formatear-y-montar-particiones)
- 4.5.- [Logical Volume Manager (LVM)](#45--logical-volume-manager-lvm)

### 4.1.- Introducción

Aunque durante el proceso de instalación de Linux se configuran todo el almacenamiento y se deja preparado para su uso, es habitual tener que añadir nuevos discos con el tiempo y es importante saber configurarlos y dejarlos preparados para su uso. Esto incluye una serie de tareas:

- Monitorizar el espacio en disco
- Particionar y formatear los nuevos discos
- Montar y desmontar los volúmenes
- Configurar los volúmenes LVM



### 4.2.- Monitorizar el espacio en disco

El comando para monitorizar el espacio que tenemos libre en Linux es `df`, que muestra todos los sistemas de ficheros con información sobre los mismos. Por defecto utiliza como unidad de medida el byte, lo que hace incómodo calcular el tamaño exacto de los sistemas de ficheros, para evitarlo, es conveniente utilizar este comando en combinación con el modificador `-h` para que muestre los tamaños en megabytes.
 
```
vgonzalez@SERVER2:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            916M     0  916M   0% /dev
tmpfs           192M  996K  191M   1% /run
/dev/sda2       124G  4.5G  113G   4% /
tmpfs           960M     0  960M   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           960M     0  960M   0% /sys/fs/cgroup
/dev/loop0       69M   69M     0 100% /snap/lxd/14804
/dev/loop1       28M   28M     0 100% /snap/snapd/7264
/dev/loop2       55M   55M     0 100% /snap/core18/1705
/dev/sda1       1.1G  5.3M  1.1G   1% /boot/efi
tmpfs           192M     0  192M   0% /run/user/1000
```

Como se puede apreciar en la salida, se muestran todos los sistemas de ficheros, incluidos algunos sistemas de ficheros especiales de Linux. En nuestro caso nos interesan los que corresponden a las unidades de almacenamiento, es decir, las que están debajo del directorio `/dev`.

Como se puede ver en la imagen, el sistema de ficheros está ocupado en un 4% (`/dev/sda2`), conteniendo 4.5GB de datos de un total de 124GB disponibles. Sin embargo, la capacidad de almacenamiento no es lo único en lo que hay que fijarse en el sistema de ficheros ya que es posible que tengamos espacio libre y no podamos almacenar más ficheros en el disco. Esto se debe a la forma que tiene el sistema de ficheros en Linux de hacer seguimiento de los ficheros que hay en el disco, que es mediante los denominados **inodos**.

Un **inodo** es una estructura de datos que almacena toda la metainformación del fichero, así como los datos necesarios para acceder al contenido de este. El número de inodos es fijo en el sistema de ficheros, ya que se crean al formatear el disco, y por tanto no es posible tener más ficheros que inodos. Normalmente es muy difícil ocupar todos los inodos dado que su número es muy alto, pero es un factor a tener en cuenta en sistemas donde tengamos muchísimos ficheros pequeños.

Para ver el número de inodos ocupados podemos utilizar el modificador `-i` del comando `df`.
 
```
vgonzalez@SERVER2:~$ df -i
Filesystem      Inodes IUsed   IFree IUse% Mounted on
udev            234299   410  233889    1% /dev
tmpfs           245543   604  244939    1% /run
/dev/sda2      8257536 81252 8176284    1% /
tmpfs           245543     4  245539    1% /dev/shm
tmpfs           245543     3  245540    1% /run/lock
tmpfs           245543    18  245525    1% /sys/fs/cgroup
/dev/loop0        1465  1465       0  100% /snap/lxd/14804
/dev/loop1         459   459       0  100% /snap/snapd/7264
/dev/loop2       10765 10765       0  100% /snap/core18/1705
/dev/sda1            0     0       0     - /boot/efi
tmpfs           245543    22  245521    1% /run/user/1000
```

Si queremos saber el espacio ocupado por cada directorio tenemos el comando `du`. Es recomendable utilizarlo con los modificadores `-hsc`. Asimismo, se le pasan como parámetro los directorios de los que queremos extraer la información.
 
```
vgonzalez@ubuntu:~$ du -hc *
4,0K    datos
8,0K    documentos
6,8M    ubuntu-20.04.4-live-server-amd64.iso
6,8M    total
```

Alternativamente, podemos utilizar la herramienta `ncdu` que nos mostrará el espacio ocupado en los discos mediante una aplicación interactiva
 
```
ncdu 1.14.1 ~ Use the arrow keys to navigate, press ? for help
--- /home/vgonzalez ------------------------------------------------------------------------------------------------------------------------
    6,7 MiB [##########]  ubuntu-20.04.4-live-server-amd64.iso                                                                                 12,0 KiB [          ] /.local
   12,0 KiB [          ] /.ssh
    8,0 KiB [          ] /documentos
    4,0 KiB [          ] /.cache
    4,0 KiB [          ]  .bashrc
    4,0 KiB [          ]  .bash_history
    4,0 KiB [          ]  .profile
    4,0 KiB [          ]  .bash_logout
    4,0 KiB [          ]  datos
    0,0   B [          ]  .sudo_as_admin_successful

 Total disk usage:   6,8 MiB  Apparent size:   6,8 MiB  Items: 18                                                                           
```


### 4.3.- Particionamiento con `fdisk`

Si queremos crear particiones en un disco duro tenemos a nuestra disposición un gran número de herramientas en cualquier sistema operativo. Por ejemplo, *GParted* en Linux, el *Administrador de Discos en Windows* o alguna de las múltiples herramientas comerciales disponibles como *Partition Magic*. Sin embargo, hay ocasiones, sobre todo cuando estamos trabajando con servidores, en las que no disponemos de una interfaz gráfica por lo que debemos acudir a una herramienta en línea de comandos.

Para ello disponemos en entornos Linux de `fdisk`, una aplicación en línea de comandos con la que podremos obtener toda la información que necesitemos respecto a la organización lógica del disco duro, así como crear, eliminar, modificar y formatear particiones en los discos.

Como en todos los comandos que tienen parámetros obligatorios, si ejecutamos el comando sin parámetros obtendremos una ayuda rápida con un resumen de los parámetros aceptados por fdisk. Igualmente puedes acceder a la ayuda utilizando el parámetro `--help` o también utilizando el comando `man`.

```
vgonzalez@ubuntu:~$ fdisk --help

Usage:
 fdisk [options] <disk>      change partition table
 fdisk [options] -l [<disk>] list partition table(s)

Display or manipulate a disk partition table.

Options:
 -b, --sector-size <size>      physical and logical sector size
 -B, --protect-boot            don't erase bootbits when creating a new label
 -c, --compatibility[=<mode>]  mode is 'dos' or 'nondos' (default)
 -L, --color[=<when>]          colorize output (auto, always or never)
                                 colors are enabled by default
```
 

#### 4.3.1.- Listado de particiones

Lo primero que tenemos que hacer cuando vamos a trabajar con un disco duro es ejecutar el comando con el parámetro `–l`. Este parámetro hará que se nos muestre un listado de todos los discos que tenemos en el sistema, así como las particiones que hay en cada uno de los discos.
 
```
vgonzalez@SERVER2:~$ sudo fdisk -l
Disk /dev/loop0: 68.99 MiB, 72318976 bytes, 141248 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk /dev/loop1: 27.9 MiB, 28405760 bytes, 55480 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop2: 54.97 MiB, 57614336 bytes, 112528 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sda: 127 GiB, 136365211648 bytes, 266338304 sectors
Disk model: Virtual Disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 147DB9EF-F508-4ACA-8F25-1E00D2C93112

Device       Start       End   Sectors  Size Type
/dev/sda1     2048   2203647   2201600  1.1G EFI System
/dev/sda2  2203648 266336255 264132608  126G Linux filesystem


Disk /dev/sdb: 30 GiB, 32212254720 bytes, 62914560 sectors
Disk model: Virtual Disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
```

Si se quiere obtener información de un único disco habría que indicar como parámetro también el fichero de dispositivo asociado a dicho disco. Los ficheros de los dispositivos se encuentran todos en el directorio `/dev`, siendo los correspondientes a los discos duros aquellos que comienzan por `sd`.

Así por ejemplo para mostrar información únicamente del segundo disco del equipo debemos ejecutar el comando:

```
vgonzalez@SERVER2:~$ sudo fdisk -l /dev/sdb
Disk /dev/sdb: 30 GiB, 32212254720 bytes, 62914560 sectors
Disk model: Virtual Disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
```

De la información proporcionada la más reseñable es la siguiente:
- **Tamaño del disco**, indicada en GB, bytes y sectores.
- **Identificador del disco**, número de serie que identifica nuestro disco duro.
- **Particiones en el disco**, con la siguiente información de cada una:
    - **Dispositivo**: fichero en el directorio `/dev` que corresponde a dicha partición. Recuerda que los números del 1 al 4 corresponden a una partición primaria o extendida, mientras que números iguales o superiores a 5 corresponden a las particiones lógicas.
    - **Inicio**: el símbolo `*` señala la partición que está marcada como **activa**, es decir, la partición de arranque del sistema.
    - **Start, final y sectores**: primer y último sector, así como número de sectores, de la partición.
    - **Size**: tamaño de la partición indicado en megabytes (M) o gigabytes (G).
    - **Tipo**: tipo de partición de que se trata.


#### 4.3.2.- Trabajando con particiones

Una vez que hemos decidido el disco duro sobre el que queremos trabajar tenemos que ejecutar el comando **fdisk** pasándole como parámetro el identificador del disco. Esto lanzará el programa interactivo que se quedará esperando nuestras órdenes.
 
```
vgonzalez@SERVER2:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x3921f320.

Command (m for help):
```

La captura anterior corresponde a un disco que está sin inicializar por lo que nos indica que no dispone de tabla de particiones. 

El cursor parpadeante nos indica que el sistema está esperando a que introduzcamos una orden. Todas las órdenes de `fdisk` consisten en una letra. Para ver el listado de órdenes disponibles debemos introducir la orden `m`.

Si el disco no está inicializado el primer paso es crear la tabla de particiones. De los cuatro tipos disponibles podríamos elegir crear una **tabla de particiones GPT** (letra `g`) o una **tabla de particiones MBR** (letra `o`).

Una vez inicializado ya podemos empezar a trabajar con el disco. Veamos las opciones principales.

```
Command (m for help): m

Help:

  GPT
   M   enter protective/hybrid MBR

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table
```

##### 4.3.2.1.- Creación de una partición

Para crear una nueva partición debemos utilizar la orden `n`. Al hacerlo nos pedirá el tipo de partición que queremos crear: **primaria**, **extendida** o **lógica**. Como se ha comentado anteriormente el límite de particiones es de 4 primarias o de 3 primarias y 1 extendida.

En la siguiente captura no nos muestra la opción de crear lógicas porque aún no tenemos creada la partición extendida. Si ya la hubiéramos creado entonces nos permitiría elegir entre primarias y lógicas.

```
Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p):
```
 
Para crear una partición primaria pulsamos la tecla `p`, tras lo que nos pedirá el número de partición, es decir, en qué entrada de la tabla de particiones de almacenará dicha partición. Lo siguiente que nos pide es la dirección del primer sector de la partición. Si queremos que la partición se ubique en el primer espacio libre del disco simplemente pulsamos la tecla `Enter`.

Lo siguiente es el último sector de la partición (que por tanto determinará el tamaño). Aquí tenemos varias opciones:
- Pulsando la tecla `Enter` seleccionamos la opción por defecto, que es que ocupe  todo el espacio libre en el disco.
- Poniendo un número indicamos la dirección del último sector de la partición.
- También podemos indicar directamente el tamaño de la partición anteponiendo el símbolo más (`+`) a un número:
    - Cuando solo ponemos un número indicamos el tamaño de la partición en sectores. Hay que tener en cuenta que un sector tiene 512 bytes.
    - Si después del número ponemos una letra entonces el tamaño estará indicado en la unidad de medida que corresponda a la letra: kilobytes (K), megabytes (M), gigabytes (G), terabytes (T) o petabytes (P). 

Por ejemplo, el valor +500M crearía una partición de 500 MB.

Una vez hecho esto ya tendríamos creada nuestra partición.

```
Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-62914559, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-62914559, default 62914559): +100M

Created a new partition 1 of type 'Linux' and of size 100 MiB.
```

Hay que tener en cuenta que, al igual que pasa con los programas en entorno gráfico como *GParted*, no se escriben los cambios en el disco hasta apliquemos los cambios.

Para aplicar los cambios en `fdisk` debemos utilizar la orden `w` que escribirá todos los cambios a la tabla de particiones y saldrá del programa.

```
Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

##### 4.3.2.2.- Borrado de una partición

El proceso de borrado de una partición es mucho más sencillo. La orden correspondiente es `d` y el único valor que nos pide es el número de partición que deseamos eliminar. Nuevamente hasta que no utilicemos la orden `w` no escribirá los cambios en el disco, aun así hemos de ser cuidadosos ya que la eliminación de una partición implica perder todos los datos del disco.


##### 4.3.2.3.- Información de particiones

Dentro de `fdisk` disponemos de varias órdenes para obtener información de disco y sus particiones.
La orden `p` imprimirá la tabla de particiones del disco de forma análoga a como hacía la versión no interactiva de `fdisk` con el parámetro `–l`.

Si queremos información más detallada sobre una única partición entonces debemos utilizar la orden `i`. 
 
```
Command (m for help): i
Selected partition 1
         Device: /dev/sdb1
          Start: 2048
            End: 206847
        Sectors: 204800
      Cylinders: 49
           Size: 100M
             Id: 83
           Type: Linux
    Start-C/H/S: 0/32/33
      End-C/H/S: 12/223/19
```

Para ver el espacio libre que aún nos queda sin particionar tenemos que usar la orden `F` que nos indica la ubicación y tamaño del espacio sin particionar.
 
```
Command (m for help): F
Unpartitioned space /dev/sdb: 29.92 GiB, 32106348544 bytes, 62707712 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes

 Start      End  Sectors  Size
206848 62914559 62707712 29.9G
```


### 4.4.- Formatear y montar particiones

Hasta ahora hemos creado las particiones, pero como podrás observar no son accesibles de ninguna manera. Para ello necesitas realizar dos pasos: por un lado, debes **formatear** la partición con un sistema de ficheros, es decir, organizar la estructura interna de la partición para que el sistema operativo pueda trabajar con ella.

El segundo paso es **montar** la partición para que así pueda ser accesible desde el sistema.

#### 4.4.1.- Formateo de una partición

Como se comentó formatear una partición consiste en asignarle un sistema de ficheros para que el sistema operativo pueda trabajar con ella.

Hay múltiples sistemas de ficheros, pero los más comunes son **ext3** y **ext4** para Linux y FAT y NTFS para Windows.
Los comandos para formatear en ext3 y ext4 son `mkfs.ext3` y `mkfs.ext4` respectivamente y su sintaxis es muy sencilla. Únicamente debemos indicar la partición que queremos formatear y ya está. 

```
vgonzalez@SERVER2:~$ sudo fdisk -l /dev/sdb
Disk /dev/sdb: 30 GiB, 32212254720 bytes, 62914560 sectors
Disk model: Virtual Disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x3921f320

Device     Boot Start    End Sectors  Size Id Type
/dev/sdb1        2048 206847  204800  100M 83 Linux
vgonzalez@SERVER2:~$ sudo mkfs.ext4 /dev/sdb1
mke2fs 1.45.5 (07-Jan-2020)
Discarding device blocks: done
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

Si quisiéramos formatear la partición en FAT porque queremos que sea accesible desde Windows necesitamos comprobar que esté instalado el paquete `dosfstools` e instalarlo en caso de que no estuviera.

La orden para formatear en FAT será:

```
vgonzalez@SERVER2:~$ sudo mkfs.vfat -F 32 -n DATOS /dev/sdb1
mkfs.fat 4.1 (2017-01-24)
```

El parámetro `–F` sirve para indicar el tamaño de la FAT, en este caso estamos asignando el formato FAT32. El parámetro `–n` sirve para indicar la etiqueta del disco. Para evitar problemas es conveniente que esta etiqueta esté en mayúsculas.

De forma análoga, el comando para formatear en NTFS es `mkfs.ntfs` y su funcionamiento es análogo a los que ya hemos visto.


#### 4.4.2.- Montaje de dispositivos

Como se vio anteriormente Linux combina todos los dispositivos de almacenamiento en un único directorio virtual. Antes de utilizar un nuevo disco en el sistema necesitas localizarlo en el directorio virtual. Esta tarea se denomina **montaje**.

La mayoría de las actuales distribuciones Linux montan automáticamente algunas unidades como las unidades de CD o memorias USB.

El comando utilizado para montar dispositivos es el comando `mount`. Por defecto `mount` muestra una lista de los dispositivos actualmente montados en el sistema.

```
vgonzalez@SERVER2:~$ mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
udev on /dev type devtmpfs (rw,nosuid,noexec,relatime,size=937188k,nr_inodes=234297,mode=755)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,noexec,relatime,size=196436k,mode=755)
/dev/sda2 on / type ext4 (rw,relatime)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
tmpfs on /run/lock type tmpfs (rw,nosuid,nodev,noexec,relatime,size=5120k)
```

La información que proporciona el comando `mount` es:

- La localización del dispositivo
- El punto de montaje en el directorio virtual 
- El tipo de sistema de ficheros
- El estado de acceso del dispositivo montado

Por ejemplo, la sexta entrada hace referencia a una partición del disco duro (sda1). El fichero que representa al dispositivo es `/dev/sda1` y está montado en el directorio raíz (`/`). El tipo del sistema de ficheros es ext4. Al final de la línea se muestra otra información del dispositivo como por ejemplo que es de lectura y escritura (rw, read and write).

```
/dev/sda1 on /boot/efi type ext4 (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro)
```

Para montar un dispositivo manualmente primero debes tener privilegios de administrador. La sintaxis del comando `mount` es:

```
    mount –t tipo dispositivo directorio
```

Los parámetros son:
- El parámetro **tipo** indica el sistema de ficheros con el que está formateado el dispositivo. Linux reconoce un gran número de sistemas de ficheros, algunos ejemplos son ext3 o ext4 nativos de Linux, vfat que es el sistema utilizado por Windows en versiones antiguas o en memorias USB, ntfs, el sistema de ficheros de Windows 2000 y posteriores o iso9660, utilizado en los CDs.
- Los siguientes dos parámetros definen la **localización del dispositivo** (los dispositivos en Linux se asocian con un archivo en el directorio `/dev`) y el **directorio** donde queremos montarlo. El usuario **root** debe tener acceso a este directorio, pero se puede limitar el acceso a otros usuarios mediante permisos.
- 
Los modificadores del comando `mount` son las siguientes:

| Modificador   | Descripción |
| ------------- | ----------- |
| `-a`          | Monta todos los sistemas de fichero que hay en `/etc/fstab` |
| `-F`          | Usado junto con `-a`, fuerza a que todos los dispositivos se monten simultáneamente |
| `-s`          | Ignora las opciones de montaje no soportadas por el sistema de ficheros |
| `-r`          | Monta el sistema de ficheros como de solo lectura |
| `-w`          | Monta el sistema de ficheros como lectura/escritura (por defecto) |
| `-o`          | Añade opciones específicas |


La última opción (`-o`) permite indicar una serie de opciones adicionales separadas por comas, estas pueden ser:

- `ro`: montar como dispositivo de solo lectura
- `rw`: montar como dispositivo de lectura-escritura
- `user`: permite a un usuario montar el sistema de ficheros
- `check=none`: omite la comprobación de integridad del sistema de ficheros.
- `loop`: permite montar un fichero en lugar de un dispositivo.
  
La última opción nos permite montar un fichero que sea una imagen de un dispositivo, por ejemplo, un fichero **ISO**, tal y como se puede ver en la siguiente imagen.

```
vgonzalez@ubuntu:~$ sudo mount -t iso9660 -o loop slacko-6.3.0.iso /mnt
mount: /mnt: /home/vgonzalez/Descargas/slacko-6.3.0.iso ya está montado
```

Una vez que hemos acabado de utilizar el dispositivo podemos desmontarlo con la orden `umount`. Este comando admite como parámetro o bien la ruta del dispositivo o bien el directorio donde está montado.


#### 4.4.3.- Montaje automático mediante el fichero `fstab`

En el apartado anterior hemos visto como montar dispositivos desde la línea de comandos, pero este método tiene un inconveniente, y es que el dispositivo únicamente permanecerá montado hasta que apaguemos el equipo, debiendo volver a montarlo cada vez que iniciemos el ordenador.

Para solventar este problema disponemos de un fichero de configuración, denominado `/etc/fstab`, que permite montar automáticamente dispositivos al iniciar el equipo. Si echamos un vistazo al contenido del fichero obtendremos una salida similar a la siguiente:
 
```
vgonzalez@ubuntu:~$ cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/ubuntu-vg/ubuntu-lv during curtin installation
/dev/disk/by-id/dm-uuid-LVM-YnQUuezDmVtsGdYZJwBpgmvchFc7eKuTK8ozZ5tkAXck9iKn9rFA1XQxZ8Opou8n / ext4 defaults 0 1
# /boot was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/534fe6b9-63bf-4754-8ce7-6ac3ed824798 /boot ext4 defaults 0 1
# /boot/efi was on /dev/sda1 during curtin installation
/dev/disk/by-uuid/AB9A-681C /boot/efi vfat defaults 0 1
/swap.img       none    swap    sw      0       0
```

Todas las líneas que comienzan con el carácter almohadilla son comentarios. Si obviamos los comentarios podremos ver que hay tres líneas que corresponden a las tres particiones creadas durante la instalación del sistema. El siguiente fragmento corresponde a la partición identificada como `/dev/sda5` durante el arranque.

```
# <file system> <mount point>    <type> <options>         <dump>   <pass>
# /was on /dev/sda5 during installation
UUID=1b6887d4-65ab-4796-887b-0e47e4b7939c  /              ext4      errors=remount-ro 0       1

```
En ella podemos apreciar los siguientes campos, separados por espacios o tabuladores:

**`<file system>`**

El primer campo es el identificador del dispositivo. Es reseñable ver que el dispositivo está identificado por el **Identificador Único Universal (UUID)** en lugar de la representación habitual de la forma `/dev/sda5`. En realidad, también sería válido identificar los discos de esta forma, pero tiene un inconveniente, y es que está condicionada por la ubicación física del hardware. 

Supongamos que este disco duro está ubicado en el conector SATA3 de la placa base, si conectáramos otro disco en el conector SATA1, esto nuevo disco pasaría a ser `/dev/sda`, pasando a identificarse nuestro disco anterior como `/dev/sdb`. 

Para evitar este problema es aconsejable utilizar el **UUID**, que es un valor numérico que identifica de forma inequívoca cada disco y partición. Si queremos saber el UUID de nuestros dispositivos de almacenamiento podemos utilizar el comando `blkid`.
 
**`<mount point>`**

En este campo se indica el directorio en el que se montará el dispositivo. Por supuesto, este directorio deberá existir.

**`<type>`**

En el siguiente campo se indica el sistema de ficheros con el que hemos formateado la partición, habitualmente ext4.

**`<options>`**

Aquí se indican las opciones de montaje del dispositivo, indicadas como una lista separada por comas. Por defecto, el directorio raíz se monta con las opciones `errors=remount-ro`, que indica que si ocurre algún error el sistema se debe remontar como sistema de solo lectura.

Para añadir otros dispositivos que no sean el directorio raíz, se suele utilizar la opción `defaults`, que engloba las siguientes opciones:

- `rw`: el sistema será de lectura y escritura.
- `exec`: permite que los archivos de este sistema de ficheros se puedan ejecutar.
- `auto`: monta automáticamente el dispositivo en el arranque. La opción opuesta sería noauto, que indica que el dispositivo no se debe montar automáticamente en el arranque.
- `nouser`: solo el usuario root puede montar este sistema de ficheros. Si queremos que cualquier usuario pueda montar el sistema de ficheros podemos usar la opción user.
- `async`: la salida al dispositivo debe ser asíncrona.

Sin embargo, estas opciones se pueden adaptar según nuestras necesidades. Por ejemplo, si los usuarios no necesitan cambiar el contenido de los archivos es preferible montar el dispositivo como de sólo lectura con la opción `ro`. De esta forma podríamos evitar el borrado accidental de los datos por parte de estos. O si por ejemplo tenemos una partición destinada a contener copias de seguridad podríamos utilizar la opción `noexec` para impedir que un usuario malintencionado pueda lanzar un script desde dicha unidad.

**`<dump>`**

Este campo puede tener el valor 0 o 1 siendo lo más frecuente el primero. Antiguamente se utilizaba para indicar a las aplicaciones de copia de seguridad si había que realizar copia de seguridad de esta partición (valor 1) o no (valor 0). Pero en la actualidad no es utilizado por lo que siempre dejaremos el valor 0.

**`<pass>`**

Este campo puede contener los valores 0, 1, o 2 y hace referencia al orden en que se comprobarán los sistemas de ficheros cuando utilicemos el comando `fsck`. El valor 0 indica que el sistema de fichero no se comprobará, los que tienen el valor 1 se comprobarán los primeros y el valor 2 indica que son los ficheros que menos prioridad tienen. Por regla general, se pondrá el valor 1 para el sistema de ficheros principal y 2 para el resto.

Una vez que hemos configurado el fichero `fstab` ya podremos montar automáticamente los dispositivos. Esto realizará durante el inicio del sistema o también podemos forzarlo utilizando el comando mount `-a`, el cual montará todos los dispositivos que hayamos marcado con la opción `auto`.

Si queremos montar dispositivos con la opción `noauto` deberemos hacerlo explícitamente, ejecutando el comando `mount` y pasando como parámetro el punto de montaje.


***




### 4.5.- Logical Volume Manager (LVM)

**LVM (Logical Volume Manager)** es una herramienta para la gestión de volúmenes lógicos en Linux. Facilita la administración de espacio de disco permitiendo operaciones como redimensionar volúmenes sin detener el sistema, agregar nuevos discos o realizar snapshots de volúmenes.

Las principales ventajas de LVM son:

- Redimensionado dinámico de particiones (extensión o reducción).
- Soporte para snapshots.
- Agrupación de discos físicos en un único volumen lógico.

Cuando hablamos de LVM hay tres conceptos que hay que tener muy claros:

- **Volumen físico (PV)**: un volumen físico es el disco duro o partición que se añadirá al sistema LVM, es decir, corresponde a un dispositivo hardware de nuestro sistema.

- **Grupo de volúmenes (VG)**: un grupo de volúmenes es una agrupación de volúmenes físicos, que forman un espacio común desde el cual se crean los volúmenes lógicos.

- **Volumen lógico (LV)**: el volumen lógico es el equivalente a una partición que se utiliza para almacenar datos, y se crea desde un grupo de volúmenes.

Veamos algunas funciones básicas que se pueden realizar con LVM.

#### 4.5.1.- Creación de volúmenes lógicos

El proceso de trabajo con LVM es el siguiente:

- Primero convertimos todos los discos físicos que queramos pasar a LVM en volúmenes físicos, para los que debemos utilizar el comando `pvcreate`.

```bash
$ pvcreate /dev/sdb
```

- El siguiente paso es la creación de grupos de volúmenes. Cada grupo de volúmenes está formado por la agregación de uno o varios volúmenes físicos. Además, podemos crear tantos grupos de volúmenes como queramos, identificado cada uno por un nombre.

```bash
$ vgcreate mi_vg /dev/sdb /dev/sdc
```

- Ahora podemos extraer volúmenes lógicos de de un grupo de volúmenes con la orden `lvcreate`.

```bash
$ lvcreate -L 10G -n mi_lv mi_vg
```

- Por último, ya podemos formatearlo y montarlo de forma análoga a como hacíamos con las particiones.

```bash
$ mkfs.ext4 /dev/mi_vg/mi_lv
$ mount /dev/mi_vg/mi_lv /mnt
```









---
---

[Volver al índice de la unidad](index.md)

[Volver al índice del módulo](../../index.md)