¡Un saludo! aquí encontrará unas breves instrucciones para desplegar la estructura de la base de datos que modele para el caso de estudio #8 Aprende MAS.

Se tienen 2 opciones para esto:

## Camino fácil

Puede desplegar el contenedor de Docker usando `docker compose up -d` esto creara un contenedor de Docker con una instancia de Postgres, y usara la data de la carpeta postgressql_data para desplegar una copia exacta de la base de datos con la que trabaje en el desarrollo de la actividad. No necesita montar una instancia de PostgreSQL ni ejecutar ningun script. Es un ready to go.

Para conectarse con la base de datos usé el localhost y el puerto 5432 (si lo tiene ocupado puede cambiarlo en el docker compose)
El user es egilmore
El pass es pg.ERGB.22

Dependencias:
 - Docker y Docker compose
 - Si no tiene Docker ni Docker compose puede seguir estas instrucciones: <https://docs.docker.com/desktop/setup/install/linux/archlinux/>

## Camino fácil (si también es fácil)

Ok si desea comprobar los scripts de inicialización de la base de datos puede escoger este camino.
Usando `psql -U <nombre de tu usuario> -f db_init.sql` se ejecutara el script que creara una base de datos llamada 'aprendemas' y la poblara con toda la estructura y la data necesaria. La explicación en profundidad de que hace el script y lo que contiene está plasmada en la documentación entregada en la plataforma de la UNETI.

Nota también se puede ejecutar usando PGADMIN, solo hay que comentar la línea donde se establece la conexión con la base de datos creada.  `\c aprendemas;`

## Alternativa (aprendemas_back.sql)

Este es un método alternativo, deje un respaldo de mi última base de datos con la que trabaje previo a entregar la actividad. En ese archivo aprendemas_back.sql puede ser restaurado usando pg_resotre.
