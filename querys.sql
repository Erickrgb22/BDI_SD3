-- Obtener todos los cursos disponibles
SELECT * FROM courses;
-- Vista para mejorar la visualizacion:
BEGIN; --Iniciar la transaccion
CREATE VIEW all_courses AS
SELECT  -- PT 2.206ms ET 0.854ms NOIDX
  c.id as "ID",
  c.name as "Nombre",
  c.description as "Descripcion",
  cc.category as "Categoria",
  cl."level" as "Nivel",
  c.duration as "Horas",
  c.price as "Precio",
  cs."status" as "Estado"
FROM 
  courses "c"
  JOIN course_category cc on c.category = cc.id
  JOIN course_level cl on c.level = cl.id
  JOIN course_status cs on c."status" = cs.id
ORDER BY c.id ASC;
EXPLAIN ANALYSE SELECT * FROM all_courses; -- PT 2.390ms ET 0.994ms NOIDX

CREATE INDEX idx_status ON course_status (status); 
CREATE INDEX idx_category ON course_category (category); 
CREATE INDEX idx_level ON course_level (level); 

EXPLAIN ANALYSE SELECT * FROM all_courses; --PT 0.836ms ET 0.352ms IDX

EXPLAIN ANALYSE SELECT * FROM courses; --PT 0.120ms ET 0.031.ms
ROLLBACK; -- Fin de la Transaccion devolver los cambios (DEBUG)

CREATE INDEX idx_status ON course_status (status); 
CREATE INDEX idx_category ON course_category (category); 
CREATE INDEX idx_level ON course_level (level); 

BEGIN;
-- Obtener cursos por Categoria, Nivel o Estado usando el ID
EXPLAIN ANALYSE SELECT * FROM courses c WHERE c.category = 1; --PT 0.782ms ET 0.115ms
EXPLAIN ANALYSE SELECT * FROM courses c WHERE c.level= 1;-- PT 0.629 ms ET 0.629 ms
EXPLAIN ANALYSE SELECT * FROM courses c WHERE c.status = 1; -- PT 0.735 ms ET 0.078 ms
-- Tambien se podia combinar para no hacer 3 consultas si no una si se quiere ser mas especifico
SELECT * FROM courses c WHERE c.category = 1 AND c.level = 1 AND c.status = 1;
-- Estas consultas son rapidas por que se hace referencia al id, que es un PK
-- TODOS los PK tienen un index que se crea automaticamente
-- Lo unico inconveniente es cuando no se conoce el id por el que se quiere filtrar

-- Filtrar por el campo en vez de por el ID toca hacer un JOIN que haria las cosas mas lentas
-- Para este caso hare un solo JOIN y Filtrare combinando los filtros pero se puede filtrar
-- cada campo por separado
-- (Es basicamente podemos usar la vista all_courses para obtener todos los cursos pero con un WHERE)
EXPLAIN ANALYSE
SELECT * FROM all_courses -- PT 2.058ms ET 0.494ms IDX
WHERE "Categoria" = 'Computacion' AND "Nivel" = 'Basico' AND "Estado" = 'Activo';
-- Esta consulta ya se encuentra optimizada por los Indices que aplicamos con anterioridad
ROLLBACK;

BEGIN;
-- Obtener a todos los usuarios
SELECT * FROM users; --PT 0.442ms ET 0.181ms

-- Obtener usuarios por Roles
EXPLAIN ANALYSE -- PT 0.449ms ET 0.321ms
SELECT 
  id,
  CONCAT(name, ' ', lastname) AS "Nombre y Apellido",
  user_type
FROM users
WHERE user_type = 1;
-- De nuevo esto es muy facil ya que estamos referenciando a un ID

-- Si tenemos:
EXPLAIN ANALYSE
SELECT
  u.id as "ID",
  CONCAT(u."name", ' ', u.lastname) as "Nombre y Apellido",
  ut."type" AS "ROL"
FROM
  users u
  JOIN user_types ut on u.user_type = ut.id
