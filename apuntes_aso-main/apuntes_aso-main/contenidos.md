# ADMINISTRACIÓN DE SISTEMAS OPERATIVOS

## UT01: Introducción. Preparación del entorno (18 horas)

- Evolución de la administración de sistemas
- Máquinas virtuales con Virtual Box
- Git
- Vagrant
- Contenedores Docker 


## UT02: Instalación y puesta en marcha de Linux Server (20 horas)

- Instalación
- Administración remota con SSH
- Configuración de la red en Linux
- Gestión del almacenamiento. RAID y LVM
- Gestión de procesos en Linux
- El proceso de arranque (bootstraping)
- Servicios del núcleo del sistema (init?, upstart????)
- Programación de tareas con `cron` y `crontab`
- El directorio `/proc`
- Monitorización con Nagios (mirar a ver si hay algo de monitorización en el curriculo)


## UT03: Lenguajes de scripting en Linux: Bash (24 horas)

- Sintaxis básica de Bash
- Variables y tipos de datos
- Operadores en Bash
- Entrada y salida en Bash
- Estructuras de control
- Bucles en Bash
- Funciones en Bash
- Manejo de archivos y directorios
- Procesamiento de textos y cadenas
- Trabajando con arrays
- Manejo de señales y errores
- Automatización y programación de tareas
- Procesos y control de tareas
- Scripts interactivos y menús
- Scripting Bash y administración del sistema


## UT04: Instalación y puesta en marcha de Windows Server (6 horas)

- Instalación de Windows Server
- Configuración del almacenamiento (grupos de almacenamiento)


## UT05: Servicio de directorio en Windows (24 horas)

- Conceptos básicos de Active Directory
- Estructura del dominio. LDAP y Kerberos
- Directivas de grupo. GPOs
- Replicación de dominios
- Gestión de contraseñas. LAPS


## UT06: Lenguajes de scripting en Windows: Powershell (20 horas)

- Conceptos básicos de Powershell
- Manipulación de archivos y carpetas
- Automatización con scripts
- Condicionales y bucles
- Funciones modulares
- Gestión de procesos y servicios
- Administración del sistema
- Trabajando con objetos y pipelining
- Cmdlets avanzados
- Interacción con APIs y Servicios Web
- Manejo de errores
- Automatización de tareas con Powershell y Windows Task Scheduler
- Powershell Remoting


## UT07: Amazon AWS (16 horas)

- Introducción a AWS y la nube
- Estructura de AWS y la cuenta de AWS (???)
- Servicios de computación
  - Amazon EC2 (Elastic Compute Cloud)
    - Creación y configuración de estancias
    - Tipos de instancias y uso adecuado
    - SSH. Acceso a instancias
- Almacenamiento en AWS
  - Amazon S3 (Simple Storage Service)
    - Introducción a S3: Buckets y objetos
    - Permisos y políticas de acceso
    - Versionado y replicación de datos
  - Amazon EBS (Elastic Block Store)
    - Almacenamiento persistente para instancias EC2
    - Creación y adjunto de volúmenes
  - Amazon Glacier. Almacenamiento de archivos a largo plazo
- Bases de datos en AWS
  - Amazon RDS (Relational Database Service)
    - Bases de datos soportadas
    - Creación y administración de una base de datos RDS
    - Copias de seguridad y restauración
  - Amazon DynamoDB
    - Base de datos NoSQL gestionada
    - Creación de tablas y operaciones básicas
- Redes y seguridad
  - Amazon VPC (Virtual Private Cloud)
  - Seguridad en AWS
- Automatización y gestión de la infraestructura (???)
  - AWS Elastic Beanstalk
  - AWS Cloud Formation
- Servicios sin servidor
  - AWS Lambda
  - Amazon API Gateway
- Servicios de contenedores
  - Amazon ECS (Elastic Container Service)
  - Amazon EKS (Elastic Kubernetes Service)





## UT07:

- Instalación de Windows Server
- Instalación de Linux Server

## UT03: Servicios de acceso y administración remota

- Acceso SSH en Linux
- Acceso remoto para administración en Windows: Escritorio remoto, RSAT, ...

## UT04: Lenguajes de scripting: Powershell

- Introducción a Powershell
- Variables en Powershell
- Operaciones básicas con variables
- Estructuras condicionales
- Estructuras repetitivas
- Variables que guardan múltiples valores

## UT05: Lenguajes de scripting: Bash





## Automatización de tareas

## UT06: Administración de servidores de impresión

## UT07: Amazon AWS?????????

























# ADMINISTRACIÓN DE SISTEMAS OPERATIVOS

## UT01.- Introducción y preparación del entorno

1. Evolución de la administración de sistemas operativos
2. Entorno de trabajo
3. Control de versiones con Git
4. Administración de máquinas virtuales con Vagrant
5. Contenedores en Docker
6. Windows Subsystem for Linux (WSL)


## UT02.- Windows Server. Active Directory

1. Instalación y primeras configuraciones
2. Grupos de almacenamiento



## UTXX.- Gestión de indentidades en la nube. Azure AD

