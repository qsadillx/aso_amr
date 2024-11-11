# UT02: INSTALACIÓN Y PUESTA EN MARCHA DE LINUX SERVER


## 7.- El directorio `/proc`

### Índice
- [7.1.- ¿Qué es el directorio `/proc`?](#71--qué-es-el-directorio-proc)
- [7.2.- Características del sistema de archivos `/proc`](#72--características-del-sistema-de-archivos-proc)
- [7.3.- Estructura del directorio `/proc`](#73--estructura-del-directorio-proc)
- [7.4.- Modificación de parámetros del kernel](#74-modificación-de-parámetros-del-kernel)
- [7.5.- Ejemplos prácticos](#75--ejemplos-prácticos)



### 7.1.- ¿Qué es el directorio `/proc`?

El directorio **`/proc`** es un **sistema de archivos virtual** que proporciona información sobre el **sistema en tiempo real**. No es un directorio tradicional que almacene archivos en el disco duro, sino que actúa como una interfaz para acceder a los datos del kernel y otros procesos del sistema.

El sistema de archivos `/proc` se monta automáticamente al iniciar el sistema y permite a los administradores y usuarios consultar información sobre el hardware, el kernel y los procesos en ejecución.

### 7.2.- Características del sistema de archivos `/proc`

- **Volátil**: Los archivos dentro de `/proc` no ocupan espacio en el disco; la información se genera dinámicamente cuando se consulta.
- **Lectura de información en tiempo real**: Se puede acceder a estadísticas del sistema, información de procesos, uso de memoria, etc.
- **Interfaz con el kernel**: Permite al usuario interactuar y modificar ciertos parámetros del kernel, como los parámetros de red o el rendimiento del sistema.

### 7.3.- Estructura del directorio `/proc`

Dentro del directorio `/proc`, se encuentran varios archivos y subdirectorios. Algunos de ellos contienen información específica del sistema, mientras que otros son directorios numerados que representan procesos en ejecución. A continuación, se explican algunos de los más relevantes:

**Archivos importantes**

- **`/proc/cpuinfo`**: Muestra información sobre la **CPU** del sistema, incluyendo el modelo, la frecuencia, la cantidad de núcleos, etc.

    ```bash
    cat /proc/cpuinfo
    ```

- **`/proc/meminfo`**: Contiene información sobre la **memoria** del sistema, como la cantidad de RAM disponible y usada, el uso de swap, etc.

    ```bash
    cat /proc/meminfo
    ```

- **`/proc/uptime`**: Indica el tiempo que el sistema ha estado funcionando desde el último arranque.

    ```bash
    cat /proc/uptime
    ```

- **`/proc/loadavg`**: Muestra la **carga del sistema** (el número de procesos que están ejecutándose o esperando ser ejecutados) en los últimos 1, 5 y 15 minutos.

    ```bash
    cat /proc/loadavg
    ```

- **`/proc/version`**: Contiene información sobre la **versión del kernel** de Linux que está corriendo actualmente en el sistema.

    ```bash
    cat /proc/version
    ```

- **`/proc/partitions`**: Muestra las particiones de los discos del sistema.

    ```bash
    cat /proc/partitions
    ```

**Directorios de procesos**

Cada proceso en el sistema tiene un subdirectorio en `/proc` con su **PID** (Process ID) como nombre. Dentro de cada uno de estos directorios, hay archivos que contienen información sobre el proceso.

Por ejemplo, el proceso con PID **1234** tendrá un directorio en `/proc/1234/`. Algunos archivos comunes en estos directorios incluyen:

- **`/proc/[PID]/cmdline`**: Muestra la línea de comando con la que fue ejecutado el proceso.
- **`/proc/[PID]/status`**: Contiene información sobre el estado del proceso, como el usuario que lo ejecuta, el consumo de memoria, y el estado actual (en ejecución, suspendido, etc.).
- **`/proc/[PID]/fd/`**: Es un directorio que contiene enlaces simbólicos a los **descriptores de archivos** abiertos por el proceso.


### 7.4.- Modificación de parámetros del kernel

Algunos archivos dentro de `/proc` permiten modificar el comportamiento del sistema, especialmente los relacionados con el **kernel**. Un ejemplo es el archivo **`/proc/sys/`**, que contiene varios subdirectorios con configuraciones del kernel.

Dentro de `/proc/sys`, puedes encontrar configuraciones para redes, seguridad y otros aspectos del sistema.

- **`/proc/sys/net/ipv4/ip_forward`**: Controla el reenvío de paquetes IP. Si se quiere habilitar el reenvío (útil en servidores de routing), se puede hacer escribiendo en este archivo.

    Para activar el reenvío de IP:

    ```bash
    echo 1 > /proc/sys/net/ipv4/ip_forward
    ```

    Para desactivarlo:

    ```bash
    echo 0 > /proc/sys/net/ipv4/ip_forward
    ```

Los cambios realizados en `/proc` se pierden después de reiniciar el sistema. Si quieres que se apliquen de **forma permanente**, debes editar el archivo `/etc/sysctl.conf`.



### 7.5.- Ejemplos prácticos

**Ver los procesos en ejecución**

Puedes listar todos los procesos en ejecución consultando los subdirectorios numéricos de `/proc`:

```bash
ls /proc | grep -E '^[0-9]+$'
```

Este comando te dará una lista de los PID de todos los procesos actuales.


**Comprobar el uso de CPU y memoria**

Consulta la información detallada de la CPU y la memoria:

```bash
cat /proc/cpuinfo
cat /proc/meminfo
```

**Ver estadísticas de red**

```bash
cat /proc/net/dev
```

---
---

[Volver al índice de la unidad](index.md)

[Volver al índice del módulo](../../index.md)