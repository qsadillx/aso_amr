# UT02: INSTALACIÓN Y PUESTA EN MARCHA DE LINUX SERVER

## Copias de seguridad en Linux

### Índice

- Herramientas de backup (rsync, tar, cron)
- Copias de seguridad en red
- Restauración de datos


### 1.- Herramientas de backup



# Apuntes sobre la creación de copias de seguridad en Linux

## 1. Introducción

La creación de **copias de seguridad** (backups) es fundamental en la administración de sistemas para garantizar la disponibilidad de los datos en caso de fallos, pérdida de información o corrupción de archivos. En Linux, existen diversas herramientas y enfoques para realizar backups de forma eficiente.

---

## 2. Tipos de Copias de Seguridad

### 2.1. Copia completa (Full Backup)
Es una copia de todos los archivos y directorios del sistema o de una parte de él. Este tipo de copia ocupa más espacio y requiere más tiempo, pero es la forma más sencilla de restaurar todos los datos.

### 2.2. Copia incremental
Solo guarda los cambios realizados desde la última copia de seguridad (ya sea completa o incremental). Requiere menos espacio y tiempo que una copia completa, pero la restauración puede ser más lenta, ya que depende de varias copias anteriores.

### 2.3. Copia diferencial
Almacena todos los cambios desde la última **copia completa**. A diferencia de las incrementales, las diferenciales no dependen de varias copias, lo que simplifica el proceso de restauración.

---

## 6. Herramientas Comunes para Backups en Linux

### 6.1. `rsync`
`rsync` es una herramienta muy flexible y eficiente para sincronizar archivos y directorios, tanto localmente como a través de una red. Soporta copias incrementales y puede mantener permisos y tiempos de modificación.

#### Sintaxis básica:
```bash
rsync -av /ruta/origen /ruta/destino
```

-a: Modo archivo, que preserva permisos, enlaces, fechas, etc.
-v: Modo verbose, para obtener más información sobre la transferencia.

Ejemplo de copia remota:

```
rsync -avz /ruta/origen usuario@servidor:/ruta/destino
```

### 6.2. tar

`tar` es una de las herramientas más antiguas y populares para crear archivos comprimidos (archivos .tar, .tar.gz). Puede ser usado para crear un archivo de copia de seguridad que incluya varios archivos y directorios.

Crear un archivo .tar:

```
tar -cvf backup.tar /ruta/a/copiar
```

Los modificadores que podemos utilizar son:

- `-c`: Crea un nuevo archivo.
- `-v`: Muestra el progreso del proceso.
- `-f`: Especifica el nombre del archivo de salida.

Crear un archivo comprimido con gzip:

```
tar -czvf backup.tar.gz /ruta/a/copiar
```

Extraer un archivo tar:

```
tar -xvf backup.tar.gz
```

### 3.3. El comando `dd`

`dd` es una herramienta potente que copia datos a nivel de bloques. Se usa comúnmente para realizar backups de discos completos o particiones.

Copiar una partición o disco completo:

```
dd if=/dev/sda of=/ruta/del/backup.img
```

Los parámetros que ponemos son:

- `if`: Archivo de entrada (dispositivo de origen).
- `of`: Archivo de salida (donde se guarda la copia).

Restaurar la imagen:

```
dd if=/ruta/del/backup.img of=/dev/sda
```


---
---

[Volver al índice de la unidad](index.md)

[Volver al índice del módulo](../../index.md)
