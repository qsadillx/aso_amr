# PR0202: Conexión remota con SSH

## Aspectos generales

### Objetivos de la práctica

Esta práctica servirá para profundizar tus conocimientos sobre usuarios y permisos en sistemas Linux.


### Recursos

1. [Box Ubuntu 22.04](https://app.vagrantup.com/generic/boxes/ubuntu2204)
2. [How to change hostname on Ubuntu 22.04](https://linuxize.com/post/how-to-change-hostname-on-ubuntu-22-04/)
3. [How to make Windows resolve local hosts by their name](https://superuser.com/questions/1182917/how-to-make-windows-resolve-local-hosts-by-their-name)


### Entorno de trabajo

Esta práctica la realizaremos en un Ubuntu Server 22.04 LTS, para utilizar todos el mismo entorno usarás el box denominado `generic/ubuntu2204`.


## Enunciado

### 1. Preparación de la máquina y configuración de la red


1. Desde la interfaz de VirtualBox añade un segundo adaptador de red en modo *red solo anfitrión*. 
2. Indica la dirección IP que asigna VirtualBox a este adaptador de red, así como la dirección IP del adaptador correspondiente en la máquina anfitrión.
3. Comprueba que hay conectividad entre el anfitrión y la máquina virtual.
4. Cambia el *hostname* de Ubuntu para que se llame `{iniciales}_server`. Esta operación la tienes que realizar directamente en el sistema, no mediante Vagrant.
5. Realiza los cambios necesarios en tu equipo Windows para que te resuelva localmente el nombre del servidor Ubuntu (si tienes dudas, en los recursos tienes una breve explicación de cómo hacerlo)


### 2. Creación del usuario y conexión SSH

1. Crea en Ubuntu un usuario que se llamará `{iniciales}_ssh`, donde iniciales son las de tu nombre y apellidos.
2. Realiza los pasos necesarios para que este usurio se pueda conectar mediante SSH mediante contraseña.
3. Una vez que hayas verificado que la conexión funciona haz los cambios necesarios para que la conexión se realize mediante un par de claves pública-privada de forma transparente para el usuario.


### 3. Conexión transparente a Github

Ahora que ya estás cómodo con la autenticación mediante par de claves pública-privada, intenta configurar tu Github para que te puedas conectar sin necesidad de introducir tu contraseña. Como pista, tienes que acceder a *tu perfil -> Settings -> SSH and GPG keys*


### ¿Qué hay que entregar?

Debes entregar:

- Documentación de los pasos más relevantes



[Volver al índice](../index.html)