WHERE ut.type = 'Admin';
-- PT 2.563ms ET 0.671ms osea 1/2 de segundo para filtrar solo a los Admins
-- Para los estudiantes y los instructores tenemos una trampa por que podemos 
-- simeplemente listar sus tablas ya que estan automaticamente conectadas por el trigger
-- que ingresa el user id correspondiente al rol
-- pero esto no nos sirve con los admins. Por tanto podemos aplicar un INDEX a la columna "type"
-- de la tabla user_types, ya que es una tabla referencial a la cual no se le ingresa gran 
-- cantidad de datos
CREATE INDEX idx_u_type ON user_types(type);
-- Despues de aplicar el Index tenemos PT 0.972ms ET 0.368ms casi el doble de rapido.

-- Con esto tambien podemos obtener el numero de usuarios por tipo
SELECT
  ut."type" AS "ROL",
  COUNT(*) AS "Usuarios X ROL"
FROM
  users u
  JOIN user_types ut on u.user_type = ut.id
GROUP BY ut."type";

-- Otra consulta interesante ha de ser la cantidad de registros por A~o
SELECT 
  EXTRACT(YEAR FROM register_date) AS "Fecha", -- EXTRACT sirve para sacar el A~o del TimeSTAMP
  COUNT(*) AS "Registros"
FROM users
GROUP BY "Fecha";

ROLLBACK;


BEGIN;
-- Obtener la lista de inscripciones por curso
EXPLAIN ANALYSE
SELECT 
   CONCAT(u."name", ' ', u.lastname) AS "Estudiantes", -- no explique anterioremente pero CONCAT
  -- Concatena la data de las columnas
  c."name" AS "Curso"
FROM
  students_courses sc
  JOIN users u on sc.id_student = u.id
  JOIN courses c on sc.id_course = c.id
ORDER BY c.id;
-- Esta consulta es lentisima por la cantidad de estudiantes y cursos 
-- PT 1.963ms ET 8.093ms !!!!!!!!!!
-- Podemos aplicar un index en la columna de nombre de los cursos puesto que es altamente referencianda 
-- Por esta consulta la cual puede derivar en una vista para hacer mas facil el filtrado
-- Esto puede ser un poco polemico por que podria tenerse que los cursos son algo que se pueden crear por lotes
-- Pero esto depende realmente del tama~o, la velocidad de conuslta en decrimento de la velocidad de inscersion
-- es totalmente justificable por:
CREATE INDEX idx_course ON courses (name);
-- Con el index creado bajamos los tiempos a PT 0.930ms ET 3.870ms osea mas de la mitad. 
-- Vamos a generar una vista de esa consulta
CREATE VIEW inscriptions AS
SELECT 
   CONCAT(u."name", ' ', u.lastname) AS "Estudiantes", -- no explique anterioremente pero CONCAT
  -- Concatena la data de las columnas
  c."name" AS "Curso"
FROM
  students_courses sc
  JOIN users u on sc.id_student = u.id
  JOIN courses c on sc.id_course = c.id
ORDER BY c.id;

-- De esta vista podemos derivar un monton de variaciones y filtros como por ejemplo
-- Obtener Estudiantes x Curso
SELECT * FROM inscriptions WHERE "Curso" = 'HTML Desde 0';
-- Obtener Cursos de un estudiante por su nombre (no muy optimo pero sirve)
SELECT * FROM inscriptions WHERE "Estudiantes" = 'Town Collister';
-- Obtener Cursos de un estudiante por su ID (ya optimo por index en columna curso)
SELECT
  u.id,
  u."name",
  c."name"
FROM 
  students_courses sc
  JOIN users u on sc.id_student = u.id
  JOIN courses c on sc.id_course = c.id
WHERE u.id = 26;
ROLLBACK;

