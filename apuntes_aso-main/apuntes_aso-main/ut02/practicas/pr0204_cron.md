# PR0204: Programación de tareas con `cron`

## Aspectos generales

### Objetivos de la práctica

En esta práctica vamos a explorar las diferentes posibilidades de `cron` para crear tareas programadas en un entorno Linux.

### Recursos

- [Crontab Gurú](https://crontab.guru/)

## Enunciado

Contesta a las siguientes preguntas:

1. ¿Qué orden pondrías en crontab en los siguientes casos?

    - La tarea se ejecuta cada hora
    - La tarea se ejecuta los domingos cada 3 horas
    - La tarea se ejecuta a las 12 de la mañana los días pares del mes.
    - La tarea se ejecuta el primer día de cada mes a las 8 de la mañana y a las 8 de la tarde.
    - La tarea se ejecuta cada media hora de lunes a viernes.
    - La tarea se ejecuta cada cuarto de hora, entre las 3 y las 8, de lunes a viernes, durante todo el mes de agosto
    - La tarea se ejecuta cada 90 minutos

2. ¿Cómo compruebas si el servicio cron se está ejecutando?

3. ¿Cuál es el efecto de la siguiente línea `crontab`?

```
    */15 1,2,3 * * * who > /tmp/test
```

4. Indica la ruta del fichero `crontab` del sistema

5. ¿Qué ficheros controlan los usuarios que pueden utilizar el `crontab`?

6. Excepcionalmente se debe iniciar una tarea llamada `script.sh` todos los lunes a las 07:30h antes de entrar en clase ¿Cómo lo harías?

7. Se ha cancelado la tarea. ¿Cómo listar y luego, suprimir la tarea?

8. Ejecuta el comando `ps -ef` para el usuario `root` cada 2 minutos y redirecciona el resultado a `/tmp/ps_result` sin sobrescribir los antiguos.

9. Verifica la lista de tareas en `crontab`

10. Espera unos minutos y comprueba el resultado en `/tmp`

11. Crea el usuario `asir2` y prohíbele utilizar el `crontab`.

12. Verifica que el usuario `asir2` realmente no puede utilizar `crontab`

13. Programa `crontab` para que cada día a las 0:05 se eliminen todos los ficheros que se encuentran en el directorio `/tmp`.

14. Programa una tarea en el sistema que se lance de lunes a viernes a las 9 de la mañana durante los meses de verano (julio, agosto y septiembre) que escriba en un fichero la hora actual (comando `date`, aunque tienes que mirar la ayuda para elegir un formato comprensible) seguido del listado de usuarios que hay conectados en ese momento en el sistema (comando `who`)

15. El servicio `cron` se ayuda de una serie de ficheros y directorios que se encuentran en el directorio `/etc`. Explica la función de cada uno de los siguientes ficheros/directorios:
    - `cron.d`:
    - `cron.allow`:
    - `cron.deny`:
    - `cron.daily`:
    - `cron.hourly`:
    - `cron.monthly`:
