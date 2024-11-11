# PR0302: Ejercicios comando `case`


Realiza las siguientes tareas:

### Ejercicio 1: Menú de operaciones matemáticas

Crea un script que presente un menú con las operaciones básicas (suma, resta, multiplicación, división) y solicite al usuario que elija una operación. El script debe ejecutar la operación seleccionada utilizando `case`.

### Ejercicio 2: Identificación de extensión de archivo

Haz un script que solicite al usuario un nombre de archivo y, usando `case`, determine si es un archivo de texto (.txt), un archivo comprimido (.zip o .tar.gz), o cualquier otro tipo de archivo.

### Ejercicio 3: Conversor de unidades

Crea un script que ofrezca un menú para convertir entre diferentes unidades de longitud (metros a kilómetros, pies a metros, etc.) utilizando `case` para gestionar las conversiones.

### Ejercicio 4: Menú de configuración del sistema

Realiza un script que presente un menú con varias opciones de configuración del sistema: por ejemplo, apagar, reiniciar o cerrar sesión. Usa `case` para gestionar las opciones seleccionadas.

### Ejercicio 5: Día de la semana

Haz un script que solicite un número entre 1 y 7 al usuario y muestre el nombre del día correspondiente (1 para lunes, 2 para martes, etc.) utilizando case.

### Ejercicio 6: Clasificación de notas

Realiza un script que solicite una calificación numérica y, usando `case`, la clasifique como "Sobresaliente", "Notable", "Aprobado", o "Suspenso" según el rango de valores.

### Ejercicio 7: Clasificación de números

Haz un script que solicite un número y lo clasifique como "Positivo", "Negativo" o "Cero".

### Ejercicio 8: Control de servicios en Linux

Crea un script que pregunte por el nombre de un servicio y luego presente un menú para iniciar, detener o reiniciar un servicio en Linux (como `apache2` o `nginx`). Usa `case` para gestionar las opciones y los comandos correspondientes (`systemctl start`, `stop`, `restart`).

Después de realizar la operación solicitada comprueba su código de estado de finalización (recuerda que puedes obtener el estado de finalización de un comando con la variable `$?` tras ejecutarlo) y muestra un mensaje indicando si la operación se ha realizado correctamente o no.