1. Introducción
2. La nube de Microsoft
3. Creación de usuarios y licencias
4. Autenticación multifactor (MFA)
5. Identity Protection y acceso condicional


Servicios de escritorio remoto (RDS)
Windows Server Update Services (WSUS)



5. Sistema de archivos y almacenamiento
    - Grupos de almacenamiento
    - Permisos NTFS
    - Crear recursos compartidos SMB
    - Cuotas
    - Robocopy
    - Distributed File Service (DFS)




1. Repaso de conceptos fundamentales
    - ¿Qué es Active Directory?
    - Componentes principales: DC (Domain Controller), OUs (Unidades Organizativas), GPOs (Group Policy Objects).
    - Estructura lógica y física: Bosques, dominios, sitios.
    - Diseño de dominios y árboles.
    - Creación y administración de sitios para optimizar el tráfico de replicación.
    - Planificación y diseño de un bosque multiforestal.
    - Relaciones de confianza entre dominios y bosques.

2. Roles FSMO (Flexible Single Master Operations)
    - Explicación de los 5 roles FSMO: Schema Master, Domain Naming Master, PDC Emulator, RID Master, Infrastructure Master.
    - Transferencia y asunción de roles FSMO.
    - Impacto de la pérdida de un rol FSMO y cómo recuperarlo.
    - Herramientas para administrar FSMO: NTDSUTIL, Usuarios y equipos de AD, Powershell

3. Políticas de grupo avanzadas (GPOs)
    - Herencia y priorización de GPOs.
    - Creación de GPOs basadas en seguridad.
    - Filtrado WMI (Windows Management Instrumentation) en GPOs.
    - Troubleshooting de GPOs con herramientas como GPResult y Group Policy Management Console (GPMC).

4. **NO** Autenticación y seguridad en Active Directory

    Kerberos vs NTLM: Diferencias y cómo optimizar la autenticación en un entorno empresarial.
    Autenticación multifactor (MFA) en entornos AD.
    Delegación de la administración en AD.
    Auditoría avanzada: Seguimiento de cambios con herramientas como Auditpol y configuración de auditoría avanzada de objetos.
    Configuración de listas de control de acceso (ACL) en AD.

6. **Para UT Powershell** Automatización y scripting en Active Directory
    - Introducción a PowerShell para Active Directory.
    - Cmdlets esenciales para la administración avanzada de AD: Get-ADUser, New-ADGroup, etc.
    - Creación de scripts para la administración masiva de usuarios, grupos y equipos.
    - Uso de PowerShell para la gestión y automatización de políticas de grupo.
    - Ejemplos avanzados: Aprovisionamiento automatizado de cuentas de usuario, gestión de licencias de Office 365.

7. Replicación de Active Directory
    - Conceptos de replicación: Intrasitio vs Intersitio.
    - Diagnóstico y resolución de problemas de replicación.
    - Herramientas para monitorear y reparar la replicación: Repadmin, DCDiag.
    - Uso del Global Catalog y su impacto en la replicación.

8. Integración de Active Directory con servicios en la nube
    - **Mirar los apuntes de 2021** Introducción a Azure AD: Diferencias y similitudes con Active Directory On-premise.
    - Sincronización de identidades con Azure AD Connect.
    - Integración híbrida: Implementación de un entorno híbrido con Azure AD y AD local.
    - Sincronización de contraseñas y autenticación federada con ADFS.

9. Backup y recuperación de Active Directory
    - **No**Estrategias de backup en AD: Backups granulares vs completos.
    - Restauración de AD: Authoritative Restore vs Non-authoritative Restore.
    - Recuperación ante desastres y cómo planificarla.
    - Uso de la Papelera de reciclaje de AD para recuperación de objetos.

10. Migración y actualización de Active Directory

    Migración de un entorno AD a una nueva versión de Windows Server.
    Herramientas de migración como ADMT (Active Directory Migration Tool).
    Despromoción y promoción de controladores de dominio.
    Buenas prácticas en la migración y consolidación de dominios.

11. Monitorización y optimización de Active Directory

    Herramientas de monitorización de AD: AD DS Best Practices Analyzer, Event Viewer, Performance Monitor.
    Diagnóstico de problemas de rendimiento en controladores de dominio.
    Optimización del uso de recursos y mejora de la latencia de autenticación.
    Uso de herramientas de terceros para mejorar la administración y el rendimiento de AD.

12. Seguridad y protección ante ciberamenazas
    Hardening de Active Directory: Protecciones avanzadas.
    Protección de cuentas privilegiadas (PAW, ESAE).
    Definición de una estrategia Zero Trust en Active Directory.
    Mitigación de ataques comunes en AD: Pass-the-Hash, Pass-the-Ticket, ataques Kerberos.

13. Casos prácticos y resolución de problemas

    Taller de resolución de problemas reales en Active Directory.
    Simulación de situaciones críticas: Controlador de dominio caído, replicación fallida, corrupción de objetos.
    Prácticas de troubleshooting y uso avanzado de logs.