-- Obtener el Progreso de un Estudiante en un "Curso"
-- Para esto tenemos que tomar en cuenta lo que se define por progreso en la plataforma
-- En este caso el progreso del estudiante se mide por la cantidad de elementos de un curso que este
-- Este marcando como completados, los elementos en cuestion serian los modulos y las Lecciones
-- De modo que si un curso tiene 4 modulos y 2 lecciones por modulo siendo 8 lecciones en total_time
-- Si un estudiante Completa 2 modulos y sus lecciones tendriamos que ese estudiante lleva un 50% del curso
-- (Modulos Completados (2) + Lecciones Completadas (4)) * 100.00 / (Modulos(4) + Lecciones (8))
-- (2+4) * 100.00 / (4+8) = (6) * 100.00 / (12) = 600/12 = 50%
--
-- Por tanto lo que necesitamos de primero es saber que modulos y lecciones un estudiante
-- tenga marcado como True el valor completed de la tabla que lo relaciona con dicha (leccion o modulo)
-- Para esto tenemos que realizar la siguiente consulta:
SELECT -- Seleeciono la data de interes y le coloco alias a las columnas para que sea mas legible
    sc.id_student AS "ID",
    CONCAT(u."name", ' ', u."lastname") AS "Estudiante",
    c.name AS "Curso",
    m.title AS "Modulo",
    sm.completed AS "Completado",
    l.title AS "Leccion",
    sl.completed as "Completado"
FROM
    students_courses sc -- De la tabla que relaciona a los estudiantes con los cursos
    JOIN courses c ON sc.id_course = c.id -- Union con tabla curso para obtener el nombre del curso
    JOIN users u on sc.id_student = u.id -- Union con la tabla usuario para tener los datos del estudiante
    JOIN modules m ON c.id = m.id_course -- Union para traer la data del modulo
    JOIN lessons l ON m.id = l.id_module -- Union para relacionar la data de las lecciones 
    -- Estas 2 uniones parecen ser las mas complejas, lo que hacemos aca es basicamente
--  unir unicamente los modulos de un curso, por estudiante inscrito en dicho curso. 
--  mismo caso para las lecciones, si no hacemos esta doble union se nos generaria un
--  producto cartesiano entre todas las relaciones N:M de todas las tablas resultando en una consulta con
--  muchos datos repetidos lo cual no nos sirve para lo que haremos a continuacion
    JOIN students_modules sm ON sm.id_module = m.id AND sm.id_student = sc.id_student
    JOIN students_lessons sl on sl.id_lesson = l.id AND sl.id_student = sc.id_student
WHERE
    sc.id_student = 26 AND c.id = 2; -- Podemos filtrar perfectamente por cualquier atributo.

-- Para explicar mejor dejo un ejemplo de la salida de esa consulta:

-- ID |  Estudiante   |   Curso    |            Modulo             | Completado |       Leccion        | Completado 
------+---------------+------------+-------------------------------+------------+----------------------+------------
-- 26 | Renata Weekes | Python OOP | Introducción a OOP            | t          | Conceptos Básicos    | t
-- 26 | Renata Weekes | Python OOP | Introducción a OOP            | t          | Clases y Objetos     | f
-- 26 | Renata Weekes | Python OOP | Herencia y Polimorfismo       | f          | Herencia             | t
-- 26 | Renata Weekes | Python OOP | Herencia y Polimorfismo       | f          | Polimorfismo         | t
-- 26 | Renata Weekes | Python OOP | Métodos y Atributos           | t          | Métodos de instancia | t
-- 26 | Renata Weekes | Python OOP | Métodos y Atributos           | t          | Atributos de clase   | t
-- 26 | Renata Weekes | Python OOP | Encapsulamiento y Abstracción | t          | Encapsulamiento      | t
-- 26 | Renata Weekes | Python OOP | Encapsulamiento y Abstracción | t          | Abstracción          | t

-- Con esto podemos ver que obtenemos el campo completed de las tablas students_lessons y students_modules
-- Del curso Python OOP que esta cursando Renata, con esto tenemos los 4 datos que necesitamos 
-- para calcular su progreso recordando lo que mencionamos al inicio
-- Necesitamos 'Total de Modulos' 'Total de Lecciones' 'Modulos completados' y 'Lecciones Completadas'
-- de un estudiante dentro de un curso 

