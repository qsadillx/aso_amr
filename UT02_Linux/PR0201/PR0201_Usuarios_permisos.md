# PR201

## 1. Permisos de usuarios

### 1.1 Creación de directorios y permisos

Creamos el directorio **pr0201** y dentro de el creamos los directorios **dir1** y **dir2**

```bash
mkdir pr0201
mkdir pr0201/dir1 pr0201/dir2
```

Los permisos del directorio **dir1** serían;
**drwrwxr-x** lo que significa que:

> **Propietario** tiene permisos de lectura, escritura y ejecución.
> 
> **Grupo** tiene permisos de lectura y ejecución.
> 
> **Otros** tiene permisos de lectura y ejecución.

### 1.2 Eliminar permisos de escritura

Para eliminar los permisos de escritura en **dir2** usaremos el comando 

```bash
chmod a-w pr0201/dir2
```

### 1.3 Eliminar permisos de lectura para el resto de usuarios en **dir2**

```bash
chmod o-r pr0201/dir2
```

### 1.4 Comprobar permisos de **dir2**
```bash
ls -l pr0201 
```

Los permisos son: **dr-xr-x---** lo que significa que:
> **Propietario** tendria permiso de lectura y ejecución
> 
> **Grupo** permiso de lectura y ejecución
> 
> **Otros** sin permiso
>

### 1.5 Crear dir21 dentro de **dir2**

Crearemos **dir21**

```bash
mkdir pr0201/dir2/dir21
```
Nos dará un error de permisos de escritura por lo que nos daremos permisos y volveremos a intentar el paso anterior 

```bash
sudo chmod u+w pr0201/dir2
mkdir pr0201/dir2/dir21
```

## 2. Notación octal y simbólica

## Notación simbolica 
### 1.1 - **rwxrwxr-x**

```bash
chmod u=rwx,g=rwx,o=rx /file
```

### 1.2 - **rwxr--r--**
```bash
chmod u=rwx,g=r--,o=r-- /file
```

### 1.3 - **r--r-----**
```bash
chmod u=r,g=r,o= /file
```

### 1.4 - **rwxr-xr-x**
```bash
chmod u=rwx,g=rx,o=rx /file
```

### 1.5 - **r-x--x--x**
```bash
chmod u=rx,g=x,o=x /file
```

### 1.6 - **-w-r----x**
```bash
chmod u=w,g=r,o=x /file
```

### 1.7 - **-----xrwx**
```bash
chmod u=,g=x,o=rwx /file
```

### 1.8 - **r---w---x**
```bash
chmod u=r,g=w,o=x /file
```

### 1.9 - **-w-------**
```bash
chmod u=w,g=,o= /file
```

### 1.10 - **rw-r-----**
```bash
chmod u=rw,g=r,o= ~/file
```

### 1.11 - **rwx--x--x**
```bash
chmod u=rwx,g=x,o=x ~/file
```
## Notación octal 

### 1.1 - **rwx rwx rwx**
```bash
chmod 777 /file
```

### 1.2 - **--x --x --x**
```bash
chmod 111 /file

```

### 1.3 - **r-- -w- --x**
```bash
chmod 421 /file

```

### 1.4 - **-w- --- ---**
```bash
chmod 200 /file

```

### 1.5 - **rw- r-- ---**
```bash
chmod 640 /file
```

### 1.6 - **rwx --x --x**
```bash
chmod 711 /file
```
### 1.7 - **rwx r-x r-x**
```bash
chmod 755 /file
```

### 1.8 - **r-x --x --x**
```bash
chmod 511 /file
```

### 1.9 - **-w- r-- --x**
```bash
chmod 241 /file

```
### 1.10 - ** --- --x rwx**
```bash
chmod 017 /file

```

## Bit setgid
### Creacion grupo **asir**

```bash
groupadd asir
useradd -m AMR1 -G asir
useradd -m AMR2 -G asir
```
### Creación directorio **compartido**, **root** es propietario

