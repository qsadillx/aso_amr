# UT02: INSTALACIÓN Y PUESTA EN MARCHA DE LINUX SERVER

## 3.- Conexión remota con SSH

## Índice

- 3.1.- [Secure Shell (SSH)](#21--secure-shell-ssh)
- 3.2.- [Conexión gráfica con SSH](#22--conexión-gráfica-con-ssh)
- 3.3.- [SSH con chrooted jail](#23--ssh-con-chrooted-jail)


### 3.1.- Secure Shell (SSH)

**SSH (Secure Shell)** es un protocolo que facilita las comunicaciones seguras entre dos sistemas utilizando una arquitectura cliente/servidor y que permite a los usuarios conectarse a un host remotamente. Su diferencia con respecto a otros protocolos, como Telnet o FTP, es que encripta la sesión de conexión, haciendo imposible que alguien pueda obtener contraseñas. Por defecto utiliza el **puerto 22**.

#### 3.1.1.- Conexión mediante SSH

SSH es un protocolo cuya función principal es el acceso remoto a un servidor por medio de un canal seguro en el que toda la información está encriptada. Algunas de las posibilidades de SSH son:

- Acceso a una terminal cifrada en otros equipos.
- Copiar datos de forma segura (tanto archivos sueltos como simular sesiones FTP cifradas)
- Gestionar claves RSA para no tener que escribir contraseñas al conectar a los dispositivos
- Pasar los datos de cualquier otra aplicación por un canal seguro tunelizado mediante SSH
- Redirigir el tráfico del sistema X Window para poder ejecutar programas gráficos remotamente.


#### 3.1.2.- Preparación del servidor SSH

Para que un equipo acepte conexiones SSH debe tener instalado el servicio, por lo que el primer paso será instalar el paquete `openssh-server`. 

Los ficheros de configuración SSH se encuentran todos en el directorio `/etc/ssh`.
 
```bash
    victor@DESKTOP-483UVTV:~$ ls /etc/ssh
    moduli  ssh_config  ssh_config.d  ssh_import_id  sshd_config  sshd_config.d
```

El fichero que necesitamos para configurar el servidor es `sshd_config`. Ten cuidado no lo confundas con el fichero `ssh_config`, de nombre muy similar pero que sirve para configurar el cliente.

Por seguridad, es buena idea crear una copia del fichero de configuración antes de modificarlo para poder revertir los cambios en caso de realizar una configuración incorrecta.

Como tantos otros ficheros de configuración en Linux, dispone de un gran número de opciones la mayoría de las cuales están por defecto comentadas para que no se apliquen. Algunas de estas opciones que nos pueden interesar son:

- `Port`: un valor diferente a 22 cambiará el puerto por el que escucha el servidor.
- `ListenAddress`: si el equipo tiene varias interfaces de red, se puede especificar exactamente por cuáles responderá a las peticiones SSH entrantes. Si se va a indicar más de una dirección se indicará una en cada línea.
- `LoginGraceTime`: el servidor desconectará después del tiempo indicado si el usuario no ha iniciado sesión con éxito. Si el valor es 0 no tendrá límite.
- `PermitRootLogin`: si el valor está establecido en no, el usuario root no podrá acceder de forma remota.
- `PasswordAuthentication`: especifica si está permitida la autenticación por contraseña.
- `PermitEmptyPasswords`: si está habilitada la autenticación por contraseña, indica si el servidor permite iniciar sesión a cuentas sin contraseña. El valor por defecto es no.
- `AllowUser`: toma como valor una lista de nombres de usuario, permitiendo el inicio de sesión únicamente a los usuarios cuyo nombre esté en dicha lista. Es posible indicar el usuario de la forma USER@HOST para permitir a usuarios de determinados equipos.
- `DenyUsesr`: de forma análoga al anterior, contiene una lista de usuarios a los que no se les permitirá iniciar sesión remota.
- `Banner`: toma como valor el nombre de un fichero (por defecto /etc/issue.net). El contenido de este fichero es mostrado en el equipo que se intenta conectar antes de la autenticación
  
Recuerda que, como siempre que cambiamos un fichero de configuración, debemos reiniciar el servicio para que se apliquen los cambios.


#### 3.1.3.- Preparación del cliente

En la mayoría de las distribuciones de Linux ya está instalado el cliente. El comando se llama `ssh` y espera como parámetros el nombre de usuario, la IP del equipo remoto y opcionalmente el puerto (modificador `-p`)
 
#### 3.1.4.- Acceso SSH con clave pública

El problema del proceso anterior es que **solicita la contraseña** cada vez que conectamos. Este proceso se puede simplificar si configuramos el acceso SSH con clave pública.

Este proceso comprende tres pasos:

- Generación de un par de claves pública/privada en el cliente
- Envío de la clave pública al servidor
- Deshabilitar el acceso al servidor con contraseña
- 
El primer paso es **generar un par de claves** para lo que utilizaremos el comando `ssh-keygen`. A este comando se le puede pasar el parámetro `-b` para indicar el tamaño en bit de la clave que queremos generar.

```
remote@ubuntu:~$ ssh-keygen -b 1024
Generating public/private rsa key pair.
Enter file in which to save the key (/home/remote/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/remote/.ssh/id_rsa
Your public key has been saved in /home/remote/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:B1XXDy9v1vmrTkqm3//oeABHzMKotQi3EJsE13k+6g0 remote@ubuntu
The key's randomart image is:
+---[RSA 1024]----+
|  ..+o . o.+. .. |
|   ooo+ +.o +.. .|
|    o+ B.. o   o.|
|      + +.. . . o|
|       .S..o   oo|
|      E  .  .  .=|
|     . o   o o o.|
|      . . + +....|
|         ..oo*=o+|
+----[SHA256]-----+
```

Por defecto, las claves se guardan en el directorio `~/.ssh`. En este directorio verás dos ficheros, uno que contiene la **clave pública** (`id_rsa.pub`) y el otro con la **clave privada** (`id_rsa`). 

Podemos ver el contenido de ambos ficheros ya que la clave, que es un valor binario, está protegida por una **armadura ASCII** para que pueda mostrarse en modo texto.

```
remote@ubuntu:~$ cat ~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDeHkF6GFQyMlK44ReOjzfTXS68lHfCEkBtmBYKtezgzrJ7dGHTMJ5rrpcMm/za+f2Kvz4VE0m9KpfKKcYhvxLa3P5N2pWAUMUIfPIHayG1ueQgD8P7GJFgq2Q7Bf5vGYW9rGpIn45koGWMnyqc99jMH31229aQ30pHGAtJpaJMsw== remote@ubuntu
```

El segundo paso que hay que realizar es **enviar la clave pública al servidor**. Esto lo podemos hacer por cualquier medio (correo electrónico, una memoria USB o incluso tecleándolo), pero vamos a ver como enviarlo directamente de un equipo a otro utilizando el comando `scp`, el cual permite transferir ficheros entre dos equipos de la red.
 
```
SCP(1)                                                 BSD General Commands Manual                                                SCP(1)

NAME
     scp — OpenSSH secure file copy

SYNOPSIS
     scp [-346BCpqrTv] [-c cipher] [-F ssh_config] [-i identity_file] [-J destination] [-l limit] [-o ssh_option] [-P port] [-S program]
         source ... target

DESCRIPTION
     scp copies files between hosts on a network.  It uses ssh(1) for data transfer, and uses the same authentication and provides the
     same security as ssh(1).  scp will ask for passwords or passphrases if they are needed for authentication.

     The source and target may be specified as a local pathname, a remote host with optional path in the form [user@]host:[path], or a
     URI in the form scp://[user@]host[:port][/path].  Local file names can be made explicit using absolute or relative pathnames to
     avoid scp treating file names containing ‘:’ as host specifiers.
```

El comando `scp` utiliza el protocolo SSH para enviar los ficheros, por lo que es conveniente que hayamos comprobado que funciona con contraseña antes de enviar los ficheros. Se le deben indicar como parámetros el nombre del fichero que queremos transferir y el nombre del fichero de destino, pero con el siguiente formato: `USER@HOST:FILENAME`
 
```
remote@SERVER2:~/.ssh$ scp ./id_rsa.pub remote@10.0.0.1:id_rsa.remote.pub
remote@10.0.0.1's password:
id_rsa.pub                                                                            100%  569     1.3MB/s   00:00
remote@SERVER2:~/.ssh$
```

En el código anterior se está copiando el fichero `id_rsa.pub` desde el directorio de trabajo del equipo local al equipo con IP 10.0.0.1 utilizando las credenciales del usuario llamado `remote`. La ruta donde se guardará es el directorio personal del usuario (`/home/remote`) y, si te fijas, se indica un nombre diferente del fichero para renomobrarlo, de forma que en el equipo remoto se sepa a quien pertence esa clave pública.

Una vez subidas vamos al servidor donde debemos incluirlas en el fichero `~/.ssh/authorized_keys`.  Lo normal es que no exista ni el fichero ni tal vez el directorio que lo contiene, por lo que deberemos crearlo. Tras crear el archivo copiamos la clave en él.

```
remote@server-1:~$ ls -la
total 36
drwxr-xr-x 4 remote remote 4096 May 22 06:15 .
drwxr-xr-x 4 root   root   4096 May 22 06:03 ..
-rw------- 1 remote remote   12 May 22 06:04 .bash_history
-rw-r--r-- 1 remote remote  220 May 22 06:03 .bash_logout
-rw-r--r-- 1 remote remote 3771 May 22 06:03 .bashrc
drwx------ 2 remote remote 4096 May 22 06:04 .cache
-rw-r--r-- 1 remote remote  807 May 22 06:03 .profile
drwxrwxr-x 2 remote remote 4096 May 22 06:15 .ssh
-rw-r--r-- 1 remote remote  569 May 22 06:08 id_rsa.remote.pub
remote@server-1:~$ mkdir .ssh
remote@server-1:~$ cat id_rsa.remote.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtoQP98FmYRtbE3Fkuy9AVpCJV8yAlot1tHOjYPrXO7PA2dgK2JGN3kPZ5L8qTKUx/EOXl3aH0lZhyrtr3gkQeWKtUGeQ2qOcWMcxYf4TF1xvSJ8qOCbdehsGvXkH3/O3NSf3OHeSomHwEV74jl5tFDWVPkLmT4zuPnsVYfbbZxzPxFWpQtKwksXBkjLkgjdb3C9jvEayNALdOZiqrsQmmrvaB+1tc0KF7Ky/vH5uh/j+lYk0L05vVLtIMD4A+suKaOlrHzvMfkuAdLZXX88OIsZRdjfcdsIiPYm16I+ARCjyzTrsGKbok9fYfWNt9B1vaqQm5XypPNn+PzdXJDt6mZjMmdstushmOmYo1I5DlJ4xhlbSffkDHfGjQp8N/N4TfLtms6vB5HvX2TnLrJMHPd+4Z/tQKX7S821LdpRwJcpl8dqeUk+acX4p+10xwAKeR3wIu+7YzekFzUKIM3UZdSnJq8IUF3cDE9kEjTnkK+sl5w9zGAFoMxBvHzfXPHT8= remote@server-1
remote@server-1:~$ cat id_rsa.remote.pub >> .ssh/authorized_keys
```

Para aumentar la seguridad podemos **deshabilitar el acceso SSH con contraseña**. Para ello editamos el fichero `/etc/ssh/sshd_config` y modificar la siguiente línea. 
 
```bash
#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

PubkeyAuthentication yes

# Expect .ssh/authorized_keys2 to be disregarded by default in future.
#AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no
#PermitEmptyPasswords no

```

Y ya podremos conectarnos al equipo remoto sin necesidad de introducir las credenciales.

```
remote@SERVER2:~$ ssh remote@10.0.0.1
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-110-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun May 22 06:21:10 UTC 2022

  System load:  0.0                Processes:             116
  Usage of /:   3.6% of 123.47GB   Users logged in:       1
  Memory usage: 16%                IPv4 address for eth0: 172.29.2.58
  Swap usage:   0%                 IPv4 address for eth1: 10.0.0.1


0 updates can be applied immediately.


*** System restart required ***
Last login: Sun May 22 06:05:53 2022 from 10.0.0.2
```

### 3.2- Conexión gráfica con SSH

Otra posibilidad es realizar una conexión a un entorno gráfico utilizando un túnel SSH. Para conseguir esto debemos configurar primero el servidor para que tenga habilitado el *X11 Forwarding*, que permite enviar la interfaz gráfica a través de la red usando SSH.

Para ello, únicamente debemos asegurarnos de que el fichero de configuración del servidor tiene habilitada la opción X11Forwarding.

```bash
#GatewayPorts no
X11Forwarding yes
#X11DisplayOffset 10
```

 
#### 3.2.1.- Conexión desde un cliente Linux

Lo más sencillo es configurar la conexión desde una máquina Linux, en este caso simplemente hay que utilizar el modificador -X al invocar el comando ssh desde el cliente.
 
Al ejecutar este comando nos mostrará la terminal del servidor, pero la diferencia es que si ejecutamos un programa del servidor que requiera entorno gráfico, lo lanzará en una ventana en la máquina cliente. Por ejemplo, si queremos acceder al sistema de ficheros en un Linux Mint podemos invocar el administrador de archivos Nemo.
 


#### 3.2.2.- Conexión gráfica desde un cliente Windows

Si queremos conectarnos a un entorno gráfico desde un cliente Windows, debemos hacerlo con **Putty**, pero necesitamos un programa adicional, **Xming**, que puedes descargar de [Sourceforge](https://sourceforge.net/projects/xming/).
Tras descargarlo e instalarlo, se puede configurar yendo a Inicio -> XLaunch.
Con esta aplicación podrás seleccionar cómo quieres que se muestren las ventanas, como se va a lanzar el programa o como ser va a gestionar el portapapeles.
Una vez instalado y configurado a nuestro gusto hay que utilizar Putty para iniciar la conexión SSH. Al igual que desde Linux teníamos que habilitar el IP Forwarding. En este caso hay que ir a Connection -> SSH -> X11 y marcar la casilla Enable IP Forwarding.
 
Tras hacerlo, establecer una conexión tal y como la hemos hecho otras veces. Al igual que cuando nos conectamos desde Linux, accederemos a una terminal en la que, si introducimos un comando que requiera entorno gráfico, abrirá una ventana en nuestra máquina Windows cliente.



### 3.3.- SSH con **chrooted jail**  (Incompleto)

Algo en lo que te habrás fijado al configurar el acceso SSH a un servidor para diferentes usuarios es que cualquier usuario que se conecte mediante SSH podrá ver todos los ficheros del sistema de ficheros, incluso los de otros usuarios. Indudablemente, este comportamiento no es deseable en entornos en que múltiples usuarios comparten el acceso a un mismo servidor, por ejemplo, en un servidor web.

La técnica que permite solventar este problema se denomina **jaula chroot (*chroot jail*)** y se basa en el comando `chroot`, el cual sirve para ejecutar un proceso bajo un **directorio raíz simulado**, de manera que dicho proceso no pueda acceder a ficheros fuera de ese directorio.

Veamos los pasos para conseguir esto .


#### 2.3.1.- Crear el SSH chroot jail

Comenzamos creando el directorio al que restringiremos el acceso al usuario. En este caso el usuario que tendrá acceso remoto se llamará `jailed_user`.

```bash
admin@server:~$ sudo adduser jailed_user
```


En el fichero de configuración `sshd_config`, hay una entrada denominada `ChrootDirectory` que es la que utilizaremos. Podemos ir a la página del manual de `sshd_config` y buscar la parte correspondiente a esta entrada.
 
```
ChrootDirectory
     Specifies the pathname of a directory to chroot(2) to after authentication.
     At session startup sshd(8) checks that all components of the pathname are
     root-owned directories which are not writable by any other user or group.
     After the chroot, sshd(8) changes the working directory to the user's home
     directory.  Arguments to ChrootDirectory accept the tokens described in the
     TOKENS section.
     The ChrootDirectory must contain the necessary files and directories to sup‐
     port the user's session.  For an interactive session this requires at least
     a shell, typically sh(1), and basic /dev nodes such as null(4), zero(4),
     stdin(4), stdout(4), stderr(4), and tty(4) devices.  For file transfer ses‐
     sions using SFTP no additional configuration of the environment is necessary
     if the in-process sftp-server is used, though sessions which use logging may
     require /dev/log inside the chroot directory on some operating systems (see
     sftp-server(8) for details).
     For safety, it is very important that the directory hierarchy be prevented
     from modification by other processes on the system (especially those outside
     the jail).  Misconfiguration can lead to unsafe environments which sshd(8)
     cannot detect.
     The default is none, indicating not to chroot(2).
```

Si te fijas, nos indica que el directorio que indiquemos debe contener, por lo menos, un shell y los nodos básicos de `/dev` tales como los dispositivos `null`, `zero`, `stdin`, `stdout`, `stderr` y `tty`.

Busquemos primero estos ficheros en el directorio `/dev`.

```bash
admin@server:~$ ls -l /dev/{null,zero,stdin,stdout,stderr,random,tty}
crw-rw-rw- 1 root root 1, 3 Oct  5 06:55 /dev/null
crw-rw-rw- 1 root root 1, 8 Oct  5 06:55 /dev/random
lrwxrwxrwx 1 root root   15 Oct  5 06:55 /dev/stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root   15 Oct  5 06:55 /dev/stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root   15 Oct  5 06:55 /dev/stdout -> /proc/self/fd/1
crw-rw-rw- 1 root tty  5, 0 Oct  5 06:55 /dev/tty
crw-rw-rw- 1 root root 1, 5 Oct  5 06:55 /dev/zero
```
 
De la anterior imagen nos interesan los números que se encuentran entre el grupo propietario y la fecha de creación. Estos números se denominan **número mayor** y **menor** y son propios de los ficheros de dispositivo (más información sobre estos números [aquí](https://www.oreilly.com/library/view/linux-device-drivers/0596000081/ch03s02.html))

- El **número mayor** identifica el driver asociado con el dispositivo. Por ejemplo, el dispositivo `/dev/null` utiliza el driver 1. El kernel utiliza el número mayor cuando abre el dispositivo para ejecutar el driver correspondiente.
- El **número menor** es utilizado únicamente por el driver especificado por el número mayor. Esto se debe a que un driver suele controlar diversos dispositivos y este número le permite saber con cuál de ellos está tratando.
Una vez que conocemos los números mayor y menor de los dispositivos que queremos copiar tenemos que crear estos ficheros de dispositivos dentro de nuestro directorio. Para ello utilizaremos el comando `mknod`, que permite crear ficheros especiales de bloques o de caracteres. 

La sintaxis de este comando es:
 
 ```
mkdon [OPTION]... NAME TYPE [MAJOR MINOR]
 ```

Donde tipo puede ser `c` para indicar un dispositivo de caracteres y `b` si es un dispositivo de bloques. También usaremos el modificador `-m` para indicar los permisos que tendrá el fichero (en este caso todos).

```bash
admin@server:~$ sudo mkdir -p /home/jailed_user/dev/
admin@server:~$ cd /home/jailed_user/dev/
admin@server:/home/jailed_user/dev$ sudo mknod -m 666 null c 1 3
admin@server:/home/jailed_user/dev$ sudo mknod -m 666 tty c 5 0
admin@server:/home/jailed_user/dev$ sudo mknod -m 666 zero c 1 5
admin@server:/home/jailed_user/dev$ sudo mknod -m 666 random c 1 8
```

A continuación, hay que asignar permisos a la jaula chroot. Fíjate que la jaula chroot y sus subdirectorios deben pertenecer al usuario root, y no deben tener permisos de escritura para ningún otro usuario normal o grupo.

```bash
admin@server:~$ sudo chown root:root /home/jailed_user/
admin@server:~$ sudo chmod 0755 /home/jailed_user/
admin@server:~$ ls -ld /home/jailed_user/
drwxr-xr-x 3 root root 4096 Oct  5 07:04 /home/jailed_user/
```

 
#### 2.3.2.- Configurar el shell interactivo

Ahora vamos a crear el directorio `bin` y copiar en él los ficheros `/bin/bash` de la siguiente forma:
 
```bash
admin@server:~$ sudo mkdir -p /home/jailed_user/bin
admin@server:~$ sudo cp -v /bin/bash /home/jailed_user/bin
'/bin/bash' -> '/home/jailed_user/bin/bash'
```

Hay que tener en cuenta que Bash utiliza librerías para su funcionamiento, por lo que tendremos que copiarlas en el directorio lib. Para saber qué librerías utiliza un programa tenemos el comando `ldd`.

```bash
admin@server:~$ ldd /bin/bash
        linux-vdso.so.1 (0x00007ffe859e2000)
        libtinfo.so.6 => /lib/x86_64-linux-gnu/libtinfo.so.6 (0x00007f7668670000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f766866a000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f7668478000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f76687d5000)
admin@server:~$ sudo mkdir -p /home/jailed_user/lib64
admin@server:~$ sudo cp -v /lib/x86_64-linux-gnu/{libtinfo.so.6,libdl.so.2,libc.so.6} /home/jailed_user/lib64
   '/lib/x86_64-linux-gnu/libtinfo.so.6' -> '/home/jailed_user/lib64/libtinfo.so.6'
   '/lib/x86_64-linux-gnu/libdl.so.2' -> '/home/jailed_user/lib64/libdl.so.2'
   '/lib/x86_64-linux-gnu/libc.so.6' -> '/home/jailed_user/lib64/libc.so.6'
admin@server:~$ sudo cp -v /lib64/ld-linux-x86-64.so.2 /home/jailed_user/lib64
   '/lib64/ld-linux-x86-64.so.2' -> '/home/jailed_user/lib64/ld-linux-x86-64.so.2'
```

#### 2.3.3.- Crear y configurar el usuario ssh

Ahora vamos a crear el comando `useradd` para crear el usuario. Ten en cuenta que este comando difiere del comando adduser en que no hace nada que no le indiquemos explícitamente en los parámetros (crear el directorio personal, crear la contraseña, …). Por tanto, para ponerle contraseña, debemos utilizar también el comando `passwd`.
 
```bash
admin@server:/home/jailed_user$ sudo useradd user
admin@server:/home/jailed_user$ sudo passwd user
New password:
Retype new password:
passwd: password updated successfully
```

También debemos guardar una copia de los ficheros de configuración en nuestra jaula, en concreto, los ficheros `/etc/passwd` y `/etc/group`,

```bash
admin@server:/home/jailed_user$ sudo mkdir /home/jailed_user/etc
admin@server:/home/jailed_user$ sudo cp -vf /etc/{passwd,group} /home/jailed_user/etc/
   '/etc/passwd' -> '/home/jailed_user/etc/passwd'
   '/etc/group' -> '/home/jailed_user/etc/group'
```

**Nota**: cada vez que se añada un usuario SSH nuevo tienes que copiar estos ficheros actualizados.


#### 2.3.4.- Configurar SSH para que utilice la jaula SSH

Ahora vamos al fichero de configuración `sshd_config` y añadimos las siguientes líneas:

```bash
# Definimos el usuario al que aplicaremos la jaula chroot
Match User user
# Especificamos la jaula chroot
ChrootDirectory /home/jailed_user
```

Tras ello solo queda reiniciar el servicio SSH.

#### 2.3.5.- Crear el directorio home del usuario ssh y añadir comandos

Ahora ya podemos probar a conectarnos con el usuario mediante SSH. Si nos conectamos veremos que lo podemos hacer sin ningún problema, pero unas pocas pruebas nos mostrarán que hay algunos comandos de Linux que no funcionan en nuestro entorno.
 
Esto se debe a que, como el usuario está encerrado en la jaula chroot únicamente podrá acceder a comandos internos (builtin) de Bash, tales como `pwd`, `cd`, … pero no a comandos externos como `ls` o `date`. En un sistema normal, estos comandos se encuentran en el directorio `/bin`, y, como es un directorio fuera de la jaula, el usuario no podrá acceder a él.

Pero antes de eso vamos a crear un directorio personal para el usuario dentro de la jaula chroot. Esto lo hacemos con las siguientes órdenes:
 
Una vez creado el directorio personal vamos a crear el directorio bin y copiar en él los comandos que queramos que tenga el usuario.
 
Al igual que nos pasó con bash, estos comandos también pueden requerir librerías externas, por lo que tendremos que copiarlas a nuestra jaula. Recuerda que el comando para verificar qué librerías requiere un comando es `ldd`.
 
 
Si probamos ahora ya veremos que el usuario puede acceder sin problemas mediante SSH y utilizar cualquier comando integrado de Bash o los comandos externos que hayamos añadido manualmente.

#### 2.3.6.- Permitir únicamente conexiones SFTP

El protocolo **SFTP (SSH File Transfer Protocol)** es un protocolo que permite realizar operaciones sobre ficheros (acceso, transferencia y administración) a través de la red sobre un túnel SSH. Hay que tener en cuenta que, a pesar del nombre, SFTP no es un FTP que se ejecuta sobre SSH, sino que es un protocolo nuevo.

Comparado con el protocolo SCP, que únicamente permite transferencias de ficheros, el protocolo SFTP un mayor rango de operaciones sobre los ficheros remotos. Un cliente SFTP incluye características extra como retomar transferencias interrumpidas, listado de directorios o eliminación remota de ficheros.

El protocolo SFTP lo podemos utilizar para permitir que un usuario remoto utilice SSH para transferir ficheros, pero sin tener la posibilidad de acceder a una terminal SSH. 

El primer paso para ello será cambiar la siguiente línea del fichero de configuración `/etc/ssh/ssd_config`.
 
Tras reiniciar el servicio, si intentamos acceder mediante SSH obtendremos un mensaje de error.
 
Y sólo podremos tener acceso mediante el comando `sftp`.
 




---
---

[Volver al índice de la unidad](index.md)

[Volver al índice del módulo](../../index.md)

