Un saludo! aqui encontrara unas breves instrucciones para desplegar la estructura de la base de datos que modele para el caso de estudio #8 AprendeMAS.

Se tienen 2 opciones para esto:

## Camino facil

Puede desplegar el contenedor de docker usando `docker compose up -d` esto creara un contenedor de docker con una instancia de Postgres, y usara la data de la carpeta postgressql_data para desplegar una copia exacta de la base de datos con la que trabaje en el desarrollo de la actividad. No necesita montar una instancia de postgresql ni ejectutar ningun script. Es un ready to go.

Para conectarse con la base de datos use el localhost y el puerto 5432 (si lo tiene ocupado puede cambiarlo en el docker compose)
El user es egilmore
El pass es pg.ERGB.22

Dependencias:
 - docker y docker compose
 - Si no tiene docker ni docker compose puede seguir estas instrucciones: <https://docs.docker.com/desktop/setup/install/linux/archlinux/>

## Camino facil (si tambien es facil)

Ok si desea comprobar los scripts de inicializacion de la base de datos puede escoger este camino.
usando `psql -U <nombre de tu usuario> -f db_init.sql` se ejecutara el script que creara una base de datos llamada 'aprendemas' y la poblara con toda la estructura y la data necesaria. La explicacion a profundidad de que hace el script y lo que contiene esta plasmada en la documetnacion entregada en la plataforma de la UNETI.

Nota tambien se puede ejecutar usando PGADMIN, solo hay que comentar la linea donde se establece la conexion con la base de datos creada.  `\c aprendemas;`

## Alternativa (aprendemas_back.sql)

Este es un metdo alternativo, deje un respaldo de mi uttima base de datos con la que trabaje previo a entregar la actividad. en ese archivo aprendemas_back.sql puede ser restaurado usando pg_resotre.