```bash
mkdir /compartido
chown root:asir /compartido
chmod 770 /compartido
```

### Establecemos **setgid** en la **carpeta  /compartido**

```bash
chmod g+s /compartido
ls -ld /compartido
```

### Creamos **fichero1** como **Usuario1**

```bash
su - AMR1
cd /compartido
echo "contenido" > fichero1
ls -l fichero1
```

### Modificamos **fichero1** como **Usuario2**

```bash
su - AMR2
cd /compartido
echo "nuevo contenido" >> fichero1
```

### Responde las siguientes preguntas:
#### ¿Qué ventajas tiene usar el bit setgid en entornos colaborativos?
Permite que los archivos hereden el grupo del propietario

#### ¿Qué sucede si no se aplica el bit setgid en un entorno colaborativo?

Que los archivos tendrian grupos diferentes


### Eliminación de usuarios y directorios

```bash
userdel -r AMR1
userdel -r AMR2
rm -r /compartido
```

## Sticky Bit

### Crear directorio /compartido

```bash
mkdir /compartido
chmod 777 /compartido
```

### Creación usuarios
```bash
useradd -m AMR1
useradd -m AMR2

```
### No sticky bit (creamos archivo con usuario1 e intentamos que usuario2 lo borre)
```bash
su - AMR1
touch /compartido/archivo
```


```bash
su - AMR2
rm /compartido/archivo
```

### Activamos sticky bit
```bash
chmod +t /compartido
ls -ls 
```

### Probamos ahora con el sticky bit activado
```bash
su AMR1
touch /compartido/archivo2
```

```bash
su AMR2
touch /compartido/archivo2
```

### Responde las siguientes preguntas:
#### ¿Qué efecto tiene el sticky bit en un directorio?
El stickybit restringe la eliminación, por lo tanto solo podría borrarlo el propietario

#### Si tienes habilitado el sticky bit, ¿cómo tendrías que hacer para eliminar un fichero dentro del directorio?

Para elimninarlo tendriamos que ser el propietario o ser root.

## Fichero **etc/shadow**

### Primero crearemos un usuario con nuestras iniciales y la contraseña "asir2"
#### Para esto usaremos los dos comandos escritos a continuación, después de escribir **sudo passwd AMR** nos pedirá la contraseña por separado, ahi escribiremos **asir2**

```bash
sudo adduser AMR
sudo passwd AMR
```

### Para conseguir la linea de nuestro usuario **"AMR"** usaremos un grep

```bash
sudo grep AMR /etc/shadow
```

### [Aquí](https://blog.elhacker.net/2022/02/icheros-etc-passwd-shadow-y-group.html) podemos observar los formatos soportados
#### Serían:
1. MD5
2. Blowfish
3. Eksblowfish
4. SHA-256
5. SHA-512

### Tipo de hash utilizado por el sistema
#### El tipo de hash por defecto sería un **SHA-512**

### Que es la sal y para que sirve
Segun esta [pagina](https://www.ochobitshacenunbyte.com/2023/01/05/como-se-puede-usar-la-tecnica-de-criptografia-salt-en-linux/) la sal es una tecnica usada para hacer mas segura las contraseñas, de esta forma un atacante no puede usar ataques modo diccionario para descifrar las contraseñas.

Ejemplo de uso;
Si juan elige la contraseña paco123, salt añadiría una cadena generada por ejemplo (2I9wcP), por lo tanto en texto plano nuestra contraseña quedaría como; **"q2I9wcPpaco123"**, además si tenemos la misma contraseña que otro usuario del sistema los hashes serán completamente diferentes.

### Ataques diccionario y tablas rainbow

#### Ataques diccionario
Consiste en probar infinitamente palabras o frases comunes y compararlos con los hashes de almacenados

#### Tablas rainbow
Son un conjunto de hashes que los atacantes usan para buscar el hash de una contraseña sin calcularlo en tiempo real

Para este ultimo ataque podemos usar la pagina [crackstation](https://crackstation.net/).

[Volver al inicio](./../../index.md)