-- Esta consulta la podemos usar como una sub consulta del siguiente modo 
WITH sp (s_id, s_name, c_id, c_name, m_complete,l_complete, m_id, l_id) AS (
-- Esto nos genera una tabla temporal llamada 'sp' con los campos listados arriba entre los ()
SELECT
    -- Esos campos corresponden a los listados por este select
    sc.id_student AS "ID", -- s_id
    CONCAT(u."name", ' ', u."lastname") AS "Estudiante", -- s_name
    c.id AS "ID CURSO", -- c_id
    c.name AS "Curso", -- c_name
    sm.completed AS "Completado", -- m_complete
    sl.completed as "Completado", -- l_complete
    m.id, -- m_id
    l.id -- l_id
FROM
    students_courses sc
    JOIN courses c ON sc.id_course = c.id
    JOIN users u on sc.id_student = u.id
    JOIN modules m ON c.id = m.id_course
    JOIN lessons l ON m.id = l.id_module
    JOIN students_modules sm ON sm.id_module = m.id AND sm.id_student = sc.id_student
    JOIN students_lessons sl on sl.id_lesson = l.id AND sl.id_student = sc.id_student
)
-- La tabla sp resultante de la subconsulta anterior es igual a la primera que mostre
-- lo unico que tiene de diferente en su salida es que incluye los id de los modulos y los id de las lecciones
  SELECT 
    s_name AS "Estudiante", -- Nombre del estudiante
    c_name AS "Curso", -- Nombre del Curso
    COUNT(DISTINCT m_id) AS "Modulos", -- Total de modulos x curso
    COUNT(DISTINCT m_id) FILTER(WHERE m_complete = 't') AS "Completados", -- Modulos completados por el estudiante
    COUNT(DISTINCT l_id) AS "Lecciones", -- Total de lecciones x curso
    COUNT(DISTINCT l_id) FILTER(WHERE l_complete = 't') AS "Completados", -- Lecciones completadas por el estudiante
  -- Este puede parecer complejo pero en realidad es una operacion matematica con los datos de
  -- arriba, aqui podemos ver por que agregamos el id de los modulos y las consultas 
  -- puesto que usamos COUNT y DISTINCT para contar el total de dichos modulos dentro del curso por su ID (al ser PK es unico)
  -- al usar DISTINCT nos aseguramos que solo contamos unicamente 1 x curso
  -- Tamben combinamos este mismo con un Filtro que basicamente dice cuenta cuantos de estos modulos estan 
  -- marcados como true en la colmna complete que en este caso la estamos pasando como atributo
  -- de la tabla sp obtenida de la subconsulta de mas arriba.
  -- Aja todo eso que resume pues que estamos ejecutando la opreacion matematica que indique al principio
  -- pero con la salvedad que lo hacemos con cada estudiante y cada curso de estos. 
    (COUNT(DISTINCT m_id) FILTER(WHERE m_complete = 't') + COUNT(DISTINCT l_id) FILTER(WHERE l_complete = 't')) 
    * 100.00 / (COUNT(DISTINCT l_id) + COUNT(DISTINCT m_id)) AS "Progreso del Curso"
  FROM sp 
  GROUP BY
  s_name,
  c_name;
  
SELECT -- Seleeciono la data de interes y le coloco alias a las columnas para que sea mas legible
    sc.id_student AS "ID",
    CONCAT(u."name", ' ', u."lastname") AS "Estudiante",
    c.name AS "Curso",
    m.title AS "Modulo",
    e.title AS "Evaluacion",
    se.grade as "Nota"
FROM
    students_courses sc -- De la tabla que relaciona a los estudiantes con los cursos
    JOIN courses c ON sc.id_course = c.id -- Union con tabla curso para obtener el nombre del curso
    JOIN users u on sc.id_student = u.id -- Union con la tabla usuario para tener los datos del estudiante
    JOIN modules m ON c.id = m.id_course -- Union para traer la data del modulo
    JOIN evaluations e on m.id = e.id_module -- Union para traer data de la evaluacion (NOTA)
    -- Mismo caso que cuando referenciamos a los modulos y los cursos x estudiante. 
--     Pero con las evaliaciones
    JOIN students_evaluations se on se.id_evaluation = e.id AND se.id_student = sc.id_student
