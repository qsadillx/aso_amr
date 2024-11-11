# PR0203: Configuración de SSH para varios usuarios

## Aspectos generales

### Objetivos de la práctica

Seguimos trabajando con SSH. Esta práctica la realizaremos en grupos de 3 ó 4 y el objetivo será configurar tu servidor para que todos tus compañeros se puedan conectar mediante SSH de forma transparente.


### Recursos

1. [Box Ubuntu 22.04](https://app.vagrantup.com/generic/boxes/ubuntu2204)
2. [How to change hostname on Ubuntu 22.04](https://linuxize.com/post/how-to-change-hostname-on-ubuntu-22-04/)
3. [How to make Windows resolve local hosts by their name](https://superuser.com/questions/1182917/how-to-make-windows-resolve-local-hosts-by-their-name)


### Entorno de trabajo

Esta práctica la realizaremos en un Ubuntu Server 22.04 LTS, para utilizar todos el mismo entorno usarás el box denominado `generic/ubuntu2204`. Ten en cuenta que ahora el servidor Ubuntu debe verse desde otros equipos de la red física, por lo que es importante que añadas un adaptador que esté conectado a esta red. Esto lo puedes hacer en Vagrant agregando un adaptador `public_network` o bien directamente desde VirtualBox agregando un adaptador en modo puente.


## Enunciado

### 1. Preparación de la máquina y configuración de la red


1. Ponte de acuerdo con tus compañeros con la dirección de red que vais a utilizar y la IP asignada a cada equipo. Para evitar colisiones con la red del centro utiliza una red privada de clase B.
2. En tu servidor crea una cuenta de usuario para tí y otra para cada uno de tus compañeros
3. Realiza los pasos necesarios para que tus compañeros se puedan conectar de forma transparente desde su servidor al tuyo.
4. Los usuarios no podrán conectarse por contraseña


### ¿Qué hay que entregar?

Debes entregar:

- Aunque el trabajo es en grupo, la entrega de la tarea es individual
- Documentación de los pasos más relevantes



[Volver al índice](../index.html)