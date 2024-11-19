# 🌐 PROYECTO PRIMERA EVALUACIÓN

## 📋 Alexandro Martínez Rojo

---

## ✨ Introducción

> Este script en Bash tiene como objetivo realizar un **escaneo de red**, identificando los *hosts activos* y escaneando **puertos específicos**.  
Gracias a la implementación de **JSON**, los resultados se guardan en un archivo especificado, permitiendo su consulta y análisis posterior.

---

## 🛠️ Requisitos de Uso

### 1️⃣ Sistema Operativo
- **Linux** o **Windows**

### 2️⃣ Herramientas Necesarias
- **`nc` (Netcat):** Para el escaneo de puertos.  
- **`ping`:** Para comprobar la actividad de los hosts en la red.  
- **`cut` | `grep` | `sed`:** Utilidades necesarias para la manipulación de cadenas.  
- **arp:** Necesitaremos esto para sacar la MAC
- **`tcp.csv`:** Archivo con información de los servicios asociados a puertos.  
   Nota: Sin este archivo, el escaneo de puertos con *Netcat* no funcionará correctamente.

---

## ⚙️ Funcionamiento

Este script permite realizar un escaneo sobre una red específica. Por ejemplo:  

Queremos escanear la red **192.168.1.0/24** y los puertos del **50 al 54**, los parámetros serían:

```bash
./proyecto.sh 192.168.1.0/24 50-54 prueba.json
```

```json
[
  {
    "ip": "192.168.1.1",
    "sistema": "Windows",
    "mac": "00:14:22:cd:ef:01",
    "puertos": [
      {
        "puerto": 50,
        "servicio": "Remote Mail Checking Protocol"
      },
      {
        "puerto": 51,
        "servicio": "IMP Logical Address Maintenance"
      },
      {
        "puerto": 52,
        "servicio": "XNS Time Protocol"
      },
      {
        "puerto": 53,
        "servicio": "Domain Name Server"
      },
      {
        "puerto": 54,
        "servicio": "XNS Clearinghouse"
      }
    ]
  }
]
```

## 💻 Parámetros de Entrada
El script utiliza tres parámetros almacenados en variables para su ejecución:

**Red IP**: Dirección de red en formato CIDR
Ejemplo: *192.168.1.0/24*

**Rango de Puertos**: Rango que abarca los puertos a escanear
Ejemplo: *1-65535*

**Archivo de Salida**: Nombre del archivo donde se guardarán los resultados
Ejemplo: *resultados.json*


## 😈 Ventajas del Script
✅ Escaneo detallado de redes IP.

✅ Identificacipn de sistemas operativos según el valor TTL.

✅ Almacenamiento en formato JSON para fácililitar las consultas


## 🗒️ Actualizaciones

✅ Se ha añadido el uso de hilos dentro del script para que funcione un poco mas rapido

✅ Se ha añadido una funcionalidad que permite localizar la mac cuando es la misma que nuestro dispositivo

✅ Se han añadido comentarios dentro del script a todas las funcionalidades para permitir su modificación de forma mas facil

[Volver al inicio](./../../index.md)