WHERE sc.id_student = 26
ORDER BY sc.id_course ASC;
-- De ese modo tenemos todas las calificaciones de un estudiante
-- Para calcular su promedio por curso podemos hacer una consulta con un efoque parecida a 
-- la del progreso usando WITH para pasar la salida de esta como tabla temporal y el resultado 
-- de esa subconsulta usarlo para calcular su nota final del curso:
-- Total de Notas / Total de Evaluaciones 

WITH sn (s_id, s_name, c_name, e_id, e_title, e_note) AS (
SELECT -- Seleeciono la data de interes y le coloco alias a las columnas para que sea mas legible
    sc.id_student AS "ID", -- s_id
    CONCAT(u."name", ' ', u."lastname") AS "Estudiante", -- s_name
    c.name AS "Curso", -- c_name
    e.id AS "ID Evaluacion", -- e_id
    e.title AS "Evaluacion", -- e_title
    se.grade as "Nota" -- e_note
FROM
    students_courses sc -- De la tabla que relaciona a los estudiantes con los cursos
    JOIN courses c ON sc.id_course = c.id -- Union con tabla curso para obtener el nombre del curso
    JOIN users u on sc.id_student = u.id -- Union con la tabla usuario para tener los datos del estudiante
    JOIN modules m ON c.id = m.id_course -- Union para traer la data del modulo
    JOIN evaluations e on m.id = e.id_module -- Union para traer data de la evaluacion (NOTA)
    -- Mismo caso que cuando referenciamos a los modulos y los cursos x estudiante. 
--     Pero con las evaliaciones
    JOIN students_evaluations se on se.id_evaluation = e.id AND se.id_student = sc.id_student
)
  -- Aqui el select es muy parecido al del progreso pero con una adicion 
-- usando SUM para sumar el total de las notas y luego dividirlas entre el total de evaluaciones
SELECT 
  sn.s_id,
  sn.s_name,
  sn.c_name,
  COUNT(DISTINCT e_id) AS "Evaluaciones",
  SUM(e_note) AS "Suma Notas",
  SUM(e_note) / COUNT(DISTINCT e_id) AS "Nota Final"
FROM
  sn
GROUP BY
  sn.s_id,
  sn.s_name,
  sn.c_name;


-- Obtener Cantidad de Contenidos por Tipos
SELECT
  ct."type",
  COUNT(ct.id)
FROM
content c
JOIN content_type as ct on c.type = ct.id
GROUP BY
  ct."type";

-- Obtener contenidos de las lecciones
SELECT 
  l.title,
  c.url
FROM
  content "c"
  JOIN content_type as ct on c.type = ct.id
  JOIN content_lessons as cl on c.id = cl.id_content
  JOIN lessons as l on cl.id_lesson = l.id;


SELECT
  c."name" AS "Curso", -- Nombre del curso
  COUNT(*) AS "Inscripciones", -- Cantidad de inscripciones (compras)
  COUNT(*) * c.price AS "Ingresos" -- compras * precio del curso = ingresos x curso
FROM
courses "c"
JOIN students_courses sc on c.id = sc.id_course
GROUP BY  
  c.price,
  c."name"
ORDER BY c.price DESC; -- Ordenar los cursos con mayor ganancias

-- Cantidad de estudiantes por insignias 
SELECT 
  b.badge AS "Insignias",
  COUNT(*) AS "Total"
FROM
  students s
  JOIN badges b on b.id = s.badge
GROUP BY
  b.badge;
-- Cantidad de instructores por Insignias
SELECT 
  b.badge AS "Insignias",
  COUNT(*) AS "Total"
FROM
  instructors i
  JOIN badges b on b.id = i.badge
GROUP BY
  b.badge

-- Obtener Ranking de estudiantes (De mas puntos a menos puntos)
SELECT 
  CONCAT(u.name, ' ', u.lastname) AS "Estudiante",
  s.points AS "Puntos"
FROM
  students s
  JOIN users u on u.id = s.id
ORDER BY
  s.points DESC;
