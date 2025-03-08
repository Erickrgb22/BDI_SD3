--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Debian 17.4-1.pgdg120+2)
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: inscripcion_estudiante(); Type: FUNCTION; Schema: public; Owner: egilmore
--

CREATE FUNCTION public.inscripcion_estudiante() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Asignar el estudiante a todos los módulos del curso
    INSERT INTO students_modules (id_student, id_module)
    SELECT NEW.id_student, m.id
    FROM modules m
    WHERE m.id_course = NEW.id_course;
    -- Asignar el estudiante a todas las lecciones de los módulos del curso
    INSERT INTO students_lessons (id_student, id_lesson)
    SELECT NEW.id_student, l.id
    FROM lessons l
    JOIN modules m ON l.id_module = m.id
    WHERE m.id_course = NEW.id_course;
    -- Asignar el estudiante a todas las evaluaciones del curso
    INSERT INTO students_evaluations (id_student, id_evaluation)
    SELECT NEW.id_student, e.id
    FROM evaluations e
    JOIN modules m ON e.id_module = m.id
    WHERE m.id_course = NEW.id_course;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.inscripcion_estudiante() OWNER TO egilmore;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: course_category; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.course_category (
    id integer NOT NULL,
    category character varying(100)
);


ALTER TABLE public.course_category OWNER TO egilmore;

--
-- Name: course_level; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.course_level (
    id integer NOT NULL,
    level character varying(12)
);


ALTER TABLE public.course_level OWNER TO egilmore;

--
-- Name: course_status; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.course_status (
    id integer NOT NULL,
    status character varying(8)
);


ALTER TABLE public.course_status OWNER TO egilmore;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.courses (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    category integer,
    level integer,
    duration integer,
    price numeric(10,2) NOT NULL,
    status integer
);


ALTER TABLE public.courses OWNER TO egilmore;

--
-- Name: all_courses; Type: VIEW; Schema: public; Owner: egilmore
--

CREATE VIEW public.all_courses AS
 SELECT c.id AS "ID",
    c.name AS "Nombre",
    c.description AS "Descripcion",
    cc.category AS "Categoria",
    cl.level AS "Nivel",
    c.duration AS "Horas",
    c.price AS "Precio",
    cs.status AS "Estado"
   FROM (((public.courses c
     JOIN public.course_category cc ON ((c.category = cc.id)))
     JOIN public.course_level cl ON ((c.level = cl.id)))
     JOIN public.course_status cs ON ((c.status = cs.id)))
  ORDER BY c.id;


ALTER VIEW public.all_courses OWNER TO egilmore;

--
-- Name: badges; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.badges (
    id integer NOT NULL,
    badge character varying(255)
);


ALTER TABLE public.badges OWNER TO egilmore;

--
-- Name: badges_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.badges ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.badges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: content; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.content (
    id integer NOT NULL,
    type integer,
    url text NOT NULL
);


ALTER TABLE public.content OWNER TO egilmore;

--
-- Name: content_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.content ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.content_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: content_lessons; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.content_lessons (
    id_content integer NOT NULL,
    id_lesson integer NOT NULL
);


ALTER TABLE public.content_lessons OWNER TO egilmore;

--
-- Name: content_type; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.content_type (
    id integer NOT NULL,
    type character varying(100)
);


ALTER TABLE public.content_type OWNER TO egilmore;

--
-- Name: content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.content_type ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: course_category_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.course_category ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.course_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: course_level_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.course_level ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.course_level_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: course_status_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.course_status ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.course_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.courses ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: evaluations; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.evaluations (
    id integer NOT NULL,
    id_module integer,
    max_grade numeric(4,2) NOT NULL,
    title character varying(100),
    CONSTRAINT evaluations_max_grade_check CHECK (((max_grade > (0)::numeric) AND (max_grade <= (20)::numeric)))
);


ALTER TABLE public.evaluations OWNER TO egilmore;

--
-- Name: evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.evaluations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.evaluations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: students_courses; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.students_courses (
    id_student integer NOT NULL,
    id_course integer NOT NULL,
    inscription_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    progress integer,
    grade integer,
    cert boolean DEFAULT false,
    CONSTRAINT students_courses_grade_check CHECK (((grade >= 0) AND (grade <= 20))),
    CONSTRAINT students_courses_progress_check CHECK (((progress >= 0) AND (progress <= 100)))
);


ALTER TABLE public.students_courses OWNER TO egilmore;

--
-- Name: users; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    lastname character varying(255) NOT NULL,
    mail character varying(255) NOT NULL,
    register_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    password character varying(255) NOT NULL,
    user_type integer NOT NULL
);


ALTER TABLE public.users OWNER TO egilmore;

--
-- Name: inscriptions; Type: VIEW; Schema: public; Owner: egilmore
--

CREATE VIEW public.inscriptions AS
 SELECT concat(u.name, ' ', u.lastname) AS "Estudiantes",
    c.name AS "Curso"
   FROM ((public.students_courses sc
     JOIN public.users u ON ((sc.id_student = u.id)))
     JOIN public.courses c ON ((sc.id_course = c.id)))
  ORDER BY c.id;


ALTER VIEW public.inscriptions OWNER TO egilmore;

--
-- Name: instructors; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.instructors (
    id integer NOT NULL,
    specialty integer NOT NULL,
    badge integer
);


ALTER TABLE public.instructors OWNER TO egilmore;

--
-- Name: instructors_courses; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.instructors_courses (
    id_instructor integer NOT NULL,
    id_course integer NOT NULL
);


ALTER TABLE public.instructors_courses OWNER TO egilmore;

--
-- Name: lessons; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.lessons (
    id integer NOT NULL,
    id_module integer,
    title character varying(100),
    duration integer
);


ALTER TABLE public.lessons OWNER TO egilmore;

--
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.lessons ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lessons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: modules; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.modules (
    id integer NOT NULL,
    id_course integer,
    title character varying(100),
    description text
);


ALTER TABLE public.modules OWNER TO egilmore;

--
-- Name: modules_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.modules ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.modules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: specialties; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.specialties (
    id integer NOT NULL,
    specialty character varying(255)
);


ALTER TABLE public.specialties OWNER TO egilmore;

--
-- Name: specialties_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.specialties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.specialties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: students; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.students (
    id integer NOT NULL,
    points integer,
    badge integer
);


ALTER TABLE public.students OWNER TO egilmore;

--
-- Name: students_evaluations; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.students_evaluations (
    id_student integer NOT NULL,
    id_evaluation integer NOT NULL,
    grade integer,
    CONSTRAINT students_evaluations_grade_check CHECK (((grade >= 0) AND (grade <= 20)))
);


ALTER TABLE public.students_evaluations OWNER TO egilmore;

--
-- Name: students_lessons; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.students_lessons (
    id_student integer NOT NULL,
    id_lesson integer NOT NULL,
    completed boolean DEFAULT false
);


ALTER TABLE public.students_lessons OWNER TO egilmore;

--
-- Name: students_modules; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.students_modules (
    id_student integer NOT NULL,
    id_module integer NOT NULL,
    completed boolean DEFAULT false
);


ALTER TABLE public.students_modules OWNER TO egilmore;

--
-- Name: user_types; Type: TABLE; Schema: public; Owner: egilmore
--

CREATE TABLE public.user_types (
    id integer NOT NULL,
    type character varying(12)
);


ALTER TABLE public.user_types OWNER TO egilmore;

--
-- Name: user_types_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.user_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: egilmore
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: badges; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.badges (id, badge) FROM stdin;
1	Hierro
2	Bronze
3	Plata
4	Oro
\.


--
-- Data for Name: content; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.content (id, type, url) FROM stdin;
1	1	https://example.com/video-html-conceptos
2	2	https://example.com/documento-html-estructura
3	5	https://example.com/ejercicios-html-primer-archivo
4	1	https://example.com/video-html-etiquetas
5	3	https://example.com/infografia-html-etiquetas-texto
6	5	https://example.com/ejercicios-html-encabezados-parrafos
7	1	https://example.com/video-html-enlaces
8	4	https://example.com/guia-html-buenas-practicas-enlaces
9	5	https://example.com/ejercicios-html-enlaces
10	1	https://example.com/video-html-imagenes
11	3	https://example.com/infografia-html-formatos-imagenes
12	5	https://example.com/ejercicios-html-imagenes
13	1	https://example.com/video-html-formularios
14	2	https://example.com/documento-html-tipos-campos-formulario
15	5	https://example.com/ejercicios-html-formulario-contacto
16	1	https://example.com/video-html-validacion-formularios
17	4	https://example.com/guia-html-buenas-practicas-formularios
18	5	https://example.com/ejercicios-html-validacion-formularios
19	1	https://example.com/video-html-tablas
20	3	https://example.com/infografia-html-estructura-tablas
21	5	https://example.com/ejercicios-html-tabla-horarios
22	1	https://example.com/video-html-listas
23	2	https://example.com/documento-html-diferencias-listas
24	5	https://example.com/ejercicios-html-lista-tareas
25	1	https://example.com/video-python-oop-conceptos
26	2	https://example.com/documento-python-oop-pilares
27	5	https://example.com/ejercicios-python-oop-identificar-conceptos
28	1	https://example.com/video-python-oop-clases-objetos
29	3	https://example.com/infografia-python-oop-clases-objetos
30	5	https://example.com/ejercicios-python-oop-clase-simple
31	1	https://example.com/video-python-oop-herencia
32	4	https://example.com/guia-python-oop-buenas-practicas-herencia
33	5	https://example.com/ejercicios-python-oop-jerarquia-clases
34	1	https://example.com/video-python-oop-polimorfismo
35	2	https://example.com/documento-python-oop-ejemplos-polimorfismo
36	5	https://example.com/ejercicios-python-oop-implementar-polimorfismo
37	1	https://example.com/video-python-oop-metodos-instancia
38	3	https://example.com/infografia-python-oop-tipos-metodos
39	5	https://example.com/ejercicios-python-oop-metodos-clase
40	1	https://example.com/video-python-oop-atributos-clase
41	4	https://example.com/guia-python-oop-buenas-practicas-atributos
42	5	https://example.com/ejercicios-python-oop-atributos-clase
43	1	https://example.com/video-python-oop-encapsulamiento
44	2	https://example.com/documento-python-oop-getter-setter
45	5	https://example.com/ejercicios-python-oop-implementar-encapsulamiento
46	1	https://example.com/video-python-oop-abstraccion
47	3	https://example.com/infografia-python-oop-ejemplos-abstraccion
48	5	https://example.com/ejercicios-python-oop-clase-abstracta
49	1	https://example.com/video-docker-conceptos
50	2	https://example.com/documento-docker-arquitectura
51	5	https://example.com/ejercicios-docker-instalacion
52	1	https://example.com/video-docker-imagenes-contenedores
53	3	https://example.com/infografia-docker-comandos-basicos
54	5	https://example.com/ejercicios-docker-contenedor
55	1	https://example.com/video-docker-compose-introduccion
56	4	https://example.com/guia-docker-compose-yaml
57	5	https://example.com/ejercicios-docker-compose-yml
58	1	https://example.com/video-docker-compose-despliegue
59	2	https://example.com/documento-docker-compose-ejemplos
60	5	https://example.com/ejercicios-docker-compose-multi-contenedor
61	1	https://example.com/video-docker-redes
62	3	https://example.com/infografia-docker-tipos-redes
63	5	https://example.com/ejercicios-docker-redes
64	1	https://example.com/video-docker-volumenes
65	4	https://example.com/guia-docker-buenas-practicas-volumenes
66	5	https://example.com/ejercicios-docker-volumenes
67	1	https://example.com/video-aritmetica-suma-resta
68	2	https://example.com/documento-aritmetica-propiedades-suma-resta
69	5	https://example.com/ejercicios-aritmetica-suma-resta
70	1	https://example.com/video-aritmetica-multiplicacion-division
71	3	https://example.com/infografia-aritmetica-tablas-multiplicar
72	5	https://example.com/ejercicios-aritmetica-multiplicacion-division
73	1	https://example.com/video-aritmetica-fracciones
74	4	https://example.com/guia-aritmetica-simplificacion-fracciones
75	5	https://example.com/ejercicios-aritmetica-simplificar-fracciones
76	1	https://example.com/video-aritmetica-operaciones-fracciones
77	2	https://example.com/documento-aritmetica-multiplicacion-division-fracciones
78	5	https://example.com/ejercicios-aritmetica-problemas-fracciones
79	1	https://example.com/video-aritmetica-decimales
80	3	https://example.com/infografia-aritmetica-conversion-fracciones-decimales
81	5	https://example.com/ejercicios-aritmetica-conversion-fracciones-decimales
82	1	https://example.com/video-aritmetica-operaciones-decimales
83	4	https://example.com/guia-aritmetica-multiplicacion-division-decimales
84	5	https://example.com/ejercicios-aritmetica-problemas-decimales
85	1	https://example.com/video-algebra-expresiones
86	2	https://example.com/documento-algebra-terminos-coeficientes
87	5	https://example.com/ejercicios-algebra-simplificar-expresiones
88	1	https://example.com/video-algebra-operaciones-expresiones
89	3	https://example.com/infografia-algebra-multiplicacion-expresiones
90	5	https://example.com/ejercicios-algebra-problemas-expresiones
91	1	https://example.com/video-algebra-ecuaciones
92	4	https://example.com/guia-algebra-pasos-resolver-ecuaciones
93	5	https://example.com/ejercicios-algebra-resolver-ecuaciones
94	1	https://example.com/video-algebra-aplicaciones-ecuaciones
95	2	https://example.com/documento-algebra-ejemplos-aplicaciones
96	5	https://example.com/ejercicios-algebra-problemas-aplicados
97	1	https://example.com/video-algebra-sistemas-ecuaciones
98	3	https://example.com/infografia-algebra-metodos-resolucion
99	5	https://example.com/ejercicios-algebra-sistemas-simples
100	1	https://example.com/video-algebra-metodos-avanzados
101	4	https://example.com/guia-algebra-metodo-grafico
102	5	https://example.com/ejercicios-algebra-sistemas-complejos
103	1	https://example.com/video-calculo-limites
104	2	https://example.com/documento-calculo-propiedades-limites
105	5	https://example.com/ejercicios-calculo-limites-basicos
106	1	https://example.com/video-calculo-limites-laterales
107	3	https://example.com/infografia-calculo-limites-laterales
108	5	https://example.com/ejercicios-calculo-limites-laterales
109	1	https://example.com/video-calculo-derivadas
110	4	https://example.com/guia-calculo-reglas-derivacion
111	5	https://example.com/ejercicios-calculo-derivar-funciones
112	1	https://example.com/video-calculo-aplicaciones-derivadas
113	2	https://example.com/documento-calculo-problemas-optimizacion
114	5	https://example.com/ejercicios-calculo-optimizacion
115	1	https://example.com/video-calculo-integrales
116	3	https://example.com/infografia-calculo-integrales-definidas-indefinidas
117	5	https://example.com/ejercicios-calculo-integrales-basicas
118	1	https://example.com/video-calculo-integracion-partes
119	4	https://example.com/guia-calculo-sustitucion-trigonometrica
120	5	https://example.com/ejercicios-calculo-integrales-complejas
121	1	https://example.com/video-fisica-cuantica-conceptos
122	2	https://example.com/documento-fisica-cuantica-principios
123	5	https://example.com/ejercicios-fisica-cuantica-identificar-conceptos
124	1	https://example.com/video-fisica-cuantica-dualidad-onda-particula
125	3	https://example.com/infografia-fisica-cuantica-dualidad
126	5	https://example.com/ejercicios-fisica-cuantica-analizar-experimento
127	1	https://example.com/video-fisica-cuantica-ecuacion-schrodinger
128	4	https://example.com/guia-fisica-cuantica-resolucion-problemas
129	5	https://example.com/ejercicios-fisica-cuantica-resolver-ecuacion
130	1	https://example.com/video-fisica-cuantica-principio-incertidumbre
131	2	https://example.com/documento-fisica-cuantica-aplicaciones-principio
132	5	https://example.com/ejercicios-fisica-cuantica-analizar-casos-incertidumbre
133	1	https://example.com/video-fisica-cuantica-computacion-cuantica
134	3	https://example.com/infografia-fisica-cuantica-qubits-superposicion
135	5	https://example.com/ejercicios-fisica-cuantica-analizar-circuito-cuantico
136	1	https://example.com/video-fisica-cuantica-teleportacion
137	4	https://example.com/guia-fisica-cuantica-experimentos-teleportacion
138	5	https://example.com/ejercicios-fisica-cuantica-investigar-experimento
139	1	https://example.com/video-fisica-mru
140	2	https://example.com/documento-fisica-formulas-mru
141	5	https://example.com/ejercicios-fisica-problemas-mru
142	1	https://example.com/video-fisica-mrua
143	3	https://example.com/infografia-fisica-formulas-mrua
144	5	https://example.com/ejercicios-fisica-problemas-mrua
145	1	https://example.com/video-fisica-leyes-newton
146	4	https://example.com/guia-fisica-aplicaciones-leyes-newton
147	5	https://example.com/ejercicios-fisica-problemas-dinamica
148	1	https://example.com/video-fisica-fuerza-movimiento
149	2	https://example.com/documento-fisica-ejemplos-fuerzas
150	5	https://example.com/ejercicios-fisica-analizar-fuerzas-sistemas
151	1	https://example.com/video-fisica-tipos-energia
152	3	https://example.com/infografia-fisica-conservacion-energia
153	5	https://example.com/ejercicios-fisica-problemas-energia
154	1	https://example.com/video-fisica-trabajo-potencia
155	4	https://example.com/guia-fisica-formulas-trabajo-potencia
156	5	https://example.com/ejercicios-fisica-problemas-trabajo-potencia
157	1	https://example.com/video-arte-egipcio
158	2	https://example.com/documento-arte-piramides-jeroglificos
159	5	https://example.com/ejercicios-arte-analizar-obra-egipcia
160	1	https://example.com/video-arte-griego
161	3	https://example.com/infografia-arte-estilos-griegos
162	5	https://example.com/ejercicios-arte-comparar-obras-griegas
163	1	https://example.com/video-arte-renacimiento
164	4	https://example.com/guia-arte-obras-destacadas-renacimiento
165	5	https://example.com/ejercicios-arte-analizar-obra-renacentista
166	1	https://example.com/video-arte-artistas-renacimiento
167	2	https://example.com/documento-arte-biografias-artistas
168	5	https://example.com/ejercicios-arte-investigar-artista
169	1	https://example.com/video-arte-impresionismo
170	3	https://example.com/infografia-arte-obras-impresionistas
171	5	https://example.com/ejercicios-arte-analizar-obra-impresionista
172	1	https://example.com/video-arte-abstracto
173	4	https://example.com/guia-arte-artistas-abstractos
174	5	https://example.com/ejercicios-arte-crear-obra-abstracta
175	1	https://example.com/video-alienigenas-teoria
176	2	https://example.com/documento-alienigenas-evidencias
177	5	https://example.com/ejercicios-alienigenas-investigar-evidencia
178	1	https://example.com/video-alienigenas-civilizaciones-antiguas
179	3	https://example.com/infografia-alienigenas-analisis-piramides
180	5	https://example.com/ejercicios-alienigenas-comparar-estructuras
181	1	https://example.com/video-alienigenas-artefactos-misteriosos
182	4	https://example.com/guia-alienigenas-analisis-artefactos
183	5	https://example.com/ejercicios-alienigenas-investigar-artefacto
184	1	https://example.com/video-alienigenas-textos-antiguos
185	2	https://example.com/documento-alienigenas-ejemplos-textos
186	5	https://example.com/ejercicios-alienigenas-analizar-texto
187	1	https://example.com/video-alienigenas-conexiones-extraterrestres
188	3	https://example.com/infografia-alienigenas-ejemplos-conexiones
189	5	https://example.com/ejercicios-alienigenas-investigar-conexion
190	1	https://example.com/video-alienigenas-criticas-teoria
191	4	https://example.com/guia-alienigenas-respuestas-criticas
192	5	https://example.com/ejercicios-alienigenas-analizar-criticas
193	1	https://example.com/video-marketing-digital-conceptos
194	2	https://example.com/documento-marketing-digital-canales
195	5	https://example.com/ejercicios-marketing-digital-identificar-canales
196	1	https://example.com/video-marketing-digital-estrategias
197	3	https://example.com/infografia-marketing-digital-ejemplos-estrategias
198	5	https://example.com/ejercicios-marketing-digital-crear-estrategia
199	1	https://example.com/video-marketing-digital-seo
200	4	https://example.com/guia-marketing-digital-tecnicas-seo
201	5	https://example.com/ejercicios-marketing-digital-aplicar-seo
202	1	https://example.com/video-marketing-digital-sem
203	2	https://example.com/documento-marketing-digital-creacion-campanas-sem
204	5	https://example.com/ejercicios-marketing-digital-disenar-campana-sem
205	1	https://example.com/video-marketing-digital-redes-sociales
206	3	https://example.com/infografia-marketing-digital-plataformas
207	5	https://example.com/ejercicios-marketing-digital-crear-plan-redes
208	1	https://example.com/video-marketing-digital-publicidad-redes
209	4	https://example.com/guia-marketing-digital-segmentacion-audiencias
210	5	https://example.com/ejercicios-marketing-digital-disenar-campana-publicitaria
\.


--
-- Data for Name: content_lessons; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.content_lessons (id_content, id_lesson) FROM stdin;
1	1
2	1
3	1
4	2
5	2
6	2
7	3
8	3
9	3
10	4
11	4
12	4
13	5
14	5
15	5
16	6
17	6
18	6
19	7
20	7
21	7
22	8
23	8
24	8
25	9
26	9
27	9
28	10
29	10
30	10
31	11
32	11
33	11
34	12
35	12
36	12
37	13
38	13
39	13
40	14
41	14
42	14
43	15
44	15
45	15
46	16
47	16
48	16
49	17
50	17
51	17
52	18
53	18
54	18
55	19
56	19
57	19
58	20
59	20
60	20
61	21
62	21
63	21
64	22
65	22
66	22
67	23
68	23
69	23
70	24
71	24
72	24
73	25
74	25
75	25
76	26
77	26
78	26
79	27
80	27
81	27
82	28
83	28
84	28
85	29
86	29
87	29
88	30
89	30
90	30
91	31
92	31
93	31
94	32
95	32
96	32
97	33
98	33
99	33
100	34
101	34
102	34
103	35
104	35
105	35
106	36
107	36
108	36
109	37
110	37
111	37
112	38
113	38
114	38
115	39
116	39
117	39
118	40
119	40
120	40
121	41
122	41
123	41
124	42
125	42
126	42
127	43
128	43
129	43
130	44
131	44
132	44
133	45
134	45
135	45
136	46
137	46
138	46
139	47
140	47
141	47
142	48
143	48
144	48
145	49
146	49
147	49
148	50
149	50
150	50
151	51
152	51
153	51
154	52
155	52
156	52
157	53
158	53
159	53
160	54
161	54
162	54
163	55
164	55
165	55
166	56
167	56
168	56
169	57
170	57
171	57
172	58
173	58
174	58
175	59
176	59
177	59
178	60
179	60
180	60
181	61
182	61
183	61
184	62
185	62
186	62
187	63
188	63
189	63
190	64
191	64
192	64
193	65
194	65
195	65
196	66
197	66
198	66
199	67
200	67
201	67
202	68
203	68
204	68
205	69
206	69
207	69
208	70
209	70
210	70
\.


--
-- Data for Name: content_type; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.content_type (id, type) FROM stdin;
1	Video
2	Documento
3	Infografia
4	Guia
5	Ejercicios
\.


--
-- Data for Name: course_category; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.course_category (id, category) FROM stdin;
1	Ciencias Basicas
2	Computacion
3	Humanidades
4	Marketing
\.


--
-- Data for Name: course_level; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.course_level (id, level) FROM stdin;
1	Basico
2	Intermedio
3	Avanzado
\.


--
-- Data for Name: course_status; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.course_status (id, status) FROM stdin;
1	Activo
2	Inactivo
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.courses (id, name, description, category, level, duration, price, status) FROM stdin;
1	HTML Desde 0	Curso introductorio de HTML	2	1	7	10.99	1
3	Docker	Curso de Docker para despliegue de aplicaciones	2	2	30	25.99	1
4	Aritmética	Curso de aritmética básica	1	1	7	5.00	1
5	Álgebra	Curso de álgebra básica	1	2	15	10.00	1
6	Cálculo	Curso de cálculo básico	1	3	30	25.00	1
7	Física Cuántica	Curso introductorio a la física cuántica	1	3	230	1000.99	2
8	Física Bachillerato	Curso de física para bachillerato	1	2	60	30.00	1
9	Historia del Arte	Curso de historia del arte	3	2	100	500.00	1
10	Alienígenas Ancestrales	Curso sobre teorías de alienígenas ancestrales	3	3	365000	999999.99	1
11	Marketing Digital	Curso de marketing digital	4	1	365	5000.00	2
2	Python OOP	Curso de Programación Orientada a Objetos en Python	2	2	15	50.00	2
\.


--
-- Data for Name: evaluations; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.evaluations (id, id_module, max_grade, title) FROM stdin;
1	1	20.00	Crear una página básica con texto
2	2	20.00	Crear una página con enlaces e imágenes
3	3	20.00	Crear y validar un formulario completo
4	4	20.00	Crear una página con tablas y listas
5	5	20.00	Crear una clase con atributos básicos
6	6	20.00	Crear una jerarquía con herencia y polimorfismo
7	7	20.00	Crear una clase con métodos y atributos avanzados
8	8	20.00	Implementar encapsulamiento y abstracción en un proyecto
9	9	20.00	Crear y gestionar un contenedor básico
10	10	20.00	Desplegar una aplicación completa con Docker Compose
11	11	20.00	Configurar redes y volúmenes en un proyecto
12	12	20.00	Prueba de operaciones básicas
13	13	20.00	Prueba de fracciones
14	14	20.00	Prueba de números decimales
15	15	20.00	Simplificación de expresiones
16	16	20.00	Prueba de ecuaciones lineales
17	17	20.00	Prueba de sistemas de ecuaciones
18	18	20.00	Prueba de límites
19	19	20.00	Prueba de derivadas
20	20	20.00	Prueba de integrales
21	21	20.00	Preguntas conceptuales
22	22	20.00	Prueba de mecánica cuántica
23	23	20.00	Prueba de aplicaciones cuánticas
24	24	20.00	Prueba de cinemática
25	25	20.00	Prueba de dinámica
26	26	20.00	Prueba de energía y trabajo
27	27	20.00	Preguntas sobre arte antiguo
28	28	20.00	Prueba sobre el Renacimiento
29	29	20.00	Prueba de arte moderno
30	30	20.00	Preguntas conceptuales
31	31	20.00	Prueba de evidencias arqueológicas
32	32	20.00	Prueba de teorías alternativas
33	33	20.00	Preguntas conceptuales
34	34	20.00	Prueba de SEO y SEM
35	35	20.00	Prueba de redes sociales
\.


--
-- Data for Name: instructors; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.instructors (id, specialty, badge) FROM stdin;
1106	5	4
1066	3	2
1067	3	4
1068	3	2
1069	3	1
1070	3	4
1071	3	2
1072	3	3
1073	3	3
1074	3	2
1075	3	3
1076	3	2
1077	3	4
1078	3	1
1079	3	2
1080	3	3
1081	3	2
1082	3	4
1083	3	3
1084	3	3
1085	3	1
1107	5	3
1108	5	2
1109	5	1
1110	5	3
1111	5	1
1112	5	2
1113	5	1
1114	5	2
1115	5	3
1116	5	4
1117	5	3
1118	5	3
1119	5	1
1120	5	4
1121	5	4
1122	5	2
1123	5	1
1124	5	4
1125	6	4
1026	1	1
1027	1	1
1028	1	3
1029	1	1
1030	1	3
1031	1	2
1032	1	1
1033	1	1
1034	1	4
1035	1	2
1036	1	2
1037	1	3
1038	1	2
1039	1	3
1040	1	1
1041	1	2
1042	1	3
1043	1	2
1044	1	4
1045	1	2
1046	2	4
1047	2	2
1048	2	4
1049	2	1
1050	2	4
1051	2	3
1052	2	3
1053	2	2
1054	2	4
1055	2	4
1056	2	2
1057	2	3
1058	2	4
1059	2	1
1060	2	4
1061	2	4
1062	2	2
1063	2	2
1064	2	2
1065	2	2
1086	4	4
1087	4	3
1088	4	1
1089	4	3
1090	4	2
1091	4	1
1092	4	2
1093	4	4
1094	4	2
1095	4	2
1096	4	3
1097	4	1
1098	4	1
1099	4	2
1100	4	1
1101	4	3
1102	4	3
1103	4	2
1104	4	3
1105	4	2
\.


--
-- Data for Name: instructors_courses; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.instructors_courses (id_instructor, id_course) FROM stdin;
1046	7
1046	8
1047	7
1047	8
1048	7
1048	8
1049	7
1049	8
1050	7
1050	8
1051	7
1051	8
1052	7
1052	8
1053	7
1053	8
1054	7
1054	8
1055	7
1055	8
1056	7
1056	8
1057	7
1057	8
1058	7
1058	8
1059	7
1059	8
1060	7
1060	8
1061	7
1061	8
1062	7
1062	8
1063	7
1063	8
1064	7
1064	8
1065	7
1065	8
1066	1
1066	3
1066	2
1067	1
1067	3
1067	2
1068	1
1068	3
1068	2
1069	1
1069	3
1069	2
1070	1
1070	3
1070	2
1071	1
1071	3
1071	2
1072	1
1072	3
1072	2
1073	1
1073	3
1073	2
1074	1
1074	3
1074	2
1075	1
1075	3
1075	2
1076	1
1076	3
1076	2
1077	1
1077	3
1077	2
1078	1
1078	3
1078	2
1079	1
1079	3
1079	2
1080	1
1080	3
1080	2
1081	1
1081	3
1081	2
1082	1
1082	3
1082	2
1083	1
1083	3
1083	2
1084	1
1084	3
1084	2
1085	1
1085	3
1085	2
1086	9
1087	9
1088	9
1089	9
1090	9
1091	9
1092	9
1093	9
1094	9
1095	9
1096	9
1097	9
1098	9
1099	9
1100	9
1101	9
1102	9
1103	9
1104	9
1105	9
1106	11
1107	11
1108	11
1109	11
1110	11
1111	11
1112	11
1113	11
1114	11
1115	11
1116	11
1117	11
1118	11
1119	11
1120	11
1121	11
1122	11
1123	11
1124	11
1125	10
\.


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.lessons (id, id_module, title, duration) FROM stdin;
1	1	Conceptos Básicos	30
2	1	Etiquetas básicas	45
3	2	Etiquetas de enlace	30
4	2	Etiquetas de imágenes	45
5	3	Creación de formularios	30
6	3	Validación de formularios	45
7	4	Creación de tablas	30
8	4	Listas ordenadas y desordenadas	45
9	5	Conceptos Básicos	30
10	5	Clases y Objetos	45
11	6	Herencia	30
12	6	Polimorfismo	45
13	7	Métodos de instancia	30
14	7	Atributos de clase	45
15	8	Encapsulamiento	30
16	8	Abstracción	45
17	9	Conceptos Básicos	30
18	9	Imágenes y Contenedores	45
19	10	Introducción a Docker Compose	30
20	10	Despliegue de aplicaciones	45
21	11	Redes en Docker	30
22	11	Volúmenes en Docker	45
23	12	Suma y Resta	30
24	12	Multiplicación y División	45
25	13	Introducción a las fracciones	30
26	13	Operaciones con fracciones	45
27	14	Introducción a los decimales	30
28	14	Operaciones con decimales	45
29	15	Introducción a las expresiones	30
30	15	Operaciones con expresiones	45
31	16	Resolución de ecuaciones	30
32	16	Aplicaciones de ecuaciones	45
33	17	Introducción a los sistemas	30
34	17	Métodos avanzados	45
35	18	Introducción a los límites	30
36	18	Límites laterales	45
37	19	Conceptos de derivadas	30
38	19	Aplicaciones de derivadas	45
39	20	Introducción a las integrales	30
40	20	Métodos de integración	45
41	21	Conceptos Básicos	30
42	21	Dualidad Onda-Partícula	45
43	22	Ecuación de Schrödinger	30
44	22	Principio de Incertidumbre	45
45	23	Computación Cuántica	30
46	23	Teleportación Cuántica	45
47	24	Movimiento Rectilíneo Uniforme	30
48	24	Movimiento Rectilíneo Uniformemente Acelerado	45
49	25	Leyes de Newton	30
50	25	Fuerza y Movimiento	45
51	26	Conceptos de Energía	30
52	26	Trabajo y Potencia	45
53	27	Arte Egipcio	30
54	27	Arte Griego	45
55	28	Arte del Renacimiento	30
56	28	Artistas del Renacimiento	45
57	29	Impresionismo	30
58	29	Arte Abstracto	45
59	30	Introducción a la teoría	30
60	30	Civilizaciones Antiguas	45
61	31	Artefactos misteriosos	30
62	31	Textos antiguos	45
63	32	Conexiones extraterrestres	30
64	32	Críticas a la teoría	45
65	33	Conceptos Básicos	30
66	33	Estrategias de Marketing	45
67	34	Optimización para motores de búsqueda	30
68	34	Publicidad en buscadores	45
69	35	Estrategias en redes sociales	30
70	35	Publicidad en redes sociales	45
\.


--
-- Data for Name: modules; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.modules (id, id_course, title, description) FROM stdin;
1	1	Introducción a HTML	Conceptos básicos de HTML
2	1	Enlaces e Imágenes	Uso de etiquetas de enlace e imágenes
3	1	Formularios	Creación y validación de formularios
4	1	Tablas y Listas	Creación de tablas y listas
5	2	Introducción a OOP	Conceptos básicos de Programación Orientada a Objetos
6	2	Herencia y Polimorfismo	Herencia y polimorfismo en Python
7	2	Métodos y Atributos	Métodos y atributos en clases
8	2	Encapsulamiento y Abstracción	Encapsulamiento y abstracción en Python
9	3	Introducción a Docker	Conceptos básicos de Docker
10	3	Docker Compose	Uso de Docker Compose para despliegue
11	3	Redes y Volúmenes	Configuración de redes y volúmenes en Docker
12	4	Operaciones Básicas	Suma, resta, multiplicación y división
13	4	Fracciones	Introducción a las fracciones
14	4	Números Decimales	Operaciones con números decimales
15	5	Expresiones Algebraicas	Introducción a las expresiones algebraicas
16	5	Ecuaciones Lineales	Resolución de ecuaciones lineales
17	5	Sistemas de Ecuaciones	Resolución de sistemas de ecuaciones
18	6	Límites	Conceptos básicos de límites
19	6	Derivadas	Introducción a las derivadas
20	6	Integrales	Conceptos básicos de integrales
21	7	Introducción a la Física Cuántica	Conceptos básicos de física cuántica
22	7	Mecánica Cuántica	Ecuación de Schrödinger y principio de incertidumbre
23	7	Aplicaciones de la Física Cuántica	Computación cuántica y teleportación
24	8	Cinemática	Movimiento rectilíneo uniforme y acelerado
25	8	Dinámica	Leyes de Newton y fuerza
26	8	Energía y Trabajo	Conceptos de energía y trabajo
27	9	Arte Antiguo	Arte egipcio y griego
28	9	Renacimiento	Arte del Renacimiento
29	9	Arte Moderno	Impresionismo y arte abstracto
30	10	Teorías de los Antiguos Astronautas	Introducción a la teoría
31	10	Evidencias Arqueológicas	Artefactos y textos antiguos
32	10	Teorías Alternativas	Conexiones extraterrestres y críticas
33	11	Introducción al Marketing Digital	Conceptos básicos de marketing digital
34	11	SEO y SEM	Optimización para motores de búsqueda y publicidad
35	11	Redes Sociales	Estrategias en redes sociales
\.


--
-- Data for Name: specialties; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.specialties (id, specialty) FROM stdin;
1	Matematicas
2	Fisica
3	Informatica
4	Historia
5	Marketing
6	History Channel
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.students (id, points, badge) FROM stdin;
26	75	4
27	11	1
28	87	1
29	18	1
30	72	2
31	66	4
32	81	3
33	58	3
34	61	4
35	34	2
36	66	3
37	53	3
38	66	3
39	22	1
40	27	3
41	6	4
42	54	2
43	38	2
44	60	1
45	30	3
46	85	1
47	33	1
48	86	1
49	42	3
50	92	3
51	23	3
52	7	1
53	53	4
54	8	1
55	32	1
56	45	2
57	55	1
58	53	4
59	23	2
60	81	4
61	98	2
62	34	4
63	70	2
64	20	1
65	23	4
66	31	1
67	95	4
68	95	3
69	21	1
70	26	3
71	29	1
72	67	1
73	35	1
74	39	2
75	43	2
76	89	3
77	94	2
78	53	2
79	5	2
80	36	4
81	5	3
82	32	2
83	26	3
84	16	4
85	99	1
86	88	1
87	59	3
88	48	1
89	11	1
90	49	3
91	37	4
92	76	3
93	45	1
94	22	2
95	23	1
96	47	4
97	42	4
98	63	1
99	59	1
100	71	2
101	63	2
102	46	4
103	12	3
104	76	2
105	44	1
106	64	1
107	66	4
108	25	2
109	18	3
110	12	1
111	42	4
112	97	3
113	90	1
114	39	2
115	95	2
116	76	4
117	12	1
118	80	2
119	29	3
120	51	2
121	87	2
122	85	4
123	16	1
124	92	3
125	40	1
126	23	2
127	41	4
128	39	1
129	77	1
130	73	4
131	100	1
132	21	3
133	90	1
134	98	2
135	25	4
136	9	1
137	78	1
138	49	3
139	12	3
140	62	1
141	49	4
142	54	1
143	82	4
144	94	2
145	99	2
146	100	4
147	55	2
148	5	2
149	99	4
150	29	4
151	29	4
152	3	3
153	30	2
154	89	2
155	39	3
156	32	3
157	36	1
158	40	2
159	18	4
160	91	1
161	100	1
162	39	3
163	20	1
164	93	1
165	10	3
166	99	2
167	40	1
168	77	2
169	38	2
170	40	2
171	29	4
172	53	4
173	37	1
174	10	3
175	98	4
176	72	4
177	29	1
178	66	2
179	50	3
180	27	3
181	37	1
182	23	4
183	42	4
184	94	2
185	19	3
186	42	3
187	92	1
188	46	4
189	52	4
190	74	2
191	61	1
192	19	1
193	65	1
194	38	3
195	94	3
196	14	2
197	77	1
198	15	2
199	60	2
200	80	4
201	63	4
202	38	2
203	17	4
204	97	3
205	85	1
206	73	1
207	42	1
208	60	2
209	21	3
210	82	4
211	15	3
212	39	3
213	33	1
214	37	4
215	53	3
216	48	2
217	54	2
218	87	2
219	92	1
220	52	4
221	50	1
222	45	2
223	61	1
224	29	2
225	94	2
226	50	3
227	17	4
228	75	4
229	51	3
230	91	2
231	41	2
232	34	3
233	70	4
234	5	2
235	90	4
236	27	1
237	77	1
238	73	1
239	24	3
240	100	1
241	31	1
242	55	3
243	75	4
244	8	4
245	92	2
246	68	3
247	33	1
248	11	1
249	29	4
250	62	3
251	32	3
252	73	3
253	27	4
254	71	4
255	65	1
256	93	3
257	12	3
258	70	2
259	81	1
260	70	2
261	88	1
262	100	1
263	6	3
264	64	2
265	56	4
266	55	1
267	61	3
268	80	3
269	5	4
270	8	2
271	79	2
272	51	1
273	16	1
274	39	4
275	54	3
276	79	4
277	16	3
278	54	1
279	14	4
280	14	1
281	64	3
282	60	4
283	89	2
284	55	4
285	94	4
286	60	1
287	10	2
288	38	3
289	29	3
290	8	3
291	1	1
292	40	3
293	94	4
294	41	1
295	49	3
296	41	2
297	20	3
298	38	4
299	50	2
300	68	4
301	57	2
302	46	3
303	87	3
304	45	4
305	22	4
306	66	4
307	34	2
308	19	4
309	31	4
310	75	2
311	39	3
312	4	3
313	87	3
314	20	4
315	32	4
316	97	4
317	10	2
318	84	4
319	94	2
320	69	1
321	9	3
322	8	4
323	77	3
324	35	1
325	41	1
326	81	2
327	90	1
328	67	3
329	24	2
330	19	3
331	33	4
332	74	1
333	84	1
334	68	2
335	82	3
336	80	1
337	73	3
338	92	3
339	82	4
340	24	3
341	95	2
342	99	2
343	76	1
344	29	1
345	44	1
346	70	1
347	7	1
348	3	2
349	78	2
350	95	2
351	23	4
352	84	1
353	37	3
354	13	2
355	20	1
356	72	4
357	77	2
358	26	3
359	27	4
360	81	1
361	26	2
362	87	1
363	79	1
364	80	4
365	52	2
366	77	4
367	20	1
368	60	2
369	87	2
370	58	1
371	75	2
372	31	4
373	10	1
374	31	2
375	37	3
376	23	3
377	3	3
378	54	2
379	30	1
380	13	4
381	33	2
382	23	4
383	41	3
384	60	1
385	94	2
386	80	2
387	84	2
388	80	3
389	36	1
390	78	3
391	67	4
392	72	2
393	20	2
394	24	2
395	79	1
396	60	1
397	63	4
398	50	1
399	81	3
400	84	4
401	84	3
402	77	1
403	58	3
404	15	3
405	100	1
406	1	3
407	36	2
408	57	3
409	41	3
410	1	3
411	99	3
412	94	1
413	22	1
414	65	2
415	5	3
416	74	1
417	90	2
418	79	4
419	24	3
420	83	4
421	63	4
422	15	3
423	37	4
424	22	4
425	22	1
426	74	4
427	35	3
428	46	3
429	26	2
430	63	1
431	42	3
432	98	2
433	2	1
434	34	1
435	99	3
436	14	1
437	98	1
438	82	1
439	20	2
440	16	4
441	6	3
442	40	3
443	8	2
444	86	3
445	36	2
446	83	1
447	88	2
448	80	3
449	36	4
450	34	3
451	13	4
452	23	4
453	13	3
454	10	2
455	4	4
456	7	1
457	88	1
458	8	4
459	7	4
460	23	4
461	2	1
462	52	3
463	98	2
464	50	4
465	43	4
466	67	1
467	59	2
468	49	4
469	23	2
470	95	3
471	62	4
472	33	2
473	85	1
474	93	4
475	72	1
476	4	2
477	61	2
478	76	3
479	44	2
480	71	3
481	10	2
482	3	3
483	52	3
484	62	4
485	8	3
486	58	3
487	82	2
488	71	1
489	94	4
490	49	2
491	82	2
492	13	3
493	6	1
494	62	2
495	23	1
496	17	2
497	85	1
498	77	4
499	43	3
500	75	2
501	100	1
502	15	1
503	42	1
504	21	4
505	36	4
506	68	3
507	76	2
508	14	4
509	39	1
510	53	2
511	54	1
512	28	3
513	45	4
514	17	2
515	54	3
516	17	1
517	12	3
518	83	3
519	7	2
520	31	1
521	87	3
522	47	1
523	60	2
524	32	3
525	34	1
526	91	3
527	45	1
528	15	2
529	27	4
530	54	1
531	22	4
532	60	4
533	32	2
534	47	1
535	14	1
536	82	4
537	92	3
538	88	2
539	4	2
540	7	1
541	35	2
542	62	3
543	86	3
544	78	2
545	8	3
546	65	2
547	14	4
548	99	4
549	46	3
550	8	4
551	91	1
552	45	1
553	33	4
554	40	2
555	80	2
556	97	2
557	61	4
558	25	3
559	72	3
560	67	2
561	26	2
562	79	3
563	16	4
564	32	2
565	45	4
566	14	2
567	24	3
568	15	1
569	63	4
570	12	4
571	4	1
572	79	1
573	92	3
574	5	1
575	5	2
576	11	4
577	14	3
578	36	1
579	48	1
580	20	4
581	37	1
582	20	3
583	6	3
584	33	4
585	52	2
586	89	2
587	62	2
588	31	3
589	43	4
590	11	2
591	51	3
592	99	4
593	37	3
594	7	2
595	29	2
596	55	3
597	95	4
598	31	2
599	46	1
600	64	2
601	35	3
602	18	2
603	42	1
604	13	4
605	41	4
606	57	4
607	36	1
608	100	3
609	86	1
610	31	1
611	82	2
612	76	3
613	61	4
614	53	4
615	88	3
616	82	2
617	61	3
618	69	2
619	79	1
620	8	4
621	5	3
622	48	3
623	63	4
624	24	2
625	70	2
626	92	3
627	99	1
628	28	4
629	6	2
630	51	4
631	64	1
632	5	1
633	12	4
634	62	3
635	57	3
636	50	3
637	62	2
638	48	1
639	14	3
640	22	4
641	83	3
642	54	1
643	84	2
644	90	3
645	53	3
646	3	1
647	37	4
648	12	4
649	43	4
650	19	4
651	19	3
652	26	4
653	28	1
654	87	1
655	26	3
656	55	4
657	65	2
658	53	4
659	43	4
660	88	4
661	1	3
662	24	3
663	79	1
664	68	2
665	49	2
666	46	2
667	67	2
668	13	2
669	25	4
670	20	4
671	3	1
672	13	2
673	87	2
674	27	4
675	57	3
676	25	1
677	100	2
678	77	3
679	32	4
680	99	3
681	9	1
682	15	2
683	93	2
684	51	4
685	75	2
686	29	3
687	89	1
688	54	4
689	92	1
690	98	1
691	98	4
692	85	3
693	98	1
694	84	2
695	16	3
696	22	4
697	96	1
698	4	4
699	82	3
700	88	1
701	51	1
702	1	2
703	32	4
704	52	1
705	62	2
706	96	2
707	55	2
708	66	1
709	17	1
710	87	3
711	65	1
712	46	4
713	22	1
714	33	4
715	59	1
716	21	4
717	83	4
718	55	3
719	96	2
720	71	1
721	96	2
722	35	1
723	35	3
724	83	3
725	52	3
726	99	4
727	1	2
728	40	2
729	50	1
730	22	3
731	54	4
732	45	2
733	6	1
734	65	3
735	17	4
736	90	1
737	35	2
738	13	2
739	45	2
740	29	3
741	85	1
742	69	3
743	38	2
744	31	1
745	80	3
746	97	4
747	13	4
748	69	1
749	48	1
750	14	4
751	37	1
752	2	4
753	42	2
754	24	2
755	46	3
756	64	3
757	80	4
758	49	2
759	69	3
760	85	3
761	63	4
762	88	2
763	8	3
764	73	3
765	67	3
766	5	3
767	7	1
768	53	1
769	24	2
770	23	3
771	18	1
772	80	3
773	99	4
774	89	4
775	10	3
776	87	2
777	57	1
778	25	2
779	47	4
780	93	1
781	61	2
782	13	1
783	1	3
784	47	1
785	84	3
786	37	3
787	18	3
788	50	3
789	2	4
790	40	1
791	35	1
792	56	2
793	45	1
794	77	1
795	10	1
796	78	3
797	78	1
798	10	4
799	74	3
800	100	1
801	38	2
802	5	3
803	21	4
804	26	1
805	74	4
806	7	4
807	80	4
808	94	3
809	34	1
810	47	4
811	47	4
812	39	4
813	49	2
814	28	1
815	50	4
816	90	3
817	78	4
818	63	1
819	66	2
820	83	1
821	6	4
822	72	3
823	59	3
824	74	1
825	36	1
826	4	3
827	51	2
828	78	1
829	25	4
830	77	1
831	74	2
832	95	2
833	65	4
834	97	4
835	13	1
836	59	3
837	26	4
838	74	2
839	71	2
840	26	3
841	53	3
842	31	3
843	54	2
844	81	4
845	16	4
846	29	2
847	37	3
848	30	1
849	39	3
850	70	4
851	17	3
852	9	4
853	68	2
854	80	3
855	70	3
856	90	2
857	72	4
858	86	2
859	20	3
860	79	4
861	22	3
862	15	4
863	63	2
864	18	2
865	18	4
866	44	1
867	62	2
868	62	2
869	93	1
870	25	2
871	74	2
872	59	4
873	97	4
874	56	3
875	54	2
876	95	3
877	25	1
878	30	2
879	82	3
880	36	2
881	16	2
882	88	2
883	23	3
884	79	4
885	28	1
886	7	1
887	21	1
888	53	3
889	86	3
890	48	2
891	69	2
892	45	3
893	82	1
894	66	3
895	99	3
896	96	1
897	52	3
898	41	3
899	16	3
900	44	3
901	66	2
902	48	2
903	19	1
904	82	4
905	42	2
906	80	1
907	83	2
908	9	4
909	57	3
910	96	1
911	64	3
912	94	3
913	85	2
914	72	4
915	36	2
916	46	2
917	24	4
918	48	1
919	18	2
920	30	2
921	100	3
922	11	3
923	1	2
924	82	2
925	74	2
926	57	1
927	67	1
928	17	2
929	66	4
930	62	3
931	62	3
932	99	4
933	84	1
934	15	3
935	60	3
936	39	4
937	59	3
938	38	1
939	74	3
940	83	2
941	79	1
942	7	3
943	22	2
944	79	1
945	20	3
946	36	1
947	72	4
948	38	3
949	70	3
950	44	1
951	8	2
952	77	2
953	48	1
954	90	1
955	85	3
956	56	4
957	98	4
958	62	3
959	33	3
960	57	2
961	96	4
962	22	4
963	55	3
964	79	1
965	41	3
966	70	3
967	50	4
968	84	3
969	70	3
970	77	2
971	73	3
972	77	4
973	47	1
974	75	2
975	72	4
976	27	1
977	81	1
978	42	2
979	42	2
980	59	2
981	77	2
982	86	2
983	61	1
984	29	2
985	89	3
986	14	1
987	77	3
988	49	3
989	6	3
990	21	4
991	82	1
992	59	1
993	11	2
994	41	1
995	5	3
996	18	3
997	6	4
998	22	4
999	85	4
1000	9	3
1001	58	4
1002	88	1
1003	11	2
1004	79	2
1005	33	3
1006	4	3
1007	1	3
1008	3	2
1009	7	4
1010	76	2
1011	26	4
1012	92	3
1013	54	1
1014	59	1
1015	35	3
1016	16	2
1017	63	1
1018	47	4
1019	56	1
1020	9	2
1021	82	1
1022	9	2
1023	11	4
1024	7	2
1025	81	1
\.


--
-- Data for Name: students_courses; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.students_courses (id_student, id_course, inscription_date, progress, grade, cert) FROM stdin;
26	6	2022-01-14 15:28:07.15875	\N	\N	f
26	9	2022-10-04 22:59:36.482129	\N	\N	f
26	8	2023-07-12 00:12:17.621417	\N	\N	f
26	2	2023-08-07 14:44:42.986375	\N	\N	f
27	9	2022-02-11 05:45:46.672989	\N	\N	f
27	11	2022-03-05 21:42:20.953982	\N	\N	f
28	4	2022-01-06 12:10:00.310571	\N	\N	f
28	11	2023-06-22 16:08:22.197081	\N	\N	f
29	3	2022-03-22 15:12:40.862902	\N	\N	f
29	7	2022-11-21 17:25:34.177546	\N	\N	f
30	6	2022-07-08 12:31:32.484249	\N	\N	f
30	10	2023-06-14 08:21:55.314363	\N	\N	f
30	5	2023-07-07 00:44:58.50276	\N	\N	f
31	2	2022-11-11 16:27:20.978014	\N	\N	f
31	8	2022-12-15 09:11:14.599757	\N	\N	f
32	2	2023-05-17 10:21:47.611703	\N	\N	f
32	6	2023-10-28 03:06:17.737732	\N	\N	f
33	7	2022-05-29 15:44:24.71615	\N	\N	f
34	10	2022-03-18 08:34:51.481869	\N	\N	f
34	7	2023-09-03 08:00:50.422133	\N	\N	f
35	5	2022-05-26 18:55:02.074958	\N	\N	f
35	7	2022-08-10 20:14:33.358236	\N	\N	f
36	8	2022-02-07 03:37:11.405967	\N	\N	f
36	4	2022-11-21 04:33:01.153671	\N	\N	f
37	4	2022-08-03 13:31:06.107108	\N	\N	f
37	5	2022-10-01 04:26:46.444919	\N	\N	f
37	8	2023-04-09 04:43:22.83554	\N	\N	f
38	1	2022-03-31 22:13:58.527732	\N	\N	f
38	6	2022-04-09 13:23:38.336609	\N	\N	f
38	3	2022-04-30 00:29:29.876628	\N	\N	f
39	6	2023-04-24 10:04:21.906183	\N	\N	f
39	10	2023-06-03 06:30:49.332489	\N	\N	f
39	2	2023-09-07 10:22:19.837265	\N	\N	f
40	1	2022-12-14 07:34:25.124951	\N	\N	f
40	3	2023-01-15 05:44:10.191863	\N	\N	f
41	8	2022-09-06 11:33:32.135062	\N	\N	f
41	2	2022-11-27 03:50:32.301504	\N	\N	f
41	1	2023-02-12 23:20:51.217568	\N	\N	f
42	2	2022-01-09 19:54:43.496263	\N	\N	f
43	5	2022-02-20 11:40:57.044662	\N	\N	f
43	7	2022-04-25 23:20:12.737545	\N	\N	f
43	2	2022-11-16 05:49:32.30283	\N	\N	f
44	7	2022-03-16 00:37:50.020999	\N	\N	f
44	9	2022-05-29 07:23:19.041754	\N	\N	f
44	1	2023-08-05 19:44:09.403289	\N	\N	f
45	1	2022-07-15 00:30:30.55214	\N	\N	f
45	8	2022-12-11 13:14:02.185297	\N	\N	f
45	4	2023-10-12 23:10:08.027044	\N	\N	f
46	4	2022-06-16 12:44:07.444855	\N	\N	f
46	9	2022-07-03 00:03:31.87374	\N	\N	f
47	10	2022-03-20 03:17:54.605924	\N	\N	f
47	9	2022-10-19 02:43:11.071799	\N	\N	f
47	3	2023-02-16 08:37:51.442874	\N	\N	f
48	8	2023-01-15 08:55:13.550053	\N	\N	f
48	11	2023-05-15 22:46:53.604821	\N	\N	f
49	3	2022-02-16 10:17:38.9573	\N	\N	f
49	5	2022-10-14 23:09:48.535203	\N	\N	f
49	6	2022-11-21 21:18:12.58637	\N	\N	f
50	11	2022-06-06 01:48:51.216481	\N	\N	f
50	3	2022-07-15 19:15:23.194378	\N	\N	f
51	3	2022-03-21 03:58:53.508768	\N	\N	f
51	10	2022-06-13 00:27:26.7897	\N	\N	f
52	1	2022-01-13 07:24:19.835263	\N	\N	f
53	2	2022-12-11 14:55:29.459078	\N	\N	f
53	4	2023-02-11 05:42:18.393316	\N	\N	f
54	10	2022-09-21 17:22:53.057739	\N	\N	f
54	4	2022-11-16 01:53:32.565896	\N	\N	f
55	3	2022-06-13 09:21:39.00005	\N	\N	f
55	9	2022-11-30 19:10:23.913217	\N	\N	f
55	11	2024-04-18 17:31:45.905079	\N	\N	f
56	2	2022-03-28 09:30:30.647068	\N	\N	f
56	5	2023-04-09 12:55:46.305075	\N	\N	f
56	7	2023-07-12 19:19:00.000583	\N	\N	f
57	8	2023-01-18 08:51:34.722429	\N	\N	f
58	10	2022-02-26 23:30:21.637188	\N	\N	f
58	4	2022-03-24 02:54:35.789139	\N	\N	f
58	2	2022-10-20 09:46:56.945762	\N	\N	f
59	10	2022-04-21 15:25:23.780986	\N	\N	f
59	4	2022-07-16 01:38:11.556602	\N	\N	f
59	8	2022-08-01 01:20:33.033157	\N	\N	f
59	7	2022-10-17 18:07:37.178949	\N	\N	f
60	4	2022-01-31 14:22:25.632694	\N	\N	f
60	7	2022-03-17 22:31:19.91426	\N	\N	f
61	1	2022-06-08 21:57:11.067645	\N	\N	f
61	8	2022-11-06 20:15:41.28533	\N	\N	f
62	10	2022-01-09 20:22:38.477766	\N	\N	f
62	1	2022-02-07 22:32:29.726202	\N	\N	f
63	5	2022-01-11 15:56:38.697859	\N	\N	f
63	3	2023-08-02 14:47:29.595569	\N	\N	f
64	8	2022-03-31 09:48:46.926554	\N	\N	f
64	1	2023-04-23 09:19:17.673225	\N	\N	f
65	2	2022-05-23 06:22:19.534569	\N	\N	f
65	10	2022-11-15 07:47:49.312406	\N	\N	f
66	7	2022-08-06 14:49:52.019559	\N	\N	f
67	9	2022-02-01 20:58:57.182304	\N	\N	f
67	11	2022-03-07 04:59:07.38042	\N	\N	f
67	1	2022-12-05 10:31:47.047365	\N	\N	f
68	1	2022-01-16 20:37:16.077353	\N	\N	f
68	5	2022-01-18 22:31:04.57142	\N	\N	f
68	9	2023-02-24 16:30:42.027899	\N	\N	f
69	7	2022-01-25 14:30:25.206494	\N	\N	f
69	8	2022-05-25 15:23:35.431946	\N	\N	f
69	4	2022-07-01 04:24:51.488667	\N	\N	f
70	11	2022-01-04 05:58:03.035095	\N	\N	f
70	9	2022-06-22 01:03:11.051439	\N	\N	f
71	5	2022-01-27 03:56:59.840642	\N	\N	f
71	8	2022-02-02 22:31:22.294154	\N	\N	f
71	2	2022-07-04 04:19:02.244805	\N	\N	f
72	10	2022-03-09 04:29:54.858955	\N	\N	f
73	6	2022-01-15 10:29:27.179714	\N	\N	f
73	10	2022-03-09 21:17:44.152134	\N	\N	f
74	2	2022-04-02 21:16:37.33431	\N	\N	f
74	7	2022-09-20 17:49:19.875396	\N	\N	f
74	4	2023-05-19 17:18:08.269285	\N	\N	f
75	4	2022-05-30 23:02:25.240168	\N	\N	f
75	10	2022-08-04 11:11:47.53758	\N	\N	f
75	6	2023-06-08 14:13:11.854469	\N	\N	f
76	4	2022-01-27 23:08:10.197617	\N	\N	f
76	6	2022-07-15 04:00:25.806957	\N	\N	f
77	6	2023-01-11 21:32:30.793232	\N	\N	f
77	9	2023-04-09 08:46:20.571445	\N	\N	f
77	3	2023-08-28 03:45:50.186649	\N	\N	f
78	6	2022-08-05 22:18:08.896798	\N	\N	f
78	10	2023-09-22 10:19:42.187382	\N	\N	f
79	7	2022-03-12 21:04:43.472636	\N	\N	f
79	4	2022-11-02 14:53:01.214807	\N	\N	f
79	5	2023-02-12 14:45:30.720454	\N	\N	f
80	7	2022-01-24 03:54:00.974386	\N	\N	f
80	9	2022-03-31 16:29:32.397471	\N	\N	f
80	2	2022-04-19 06:53:19.850883	\N	\N	f
80	3	2022-05-24 18:35:50.138494	\N	\N	f
81	1	2022-02-19 16:21:43.239724	\N	\N	f
81	10	2022-05-16 16:37:56.492753	\N	\N	f
81	5	2023-03-12 04:57:15.241531	\N	\N	f
82	11	2022-10-17 12:14:46.231836	\N	\N	f
82	3	2023-04-12 16:47:31.531364	\N	\N	f
83	5	2022-02-27 23:10:04.140761	\N	\N	f
83	4	2023-08-03 01:55:01.48064	\N	\N	f
84	8	2022-02-08 19:59:31.209594	\N	\N	f
85	10	2022-03-08 02:47:43.52017	\N	\N	f
85	9	2022-04-19 16:12:45.683443	\N	\N	f
85	7	2022-05-22 16:52:10.017334	\N	\N	f
85	11	2022-06-10 11:57:19.362439	\N	\N	f
86	9	2022-02-04 19:52:19.852272	\N	\N	f
86	11	2022-05-09 18:06:13.036348	\N	\N	f
86	5	2022-10-21 14:58:32.405142	\N	\N	f
87	7	2022-03-13 11:02:04.479447	\N	\N	f
87	9	2022-09-13 04:06:22.141377	\N	\N	f
87	4	2022-09-20 04:17:59.888072	\N	\N	f
88	9	2022-04-30 00:54:56.610135	\N	\N	f
88	6	2022-05-31 07:50:14.596746	\N	\N	f
89	6	2022-03-03 09:20:32.720881	\N	\N	f
89	5	2023-05-03 06:40:57.981937	\N	\N	f
90	11	2022-01-21 06:13:58.477476	\N	\N	f
90	9	2022-02-12 04:52:52.452605	\N	\N	f
90	5	2022-06-10 08:32:50.928347	\N	\N	f
91	5	2022-05-01 12:24:20.332795	\N	\N	f
91	9	2023-02-07 22:19:18.657988	\N	\N	f
91	10	2023-03-14 19:59:14.332456	\N	\N	f
91	8	2023-09-09 13:00:57.122121	\N	\N	f
92	3	2022-08-20 18:33:15.924488	\N	\N	f
93	4	2022-02-05 18:34:08.453093	\N	\N	f
93	2	2022-05-07 05:31:47.261954	\N	\N	f
94	11	2022-03-05 11:55:52.633166	\N	\N	f
94	2	2022-04-21 15:02:55.255912	\N	\N	f
94	6	2022-11-12 04:52:09.81227	\N	\N	f
95	8	2022-10-23 00:43:07.118603	\N	\N	f
95	5	2023-01-04 22:44:47.968671	\N	\N	f
96	2	2022-04-24 10:25:03.423876	\N	\N	f
96	5	2023-02-07 06:48:57.215792	\N	\N	f
97	5	2022-02-23 04:36:23.555147	\N	\N	f
97	4	2023-03-18 02:44:48.877339	\N	\N	f
97	9	2023-04-24 02:55:32.618836	\N	\N	f
98	11	2022-04-13 19:47:25.471107	\N	\N	f
98	2	2022-06-02 21:32:12.301718	\N	\N	f
98	7	2022-08-04 03:11:02.60729	\N	\N	f
99	7	2022-01-11 05:24:44.466514	\N	\N	f
99	8	2022-04-17 13:00:06.880539	\N	\N	f
99	5	2022-07-10 23:35:26.756708	\N	\N	f
100	6	2022-03-28 00:15:47.058915	\N	\N	f
100	4	2022-04-16 07:47:59.137338	\N	\N	f
100	3	2022-06-06 04:19:06.236808	\N	\N	f
101	1	2022-03-20 04:36:54.13278	\N	\N	f
101	4	2022-04-19 00:11:56.313878	\N	\N	f
101	3	2022-09-09 14:36:30.635723	\N	\N	f
102	10	2022-02-06 21:49:45.440761	\N	\N	f
103	6	2022-03-10 19:07:23.756671	\N	\N	f
103	8	2022-05-27 04:15:08.377234	\N	\N	f
104	10	2022-02-09 05:01:51.203186	\N	\N	f
104	7	2022-09-24 08:57:04.088944	\N	\N	f
104	2	2022-12-17 20:26:59.839774	\N	\N	f
105	8	2022-03-03 18:20:24.222047	\N	\N	f
106	10	2022-06-18 10:17:22.965	\N	\N	f
106	6	2022-06-23 22:17:08.338128	\N	\N	f
106	5	2023-03-06 14:45:13.00906	\N	\N	f
107	8	2022-05-13 19:39:20.297605	\N	\N	f
107	6	2022-05-23 20:19:13.144671	\N	\N	f
107	11	2022-06-05 20:16:31.82673	\N	\N	f
107	2	2022-06-08 09:09:05.56475	\N	\N	f
108	3	2022-03-02 02:57:34.965761	\N	\N	f
108	8	2022-03-24 23:22:22.011709	\N	\N	f
108	6	2022-08-17 16:06:00.083207	\N	\N	f
109	1	2022-05-04 07:37:17.959943	\N	\N	f
109	2	2022-05-13 14:31:43.033667	\N	\N	f
110	10	2022-06-11 22:20:54.378942	\N	\N	f
110	5	2022-08-15 22:11:53.480481	\N	\N	f
111	4	2022-08-01 04:49:29.701347	\N	\N	f
111	9	2022-09-06 10:28:03.57719	\N	\N	f
112	11	2022-03-26 19:10:11.205685	\N	\N	f
112	6	2023-06-08 06:32:31.800938	\N	\N	f
113	5	2022-05-01 13:52:33.852707	\N	\N	f
113	1	2022-10-16 14:29:02.839516	\N	\N	f
113	2	2023-01-24 15:00:28.624545	\N	\N	f
114	6	2022-08-16 10:16:06.28023	\N	\N	f
114	5	2023-06-14 06:52:42.162906	\N	\N	f
115	11	2023-01-27 06:17:11.446305	\N	\N	f
115	10	2023-04-22 17:42:50.805816	\N	\N	f
115	1	2023-06-01 08:51:20.61511	\N	\N	f
116	3	2022-05-28 21:29:43.479939	\N	\N	f
116	2	2022-07-09 01:34:18.186201	\N	\N	f
116	6	2023-08-25 04:23:40.905452	\N	\N	f
117	7	2022-04-01 11:26:21.929442	\N	\N	f
117	8	2024-03-16 17:21:13.7101	\N	\N	f
118	9	2022-01-05 08:08:44.137473	\N	\N	f
118	11	2022-09-25 07:19:29.619408	\N	\N	f
118	5	2022-10-16 18:28:30.33694	\N	\N	f
119	9	2022-02-03 14:10:18.987483	\N	\N	f
119	7	2023-01-10 18:47:25.520112	\N	\N	f
120	10	2022-08-19 10:06:52.80769	\N	\N	f
120	3	2022-10-31 03:12:45.409798	\N	\N	f
120	11	2023-01-14 00:41:01.889116	\N	\N	f
120	6	2023-01-30 22:08:52.937439	\N	\N	f
121	7	2023-05-23 02:34:19.791297	\N	\N	f
121	1	2023-06-04 10:41:12.542797	\N	\N	f
121	4	2023-08-10 07:56:03.295291	\N	\N	f
121	8	2024-04-19 14:03:10.560018	\N	\N	f
122	1	2022-03-07 04:39:14.842083	\N	\N	f
122	10	2022-06-21 18:17:32.070896	\N	\N	f
123	7	2022-09-06 06:10:46.10045	\N	\N	f
123	9	2022-10-29 21:30:30.894941	\N	\N	f
123	4	2023-05-22 14:22:57.081939	\N	\N	f
124	5	2022-03-26 12:52:43.139478	\N	\N	f
124	2	2022-07-14 19:21:01.367399	\N	\N	f
124	1	2022-08-29 17:58:32.754387	\N	\N	f
124	9	2023-07-25 09:11:58.991489	\N	\N	f
125	5	2022-03-13 06:45:23.267031	\N	\N	f
125	7	2022-05-17 01:56:00.894947	\N	\N	f
126	7	2022-02-17 13:41:36.508395	\N	\N	f
126	2	2022-03-30 03:05:18.512619	\N	\N	f
126	8	2022-11-26 23:48:53.267883	\N	\N	f
127	7	2022-06-21 09:24:03.225344	\N	\N	f
127	4	2023-09-02 17:45:52.853295	\N	\N	f
127	1	2023-09-08 15:56:26.206325	\N	\N	f
128	10	2022-02-11 14:22:33.878096	\N	\N	f
128	11	2022-11-22 00:01:23.811138	\N	\N	f
129	9	2022-01-26 15:49:55.372787	\N	\N	f
129	8	2022-05-24 11:27:20.084601	\N	\N	f
129	5	2023-02-09 19:59:33.926459	\N	\N	f
130	1	2022-01-28 21:44:59.765542	\N	\N	f
130	8	2022-02-19 21:34:51.238308	\N	\N	f
131	9	2022-02-28 05:20:03.954007	\N	\N	f
131	1	2022-04-29 19:31:51.532355	\N	\N	f
131	3	2022-10-14 23:09:25.889368	\N	\N	f
132	1	2022-03-28 08:18:50.866285	\N	\N	f
132	8	2022-05-31 12:24:54.075402	\N	\N	f
133	11	2022-05-29 00:10:53.132266	\N	\N	f
133	2	2022-09-14 16:06:37.151668	\N	\N	f
133	4	2022-11-02 21:52:44.066451	\N	\N	f
134	11	2022-04-08 01:37:57.340826	\N	\N	f
134	2	2023-06-06 00:12:26.109944	\N	\N	f
134	5	2023-07-17 20:25:08.906174	\N	\N	f
135	11	2022-06-16 10:25:59.093465	\N	\N	f
135	6	2024-03-12 10:33:00.416134	\N	\N	f
136	8	2022-03-28 14:19:10.755795	\N	\N	f
136	7	2022-05-23 02:12:30.706872	\N	\N	f
136	11	2023-08-05 06:12:05.797821	\N	\N	f
137	10	2022-02-01 13:34:11.990148	\N	\N	f
137	7	2022-11-18 05:01:58.838394	\N	\N	f
138	10	2022-01-18 08:58:42.059742	\N	\N	f
138	3	2022-05-08 06:04:58.464455	\N	\N	f
138	2	2023-02-08 07:13:59.646759	\N	\N	f
139	10	2022-02-12 04:26:20.798856	\N	\N	f
140	10	2022-07-26 11:38:51.903193	\N	\N	f
140	9	2022-12-15 08:40:38.832023	\N	\N	f
140	4	2023-06-12 15:47:41.458839	\N	\N	f
141	4	2022-04-18 23:25:09.90255	\N	\N	f
141	9	2022-06-18 04:13:45.847166	\N	\N	f
142	2	2022-05-21 06:37:06.088994	\N	\N	f
142	8	2022-10-17 08:07:14.430794	\N	\N	f
143	5	2022-04-03 19:54:46.991703	\N	\N	f
143	3	2022-06-21 17:56:33.315122	\N	\N	f
144	1	2022-05-04 19:42:37.616916	\N	\N	f
144	7	2022-05-27 01:55:12.710688	\N	\N	f
145	11	2022-03-22 04:40:20.304325	\N	\N	f
145	4	2022-04-13 23:48:23.74056	\N	\N	f
145	7	2022-05-05 08:15:28.029862	\N	\N	f
146	3	2022-06-03 20:31:37.181878	\N	\N	f
147	6	2022-04-06 23:48:46.899534	\N	\N	f
147	4	2023-06-18 06:45:02.806919	\N	\N	f
147	5	2023-07-16 08:11:36.011423	\N	\N	f
148	2	2022-01-28 01:24:24.604432	\N	\N	f
148	10	2022-06-11 09:35:39.964456	\N	\N	f
148	7	2022-06-17 18:34:25.666317	\N	\N	f
148	5	2022-07-20 22:34:42.415609	\N	\N	f
149	4	2022-01-17 10:35:21.525453	\N	\N	f
149	8	2022-03-05 23:47:37.132763	\N	\N	f
149	10	2023-05-05 21:53:17.15141	\N	\N	f
149	3	2023-06-07 16:43:42.667876	\N	\N	f
150	10	2022-01-18 09:06:43.511132	\N	\N	f
151	7	2022-05-29 09:24:37.534521	\N	\N	f
151	6	2023-05-29 06:05:53.918737	\N	\N	f
151	8	2023-06-10 01:30:32.083086	\N	\N	f
152	6	2022-04-03 23:43:05.27998	\N	\N	f
152	8	2022-09-13 12:05:14.804712	\N	\N	f
153	3	2023-01-08 16:45:31.993862	\N	\N	f
153	4	2023-08-11 18:50:12.671196	\N	\N	f
154	6	2022-12-24 18:01:11.074597	\N	\N	f
154	1	2022-12-27 16:13:11.99299	\N	\N	f
154	10	2023-02-06 09:39:06.596095	\N	\N	f
155	2	2022-03-04 06:02:51.781313	\N	\N	f
155	1	2022-04-22 20:36:20.175926	\N	\N	f
155	10	2022-05-11 21:10:13.553276	\N	\N	f
155	7	2022-05-20 11:31:30.555372	\N	\N	f
156	10	2022-02-06 00:40:20.095594	\N	\N	f
156	4	2022-03-13 03:00:09.023598	\N	\N	f
157	10	2022-03-12 13:31:26.840488	\N	\N	f
157	8	2022-06-11 07:11:47.87298	\N	\N	f
157	4	2022-09-18 09:39:30.10287	\N	\N	f
158	3	2022-02-11 21:54:42.66128	\N	\N	f
158	6	2022-05-25 15:14:06.26989	\N	\N	f
158	2	2022-12-17 17:09:22.149112	\N	\N	f
158	4	2023-02-26 12:08:29.471928	\N	\N	f
159	9	2022-02-24 10:36:33.848647	\N	\N	f
159	7	2022-10-15 02:14:45.849942	\N	\N	f
159	11	2022-11-09 08:54:43.395833	\N	\N	f
159	10	2023-03-01 01:08:42.256974	\N	\N	f
160	2	2022-04-04 19:44:22.993287	\N	\N	f
160	5	2022-10-31 04:35:37.132259	\N	\N	f
160	10	2022-10-31 13:45:13.936633	\N	\N	f
161	2	2022-07-31 05:47:50.595468	\N	\N	f
161	1	2022-08-22 13:01:04.498565	\N	\N	f
162	10	2022-01-10 06:08:31.014938	\N	\N	f
163	4	2022-03-25 10:35:42.722106	\N	\N	f
163	11	2022-05-17 11:34:52.297141	\N	\N	f
163	8	2022-10-04 15:49:23.683957	\N	\N	f
164	2	2022-02-25 20:13:29.321601	\N	\N	f
164	10	2022-03-11 16:36:20.930583	\N	\N	f
164	8	2023-02-25 06:00:25.121441	\N	\N	f
164	4	2023-06-27 12:53:16.040263	\N	\N	f
165	4	2022-01-31 02:04:41.434655	\N	\N	f
165	5	2022-02-03 14:56:38.61426	\N	\N	f
166	8	2022-04-06 00:17:20.902255	\N	\N	f
166	9	2022-10-11 07:06:08.528142	\N	\N	f
166	11	2022-12-23 16:26:20.599257	\N	\N	f
167	4	2022-01-31 08:29:20.367826	\N	\N	f
167	8	2022-04-29 06:57:04.363438	\N	\N	f
167	6	2022-10-20 13:01:09.356741	\N	\N	f
168	3	2022-02-21 07:15:16.40382	\N	\N	f
168	1	2022-02-26 10:05:18.770097	\N	\N	f
169	10	2022-03-11 10:35:06.651898	\N	\N	f
169	11	2022-05-17 02:04:33.687778	\N	\N	f
170	6	2022-06-27 10:03:23.351853	\N	\N	f
170	1	2023-01-16 08:08:27.624041	\N	\N	f
171	4	2022-03-08 11:30:27.810068	\N	\N	f
171	1	2022-03-13 06:54:54.626425	\N	\N	f
172	9	2022-10-07 23:57:20.180063	\N	\N	f
172	4	2023-03-07 13:34:10.412079	\N	\N	f
172	7	2023-11-12 06:45:35.963387	\N	\N	f
173	10	2022-02-17 13:58:43.284646	\N	\N	f
173	9	2022-03-17 01:53:27.289704	\N	\N	f
173	6	2022-04-13 20:54:46.666199	\N	\N	f
174	2	2022-01-20 11:10:00.435201	\N	\N	f
174	5	2022-08-08 20:18:21.75964	\N	\N	f
174	1	2022-10-02 11:52:55.102608	\N	\N	f
175	11	2022-01-07 16:01:39.897074	\N	\N	f
175	1	2022-03-04 11:14:27.725931	\N	\N	f
175	10	2023-01-09 10:00:02.95148	\N	\N	f
176	3	2022-05-10 18:31:51.649575	\N	\N	f
176	9	2022-09-17 02:39:26.689772	\N	\N	f
176	5	2022-09-25 13:51:07.540044	\N	\N	f
177	2	2022-08-04 23:43:13.427053	\N	\N	f
177	1	2022-08-30 14:16:55.322966	\N	\N	f
178	8	2022-02-09 23:01:33.547694	\N	\N	f
178	2	2024-04-07 02:58:41.841194	\N	\N	f
179	7	2022-09-14 12:36:32.606412	\N	\N	f
179	3	2023-01-29 04:47:29.061222	\N	\N	f
180	8	2022-01-19 18:09:00.087682	\N	\N	f
180	10	2022-02-15 23:04:40.146417	\N	\N	f
180	5	2022-05-23 00:10:46.788844	\N	\N	f
181	8	2022-02-07 11:44:53.189127	\N	\N	f
181	11	2022-08-15 09:55:31.170581	\N	\N	f
182	2	2022-01-07 04:36:24.893694	\N	\N	f
182	6	2022-07-06 10:59:18.706252	\N	\N	f
183	3	2022-02-26 04:20:15.797038	\N	\N	f
183	1	2022-04-27 03:14:20.46273	\N	\N	f
184	10	2022-01-02 01:09:37.050151	\N	\N	f
184	11	2022-03-03 22:41:36.212951	\N	\N	f
184	7	2022-06-18 23:55:23.025808	\N	\N	f
185	3	2022-03-01 19:34:19.216799	\N	\N	f
185	2	2023-03-27 17:45:03.069007	\N	\N	f
186	6	2022-01-29 18:43:48.786314	\N	\N	f
186	2	2022-04-19 21:57:55.671561	\N	\N	f
186	5	2023-02-14 06:31:43.162352	\N	\N	f
186	7	2024-01-26 19:16:49.481214	\N	\N	f
187	7	2022-05-22 09:42:47.154024	\N	\N	f
188	8	2022-07-16 05:52:04.896688	\N	\N	f
188	9	2022-07-16 22:56:21.676627	\N	\N	f
189	10	2022-01-11 06:32:09.081124	\N	\N	f
189	11	2022-04-24 14:07:57.222901	\N	\N	f
189	6	2023-05-29 11:42:01.277158	\N	\N	f
190	9	2022-04-08 15:17:55.618896	\N	\N	f
190	8	2022-09-11 16:28:48.80424	\N	\N	f
190	11	2022-10-22 02:50:05.040942	\N	\N	f
191	9	2022-02-27 10:54:29.669127	\N	\N	f
191	7	2022-04-09 16:27:19.017005	\N	\N	f
192	5	2022-02-13 23:01:03.033533	\N	\N	f
192	2	2023-01-14 18:35:31.694257	\N	\N	f
192	9	2023-05-08 15:14:54.715447	\N	\N	f
193	1	2022-04-08 16:25:30.917243	\N	\N	f
193	4	2022-06-12 13:39:09.240129	\N	\N	f
194	6	2022-01-20 02:39:25.502321	\N	\N	f
194	5	2022-07-16 09:15:44.818219	\N	\N	f
194	11	2022-11-30 09:05:59.972066	\N	\N	f
194	3	2023-03-22 04:40:26.323253	\N	\N	f
195	9	2022-04-26 18:12:29.628053	\N	\N	f
195	6	2022-10-04 12:29:21.495026	\N	\N	f
195	5	2023-07-01 04:54:53.982934	\N	\N	f
195	4	2024-01-13 15:50:51.35509	\N	\N	f
196	10	2022-04-15 15:58:53.995765	\N	\N	f
196	8	2022-09-28 07:51:42.733123	\N	\N	f
197	10	2022-06-22 19:22:01.909859	\N	\N	f
197	3	2023-02-24 16:38:43.860371	\N	\N	f
198	9	2022-02-01 04:55:54.769108	\N	\N	f
198	7	2022-03-04 06:22:18.931402	\N	\N	f
198	1	2022-03-19 14:02:21.796421	\N	\N	f
199	1	2022-11-02 05:06:53.482671	\N	\N	f
199	9	2023-01-04 10:07:43.027543	\N	\N	f
199	11	2023-04-02 07:57:21.843553	\N	\N	f
200	6	2022-09-19 13:49:14.363924	\N	\N	f
200	11	2023-05-23 22:15:07.05424	\N	\N	f
200	4	2023-06-11 19:32:04.068983	\N	\N	f
200	2	2023-09-04 04:05:50.309309	\N	\N	f
201	1	2022-01-22 08:39:05.136474	\N	\N	f
201	5	2022-03-21 09:36:15.79443	\N	\N	f
202	8	2022-04-14 02:00:26.090157	\N	\N	f
203	8	2022-05-26 01:09:40.533834	\N	\N	f
203	5	2022-10-05 06:02:42.429551	\N	\N	f
204	7	2022-01-19 19:08:50.599288	\N	\N	f
204	5	2022-04-05 16:08:49.983487	\N	\N	f
204	1	2022-07-15 09:53:01.673355	\N	\N	f
205	7	2022-03-08 07:51:04.891853	\N	\N	f
205	8	2022-10-26 06:06:11.291401	\N	\N	f
205	11	2023-03-13 03:25:52.170661	\N	\N	f
206	2	2022-04-23 04:01:37.842717	\N	\N	f
206	10	2022-09-02 17:04:13.049819	\N	\N	f
206	11	2022-11-01 10:02:48.063052	\N	\N	f
207	7	2022-01-16 19:49:30.365882	\N	\N	f
207	10	2022-03-08 22:47:31.056243	\N	\N	f
208	6	2022-07-24 05:10:56.335027	\N	\N	f
208	9	2022-08-09 10:36:24.84899	\N	\N	f
209	8	2022-02-10 05:31:46.171739	\N	\N	f
209	10	2022-12-01 15:50:10.706193	\N	\N	f
209	1	2023-07-23 23:44:41.537134	\N	\N	f
210	2	2022-03-04 22:56:10.302499	\N	\N	f
210	8	2022-04-03 20:59:12.223992	\N	\N	f
211	1	2022-01-30 13:19:26.304814	\N	\N	f
212	3	2022-01-18 04:23:04.204387	\N	\N	f
212	8	2022-03-13 02:59:16.302693	\N	\N	f
212	6	2022-04-24 17:57:28.36391	\N	\N	f
213	8	2022-05-09 06:25:11.002916	\N	\N	f
213	10	2022-05-12 09:48:13.305827	\N	\N	f
214	7	2022-07-11 03:03:08.809399	\N	\N	f
214	2	2022-11-02 20:38:50.85818	\N	\N	f
214	4	2023-12-29 09:27:31.866278	\N	\N	f
215	6	2022-11-10 16:28:58.50476	\N	\N	f
215	4	2023-05-01 23:35:35.752969	\N	\N	f
215	2	2023-10-03 08:05:45.811683	\N	\N	f
216	2	2023-04-29 19:01:40.651222	\N	\N	f
216	9	2023-05-07 07:13:49.305038	\N	\N	f
217	3	2022-02-02 17:20:38.615999	\N	\N	f
217	8	2022-03-22 19:40:42.854942	\N	\N	f
217	9	2022-08-22 09:27:58.278899	\N	\N	f
218	1	2022-04-13 07:57:39.102016	\N	\N	f
219	6	2022-01-11 14:36:22.12158	\N	\N	f
219	3	2022-04-18 11:38:08.098406	\N	\N	f
219	8	2022-06-20 12:36:56.273741	\N	\N	f
220	9	2022-03-06 11:43:11.544154	\N	\N	f
220	8	2022-04-07 12:22:33.619639	\N	\N	f
220	1	2022-06-08 18:49:42.445795	\N	\N	f
221	6	2022-01-29 07:49:56.317806	\N	\N	f
221	2	2022-06-01 05:49:08.147208	\N	\N	f
221	11	2022-08-20 18:40:13.635405	\N	\N	f
222	10	2022-05-01 10:56:15.782859	\N	\N	f
222	1	2023-06-21 15:36:00.746896	\N	\N	f
223	8	2022-02-19 21:00:59.918658	\N	\N	f
224	2	2022-05-06 13:03:36.381595	\N	\N	f
224	1	2023-04-22 17:10:48.709546	\N	\N	f
224	10	2023-08-21 19:28:21.358736	\N	\N	f
225	9	2022-02-26 09:26:10.79843	\N	\N	f
225	7	2022-05-05 19:54:44.850265	\N	\N	f
225	6	2022-05-09 07:22:12.398006	\N	\N	f
226	9	2022-07-10 14:15:14.927664	\N	\N	f
226	4	2022-08-31 07:09:04.640534	\N	\N	f
227	4	2022-12-11 21:24:01.137251	\N	\N	f
227	10	2023-01-09 04:52:29.171679	\N	\N	f
228	3	2022-05-12 09:19:53.31036	\N	\N	f
228	11	2022-07-26 13:17:55.75308	\N	\N	f
228	7	2022-08-05 14:15:29.945509	\N	\N	f
228	10	2022-10-17 09:10:03.146626	\N	\N	f
229	7	2022-03-13 03:04:39.791118	\N	\N	f
229	4	2022-09-11 22:10:58.175647	\N	\N	f
230	2	2022-04-24 09:13:41.332876	\N	\N	f
230	4	2022-04-25 09:07:50.242922	\N	\N	f
230	6	2023-01-01 01:13:15.061497	\N	\N	f
230	1	2023-04-05 12:35:12.905328	\N	\N	f
231	2	2022-05-26 22:29:17.111358	\N	\N	f
231	5	2022-12-19 00:05:43.709925	\N	\N	f
232	5	2022-01-26 05:27:51.692997	\N	\N	f
232	1	2023-03-13 15:23:01.287965	\N	\N	f
233	2	2022-01-27 02:43:07.082372	\N	\N	f
233	1	2022-03-07 22:11:20.640723	\N	\N	f
233	11	2023-05-29 14:59:58.837401	\N	\N	f
234	6	2022-03-21 08:39:20.005008	\N	\N	f
234	5	2022-09-13 15:51:24.710507	\N	\N	f
234	2	2023-08-21 21:00:55.405133	\N	\N	f
234	3	2023-12-07 00:46:11.352081	\N	\N	f
235	8	2022-04-07 12:19:26.487518	\N	\N	f
235	7	2022-07-15 21:02:03.213831	\N	\N	f
236	9	2022-04-20 21:15:45.181495	\N	\N	f
236	3	2022-12-26 19:06:47.507192	\N	\N	f
237	9	2022-10-17 19:13:16.480758	\N	\N	f
237	8	2023-05-13 07:51:09.483359	\N	\N	f
237	11	2023-07-30 22:55:12.09821	\N	\N	f
237	6	2023-10-07 21:29:55.098061	\N	\N	f
238	1	2022-02-21 21:07:14.445853	\N	\N	f
238	3	2022-08-08 22:17:56.944597	\N	\N	f
238	11	2022-11-19 04:24:04.688356	\N	\N	f
239	6	2022-03-08 02:47:57.483611	\N	\N	f
239	1	2022-06-15 17:52:38.481557	\N	\N	f
240	6	2022-01-08 07:07:42.36565	\N	\N	f
240	2	2022-03-04 11:59:42.304396	\N	\N	f
241	4	2022-03-23 06:04:04.57862	\N	\N	f
241	10	2022-05-27 06:12:06.940119	\N	\N	f
242	2	2022-12-20 12:31:09.835568	\N	\N	f
242	3	2023-02-08 00:30:11.485705	\N	\N	f
242	7	2024-01-24 15:58:17.252411	\N	\N	f
243	2	2022-03-14 20:19:36.885515	\N	\N	f
243	1	2023-05-05 00:03:43.587515	\N	\N	f
243	3	2023-08-18 18:50:38.4431	\N	\N	f
244	6	2022-01-13 17:27:28.151046	\N	\N	f
244	8	2022-12-22 08:24:36.198863	\N	\N	f
245	1	2022-04-20 11:47:15.710593	\N	\N	f
245	11	2022-07-12 05:05:43.172767	\N	\N	f
246	3	2022-01-26 14:23:06.334359	\N	\N	f
246	6	2022-01-28 00:57:10.574413	\N	\N	f
247	3	2022-09-24 10:11:42.066931	\N	\N	f
247	6	2023-03-22 22:49:51.333418	\N	\N	f
247	1	2023-05-21 15:55:59.124956	\N	\N	f
248	4	2022-10-10 21:57:18.078516	\N	\N	f
248	11	2022-10-22 12:02:39.727015	\N	\N	f
249	7	2022-01-06 18:32:37.325787	\N	\N	f
249	10	2022-07-03 15:43:30.749396	\N	\N	f
249	8	2022-12-11 12:41:20.398117	\N	\N	f
250	1	2022-01-28 15:31:43.425171	\N	\N	f
250	4	2022-11-08 16:34:17.721384	\N	\N	f
250	9	2023-11-15 20:34:07.331765	\N	\N	f
251	10	2022-01-20 08:04:05.757131	\N	\N	f
251	5	2022-02-03 12:02:11.452394	\N	\N	f
252	11	2022-07-30 07:38:38.115036	\N	\N	f
252	6	2023-08-01 17:25:03.833229	\N	\N	f
253	3	2022-01-18 17:47:54.405461	\N	\N	f
253	2	2022-02-19 17:52:04.401394	\N	\N	f
254	8	2022-04-10 17:56:07.077928	\N	\N	f
254	3	2022-09-18 23:48:59.519272	\N	\N	f
254	5	2023-09-30 07:04:29.360388	\N	\N	f
255	5	2022-05-25 22:36:50.249396	\N	\N	f
255	6	2022-06-07 11:01:20.074573	\N	\N	f
255	11	2023-05-30 11:54:56.063907	\N	\N	f
256	5	2022-10-11 23:53:48.576187	\N	\N	f
257	7	2022-12-08 20:54:26.849911	\N	\N	f
258	1	2022-04-11 01:59:22.112476	\N	\N	f
258	8	2022-06-09 13:54:00.580497	\N	\N	f
258	7	2022-07-25 08:25:30.358365	\N	\N	f
258	11	2022-08-09 21:08:39.205948	\N	\N	f
259	9	2022-04-24 15:38:23.333515	\N	\N	f
259	1	2022-06-01 16:54:15.812156	\N	\N	f
260	9	2022-06-25 16:09:49.995354	\N	\N	f
260	3	2022-08-17 09:28:51.9717	\N	\N	f
261	3	2022-01-28 02:16:43.165386	\N	\N	f
261	7	2022-03-21 13:38:36.793146	\N	\N	f
262	11	2022-02-18 01:36:17.212562	\N	\N	f
262	2	2022-07-18 13:34:58.559508	\N	\N	f
262	7	2023-03-18 20:50:14.478513	\N	\N	f
263	4	2022-04-01 02:18:03.143769	\N	\N	f
263	3	2022-12-09 01:34:52.919308	\N	\N	f
264	5	2022-03-10 15:06:21.368182	\N	\N	f
264	6	2022-04-12 00:07:15.464532	\N	\N	f
265	1	2022-01-04 01:32:22.081959	\N	\N	f
265	10	2022-02-09 04:16:21.378667	\N	\N	f
265	5	2022-11-08 18:23:25.051291	\N	\N	f
266	11	2022-02-25 02:52:43.8688	\N	\N	f
266	8	2022-04-20 05:55:38.893669	\N	\N	f
267	10	2022-09-27 01:11:51.756992	\N	\N	f
267	9	2023-02-20 22:39:29.395822	\N	\N	f
268	11	2022-01-13 02:10:57.185907	\N	\N	f
268	10	2022-10-19 12:05:49.010692	\N	\N	f
269	1	2022-02-18 22:16:04.308596	\N	\N	f
269	7	2022-07-22 07:57:39.540869	\N	\N	f
269	8	2022-11-19 23:26:00.681146	\N	\N	f
270	6	2022-04-02 08:02:51.653554	\N	\N	f
270	11	2022-05-09 19:10:27.965877	\N	\N	f
270	7	2022-09-19 08:15:02.085583	\N	\N	f
271	3	2022-02-17 19:14:38.733891	\N	\N	f
271	4	2022-09-24 21:15:35.363404	\N	\N	f
272	8	2022-02-03 09:59:32.751664	\N	\N	f
272	2	2022-10-07 21:00:02.742958	\N	\N	f
273	2	2022-06-15 05:59:35.278909	\N	\N	f
273	11	2022-10-19 11:54:45.300337	\N	\N	f
274	10	2022-08-06 08:43:07.623588	\N	\N	f
274	6	2023-02-19 03:13:03.099464	\N	\N	f
274	9	2023-03-10 20:52:20.709999	\N	\N	f
275	3	2022-05-10 11:12:32.022456	\N	\N	f
275	8	2022-08-22 20:43:34.337479	\N	\N	f
275	2	2022-09-14 03:21:12.921423	\N	\N	f
276	7	2022-11-15 04:52:24.288101	\N	\N	f
276	10	2023-01-21 21:18:48.788818	\N	\N	f
276	11	2023-11-01 14:11:00.538225	\N	\N	f
277	4	2022-06-05 01:18:50.676766	\N	\N	f
277	6	2022-10-13 04:48:51.169692	\N	\N	f
278	8	2022-01-04 13:09:48.541872	\N	\N	f
278	7	2022-06-29 08:40:22.323123	\N	\N	f
278	5	2022-07-27 13:38:50.6168	\N	\N	f
279	2	2022-02-28 14:20:59.046929	\N	\N	f
279	7	2022-04-06 00:39:03.64905	\N	\N	f
279	1	2024-03-07 01:55:55.110566	\N	\N	f
280	5	2022-02-27 14:55:51.549283	\N	\N	f
280	11	2022-03-16 01:35:54.265337	\N	\N	f
281	3	2022-01-27 17:29:24.16385	\N	\N	f
281	6	2022-06-05 21:00:31.315651	\N	\N	f
282	3	2022-05-28 07:13:35.665356	\N	\N	f
282	11	2022-10-09 07:19:47.111272	\N	\N	f
283	9	2022-04-04 18:03:30.830134	\N	\N	f
283	7	2023-01-15 09:38:50.034622	\N	\N	f
283	8	2023-08-02 19:25:52.37844	\N	\N	f
284	5	2022-09-05 12:54:23.95452	\N	\N	f
284	6	2023-05-13 18:37:11.1058	\N	\N	f
285	2	2022-03-11 10:30:35.668246	\N	\N	f
285	10	2022-05-17 23:16:50.707638	\N	\N	f
285	6	2023-02-28 02:11:35.166484	\N	\N	f
286	5	2022-02-20 04:49:26.173589	\N	\N	f
286	8	2022-05-17 10:10:12.345318	\N	\N	f
286	10	2023-12-19 16:12:56.951563	\N	\N	f
287	9	2022-03-23 18:31:12.262563	\N	\N	f
287	5	2022-05-04 03:39:41.297819	\N	\N	f
287	7	2022-08-13 09:02:21.140877	\N	\N	f
288	2	2022-10-15 10:11:44.998066	\N	\N	f
288	5	2023-01-17 16:49:44.946365	\N	\N	f
288	9	2023-01-21 03:27:52.708118	\N	\N	f
288	7	2023-02-28 03:04:21.861335	\N	\N	f
289	4	2022-10-17 05:37:39.544802	\N	\N	f
289	8	2023-06-06 14:32:33.938891	\N	\N	f
290	6	2022-10-10 07:20:30.18605	\N	\N	f
290	8	2022-10-13 04:54:27.410683	\N	\N	f
291	7	2022-01-21 07:49:26.995208	\N	\N	f
291	5	2022-12-25 11:12:59.029138	\N	\N	f
292	2	2022-03-29 19:04:36.205892	\N	\N	f
292	6	2022-06-09 19:57:44.168778	\N	\N	f
292	11	2022-09-27 10:46:01.011447	\N	\N	f
293	8	2022-03-12 08:47:35.000141	\N	\N	f
294	2	2022-09-16 12:02:19.921704	\N	\N	f
294	9	2023-04-05 16:04:24.511817	\N	\N	f
295	6	2022-05-01 16:15:51.225148	\N	\N	f
295	11	2022-06-12 12:34:15.884332	\N	\N	f
296	1	2022-02-04 13:44:15.902421	\N	\N	f
296	4	2022-03-20 03:18:09.239194	\N	\N	f
297	7	2022-02-08 05:12:37.51108	\N	\N	f
298	10	2022-05-12 18:34:49.727745	\N	\N	f
299	7	2022-01-04 03:47:41.21425	\N	\N	f
299	9	2022-01-14 15:38:15.844013	\N	\N	f
300	2	2022-07-07 22:04:43.43421	\N	\N	f
300	3	2022-09-07 09:32:19.487613	\N	\N	f
301	5	2022-10-20 23:50:30.408532	\N	\N	f
301	3	2023-01-14 13:28:07.735733	\N	\N	f
302	9	2022-02-13 13:41:42.860335	\N	\N	f
302	1	2022-03-30 10:20:24.017906	\N	\N	f
303	3	2022-04-05 14:02:04.969864	\N	\N	f
303	4	2022-06-13 17:40:43.127556	\N	\N	f
303	10	2023-02-06 18:20:14.463895	\N	\N	f
304	11	2022-08-14 09:50:10.257904	\N	\N	f
304	2	2023-02-06 06:18:47.958801	\N	\N	f
304	7	2023-05-25 18:08:52.136372	\N	\N	f
305	10	2023-01-29 15:11:53.912683	\N	\N	f
305	6	2023-02-23 00:18:01.494971	\N	\N	f
305	9	2023-03-17 07:25:36.861101	\N	\N	f
306	1	2022-03-10 04:56:33.150373	\N	\N	f
306	3	2022-08-23 07:44:39.272828	\N	\N	f
307	9	2022-01-20 18:37:20.182035	\N	\N	f
308	2	2022-03-31 16:33:21.734335	\N	\N	f
308	7	2022-07-15 05:00:56.798409	\N	\N	f
309	9	2022-10-19 03:41:43.17625	\N	\N	f
310	8	2022-03-23 16:21:09.501679	\N	\N	f
310	1	2022-06-26 09:50:51.931516	\N	\N	f
310	2	2022-07-22 04:50:22.921374	\N	\N	f
311	6	2022-03-18 02:09:40.851247	\N	\N	f
311	4	2022-04-27 03:51:53.836529	\N	\N	f
311	5	2022-05-12 14:12:14.909212	\N	\N	f
312	7	2022-01-28 15:27:55.642308	\N	\N	f
313	4	2022-10-07 06:25:13.691138	\N	\N	f
313	10	2022-12-24 08:31:24.204566	\N	\N	f
314	8	2022-02-18 06:23:21.318835	\N	\N	f
314	4	2022-03-29 11:11:54.468751	\N	\N	f
314	7	2022-07-19 10:39:51.082868	\N	\N	f
315	3	2022-05-09 12:50:30.387	\N	\N	f
315	2	2022-11-23 23:59:38.964762	\N	\N	f
315	7	2023-07-10 03:31:31.536692	\N	\N	f
316	7	2023-04-15 07:13:37.639576	\N	\N	f
316	6	2023-06-26 23:58:09.337086	\N	\N	f
316	8	2023-06-29 04:08:30.361381	\N	\N	f
317	4	2022-03-19 00:05:17.215492	\N	\N	f
317	8	2022-09-13 16:11:36.864647	\N	\N	f
317	10	2022-09-24 00:29:37.381081	\N	\N	f
317	1	2022-12-30 15:59:53.423906	\N	\N	f
318	6	2022-01-28 22:20:04.071294	\N	\N	f
318	7	2022-03-16 23:19:42.824905	\N	\N	f
318	11	2022-04-01 07:38:58.208053	\N	\N	f
319	11	2022-04-10 16:25:21.772727	\N	\N	f
319	9	2022-04-23 00:19:20.773029	\N	\N	f
320	5	2022-02-01 06:07:42.785363	\N	\N	f
320	1	2022-10-18 13:41:07.872588	\N	\N	f
320	7	2023-01-03 03:46:38.725735	\N	\N	f
320	8	2023-12-02 12:05:05.737196	\N	\N	f
321	4	2022-08-21 05:39:43.248434	\N	\N	f
321	11	2022-10-12 07:53:13.488595	\N	\N	f
321	8	2023-01-12 06:56:51.621013	\N	\N	f
322	10	2022-04-03 18:32:41.482753	\N	\N	f
322	9	2022-07-06 07:08:54.478854	\N	\N	f
323	10	2022-05-16 09:58:51.820427	\N	\N	f
323	8	2022-05-31 14:46:18.908859	\N	\N	f
324	10	2022-10-26 10:15:51.591024	\N	\N	f
324	9	2022-11-03 14:14:48.176268	\N	\N	f
324	5	2023-05-17 09:24:37.040359	\N	\N	f
325	6	2022-01-25 00:53:36.199102	\N	\N	f
326	7	2022-05-28 09:49:47.779441	\N	\N	f
326	5	2022-12-17 05:26:00.590119	\N	\N	f
326	6	2024-04-04 02:27:47.488109	\N	\N	f
327	2	2022-10-21 12:28:22.415299	\N	\N	f
327	3	2022-11-06 17:12:05.135697	\N	\N	f
327	4	2022-12-14 17:24:03.296068	\N	\N	f
328	5	2022-02-04 02:18:47.941712	\N	\N	f
328	11	2023-01-25 20:53:56.724613	\N	\N	f
329	8	2022-01-18 09:58:25.572301	\N	\N	f
329	3	2022-05-07 12:41:12.869758	\N	\N	f
329	4	2022-09-21 07:31:07.057198	\N	\N	f
330	9	2022-04-29 13:30:19.677326	\N	\N	f
331	1	2022-01-12 10:43:00.078926	\N	\N	f
331	7	2022-04-02 05:11:32.27033	\N	\N	f
331	9	2023-04-21 09:19:00.936813	\N	\N	f
332	8	2022-01-30 00:19:24.971459	\N	\N	f
333	4	2022-02-06 20:50:53.162154	\N	\N	f
333	3	2022-03-12 23:30:30.82957	\N	\N	f
333	10	2022-08-02 20:35:37.020177	\N	\N	f
334	3	2022-05-21 11:45:51.199972	\N	\N	f
334	8	2022-06-24 04:35:32.732327	\N	\N	f
334	2	2022-06-27 18:56:28.370806	\N	\N	f
335	2	2022-05-14 12:08:12.737471	\N	\N	f
335	6	2022-05-29 07:55:25.729245	\N	\N	f
336	2	2022-02-22 10:33:23.135231	\N	\N	f
336	8	2022-03-23 00:39:35.187442	\N	\N	f
336	6	2022-11-25 03:10:36.377295	\N	\N	f
337	9	2022-05-05 15:16:18.562716	\N	\N	f
337	10	2022-05-10 03:09:05.52105	\N	\N	f
337	4	2022-05-16 03:07:45.030889	\N	\N	f
338	3	2022-04-03 05:45:04.914454	\N	\N	f
338	7	2022-04-28 13:10:19.050348	\N	\N	f
338	1	2022-05-24 14:33:16.591066	\N	\N	f
339	6	2022-07-20 14:38:55.520038	\N	\N	f
339	11	2022-12-16 11:12:57.646528	\N	\N	f
340	5	2022-02-02 22:06:32.972389	\N	\N	f
340	1	2022-12-16 05:25:09.518183	\N	\N	f
340	7	2023-05-22 05:18:51.268534	\N	\N	f
341	6	2022-11-25 01:11:20.204131	\N	\N	f
341	8	2023-01-11 05:33:05.771195	\N	\N	f
341	7	2023-01-15 04:47:02.164122	\N	\N	f
341	1	2023-07-24 07:42:12.926275	\N	\N	f
342	8	2022-09-05 16:14:40.050639	\N	\N	f
342	3	2023-03-11 10:14:17.801927	\N	\N	f
342	9	2023-12-01 14:02:38.03852	\N	\N	f
343	7	2022-04-24 22:43:55.697489	\N	\N	f
343	3	2022-05-12 15:17:25.261837	\N	\N	f
343	6	2022-08-31 17:49:38.267032	\N	\N	f
344	4	2022-03-20 06:58:17.672778	\N	\N	f
344	11	2022-04-19 07:05:56.664706	\N	\N	f
344	1	2023-01-25 19:40:00.349207	\N	\N	f
345	8	2023-08-23 01:13:50.630105	\N	\N	f
345	11	2023-11-07 22:47:52.021153	\N	\N	f
345	3	2023-12-10 21:28:33.683222	\N	\N	f
346	6	2022-01-07 11:50:40.20813	\N	\N	f
346	9	2022-02-03 02:58:48.56726	\N	\N	f
347	3	2022-06-14 14:09:07.846316	\N	\N	f
347	6	2022-09-02 07:56:39.165475	\N	\N	f
347	5	2023-01-13 16:49:28.129938	\N	\N	f
348	3	2022-02-23 18:13:56.419051	\N	\N	f
348	7	2022-03-17 00:46:57.281951	\N	\N	f
348	6	2022-08-24 12:44:57.026941	\N	\N	f
349	5	2022-03-14 13:00:08.725821	\N	\N	f
349	10	2022-05-29 22:47:05.177025	\N	\N	f
349	4	2022-11-06 14:17:07.698386	\N	\N	f
350	5	2022-02-01 21:47:44.861689	\N	\N	f
350	7	2022-02-24 16:53:26.71689	\N	\N	f
350	1	2022-08-11 16:15:41.398992	\N	\N	f
351	5	2022-05-22 16:42:51.012121	\N	\N	f
351	6	2023-05-23 01:54:11.702649	\N	\N	f
351	3	2023-08-15 05:40:38.638314	\N	\N	f
352	8	2022-04-04 23:43:08.781502	\N	\N	f
352	10	2023-03-10 17:12:05.12742	\N	\N	f
353	1	2022-03-16 09:22:59.413051	\N	\N	f
353	11	2022-07-22 12:32:27.977822	\N	\N	f
353	9	2022-10-08 21:09:22.915106	\N	\N	f
354	2	2022-08-18 03:55:05.191027	\N	\N	f
354	8	2022-10-10 03:07:28.159016	\N	\N	f
354	9	2022-11-16 05:52:07.691186	\N	\N	f
355	10	2023-02-06 00:33:13.614351	\N	\N	f
356	11	2022-05-31 20:15:32.537446	\N	\N	f
356	1	2022-12-28 01:27:03.159331	\N	\N	f
357	11	2022-06-20 04:03:05.429483	\N	\N	f
357	10	2022-07-22 05:47:47.158226	\N	\N	f
357	2	2022-09-26 00:29:00.868535	\N	\N	f
358	5	2022-02-03 14:50:54.719068	\N	\N	f
359	8	2022-06-02 01:37:23.818324	\N	\N	f
359	3	2022-08-05 13:29:46.425081	\N	\N	f
360	5	2022-02-14 17:47:23.556926	\N	\N	f
361	2	2022-01-20 09:01:07.569252	\N	\N	f
361	1	2022-04-07 23:03:33.816512	\N	\N	f
361	7	2022-08-26 05:40:35.045393	\N	\N	f
361	10	2022-09-12 13:09:21.19269	\N	\N	f
362	5	2023-06-03 13:38:05.261977	\N	\N	f
362	2	2023-12-12 17:48:41.555721	\N	\N	f
362	8	2024-01-24 22:40:58.738892	\N	\N	f
362	1	2024-01-25 20:45:57.968762	\N	\N	f
363	8	2022-05-03 21:02:22.676617	\N	\N	f
363	11	2024-06-27 03:01:27.938058	\N	\N	f
364	1	2022-04-12 03:22:52.018805	\N	\N	f
364	10	2023-03-13 04:09:18.257632	\N	\N	f
364	3	2023-12-27 03:09:02.157563	\N	\N	f
365	8	2022-04-11 17:54:36.122051	\N	\N	f
365	11	2022-04-14 21:38:15.105869	\N	\N	f
365	9	2022-09-05 17:24:44.441324	\N	\N	f
366	8	2022-11-29 06:24:10.550308	\N	\N	f
366	1	2023-04-03 02:45:56.409899	\N	\N	f
366	2	2023-11-03 09:28:45.788178	\N	\N	f
367	10	2022-01-21 06:14:41.516619	\N	\N	f
367	4	2022-10-14 00:15:02.398334	\N	\N	f
367	11	2022-10-28 21:36:49.437307	\N	\N	f
368	7	2022-02-21 11:03:51.809628	\N	\N	f
369	7	2022-09-12 14:37:55.107246	\N	\N	f
369	6	2022-12-31 04:40:54.022979	\N	\N	f
369	1	2023-06-12 00:13:16.898881	\N	\N	f
370	1	2022-01-13 12:30:48.104983	\N	\N	f
371	9	2022-01-06 20:06:57.565881	\N	\N	f
371	4	2022-09-20 14:58:12.783894	\N	\N	f
372	1	2022-06-30 16:07:31.303589	\N	\N	f
372	11	2022-08-21 04:14:49.438205	\N	\N	f
373	11	2022-02-10 09:20:17.246073	\N	\N	f
373	1	2022-02-10 21:51:27.348153	\N	\N	f
373	10	2022-02-11 20:52:58.529866	\N	\N	f
374	5	2022-11-25 12:54:27.137464	\N	\N	f
374	7	2023-02-15 17:38:39.742712	\N	\N	f
375	1	2022-02-07 08:42:23.041237	\N	\N	f
375	2	2022-04-08 17:34:31.045587	\N	\N	f
376	10	2022-10-10 16:38:43.791973	\N	\N	f
376	1	2022-12-17 16:14:52.102743	\N	\N	f
376	5	2023-06-14 09:47:07.778518	\N	\N	f
377	9	2022-04-27 01:50:38.238847	\N	\N	f
377	8	2022-08-16 15:52:04.200845	\N	\N	f
378	8	2022-03-01 20:53:23.09567	\N	\N	f
378	2	2023-02-14 04:03:40.655805	\N	\N	f
378	6	2023-05-07 17:10:00.258778	\N	\N	f
378	10	2023-07-16 12:46:11.935047	\N	\N	f
379	8	2022-01-15 19:11:04.698462	\N	\N	f
379	11	2022-07-06 02:21:56.452545	\N	\N	f
380	9	2022-06-27 04:15:54.668166	\N	\N	f
380	1	2023-10-18 21:31:40.942875	\N	\N	f
380	6	2024-03-09 00:53:01.77433	\N	\N	f
381	6	2022-06-15 02:00:19.212886	\N	\N	f
381	9	2023-04-20 10:16:38.755947	\N	\N	f
382	8	2022-04-20 18:05:36.785887	\N	\N	f
382	3	2022-06-13 03:38:47.019772	\N	\N	f
382	4	2023-10-18 13:18:32.838552	\N	\N	f
383	2	2022-08-22 22:19:01.75381	\N	\N	f
383	1	2023-02-07 13:00:12.367131	\N	\N	f
384	10	2022-01-16 16:19:53.8255	\N	\N	f
384	7	2022-04-30 23:21:40.004371	\N	\N	f
384	8	2022-09-02 23:38:56.996884	\N	\N	f
385	9	2022-03-02 03:44:20.936714	\N	\N	f
385	8	2022-03-18 23:05:05.508794	\N	\N	f
385	6	2022-05-28 23:14:30.383719	\N	\N	f
386	5	2022-08-19 05:56:59.01854	\N	\N	f
386	1	2024-03-11 00:18:37.319204	\N	\N	f
387	4	2022-04-30 11:20:18.161309	\N	\N	f
387	8	2022-05-02 12:11:34.49887	\N	\N	f
387	3	2022-08-23 02:10:01.878185	\N	\N	f
388	7	2022-03-21 06:26:43.060354	\N	\N	f
388	8	2022-07-13 17:14:24.760161	\N	\N	f
389	7	2022-02-14 10:32:38.982574	\N	\N	f
389	3	2022-03-29 01:12:50.963829	\N	\N	f
389	8	2022-10-16 04:16:12.746178	\N	\N	f
390	1	2022-05-11 13:19:01.983698	\N	\N	f
390	7	2022-10-01 19:41:53.974848	\N	\N	f
390	11	2022-11-28 02:53:01.913073	\N	\N	f
391	1	2022-03-03 06:30:54.647867	\N	\N	f
391	10	2022-06-14 19:50:33.781539	\N	\N	f
392	8	2022-06-01 21:57:59.293673	\N	\N	f
392	4	2022-07-10 07:22:58.496682	\N	\N	f
392	5	2022-12-26 18:03:39.65498	\N	\N	f
393	9	2022-09-24 06:14:07.54176	\N	\N	f
393	4	2023-03-27 07:47:41.952537	\N	\N	f
394	8	2022-06-20 23:01:00.850705	\N	\N	f
394	5	2022-08-03 20:40:27.951674	\N	\N	f
394	3	2022-08-17 08:02:13.770531	\N	\N	f
394	7	2022-08-29 06:23:16.2155	\N	\N	f
395	7	2022-11-15 02:33:13.425153	\N	\N	f
395	8	2022-12-27 04:30:07.84478	\N	\N	f
396	4	2023-05-27 13:35:12.099069	\N	\N	f
397	10	2023-02-21 16:44:18.878313	\N	\N	f
397	5	2023-04-27 13:17:00.348956	\N	\N	f
398	3	2022-06-03 18:41:58.47434	\N	\N	f
398	9	2023-03-20 04:39:31.287417	\N	\N	f
399	11	2022-02-13 06:37:17.340191	\N	\N	f
399	6	2022-04-27 14:24:49.002316	\N	\N	f
399	1	2022-10-20 17:40:37.152091	\N	\N	f
400	6	2022-04-12 18:20:40.611635	\N	\N	f
400	8	2022-11-27 02:09:16.458147	\N	\N	f
401	10	2022-07-06 04:14:13.215302	\N	\N	f
401	8	2022-11-11 02:15:31.030148	\N	\N	f
401	6	2023-01-20 13:56:51.984578	\N	\N	f
402	5	2022-01-06 11:06:59.541093	\N	\N	f
402	6	2022-07-30 04:08:36.235222	\N	\N	f
402	7	2023-09-18 21:23:57.434564	\N	\N	f
403	10	2022-01-31 23:54:52.82175	\N	\N	f
403	8	2022-09-28 02:07:16.24949	\N	\N	f
404	10	2022-05-01 11:03:42.967913	\N	\N	f
404	8	2022-06-07 14:58:35.657131	\N	\N	f
404	11	2022-08-23 05:46:38.699876	\N	\N	f
405	9	2022-06-29 00:25:09.990216	\N	\N	f
405	2	2023-01-02 18:22:29.213821	\N	\N	f
406	8	2022-02-08 00:41:45.733483	\N	\N	f
406	11	2022-12-08 19:01:54.745339	\N	\N	f
406	3	2024-01-06 04:21:34.180356	\N	\N	f
407	11	2022-05-13 11:08:19.680429	\N	\N	f
407	2	2022-05-26 08:11:15.323446	\N	\N	f
408	10	2022-07-14 06:12:39.7387	\N	\N	f
408	9	2023-02-24 21:13:41.619707	\N	\N	f
409	3	2022-03-11 03:25:31.463044	\N	\N	f
409	7	2022-06-26 18:01:19.433059	\N	\N	f
409	5	2023-06-02 09:08:25.303168	\N	\N	f
410	2	2022-03-01 02:22:33.959314	\N	\N	f
410	11	2022-11-02 08:32:03.229716	\N	\N	f
411	11	2023-01-24 15:22:20.73583	\N	\N	f
411	5	2024-02-17 01:41:48.425327	\N	\N	f
412	11	2022-05-06 04:23:01.921351	\N	\N	f
412	5	2022-08-01 12:25:12.99584	\N	\N	f
412	7	2022-09-09 15:57:17.723199	\N	\N	f
413	4	2023-02-06 23:52:26.260515	\N	\N	f
413	9	2023-04-15 13:53:27.250049	\N	\N	f
413	10	2023-08-24 04:02:39.832137	\N	\N	f
414	9	2022-02-16 17:04:29.626926	\N	\N	f
414	1	2022-03-25 13:31:48.272031	\N	\N	f
415	9	2022-03-27 07:57:18.239581	\N	\N	f
415	1	2023-01-10 10:57:51.805492	\N	\N	f
415	11	2023-04-15 21:16:58.293073	\N	\N	f
416	11	2022-05-21 02:35:24.218258	\N	\N	f
416	4	2022-07-29 07:10:36.407932	\N	\N	f
416	2	2023-05-28 14:01:00.398169	\N	\N	f
417	11	2022-03-03 13:39:49.393752	\N	\N	f
417	3	2022-05-31 11:47:43.586475	\N	\N	f
418	3	2022-01-19 12:30:14.114907	\N	\N	f
418	10	2022-01-21 08:24:56.405164	\N	\N	f
419	9	2022-03-21 17:08:05.033161	\N	\N	f
419	3	2022-04-30 22:22:30.450222	\N	\N	f
420	6	2022-07-10 02:52:04.379133	\N	\N	f
420	1	2022-07-10 04:25:02.008816	\N	\N	f
420	7	2023-01-15 01:06:56.04868	\N	\N	f
421	7	2022-01-09 23:11:49.232933	\N	\N	f
421	5	2022-10-31 19:18:19.743256	\N	\N	f
421	9	2022-11-13 22:44:14.874773	\N	\N	f
422	9	2022-03-07 03:58:37.922307	\N	\N	f
422	1	2022-09-18 17:03:44.24438	\N	\N	f
422	3	2022-10-15 20:42:22.615449	\N	\N	f
422	4	2023-03-25 19:51:41.362893	\N	\N	f
423	11	2022-04-14 10:13:15.836805	\N	\N	f
423	7	2022-06-05 05:45:02.317399	\N	\N	f
423	6	2022-07-06 11:22:37.602747	\N	\N	f
424	6	2022-02-27 19:21:43.738105	\N	\N	f
424	11	2022-08-14 09:57:21.52834	\N	\N	f
424	3	2022-10-19 08:14:42.769432	\N	\N	f
424	10	2022-11-20 15:48:37.996063	\N	\N	f
425	11	2022-03-02 09:51:50.000975	\N	\N	f
425	5	2023-03-28 06:40:34.358214	\N	\N	f
426	8	2022-03-02 18:43:09.407174	\N	\N	f
426	3	2022-08-16 06:21:58.784166	\N	\N	f
427	1	2022-02-11 01:13:29.983724	\N	\N	f
427	10	2022-04-06 19:49:30.84884	\N	\N	f
427	8	2022-08-29 13:09:44.641005	\N	\N	f
428	2	2022-02-06 21:50:11.587061	\N	\N	f
428	6	2022-03-11 15:56:25.075388	\N	\N	f
429	7	2022-02-11 16:37:57.688039	\N	\N	f
429	2	2022-02-19 21:46:44.146328	\N	\N	f
430	2	2022-03-22 22:52:06.863072	\N	\N	f
430	9	2023-01-04 20:07:13.87352	\N	\N	f
431	10	2022-09-08 05:22:30.513923	\N	\N	f
431	5	2023-02-03 04:43:02.802109	\N	\N	f
432	3	2022-06-08 05:47:13.543958	\N	\N	f
433	1	2022-01-12 14:06:08.285021	\N	\N	f
433	5	2023-01-31 01:12:59.653288	\N	\N	f
434	1	2022-02-11 12:31:25.63125	\N	\N	f
435	3	2022-01-17 09:18:25.993032	\N	\N	f
436	5	2022-11-16 10:42:39.934993	\N	\N	f
436	10	2023-05-12 22:51:26.940273	\N	\N	f
437	4	2022-02-02 19:39:54.386559	\N	\N	f
437	11	2022-04-14 17:07:22.397383	\N	\N	f
437	6	2022-04-28 13:14:50.439786	\N	\N	f
438	11	2022-03-09 06:55:50.257807	\N	\N	f
438	2	2022-03-28 15:00:33.169945	\N	\N	f
438	6	2022-04-01 06:57:31.127965	\N	\N	f
439	5	2022-01-05 06:30:54.827893	\N	\N	f
439	4	2022-07-14 02:00:37.088334	\N	\N	f
439	11	2022-08-27 16:49:27.653002	\N	\N	f
439	8	2022-11-18 01:53:08.748542	\N	\N	f
440	2	2022-08-03 22:37:03.940695	\N	\N	f
440	9	2022-10-29 20:02:47.711116	\N	\N	f
441	1	2022-02-06 18:23:28.536045	\N	\N	f
441	3	2022-04-17 00:34:21.1216	\N	\N	f
441	9	2023-05-21 03:59:03.019356	\N	\N	f
442	5	2022-01-14 03:40:29.968294	\N	\N	f
442	4	2023-01-26 13:41:59.872964	\N	\N	f
442	2	2023-06-23 00:26:43.790886	\N	\N	f
443	10	2022-01-13 21:13:10.243247	\N	\N	f
443	2	2022-04-19 18:50:33.257776	\N	\N	f
444	7	2022-01-16 11:16:37.754528	\N	\N	f
444	11	2022-07-05 11:59:00.227716	\N	\N	f
444	9	2022-12-04 07:07:33.771	\N	\N	f
444	4	2022-12-09 11:09:50.304498	\N	\N	f
445	1	2022-01-10 01:42:57.554919	\N	\N	f
445	5	2022-02-01 01:01:59.761921	\N	\N	f
445	9	2022-06-11 02:09:54.397779	\N	\N	f
445	11	2022-07-30 02:56:59.638215	\N	\N	f
446	2	2022-01-06 09:02:21.30851	\N	\N	f
446	5	2022-12-02 11:06:20.99598	\N	\N	f
446	10	2023-01-24 05:45:36.005169	\N	\N	f
446	6	2023-02-28 20:20:26.973536	\N	\N	f
447	6	2022-10-19 20:12:51.937809	\N	\N	f
447	10	2023-07-05 15:32:35.421964	\N	\N	f
448	5	2022-04-27 17:48:21.693228	\N	\N	f
448	11	2022-08-31 12:00:46.829917	\N	\N	f
449	5	2022-02-26 01:37:58.179572	\N	\N	f
449	6	2023-01-26 16:00:24.276821	\N	\N	f
450	5	2022-03-18 02:21:35.814172	\N	\N	f
450	9	2022-12-22 09:18:26.454455	\N	\N	f
451	9	2022-01-19 15:52:13.998332	\N	\N	f
451	11	2023-03-31 01:34:32.227519	\N	\N	f
451	2	2023-11-07 15:57:02.872653	\N	\N	f
452	8	2022-05-17 17:31:49.989952	\N	\N	f
452	7	2022-06-05 06:45:20.871985	\N	\N	f
452	10	2023-01-17 19:33:55.002788	\N	\N	f
452	2	2023-03-02 13:25:16.236164	\N	\N	f
453	3	2022-02-20 12:54:27.34633	\N	\N	f
453	8	2022-09-13 01:52:45.927213	\N	\N	f
453	9	2022-10-11 11:32:21.115041	\N	\N	f
454	9	2022-09-22 12:24:02.978473	\N	\N	f
454	11	2023-02-08 09:56:46.071818	\N	\N	f
455	9	2022-01-26 18:01:32.106347	\N	\N	f
455	11	2022-09-07 15:14:29.734858	\N	\N	f
455	4	2023-02-11 05:53:10.89878	\N	\N	f
456	2	2022-01-27 07:36:33.918607	\N	\N	f
456	5	2022-01-30 19:02:33.503857	\N	\N	f
456	9	2022-02-28 07:28:38.883807	\N	\N	f
456	8	2022-05-04 14:38:07.59523	\N	\N	f
457	11	2022-06-29 20:52:42.879081	\N	\N	f
457	8	2022-07-31 09:27:49.477921	\N	\N	f
457	9	2022-09-21 17:52:12.744016	\N	\N	f
457	3	2023-01-16 21:23:49.050127	\N	\N	f
458	8	2022-02-10 13:21:01.393151	\N	\N	f
458	10	2022-02-16 05:58:41.96931	\N	\N	f
458	3	2022-09-17 05:08:42.147327	\N	\N	f
459	2	2022-05-25 07:34:20.147186	\N	\N	f
459	1	2022-08-26 07:58:11.04996	\N	\N	f
459	5	2023-05-20 18:16:09.501562	\N	\N	f
460	8	2022-02-17 23:02:42.577942	\N	\N	f
460	5	2022-09-12 15:58:40.054849	\N	\N	f
460	11	2023-01-12 11:35:52.149051	\N	\N	f
461	3	2022-03-03 09:31:24.601441	\N	\N	f
461	11	2022-03-05 01:11:48.904349	\N	\N	f
462	4	2022-03-26 01:53:15.703479	\N	\N	f
462	3	2022-09-19 12:09:25.974853	\N	\N	f
463	6	2022-04-12 10:32:12.847839	\N	\N	f
463	10	2022-06-04 23:04:19.725671	\N	\N	f
464	2	2022-03-09 01:16:58.874746	\N	\N	f
464	7	2022-05-10 12:36:18.677791	\N	\N	f
464	11	2022-10-30 16:16:42.637484	\N	\N	f
465	1	2022-11-05 03:41:36.074825	\N	\N	f
465	3	2023-02-21 03:24:08.452592	\N	\N	f
466	8	2022-02-04 04:13:23.092447	\N	\N	f
466	9	2022-02-06 12:07:40.99934	\N	\N	f
467	4	2022-01-13 07:15:17.593236	\N	\N	f
467	2	2022-06-25 09:55:47.900909	\N	\N	f
467	9	2023-06-29 16:46:52.421806	\N	\N	f
468	9	2022-05-12 07:45:10.690214	\N	\N	f
468	3	2022-05-26 07:16:16.659973	\N	\N	f
468	7	2022-06-03 07:23:40.527438	\N	\N	f
469	2	2022-04-18 08:21:15.327519	\N	\N	f
469	6	2022-08-11 11:32:19.340687	\N	\N	f
470	3	2022-02-13 22:50:33.482361	\N	\N	f
471	1	2022-01-17 12:40:13.463713	\N	\N	f
471	4	2022-07-09 04:39:03.916463	\N	\N	f
472	1	2022-01-04 04:54:44.9196	\N	\N	f
472	3	2022-11-15 11:38:22.471353	\N	\N	f
472	7	2023-10-03 13:13:51.065434	\N	\N	f
473	11	2022-05-16 09:30:34.971196	\N	\N	f
473	2	2022-05-29 04:24:58.217414	\N	\N	f
474	2	2022-04-12 04:08:33.510627	\N	\N	f
474	6	2022-11-11 01:14:16.40908	\N	\N	f
474	3	2023-06-20 09:48:45.269497	\N	\N	f
475	8	2022-07-08 15:11:33.928717	\N	\N	f
475	1	2023-01-25 20:31:54.648051	\N	\N	f
475	9	2023-08-28 01:57:19.368286	\N	\N	f
475	7	2023-09-15 06:53:26.234528	\N	\N	f
476	7	2022-01-01 07:22:42.229565	\N	\N	f
476	6	2022-05-03 00:39:38.767668	\N	\N	f
477	8	2022-06-14 11:38:17.4297	\N	\N	f
477	3	2022-08-06 12:14:17.281583	\N	\N	f
477	7	2022-12-27 17:36:59.963701	\N	\N	f
478	9	2022-04-13 19:12:04.72225	\N	\N	f
478	5	2022-10-04 21:47:52.312376	\N	\N	f
479	7	2022-02-19 20:05:28.382353	\N	\N	f
479	11	2022-11-12 07:58:31.779484	\N	\N	f
480	5	2022-03-18 02:26:44.737071	\N	\N	f
481	8	2022-04-25 17:32:36.296725	\N	\N	f
481	6	2023-06-26 16:07:42.185404	\N	\N	f
482	5	2022-01-06 02:43:23.849257	\N	\N	f
482	4	2022-09-17 07:33:37.083472	\N	\N	f
483	8	2022-01-21 13:44:53.962055	\N	\N	f
484	7	2022-03-06 23:18:02.67381	\N	\N	f
484	2	2023-03-04 17:51:21.733479	\N	\N	f
484	8	2023-04-15 15:46:50.717547	\N	\N	f
485	3	2022-06-22 18:49:28.925173	\N	\N	f
485	4	2022-07-27 02:25:23.123017	\N	\N	f
485	5	2022-12-12 11:02:01.783896	\N	\N	f
486	6	2022-03-06 15:23:18.65788	\N	\N	f
486	3	2022-03-07 20:51:26.900734	\N	\N	f
486	4	2022-05-11 08:47:46.294555	\N	\N	f
487	7	2023-04-01 02:31:25.140592	\N	\N	f
487	1	2023-06-02 13:50:26.271415	\N	\N	f
487	11	2023-10-17 03:11:15.295706	\N	\N	f
488	1	2022-08-04 07:06:58.423218	\N	\N	f
488	10	2022-09-24 21:50:53.897455	\N	\N	f
488	7	2023-11-27 00:48:20.254345	\N	\N	f
489	6	2022-04-28 08:07:40.942705	\N	\N	f
489	2	2023-01-14 00:18:28.125822	\N	\N	f
489	7	2023-05-01 13:42:25.898266	\N	\N	f
490	10	2022-02-11 16:15:16.2425	\N	\N	f
490	6	2022-02-26 09:26:19.066718	\N	\N	f
490	9	2022-06-23 19:38:00.862074	\N	\N	f
490	8	2023-01-22 01:19:37.292806	\N	\N	f
491	10	2022-01-31 06:20:29.687815	\N	\N	f
491	11	2022-05-22 23:43:29.541311	\N	\N	f
491	6	2022-08-08 08:23:24.359637	\N	\N	f
491	1	2022-09-10 16:48:06.684918	\N	\N	f
492	7	2022-01-31 21:31:23.317966	\N	\N	f
492	3	2023-05-04 04:58:00.563014	\N	\N	f
493	8	2022-03-08 00:44:23.027365	\N	\N	f
493	4	2023-02-05 08:20:07.617838	\N	\N	f
493	10	2024-01-06 00:52:54.102813	\N	\N	f
494	5	2022-06-22 01:20:29.205939	\N	\N	f
495	1	2022-03-22 06:26:45.14967	\N	\N	f
495	5	2022-10-14 14:47:43.416918	\N	\N	f
495	2	2023-09-11 19:11:06.339325	\N	\N	f
496	1	2022-05-18 18:03:47.442741	\N	\N	f
496	6	2022-08-24 07:09:26.63877	\N	\N	f
496	7	2022-09-01 03:19:09.337203	\N	\N	f
497	3	2022-04-15 11:24:26.25278	\N	\N	f
497	10	2023-01-08 00:29:12.369883	\N	\N	f
497	7	2023-06-18 16:27:20.369174	\N	\N	f
498	7	2022-06-19 11:09:26.06386	\N	\N	f
498	3	2022-09-27 15:55:25.505422	\N	\N	f
499	1	2022-11-24 02:02:41.932514	\N	\N	f
499	2	2023-12-22 09:37:29.553529	\N	\N	f
500	11	2022-08-02 16:09:16.892428	\N	\N	f
500	10	2022-09-12 18:40:44.314963	\N	\N	f
501	5	2022-10-28 00:11:44.829009	\N	\N	f
501	7	2023-03-08 18:20:13.683593	\N	\N	f
501	6	2023-04-12 22:47:38.84915	\N	\N	f
501	11	2023-06-04 12:19:07.069239	\N	\N	f
502	7	2022-04-18 17:20:57.690692	\N	\N	f
502	5	2022-05-02 19:20:42.550376	\N	\N	f
502	6	2022-10-16 00:33:27.652137	\N	\N	f
503	9	2022-08-04 22:16:15.152413	\N	\N	f
503	1	2023-02-26 21:15:35.295782	\N	\N	f
504	4	2023-09-27 23:25:36.210804	\N	\N	f
504	10	2024-01-15 03:13:46.890537	\N	\N	f
505	10	2022-04-25 05:27:23.877447	\N	\N	f
505	4	2022-10-21 11:23:14.507071	\N	\N	f
505	11	2023-09-21 19:03:47.243509	\N	\N	f
506	7	2022-01-22 07:26:44.14916	\N	\N	f
506	6	2022-03-07 02:00:50.365726	\N	\N	f
507	5	2022-03-15 02:02:54.034349	\N	\N	f
508	6	2023-11-20 11:44:45.36902	\N	\N	f
508	1	2024-01-01 02:58:29.479941	\N	\N	f
508	11	2024-02-22 06:01:31.153104	\N	\N	f
509	7	2022-06-23 16:31:41.394758	\N	\N	f
509	1	2022-12-08 00:44:04.813677	\N	\N	f
510	10	2022-03-15 17:47:53.671369	\N	\N	f
510	9	2022-04-12 05:02:22.427748	\N	\N	f
510	5	2022-05-14 13:51:47.818462	\N	\N	f
511	7	2023-02-12 17:51:44.874243	\N	\N	f
511	5	2023-05-14 06:43:10.085039	\N	\N	f
512	6	2022-07-10 10:55:23.782015	\N	\N	f
512	8	2022-11-18 19:26:06.043189	\N	\N	f
512	1	2023-02-21 01:32:16.95645	\N	\N	f
513	7	2022-05-04 23:14:34.496164	\N	\N	f
513	9	2022-11-20 07:17:48.04019	\N	\N	f
514	10	2022-09-16 15:44:43.728361	\N	\N	f
514	8	2022-12-13 22:30:51.246854	\N	\N	f
514	6	2023-09-29 07:01:51.240665	\N	\N	f
515	6	2022-01-07 04:04:04.555487	\N	\N	f
515	2	2022-01-24 05:45:33.37453	\N	\N	f
515	3	2022-02-10 16:14:09.150206	\N	\N	f
516	8	2022-06-22 09:06:41.675244	\N	\N	f
516	9	2022-07-28 08:46:25.982028	\N	\N	f
516	5	2022-07-30 02:19:46.337984	\N	\N	f
517	10	2023-04-12 06:13:47.298603	\N	\N	f
518	10	2022-01-04 12:42:09.185732	\N	\N	f
518	1	2022-01-14 19:28:41.462635	\N	\N	f
518	5	2022-04-10 11:12:44.001029	\N	\N	f
518	8	2022-10-28 05:34:49.042552	\N	\N	f
519	8	2022-04-07 23:52:03.378642	\N	\N	f
519	9	2022-04-21 23:13:05.390897	\N	\N	f
519	7	2022-05-10 08:13:05.758937	\N	\N	f
520	5	2022-12-16 13:47:06.587713	\N	\N	f
520	9	2023-01-16 00:24:18.209614	\N	\N	f
521	3	2022-06-28 12:48:06.630344	\N	\N	f
521	4	2023-08-27 03:38:38.873793	\N	\N	f
521	11	2024-07-03 02:01:57.322471	\N	\N	f
522	10	2022-05-01 21:37:08.112821	\N	\N	f
522	1	2022-05-05 14:04:08.861874	\N	\N	f
522	5	2023-03-30 22:03:57.361428	\N	\N	f
523	8	2022-01-16 22:34:00.981441	\N	\N	f
523	5	2022-10-21 03:30:54.195185	\N	\N	f
523	9	2023-04-24 01:50:26.418939	\N	\N	f
524	2	2023-03-31 23:13:28.721635	\N	\N	f
524	4	2024-02-25 07:48:34.040906	\N	\N	f
525	7	2022-01-17 12:49:29.74571	\N	\N	f
525	11	2022-04-11 08:20:47.442429	\N	\N	f
525	5	2022-08-22 21:53:51.19677	\N	\N	f
525	6	2022-11-14 10:14:28.232353	\N	\N	f
526	6	2022-09-08 12:27:44.671165	\N	\N	f
526	9	2022-09-23 18:13:26.873407	\N	\N	f
527	6	2022-01-28 10:10:56.90509	\N	\N	f
527	8	2022-06-19 11:06:02.730813	\N	\N	f
527	7	2024-01-31 16:30:12.552634	\N	\N	f
528	2	2022-02-22 05:43:10.446976	\N	\N	f
528	9	2022-08-25 07:02:43.61619	\N	\N	f
528	8	2022-12-27 11:29:50.954275	\N	\N	f
529	2	2022-07-10 17:49:06.696297	\N	\N	f
529	11	2023-02-28 05:26:18.446302	\N	\N	f
530	3	2022-03-09 14:27:42.600081	\N	\N	f
530	7	2022-04-18 12:15:32.466618	\N	\N	f
530	11	2022-04-29 20:41:51.82243	\N	\N	f
531	9	2022-01-19 01:11:01.838618	\N	\N	f
531	8	2022-11-17 14:39:53.307265	\N	\N	f
531	10	2023-01-02 19:15:25.626407	\N	\N	f
531	6	2023-01-26 18:27:41.115811	\N	\N	f
532	5	2022-02-08 17:59:57.853795	\N	\N	f
532	8	2022-07-03 20:05:22.475296	\N	\N	f
532	6	2023-02-15 20:37:25.466527	\N	\N	f
533	8	2022-11-11 23:38:12.408977	\N	\N	f
533	3	2023-04-03 08:28:44.87011	\N	\N	f
533	5	2023-10-03 02:52:17.617923	\N	\N	f
534	4	2022-03-18 14:25:38.476833	\N	\N	f
534	1	2022-04-15 20:21:06.687943	\N	\N	f
534	9	2022-05-02 08:54:00.429856	\N	\N	f
534	11	2023-04-04 03:28:02.403516	\N	\N	f
535	2	2022-01-01 01:21:19.15824	\N	\N	f
535	11	2022-01-12 09:15:59.636783	\N	\N	f
536	7	2022-12-11 08:03:59.15647	\N	\N	f
536	2	2023-02-13 06:07:07.635922	\N	\N	f
536	1	2023-02-28 03:23:42.707084	\N	\N	f
536	6	2023-03-21 13:07:08.039085	\N	\N	f
537	3	2022-03-18 15:01:59.224153	\N	\N	f
537	4	2022-03-19 10:45:28.707235	\N	\N	f
537	7	2023-01-04 06:32:37.095706	\N	\N	f
538	5	2022-01-29 09:46:26.474519	\N	\N	f
538	6	2022-03-10 03:50:20.033597	\N	\N	f
538	11	2023-03-22 05:13:39.977105	\N	\N	f
539	4	2022-02-09 19:38:21.140704	\N	\N	f
539	7	2022-05-04 18:34:34.306522	\N	\N	f
539	9	2022-11-30 09:48:41.549486	\N	\N	f
540	4	2022-02-24 07:14:34.178043	\N	\N	f
540	11	2022-05-05 02:37:25.65254	\N	\N	f
541	8	2022-06-10 03:20:46.030148	\N	\N	f
541	9	2022-08-05 15:12:34.948929	\N	\N	f
542	4	2022-07-01 04:02:49.053078	\N	\N	f
542	3	2022-08-16 12:47:44.64363	\N	\N	f
543	10	2022-01-10 16:13:55.385343	\N	\N	f
543	9	2022-01-12 08:00:28.582677	\N	\N	f
543	5	2023-02-04 17:32:33.929556	\N	\N	f
544	4	2022-01-13 00:02:01.367204	\N	\N	f
544	7	2022-04-04 02:52:54.774232	\N	\N	f
545	2	2022-10-01 20:52:40.392585	\N	\N	f
545	5	2023-04-19 15:43:35.519119	\N	\N	f
545	11	2024-01-19 06:26:32.866986	\N	\N	f
546	9	2022-10-25 23:21:12.600056	\N	\N	f
547	2	2022-04-10 00:00:34.019412	\N	\N	f
547	5	2022-06-13 01:55:46.523504	\N	\N	f
548	11	2022-04-22 11:39:02.142766	\N	\N	f
548	9	2022-06-24 07:04:51.111472	\N	\N	f
549	5	2022-01-26 08:20:55.10681	\N	\N	f
549	4	2022-11-21 08:06:28.603931	\N	\N	f
549	8	2023-01-01 01:30:28.845066	\N	\N	f
550	3	2022-06-18 16:20:31.515441	\N	\N	f
550	7	2022-11-06 08:58:01.200895	\N	\N	f
550	5	2023-01-25 16:32:40.704767	\N	\N	f
551	10	2022-01-16 02:29:15.58964	\N	\N	f
551	9	2022-05-20 21:47:42.065025	\N	\N	f
551	3	2023-08-18 20:16:02.6502	\N	\N	f
552	4	2022-07-22 16:50:55.098299	\N	\N	f
552	9	2023-09-20 01:38:51.79456	\N	\N	f
553	2	2022-08-25 09:07:46.1889	\N	\N	f
553	1	2022-10-26 05:43:14.136316	\N	\N	f
553	8	2023-03-07 00:54:59.903194	\N	\N	f
554	3	2022-03-01 16:36:59.374394	\N	\N	f
554	2	2022-03-12 04:10:38.440242	\N	\N	f
554	10	2022-07-12 09:11:01.595033	\N	\N	f
555	1	2022-05-03 13:06:28.348725	\N	\N	f
555	4	2023-01-16 00:31:21.029833	\N	\N	f
555	2	2023-05-05 11:00:35.909267	\N	\N	f
555	5	2023-11-26 21:18:05.856477	\N	\N	f
556	8	2022-09-01 12:12:14.503928	\N	\N	f
556	9	2022-11-20 16:02:57.959117	\N	\N	f
557	4	2022-06-18 01:23:33.095221	\N	\N	f
558	1	2022-01-28 18:34:25.241329	\N	\N	f
558	8	2022-06-19 04:20:56.157714	\N	\N	f
558	11	2022-10-08 16:39:57.371458	\N	\N	f
558	2	2023-02-10 10:29:45.921109	\N	\N	f
559	4	2022-09-01 13:34:54.444689	\N	\N	f
559	5	2022-10-21 06:09:40.505378	\N	\N	f
559	6	2022-11-22 05:41:06.58485	\N	\N	f
560	8	2022-08-16 08:36:14.000125	\N	\N	f
560	3	2023-07-14 13:06:18.331245	\N	\N	f
560	7	2024-01-18 13:15:18.913557	\N	\N	f
561	9	2022-02-06 06:37:49.707553	\N	\N	f
561	4	2022-08-02 10:33:29.017036	\N	\N	f
561	8	2022-09-08 05:07:47.519276	\N	\N	f
561	5	2022-12-12 14:15:57.450765	\N	\N	f
562	6	2022-02-18 18:22:50.329912	\N	\N	f
562	2	2022-02-19 03:22:04.284455	\N	\N	f
562	10	2022-06-06 09:36:03.546853	\N	\N	f
563	8	2022-02-25 22:14:24.00434	\N	\N	f
563	2	2022-03-12 02:28:59.132467	\N	\N	f
564	1	2022-01-11 13:29:05.552433	\N	\N	f
564	3	2022-11-21 15:04:58.981623	\N	\N	f
565	9	2022-01-29 04:01:19.98833	\N	\N	f
565	6	2022-02-23 11:06:57.687703	\N	\N	f
566	3	2022-10-08 23:10:49.347751	\N	\N	f
566	11	2023-01-09 00:38:41.841021	\N	\N	f
567	4	2022-08-23 11:14:33.196714	\N	\N	f
568	1	2022-02-28 02:56:51.146511	\N	\N	f
568	9	2022-08-30 04:11:27.068549	\N	\N	f
568	11	2022-12-15 23:34:24.153658	\N	\N	f
568	2	2022-12-24 07:23:37.964776	\N	\N	f
569	5	2022-01-29 20:10:21.560267	\N	\N	f
569	2	2023-04-05 22:17:11.97138	\N	\N	f
570	2	2022-01-25 14:36:54.780952	\N	\N	f
570	3	2022-05-03 05:26:19.268112	\N	\N	f
570	6	2022-12-25 21:32:10.017895	\N	\N	f
571	4	2022-05-04 00:06:33.761775	\N	\N	f
571	10	2022-05-04 21:40:31.041916	\N	\N	f
571	3	2022-06-22 20:52:49.824319	\N	\N	f
572	7	2022-04-21 17:17:57.301016	\N	\N	f
573	2	2022-03-16 23:32:45.187325	\N	\N	f
573	8	2022-03-17 07:54:57.955052	\N	\N	f
573	4	2022-05-10 22:24:17.912795	\N	\N	f
573	9	2023-04-07 08:35:06.905128	\N	\N	f
574	4	2022-08-04 01:40:53.532068	\N	\N	f
574	8	2022-09-04 03:06:11.250181	\N	\N	f
574	1	2023-08-25 09:12:07.825035	\N	\N	f
575	9	2022-05-30 06:07:52.376536	\N	\N	f
575	3	2022-07-06 10:31:22.878552	\N	\N	f
576	3	2022-07-03 06:00:06.269063	\N	\N	f
576	4	2023-02-14 13:54:01.450459	\N	\N	f
576	10	2023-03-03 13:51:50.399045	\N	\N	f
576	6	2023-03-22 00:45:55.416141	\N	\N	f
577	3	2022-02-09 03:56:10.580972	\N	\N	f
578	9	2022-01-30 19:59:23.014478	\N	\N	f
578	6	2023-10-11 12:24:47.568536	\N	\N	f
579	6	2022-12-31 05:57:18.329437	\N	\N	f
579	8	2023-02-03 07:20:48.038882	\N	\N	f
579	1	2023-05-16 16:50:45.72055	\N	\N	f
580	10	2022-01-28 12:49:07.888075	\N	\N	f
580	11	2022-05-03 23:08:27.823602	\N	\N	f
580	7	2022-05-18 20:09:15.43508	\N	\N	f
580	3	2022-09-23 03:03:52.166421	\N	\N	f
581	11	2022-03-06 20:26:06.983488	\N	\N	f
581	8	2023-04-30 00:10:28.270908	\N	\N	f
582	11	2022-01-18 23:49:32.136534	\N	\N	f
582	10	2022-02-20 17:53:36.175915	\N	\N	f
582	9	2022-04-17 19:25:48.688865	\N	\N	f
583	9	2022-06-09 19:09:27.542529	\N	\N	f
583	6	2022-10-04 12:43:09.089394	\N	\N	f
583	4	2023-07-21 09:44:47.128302	\N	\N	f
584	8	2023-03-15 22:04:52.773099	\N	\N	f
584	11	2024-02-20 21:34:22.274511	\N	\N	f
585	7	2022-10-18 09:20:53.599041	\N	\N	f
585	5	2023-10-18 07:41:17.309596	\N	\N	f
586	10	2022-11-27 05:20:38.726372	\N	\N	f
586	1	2023-02-14 11:00:20.717775	\N	\N	f
587	7	2022-12-19 11:18:29.881982	\N	\N	f
587	6	2023-02-24 17:02:56.918208	\N	\N	f
587	3	2023-03-16 13:50:28.537161	\N	\N	f
588	6	2022-04-29 15:21:22.853415	\N	\N	f
588	4	2022-07-09 10:49:59.399708	\N	\N	f
588	9	2022-09-20 06:36:15.21646	\N	\N	f
589	9	2022-01-14 08:47:17.039784	\N	\N	f
589	7	2022-04-26 00:20:32.492005	\N	\N	f
589	8	2022-05-16 13:27:12.456447	\N	\N	f
590	11	2022-02-23 18:55:59.567523	\N	\N	f
590	2	2022-11-07 10:05:25.071455	\N	\N	f
591	7	2022-03-23 05:23:43.014374	\N	\N	f
591	1	2023-05-27 12:17:58.673437	\N	\N	f
591	5	2023-11-18 16:02:28.695124	\N	\N	f
592	3	2022-02-12 19:19:23.871091	\N	\N	f
593	6	2023-03-09 20:04:19.603864	\N	\N	f
593	2	2024-08-16 09:15:17.000028	\N	\N	f
594	3	2022-06-21 13:15:10.328268	\N	\N	f
595	5	2022-05-12 04:06:39.189106	\N	\N	f
595	11	2022-06-22 06:56:42.696883	\N	\N	f
595	4	2023-01-16 04:07:45.610354	\N	\N	f
596	2	2022-07-23 01:12:32.368803	\N	\N	f
596	11	2022-09-22 05:02:41.684814	\N	\N	f
597	1	2022-01-11 14:37:38.587234	\N	\N	f
597	7	2024-01-12 14:49:02.587945	\N	\N	f
598	7	2022-08-05 18:20:18.79152	\N	\N	f
598	3	2022-12-17 17:46:42.211364	\N	\N	f
599	2	2022-06-17 13:55:07.051406	\N	\N	f
599	7	2022-08-06 23:59:05.961532	\N	\N	f
599	1	2023-06-23 03:55:51.321586	\N	\N	f
600	6	2022-12-15 01:49:45.944025	\N	\N	f
600	2	2023-01-29 07:24:16.195771	\N	\N	f
600	5	2023-11-28 10:35:53.452011	\N	\N	f
601	4	2022-03-02 21:40:59.581639	\N	\N	f
601	8	2022-04-23 17:36:30.373742	\N	\N	f
601	7	2022-06-29 21:38:16.789163	\N	\N	f
602	6	2022-01-18 04:32:59.900279	\N	\N	f
602	3	2022-01-21 01:32:45.140472	\N	\N	f
603	8	2022-08-22 23:36:06.823705	\N	\N	f
604	7	2022-04-01 02:59:01.211465	\N	\N	f
604	1	2022-06-28 11:09:07.888854	\N	\N	f
604	3	2022-10-03 15:25:57.469767	\N	\N	f
605	11	2022-03-25 21:49:19.342826	\N	\N	f
605	7	2023-03-20 08:30:40.091578	\N	\N	f
605	6	2023-05-05 08:50:44.739701	\N	\N	f
605	1	2023-09-14 02:36:42.769326	\N	\N	f
606	9	2022-01-17 09:03:54.663388	\N	\N	f
607	4	2022-10-19 23:04:32.563261	\N	\N	f
607	10	2022-11-07 20:59:45.623721	\N	\N	f
608	11	2022-01-06 02:41:02.869301	\N	\N	f
608	10	2022-06-26 15:52:33.872379	\N	\N	f
608	9	2022-08-28 04:15:24.274945	\N	\N	f
609	9	2022-01-22 23:59:11.353034	\N	\N	f
609	11	2022-01-29 21:50:41.213793	\N	\N	f
610	2	2022-01-11 05:40:33.046169	\N	\N	f
610	10	2022-08-20 09:28:19.838169	\N	\N	f
610	8	2023-03-28 02:39:05.792567	\N	\N	f
611	2	2022-03-09 05:01:55.001313	\N	\N	f
611	6	2022-03-28 01:26:43.818825	\N	\N	f
612	5	2022-04-09 02:33:51.430504	\N	\N	f
612	3	2022-09-24 19:28:34.19633	\N	\N	f
612	7	2022-12-21 09:09:17.132746	\N	\N	f
613	9	2022-01-17 00:20:28.051254	\N	\N	f
613	8	2022-01-24 08:28:30.741926	\N	\N	f
613	2	2022-05-19 01:37:21.650174	\N	\N	f
613	4	2022-12-10 09:44:39.981151	\N	\N	f
614	11	2022-01-21 17:54:45.008496	\N	\N	f
615	5	2022-01-12 21:54:04.834091	\N	\N	f
615	2	2022-09-08 06:07:33.174974	\N	\N	f
616	5	2022-03-02 18:44:12.763714	\N	\N	f
616	10	2022-03-27 13:52:28.85142	\N	\N	f
617	2	2022-03-01 01:42:02.290669	\N	\N	f
617	6	2022-06-25 12:31:59.751128	\N	\N	f
618	1	2022-04-02 17:40:22.987288	\N	\N	f
618	4	2023-11-24 04:59:05.861927	\N	\N	f
619	7	2022-01-24 21:28:56.217911	\N	\N	f
620	1	2022-03-02 12:25:58.508255	\N	\N	f
621	1	2022-01-15 01:30:30.707914	\N	\N	f
621	2	2022-04-24 18:34:15.105752	\N	\N	f
622	6	2022-01-29 14:13:52.440315	\N	\N	f
622	8	2022-04-09 00:38:43.757918	\N	\N	f
623	8	2022-04-15 18:30:55.94685	\N	\N	f
623	11	2022-10-04 06:08:45.906736	\N	\N	f
624	11	2022-05-21 15:51:26.215984	\N	\N	f
624	7	2022-07-02 19:43:28.707921	\N	\N	f
625	1	2022-11-16 09:26:45.346608	\N	\N	f
625	3	2023-07-13 02:58:35.524233	\N	\N	f
626	4	2022-01-19 17:43:29.179992	\N	\N	f
626	5	2022-02-26 09:39:29.564405	\N	\N	f
627	4	2022-09-09 17:21:30.406267	\N	\N	f
627	8	2022-09-16 06:01:10.60082	\N	\N	f
627	5	2022-09-22 16:11:13.630145	\N	\N	f
628	7	2022-07-13 16:15:45.183541	\N	\N	f
628	2	2022-09-20 03:38:41.809902	\N	\N	f
628	6	2023-05-17 04:42:28.418744	\N	\N	f
628	10	2024-01-02 20:45:07.612689	\N	\N	f
629	6	2022-03-12 18:36:32.523797	\N	\N	f
629	10	2022-04-12 14:25:21.733127	\N	\N	f
629	1	2022-11-03 13:21:17.089874	\N	\N	f
630	11	2022-02-13 21:59:23.704816	\N	\N	f
630	1	2022-05-26 08:32:37.868053	\N	\N	f
630	2	2023-01-09 22:07:58.523063	\N	\N	f
631	4	2022-02-02 19:25:11.534634	\N	\N	f
631	8	2022-03-15 05:15:47.777864	\N	\N	f
632	6	2022-03-06 13:41:23.28372	\N	\N	f
632	8	2023-03-25 09:18:48.982823	\N	\N	f
632	3	2023-07-15 22:27:49.499128	\N	\N	f
633	8	2022-02-24 22:47:45.126316	\N	\N	f
634	5	2022-01-21 20:08:17.253967	\N	\N	f
634	11	2022-10-14 09:01:45.494439	\N	\N	f
635	3	2022-05-12 12:07:44.847798	\N	\N	f
635	4	2022-05-30 22:59:26.540383	\N	\N	f
636	1	2022-02-15 14:22:31.174046	\N	\N	f
637	7	2022-05-09 21:10:33.395246	\N	\N	f
637	9	2023-01-08 00:49:53.961008	\N	\N	f
638	6	2022-01-16 13:12:13.299061	\N	\N	f
639	8	2023-04-15 07:55:46.908627	\N	\N	f
639	1	2023-11-26 07:36:20.889173	\N	\N	f
639	2	2023-12-15 19:51:32.035169	\N	\N	f
640	3	2022-06-28 13:48:49.851441	\N	\N	f
641	11	2022-01-12 08:23:12.829861	\N	\N	f
641	4	2022-03-18 08:43:39.615865	\N	\N	f
642	2	2022-03-22 14:02:36.723718	\N	\N	f
643	7	2022-01-01 11:25:56.866814	\N	\N	f
643	9	2022-03-17 04:14:17.292769	\N	\N	f
644	4	2022-09-01 01:59:39.098106	\N	\N	f
644	2	2023-03-31 21:47:27.835294	\N	\N	f
645	9	2022-01-23 13:23:02.895746	\N	\N	f
645	4	2022-01-30 20:56:18.182952	\N	\N	f
645	5	2022-02-16 11:57:40.468458	\N	\N	f
645	3	2022-03-18 04:29:15.943092	\N	\N	f
646	7	2022-03-28 08:28:10.717468	\N	\N	f
646	11	2022-06-16 02:01:25.293864	\N	\N	f
647	1	2022-02-20 21:46:06.456451	\N	\N	f
647	3	2022-06-14 21:50:39.594012	\N	\N	f
647	10	2022-09-01 17:11:51.261452	\N	\N	f
648	11	2022-07-07 21:23:08.272821	\N	\N	f
648	8	2022-11-01 16:24:27.504323	\N	\N	f
648	3	2023-02-09 10:19:00.102035	\N	\N	f
649	10	2022-07-19 17:25:53.667962	\N	\N	f
649	11	2022-12-01 04:19:44.125872	\N	\N	f
649	3	2023-01-15 08:00:46.42057	\N	\N	f
650	2	2022-03-14 00:24:56.043363	\N	\N	f
650	8	2022-05-20 00:52:21.195415	\N	\N	f
651	10	2023-04-09 20:39:18.358409	\N	\N	f
651	4	2023-08-19 16:35:52.254521	\N	\N	f
651	1	2023-10-13 16:31:30.727077	\N	\N	f
652	8	2022-09-22 04:05:51.896925	\N	\N	f
653	6	2022-05-06 19:40:42.842994	\N	\N	f
653	3	2022-07-14 21:36:18.39096	\N	\N	f
653	4	2023-01-25 23:39:42.361798	\N	\N	f
654	3	2022-02-15 20:01:08.284532	\N	\N	f
654	6	2023-03-14 12:06:27.049562	\N	\N	f
655	4	2022-03-18 15:16:58.407609	\N	\N	f
655	11	2022-05-30 10:39:50.543938	\N	\N	f
656	8	2022-04-05 09:11:55.355146	\N	\N	f
656	10	2023-08-20 14:20:49.187556	\N	\N	f
656	7	2024-04-13 23:27:27.905787	\N	\N	f
657	9	2022-03-09 02:11:20.40629	\N	\N	f
657	8	2022-04-12 23:23:16.069605	\N	\N	f
658	10	2022-03-02 06:48:41.909073	\N	\N	f
659	8	2022-03-16 14:04:06.307781	\N	\N	f
659	1	2022-05-28 05:31:09.846797	\N	\N	f
660	7	2022-02-13 15:24:33.699324	\N	\N	f
660	1	2022-06-16 01:22:55.816503	\N	\N	f
661	1	2022-07-08 23:05:48.770599	\N	\N	f
661	7	2022-12-13 04:43:24.110613	\N	\N	f
662	10	2022-06-16 06:34:16.600864	\N	\N	f
662	9	2022-10-11 09:34:19.305736	\N	\N	f
662	11	2023-01-17 23:06:33.170574	\N	\N	f
663	8	2022-04-01 18:42:33.949933	\N	\N	f
663	2	2022-08-11 19:56:27.358068	\N	\N	f
663	6	2023-07-06 13:05:55.619233	\N	\N	f
663	1	2023-08-11 12:49:45.812046	\N	\N	f
664	8	2022-08-25 10:39:13.779182	\N	\N	f
664	10	2023-04-02 05:12:37.832734	\N	\N	f
664	1	2023-10-25 07:58:54.266642	\N	\N	f
665	7	2022-01-27 09:53:16.094465	\N	\N	f
665	3	2022-08-26 15:48:35.629986	\N	\N	f
666	10	2022-02-27 16:15:16.847271	\N	\N	f
666	5	2022-06-13 06:32:57.595706	\N	\N	f
666	3	2022-06-21 00:53:32.367371	\N	\N	f
666	11	2022-12-09 16:57:08.532818	\N	\N	f
667	7	2022-03-21 19:44:18.801095	\N	\N	f
667	2	2022-10-15 00:01:07.732315	\N	\N	f
668	4	2022-02-11 07:08:28.009514	\N	\N	f
668	3	2022-04-20 05:07:41.618971	\N	\N	f
669	6	2022-03-20 20:57:29.724185	\N	\N	f
669	7	2023-01-24 10:48:49.196457	\N	\N	f
670	2	2022-02-07 12:08:26.173368	\N	\N	f
670	3	2022-02-25 03:55:02.613381	\N	\N	f
670	7	2022-04-10 01:02:41.782643	\N	\N	f
670	10	2022-04-11 06:52:48.431934	\N	\N	f
671	6	2022-02-17 08:30:59.178274	\N	\N	f
672	8	2022-04-14 06:36:44.885436	\N	\N	f
672	4	2022-08-05 08:28:57.399165	\N	\N	f
673	2	2022-03-16 19:57:04.342234	\N	\N	f
673	5	2022-06-03 03:56:10.631668	\N	\N	f
673	9	2022-07-10 04:49:06.240661	\N	\N	f
674	4	2022-10-05 02:18:18.026606	\N	\N	f
674	3	2023-07-16 17:52:20.545769	\N	\N	f
675	6	2022-02-11 16:39:53.291339	\N	\N	f
675	10	2022-07-18 21:49:51.868029	\N	\N	f
675	5	2022-10-19 07:24:17.621891	\N	\N	f
676	8	2022-06-26 07:08:36.558533	\N	\N	f
676	11	2022-10-12 04:39:37.786128	\N	\N	f
676	6	2022-11-16 17:52:33.344571	\N	\N	f
677	1	2022-02-09 01:25:49.476111	\N	\N	f
677	3	2022-05-19 22:52:47.431809	\N	\N	f
678	5	2022-01-14 22:54:53.599171	\N	\N	f
678	9	2022-10-14 13:25:24.492145	\N	\N	f
678	10	2023-07-11 10:34:41.45476	\N	\N	f
679	5	2022-04-22 13:43:18.269791	\N	\N	f
679	9	2022-10-02 19:39:36.022279	\N	\N	f
679	2	2023-07-12 15:12:11.234746	\N	\N	f
680	8	2022-04-13 23:14:42.087341	\N	\N	f
680	3	2022-09-26 09:25:55.654399	\N	\N	f
681	1	2022-04-12 09:04:42.173795	\N	\N	f
681	2	2022-08-05 17:12:25.328504	\N	\N	f
682	9	2022-01-12 05:05:23.595525	\N	\N	f
682	8	2022-01-18 01:30:00.560969	\N	\N	f
682	1	2022-03-22 08:07:40.117967	\N	\N	f
683	6	2022-01-05 23:11:39.804243	\N	\N	f
683	7	2022-10-21 06:53:19.950596	\N	\N	f
684	6	2022-03-19 07:15:52.198784	\N	\N	f
684	8	2022-12-10 20:16:17.614241	\N	\N	f
685	5	2022-07-25 21:15:19.736162	\N	\N	f
685	1	2023-09-16 11:33:42.978065	\N	\N	f
686	7	2022-05-22 15:18:58.575914	\N	\N	f
686	8	2022-07-17 03:39:26.633726	\N	\N	f
687	4	2022-05-06 15:50:30.062501	\N	\N	f
687	5	2022-07-17 05:46:12.378872	\N	\N	f
687	1	2022-10-18 09:26:15.399533	\N	\N	f
688	10	2022-02-25 00:34:51.865674	\N	\N	f
688	11	2022-07-20 07:57:48.060952	\N	\N	f
689	9	2022-02-22 16:18:23.57171	\N	\N	f
689	2	2022-04-29 09:35:16.519095	\N	\N	f
689	6	2022-10-11 04:15:43.123379	\N	\N	f
690	1	2022-04-20 11:09:13.89105	\N	\N	f
690	2	2022-05-04 03:03:38.444461	\N	\N	f
691	1	2022-04-09 02:07:30.549821	\N	\N	f
691	7	2022-07-11 06:27:28.337705	\N	\N	f
691	2	2022-10-13 17:58:21.744617	\N	\N	f
692	10	2022-05-13 11:57:57.04589	\N	\N	f
692	1	2023-04-18 19:50:14.165605	\N	\N	f
693	11	2022-04-14 03:57:57.310073	\N	\N	f
693	10	2022-04-15 02:08:28.024064	\N	\N	f
693	6	2022-07-20 15:45:17.048972	\N	\N	f
693	3	2022-10-17 21:25:44.306016	\N	\N	f
694	8	2022-06-28 07:30:00.881894	\N	\N	f
694	10	2022-11-22 11:54:23.481786	\N	\N	f
695	4	2022-03-19 06:12:59.787615	\N	\N	f
695	3	2022-11-01 01:00:26.619734	\N	\N	f
695	5	2023-10-20 14:30:21.786037	\N	\N	f
696	1	2022-01-27 06:18:32.001824	\N	\N	f
696	5	2022-02-18 02:14:27.480683	\N	\N	f
696	7	2022-03-20 19:02:14.034777	\N	\N	f
697	3	2022-11-16 06:05:55.403668	\N	\N	f
697	7	2022-11-20 12:08:22.527644	\N	\N	f
698	10	2022-02-17 14:43:00.565502	\N	\N	f
699	3	2022-02-09 07:49:33.705256	\N	\N	f
699	5	2022-04-12 03:04:11.154949	\N	\N	f
700	10	2022-02-21 05:43:48.831343	\N	\N	f
700	3	2022-09-05 15:24:06.371982	\N	\N	f
700	1	2022-09-06 16:17:46.444273	\N	\N	f
701	3	2022-07-27 09:56:27.21514	\N	\N	f
701	8	2022-12-07 18:06:52.567068	\N	\N	f
702	4	2022-02-09 08:11:40.081689	\N	\N	f
702	10	2022-03-20 10:11:15.777763	\N	\N	f
702	9	2023-01-22 12:31:26.634374	\N	\N	f
703	5	2022-04-06 18:09:22.170076	\N	\N	f
703	4	2022-07-06 23:13:06.827314	\N	\N	f
703	7	2022-11-09 02:45:59.429532	\N	\N	f
704	2	2022-02-06 08:03:43.274624	\N	\N	f
704	3	2022-09-17 06:33:44.670355	\N	\N	f
705	8	2022-02-15 06:47:52.519826	\N	\N	f
705	7	2022-06-27 15:49:50.442422	\N	\N	f
706	11	2022-03-26 00:03:26.266528	\N	\N	f
706	3	2022-05-15 16:37:09.929335	\N	\N	f
707	2	2022-02-09 13:19:58.993349	\N	\N	f
707	8	2022-04-16 03:18:25.877928	\N	\N	f
707	3	2022-06-29 21:29:17.061515	\N	\N	f
708	8	2022-07-16 23:04:14.649046	\N	\N	f
708	11	2022-07-21 17:00:20.34576	\N	\N	f
709	1	2022-07-14 06:39:53.291609	\N	\N	f
709	4	2022-09-17 08:30:36.750353	\N	\N	f
710	11	2022-01-18 02:18:53.343565	\N	\N	f
710	7	2022-03-28 03:34:37.735846	\N	\N	f
711	2	2022-12-23 06:16:54.55892	\N	\N	f
711	11	2023-06-13 21:22:43.911608	\N	\N	f
711	5	2024-02-03 06:36:16.600424	\N	\N	f
712	10	2022-04-16 00:49:56.486538	\N	\N	f
712	2	2022-06-13 11:03:47.299579	\N	\N	f
712	9	2022-06-17 13:16:22.483602	\N	\N	f
713	5	2022-03-30 14:20:35.891547	\N	\N	f
713	8	2022-06-05 17:44:44.825745	\N	\N	f
713	6	2022-11-29 02:11:22.83499	\N	\N	f
714	3	2022-08-26 08:06:52.961296	\N	\N	f
714	10	2023-03-25 22:04:52.771688	\N	\N	f
714	4	2023-06-15 13:56:29.240656	\N	\N	f
715	8	2022-04-12 21:31:52.560873	\N	\N	f
715	5	2023-08-03 15:38:22.675428	\N	\N	f
716	5	2023-01-14 01:40:36.626179	\N	\N	f
717	6	2022-05-16 14:54:43.052393	\N	\N	f
717	3	2022-06-17 18:35:57.493693	\N	\N	f
717	2	2022-11-17 20:54:04.910977	\N	\N	f
717	9	2022-12-03 12:21:19.862348	\N	\N	f
718	5	2022-02-06 06:03:42.19792	\N	\N	f
718	11	2022-03-15 10:51:43.018374	\N	\N	f
718	3	2022-10-13 15:07:59.424749	\N	\N	f
718	4	2022-11-19 20:30:53.001756	\N	\N	f
719	11	2022-02-24 18:48:04.124841	\N	\N	f
719	5	2022-03-24 19:55:37.503509	\N	\N	f
719	8	2022-06-01 21:19:12.942339	\N	\N	f
720	8	2022-09-04 02:29:26.005176	\N	\N	f
720	2	2023-03-12 20:52:14.503844	\N	\N	f
720	5	2023-08-11 17:21:56.296774	\N	\N	f
721	9	2022-02-09 19:42:23.855808	\N	\N	f
721	10	2022-04-25 01:49:32.849058	\N	\N	f
721	7	2022-05-06 17:20:39.277374	\N	\N	f
722	7	2022-04-07 03:22:53.916966	\N	\N	f
722	5	2022-11-24 09:36:01.867416	\N	\N	f
723	2	2022-08-29 10:25:22.303909	\N	\N	f
723	4	2022-10-09 18:03:15.176731	\N	\N	f
724	5	2022-01-10 10:04:34.775712	\N	\N	f
724	11	2022-08-10 15:07:34.965137	\N	\N	f
725	5	2022-07-16 04:55:06.556916	\N	\N	f
725	2	2023-09-27 21:51:34.597663	\N	\N	f
726	1	2022-02-23 07:58:20.263234	\N	\N	f
726	4	2022-03-20 09:42:26.922122	\N	\N	f
727	5	2023-03-03 10:28:42.931637	\N	\N	f
727	11	2023-06-12 22:56:45.830066	\N	\N	f
727	2	2024-08-03 10:13:34.298388	\N	\N	f
728	1	2022-03-13 14:20:05.05403	\N	\N	f
728	7	2022-05-06 04:16:45.197508	\N	\N	f
728	5	2023-01-06 22:08:14.180926	\N	\N	f
729	2	2022-02-01 12:42:03.982062	\N	\N	f
729	4	2022-03-13 12:50:37.762355	\N	\N	f
729	10	2023-05-03 18:19:57.672633	\N	\N	f
730	4	2022-02-20 06:36:14.122546	\N	\N	f
730	8	2023-02-21 07:22:51.504846	\N	\N	f
731	7	2022-03-09 07:04:54.179212	\N	\N	f
731	2	2022-03-31 06:28:16.034279	\N	\N	f
732	4	2022-02-25 01:45:42.394478	\N	\N	f
732	9	2022-07-04 00:46:36.858547	\N	\N	f
732	8	2022-07-12 03:55:55.662206	\N	\N	f
733	4	2022-03-27 20:03:03.144746	\N	\N	f
733	5	2023-07-30 12:41:21.984005	\N	\N	f
733	3	2023-08-10 03:22:14.726528	\N	\N	f
733	10	2023-10-22 00:59:30.304141	\N	\N	f
734	9	2022-03-18 03:30:40.275823	\N	\N	f
734	5	2022-05-01 05:02:07.528743	\N	\N	f
734	3	2023-04-06 02:57:31.374201	\N	\N	f
735	1	2022-01-21 10:59:23.611392	\N	\N	f
735	8	2022-11-01 08:01:29.597907	\N	\N	f
735	7	2023-05-10 09:09:52.106302	\N	\N	f
736	9	2022-04-14 08:44:17.339874	\N	\N	f
736	3	2022-07-25 04:00:56.893765	\N	\N	f
737	10	2022-02-24 00:29:13.80585	\N	\N	f
737	8	2022-04-07 17:21:35.585455	\N	\N	f
738	1	2022-05-30 10:40:02.596484	\N	\N	f
738	7	2022-08-19 08:04:17.743585	\N	\N	f
738	4	2023-04-02 07:34:14.377909	\N	\N	f
739	7	2022-03-31 00:03:22.528939	\N	\N	f
739	4	2022-12-19 03:08:14.819577	\N	\N	f
739	9	2023-07-06 01:24:12.399656	\N	\N	f
740	5	2022-01-11 02:08:10.220266	\N	\N	f
740	7	2022-05-31 01:01:46.596677	\N	\N	f
741	1	2022-01-24 02:00:53.083178	\N	\N	f
741	7	2022-03-27 14:29:59.002632	\N	\N	f
742	2	2022-02-14 05:00:07.00115	\N	\N	f
742	10	2022-10-23 12:46:05.16923	\N	\N	f
743	7	2022-10-03 20:26:04.314396	\N	\N	f
743	3	2023-02-06 05:32:30.340211	\N	\N	f
743	11	2023-04-09 06:55:08.606769	\N	\N	f
744	9	2022-05-14 10:23:57.213026	\N	\N	f
744	2	2022-06-26 23:38:41.151371	\N	\N	f
745	9	2022-06-22 02:28:38.58769	\N	\N	f
745	8	2022-07-11 02:18:45.874875	\N	\N	f
746	6	2022-03-02 18:51:25.72499	\N	\N	f
746	4	2022-08-31 23:12:03.434111	\N	\N	f
747	1	2022-06-27 23:29:24.938336	\N	\N	f
747	4	2022-12-28 14:00:41.328557	\N	\N	f
748	3	2022-02-24 03:32:20.274481	\N	\N	f
748	7	2022-05-04 02:11:15.704513	\N	\N	f
749	6	2022-06-29 13:14:58.437591	\N	\N	f
749	10	2022-08-23 19:13:03.826915	\N	\N	f
750	5	2022-12-03 10:57:41.065075	\N	\N	f
750	7	2022-12-29 02:19:18.716116	\N	\N	f
750	11	2023-04-15 13:39:09.868649	\N	\N	f
751	4	2022-04-19 14:26:25.154065	\N	\N	f
751	5	2022-05-10 06:07:46.281041	\N	\N	f
752	6	2022-02-13 00:46:22.976437	\N	\N	f
752	4	2022-06-19 20:31:55.791104	\N	\N	f
752	11	2023-06-06 03:17:26.291873	\N	\N	f
753	9	2022-06-22 09:50:45.392441	\N	\N	f
753	5	2022-10-31 00:56:17.730859	\N	\N	f
753	1	2023-05-18 07:01:54.198124	\N	\N	f
754	1	2022-02-19 05:29:12.757508	\N	\N	f
754	9	2022-04-16 16:45:14.968236	\N	\N	f
754	6	2022-09-22 09:47:27.791989	\N	\N	f
755	8	2022-07-16 17:04:49.435918	\N	\N	f
755	10	2024-01-23 15:13:50.514571	\N	\N	f
755	3	2024-03-01 08:09:03.057461	\N	\N	f
755	7	2024-03-29 00:40:56.343158	\N	\N	f
756	10	2022-05-21 23:15:40.858854	\N	\N	f
756	9	2022-06-28 23:04:39.434133	\N	\N	f
756	3	2023-03-15 03:39:26.449052	\N	\N	f
757	3	2022-08-05 11:34:44.253258	\N	\N	f
757	1	2022-08-17 16:32:02.842034	\N	\N	f
757	9	2023-01-11 20:01:23.769345	\N	\N	f
758	8	2022-01-24 13:40:24.06452	\N	\N	f
758	7	2023-09-28 05:58:34.612991	\N	\N	f
758	9	2024-03-07 22:13:22.386149	\N	\N	f
759	7	2022-02-14 10:06:04.550096	\N	\N	f
759	2	2023-03-06 04:31:54.691076	\N	\N	f
760	6	2022-01-19 16:56:43.904312	\N	\N	f
760	11	2022-05-25 04:34:40.209624	\N	\N	f
761	9	2022-06-29 08:22:14.838637	\N	\N	f
761	6	2022-09-24 16:59:51.708897	\N	\N	f
761	1	2022-12-04 12:48:05.708786	\N	\N	f
762	10	2022-01-22 19:06:57.257136	\N	\N	f
763	3	2022-04-12 10:06:27.211418	\N	\N	f
763	11	2022-07-24 21:26:22.553111	\N	\N	f
763	8	2022-11-06 20:13:37.199673	\N	\N	f
763	10	2023-07-19 09:12:24.321453	\N	\N	f
764	4	2022-05-25 08:44:23.148881	\N	\N	f
764	10	2023-02-03 04:44:15.323944	\N	\N	f
765	8	2022-09-27 22:36:10.033049	\N	\N	f
765	7	2023-05-09 23:02:06.903254	\N	\N	f
766	8	2022-02-12 06:25:30.324486	\N	\N	f
766	1	2022-05-17 14:19:51.842437	\N	\N	f
767	7	2022-03-15 09:06:43.509678	\N	\N	f
767	1	2022-09-09 12:30:53.77943	\N	\N	f
767	9	2022-11-04 21:43:27.883299	\N	\N	f
768	3	2022-02-10 00:59:09.883805	\N	\N	f
768	9	2022-03-22 03:53:13.6388	\N	\N	f
768	1	2023-03-15 22:50:34.771426	\N	\N	f
769	1	2022-05-20 16:20:10.562155	\N	\N	f
769	2	2022-07-07 15:27:44.85766	\N	\N	f
769	8	2022-08-12 19:13:56.002048	\N	\N	f
770	2	2022-02-02 01:03:25.715775	\N	\N	f
770	9	2023-05-21 21:02:21.32762	\N	\N	f
770	4	2023-10-26 13:34:25.134382	\N	\N	f
771	2	2022-09-30 21:20:50.117844	\N	\N	f
771	6	2023-10-29 22:02:53.737675	\N	\N	f
771	4	2023-11-27 17:44:06.135299	\N	\N	f
771	7	2024-12-25 22:15:11.887651	\N	\N	f
772	2	2022-03-26 23:32:58.016284	\N	\N	f
772	9	2022-04-01 01:58:20.58639	\N	\N	f
772	10	2022-05-28 11:48:12.963686	\N	\N	f
773	11	2022-02-07 00:14:27.240806	\N	\N	f
773	8	2022-05-16 10:03:02.357283	\N	\N	f
773	1	2022-08-24 09:31:00.779427	\N	\N	f
774	6	2022-05-30 23:00:55.715154	\N	\N	f
774	1	2022-08-28 13:23:38.099945	\N	\N	f
774	7	2023-09-13 18:56:54.733722	\N	\N	f
775	10	2022-04-18 04:56:52.9759	\N	\N	f
776	11	2022-01-09 07:27:47.868242	\N	\N	f
776	7	2022-08-14 13:54:15.23269	\N	\N	f
777	4	2022-01-16 19:18:43.333593	\N	\N	f
777	6	2022-07-25 05:59:40.074339	\N	\N	f
777	9	2023-03-15 04:53:52.701948	\N	\N	f
778	11	2022-06-30 07:40:55.568576	\N	\N	f
779	10	2022-06-13 15:24:41.949193	\N	\N	f
779	1	2022-07-22 09:41:21.380937	\N	\N	f
780	9	2022-01-13 08:13:25.216888	\N	\N	f
780	8	2022-12-25 19:10:12.310816	\N	\N	f
780	5	2023-01-15 00:25:09.538194	\N	\N	f
780	2	2023-02-27 13:17:38.526425	\N	\N	f
781	9	2022-07-28 03:48:51.951805	\N	\N	f
781	4	2022-11-05 20:41:02.144026	\N	\N	f
781	8	2022-11-22 10:37:22.677606	\N	\N	f
782	3	2022-01-14 03:30:21.998623	\N	\N	f
782	7	2022-11-01 10:17:26.028804	\N	\N	f
783	11	2022-04-13 03:31:15.237191	\N	\N	f
783	10	2022-05-13 10:38:37.648914	\N	\N	f
783	5	2022-07-12 01:52:31.597329	\N	\N	f
783	1	2022-07-25 09:51:09.532062	\N	\N	f
784	6	2022-02-20 07:08:34.168694	\N	\N	f
784	5	2022-05-27 21:52:55.017931	\N	\N	f
784	4	2022-10-09 11:20:27.917541	\N	\N	f
785	8	2022-02-25 19:46:04.300356	\N	\N	f
785	5	2022-12-10 17:27:50.287353	\N	\N	f
786	9	2022-08-20 06:31:53.251578	\N	\N	f
786	1	2023-03-27 02:44:34.975611	\N	\N	f
787	10	2022-01-24 23:29:54.506086	\N	\N	f
787	8	2022-08-31 03:55:46.128239	\N	\N	f
787	1	2022-10-21 05:48:41.374556	\N	\N	f
788	11	2022-05-13 08:43:30.161274	\N	\N	f
788	2	2022-09-11 05:25:21.536728	\N	\N	f
788	10	2022-12-11 03:00:02.877209	\N	\N	f
789	9	2022-06-26 04:55:01.762597	\N	\N	f
789	3	2022-07-31 05:18:06.505846	\N	\N	f
789	10	2023-03-25 11:11:23.584934	\N	\N	f
790	9	2022-04-19 15:22:34.389688	\N	\N	f
790	5	2022-07-17 01:09:17.326683	\N	\N	f
791	7	2022-01-18 11:57:16.586705	\N	\N	f
791	3	2022-09-22 14:51:38.699535	\N	\N	f
791	4	2022-11-15 16:38:00.004333	\N	\N	f
792	8	2022-05-09 21:50:30.439349	\N	\N	f
792	7	2022-07-20 03:32:38.737828	\N	\N	f
793	11	2022-04-13 09:16:04.777892	\N	\N	f
793	7	2023-01-07 01:15:57.453811	\N	\N	f
793	3	2023-06-06 10:05:17.486096	\N	\N	f
794	2	2022-02-08 03:02:39.067084	\N	\N	f
794	6	2022-03-15 00:20:10.819257	\N	\N	f
795	3	2022-05-13 14:40:23.449212	\N	\N	f
795	10	2022-11-28 02:16:27.683686	\N	\N	f
795	7	2023-01-02 19:22:51.018712	\N	\N	f
796	11	2022-08-04 11:12:16.845437	\N	\N	f
797	6	2022-02-14 23:44:07.01287	\N	\N	f
797	10	2023-08-29 21:42:03.908571	\N	\N	f
798	3	2022-01-30 22:38:26.314672	\N	\N	f
799	3	2022-03-13 01:04:59.833155	\N	\N	f
799	7	2023-01-23 16:19:09.030714	\N	\N	f
799	8	2023-08-06 04:41:08.314463	\N	\N	f
800	10	2022-07-15 23:17:24.035753	\N	\N	f
800	2	2022-08-31 23:55:30.172617	\N	\N	f
800	7	2022-09-29 12:38:44.414412	\N	\N	f
800	3	2023-06-01 04:10:22.591307	\N	\N	f
801	10	2022-06-23 06:42:40.319841	\N	\N	f
801	6	2023-01-23 05:54:19.816247	\N	\N	f
802	10	2022-02-16 13:28:47.158212	\N	\N	f
802	3	2022-05-12 15:20:33.937124	\N	\N	f
802	7	2022-06-23 01:27:37.784148	\N	\N	f
803	2	2022-05-02 15:40:13.401405	\N	\N	f
803	4	2022-06-30 02:12:30.34637	\N	\N	f
804	5	2022-03-11 21:59:35.141197	\N	\N	f
804	4	2022-05-28 21:25:14.110813	\N	\N	f
804	7	2022-10-22 07:10:53.476896	\N	\N	f
805	9	2022-02-20 18:50:01.162748	\N	\N	f
805	7	2022-12-19 19:34:32.56581	\N	\N	f
805	3	2023-02-26 02:42:57.076388	\N	\N	f
806	10	2022-01-29 15:52:09.386275	\N	\N	f
806	1	2022-07-16 19:48:47.745786	\N	\N	f
807	3	2022-02-10 10:32:57.150125	\N	\N	f
807	1	2022-08-21 01:36:45.675325	\N	\N	f
808	3	2022-02-06 19:38:47.262957	\N	\N	f
808	4	2022-05-25 00:30:51.05333	\N	\N	f
809	8	2022-05-13 05:16:00.126101	\N	\N	f
810	8	2022-01-12 17:03:30.76874	\N	\N	f
810	6	2023-03-08 17:57:48.218713	\N	\N	f
811	4	2022-01-25 00:10:37.56274	\N	\N	f
812	1	2022-08-07 13:15:44.658637	\N	\N	f
812	3	2022-09-05 15:04:19.040773	\N	\N	f
813	3	2022-02-10 17:13:53.648822	\N	\N	f
813	1	2022-07-20 00:24:06.442363	\N	\N	f
813	10	2023-11-08 22:18:47.650521	\N	\N	f
814	9	2022-01-02 12:10:41.650967	\N	\N	f
814	6	2022-06-09 09:56:34.819297	\N	\N	f
815	5	2022-01-17 04:00:51.992096	\N	\N	f
815	9	2022-02-14 03:37:23.012485	\N	\N	f
816	1	2022-05-07 18:28:28.74587	\N	\N	f
816	11	2022-05-26 08:49:53.326616	\N	\N	f
816	9	2022-07-26 16:55:34.842164	\N	\N	f
817	6	2022-05-15 20:36:12.709978	\N	\N	f
817	3	2022-11-19 12:07:14.474205	\N	\N	f
817	5	2023-02-06 04:02:16.428281	\N	\N	f
818	7	2022-08-12 16:52:59.713946	\N	\N	f
818	6	2023-01-07 12:38:30.968043	\N	\N	f
818	3	2023-05-12 13:52:47.484019	\N	\N	f
819	6	2022-09-13 18:34:16.78044	\N	\N	f
819	4	2022-10-23 20:06:22.757192	\N	\N	f
819	2	2023-03-04 12:43:29.108609	\N	\N	f
819	5	2023-04-16 19:07:23.826185	\N	\N	f
820	10	2022-07-18 11:25:03.867212	\N	\N	f
820	1	2022-11-01 11:39:16.435472	\N	\N	f
820	8	2022-11-13 21:25:02.550824	\N	\N	f
821	6	2022-06-27 18:00:54.450337	\N	\N	f
821	10	2022-09-19 18:04:47.4447	\N	\N	f
821	9	2023-04-27 05:32:36.294039	\N	\N	f
822	3	2022-09-30 11:36:36.860157	\N	\N	f
822	4	2023-04-08 21:51:02.067968	\N	\N	f
822	11	2023-05-21 15:29:59.504811	\N	\N	f
823	4	2022-01-16 00:35:32.963924	\N	\N	f
823	6	2022-05-28 11:19:41.599785	\N	\N	f
823	3	2023-03-09 16:49:57.864754	\N	\N	f
824	9	2022-06-16 06:53:58.580303	\N	\N	f
824	10	2022-06-28 10:56:39.610924	\N	\N	f
825	6	2022-02-13 04:30:30.670904	\N	\N	f
825	10	2022-02-22 14:08:53.592925	\N	\N	f
825	7	2022-04-25 16:38:40.513595	\N	\N	f
825	4	2022-11-29 21:31:06.435104	\N	\N	f
826	3	2023-01-15 03:50:41.89508	\N	\N	f
827	1	2022-03-02 19:34:55.851384	\N	\N	f
827	2	2022-09-06 17:17:47.336671	\N	\N	f
828	9	2022-04-06 15:01:26.956823	\N	\N	f
828	10	2022-09-05 16:15:17.617201	\N	\N	f
829	11	2022-04-25 12:31:58.09443	\N	\N	f
829	4	2022-05-02 07:00:18.877021	\N	\N	f
829	3	2022-05-24 06:20:51.131403	\N	\N	f
829	8	2023-03-29 03:17:51.427149	\N	\N	f
830	6	2022-03-31 06:57:31.357856	\N	\N	f
831	9	2022-07-04 05:37:36.180719	\N	\N	f
832	6	2022-04-23 07:51:18.635376	\N	\N	f
832	4	2023-05-28 03:15:00.943894	\N	\N	f
832	1	2023-09-28 22:29:49.015588	\N	\N	f
833	11	2022-05-02 01:15:08.372593	\N	\N	f
833	4	2022-06-28 00:34:45.654439	\N	\N	f
833	10	2022-07-26 16:50:32.088396	\N	\N	f
834	1	2022-04-02 16:29:31.63338	\N	\N	f
834	6	2022-06-08 05:37:41.524707	\N	\N	f
834	8	2022-11-11 07:48:56.56848	\N	\N	f
835	5	2022-01-05 16:29:16.892061	\N	\N	f
835	3	2023-10-04 13:40:28.573714	\N	\N	f
836	3	2022-01-17 12:28:38.997178	\N	\N	f
836	11	2022-01-28 08:59:07.9066	\N	\N	f
836	4	2022-03-31 16:46:57.346619	\N	\N	f
836	5	2022-04-16 02:11:13.211151	\N	\N	f
837	11	2022-01-23 06:00:48.665742	\N	\N	f
837	4	2022-01-27 02:10:53.678013	\N	\N	f
838	9	2022-05-18 00:00:57.973948	\N	\N	f
838	3	2023-11-21 18:20:40.834487	\N	\N	f
839	3	2022-05-02 05:29:51.569959	\N	\N	f
839	4	2022-07-12 16:55:34.452476	\N	\N	f
839	11	2022-10-06 17:18:31.382895	\N	\N	f
840	1	2022-06-03 08:24:05.555763	\N	\N	f
840	6	2023-08-24 08:12:19.004371	\N	\N	f
841	1	2022-08-23 03:04:53.209671	\N	\N	f
841	2	2023-02-08 10:39:38.921657	\N	\N	f
842	9	2022-09-09 02:50:24.779733	\N	\N	f
842	11	2022-10-13 16:37:24.784212	\N	\N	f
842	7	2023-06-04 03:39:11.769533	\N	\N	f
843	9	2022-05-03 04:48:27.994576	\N	\N	f
844	8	2022-02-03 07:49:53.626959	\N	\N	f
844	2	2022-02-18 10:37:26.490374	\N	\N	f
845	7	2022-07-18 06:55:29.540188	\N	\N	f
845	1	2023-03-18 17:58:30.946867	\N	\N	f
845	11	2023-08-16 18:38:30.915901	\N	\N	f
846	11	2022-05-12 23:02:01.284459	\N	\N	f
846	2	2023-03-31 04:42:23.17336	\N	\N	f
847	9	2022-01-12 19:14:12.950883	\N	\N	f
847	4	2022-03-26 11:25:56.068728	\N	\N	f
848	11	2022-06-08 21:56:13.05536	\N	\N	f
848	4	2022-06-25 03:53:22.083514	\N	\N	f
848	7	2022-07-07 01:15:19.748211	\N	\N	f
849	11	2022-04-15 19:24:07.759349	\N	\N	f
849	10	2022-08-19 22:33:11.243183	\N	\N	f
850	5	2022-03-13 01:39:43.883319	\N	\N	f
850	6	2022-07-15 02:30:58.400314	\N	\N	f
850	7	2022-09-28 16:23:24.453726	\N	\N	f
850	9	2022-12-20 20:22:48.031488	\N	\N	f
851	5	2022-07-11 10:54:05.939232	\N	\N	f
851	11	2022-07-14 19:28:48.086962	\N	\N	f
852	6	2022-09-15 11:05:00.285296	\N	\N	f
852	2	2022-09-16 12:42:28.247017	\N	\N	f
852	5	2023-02-27 14:25:42.675366	\N	\N	f
853	11	2022-06-25 08:26:15.089472	\N	\N	f
853	4	2022-06-28 02:32:35.36852	\N	\N	f
853	5	2023-10-17 08:42:01.303679	\N	\N	f
854	10	2023-05-24 07:59:06.833988	\N	\N	f
854	4	2023-07-26 20:53:51.663775	\N	\N	f
854	1	2023-08-08 11:02:44.610303	\N	\N	f
854	8	2023-09-23 16:10:04.977345	\N	\N	f
855	3	2022-05-09 20:22:49.96862	\N	\N	f
855	1	2022-09-07 18:04:55.51818	\N	\N	f
855	11	2023-03-12 05:59:40.712899	\N	\N	f
856	11	2022-10-11 06:54:50.974722	\N	\N	f
856	4	2023-11-30 12:43:13.427681	\N	\N	f
856	2	2024-03-03 13:37:34.394231	\N	\N	f
857	7	2022-08-24 03:11:24.55417	\N	\N	f
857	2	2023-10-08 18:19:58.089794	\N	\N	f
857	8	2023-10-21 07:26:24.271088	\N	\N	f
858	11	2022-06-07 21:39:04.648178	\N	\N	f
858	2	2022-06-26 15:10:14.961106	\N	\N	f
859	8	2023-02-27 00:59:33.217416	\N	\N	f
859	3	2023-05-30 13:51:11.319282	\N	\N	f
860	3	2022-07-26 20:23:02.538972	\N	\N	f
860	1	2023-07-16 05:06:13.451449	\N	\N	f
861	7	2022-02-17 04:12:58.717098	\N	\N	f
861	9	2022-04-06 00:22:09.919803	\N	\N	f
862	9	2022-10-09 16:09:49.403179	\N	\N	f
862	11	2023-06-19 23:37:41.692131	\N	\N	f
863	11	2022-01-12 19:14:26.590848	\N	\N	f
863	10	2022-07-06 15:40:30.385935	\N	\N	f
863	7	2023-03-29 03:37:55.795377	\N	\N	f
864	3	2022-10-02 11:01:06.881854	\N	\N	f
864	10	2022-12-23 03:54:15.993244	\N	\N	f
864	2	2023-03-02 15:27:15.701333	\N	\N	f
865	4	2022-09-19 11:03:18.798069	\N	\N	f
865	8	2022-12-26 00:06:29.19816	\N	\N	f
866	11	2022-04-03 11:45:33.801832	\N	\N	f
866	5	2022-04-04 22:57:10.026485	\N	\N	f
866	9	2022-06-16 12:35:11.482472	\N	\N	f
866	2	2022-08-15 10:01:23.977433	\N	\N	f
867	5	2022-01-13 06:58:12.64425	\N	\N	f
867	9	2022-11-05 04:15:10.851523	\N	\N	f
868	6	2022-06-08 01:57:49.656106	\N	\N	f
868	1	2022-10-26 05:03:54.783567	\N	\N	f
869	10	2022-05-18 06:48:14.269461	\N	\N	f
869	4	2022-11-06 18:33:51.6625	\N	\N	f
870	10	2022-01-22 21:35:27.737018	\N	\N	f
870	8	2022-07-04 05:38:58.535342	\N	\N	f
871	5	2022-11-23 07:58:32.585964	\N	\N	f
871	4	2023-01-11 12:49:35.0831	\N	\N	f
872	3	2022-05-24 13:54:55.746989	\N	\N	f
872	5	2022-09-17 04:30:37.464905	\N	\N	f
873	10	2022-01-25 20:33:09.865999	\N	\N	f
873	5	2022-07-16 13:50:45.431698	\N	\N	f
873	2	2022-07-22 17:46:21.72941	\N	\N	f
873	11	2023-02-11 01:33:25.951157	\N	\N	f
874	5	2022-12-25 21:06:49.431082	\N	\N	f
874	9	2023-02-01 22:15:33.677893	\N	\N	f
874	3	2023-07-31 15:27:50.330308	\N	\N	f
875	6	2022-01-23 07:04:10.502363	\N	\N	f
876	6	2022-04-21 16:05:51.650417	\N	\N	f
876	9	2023-01-13 10:19:17.547975	\N	\N	f
877	8	2022-01-08 17:43:40.495926	\N	\N	f
877	5	2023-08-10 18:55:55.47149	\N	\N	f
878	6	2022-03-31 14:15:24.106852	\N	\N	f
878	1	2022-05-21 12:21:05.693256	\N	\N	f
879	3	2022-05-24 00:12:48.520234	\N	\N	f
879	8	2023-06-10 19:25:56.460809	\N	\N	f
880	10	2022-09-23 10:48:49.865948	\N	\N	f
881	4	2022-02-18 01:12:31.479164	\N	\N	f
881	11	2022-08-22 18:25:50.133209	\N	\N	f
882	7	2022-03-11 20:08:32.060871	\N	\N	f
882	11	2022-06-28 03:05:48.773647	\N	\N	f
882	1	2022-11-19 01:36:04.722012	\N	\N	f
883	6	2022-07-16 12:51:09.741592	\N	\N	f
883	9	2022-12-31 15:45:58.558574	\N	\N	f
884	11	2022-05-01 00:27:20.818489	\N	\N	f
884	8	2022-12-31 06:18:26.155594	\N	\N	f
885	7	2023-02-22 11:19:41.605976	\N	\N	f
885	2	2023-05-07 11:33:24.59716	\N	\N	f
885	11	2023-07-23 17:29:37.043683	\N	\N	f
886	11	2022-07-31 03:26:47.694828	\N	\N	f
886	4	2022-08-01 09:29:17.088889	\N	\N	f
886	9	2023-01-18 01:19:39.998104	\N	\N	f
886	7	2023-02-11 09:27:23.185566	\N	\N	f
887	4	2022-05-22 21:35:05.595736	\N	\N	f
887	11	2022-08-05 20:52:30.541325	\N	\N	f
887	6	2022-08-30 06:30:32.364574	\N	\N	f
887	8	2022-11-03 10:27:53.96107	\N	\N	f
888	7	2022-09-22 12:38:58.736339	\N	\N	f
888	9	2023-01-09 07:29:59.657383	\N	\N	f
889	6	2022-04-17 08:17:17.497838	\N	\N	f
889	2	2022-07-05 12:58:52.180818	\N	\N	f
890	2	2023-08-04 04:24:52.369009	\N	\N	f
890	9	2023-10-28 18:57:27.724532	\N	\N	f
891	6	2022-04-16 21:41:27.626991	\N	\N	f
891	7	2023-03-03 03:13:51.164577	\N	\N	f
892	3	2022-01-16 14:22:38.422626	\N	\N	f
892	2	2022-03-06 22:03:05.011179	\N	\N	f
892	7	2022-06-19 16:03:43.15753	\N	\N	f
893	9	2022-04-06 21:47:01.770582	\N	\N	f
893	7	2022-06-29 11:00:52.878906	\N	\N	f
893	3	2022-11-25 09:30:13.344606	\N	\N	f
894	5	2022-01-05 02:39:37.167819	\N	\N	f
894	3	2022-01-18 00:47:18.847071	\N	\N	f
894	1	2023-01-15 21:05:34.102071	\N	\N	f
895	1	2022-02-20 19:29:18.744991	\N	\N	f
895	9	2022-04-18 16:34:19.333382	\N	\N	f
896	5	2022-03-15 05:21:45.587066	\N	\N	f
896	4	2022-08-14 12:28:23.297652	\N	\N	f
897	3	2022-01-03 07:59:11.884007	\N	\N	f
897	7	2023-06-01 00:36:21.4192	\N	\N	f
898	5	2023-04-26 18:39:17.506619	\N	\N	f
899	5	2022-06-10 06:06:03.467819	\N	\N	f
899	2	2023-03-26 22:38:02.548364	\N	\N	f
899	6	2023-05-22 08:02:03.684365	\N	\N	f
900	5	2022-01-17 21:15:09.294183	\N	\N	f
900	4	2022-09-26 21:14:07.474736	\N	\N	f
901	2	2022-04-14 04:28:12.032417	\N	\N	f
901	4	2022-09-26 04:34:10.108706	\N	\N	f
901	8	2022-10-24 15:03:04.837559	\N	\N	f
902	6	2023-01-30 13:54:52.751293	\N	\N	f
902	9	2023-05-22 06:42:34.050299	\N	\N	f
902	8	2023-07-09 16:47:01.459561	\N	\N	f
902	11	2023-07-16 18:55:27.343962	\N	\N	f
903	11	2023-06-27 04:27:46.016283	\N	\N	f
903	10	2023-07-15 21:44:57.704426	\N	\N	f
903	6	2023-11-23 23:13:26.448957	\N	\N	f
904	11	2022-04-09 21:36:01.743936	\N	\N	f
905	6	2022-12-01 05:47:50.763413	\N	\N	f
905	7	2023-04-06 19:32:34.243147	\N	\N	f
905	2	2023-07-20 23:23:34.74847	\N	\N	f
905	8	2023-08-17 22:23:54.458086	\N	\N	f
906	2	2022-03-20 21:10:45.969126	\N	\N	f
906	6	2022-04-05 01:21:15.088218	\N	\N	f
906	1	2022-05-28 13:16:36.863296	\N	\N	f
906	3	2022-08-01 03:23:41.535548	\N	\N	f
907	6	2022-01-19 22:10:16.954485	\N	\N	f
908	4	2022-04-10 09:56:58.822799	\N	\N	f
908	1	2023-05-23 19:59:19.540741	\N	\N	f
908	11	2023-08-03 23:51:14.504809	\N	\N	f
909	2	2022-06-11 09:05:07.962165	\N	\N	f
909	3	2022-12-01 16:10:02.018556	\N	\N	f
909	7	2023-03-04 08:23:38.848374	\N	\N	f
910	7	2022-04-11 19:04:46.060135	\N	\N	f
910	1	2022-09-30 22:31:35.332977	\N	\N	f
911	6	2022-01-12 19:23:07.929419	\N	\N	f
911	2	2022-08-13 22:45:45.44044	\N	\N	f
912	4	2022-02-22 12:21:05.986217	\N	\N	f
912	11	2022-07-18 23:54:50.868809	\N	\N	f
912	5	2022-10-26 01:49:26.316546	\N	\N	f
913	2	2022-05-02 11:35:19.477122	\N	\N	f
913	11	2023-06-16 11:31:29.530403	\N	\N	f
914	8	2022-01-26 23:47:11.107251	\N	\N	f
914	7	2022-12-31 13:07:35.899618	\N	\N	f
914	3	2023-02-06 18:17:11.889983	\N	\N	f
914	6	2023-02-28 10:03:15.618784	\N	\N	f
915	4	2022-02-10 22:03:26.399102	\N	\N	f
915	10	2022-08-20 12:51:01.533954	\N	\N	f
916	9	2022-02-14 05:19:19.29032	\N	\N	f
916	5	2022-04-05 22:57:12.13232	\N	\N	f
917	9	2022-03-14 14:17:17.269638	\N	\N	f
917	11	2022-04-03 02:52:50.984599	\N	\N	f
918	6	2022-03-06 01:32:04.007068	\N	\N	f
918	8	2022-10-25 11:27:30.501227	\N	\N	f
918	4	2023-03-19 00:38:11.651263	\N	\N	f
919	8	2022-09-30 10:54:20.927175	\N	\N	f
919	11	2022-10-04 01:22:59.343878	\N	\N	f
919	9	2022-10-16 17:00:38.671451	\N	\N	f
920	6	2022-03-26 08:32:37.523285	\N	\N	f
920	9	2022-09-14 01:50:17.377225	\N	\N	f
920	5	2022-12-14 14:29:40.969844	\N	\N	f
920	10	2023-06-26 02:42:01.859207	\N	\N	f
921	11	2022-03-08 00:35:59.322054	\N	\N	f
921	8	2022-08-26 13:47:30.299672	\N	\N	f
921	2	2022-08-26 21:30:57.642362	\N	\N	f
922	3	2022-02-09 07:39:52.211876	\N	\N	f
922	8	2023-06-17 17:53:28.382073	\N	\N	f
923	11	2022-08-25 05:37:34.68974	\N	\N	f
923	7	2023-01-01 02:39:14.303068	\N	\N	f
924	9	2022-01-31 03:32:40.778224	\N	\N	f
924	1	2022-02-06 15:07:21.155014	\N	\N	f
924	8	2022-03-07 06:33:28.282247	\N	\N	f
925	3	2022-02-15 20:51:04.490892	\N	\N	f
925	8	2022-03-12 16:49:22.398672	\N	\N	f
926	6	2022-03-15 01:53:10.782106	\N	\N	f
926	11	2022-11-19 00:53:23.950955	\N	\N	f
926	5	2023-01-20 09:20:06.958479	\N	\N	f
927	9	2022-01-05 16:41:58.863813	\N	\N	f
927	3	2022-06-12 08:11:55.505967	\N	\N	f
927	1	2023-04-03 20:14:02.708449	\N	\N	f
928	3	2022-09-09 20:04:08.409001	\N	\N	f
928	7	2022-12-21 05:27:52.431694	\N	\N	f
928	2	2023-01-13 11:33:06.675935	\N	\N	f
929	7	2022-04-26 02:16:38.9458	\N	\N	f
929	2	2023-04-03 13:20:45.8292	\N	\N	f
930	9	2022-12-18 17:54:23.250768	\N	\N	f
930	1	2023-02-11 13:24:56.06224	\N	\N	f
930	10	2023-09-04 16:00:03.229925	\N	\N	f
931	5	2022-01-12 04:21:10.974002	\N	\N	f
931	8	2022-03-17 14:44:32.173649	\N	\N	f
931	6	2022-07-07 10:19:44.686671	\N	\N	f
932	4	2022-03-06 22:03:20.853786	\N	\N	f
932	5	2022-03-22 01:14:31.343715	\N	\N	f
933	5	2022-01-13 20:13:31.410514	\N	\N	f
933	1	2022-04-05 21:10:51.704854	\N	\N	f
933	9	2022-04-16 20:00:44.721744	\N	\N	f
934	3	2022-05-27 07:39:35.156178	\N	\N	f
934	5	2023-06-29 04:51:41.109431	\N	\N	f
935	10	2022-01-19 11:11:39.782306	\N	\N	f
935	2	2022-02-01 00:34:24.069809	\N	\N	f
935	1	2022-11-17 12:35:46.558866	\N	\N	f
936	3	2022-10-10 00:23:06.938598	\N	\N	f
936	8	2023-07-02 12:22:35.347276	\N	\N	f
936	5	2023-10-27 04:17:46.457581	\N	\N	f
937	6	2022-08-13 08:44:37.554561	\N	\N	f
937	10	2024-01-05 08:32:50.319345	\N	\N	f
938	6	2023-03-26 11:08:41.419626	\N	\N	f
938	9	2023-05-26 02:15:33.488097	\N	\N	f
939	11	2022-07-26 00:27:24.809562	\N	\N	f
939	10	2022-09-02 19:32:11.968045	\N	\N	f
940	1	2022-12-08 02:45:14.28548	\N	\N	f
940	2	2023-01-17 15:01:37.691389	\N	\N	f
941	8	2022-02-07 18:28:47.615081	\N	\N	f
941	11	2022-07-12 01:44:31.018525	\N	\N	f
942	6	2022-02-07 11:02:34.26232	\N	\N	f
942	11	2022-09-01 13:13:08.856639	\N	\N	f
943	3	2022-01-05 14:21:00.97768	\N	\N	f
943	8	2022-03-31 04:47:31.997546	\N	\N	f
944	8	2022-04-16 02:08:42.090592	\N	\N	f
944	11	2022-11-01 14:51:44.621795	\N	\N	f
944	3	2022-12-22 05:50:36.032624	\N	\N	f
944	5	2024-02-20 22:52:08.399057	\N	\N	f
945	5	2022-01-01 04:10:18.632721	\N	\N	f
945	8	2022-03-01 06:57:09.765504	\N	\N	f
946	5	2022-04-25 09:48:55.234651	\N	\N	f
946	1	2022-08-17 15:03:46.55894	\N	\N	f
946	8	2024-02-11 09:59:17.516474	\N	\N	f
947	9	2022-01-10 00:47:37.867842	\N	\N	f
947	7	2022-06-17 17:28:00.074252	\N	\N	f
947	6	2022-07-25 23:52:46.027386	\N	\N	f
947	1	2022-10-31 18:21:00.444514	\N	\N	f
948	3	2022-07-17 04:30:53.674667	\N	\N	f
948	9	2022-09-07 09:35:18.312067	\N	\N	f
948	7	2022-12-26 10:42:21.53559	\N	\N	f
949	5	2022-01-16 02:45:04.068861	\N	\N	f
950	6	2022-08-07 19:43:06.250747	\N	\N	f
950	10	2022-11-26 09:37:27.553797	\N	\N	f
950	11	2022-12-02 15:01:53.703428	\N	\N	f
951	7	2022-03-05 01:47:12.644166	\N	\N	f
951	6	2022-05-16 14:49:04.03371	\N	\N	f
951	1	2022-10-04 23:34:28.030144	\N	\N	f
952	6	2022-02-22 12:24:04.34591	\N	\N	f
952	1	2022-11-17 01:47:06.934994	\N	\N	f
953	5	2022-05-16 08:46:36.137093	\N	\N	f
953	8	2022-05-22 16:13:06.878913	\N	\N	f
954	7	2022-07-06 14:21:35.701183	\N	\N	f
954	3	2023-04-06 00:46:41.303955	\N	\N	f
954	4	2023-05-30 07:40:39.712587	\N	\N	f
954	8	2023-06-08 20:38:22.14717	\N	\N	f
955	1	2022-05-03 13:51:10.586118	\N	\N	f
955	11	2022-10-14 09:14:03.603226	\N	\N	f
955	2	2022-10-14 17:43:20.627942	\N	\N	f
955	9	2023-03-03 18:10:23.946646	\N	\N	f
956	9	2022-08-05 17:08:15.839283	\N	\N	f
956	8	2023-05-15 21:39:55.025665	\N	\N	f
956	4	2024-02-21 19:54:47.762777	\N	\N	f
957	7	2022-01-22 13:11:50.417064	\N	\N	f
958	7	2022-02-03 15:43:30.202382	\N	\N	f
958	4	2022-03-14 21:36:39.635437	\N	\N	f
958	5	2022-11-15 04:09:09.169546	\N	\N	f
959	9	2022-04-25 23:59:40.546376	\N	\N	f
959	10	2022-05-19 12:40:07.608497	\N	\N	f
959	1	2022-06-10 14:33:03.61466	\N	\N	f
960	9	2022-02-07 16:25:15.492164	\N	\N	f
960	2	2023-06-18 23:17:18.724082	\N	\N	f
960	7	2023-07-14 01:08:57.521549	\N	\N	f
961	5	2022-02-05 02:56:08.929284	\N	\N	f
961	9	2022-05-30 19:10:20.580918	\N	\N	f
962	3	2022-02-05 10:05:48.387474	\N	\N	f
962	11	2022-04-05 10:27:28.779635	\N	\N	f
962	4	2022-05-14 21:48:13.826373	\N	\N	f
962	9	2022-06-05 00:31:33.813187	\N	\N	f
963	2	2022-04-06 16:54:06.702287	\N	\N	f
963	7	2022-09-30 11:54:45.58325	\N	\N	f
964	10	2022-04-26 15:21:01.143533	\N	\N	f
964	1	2022-10-31 23:37:03.197987	\N	\N	f
964	11	2023-11-27 12:40:09.974401	\N	\N	f
965	2	2022-02-18 05:01:13.637264	\N	\N	f
966	7	2022-01-04 09:43:44.526626	\N	\N	f
966	1	2022-05-03 03:00:41.513618	\N	\N	f
966	10	2022-09-02 20:54:04.956222	\N	\N	f
967	9	2022-11-24 14:12:41.648282	\N	\N	f
967	5	2023-11-01 17:36:20.647379	\N	\N	f
968	9	2022-04-10 19:18:50.972698	\N	\N	f
968	6	2022-04-23 03:13:35.81124	\N	\N	f
968	4	2022-05-10 15:02:16.996055	\N	\N	f
969	11	2022-08-10 21:48:02.9065	\N	\N	f
969	4	2023-03-18 03:47:16.732517	\N	\N	f
969	1	2023-10-28 09:09:41.253135	\N	\N	f
970	9	2022-02-28 05:28:00.616228	\N	\N	f
970	4	2022-06-13 01:50:09.970866	\N	\N	f
970	6	2023-07-26 07:23:27.33726	\N	\N	f
971	6	2022-01-13 10:18:03.626892	\N	\N	f
971	7	2022-02-14 03:44:12.081234	\N	\N	f
972	9	2022-03-31 02:30:40.679224	\N	\N	f
972	2	2022-03-31 07:13:27.273126	\N	\N	f
973	1	2022-01-21 14:19:27.303036	\N	\N	f
973	7	2022-04-20 05:16:35.570263	\N	\N	f
973	4	2022-08-09 13:10:58.075456	\N	\N	f
974	6	2022-01-18 16:17:31.834204	\N	\N	f
974	2	2022-06-06 04:16:42.529242	\N	\N	f
975	7	2022-01-14 03:24:02.118088	\N	\N	f
975	3	2022-10-06 17:31:54.81942	\N	\N	f
976	2	2022-11-27 12:40:24.137385	\N	\N	f
976	5	2023-01-20 15:36:04.993263	\N	\N	f
976	6	2023-02-28 07:16:03.688103	\N	\N	f
977	11	2022-05-10 11:10:50.623117	\N	\N	f
977	6	2022-06-28 08:07:57.183766	\N	\N	f
977	5	2023-01-19 22:36:00.491811	\N	\N	f
978	6	2022-02-12 07:19:47.977154	\N	\N	f
978	9	2022-09-21 17:58:19.272341	\N	\N	f
979	7	2022-08-08 23:21:17.391732	\N	\N	f
979	6	2022-08-24 13:03:25.305596	\N	\N	f
979	8	2023-12-11 02:25:00.072173	\N	\N	f
980	7	2022-03-28 07:26:02.853103	\N	\N	f
980	9	2022-09-21 22:43:43.507783	\N	\N	f
981	1	2022-03-22 22:45:12.86519	\N	\N	f
981	5	2023-02-13 17:56:30.293537	\N	\N	f
981	11	2023-05-23 20:45:51.376251	\N	\N	f
982	10	2022-05-08 17:30:45.750849	\N	\N	f
982	7	2023-11-23 23:00:00.494186	\N	\N	f
983	9	2022-07-22 01:24:07.089978	\N	\N	f
983	4	2022-11-09 20:24:24.852395	\N	\N	f
984	8	2022-06-10 15:00:46.25564	\N	\N	f
984	4	2022-09-11 18:00:59.282286	\N	\N	f
985	7	2022-04-03 07:06:09.97028	\N	\N	f
985	11	2022-08-02 03:21:13.456589	\N	\N	f
986	6	2022-12-13 18:20:29.670432	\N	\N	f
986	8	2023-02-18 01:12:42.880017	\N	\N	f
987	6	2022-04-25 02:04:39.897284	\N	\N	f
987	8	2022-12-08 21:54:48.28476	\N	\N	f
987	11	2022-12-15 19:07:57.106296	\N	\N	f
988	3	2022-02-09 23:54:06.965658	\N	\N	f
989	5	2022-07-29 02:23:47.179126	\N	\N	f
989	8	2022-08-13 20:58:54.719882	\N	\N	f
990	6	2022-05-15 10:05:25.525021	\N	\N	f
990	9	2022-06-24 13:54:14.25375	\N	\N	f
990	2	2023-03-15 14:43:16.099173	\N	\N	f
991	2	2022-07-05 11:00:38.350668	\N	\N	f
991	3	2022-07-15 07:43:41.00043	\N	\N	f
992	7	2022-04-01 10:58:38.348342	\N	\N	f
992	8	2022-05-20 11:20:43.750179	\N	\N	f
992	11	2022-09-06 16:09:34.882118	\N	\N	f
993	10	2022-05-18 00:40:28.792749	\N	\N	f
993	3	2023-01-26 23:52:14.993636	\N	\N	f
994	2	2022-01-08 23:02:19.29263	\N	\N	f
994	4	2023-04-21 08:58:52.81632	\N	\N	f
995	4	2022-01-09 13:07:14.314572	\N	\N	f
995	5	2023-01-20 13:20:06.796952	\N	\N	f
995	9	2023-05-11 14:10:58.681003	\N	\N	f
996	8	2022-03-13 20:32:33.813447	\N	\N	f
996	3	2022-07-11 02:04:17.950495	\N	\N	f
996	6	2022-08-16 15:26:46.81209	\N	\N	f
997	7	2022-07-20 07:44:39.060892	\N	\N	f
997	1	2022-09-14 22:22:17.717467	\N	\N	f
997	9	2023-03-30 06:09:53.692202	\N	\N	f
997	8	2023-06-27 03:56:03.295334	\N	\N	f
998	9	2022-07-13 07:19:59.986387	\N	\N	f
999	7	2022-01-10 09:06:55.109039	\N	\N	f
999	9	2022-02-21 05:31:40.461493	\N	\N	f
999	2	2022-11-26 10:54:52.955319	\N	\N	f
1000	6	2022-05-25 18:22:19.418988	\N	\N	f
1000	3	2022-12-13 09:10:14.007096	\N	\N	f
1000	2	2023-03-29 10:47:33.137867	\N	\N	f
1001	9	2022-11-09 03:18:13.836554	\N	\N	f
1001	6	2023-01-18 04:31:44.784095	\N	\N	f
1002	6	2022-01-20 08:38:45.528221	\N	\N	f
1002	1	2022-01-29 22:58:14.767195	\N	\N	f
1002	4	2022-12-01 07:05:05.011035	\N	\N	f
1003	1	2022-03-13 06:27:22.514775	\N	\N	f
1003	9	2023-05-18 15:40:32.16045	\N	\N	f
1004	9	2022-10-24 16:08:10.649863	\N	\N	f
1004	6	2022-11-18 07:09:08.942195	\N	\N	f
1005	5	2023-03-18 15:57:34.323451	\N	\N	f
1005	7	2023-12-26 18:33:53.188032	\N	\N	f
1005	2	2024-06-28 01:25:09.138361	\N	\N	f
1006	5	2022-06-16 18:18:08.891064	\N	\N	f
1006	4	2022-10-28 21:04:54.813296	\N	\N	f
1007	5	2022-06-08 19:08:04.806607	\N	\N	f
1007	10	2022-07-30 07:16:33.671518	\N	\N	f
1007	7	2022-11-04 11:38:25.665049	\N	\N	f
1008	5	2022-01-25 13:43:49.925506	\N	\N	f
1008	2	2022-11-09 15:45:36.974865	\N	\N	f
1009	10	2022-01-30 10:09:56.078623	\N	\N	f
1010	1	2022-04-28 04:05:00.070695	\N	\N	f
1010	10	2022-11-07 03:00:34.437541	\N	\N	f
1011	9	2022-01-03 22:13:03.550316	\N	\N	f
1011	1	2022-01-13 01:53:53.374116	\N	\N	f
1011	10	2022-02-01 18:23:58.615455	\N	\N	f
1012	5	2022-07-16 03:05:53.540137	\N	\N	f
1012	4	2022-11-09 02:39:17.919579	\N	\N	f
1013	7	2022-08-30 19:12:24.462054	\N	\N	f
1013	10	2023-06-06 10:15:25.048606	\N	\N	f
1014	4	2022-08-05 14:52:20.452374	\N	\N	f
1014	6	2023-02-01 18:29:03.306191	\N	\N	f
1014	11	2023-10-07 20:36:40.679164	\N	\N	f
1014	10	2024-01-25 05:03:49.552476	\N	\N	f
1015	5	2022-03-06 23:21:36.047006	\N	\N	f
1015	8	2023-03-02 09:53:44.232939	\N	\N	f
1015	7	2023-08-29 01:51:16.344642	\N	\N	f
1016	6	2022-07-03 12:10:33.044857	\N	\N	f
1017	2	2022-03-05 15:00:17.494335	\N	\N	f
1017	7	2023-01-09 18:46:01.861903	\N	\N	f
1018	4	2022-10-11 20:17:29.042572	\N	\N	f
1018	6	2023-01-10 15:39:51.720137	\N	\N	f
1019	7	2022-01-02 11:52:19.511334	\N	\N	f
1019	4	2022-11-19 22:47:50.404629	\N	\N	f
1020	8	2022-02-12 12:42:22.776309	\N	\N	f
1020	7	2023-06-12 15:40:37.687089	\N	\N	f
1021	3	2022-08-11 23:17:26.266011	\N	\N	f
1021	11	2022-11-27 23:56:47.420833	\N	\N	f
1021	2	2022-11-30 18:14:23.136669	\N	\N	f
1022	2	2022-03-15 15:30:27.562725	\N	\N	f
1023	10	2022-04-29 16:04:54.341751	\N	\N	f
1023	6	2023-02-06 10:12:35.230566	\N	\N	f
1024	6	2022-05-24 19:35:16.822937	\N	\N	f
1024	10	2022-06-02 08:41:19.111636	\N	\N	f
1024	8	2022-07-06 05:16:11.232311	\N	\N	f
1024	4	2022-08-05 14:41:17.266343	\N	\N	f
1025	1	2022-03-18 22:57:17.419962	\N	\N	f
1025	3	2022-06-20 22:10:24.46434	\N	\N	f
\.


--
-- Data for Name: students_evaluations; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.students_evaluations (id_student, id_evaluation, grade) FROM stdin;
26	18	5
26	19	2
26	20	12
26	28	12
26	29	2
26	24	17
26	25	15
26	26	8
26	5	18
26	7	19
26	8	0
27	28	2
27	29	8
27	33	0
27	34	5
27	35	15
28	12	11
28	13	4
28	14	9
28	33	11
28	34	14
29	9	2
29	10	12
29	11	0
29	21	2
29	23	6
30	18	9
30	20	15
30	30	12
30	31	4
30	32	5
30	15	2
30	16	6
30	17	2
31	6	9
31	7	18
31	8	11
31	24	16
31	25	6
31	26	7
32	6	8
32	7	6
32	18	1
32	19	17
32	20	15
34	30	19
34	31	18
34	21	16
34	22	20
35	15	17
35	16	14
35	17	14
35	21	11
35	22	2
36	24	3
36	25	19
36	26	6
36	12	6
36	13	15
36	14	3
37	12	1
37	13	8
37	14	7
37	15	2
37	16	16
37	17	14
37	24	1
37	25	20
38	1	16
38	2	2
38	4	17
38	18	6
38	9	18
38	10	15
38	11	4
39	18	17
39	19	2
39	20	10
39	30	18
39	31	4
39	32	6
39	5	5
39	8	3
40	1	1
40	2	5
40	3	1
40	4	14
40	9	2
40	10	2
40	11	15
41	24	18
41	26	11
41	6	16
41	7	16
41	1	9
41	2	6
41	3	8
41	4	15
42	5	6
42	6	19
42	7	3
42	8	18
43	15	7
43	16	12
43	22	8
43	23	20
43	5	9
43	6	4
43	7	13
44	21	14
44	22	4
44	23	16
44	27	17
44	28	9
44	29	1
44	1	20
44	2	8
44	3	6
44	4	13
45	1	13
45	4	13
45	24	18
45	25	9
45	26	11
46	12	6
46	13	18
46	14	10
46	27	1
46	28	19
47	30	6
47	31	12
47	32	3
47	27	3
47	29	13
47	9	16
47	10	15
48	24	5
48	25	12
48	26	12
48	33	5
48	34	17
48	35	17
49	9	6
49	11	8
49	16	16
56	7	20
56	15	3
56	17	11
56	21	1
56	22	3
56	23	16
57	24	5
57	25	1
57	26	19
58	30	7
58	31	11
58	32	6
58	13	11
58	5	8
58	6	2
58	7	15
58	8	20
59	31	9
59	12	11
59	24	8
59	25	7
59	26	6
59	21	4
59	22	6
59	23	17
60	12	8
60	13	7
60	14	2
60	21	18
60	22	4
61	2	11
61	3	3
61	4	12
61	25	1
49	17	7
49	18	1
49	19	4
50	33	14
50	34	0
50	9	11
50	10	12
50	11	20
51	9	6
51	10	0
51	11	2
51	30	7
51	32	7
52	1	11
52	2	8
52	3	4
52	4	7
53	5	14
53	6	16
53	12	18
53	14	14
54	31	2
54	32	14
54	12	14
54	13	5
54	14	19
55	10	17
55	11	4
55	27	13
55	28	0
55	29	13
55	33	10
55	34	16
55	35	0
56	6	8
61	26	20
62	30	14
62	31	1
62	32	8
62	1	12
62	2	10
62	3	8
62	4	20
63	15	8
63	16	2
63	17	2
63	9	12
63	10	13
63	11	5
64	24	7
64	25	5
64	26	4
64	1	18
64	2	7
64	4	9
65	5	10
65	6	10
65	7	2
65	32	18
66	23	9
67	29	6
67	33	4
67	34	0
67	35	12
67	1	17
67	2	4
67	3	3
67	4	5
68	1	14
68	2	1
68	3	5
68	4	0
68	15	14
68	16	18
68	27	4
68	28	0
69	21	2
69	22	13
69	23	11
69	24	16
69	26	2
69	12	0
69	13	8
69	14	4
70	33	0
70	34	1
70	35	11
70	27	11
70	28	0
71	15	9
71	16	5
71	17	13
71	24	4
71	25	19
71	26	14
71	5	14
71	6	1
71	8	10
72	30	16
72	31	19
72	32	1
73	18	5
73	31	6
73	32	5
74	5	16
74	6	16
74	7	3
74	8	12
74	21	18
74	22	16
74	23	9
74	12	13
74	13	18
74	14	20
75	13	7
75	30	0
85	33	11
85	34	1
85	35	16
86	27	10
86	28	1
86	29	11
86	34	15
86	35	3
86	16	12
86	17	10
87	23	13
87	28	10
87	29	15
87	14	5
88	28	13
88	18	7
88	19	0
88	20	20
89	18	11
89	19	19
89	20	6
89	15	17
89	16	2
89	17	13
90	33	2
90	34	17
90	35	0
90	27	11
90	28	9
91	16	15
91	17	0
91	27	17
91	28	17
91	29	17
91	30	5
91	31	8
91	32	12
91	24	8
91	25	10
91	26	7
92	9	5
75	31	7
75	32	14
75	18	13
75	20	15
76	12	3
76	13	20
76	14	19
76	18	7
76	19	2
76	20	7
77	18	8
77	19	15
77	20	8
77	27	14
77	28	7
77	29	14
77	9	4
77	10	4
77	11	9
78	18	1
78	20	3
78	31	0
79	21	13
79	22	20
79	23	3
79	12	5
79	13	1
79	14	17
79	15	10
79	16	18
80	21	10
80	22	18
80	23	8
80	27	7
80	5	0
80	6	9
80	7	11
80	8	19
80	9	11
80	10	13
80	11	18
81	1	14
81	2	10
81	3	14
81	4	8
81	30	3
81	31	15
81	32	16
81	15	11
81	16	13
81	17	16
82	33	1
82	34	16
82	35	16
82	9	8
82	10	4
82	11	4
83	15	6
83	16	8
83	17	11
83	12	2
83	13	14
83	14	12
84	24	1
84	25	2
84	26	15
85	30	7
85	32	14
85	28	2
85	29	15
85	21	1
85	22	17
85	23	2
92	10	18
93	12	0
93	13	2
93	14	9
93	5	19
93	6	4
93	7	15
94	33	16
94	34	16
94	35	2
94	5	5
94	6	16
94	7	2
94	19	6
94	20	3
95	24	16
95	25	16
95	26	8
95	15	20
95	16	5
95	17	19
96	6	8
96	7	12
96	15	3
96	16	13
96	17	8
97	16	9
97	17	16
97	13	4
97	14	7
114	20	4
114	15	17
114	16	14
115	34	13
115	35	20
115	31	18
115	32	20
115	1	11
115	2	7
115	3	17
115	4	10
116	9	1
116	11	1
116	5	11
116	6	13
116	7	2
116	8	19
116	18	20
116	19	9
116	20	7
117	21	11
117	22	5
117	23	18
117	25	9
117	26	9
118	27	1
118	28	19
118	29	12
118	33	18
118	34	9
118	35	8
118	15	11
118	16	16
119	27	10
119	28	8
119	29	19
97	27	3
97	29	14
98	33	6
98	34	10
98	35	19
98	5	5
98	6	0
98	7	5
98	23	0
99	21	19
99	22	11
99	23	4
99	26	17
99	15	20
99	16	0
99	17	3
100	19	12
100	12	8
100	13	15
100	9	13
100	10	15
100	11	11
101	1	14
101	2	3
101	3	8
101	4	3
101	12	6
101	13	12
101	14	20
101	9	20
101	10	6
101	11	10
102	31	14
103	18	11
103	19	10
103	20	16
103	25	0
103	26	11
104	30	8
104	31	19
104	32	19
104	21	18
104	23	12
104	7	6
104	8	18
105	24	16
105	25	13
106	30	14
106	31	6
106	32	3
106	19	13
106	20	2
106	15	19
106	16	17
106	17	15
107	24	14
107	25	4
107	26	11
107	18	8
107	19	19
107	20	17
107	33	3
107	34	17
107	35	10
107	5	3
107	6	17
108	9	0
108	11	14
108	24	15
108	25	8
108	26	17
108	18	0
108	19	12
109	1	4
109	2	2
109	3	18
109	4	9
109	6	12
109	7	9
109	8	4
110	30	1
110	31	10
110	32	7
110	15	13
110	16	11
110	17	14
111	12	14
111	13	2
111	14	0
111	27	14
111	28	8
111	29	3
112	33	4
112	34	9
112	35	8
112	18	17
112	19	2
112	20	17
113	15	19
113	16	2
113	17	13
113	1	14
113	2	2
113	4	4
113	5	13
113	6	16
113	7	13
113	8	18
114	18	13
119	21	5
119	22	13
119	23	6
120	31	16
140	13	12
140	14	7
141	12	1
141	13	8
141	14	8
141	27	3
141	28	2
141	29	3
142	5	8
142	6	2
142	7	9
142	8	6
142	24	3
142	25	6
142	26	5
143	15	8
143	16	19
143	9	8
143	10	20
143	11	19
144	1	4
144	2	14
144	3	12
144	4	18
144	21	0
144	22	16
144	23	9
145	33	2
145	12	16
145	14	8
145	21	9
145	23	8
120	32	10
120	9	11
120	11	6
120	33	2
120	34	1
120	18	2
120	20	0
121	21	0
121	22	8
121	1	11
121	4	4
121	12	12
121	13	10
121	14	7
121	24	7
121	25	0
121	26	10
122	1	11
122	2	2
122	3	14
122	4	1
122	30	4
122	31	5
122	32	3
123	21	8
123	22	6
123	23	7
123	27	18
123	28	20
123	29	20
123	13	1
123	14	6
124	16	18
124	17	5
124	5	11
124	6	4
124	7	4
124	8	17
124	1	20
124	2	13
124	3	4
124	4	11
124	27	11
124	28	1
124	29	20
125	15	17
125	16	7
125	17	11
125	21	1
125	22	2
125	23	6
126	21	11
126	23	5
126	5	16
126	6	2
126	7	16
126	8	8
126	24	18
126	26	12
127	22	14
127	23	10
127	12	5
127	13	8
127	14	13
127	1	3
127	2	19
127	3	11
127	4	7
128	30	6
128	32	20
128	33	13
128	35	10
129	27	5
129	28	20
129	29	18
129	24	6
129	26	5
129	16	19
129	17	7
130	1	20
130	3	20
130	4	14
130	24	20
130	26	13
131	27	2
131	28	15
131	29	14
131	1	14
131	3	11
131	4	12
131	9	11
131	10	15
131	11	4
132	1	6
132	2	5
132	3	8
132	4	16
132	24	10
132	25	4
133	34	18
133	35	18
133	6	5
133	7	16
133	8	15
133	12	8
133	13	7
134	33	7
134	6	5
134	7	6
134	16	11
134	17	12
135	33	19
135	34	13
135	35	10
135	18	17
135	19	19
136	24	13
136	25	8
136	26	18
136	21	3
167	18	17
167	19	3
167	20	2
168	9	15
168	10	0
168	11	12
168	1	11
168	2	8
168	3	0
168	4	2
169	31	16
169	32	8
169	34	10
169	35	2
170	18	12
170	19	17
170	20	0
170	1	13
170	2	19
170	3	5
171	12	3
171	13	13
171	14	20
171	1	4
171	2	18
171	3	0
171	4	3
172	27	15
172	28	5
172	29	12
172	12	8
172	13	6
172	22	9
172	23	19
173	30	20
173	31	13
173	32	18
173	27	14
173	29	20
173	18	11
136	23	13
136	33	19
136	35	19
137	30	5
137	31	2
137	32	2
137	21	7
137	22	8
138	30	20
138	32	5
138	9	15
138	10	12
138	5	11
138	6	14
138	7	1
138	8	11
139	30	15
139	31	20
139	32	13
140	30	4
140	31	2
140	32	17
140	27	7
140	28	13
140	29	11
140	12	2
146	9	7
146	10	10
147	18	13
147	19	10
147	20	7
147	12	10
147	13	17
147	14	9
147	15	7
147	16	13
148	5	8
148	6	13
148	7	1
148	8	0
148	30	15
148	31	1
148	32	3
148	21	19
148	22	19
148	23	11
148	15	14
148	16	16
148	17	20
149	12	6
149	13	12
149	14	11
149	24	11
149	25	9
149	26	12
149	30	2
149	31	11
149	32	8
149	9	20
149	11	17
150	30	2
150	32	19
151	21	3
151	23	16
151	18	4
151	19	17
151	24	4
151	26	19
152	18	18
152	20	3
152	24	3
152	26	5
153	9	1
153	11	11
153	12	4
153	13	0
153	14	4
154	18	7
154	19	7
154	20	0
154	1	18
154	2	12
154	3	14
154	4	1
154	30	5
154	31	6
154	32	12
155	5	2
155	6	12
155	8	8
155	1	14
155	2	8
155	3	18
155	4	11
155	30	2
155	31	0
155	32	0
155	21	10
155	22	5
155	23	10
156	30	16
156	31	0
156	32	19
156	12	9
157	30	17
195	16	11
195	17	8
195	12	2
195	14	11
196	30	10
196	31	3
196	24	19
196	25	13
196	26	5
197	31	10
197	32	2
197	9	4
197	10	2
197	11	10
198	27	1
198	28	0
198	29	11
198	22	10
198	23	19
198	1	16
198	2	6
198	3	7
198	4	2
199	1	15
199	2	12
199	29	7
199	33	2
199	34	9
199	35	16
200	18	9
200	19	4
200	20	19
200	33	10
200	34	14
200	35	17
200	12	4
200	13	17
200	14	1
200	5	15
200	6	15
157	31	19
157	32	5
157	25	12
157	26	15
157	12	3
157	13	2
157	14	2
158	10	13
158	18	7
158	19	20
158	5	0
158	6	9
158	8	7
158	12	0
158	13	1
158	14	2
159	27	19
159	28	19
159	29	13
159	22	0
159	34	5
159	35	8
159	30	7
159	31	13
159	32	13
160	5	2
160	6	17
160	7	8
160	8	7
160	15	11
160	16	5
160	17	6
160	30	3
160	31	3
160	32	5
161	5	2
161	6	5
161	7	13
161	8	18
161	1	5
161	3	5
162	30	18
162	31	16
163	12	14
163	13	4
163	14	6
163	33	3
163	34	4
163	24	11
163	25	15
163	26	14
164	6	11
164	7	15
164	8	11
164	30	5
164	31	2
164	24	19
164	25	2
164	26	4
164	12	19
164	13	2
164	14	1
165	12	19
165	14	3
165	16	7
165	17	14
166	25	11
166	26	4
166	27	8
166	28	13
166	33	20
166	34	3
166	35	0
167	12	6
167	13	1
167	14	13
167	24	4
167	25	5
167	26	8
173	19	20
173	20	7
174	6	14
174	7	12
174	8	18
174	15	14
174	16	19
174	17	15
174	1	7
174	2	16
174	3	13
174	4	19
175	33	14
175	34	15
175	35	12
175	1	5
175	2	19
175	3	19
175	4	18
175	31	12
175	32	14
176	9	8
176	10	11
176	11	13
176	28	3
176	29	1
224	2	12
224	30	20
224	31	15
224	32	4
225	27	19
225	21	17
225	22	4
225	23	5
225	18	20
225	20	8
226	27	3
226	28	16
226	13	5
226	14	19
227	14	5
227	30	19
227	31	1
227	32	10
228	9	16
228	10	18
228	33	1
228	34	9
228	35	6
228	21	6
228	22	11
228	23	4
228	31	2
228	32	5
229	22	15
229	12	6
229	13	15
229	14	20
230	6	17
230	7	0
230	8	5
230	12	9
230	13	2
230	14	20
230	18	5
230	19	5
230	20	2
230	3	17
230	4	10
231	5	1
231	6	17
176	16	17
177	5	18
177	6	4
177	8	4
177	1	4
177	2	17
177	3	12
178	25	20
178	5	15
178	7	6
179	21	16
179	22	14
179	9	8
179	11	17
180	25	14
180	26	1
180	30	10
180	31	11
180	32	10
180	15	12
180	16	5
180	17	3
181	24	19
181	25	0
181	26	15
181	33	18
181	34	19
182	6	0
182	7	5
182	8	17
182	18	11
182	19	11
182	20	0
183	9	18
183	10	20
183	11	12
183	1	12
183	4	4
184	31	5
184	32	0
184	33	18
184	34	12
184	21	9
184	22	10
184	23	2
185	9	17
185	10	12
185	11	3
185	5	19
185	7	13
185	8	6
186	18	13
186	19	7
186	20	1
186	5	5
186	6	11
186	7	6
186	15	6
186	16	17
186	21	1
186	23	14
187	21	4
187	22	1
188	25	11
188	26	15
188	27	15
188	29	4
189	30	1
189	31	9
189	32	2
189	18	15
189	19	14
190	27	17
190	28	11
190	29	14
190	24	9
190	25	6
190	26	4
190	33	14
190	34	3
190	35	10
191	28	11
191	29	11
191	22	0
191	23	13
192	15	14
192	16	6
192	17	4
192	5	17
192	6	13
192	7	20
192	8	20
192	28	6
192	29	4
193	1	13
193	2	6
250	29	7
251	30	7
251	31	19
251	32	3
251	15	17
251	17	0
252	33	4
252	34	8
252	35	1
252	18	14
252	20	10
253	11	7
253	6	15
253	7	14
253	8	3
254	25	8
254	26	5
254	10	3
254	11	0
254	16	6
254	17	17
255	15	14
255	16	2
255	17	20
255	18	10
255	19	10
255	20	9
255	34	16
255	35	6
256	15	7
256	16	12
256	17	13
257	21	19
257	22	9
257	23	17
258	1	17
258	2	7
258	3	19
258	4	2
258	24	8
258	25	6
258	21	4
258	22	10
258	23	18
258	33	9
258	34	16
258	35	6
259	27	11
259	28	9
259	29	9
193	3	2
193	4	11
193	12	17
193	14	20
194	18	14
194	19	19
194	20	10
194	15	19
194	16	13
194	17	16
194	34	2
194	35	16
194	9	9
194	11	2
195	27	10
195	29	11
195	18	7
195	19	17
195	20	13
200	7	20
200	8	15
201	1	8
201	2	12
201	3	7
201	15	12
201	17	1
202	24	19
202	25	17
202	26	17
203	24	13
203	25	1
203	26	15
203	15	14
203	16	6
203	17	13
204	21	9
204	22	5
204	23	17
204	15	11
204	17	13
204	1	17
204	2	19
204	3	7
204	4	2
205	21	19
205	22	18
205	23	5
205	26	6
205	33	13
205	34	8
205	35	20
206	5	2
206	7	20
206	8	0
206	30	12
206	31	16
206	32	1
206	33	4
206	34	10
206	35	8
207	21	12
207	22	9
207	23	19
207	30	15
207	31	20
207	32	4
208	18	13
208	19	15
208	20	6
208	28	3
208	29	10
209	24	19
209	25	0
209	26	12
209	30	12
209	31	3
209	32	16
209	1	13
209	2	18
209	3	8
209	4	16
210	6	12
210	7	7
210	8	19
210	24	8
210	25	17
281	10	2
281	11	2
281	18	1
281	19	17
282	9	17
282	10	13
282	11	7
282	33	1
282	35	16
283	27	5
283	28	18
283	29	5
283	21	2
283	22	18
283	23	12
283	24	1
283	25	4
284	15	13
284	16	20
284	17	1
284	18	15
284	19	17
284	20	12
285	5	13
285	6	10
285	7	8
285	8	6
285	30	14
285	32	10
285	18	19
285	19	10
285	20	14
286	15	12
286	17	5
286	24	8
286	25	14
286	26	10
286	30	3
286	32	3
287	27	13
287	28	5
287	29	5
210	26	9
211	2	16
211	3	0
211	4	1
212	9	14
212	10	18
212	11	12
212	24	13
212	26	6
212	18	19
212	19	20
213	24	7
213	25	9
213	26	8
213	30	4
213	31	15
213	32	16
214	21	18
214	22	14
214	5	9
214	7	4
214	12	19
214	14	9
215	18	11
215	19	5
215	20	0
215	13	5
215	14	6
215	8	10
216	5	10
216	6	3
216	8	5
216	28	0
216	29	0
217	11	6
217	24	7
217	25	3
217	26	15
217	27	7
217	28	13
218	1	2
218	2	13
218	3	12
219	19	15
219	20	11
219	9	7
219	10	19
219	11	15
219	24	12
219	25	1
219	26	7
220	27	0
220	28	12
220	29	7
220	26	6
220	1	16
220	3	7
220	4	3
221	18	16
221	19	0
221	6	6
221	7	19
221	8	2
221	34	6
222	30	7
222	31	17
222	32	10
222	1	15
222	2	13
222	4	16
223	24	5
223	25	13
224	5	4
224	6	3
224	7	1
231	7	1
231	15	5
231	16	16
231	17	20
232	15	0
232	16	11
232	17	4
232	2	9
232	3	11
232	4	11
233	5	1
233	6	20
233	7	15
233	1	0
233	2	3
233	33	18
233	34	11
233	35	10
234	18	20
234	19	18
234	20	4
234	15	9
234	17	15
234	5	11
234	7	15
234	8	4
314	24	9
314	25	8
314	26	18
314	12	13
314	13	0
314	14	7
314	21	5
314	22	15
314	23	14
315	9	18
315	11	16
315	5	12
315	6	8
315	7	6
315	8	16
315	21	18
315	22	6
315	23	17
316	21	18
316	22	6
316	23	19
316	18	15
316	19	5
316	24	20
316	25	11
316	26	13
317	12	6
317	13	20
317	14	17
234	10	17
234	11	15
235	24	9
235	25	3
235	26	12
235	21	11
235	22	15
235	23	11
236	27	1
236	28	6
236	29	8
236	9	0
236	10	13
236	11	8
237	29	13
237	25	8
237	26	4
237	33	9
237	35	9
237	18	4
237	19	5
237	20	8
238	1	17
238	2	19
238	3	0
238	4	18
238	9	20
238	11	3
238	33	7
238	34	17
238	35	4
239	18	11
239	20	17
239	1	13
239	4	7
240	18	11
240	19	12
240	20	8
240	5	9
240	6	9
240	7	15
240	8	10
241	12	17
241	13	8
241	14	7
241	30	2
241	31	1
241	32	19
242	6	14
242	7	19
242	9	17
242	10	16
242	11	10
242	21	16
242	22	16
243	5	18
243	7	3
243	1	4
243	3	3
243	4	19
243	9	9
243	10	14
243	11	15
244	18	13
244	19	10
244	20	3
244	25	15
244	26	11
245	1	18
245	3	18
245	34	1
245	35	1
246	9	3
246	10	10
246	11	0
246	19	18
246	20	4
247	9	7
247	10	15
247	11	5
247	18	1
247	20	2
247	1	3
247	2	6
247	3	6
247	4	10
248	12	15
248	14	14
248	33	12
248	34	17
248	35	7
249	22	7
249	23	16
249	31	11
249	32	10
249	24	16
249	25	11
249	26	11
250	2	7
250	3	16
250	12	6
250	13	12
250	14	2
250	27	3
250	28	7
259	1	9
259	2	2
259	3	16
259	4	16
260	27	5
260	28	8
260	29	4
260	9	3
260	10	10
260	11	1
261	9	10
261	10	0
261	11	2
261	22	15
261	23	18
262	34	4
262	6	4
262	7	11
262	21	5
262	23	17
263	13	1
341	25	6
341	26	19
341	21	5
341	23	20
341	1	17
341	2	17
341	4	14
342	24	7
342	25	15
342	26	13
342	9	15
342	10	0
342	11	18
342	27	8
342	28	8
342	29	2
343	22	4
343	23	19
343	9	15
343	10	4
343	11	12
343	18	18
343	19	20
343	20	19
344	12	12
344	13	1
344	14	4
344	33	11
344	34	18
344	35	8
344	1	4
344	2	0
344	4	9
345	24	13
345	25	15
345	26	9
345	33	19
345	34	3
345	35	13
345	9	12
346	18	2
346	19	18
346	27	19
346	29	3
347	10	5
347	11	20
347	18	0
263	9	3
263	10	18
263	11	11
264	15	17
264	16	12
264	18	6
264	20	9
265	1	6
265	2	14
265	3	9
265	30	9
265	31	8
265	15	19
265	16	18
265	17	19
266	33	1
266	34	12
266	35	18
266	24	9
266	25	6
266	26	12
267	30	20
267	31	11
267	32	9
267	27	0
267	28	2
268	33	7
268	34	7
268	35	18
268	30	20
268	31	19
268	32	17
269	1	19
269	2	7
269	4	14
269	22	1
269	23	14
270	18	6
270	19	17
270	20	10
270	33	12
270	35	8
270	21	16
270	22	3
270	23	10
271	9	12
271	10	11
271	11	0
271	13	19
272	24	7
272	25	20
272	26	0
272	5	11
272	6	14
272	7	9
272	8	14
273	7	19
273	8	17
273	33	14
273	34	4
273	35	4
274	30	0
274	31	19
274	32	19
274	18	17
274	27	19
275	11	13
275	24	2
275	26	11
275	6	15
275	7	13
276	22	12
276	23	7
276	34	8
276	35	20
277	13	3
277	14	3
277	18	9
277	19	9
278	24	12
278	25	11
278	26	19
278	21	20
278	15	2
278	16	13
279	5	3
279	7	19
279	8	17
279	22	16
279	23	15
279	1	1
279	2	5
367	13	11
367	33	12
367	34	18
367	35	5
368	23	5
369	21	8
369	18	5
369	19	9
369	20	8
369	1	13
369	2	4
369	3	2
369	4	14
370	1	10
370	3	1
370	4	18
371	27	20
371	29	19
371	14	17
372	1	0
372	3	19
372	4	16
372	33	6
372	34	0
372	35	13
373	33	15
373	34	16
373	35	10
373	1	0
373	2	2
373	4	9
373	32	20
374	15	5
374	16	17
374	21	3
374	22	4
374	23	19
375	2	13
375	3	14
375	4	10
375	6	9
375	7	5
375	8	12
376	31	10
376	1	17
376	2	14
376	3	0
376	4	2
279	3	19
279	4	17
280	15	14
280	16	7
280	34	5
280	35	12
281	9	20
287	15	2
287	17	6
287	21	20
287	22	16
287	23	17
288	5	8
288	7	13
288	16	11
288	17	9
288	27	5
288	22	11
288	23	10
289	12	13
289	13	16
289	14	11
289	24	16
289	25	16
289	26	3
290	18	7
290	19	11
290	24	17
290	26	16
291	21	19
291	22	13
291	23	20
291	15	7
291	17	14
292	6	15
292	7	8
292	19	7
292	20	16
292	33	12
293	24	3
293	25	4
293	26	10
294	5	18
294	7	3
294	8	12
294	27	11
294	28	0
294	29	5
295	19	4
295	33	0
295	34	9
295	35	9
296	1	16
296	2	0
296	3	17
296	4	6
296	13	7
296	14	13
297	21	4
297	23	19
298	30	19
298	31	18
298	32	3
299	21	20
299	22	11
299	23	2
299	27	4
299	28	11
299	29	19
300	5	18
300	6	16
300	7	2
300	8	2
300	9	17
300	10	11
300	11	7
301	15	4
301	17	15
301	9	17
302	27	1
302	28	19
302	29	5
302	1	0
302	2	15
302	3	1
302	4	17
303	9	15
303	10	8
303	12	16
303	31	7
396	12	1
396	13	14
396	14	13
397	30	10
397	31	20
397	15	13
397	16	16
397	17	14
398	10	8
398	27	9
398	28	7
398	29	15
399	33	18
399	34	18
399	35	2
399	18	18
399	20	16
399	1	3
399	2	5
400	18	3
400	19	9
400	24	13
400	25	16
400	26	11
401	30	0
401	31	2
401	24	20
401	25	18
401	26	4
401	18	3
401	19	15
401	20	14
402	15	14
402	16	11
402	17	19
402	18	5
402	19	8
402	20	8
402	21	7
304	33	5
304	34	7
304	5	9
304	6	19
304	8	16
304	21	0
304	22	20
305	30	11
305	31	0
305	32	9
305	18	11
305	19	14
305	20	10
305	27	13
305	28	8
305	29	19
306	1	14
306	2	17
306	3	13
306	4	8
306	9	5
306	10	6
306	11	2
307	27	0
307	28	1
308	5	13
308	6	10
308	7	1
308	8	12
308	22	0
308	23	1
309	28	16
309	29	11
310	24	3
310	25	20
310	1	16
310	2	16
310	4	4
310	6	9
310	7	3
311	19	2
311	20	20
311	12	13
311	13	12
311	14	0
311	15	14
311	17	11
312	21	3
312	22	1
312	23	20
313	13	7
313	14	18
313	30	6
313	31	11
317	24	2
317	25	17
317	26	7
317	30	18
317	31	16
317	32	4
317	2	17
317	3	7
317	4	12
318	19	14
318	20	4
318	21	18
318	22	0
318	23	17
318	34	19
319	33	17
319	34	10
319	27	0
319	28	0
320	15	20
320	16	3
320	17	19
320	1	5
320	2	9
320	4	7
320	21	18
320	22	2
320	23	8
320	24	0
320	25	18
320	26	18
321	12	17
321	13	20
321	34	8
321	24	1
321	25	1
322	30	4
322	31	19
322	32	11
322	27	17
322	28	6
322	29	19
323	30	13
323	31	12
323	32	7
323	25	13
324	30	5
324	31	6
324	27	6
324	28	20
324	29	8
324	15	3
324	16	13
424	10	11
424	11	3
424	31	3
424	32	6
425	33	9
425	34	18
425	16	13
426	24	11
426	25	3
426	26	10
426	11	0
427	1	16
427	2	1
427	3	4
427	4	20
427	30	9
427	32	0
427	25	15
427	26	8
428	5	15
428	6	18
428	8	3
428	18	5
428	19	11
428	20	19
429	21	16
429	22	1
429	23	5
429	5	10
429	6	3
429	7	13
429	8	20
430	5	18
430	6	16
430	7	10
430	8	4
430	28	0
430	29	12
431	30	7
431	31	20
432	9	7
432	11	4
324	17	19
325	19	15
325	20	7
326	21	5
326	22	19
326	23	0
326	15	7
326	16	10
326	17	9
326	19	13
326	20	12
327	5	3
327	6	11
327	7	17
327	8	11
327	9	20
327	11	18
327	12	2
327	13	5
328	15	18
328	16	10
328	17	10
328	33	19
328	34	3
328	35	1
329	25	19
329	26	3
329	9	16
329	10	10
329	11	16
329	12	1
329	13	13
329	14	18
330	27	11
330	28	1
330	29	4
331	1	0
331	2	6
331	3	8
331	4	0
331	21	17
331	22	17
331	23	4
331	27	7
331	28	12
331	29	13
332	24	2
332	25	20
332	26	9
333	13	3
333	14	10
333	10	3
333	11	3
333	30	19
333	32	17
334	9	1
334	10	3
334	11	18
334	24	7
334	25	15
334	26	19
334	5	13
334	7	0
334	8	7
335	6	3
335	7	8
335	8	6
335	18	13
335	19	11
335	20	7
336	5	18
336	6	4
336	7	7
336	8	2
336	24	7
336	25	7
336	26	20
336	18	1
336	20	17
337	27	8
337	28	18
337	29	11
337	30	18
337	31	2
337	32	20
337	13	16
337	14	4
338	9	12
338	10	18
338	11	14
338	21	17
338	22	13
338	1	10
338	2	12
338	3	6
338	4	15
339	18	9
339	19	15
339	20	10
339	33	13
339	35	13
452	8	19
453	10	13
453	11	0
453	25	10
453	27	19
453	29	18
454	27	4
454	28	10
454	29	5
454	35	18
455	27	14
455	29	10
455	34	10
455	35	1
455	12	10
455	13	1
455	14	15
456	5	19
456	6	3
456	7	11
456	8	10
456	15	7
456	16	20
456	27	7
456	28	19
456	29	9
456	24	13
456	26	19
457	33	6
457	34	16
457	35	13
457	24	3
457	28	12
457	29	8
457	9	14
457	11	13
458	24	1
458	26	4
458	30	1
458	31	1
458	32	6
340	15	0
340	16	12
340	17	14
340	2	20
340	3	12
340	4	12
340	21	9
340	22	4
340	23	0
341	18	19
341	19	8
347	19	4
347	20	13
347	15	5
347	16	20
348	9	18
348	10	16
348	11	14
348	23	17
348	18	19
348	19	4
349	15	15
349	16	14
349	17	11
349	30	17
349	31	7
349	32	11
349	12	12
350	15	8
350	16	2
350	21	5
350	23	3
350	2	15
350	4	5
351	15	18
351	17	15
351	18	15
351	19	1
351	20	2
351	9	6
351	10	16
351	11	18
352	25	0
352	26	20
352	30	15
352	31	15
352	32	14
353	1	11
353	2	15
353	3	13
353	33	12
353	34	6
353	35	2
353	29	0
354	5	1
354	7	4
354	8	14
354	26	18
354	28	19
354	29	11
355	30	15
355	31	4
355	32	5
356	33	10
356	34	6
356	35	14
356	1	12
356	2	6
356	3	0
357	33	9
357	34	15
357	35	3
357	31	8
357	32	6
357	5	0
357	7	6
357	8	5
358	16	15
358	17	13
359	24	5
359	26	2
359	9	2
359	10	8
359	11	16
360	15	15
360	16	16
360	17	18
361	5	2
361	6	11
361	7	12
361	8	14
361	1	2
361	2	16
361	3	5
361	4	1
361	22	5
361	23	13
361	31	14
362	15	7
362	16	16
362	17	20
362	5	5
362	7	11
481	24	15
481	25	16
481	26	17
481	18	12
481	19	16
481	20	6
482	15	1
482	17	16
482	12	18
482	13	2
482	14	11
483	24	2
483	25	14
484	21	19
484	22	3
484	23	2
484	5	2
484	6	16
484	7	6
484	8	14
484	25	11
485	9	12
485	10	1
485	11	7
485	12	10
485	13	18
485	14	13
485	15	12
485	17	3
486	18	12
486	19	5
486	9	0
486	10	14
486	11	4
486	13	4
486	14	1
487	21	6
487	22	12
487	23	11
487	2	13
487	3	6
362	24	0
362	25	17
362	26	15
362	4	11
363	25	18
363	26	11
363	33	5
363	35	3
364	2	14
364	3	16
364	4	9
364	30	6
364	31	0
364	9	20
364	10	1
364	11	8
365	24	2
365	25	16
365	26	1
365	33	5
365	35	17
365	29	14
366	24	2
366	25	5
366	26	14
366	1	7
366	2	15
366	3	11
366	4	16
366	5	8
366	6	17
366	7	15
366	8	8
367	32	9
367	12	3
376	15	17
376	16	11
376	17	7
377	27	10
377	28	0
377	29	2
377	24	20
378	25	10
378	26	16
378	5	4
378	6	0
378	7	2
378	8	13
378	18	0
378	20	18
378	30	12
378	32	13
379	24	20
379	25	11
379	26	0
379	33	16
379	35	12
380	27	9
380	28	3
380	29	2
380	1	15
380	4	17
380	18	14
380	19	10
380	20	12
381	18	19
381	19	5
381	28	17
382	24	20
382	25	2
382	26	1
382	9	20
382	11	12
382	13	20
382	14	17
383	5	12
383	6	4
383	7	4
383	8	15
383	1	13
383	2	11
383	4	16
384	30	16
384	31	15
384	32	12
384	22	15
384	23	3
384	24	4
384	25	9
385	27	2
385	28	11
385	29	3
385	24	12
385	25	7
385	26	0
385	18	14
385	20	4
386	1	16
386	2	2
386	4	11
387	12	6
387	13	8
387	14	20
508	34	13
508	35	15
509	21	16
509	22	5
509	23	12
509	1	17
509	2	0
509	3	3
510	30	10
510	31	20
510	32	16
510	27	11
510	28	0
510	15	15
510	16	14
511	21	5
511	22	12
511	23	14
511	16	1
511	17	2
512	18	1
512	20	4
512	24	18
512	1	6
512	2	17
512	3	13
512	4	13
513	21	20
513	22	12
513	23	9
513	27	16
513	28	0
514	31	5
514	32	17
514	25	6
514	26	18
514	18	15
514	19	5
514	20	0
515	18	19
515	19	19
515	5	20
515	6	5
515	8	9
387	24	5
387	25	14
387	9	2
387	10	3
387	11	17
388	21	4
388	23	19
388	24	6
388	25	10
388	26	14
389	21	6
389	22	17
389	9	19
389	10	8
389	11	6
389	25	9
389	26	12
390	1	3
390	2	14
390	3	19
390	4	2
390	22	3
390	23	14
390	33	0
390	34	9
390	35	15
391	1	5
391	2	13
391	3	13
391	4	20
391	30	19
391	32	18
392	24	16
392	12	0
392	13	9
392	15	8
392	16	4
392	17	2
393	27	3
393	28	5
393	29	17
393	12	0
393	13	18
393	14	4
394	24	20
394	26	10
394	17	12
394	9	15
394	10	20
394	11	13
394	21	17
395	21	2
395	22	7
395	23	2
395	24	20
395	25	4
395	26	5
402	22	12
402	23	13
403	30	4
403	31	8
403	32	16
403	24	7
403	25	2
403	26	12
404	30	17
404	32	8
404	24	8
404	25	5
404	26	15
404	33	11
404	34	13
404	35	5
405	28	1
405	29	10
405	5	17
405	6	5
405	8	9
406	24	12
406	25	16
406	26	9
406	35	5
406	11	5
407	34	6
407	35	20
407	5	4
407	6	3
407	7	1
407	8	8
408	30	10
408	32	0
408	27	17
408	29	19
409	10	17
409	11	15
409	21	0
409	15	19
534	29	4
534	33	0
534	34	4
535	5	6
535	6	15
535	7	11
535	8	1
535	33	16
535	34	20
535	35	10
536	21	11
536	22	15
536	5	17
536	6	16
536	7	17
536	8	0
536	1	0
536	2	10
536	3	8
536	4	20
536	18	6
536	19	11
536	20	5
537	9	19
537	11	4
537	12	9
537	13	6
537	14	2
537	21	15
409	17	8
410	5	19
410	6	14
410	7	12
410	8	19
410	33	4
410	34	13
410	35	4
411	33	7
411	34	1
411	16	8
411	17	20
412	33	8
412	34	1
412	15	9
412	17	14
412	21	10
412	22	14
412	23	3
413	12	17
413	13	19
413	27	20
413	28	15
413	29	5
413	30	6
413	31	0
413	32	14
414	27	13
414	29	4
414	1	4
414	2	17
414	3	20
415	27	1
415	29	20
415	2	11
415	3	4
415	4	12
415	33	12
415	35	19
416	33	17
416	35	2
416	12	4
416	14	16
416	5	0
416	7	7
416	8	7
417	33	12
417	34	10
417	35	11
417	9	8
417	10	4
417	11	1
418	9	11
418	10	13
418	11	8
418	30	19
418	31	9
418	32	1
419	28	8
419	29	12
419	10	14
419	11	2
420	18	20
420	19	2
420	20	18
420	1	17
420	2	3
420	4	7
420	21	8
420	23	0
421	21	13
421	22	5
421	23	5
421	15	9
421	16	12
421	27	0
421	28	13
421	29	12
422	27	0
422	28	19
422	29	19
422	1	8
422	2	9
422	3	5
422	4	20
422	9	15
422	10	12
422	11	2
422	12	6
422	13	9
422	14	15
423	33	4
423	35	17
423	21	12
423	22	5
423	23	13
423	18	9
423	19	12
423	20	9
424	18	12
424	19	12
424	20	10
424	33	20
424	9	18
433	1	14
433	2	3
433	3	9
433	4	8
433	15	10
433	17	0
434	1	4
434	2	3
434	3	2
434	4	12
435	9	7
435	10	14
435	11	15
436	15	6
436	16	18
436	17	5
436	30	13
436	31	9
436	32	6
437	12	6
437	13	2
437	14	11
561	24	3
561	25	20
561	26	4
561	15	1
561	16	1
561	17	0
562	18	16
562	20	10
562	7	15
562	8	3
562	30	10
562	31	11
563	26	17
563	6	11
563	7	4
563	8	1
564	1	16
564	2	5
564	3	14
564	4	18
564	9	5
564	10	6
564	11	1
565	27	3
565	28	13
565	29	16
565	18	11
565	19	2
565	20	4
566	9	5
566	10	20
566	11	5
566	33	10
566	34	5
566	35	0
567	12	15
567	13	17
567	14	4
568	1	16
568	2	2
568	3	18
568	4	0
568	27	0
437	33	8
437	35	1
437	18	15
437	19	16
437	20	11
438	33	2
438	35	8
438	5	1
438	6	16
438	7	20
438	18	14
438	19	1
438	20	18
439	15	5
439	16	17
439	17	5
439	14	5
439	33	12
439	34	15
439	35	11
439	24	11
439	26	10
440	6	3
440	7	19
440	29	4
441	1	4
441	2	2
441	3	8
441	4	13
441	27	12
441	28	1
441	29	4
442	15	1
442	16	19
442	17	11
442	12	10
442	13	2
442	14	12
442	6	5
442	7	11
442	8	15
443	30	1
443	31	4
443	32	12
443	6	13
443	7	20
444	21	11
444	22	0
444	23	10
444	33	17
444	34	8
444	35	16
444	27	10
444	28	4
444	12	19
444	13	0
444	14	6
445	1	0
445	2	3
445	3	8
445	4	6
445	15	14
445	16	9
445	17	2
445	27	7
445	28	12
445	29	17
445	33	4
445	34	1
445	35	6
446	5	9
446	6	11
446	7	11
446	15	14
446	16	10
446	17	7
446	30	1
446	31	6
446	32	2
446	18	16
446	19	20
447	18	19
447	19	6
447	20	18
447	30	18
447	31	18
447	32	13
448	15	4
448	17	0
448	33	0
448	35	8
449	15	4
449	18	14
449	19	9
449	20	2
450	16	15
450	17	13
450	27	14
450	28	3
589	23	19
589	24	20
589	25	8
589	26	11
590	35	14
590	5	12
590	6	14
590	7	5
590	8	8
591	21	19
591	22	19
591	1	4
591	2	1
591	3	10
591	4	19
591	15	3
591	16	19
592	9	15
592	11	13
593	18	17
593	19	17
593	7	14
593	8	12
594	9	9
594	10	3
594	11	5
595	15	0
595	16	4
595	34	7
595	35	17
595	12	20
595	14	6
596	5	4
596	7	12
596	8	3
596	33	2
596	34	20
596	35	20
597	1	3
597	3	17
597	4	5
597	21	7
597	22	14
451	27	9
451	29	2
451	33	20
451	34	15
451	35	6
451	5	20
451	7	20
451	8	0
452	24	17
452	25	6
452	26	8
452	21	18
452	23	14
452	30	0
452	32	5
452	6	7
458	9	2
458	10	9
458	11	14
459	5	18
459	6	5
459	7	3
459	1	20
459	2	11
459	4	18
459	15	2
459	17	14
460	25	20
460	26	20
460	15	8
460	16	14
460	17	12
460	33	9
460	34	1
460	35	6
461	9	0
461	10	11
461	11	10
461	34	8
461	35	3
462	12	9
462	13	20
462	9	6
462	10	14
462	11	19
463	19	2
463	30	14
463	31	14
463	32	20
464	5	15
464	6	10
464	7	18
464	22	14
464	23	6
464	33	15
465	1	20
465	3	15
465	4	0
465	9	6
465	10	9
465	11	10
466	24	12
466	27	16
466	28	8
466	29	5
467	12	3
467	13	9
467	14	10
467	5	19
467	27	0
467	28	10
467	29	15
468	28	18
468	29	4
468	9	9
468	11	19
468	21	5
468	22	1
468	23	20
469	5	11
469	6	12
469	7	10
469	8	16
469	18	11
469	20	3
470	9	8
470	10	15
470	11	2
471	1	18
471	2	7
471	3	10
471	4	6
471	12	11
471	13	13
471	14	10
472	1	16
472	2	18
472	3	4
472	9	13
621	2	1
621	3	19
621	4	14
621	5	15
621	6	18
621	7	3
621	8	6
622	18	17
622	19	19
622	20	16
622	25	12
622	26	13
623	24	6
623	25	18
623	26	7
623	33	10
623	34	18
624	33	0
624	34	20
624	35	0
624	21	10
624	22	17
625	1	20
625	2	15
625	4	9
625	9	15
625	10	5
625	11	8
626	12	17
626	13	9
626	14	19
626	15	14
626	17	7
627	12	20
627	13	17
472	11	9
472	21	5
472	22	6
472	23	10
473	35	5
473	5	16
473	6	6
473	7	5
473	8	6
474	5	9
474	6	13
474	7	20
474	8	6
474	18	16
474	19	15
474	20	7
474	9	1
474	10	1
474	11	8
475	24	11
475	25	16
475	26	13
475	1	1
475	2	5
475	4	2
475	27	1
475	28	11
475	29	19
475	21	4
475	22	8
475	23	15
476	21	10
476	22	5
476	23	20
476	18	11
476	19	5
476	20	11
477	24	20
477	25	12
477	9	20
477	10	11
477	21	11
477	22	17
477	23	10
478	27	5
478	28	5
478	29	3
478	16	8
479	21	10
479	23	10
479	33	1
479	34	17
479	35	16
480	15	19
480	16	18
480	17	10
487	33	4
487	34	5
487	35	4
488	1	2
488	2	5
488	3	19
488	4	12
488	30	1
488	31	7
488	32	20
488	22	7
488	23	15
489	18	14
489	19	17
489	5	12
489	6	13
489	8	15
489	21	16
489	22	14
489	23	18
490	30	19
490	31	5
490	18	10
490	19	13
490	27	11
490	28	14
490	29	14
490	24	19
490	25	14
490	26	11
491	31	10
491	32	9
491	33	9
491	34	11
491	35	1
491	19	16
491	20	14
491	1	15
491	2	5
491	3	4
492	21	0
492	22	0
492	23	9
492	9	17
492	10	11
492	11	0
493	24	0
493	25	6
493	26	2
493	12	3
493	13	0
493	14	14
493	30	3
493	32	7
494	16	16
494	17	18
495	2	9
495	3	18
495	4	15
652	26	14
653	18	9
653	19	1
653	20	9
653	9	20
653	10	6
653	11	18
653	12	14
653	13	5
654	9	1
654	10	1
654	11	10
654	18	20
654	19	5
654	20	15
655	12	15
655	13	6
655	14	3
655	33	3
655	34	10
655	35	3
656	24	1
656	25	5
656	26	15
656	30	4
656	31	9
656	32	10
656	22	7
656	23	20
657	27	5
657	28	18
657	29	10
657	24	5
657	25	12
658	30	0
658	31	4
495	15	8
495	16	0
495	17	13
495	5	11
495	6	2
495	7	6
495	8	12
496	3	9
496	4	17
496	18	5
496	19	13
496	20	14
496	21	13
496	22	6
496	23	17
497	10	19
497	11	4
497	30	11
497	31	5
497	32	17
497	22	3
497	23	14
498	22	0
498	23	18
498	9	1
498	10	11
498	11	0
499	3	17
499	4	15
499	5	12
499	6	1
499	7	11
499	8	7
500	33	18
500	34	15
500	35	6
500	30	19
500	31	10
500	32	19
501	15	14
501	17	2
501	22	18
501	23	16
501	18	4
501	19	6
501	33	11
501	34	9
502	21	10
502	23	9
502	16	5
502	18	11
502	20	6
503	28	8
503	29	18
503	1	4
503	2	10
503	3	11
504	31	1
504	32	13
505	30	13
505	31	17
505	32	18
505	12	20
505	14	17
505	33	11
505	34	15
505	35	8
506	21	6
506	23	4
506	18	14
506	19	7
506	20	2
507	16	5
508	18	8
508	20	9
508	1	19
508	2	17
508	3	0
508	4	7
508	33	10
515	9	7
515	10	2
515	11	14
516	24	8
516	25	16
516	28	11
516	29	16
516	15	0
516	16	7
517	30	7
517	31	4
517	32	3
518	30	11
518	31	19
518	1	15
518	2	6
518	3	11
518	4	14
518	15	3
518	16	8
518	17	2
518	24	3
518	26	1
519	24	14
519	26	0
519	28	17
519	29	20
519	21	5
519	22	3
519	23	0
520	15	11
520	16	19
520	17	10
681	8	8
682	29	8
682	25	12
682	26	3
682	1	0
682	2	1
682	3	10
682	4	0
683	18	4
683	19	11
683	21	6
684	18	3
684	19	11
684	20	6
684	24	15
685	15	5
685	16	12
685	17	17
685	1	0
685	2	2
685	3	20
686	21	1
686	23	11
686	24	13
686	25	17
686	26	12
687	12	16
687	13	16
687	15	18
687	17	18
687	1	0
687	2	19
687	3	5
687	4	8
688	30	6
688	31	8
688	32	13
688	33	20
688	34	14
689	27	14
689	28	11
689	5	17
689	6	5
689	7	10
689	8	12
689	18	15
689	20	10
690	1	4
690	2	9
690	4	8
690	7	20
690	8	18
691	1	2
691	2	20
691	3	2
691	22	20
520	29	18
521	9	17
521	11	8
521	12	10
521	14	17
521	33	7
521	35	12
522	30	4
522	31	15
522	32	4
522	1	18
522	2	7
522	3	14
522	4	7
522	15	8
522	17	1
523	24	8
523	25	11
523	26	13
523	15	17
523	16	10
523	17	9
523	27	9
523	28	4
524	5	11
524	6	11
524	8	12
524	12	14
524	13	18
524	14	1
525	21	16
525	23	1
525	33	16
525	34	5
525	35	20
525	15	3
525	16	3
525	18	10
525	19	12
525	20	15
526	18	3
526	20	16
526	28	20
526	29	15
527	18	6
527	20	0
527	24	18
527	26	10
527	22	0
527	23	4
528	6	1
528	7	10
528	27	8
528	28	6
528	29	1
528	24	16
528	26	15
529	5	14
529	8	5
529	33	10
529	34	2
529	35	5
530	9	1
530	10	7
530	11	5
530	21	11
530	22	17
530	23	16
530	33	11
530	34	20
530	35	19
531	27	18
531	28	15
531	29	14
531	24	15
711	33	15
711	34	15
711	35	0
711	15	3
711	16	14
711	17	0
712	30	10
712	31	10
712	32	9
712	6	11
712	7	2
712	8	2
712	27	14
712	28	5
712	29	4
713	16	13
713	17	9
713	24	11
713	25	16
713	26	0
713	19	8
713	20	20
714	9	17
714	10	14
714	11	13
714	30	8
714	32	18
714	12	13
714	13	13
715	24	2
531	25	10
531	30	14
531	18	11
531	19	8
532	15	11
532	16	11
532	17	5
532	24	19
532	25	4
532	26	1
532	18	15
532	19	5
532	20	4
533	26	7
533	10	18
533	15	17
533	17	17
534	12	9
534	13	2
534	14	11
534	1	1
534	3	11
534	4	8
534	27	9
534	28	10
537	23	14
538	15	20
538	16	4
538	17	15
538	18	4
538	19	3
538	33	8
538	34	13
538	35	15
539	12	18
539	13	15
539	14	6
539	21	13
539	22	3
539	23	16
539	27	18
539	28	9
540	12	3
540	13	18
540	14	2
540	33	4
540	34	0
541	24	15
541	25	0
541	26	16
541	27	10
541	28	12
541	29	5
542	12	18
542	13	14
542	14	15
542	10	11
542	11	2
543	30	7
543	31	3
543	32	13
543	28	17
543	29	3
543	15	10
543	16	20
544	12	11
544	13	10
544	14	14
544	21	4
544	22	5
544	23	18
545	5	0
545	6	5
545	8	3
545	15	20
545	16	0
545	17	16
545	33	13
545	35	11
546	27	10
546	28	19
547	5	12
547	6	8
547	7	19
547	8	13
547	15	11
547	16	7
547	17	11
548	33	14
548	34	19
548	35	10
548	27	9
548	28	2
548	29	6
549	15	18
549	16	8
549	17	7
549	12	20
549	13	5
549	24	6
549	25	14
549	26	11
550	9	3
550	10	8
550	22	15
550	23	7
550	16	9
550	17	9
551	30	15
551	31	13
551	27	6
551	28	8
551	29	13
551	9	19
551	11	3
552	12	5
552	13	16
552	14	13
552	27	8
552	28	1
552	29	4
553	5	6
553	6	15
553	7	9
738	3	19
738	4	6
738	21	2
738	22	0
738	23	13
738	12	2
738	13	10
739	21	4
739	22	4
739	23	8
739	12	19
739	13	2
739	14	10
739	27	0
739	28	18
739	29	15
740	15	19
740	16	9
740	17	7
740	21	14
740	22	2
740	23	6
741	1	4
741	2	4
741	3	18
741	4	5
741	21	7
741	22	8
741	23	12
742	5	15
742	6	9
742	7	20
742	30	8
742	31	7
553	8	9
553	1	15
553	2	2
553	3	11
553	25	11
554	9	12
554	10	17
554	11	0
554	5	4
554	6	20
554	7	6
554	8	5
554	30	18
554	31	9
554	32	11
555	1	9
555	2	11
555	3	19
555	4	1
555	12	7
555	13	17
555	5	13
555	6	11
555	7	3
555	8	18
555	15	11
555	16	1
555	17	1
556	24	9
556	25	0
556	26	16
557	12	20
557	13	14
557	14	9
558	1	15
558	4	8
558	24	12
558	25	9
558	26	6
558	33	11
558	34	18
558	35	19
558	5	15
558	6	19
558	7	16
558	8	16
559	13	0
559	14	16
559	15	1
559	16	12
559	17	3
559	19	5
559	20	8
560	24	18
560	26	19
560	9	16
560	10	4
560	11	6
560	21	17
560	22	7
560	23	6
561	27	17
561	28	2
561	12	7
561	13	13
561	14	17
568	28	2
568	29	14
568	33	16
568	5	16
568	6	18
568	7	15
569	15	8
569	16	7
569	17	5
569	5	7
569	6	13
569	7	3
570	5	0
570	6	7
570	7	20
570	8	18
570	9	5
570	18	0
570	19	14
570	20	0
571	12	9
571	13	9
571	30	4
571	32	10
571	9	20
571	10	2
571	11	1
572	21	19
572	23	4
573	5	9
573	8	11
573	24	15
573	26	15
573	14	3
573	28	4
574	12	3
574	24	3
574	25	3
574	26	20
574	1	15
574	2	4
574	3	14
574	4	19
575	27	17
575	28	18
575	9	9
575	10	16
575	11	6
576	9	16
576	10	0
767	22	19
767	23	0
767	1	10
767	2	2
767	3	10
767	4	8
767	27	1
767	28	10
768	9	1
768	27	10
768	28	15
768	29	8
768	1	12
768	2	14
768	4	2
769	1	16
769	3	17
769	4	18
769	5	15
769	7	17
769	24	0
769	25	6
769	26	14
770	5	11
770	7	19
770	8	7
770	27	16
770	13	7
770	14	11
771	5	9
771	6	3
771	8	5
771	18	16
771	19	9
771	12	14
771	13	8
771	14	15
771	21	1
771	23	16
772	5	15
772	6	1
772	8	17
772	27	2
772	28	11
772	29	17
576	11	6
576	12	20
576	13	14
576	30	11
576	31	3
576	32	12
576	18	6
576	20	9
577	9	3
577	10	15
577	11	19
578	27	10
578	29	1
578	18	19
578	20	5
579	18	5
579	19	18
579	20	2
579	24	15
579	26	3
579	2	3
579	3	17
579	4	11
580	30	0
580	31	0
580	32	11
580	33	7
580	34	0
580	35	2
580	22	14
580	23	18
580	9	5
580	10	12
580	11	10
581	33	0
581	24	6
581	25	11
581	26	20
582	33	3
582	35	1
582	30	5
582	31	9
582	32	13
582	27	12
582	28	5
582	29	20
583	27	0
583	28	12
583	29	6
583	18	5
583	19	19
583	12	4
583	14	19
584	24	14
584	34	18
584	35	8
585	21	2
585	22	6
585	23	8
585	15	7
585	16	11
585	17	8
586	30	12
586	31	11
586	32	11
586	2	3
586	3	18
586	4	13
587	21	15
587	23	18
587	19	18
587	20	20
587	9	2
587	10	13
587	11	4
588	20	0
588	12	20
588	13	0
588	14	4
588	27	8
588	28	19
588	29	19
589	29	19
589	21	20
589	22	14
597	23	2
598	21	12
598	22	15
598	23	20
598	9	5
598	10	8
598	11	16
599	5	15
599	6	13
599	8	16
599	21	12
793	35	13
793	22	4
793	10	1
793	11	13
794	5	7
794	6	7
794	8	7
794	18	3
794	19	20
794	20	12
795	9	6
795	10	13
795	11	9
795	30	5
795	31	5
795	32	13
795	21	0
795	22	19
795	23	5
796	33	17
796	34	15
796	35	8
797	18	10
797	20	7
797	30	16
797	32	15
798	9	6
798	10	17
798	11	1
799	9	14
799	10	5
799	11	3
799	21	9
799	22	19
799	23	4
799	24	18
799	25	19
599	22	3
599	23	20
599	1	3
599	2	14
600	18	4
600	19	19
600	20	1
600	5	0
600	6	4
600	7	9
600	8	8
600	15	18
600	16	2
600	17	3
601	12	11
601	13	4
601	14	5
601	24	9
601	25	8
601	26	13
601	23	12
602	19	8
602	20	16
602	9	17
602	11	20
603	24	13
604	21	12
604	23	15
604	1	8
604	2	3
604	3	11
604	4	13
604	9	15
604	11	11
605	33	18
605	34	18
605	35	8
605	21	0
605	22	20
605	23	8
605	18	12
605	20	19
605	1	13
605	2	17
605	3	8
605	4	7
606	28	13
606	29	6
607	12	18
607	13	11
607	14	1
607	31	0
607	32	7
608	33	0
608	34	1
608	35	18
608	30	9
608	31	19
608	32	14
608	27	20
608	28	17
608	29	5
609	27	4
609	29	10
609	33	16
609	35	4
610	6	1
610	7	16
610	31	14
610	32	7
610	24	9
610	25	14
610	26	2
611	6	13
611	7	6
611	8	13
611	18	3
611	19	4
611	20	18
612	15	11
612	16	5
612	17	18
612	9	12
612	10	6
612	11	2
612	21	15
612	22	4
612	23	7
613	27	13
613	28	17
613	29	7
613	24	20
613	25	0
613	26	19
613	6	5
613	7	0
613	8	6
613	12	6
613	14	20
615	17	12
615	8	9
616	15	11
616	16	7
616	17	11
616	30	12
616	31	4
616	32	13
617	5	18
617	6	17
617	7	17
617	8	20
823	12	12
823	13	12
823	14	8
823	18	19
823	19	8
823	20	2
823	9	14
823	10	11
823	11	11
824	27	6
824	28	10
824	30	3
824	32	12
825	19	20
825	20	10
825	30	4
825	31	0
825	32	0
825	21	5
825	22	13
825	23	5
825	12	15
825	14	4
826	9	3
826	10	2
826	11	11
827	1	7
827	4	17
827	6	7
827	8	15
828	27	1
828	28	17
828	29	8
828	30	7
828	32	3
829	35	16
829	12	9
829	13	18
829	10	9
829	11	3
829	25	3
829	26	16
617	18	6
617	20	6
618	2	5
618	4	20
618	12	3
618	14	18
619	22	16
619	23	17
620	1	19
620	2	6
620	3	6
620	4	12
621	1	5
627	14	17
627	24	3
627	25	0
627	15	20
627	16	19
627	17	12
628	21	16
628	23	10
628	5	14
628	6	14
628	7	20
628	18	13
628	19	2
628	20	18
628	30	16
628	31	9
628	32	5
629	18	12
629	20	4
629	30	6
629	32	17
629	1	18
629	2	8
629	3	17
629	4	1
630	33	4
630	34	17
630	35	11
630	3	18
630	4	7
630	6	3
630	7	2
630	8	20
631	12	1
631	13	4
631	14	14
631	24	11
631	25	14
631	26	18
632	18	18
632	19	10
632	20	8
632	24	13
632	25	6
632	9	16
632	11	16
633	24	14
633	25	9
633	26	3
634	15	14
634	16	12
634	17	17
634	33	14
634	35	18
635	9	14
635	10	5
635	12	6
635	13	3
635	14	5
636	2	15
636	3	5
636	4	18
637	21	4
637	22	11
637	23	10
637	27	14
637	28	9
638	18	2
638	20	18
639	24	2
639	1	18
639	2	4
639	3	6
639	4	0
639	5	2
639	6	10
639	7	9
639	8	2
640	9	11
640	10	10
640	11	2
641	33	10
641	34	12
641	35	20
641	12	14
641	13	12
641	14	2
642	5	18
852	7	5
852	8	10
852	15	10
852	16	13
853	34	11
853	12	4
853	13	17
853	14	5
853	15	20
853	17	2
854	30	6
854	31	3
854	32	3
854	12	8
854	13	20
854	14	6
854	1	14
854	2	11
854	3	10
854	4	1
854	24	11
854	25	14
854	26	13
855	9	2
855	10	14
855	2	19
855	3	2
855	33	8
855	34	7
855	35	20
856	33	0
856	34	3
856	12	14
856	13	8
856	14	18
856	5	6
856	6	9
856	8	12
857	22	7
857	23	15
857	6	5
857	7	18
857	8	5
857	24	18
857	26	6
642	6	1
642	7	13
642	8	19
643	23	16
643	27	8
643	28	4
643	29	16
644	12	20
644	5	12
644	6	20
644	7	8
644	8	17
645	27	4
645	28	17
645	29	20
645	12	20
645	13	10
645	14	9
645	15	16
645	16	7
645	17	5
645	10	13
645	11	5
646	21	9
646	23	18
646	33	15
646	34	15
646	35	2
647	2	1
647	3	2
647	4	3
647	9	12
647	11	17
647	30	9
647	31	18
648	33	9
648	34	6
648	35	19
648	24	19
648	25	3
648	26	18
648	9	18
648	10	10
648	11	14
649	31	8
649	32	9
649	33	4
649	34	13
649	35	16
650	5	11
650	6	12
650	7	2
650	8	0
650	24	19
650	25	9
650	26	13
651	30	18
651	12	19
651	13	19
651	14	14
651	3	3
651	4	18
652	24	3
652	25	18
658	32	18
659	24	2
659	25	5
659	1	5
659	2	20
659	4	5
660	21	9
660	22	15
660	23	13
660	1	20
660	2	12
660	4	5
661	1	3
661	2	6
661	3	1
661	4	19
661	21	14
661	22	6
661	23	20
662	30	16
662	31	9
662	32	12
662	28	3
662	29	6
662	33	12
662	34	3
662	35	2
663	24	2
663	25	5
663	26	0
663	5	12
663	6	4
882	33	14
882	2	2
882	3	8
882	4	5
883	18	7
883	20	13
883	27	16
883	28	16
883	29	17
884	33	9
884	35	9
884	24	15
884	25	7
884	26	4
885	21	10
885	22	12
885	23	19
885	5	5
885	6	8
885	7	15
885	8	16
885	33	16
885	34	20
885	35	18
886	33	6
886	34	10
886	35	17
886	12	7
886	13	14
886	27	9
886	28	0
886	29	20
886	22	11
886	23	13
887	12	5
887	13	1
887	14	4
887	33	17
663	8	7
663	18	1
663	19	2
663	20	14
663	1	4
663	3	18
663	4	9
664	25	18
664	30	10
664	32	15
664	1	5
664	2	3
664	3	8
665	21	15
665	22	1
665	23	0
665	10	15
665	11	4
666	30	3
666	31	18
666	32	1
666	15	8
666	16	15
666	10	11
666	33	2
666	35	11
667	21	4
667	22	16
667	23	2
667	5	18
667	6	20
667	7	1
667	8	5
668	12	6
668	13	15
668	14	0
668	9	7
668	10	2
668	11	20
669	18	10
669	19	19
669	20	6
669	21	4
670	5	15
670	6	17
670	8	16
670	9	15
670	10	12
670	11	1
670	21	9
670	22	16
670	23	1
670	30	16
670	31	14
670	32	17
671	18	18
671	19	6
671	20	15
672	24	0
672	25	8
672	26	1
672	12	3
672	14	17
673	5	14
673	6	5
673	15	2
673	16	7
673	17	17
673	27	14
673	29	5
674	12	16
674	13	0
674	14	2
674	9	19
674	10	19
674	11	14
675	18	7
675	19	5
675	20	1
675	30	1
675	31	5
675	16	18
675	17	11
676	24	1
676	25	3
676	26	1
676	33	1
676	34	16
676	35	19
676	18	5
676	19	2
677	1	2
677	2	6
677	3	6
677	9	16
677	10	12
678	16	20
678	17	8
678	27	16
678	29	20
678	30	13
679	15	15
679	16	5
679	27	11
679	28	14
679	29	15
679	5	14
679	6	2
679	7	18
909	11	5
909	23	14
910	21	14
910	22	9
910	23	10
910	1	18
910	2	4
910	3	19
910	4	14
911	18	5
911	19	15
911	20	4
911	6	20
911	7	20
911	8	8
912	13	3
912	14	6
912	33	4
912	34	6
912	35	9
912	15	0
912	17	1
913	5	17
913	6	14
913	7	3
913	8	13
913	33	14
913	34	7
913	35	15
914	24	4
914	22	15
914	9	3
914	10	6
914	11	14
914	19	0
914	20	3
915	12	2
915	30	19
915	31	12
915	32	12
679	8	8
680	24	4
680	25	10
680	26	5
680	10	20
680	11	19
681	1	5
681	5	0
681	6	19
691	23	18
691	6	13
691	7	10
691	8	14
692	32	4
692	1	12
692	2	20
692	3	3
692	4	5
693	34	6
693	31	9
693	32	1
693	19	9
693	9	1
693	10	18
693	11	1
694	25	0
694	26	3
694	31	20
695	13	9
695	14	17
695	10	4
695	11	4
695	15	6
695	16	12
695	17	7
696	1	1
696	2	10
696	3	14
696	16	14
696	17	14
696	21	3
696	22	3
696	23	7
697	10	19
697	11	16
697	21	15
697	23	2
698	31	11
698	32	11
699	10	0
699	15	4
699	16	14
700	31	16
700	32	3
700	9	2
700	11	5
700	1	20
700	2	1
700	3	3
700	4	5
701	9	18
701	10	5
701	24	4
701	26	12
702	13	5
702	14	4
702	30	15
702	32	10
702	27	8
702	28	11
702	29	6
703	15	0
703	16	13
703	13	20
703	14	5
703	22	9
703	23	10
704	5	20
704	6	12
704	7	12
704	8	11
704	9	2
704	10	0
705	24	9
705	25	20
705	26	16
705	22	6
705	23	8
706	33	13
706	34	0
706	35	18
706	9	1
706	10	15
706	11	3
707	5	5
707	6	11
707	8	2
707	25	16
707	26	9
707	10	2
708	25	18
708	26	18
708	33	4
708	35	2
709	1	14
936	15	17
937	18	7
937	19	3
937	31	3
937	32	13
938	19	2
938	28	11
938	29	16
939	33	13
939	34	10
939	35	12
939	30	5
939	31	19
940	1	4
940	3	19
940	4	4
940	5	17
940	6	6
940	8	9
941	24	15
941	33	17
941	35	14
942	18	19
942	19	14
942	33	13
942	35	3
943	9	3
943	10	8
943	24	11
943	26	14
944	24	7
944	25	10
944	33	0
944	35	5
944	9	20
944	10	18
944	11	14
944	15	19
944	17	5
945	15	11
709	2	3
709	3	5
709	4	14
709	13	4
709	14	9
710	33	19
710	35	6
710	22	2
710	23	10
711	6	9
711	7	3
711	8	15
715	25	11
715	26	15
715	15	1
715	16	7
715	17	12
716	15	6
716	16	12
716	17	9
717	18	6
717	19	19
717	20	16
717	9	9
717	10	0
717	11	20
717	5	11
717	6	7
717	27	12
717	28	2
717	29	14
718	16	0
718	17	16
718	33	7
718	34	12
718	35	18
718	9	14
718	11	0
718	12	13
718	13	9
718	14	4
719	33	5
719	34	17
719	35	7
719	15	15
719	16	15
719	24	4
719	25	17
719	26	2
720	24	0
720	25	0
720	26	13
720	5	15
720	6	15
720	7	20
720	8	3
720	15	14
720	17	20
721	27	6
721	28	6
721	29	12
721	30	18
721	31	4
721	21	18
721	23	5
722	22	7
722	23	11
722	15	5
722	17	11
723	6	18
723	7	4
723	8	11
723	12	19
723	13	2
723	14	17
724	15	5
724	16	1
724	17	16
724	33	0
724	34	2
724	35	20
725	15	13
725	16	16
725	5	14
725	6	17
725	7	18
725	8	14
726	2	19
726	3	3
726	4	1
726	12	20
726	13	19
726	14	18
727	15	14
727	16	1
727	17	20
727	33	9
727	34	14
727	35	20
727	6	18
728	1	0
728	3	7
728	4	19
728	21	8
728	22	16
964	32	2
964	1	18
964	2	18
964	3	15
964	4	13
964	33	0
964	34	6
964	35	10
965	5	0
965	6	1
965	7	6
965	8	7
966	22	14
966	23	15
966	1	2
966	3	16
966	4	20
966	30	0
966	31	3
966	32	2
967	29	15
967	17	7
968	27	11
968	28	20
968	29	11
968	18	17
968	19	4
968	20	15
968	13	14
969	33	4
969	34	18
969	35	11
969	12	10
969	13	11
969	14	4
969	2	1
969	3	5
970	27	11
970	28	17
970	29	4
728	23	4
728	15	6
728	16	14
728	17	20
729	5	10
729	6	10
729	7	4
729	8	7
729	12	1
729	13	4
729	14	13
729	30	20
729	31	11
729	32	2
730	12	19
730	13	2
730	14	5
730	24	10
730	25	5
730	26	20
731	21	3
731	22	10
731	23	13
731	5	18
731	6	9
731	7	10
731	8	9
732	12	10
732	13	17
732	14	14
732	27	19
732	28	20
732	29	0
732	24	7
732	26	6
733	14	8
733	16	3
733	17	20
733	9	10
733	10	2
733	30	3
733	32	13
734	27	0
734	28	14
734	29	11
734	15	16
734	16	14
734	17	11
734	9	0
734	10	20
734	11	2
735	1	7
735	2	20
735	3	8
735	4	5
735	25	17
735	26	10
735	21	13
735	22	1
735	23	20
736	27	19
736	28	5
736	29	5
736	9	17
736	10	20
737	30	14
737	31	3
737	24	8
737	25	2
738	1	14
742	32	7
743	21	13
743	23	12
743	9	9
743	10	13
743	11	19
743	33	7
743	34	20
743	35	17
744	27	20
744	29	17
744	5	20
744	6	16
744	7	13
744	8	13
745	27	10
745	29	8
745	24	14
745	25	16
746	18	12
746	19	17
746	12	3
746	13	17
746	14	16
747	1	11
747	2	20
747	3	4
747	12	2
747	13	5
747	14	12
748	9	2
748	21	16
748	23	14
749	18	2
749	19	5
994	12	19
994	14	19
995	13	15
995	14	7
995	15	1
995	16	15
995	17	18
995	27	20
995	28	2
995	29	16
996	24	5
996	25	20
996	26	5
996	9	3
996	10	14
996	11	7
996	18	3
996	20	20
997	21	15
997	22	7
997	23	15
997	3	18
997	4	14
997	27	20
997	29	16
997	25	16
997	26	1
998	27	20
998	28	20
998	29	13
999	21	7
999	23	8
999	27	9
999	28	1
999	29	10
999	5	2
999	6	7
999	7	17
1000	18	0
1000	19	9
1000	20	10
1000	9	12
1000	10	8
1000	11	2
1000	5	2
1000	6	17
1000	7	1
749	20	18
749	30	8
749	31	0
750	16	3
750	17	3
750	22	5
750	23	8
750	33	0
750	35	15
751	13	19
751	14	20
751	15	9
751	16	20
751	17	2
752	18	3
752	19	19
752	20	10
752	12	6
752	13	5
752	33	7
752	35	16
753	27	0
753	29	2
753	15	11
753	16	12
753	17	10
753	1	3
753	3	13
753	4	3
754	1	11
754	2	7
754	4	13
754	27	6
754	29	17
754	19	14
754	20	20
755	24	14
755	25	7
755	26	16
755	30	5
755	31	1
755	32	0
755	9	6
755	10	0
755	11	1
755	21	17
755	22	20
755	23	13
756	30	17
756	31	12
756	32	2
756	29	7
756	9	20
756	10	0
757	10	10
757	11	1
757	1	3
757	2	2
757	4	20
757	27	13
757	28	6
757	29	12
758	24	3
758	25	18
758	26	15
758	21	0
758	23	3
758	27	20
758	29	18
759	21	12
759	22	16
759	23	17
759	5	17
759	6	16
759	7	14
759	8	17
760	18	17
760	19	2
760	20	10
760	34	1
760	35	6
761	27	5
761	28	5
761	29	3
761	18	15
761	19	19
761	20	19
761	1	14
761	2	7
761	4	3
762	30	6
762	31	19
32	5	18
762	32	19
763	9	12
763	11	16
763	33	3
763	34	4
763	35	8
763	24	2
763	25	2
763	30	18
763	31	11
763	32	19
764	13	17
764	14	4
764	31	8
765	24	1
765	25	9
765	26	14
765	21	0
765	22	7
765	23	6
766	25	15
766	26	11
766	1	11
766	2	1
766	3	14
766	4	18
767	21	20
772	30	7
772	32	9
773	33	6
773	34	5
773	35	16
773	26	13
773	1	17
773	2	16
773	3	13
774	18	7
774	19	5
774	20	10
774	1	3
774	2	3
774	4	16
774	21	10
774	22	5
774	23	3
775	30	0
775	31	0
775	32	14
776	34	7
776	35	14
776	21	13
776	22	19
777	12	19
777	14	18
777	18	17
777	19	17
777	27	12
777	28	6
777	29	11
778	33	17
778	34	8
779	30	12
779	31	0
779	32	7
779	2	9
779	3	7
779	4	6
780	27	3
780	28	17
780	24	1
780	25	19
780	15	16
780	16	9
780	17	4
780	5	12
780	6	15
781	27	13
781	29	3
781	12	0
781	13	8
781	14	16
781	26	4
782	9	7
782	11	18
782	21	3
782	22	17
782	23	5
783	33	3
783	34	14
783	35	17
783	31	20
783	32	8
783	15	19
783	16	5
783	17	14
783	1	5
783	2	12
783	4	20
784	18	10
784	19	9
784	20	10
784	15	16
784	17	8
784	12	13
784	14	6
785	24	0
785	25	11
785	26	0
785	16	0
785	17	7
786	27	12
786	29	2
786	2	12
786	3	20
787	30	17
787	32	11
787	24	3
787	25	5
787	1	4
787	2	0
787	3	4
787	4	1
788	33	12
788	34	7
788	35	9
788	5	13
788	8	4
788	30	10
788	31	3
788	32	12
789	27	2
789	28	18
789	29	19
789	9	3
789	11	12
789	30	20
789	32	1
790	29	16
790	15	16
790	16	14
790	17	9
791	21	8
791	22	13
791	23	7
791	9	8
791	10	12
791	11	0
791	12	16
791	13	3
791	14	14
792	24	6
792	25	17
792	26	6
792	21	18
792	22	12
792	23	0
793	33	11
793	34	11
799	26	17
800	31	17
800	32	11
800	5	0
800	6	0
800	7	10
800	22	19
800	23	7
800	11	7
801	30	6
801	31	9
801	18	20
801	19	16
801	20	6
802	30	14
802	32	11
802	10	3
802	11	18
802	21	9
802	22	19
802	23	6
803	5	1
803	6	12
803	7	15
803	8	12
803	12	13
803	14	15
804	15	18
804	16	15
804	17	6
804	13	6
804	14	14
804	21	19
804	22	14
804	23	17
805	27	0
805	21	10
805	22	18
805	23	2
805	9	11
805	11	7
806	30	0
806	32	4
806	1	10
806	4	20
807	10	4
807	1	19
807	2	10
807	3	7
807	4	16
808	9	11
808	10	4
808	11	20
808	12	4
808	13	11
808	14	6
809	24	5
809	26	2
810	24	20
810	25	13
810	19	10
811	12	16
811	13	0
811	14	14
812	1	8
812	2	14
812	3	12
812	4	4
812	9	2
812	10	15
812	11	15
813	9	10
813	10	4
813	11	14
813	1	4
813	3	10
813	30	7
813	31	10
813	32	5
814	27	15
814	28	3
814	29	17
814	20	17
815	15	6
815	16	5
815	17	7
815	27	5
815	29	18
816	1	14
816	2	0
816	3	13
816	4	3
816	34	15
816	35	10
816	27	17
816	28	6
816	29	7
817	18	5
817	19	3
817	20	8
817	10	5
817	15	5
817	16	19
818	21	3
818	22	17
818	23	14
818	18	20
818	19	3
818	20	18
818	9	9
818	10	9
818	11	19
819	18	2
819	19	4
819	20	8
819	12	8
819	14	3
819	5	5
819	6	6
819	7	5
819	15	17
819	16	4
819	17	19
820	30	10
820	31	12
820	32	18
820	1	16
820	2	7
820	4	2
820	24	12
820	25	7
820	26	14
821	18	11
821	19	1
821	20	20
821	30	1
821	31	3
821	32	16
821	28	10
821	29	9
822	9	4
822	10	11
822	11	16
822	12	8
822	13	20
822	14	1
822	33	2
822	34	16
830	18	5
830	19	19
830	20	4
831	28	13
831	29	4
832	18	17
832	20	6
832	12	14
832	14	6
832	1	19
832	2	15
832	3	1
833	33	8
833	34	17
833	12	18
833	13	0
833	14	1
833	30	19
833	31	4
833	32	8
834	2	7
834	3	12
834	4	5
834	18	17
834	19	14
834	20	20
834	24	8
834	25	18
834	26	6
835	15	2
835	16	6
835	17	5
835	9	16
835	10	14
835	11	9
836	9	7
836	10	1
836	33	16
836	34	6
836	35	20
836	12	9
836	13	16
836	14	6
836	16	6
836	17	5
837	33	12
837	35	11
837	14	5
838	27	7
838	28	20
838	29	18
838	9	20
838	11	0
839	9	7
839	10	18
839	12	8
839	13	16
839	14	1
839	33	8
839	34	11
839	35	20
840	1	11
840	2	10
840	3	13
840	4	5
840	18	13
840	20	6
841	1	15
841	3	12
841	4	15
841	5	14
841	6	20
841	7	19
841	8	10
842	27	5
842	28	20
842	29	0
842	33	13
842	34	6
842	21	15
842	23	14
843	27	8
843	28	7
844	24	7
844	25	4
844	5	5
844	6	13
844	8	6
845	21	9
845	22	15
845	23	20
845	1	10
845	2	18
845	3	11
845	4	16
845	33	12
845	35	11
846	33	16
846	34	11
846	35	11
846	5	1
846	6	0
846	8	4
847	27	10
847	28	7
847	29	14
847	12	0
847	13	8
847	14	19
848	33	20
848	34	7
848	35	4
848	12	8
848	13	6
848	21	4
848	22	18
849	33	11
849	34	4
849	35	1
849	30	7
850	15	18
850	16	2
850	19	4
850	20	13
850	21	16
850	22	7
850	27	9
851	16	16
851	17	15
851	33	5
851	34	15
851	35	0
852	18	15
852	19	2
852	20	0
852	5	11
852	6	4
858	33	6
858	35	15
858	5	7
858	6	1
859	24	10
859	25	6
859	9	15
859	10	9
859	11	20
860	9	17
860	1	11
860	3	15
861	22	0
861	23	10
861	27	1
861	28	4
861	29	10
862	27	4
862	28	18
862	29	5
862	33	14
862	34	13
862	35	2
863	33	18
863	34	8
863	35	10
863	30	17
863	22	11
863	23	16
864	9	13
864	10	0
864	11	13
864	31	19
864	6	18
864	8	5
865	12	19
865	13	17
865	14	8
865	25	1
866	33	6
866	34	15
866	35	9
866	15	4
866	16	9
866	27	15
866	29	6
866	5	18
866	6	13
866	7	13
867	15	20
867	16	19
867	17	12
867	27	10
867	28	9
867	29	18
868	18	4
868	20	5
868	1	6
868	2	5
868	3	4
868	4	14
869	30	1
869	32	13
869	12	11
869	14	13
870	30	3
870	31	16
870	32	1
870	24	8
870	25	9
871	15	2
871	16	17
871	17	18
871	12	18
871	13	5
871	14	17
872	9	15
872	10	19
872	11	12
872	15	13
872	17	16
873	32	13
873	15	4
873	16	10
873	5	6
873	6	20
873	7	8
873	8	16
873	33	10
873	34	7
874	15	0
874	16	10
874	17	2
874	27	0
874	28	5
874	29	12
874	10	14
874	11	1
875	18	1
875	19	13
875	20	20
876	18	3
876	19	13
876	20	10
876	27	20
877	24	2
877	25	14
877	26	7
877	15	18
877	16	2
877	17	14
878	18	2
878	19	11
878	20	20
878	1	14
878	2	20
878	4	2
879	9	3
879	10	11
879	11	4
879	24	13
879	25	20
879	26	17
880	30	8
880	31	11
880	32	0
881	12	19
881	33	4
881	35	0
882	21	20
882	23	5
887	34	8
887	35	12
887	18	6
887	19	3
887	24	15
887	26	4
888	21	2
888	22	3
888	23	3
888	27	20
888	28	7
888	29	1
889	18	14
889	19	1
889	20	4
889	5	17
889	6	6
890	5	3
890	6	14
890	7	17
890	8	1
890	27	14
890	28	1
890	29	20
891	18	0
891	19	4
891	21	4
891	22	10
891	23	3
892	9	19
892	10	13
892	11	10
892	5	2
892	6	14
892	7	11
892	8	2
892	22	12
892	23	14
893	28	20
893	29	3
893	21	18
893	22	15
893	23	9
893	9	9
893	10	18
893	11	1
894	15	9
894	17	5
894	9	4
894	10	14
894	11	9
894	1	4
894	2	4
894	4	8
895	1	17
895	2	3
895	4	17
895	27	0
895	28	2
895	29	2
896	15	0
896	16	2
896	17	17
896	12	15
896	13	1
897	9	9
897	10	0
897	11	14
897	21	20
898	16	18
899	15	11
899	16	1
899	17	16
899	5	1
899	6	14
899	7	17
899	18	6
899	19	9
900	17	8
900	12	19
900	13	15
900	14	13
901	5	1
901	7	1
901	8	1
901	13	4
901	14	8
901	26	6
902	18	9
902	19	11
902	20	13
902	27	5
902	28	7
902	29	14
902	24	7
902	25	1
902	26	16
902	33	2
902	34	13
902	35	0
903	33	17
903	34	5
903	35	0
903	30	18
903	18	20
903	20	11
904	33	19
904	34	6
904	35	18
905	18	9
905	20	3
905	22	19
905	23	20
905	5	20
905	6	11
905	7	9
905	8	18
905	24	2
905	26	12
906	5	17
906	6	20
906	7	15
906	8	20
906	18	7
906	20	1
906	2	19
906	3	17
906	4	11
906	10	19
906	11	9
907	18	0
907	19	12
907	20	6
908	12	19
908	13	4
908	14	10
908	1	11
908	2	0
908	33	5
908	34	14
908	35	3
909	5	7
909	6	12
909	7	1
909	9	20
909	10	17
916	27	16
916	28	0
916	29	14
916	15	8
916	16	0
917	27	7
917	28	5
917	29	0
917	33	3
917	34	2
917	35	4
918	18	15
918	19	2
918	25	15
918	12	14
918	13	3
918	14	5
919	24	18
919	25	1
919	26	10
919	34	14
919	35	1
919	27	10
919	28	10
919	29	0
920	18	9
920	19	4
920	20	17
920	27	15
920	28	14
920	29	10
920	15	19
920	16	9
920	17	2
920	30	17
920	31	4
920	32	4
921	33	15
921	34	18
921	35	0
921	24	7
921	26	13
921	5	0
921	6	12
921	8	16
922	10	19
922	11	18
922	25	2
922	26	6
923	33	7
923	34	5
923	21	12
923	22	10
923	23	15
924	27	1
924	28	1
924	29	13
924	2	8
924	3	2
924	4	17
924	26	20
925	9	2
925	10	8
925	25	2
925	26	4
926	18	20
926	19	3
926	33	15
926	35	9
926	16	3
926	17	3
927	27	15
927	28	5
927	29	20
927	9	20
927	10	4
927	11	20
927	1	9
927	2	5
927	4	2
928	10	11
928	11	20
928	21	9
928	22	17
928	5	8
928	6	11
928	8	19
929	22	9
929	23	10
929	6	7
929	7	16
929	8	1
930	27	6
930	29	19
930	1	9
930	2	14
930	3	15
930	4	13
930	30	6
930	31	8
930	32	14
931	15	8
931	16	15
931	17	11
931	24	5
931	25	11
931	26	3
931	18	8
931	19	20
931	20	8
932	12	7
932	13	19
932	16	20
932	17	1
933	15	13
933	16	0
933	17	6
933	1	4
933	2	11
933	3	1
933	27	18
933	28	19
933	29	3
934	10	3
934	11	15
934	15	16
934	16	19
935	30	17
935	31	18
935	32	2
935	5	10
935	6	20
935	7	6
935	8	12
935	1	20
935	2	1
935	3	0
935	4	0
936	11	3
936	24	6
936	25	3
945	17	13
945	24	9
945	25	16
946	15	15
946	16	1
946	17	18
946	2	7
946	3	18
946	4	2
946	25	7
946	26	0
947	27	1
947	28	16
947	29	15
947	21	0
947	22	11
947	23	19
947	19	18
947	20	12
947	2	9
947	3	8
947	4	9
948	9	17
948	10	17
948	11	17
948	27	16
948	28	9
948	29	14
948	21	15
948	22	10
948	23	4
949	15	10
949	16	0
949	17	13
950	18	8
950	19	5
950	20	15
950	30	9
950	31	0
950	32	3
950	33	20
950	34	5
950	35	19
951	21	19
951	22	1
951	23	0
951	18	10
951	19	16
951	20	14
951	1	4
951	2	6
951	3	20
951	4	13
952	18	2
952	1	4
952	2	10
952	3	16
952	4	12
953	15	2
953	16	13
953	17	16
953	24	12
953	25	2
954	21	5
954	22	0
954	23	18
954	10	20
954	11	16
954	12	20
954	13	13
954	14	18
954	24	2
954	25	0
954	26	2
955	1	1
955	2	5
955	3	9
955	4	18
955	34	3
955	35	3
955	5	3
955	6	14
955	7	6
955	8	9
955	28	5
955	29	8
956	28	17
956	29	5
956	25	1
956	26	12
956	12	9
956	14	2
957	21	17
957	22	16
957	23	1
958	21	11
958	22	4
958	23	3
958	12	1
958	14	10
958	15	13
958	16	18
959	28	20
959	29	19
959	30	7
959	31	19
959	32	10
959	1	5
959	3	14
960	27	3
960	28	4
960	29	5
960	5	9
960	6	19
960	7	5
960	8	10
960	21	14
960	22	8
960	23	15
961	15	6
961	16	4
961	17	10
961	27	13
961	29	1
962	9	7
962	10	14
962	11	0
962	33	3
962	34	15
962	12	6
962	13	5
962	14	20
962	27	6
962	28	5
963	5	19
963	7	0
963	8	19
963	22	20
963	23	16
964	30	3
964	31	8
970	14	10
970	18	0
970	19	2
970	20	3
971	18	8
971	19	10
971	21	7
972	27	2
972	28	2
972	29	19
972	5	10
972	6	2
972	8	13
973	1	4
973	2	11
973	4	4
973	21	17
973	23	12
973	12	15
973	13	0
974	18	7
974	19	5
974	20	15
974	5	10
974	6	4
974	7	7
974	8	20
975	21	10
975	23	6
975	9	11
975	10	4
976	5	13
976	6	1
976	7	15
976	8	3
976	16	12
976	17	4
976	19	9
977	33	3
977	34	1
977	35	15
977	18	20
977	20	17
977	16	8
977	17	1
978	18	19
978	20	10
978	27	4
978	29	10
979	21	0
979	22	5
979	23	9
979	19	10
979	20	17
979	24	12
979	26	12
980	21	10
980	22	16
980	27	16
980	28	20
980	29	12
981	1	8
981	3	8
981	4	4
981	15	20
981	17	18
981	33	7
981	34	16
981	35	18
982	30	0
982	31	20
982	32	4
982	21	2
982	23	7
983	28	7
983	29	11
983	13	10
983	14	12
984	24	11
984	25	18
984	26	8
984	12	14
984	13	1
984	14	15
985	21	7
985	22	19
985	23	1
985	34	7
985	35	7
986	18	15
986	20	15
986	24	14
986	25	11
986	26	8
987	18	18
987	19	16
987	20	7
987	24	3
987	25	1
987	26	3
987	33	1
987	34	17
987	35	3
988	9	20
988	10	15
988	11	2
989	15	1
989	16	17
989	17	9
989	24	3
989	25	3
989	26	15
990	18	12
990	19	1
990	20	13
990	27	13
990	28	10
990	29	6
990	5	20
990	6	15
990	7	7
990	8	19
991	6	3
991	7	11
991	8	19
991	9	4
991	11	7
992	21	16
992	22	16
992	23	18
992	26	19
992	33	15
992	34	16
992	35	5
993	31	15
993	32	6
993	9	4
993	11	19
994	6	7
994	7	13
994	8	5
1000	8	16
1001	27	13
1001	28	5
1001	18	3
1001	19	2
1001	20	2
1002	18	4
1002	20	20
1002	1	13
1002	3	9
1002	12	18
1002	13	15
1002	14	1
1003	3	19
1003	4	8
1003	27	7
1003	28	19
1003	29	9
1004	27	1
1004	29	14
1004	18	15
1004	19	17
1004	20	15
1005	15	3
1005	16	15
1005	17	9
1005	21	14
1005	22	11
1005	23	11
1005	7	12
1005	8	12
1006	16	9
1006	17	1
1006	12	4
1006	13	13
1007	15	20
1007	16	13
1007	17	5
1007	30	10
1007	31	1
1007	32	11
1007	21	16
1007	22	17
1007	23	15
1008	15	16
1008	16	10
1008	17	1
1008	5	20
1008	6	3
1008	7	4
1009	30	1
1009	32	18
1010	1	15
1010	2	16
1010	4	13
1010	30	17
1010	31	17
1010	32	15
1011	27	6
1011	29	9
1011	1	11
1011	2	5
1011	4	20
1011	30	8
1011	31	11
1012	15	1
1012	12	16
1013	22	16
1013	23	18
1013	30	7
1013	31	19
1014	13	11
1014	18	1
1014	19	7
1014	20	3
1014	33	12
1014	34	14
1014	35	0
1014	30	12
1014	31	11
1015	15	3
1015	16	2
1015	17	2
1015	24	19
1015	26	17
1015	21	18
1015	22	15
1015	23	11
1016	18	15
1016	20	20
1017	5	19
1017	6	16
1017	7	10
1017	21	4
1017	22	11
1018	12	3
1018	13	14
1018	14	8
1018	18	2
1018	19	16
1018	20	12
1019	21	10
1019	13	1
1020	24	13
1020	25	6
1020	26	19
1020	21	5
1020	22	16
1021	9	18
1021	10	9
1021	11	2
1021	33	20
1021	34	3
1021	35	18
1021	7	12
1022	6	9
1022	7	4
1022	8	1
1023	30	1
1023	31	20
1023	32	8
1023	19	6
1023	20	3
1024	19	16
1024	20	7
1024	30	19
1024	31	17
1024	25	2
1024	26	13
1024	12	0
1024	14	1
1025	1	18
1025	2	15
1025	3	2
1025	4	15
1025	9	11
1025	10	4
1025	11	1
961	28	\N
962	35	\N
962	29	\N
963	6	\N
963	21	\N
966	21	\N
966	2	\N
967	27	\N
967	28	\N
967	15	\N
967	16	\N
968	12	\N
968	14	\N
969	1	\N
969	4	\N
970	12	\N
970	13	\N
971	20	\N
971	22	\N
971	23	\N
972	7	\N
973	3	\N
973	22	\N
973	14	\N
975	22	\N
975	11	\N
976	15	\N
976	18	\N
976	20	\N
977	19	\N
977	15	\N
978	19	\N
978	28	\N
979	18	\N
979	25	\N
980	23	\N
981	2	\N
981	16	\N
982	22	\N
983	27	\N
983	12	\N
985	33	\N
986	19	\N
991	5	\N
991	10	\N
992	24	\N
992	25	\N
993	30	\N
993	10	\N
994	5	\N
994	13	\N
995	12	\N
996	19	\N
997	1	\N
997	2	\N
997	28	\N
997	24	\N
999	22	\N
999	8	\N
1001	29	\N
1002	19	\N
1002	2	\N
1002	4	\N
1003	1	\N
1003	2	\N
1004	28	\N
1005	5	\N
1005	6	\N
1006	15	\N
1006	14	\N
1008	8	\N
1009	31	\N
1010	3	\N
1011	28	\N
1011	3	\N
1011	32	\N
1012	16	\N
1012	17	\N
1012	13	\N
1012	14	\N
1013	21	\N
1013	32	\N
1014	12	\N
1014	14	\N
1014	32	\N
1015	25	\N
1016	19	\N
1017	8	\N
1017	23	\N
1019	22	\N
1019	23	\N
1019	12	\N
1019	14	\N
1020	23	\N
1021	5	\N
1021	6	\N
1021	8	\N
1022	5	\N
1023	18	\N
1024	18	\N
1024	32	\N
26	27	\N
26	6	\N
27	27	\N
28	35	\N
29	22	\N
30	19	\N
31	5	\N
32	8	\N
33	21	\N
33	22	\N
33	23	\N
34	32	\N
34	23	\N
35	23	\N
37	26	\N
38	3	\N
38	19	\N
38	20	\N
39	6	\N
39	7	\N
41	25	\N
41	5	\N
41	8	\N
43	17	\N
43	21	\N
43	8	\N
45	2	\N
45	3	\N
45	12	\N
45	13	\N
45	14	\N
46	29	\N
47	28	\N
47	11	\N
49	10	\N
49	15	\N
49	20	\N
50	35	\N
51	31	\N
53	7	\N
53	8	\N
53	13	\N
54	30	\N
55	9	\N
56	5	\N
56	8	\N
56	16	\N
58	12	\N
58	14	\N
59	30	\N
59	32	\N
59	13	\N
59	14	\N
60	23	\N
61	1	\N
61	24	\N
64	3	\N
65	8	\N
65	30	\N
65	31	\N
66	21	\N
66	22	\N
67	27	\N
67	28	\N
68	17	\N
68	29	\N
69	25	\N
70	29	\N
71	7	\N
73	19	\N
73	20	\N
73	30	\N
75	12	\N
75	14	\N
75	19	\N
78	19	\N
78	30	\N
78	32	\N
79	17	\N
80	28	\N
80	29	\N
85	31	\N
85	27	\N
86	33	\N
86	15	\N
87	21	\N
87	22	\N
87	27	\N
87	12	\N
87	13	\N
88	27	\N
88	29	\N
90	29	\N
90	15	\N
90	16	\N
90	17	\N
91	15	\N
92	11	\N
93	8	\N
94	8	\N
94	18	\N
96	5	\N
96	8	\N
97	15	\N
97	12	\N
97	28	\N
98	8	\N
98	21	\N
98	22	\N
99	24	\N
99	25	\N
100	18	\N
100	20	\N
100	14	\N
102	30	\N
102	32	\N
103	24	\N
104	22	\N
104	5	\N
104	6	\N
105	26	\N
106	18	\N
107	7	\N
107	8	\N
108	10	\N
108	20	\N
109	5	\N
113	3	\N
114	19	\N
114	17	\N
115	33	\N
115	30	\N
116	10	\N
117	24	\N
118	17	\N
120	30	\N
120	10	\N
120	35	\N
120	19	\N
121	23	\N
121	2	\N
121	3	\N
123	12	\N
124	15	\N
126	22	\N
126	25	\N
127	21	\N
128	31	\N
128	34	\N
129	25	\N
129	15	\N
130	2	\N
130	25	\N
131	2	\N
132	26	\N
133	33	\N
133	5	\N
133	14	\N
134	34	\N
134	35	\N
134	5	\N
134	8	\N
134	15	\N
135	20	\N
136	22	\N
136	34	\N
137	23	\N
138	31	\N
138	11	\N
143	17	\N
145	34	\N
145	35	\N
145	13	\N
145	22	\N
146	11	\N
147	17	\N
149	10	\N
150	31	\N
151	22	\N
151	20	\N
151	25	\N
152	19	\N
152	25	\N
153	10	\N
155	7	\N
156	13	\N
156	14	\N
157	24	\N
158	9	\N
158	11	\N
158	20	\N
158	7	\N
159	21	\N
159	23	\N
159	33	\N
161	2	\N
161	4	\N
162	32	\N
163	35	\N
164	5	\N
164	32	\N
165	13	\N
165	15	\N
166	24	\N
166	29	\N
169	30	\N
169	33	\N
170	4	\N
172	14	\N
172	21	\N
173	28	\N
174	5	\N
175	30	\N
176	27	\N
176	15	\N
176	17	\N
177	7	\N
177	4	\N
178	24	\N
178	26	\N
178	6	\N
178	8	\N
179	23	\N
179	10	\N
180	24	\N
181	35	\N
182	5	\N
183	2	\N
183	3	\N
184	30	\N
184	35	\N
185	6	\N
186	8	\N
186	17	\N
186	22	\N
187	23	\N
188	24	\N
188	28	\N
189	33	\N
189	34	\N
189	35	\N
189	20	\N
191	27	\N
191	21	\N
192	27	\N
193	13	\N
194	33	\N
194	10	\N
195	28	\N
195	15	\N
195	13	\N
196	32	\N
197	30	\N
198	21	\N
199	3	\N
199	4	\N
199	27	\N
199	28	\N
201	4	\N
201	16	\N
204	16	\N
205	24	\N
205	25	\N
206	6	\N
208	27	\N
210	5	\N
211	1	\N
212	25	\N
212	20	\N
214	23	\N
214	6	\N
214	8	\N
214	13	\N
215	12	\N
215	5	\N
215	6	\N
215	7	\N
216	7	\N
216	27	\N
217	9	\N
217	10	\N
217	29	\N
218	4	\N
219	18	\N
220	24	\N
220	25	\N
220	2	\N
221	20	\N
221	5	\N
221	33	\N
221	35	\N
222	3	\N
223	26	\N
224	8	\N
224	1	\N
224	3	\N
224	4	\N
225	28	\N
225	29	\N
225	19	\N
226	29	\N
226	12	\N
227	12	\N
227	13	\N
228	11	\N
228	30	\N
229	21	\N
229	23	\N
230	5	\N
230	1	\N
230	2	\N
231	8	\N
232	1	\N
233	8	\N
233	3	\N
233	4	\N
234	16	\N
234	6	\N
234	9	\N
237	27	\N
237	28	\N
237	24	\N
237	34	\N
238	10	\N
239	19	\N
239	2	\N
239	3	\N
242	5	\N
242	8	\N
242	23	\N
243	6	\N
243	8	\N
243	2	\N
244	24	\N
245	2	\N
245	4	\N
245	33	\N
246	18	\N
247	19	\N
248	13	\N
249	21	\N
249	30	\N
250	1	\N
250	4	\N
251	16	\N
252	19	\N
253	9	\N
253	10	\N
253	5	\N
254	24	\N
254	9	\N
254	15	\N
255	33	\N
258	26	\N
261	21	\N
262	33	\N
262	35	\N
262	5	\N
262	8	\N
262	22	\N
263	12	\N
263	14	\N
264	17	\N
264	19	\N
265	4	\N
265	32	\N
267	29	\N
269	3	\N
269	21	\N
269	24	\N
269	25	\N
269	26	\N
270	34	\N
271	12	\N
271	14	\N
273	5	\N
273	6	\N
274	19	\N
274	20	\N
274	28	\N
274	29	\N
275	9	\N
275	10	\N
275	25	\N
275	5	\N
275	8	\N
276	21	\N
276	30	\N
276	31	\N
276	32	\N
276	33	\N
277	12	\N
277	20	\N
278	22	\N
278	23	\N
278	17	\N
279	6	\N
279	21	\N
280	17	\N
280	33	\N
281	20	\N
282	34	\N
283	26	\N
285	31	\N
286	16	\N
286	31	\N
287	16	\N
288	6	\N
288	8	\N
288	15	\N
288	28	\N
288	29	\N
288	21	\N
290	20	\N
290	25	\N
291	16	\N
292	5	\N
292	8	\N
292	18	\N
292	34	\N
292	35	\N
294	6	\N
295	18	\N
295	20	\N
296	12	\N
297	22	\N
301	16	\N
301	10	\N
301	11	\N
303	11	\N
303	13	\N
303	14	\N
303	30	\N
303	32	\N
304	35	\N
304	7	\N
304	23	\N
307	29	\N
308	21	\N
309	27	\N
310	26	\N
310	3	\N
310	5	\N
310	8	\N
311	18	\N
311	16	\N
313	12	\N
313	32	\N
315	10	\N
316	20	\N
317	1	\N
318	18	\N
318	33	\N
318	35	\N
319	35	\N
319	29	\N
320	3	\N
321	14	\N
321	33	\N
321	35	\N
321	26	\N
323	24	\N
323	26	\N
324	32	\N
325	18	\N
326	18	\N
327	10	\N
327	14	\N
329	24	\N
333	12	\N
333	9	\N
333	31	\N
334	6	\N
335	5	\N
336	19	\N
337	12	\N
338	23	\N
339	34	\N
340	1	\N
341	20	\N
341	24	\N
341	22	\N
341	3	\N
343	21	\N
344	3	\N
345	10	\N
345	11	\N
346	20	\N
346	28	\N
347	9	\N
347	17	\N
348	21	\N
348	22	\N
348	20	\N
349	13	\N
349	14	\N
350	17	\N
350	22	\N
350	1	\N
350	3	\N
351	16	\N
352	24	\N
353	4	\N
353	27	\N
353	28	\N
354	6	\N
354	24	\N
354	25	\N
354	27	\N
356	4	\N
357	30	\N
357	6	\N
358	15	\N
359	25	\N
361	21	\N
361	30	\N
361	32	\N
362	6	\N
362	8	\N
362	1	\N
362	2	\N
362	3	\N
363	24	\N
363	34	\N
364	1	\N
364	32	\N
365	34	\N
365	27	\N
365	28	\N
367	30	\N
367	31	\N
367	14	\N
368	21	\N
368	22	\N
369	22	\N
369	23	\N
370	2	\N
371	28	\N
371	12	\N
371	13	\N
372	2	\N
373	3	\N
373	30	\N
373	31	\N
374	17	\N
375	1	\N
375	5	\N
376	30	\N
376	32	\N
377	25	\N
377	26	\N
378	24	\N
378	19	\N
378	31	\N
379	34	\N
380	2	\N
380	3	\N
381	20	\N
381	27	\N
381	29	\N
382	10	\N
382	12	\N
383	3	\N
384	21	\N
384	26	\N
385	19	\N
386	15	\N
386	16	\N
386	17	\N
386	3	\N
387	26	\N
388	22	\N
389	23	\N
389	24	\N
390	21	\N
391	31	\N
392	25	\N
392	26	\N
392	14	\N
394	25	\N
394	15	\N
394	16	\N
394	22	\N
394	23	\N
397	32	\N
398	9	\N
398	11	\N
399	19	\N
399	3	\N
399	4	\N
400	20	\N
401	32	\N
404	31	\N
405	27	\N
405	7	\N
406	33	\N
406	34	\N
406	9	\N
406	10	\N
407	33	\N
408	31	\N
408	28	\N
409	9	\N
409	22	\N
409	23	\N
409	16	\N
411	35	\N
411	15	\N
412	35	\N
412	16	\N
413	14	\N
414	28	\N
414	4	\N
415	28	\N
415	1	\N
415	34	\N
416	34	\N
416	13	\N
416	6	\N
419	27	\N
419	9	\N
420	3	\N
420	22	\N
421	17	\N
423	34	\N
424	34	\N
424	35	\N
424	30	\N
425	35	\N
425	15	\N
425	17	\N
426	9	\N
426	10	\N
427	31	\N
427	24	\N
428	7	\N
430	27	\N
431	32	\N
431	15	\N
431	16	\N
431	17	\N
432	10	\N
433	16	\N
437	34	\N
438	34	\N
438	8	\N
439	12	\N
439	13	\N
439	25	\N
440	5	\N
440	8	\N
440	27	\N
440	28	\N
441	9	\N
441	10	\N
441	11	\N
442	5	\N
443	5	\N
443	8	\N
444	29	\N
446	8	\N
446	20	\N
448	16	\N
448	34	\N
449	16	\N
449	17	\N
450	15	\N
450	29	\N
451	28	\N
451	6	\N
452	22	\N
452	31	\N
452	5	\N
452	7	\N
453	9	\N
453	24	\N
453	26	\N
453	28	\N
454	33	\N
454	34	\N
455	28	\N
455	33	\N
456	17	\N
456	25	\N
457	25	\N
457	26	\N
457	27	\N
457	10	\N
458	25	\N
459	8	\N
459	3	\N
459	16	\N
460	24	\N
461	33	\N
462	14	\N
463	18	\N
463	20	\N
464	8	\N
464	21	\N
464	34	\N
464	35	\N
465	2	\N
466	25	\N
466	26	\N
467	6	\N
467	7	\N
467	8	\N
468	27	\N
468	10	\N
469	19	\N
472	4	\N
472	10	\N
473	33	\N
473	34	\N
475	3	\N
477	26	\N
477	11	\N
478	15	\N
478	17	\N
479	22	\N
482	16	\N
483	26	\N
484	24	\N
484	26	\N
485	16	\N
486	20	\N
486	12	\N
487	1	\N
487	4	\N
488	21	\N
489	20	\N
489	7	\N
490	32	\N
490	20	\N
491	30	\N
491	18	\N
491	4	\N
493	31	\N
494	15	\N
495	1	\N
496	1	\N
496	2	\N
497	9	\N
497	21	\N
498	21	\N
499	1	\N
499	2	\N
501	16	\N
501	21	\N
501	20	\N
501	35	\N
502	22	\N
502	15	\N
502	17	\N
502	19	\N
503	27	\N
503	4	\N
504	12	\N
504	13	\N
504	14	\N
504	30	\N
505	13	\N
506	22	\N
507	15	\N
507	17	\N
508	19	\N
509	4	\N
510	29	\N
510	17	\N
511	15	\N
512	19	\N
512	25	\N
512	26	\N
513	29	\N
514	30	\N
514	24	\N
515	20	\N
515	7	\N
516	26	\N
516	27	\N
516	17	\N
518	32	\N
518	25	\N
519	25	\N
519	27	\N
520	27	\N
520	28	\N
521	10	\N
521	13	\N
521	34	\N
522	16	\N
523	29	\N
524	7	\N
525	22	\N
525	17	\N
526	19	\N
526	27	\N
527	19	\N
527	25	\N
527	21	\N
528	5	\N
528	8	\N
528	25	\N
529	6	\N
529	7	\N
531	26	\N
531	31	\N
531	32	\N
531	20	\N
533	24	\N
533	25	\N
533	9	\N
533	11	\N
533	16	\N
534	2	\N
534	35	\N
536	23	\N
537	10	\N
537	22	\N
538	20	\N
539	29	\N
540	35	\N
542	9	\N
543	27	\N
543	17	\N
545	7	\N
545	34	\N
546	29	\N
549	14	\N
550	11	\N
550	21	\N
550	15	\N
551	32	\N
551	10	\N
553	4	\N
553	24	\N
553	26	\N
555	14	\N
556	27	\N
556	28	\N
556	29	\N
558	2	\N
558	3	\N
559	12	\N
559	18	\N
560	25	\N
561	29	\N
562	19	\N
562	5	\N
562	6	\N
562	32	\N
563	24	\N
563	25	\N
563	5	\N
568	34	\N
568	35	\N
568	8	\N
569	8	\N
570	10	\N
570	11	\N
571	14	\N
571	31	\N
572	22	\N
573	6	\N
573	7	\N
573	25	\N
573	12	\N
573	13	\N
573	27	\N
573	29	\N
574	13	\N
574	14	\N
575	29	\N
576	14	\N
576	19	\N
578	28	\N
578	19	\N
579	25	\N
579	1	\N
580	21	\N
581	34	\N
581	35	\N
582	34	\N
583	20	\N
583	13	\N
584	25	\N
584	26	\N
584	33	\N
586	1	\N
587	22	\N
587	18	\N
588	18	\N
588	19	\N
589	27	\N
589	28	\N
590	33	\N
590	34	\N
591	23	\N
591	17	\N
592	10	\N
593	20	\N
593	5	\N
593	6	\N
595	17	\N
595	33	\N
595	13	\N
596	6	\N
597	2	\N
599	7	\N
599	3	\N
599	4	\N
601	21	\N
601	22	\N
602	18	\N
602	10	\N
603	25	\N
603	26	\N
604	22	\N
604	10	\N
605	19	\N
606	27	\N
607	30	\N
609	28	\N
609	34	\N
610	5	\N
610	8	\N
610	30	\N
611	5	\N
613	5	\N
613	13	\N
614	33	\N
614	34	\N
614	35	\N
615	15	\N
615	16	\N
615	5	\N
615	6	\N
615	7	\N
617	19	\N
618	1	\N
618	3	\N
618	13	\N
619	21	\N
622	24	\N
623	35	\N
624	23	\N
625	3	\N
626	16	\N
627	26	\N
628	22	\N
628	8	\N
629	19	\N
629	31	\N
630	1	\N
630	2	\N
630	5	\N
632	26	\N
632	10	\N
634	34	\N
635	11	\N
636	1	\N
637	29	\N
638	19	\N
639	25	\N
639	26	\N
643	21	\N
643	22	\N
644	13	\N
644	14	\N
645	9	\N
646	22	\N
647	1	\N
647	10	\N
647	32	\N
649	30	\N
649	9	\N
649	10	\N
649	11	\N
651	31	\N
651	32	\N
651	1	\N
651	2	\N
653	14	\N
656	21	\N
657	26	\N
659	26	\N
659	3	\N
660	3	\N
662	27	\N
663	7	\N
663	2	\N
664	24	\N
664	26	\N
664	31	\N
664	4	\N
665	9	\N
666	17	\N
666	9	\N
666	11	\N
666	34	\N
669	22	\N
669	23	\N
670	7	\N
672	13	\N
673	7	\N
673	8	\N
673	28	\N
675	32	\N
675	15	\N
676	20	\N
677	4	\N
677	11	\N
678	15	\N
678	28	\N
678	31	\N
678	32	\N
679	17	\N
680	9	\N
681	2	\N
681	3	\N
681	4	\N
681	7	\N
682	27	\N
682	28	\N
682	24	\N
683	20	\N
683	22	\N
683	23	\N
684	25	\N
684	26	\N
685	4	\N
686	22	\N
687	14	\N
687	16	\N
688	35	\N
689	29	\N
689	19	\N
690	3	\N
690	5	\N
690	6	\N
691	4	\N
691	21	\N
691	5	\N
692	30	\N
692	31	\N
693	33	\N
693	35	\N
693	30	\N
693	18	\N
693	20	\N
694	24	\N
694	30	\N
694	32	\N
695	12	\N
695	9	\N
696	4	\N
696	15	\N
697	9	\N
697	22	\N
698	30	\N
699	9	\N
699	11	\N
699	17	\N
700	30	\N
700	10	\N
701	11	\N
701	25	\N
702	12	\N
702	31	\N
703	17	\N
703	12	\N
703	21	\N
704	11	\N
705	21	\N
707	7	\N
707	24	\N
707	9	\N
707	11	\N
708	24	\N
708	34	\N
709	12	\N
710	34	\N
710	21	\N
711	5	\N
712	5	\N
713	15	\N
713	18	\N
714	31	\N
714	14	\N
717	7	\N
717	8	\N
718	15	\N
718	10	\N
719	17	\N
720	16	\N
721	32	\N
721	22	\N
722	21	\N
722	16	\N
723	5	\N
725	17	\N
726	1	\N
727	5	\N
727	7	\N
727	8	\N
728	2	\N
732	25	\N
733	12	\N
733	13	\N
733	15	\N
733	11	\N
733	31	\N
735	24	\N
736	11	\N
737	32	\N
737	26	\N
738	2	\N
738	14	\N
742	8	\N
743	22	\N
744	28	\N
745	28	\N
745	26	\N
746	20	\N
747	4	\N
748	10	\N
748	11	\N
748	22	\N
749	32	\N
750	15	\N
750	21	\N
750	34	\N
751	12	\N
752	14	\N
752	34	\N
753	28	\N
753	2	\N
754	3	\N
754	28	\N
754	18	\N
756	27	\N
756	28	\N
756	11	\N
757	9	\N
757	3	\N
758	22	\N
758	28	\N
760	33	\N
761	3	\N
763	10	\N
763	26	\N
764	12	\N
764	30	\N
764	32	\N
766	24	\N
767	29	\N
768	10	\N
768	11	\N
768	3	\N
769	2	\N
769	6	\N
769	8	\N
770	6	\N
770	28	\N
770	29	\N
770	12	\N
771	7	\N
771	20	\N
771	22	\N
772	7	\N
772	31	\N
773	24	\N
773	25	\N
773	4	\N
774	3	\N
776	33	\N
776	23	\N
777	13	\N
777	20	\N
778	35	\N
779	1	\N
780	29	\N
780	26	\N
780	7	\N
780	8	\N
781	28	\N
781	24	\N
781	25	\N
782	10	\N
783	30	\N
783	3	\N
784	16	\N
784	13	\N
785	15	\N
786	28	\N
786	1	\N
786	4	\N
787	31	\N
787	26	\N
788	6	\N
788	7	\N
789	10	\N
789	31	\N
790	27	\N
790	28	\N
793	21	\N
793	23	\N
793	9	\N
794	7	\N
797	19	\N
797	31	\N
800	30	\N
800	8	\N
800	21	\N
800	9	\N
800	10	\N
801	32	\N
802	31	\N
802	9	\N
803	13	\N
804	12	\N
805	28	\N
805	29	\N
805	10	\N
806	31	\N
806	2	\N
806	3	\N
807	9	\N
807	11	\N
809	25	\N
810	26	\N
810	18	\N
810	20	\N
813	2	\N
813	4	\N
814	18	\N
814	19	\N
815	28	\N
816	33	\N
817	9	\N
817	11	\N
817	17	\N
819	13	\N
819	8	\N
820	3	\N
821	27	\N
822	35	\N
824	29	\N
824	31	\N
825	18	\N
825	13	\N
827	2	\N
827	3	\N
827	5	\N
827	7	\N
828	31	\N
829	33	\N
829	34	\N
829	14	\N
829	9	\N
829	24	\N
831	27	\N
832	19	\N
832	13	\N
832	4	\N
833	35	\N
834	1	\N
836	11	\N
836	15	\N
837	34	\N
837	12	\N
837	13	\N
838	10	\N
839	11	\N
840	19	\N
841	2	\N
842	35	\N
842	22	\N
843	29	\N
844	26	\N
844	7	\N
845	34	\N
846	7	\N
848	14	\N
848	23	\N
849	31	\N
849	32	\N
850	17	\N
850	18	\N
850	23	\N
850	28	\N
850	29	\N
851	15	\N
852	17	\N
853	33	\N
853	35	\N
853	16	\N
855	11	\N
855	1	\N
855	4	\N
856	35	\N
856	7	\N
857	21	\N
857	5	\N
857	25	\N
858	34	\N
858	7	\N
858	8	\N
859	26	\N
860	10	\N
860	11	\N
860	2	\N
860	4	\N
861	21	\N
863	31	\N
863	32	\N
863	21	\N
864	30	\N
864	32	\N
864	5	\N
864	7	\N
865	24	\N
865	26	\N
866	17	\N
866	28	\N
866	8	\N
868	19	\N
869	31	\N
869	13	\N
870	26	\N
872	16	\N
873	30	\N
873	31	\N
873	17	\N
873	35	\N
874	9	\N
876	28	\N
876	29	\N
878	3	\N
881	13	\N
881	14	\N
881	34	\N
882	22	\N
882	34	\N
882	35	\N
882	1	\N
883	19	\N
884	34	\N
886	14	\N
886	21	\N
887	20	\N
887	25	\N
889	7	\N
889	8	\N
891	20	\N
892	21	\N
893	27	\N
894	16	\N
894	3	\N
895	3	\N
896	14	\N
897	22	\N
897	23	\N
898	15	\N
898	17	\N
899	8	\N
899	20	\N
900	15	\N
900	16	\N
901	6	\N
901	12	\N
901	24	\N
901	25	\N
903	31	\N
903	32	\N
903	19	\N
905	19	\N
905	21	\N
905	25	\N
906	19	\N
906	1	\N
906	9	\N
908	3	\N
908	4	\N
909	8	\N
909	21	\N
909	22	\N
911	5	\N
912	12	\N
912	16	\N
914	25	\N
914	26	\N
914	21	\N
914	23	\N
914	18	\N
915	13	\N
915	14	\N
916	17	\N
918	20	\N
918	24	\N
918	26	\N
919	33	\N
921	25	\N
921	7	\N
922	9	\N
922	24	\N
923	35	\N
924	1	\N
924	24	\N
924	25	\N
925	11	\N
925	24	\N
926	20	\N
926	34	\N
926	15	\N
927	3	\N
928	9	\N
928	23	\N
928	7	\N
929	21	\N
929	5	\N
930	28	\N
932	14	\N
932	15	\N
933	4	\N
934	9	\N
934	17	\N
936	9	\N
936	10	\N
936	26	\N
936	16	\N
936	17	\N
937	20	\N
937	30	\N
938	18	\N
938	20	\N
938	27	\N
939	32	\N
940	2	\N
940	7	\N
941	25	\N
941	26	\N
941	34	\N
942	20	\N
942	34	\N
943	11	\N
943	25	\N
944	26	\N
944	34	\N
944	16	\N
945	16	\N
945	26	\N
946	1	\N
946	24	\N
947	18	\N
947	1	\N
952	19	\N
952	20	\N
953	26	\N
954	9	\N
955	33	\N
955	27	\N
956	27	\N
956	24	\N
956	13	\N
958	13	\N
958	17	\N
959	27	\N
959	2	\N
959	4	\N
1024	24	\N
1024	13	\N
\.


--
-- Data for Name: students_lessons; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.students_lessons (id_student, id_lesson, completed) FROM stdin;
26	40	f
26	55	f
26	48	f
26	10	f
27	66	f
27	67	f
29	19	f
29	42	f
30	33	f
31	11	f
31	13	f
31	14	f
31	52	f
32	10	f
32	14	f
32	39	f
34	64	f
34	46	f
35	30	f
35	32	f
35	46	f
36	52	f
36	23	f
37	26	f
37	27	f
37	30	f
38	7	f
38	8	f
38	39	f
38	18	f
38	19	f
38	21	f
39	38	f
39	39	f
39	9	f
39	12	f
39	13	f
39	15	f
40	3	f
40	18	f
41	47	f
41	7	f
42	16	f
43	30	f
43	32	f
44	56	f
44	5	f
44	7	f
45	1	f
45	3	f
45	4	f
45	48	f
45	50	f
45	23	f
45	24	f
45	27	f
46	26	f
46	27	f
46	57	f
46	58	f
47	59	f
47	63	f
47	64	f
47	22	f
49	18	f
49	19	f
49	29	f
49	30	f
49	32	f
49	37	f
50	17	f
50	18	f
50	21	f
50	22	f
51	22	f
51	61	f
51	63	f
51	64	f
53	13	f
53	24	f
54	59	f
54	24	f
54	27	f
55	17	f
55	19	f
55	21	f
55	67	f
55	69	f
56	9	f
56	11	f
56	13	f
56	16	f
56	30	f
56	31	f
56	41	f
56	42	f
56	44	f
57	49	f
57	50	f
58	63	f
58	25	f
58	11	f
58	15	f
59	60	f
59	49	f
59	42	f
60	24	f
60	26	f
60	45	f
60	46	f
61	52	f
62	63	f
62	6	f
62	7	f
62	8	f
63	32	f
63	22	f
64	50	f
64	8	f
65	62	f
66	43	f
67	53	f
67	55	f
67	57	f
67	67	f
67	68	f
67	2	f
67	3	f
68	1	f
68	4	f
68	29	f
68	30	f
68	33	f
68	55	f
69	41	f
69	48	f
69	26	f
70	57	f
71	49	f
71	50	f
71	10	f
72	59	f
73	36	f
73	39	f
73	40	f
74	13	f
74	43	f
74	25	f
74	27	f
75	60	f
76	39	f
77	39	f
77	40	f
77	54	f
77	56	f
79	46	f
79	23	f
79	24	f
79	26	f
80	55	f
80	57	f
80	14	f
80	18	f
80	21	f
81	1	f
81	3	f
81	60	f
81	62	f
81	31	f
81	33	f
82	67	f
82	21	f
83	30	f
83	26	f
84	52	f
85	41	f
85	43	f
85	68	f
85	69	f
86	32	f
86	33	f
87	43	f
87	53	f
87	28	f
88	57	f
89	35	f
89	36	f
89	38	f
89	40	f
89	29	f
89	34	f
90	65	f
90	55	f
90	56	f
90	57	f
90	58	f
90	31	f
91	29	f
91	31	f
91	55	f
91	57	f
91	59	f
91	60	f
91	62	f
91	47	f
91	50	f
92	21	f
93	23	f
93	13	f
94	11	f
94	14	f
94	37	f
94	38	f
96	14	f
96	16	f
96	31	f
96	33	f
97	29	f
97	31	f
97	24	f
97	53	f
98	68	f
98	9	f
98	11	f
98	13	f
98	14	f
98	16	f
99	41	f
99	47	f
99	52	f
100	35	f
100	24	f
100	25	f
100	28	f
100	20	f
101	1	f
101	4	f
101	7	f
101	8	f
101	27	f
101	22	f
102	59	f
102	63	f
103	50	f
103	51	f
104	41	f
104	42	f
104	10	f
104	12	f
105	50	f
105	51	f
105	52	f
106	60	f
106	63	f
106	36	f
106	39	f
106	34	f
107	36	f
107	39	f
107	40	f
107	65	f
107	9	f
107	14	f
108	52	f
108	37	f
109	3	f
109	4	f
109	10	f
109	16	f
110	60	f
110	61	f
110	62	f
110	63	f
110	30	f
110	32	f
110	34	f
111	23	f
111	25	f
111	27	f
112	65	f
112	69	f
112	36	f
112	38	f
113	30	f
113	1	f
113	4	f
113	16	f
114	36	f
114	30	f
114	31	f
115	70	f
115	3	f
115	5	f
116	9	f
116	14	f
116	38	f
117	47	f
118	68	f
118	69	f
120	19	f
120	69	f
120	35	f
120	36	f
121	47	f
122	1	f
122	59	f
123	41	f
123	55	f
123	27	f
124	34	f
124	12	f
124	6	f
124	7	f
125	32	f
126	43	f
126	44	f
126	11	f
126	14	f
126	16	f
126	52	f
127	41	f
127	43	f
128	59	f
128	63	f
128	64	f
128	66	f
128	70	f
129	54	f
129	57	f
129	48	f
129	49	f
129	52	f
130	4	f
130	5	f
130	6	f
130	48	f
130	52	f
131	54	f
131	56	f
131	2	f
131	19	f
131	20	f
131	21	f
132	2	f
132	7	f
132	51	f
133	65	f
133	70	f
133	16	f
134	69	f
134	70	f
134	30	f
134	33	f
136	66	f
136	68	f
137	59	f
137	61	f
137	62	f
137	63	f
138	61	f
138	22	f
139	59	f
140	59	f
140	56	f
141	27	f
141	58	f
142	9	f
142	13	f
143	33	f
143	20	f
143	22	f
144	7	f
144	8	f
144	45	f
145	66	f
145	23	f
145	24	f
145	46	f
147	35	f
147	26	f
147	34	f
148	60	f
148	63	f
148	33	f
148	34	f
149	23	f
149	24	f
149	27	f
149	28	f
149	48	f
149	50	f
149	61	f
149	17	f
151	44	f
151	45	f
151	46	f
152	36	f
152	52	f
153	28	f
154	36	f
154	39	f
154	4	f
154	60	f
155	9	f
155	16	f
155	5	f
155	59	f
155	43	f
156	59	f
156	64	f
156	25	f
156	26	f
156	27	f
156	28	f
157	49	f
158	9	f
158	23	f
159	46	f
159	65	f
159	66	f
159	70	f
159	59	f
160	12	f
160	16	f
160	29	f
160	59	f
160	60	f
160	63	f
161	9	f
161	10	f
161	8	f
162	59	f
163	28	f
164	9	f
164	12	f
164	16	f
164	61	f
164	64	f
164	48	f
164	52	f
164	26	f
165	26	f
165	27	f
165	34	f
166	49	f
166	65	f
166	67	f
166	68	f
167	23	f
167	24	f
167	26	f
167	48	f
167	51	f
167	36	f
167	40	f
168	21	f
168	1	f
168	2	f
168	3	f
168	5	f
169	66	f
169	68	f
169	70	f
170	37	f
170	39	f
170	5	f
171	23	f
171	1	f
172	23	f
173	59	f
173	58	f
174	11	f
174	13	f
174	15	f
175	66	f
175	67	f
175	69	f
175	5	f
175	6	f
175	60	f
175	63	f
176	19	f
176	21	f
176	56	f
176	29	f
176	30	f
176	33	f
177	9	f
177	12	f
177	13	f
177	15	f
177	1	f
177	5	f
177	6	f
177	7	f
178	47	f
178	49	f
178	11	f
179	45	f
179	22	f
180	63	f
180	29	f
180	30	f
180	32	f
181	48	f
181	50	f
181	65	f
181	68	f
182	11	f
182	13	f
182	35	f
182	37	f
182	38	f
183	4	f
183	6	f
184	60	f
184	66	f
184	45	f
184	46	f
185	20	f
185	21	f
185	10	f
185	13	f
186	40	f
186	15	f
186	31	f
186	32	f
186	33	f
186	34	f
186	42	f
188	49	f
189	60	f
189	64	f
189	69	f
189	38	f
189	39	f
190	48	f
190	50	f
191	58	f
192	9	f
192	12	f
192	56	f
193	1	f
193	6	f
193	7	f
194	36	f
194	67	f
194	19	f
194	21	f
195	58	f
195	37	f
195	38	f
195	32	f
196	61	f
196	50	f
197	60	f
197	64	f
198	55	f
198	44	f
199	6	f
199	8	f
199	55	f
199	65	f
200	38	f
200	25	f
200	11	f
200	13	f
200	15	f
201	2	f
201	7	f
201	34	f
202	47	f
202	49	f
203	48	f
203	50	f
203	31	f
204	43	f
204	45	f
204	31	f
204	6	f
204	8	f
205	42	f
205	47	f
205	51	f
205	67	f
205	68	f
206	12	f
206	14	f
206	59	f
206	66	f
206	68	f
207	64	f
209	47	f
209	52	f
209	60	f
209	62	f
209	64	f
209	2	f
209	3	f
210	10	f
210	16	f
210	51	f
211	8	f
212	47	f
212	48	f
212	49	f
212	51	f
212	37	f
213	51	f
213	52	f
213	61	f
213	62	f
213	63	f
213	64	f
214	42	f
214	14	f
214	16	f
214	28	f
215	35	f
215	37	f
215	40	f
216	13	f
216	53	f
217	21	f
217	47	f
217	54	f
217	58	f
218	8	f
219	35	f
219	37	f
219	17	f
219	21	f
219	22	f
220	56	f
220	3	f
220	4	f
221	9	f
221	12	f
222	61	f
222	2	f
224	4	f
224	8	f
225	53	f
225	42	f
225	45	f
225	35	f
225	36	f
225	40	f
226	55	f
226	27	f
228	20	f
228	65	f
228	66	f
228	67	f
228	68	f
228	44	f
228	45	f
228	46	f
230	24	f
230	25	f
230	26	f
230	36	f
230	4	f
231	15	f
232	1	f
232	6	f
232	7	f
232	8	f
233	11	f
233	3	f
233	8	f
234	37	f
234	38	f
234	30	f
234	32	f
234	33	f
234	34	f
234	11	f
234	12	f
235	52	f
236	54	f
236	55	f
236	20	f
237	53	f
237	56	f
237	52	f
237	68	f
237	35	f
237	36	f
237	39	f
237	40	f
238	2	f
238	4	f
238	7	f
238	19	f
238	22	f
238	68	f
239	5	f
240	39	f
240	9	f
241	23	f
241	63	f
242	9	f
242	12	f
242	13	f
242	18	f
242	20	f
242	43	f
243	20	f
243	21	f
243	22	f
244	35	f
244	36	f
245	5	f
245	66	f
246	21	f
246	35	f
246	40	f
247	17	f
247	20	f
247	37	f
247	38	f
247	8	f
248	68	f
248	70	f
249	50	f
250	55	f
250	57	f
251	61	f
251	64	f
251	31	f
251	33	f
252	37	f
252	39	f
253	18	f
253	19	f
253	21	f
253	22	f
254	50	f
254	29	f
255	31	f
255	33	f
255	34	f
255	36	f
255	37	f
256	30	f
257	42	f
257	45	f
258	5	f
258	48	f
258	49	f
258	52	f
258	66	f
259	5	f
259	6	f
259	8	f
260	54	f
260	21	f
261	22	f
261	45	f
262	65	f
262	67	f
262	13	f
262	14	f
262	44	f
263	25	f
263	17	f
263	21	f
264	32	f
264	33	f
264	39	f
264	40	f
265	5	f
265	7	f
265	31	f
265	34	f
266	65	f
266	67	f
267	61	f
267	54	f
268	69	f
268	59	f
269	1	f
269	2	f
269	4	f
269	42	f
269	47	f
269	49	f
270	37	f
270	40	f
270	42	f
271	19	f
272	49	f
272	51	f
272	12	f
272	13	f
272	14	f
273	12	f
273	66	f
273	67	f
274	62	f
274	35	f
274	38	f
274	39	f
274	40	f
275	17	f
275	47	f
275	10	f
276	59	f
277	24	f
277	36	f
277	39	f
278	47	f
278	49	f
278	51	f
278	29	f
278	32	f
279	16	f
279	46	f
279	4	f
280	31	f
280	66	f
280	69	f
281	17	f
281	18	f
281	21	f
282	18	f
282	68	f
283	45	f
283	46	f
284	32	f
284	36	f
284	38	f
284	40	f
285	9	f
285	12	f
285	60	f
285	39	f
286	31	f
286	33	f
286	34	f
286	48	f
286	59	f
286	63	f
286	64	f
287	33	f
287	42	f
288	33	f
288	34	f
288	41	f
288	44	f
289	23	f
289	25	f
290	47	f
291	29	f
292	15	f
292	16	f
292	68	f
293	49	f
294	9	f
294	11	f
294	14	f
294	54	f
294	55	f
296	6	f
296	7	f
298	59	f
299	41	f
299	54	f
299	57	f
299	58	f
300	10	f
300	11	f
300	13	f
300	15	f
301	17	f
301	21	f
302	54	f
302	58	f
302	5	f
302	7	f
303	19	f
303	25	f
303	60	f
304	66	f
304	69	f
304	9	f
304	16	f
304	42	f
305	64	f
305	53	f
305	55	f
306	5	f
306	7	f
306	19	f
308	41	f
308	46	f
309	53	f
309	58	f
310	51	f
310	5	f
310	6	f
310	7	f
310	12	f
310	15	f
311	36	f
311	39	f
311	30	f
311	31	f
313	26	f
313	28	f
313	59	f
314	47	f
314	44	f
315	18	f
315	14	f
315	16	f
316	45	f
316	46	f
316	39	f
317	27	f
317	49	f
317	8	f
318	39	f
318	40	f
318	41	f
318	46	f
318	66	f
318	70	f
319	65	f
320	31	f
320	1	f
320	2	f
320	5	f
320	44	f
321	24	f
321	26	f
322	62	f
322	64	f
322	55	f
322	58	f
323	59	f
323	63	f
324	29	f
324	31	f
326	41	f
326	43	f
326	37	f
326	38	f
327	12	f
327	14	f
327	21	f
327	24	f
328	65	f
328	68	f
328	70	f
329	49	f
329	18	f
330	56	f
331	2	f
331	5	f
331	41	f
331	42	f
331	54	f
331	58	f
332	51	f
333	28	f
333	21	f
334	19	f
334	22	f
334	10	f
334	15	f
335	11	f
335	12	f
336	14	f
336	49	f
336	52	f
336	35	f
337	53	f
337	56	f
337	27	f
338	41	f
338	45	f
338	1	f
338	5	f
338	7	f
338	8	f
339	35	f
339	40	f
340	29	f
340	34	f
340	7	f
340	41	f
340	43	f
341	47	f
341	49	f
341	50	f
341	51	f
341	43	f
341	2	f
342	48	f
342	20	f
342	54	f
342	56	f
343	43	f
343	45	f
343	17	f
343	20	f
343	40	f
344	6	f
344	7	f
345	51	f
345	66	f
345	19	f
345	22	f
346	40	f
346	53	f
346	57	f
347	37	f
347	31	f
348	18	f
348	19	f
348	44	f
348	35	f
350	34	f
350	1	f
350	8	f
351	33	f
351	36	f
351	22	f
352	49	f
352	60	f
353	2	f
353	5	f
353	66	f
353	68	f
353	69	f
353	55	f
353	56	f
354	49	f
355	61	f
356	66	f
356	67	f
356	2	f
356	4	f
356	6	f
357	59	f
357	9	f
357	14	f
357	16	f
358	34	f
359	20	f
360	33	f
360	34	f
361	10	f
361	16	f
361	5	f
361	41	f
361	43	f
361	61	f
362	29	f
362	31	f
362	32	f
362	47	f
362	1	f
362	3	f
363	48	f
363	66	f
363	67	f
363	69	f
364	8	f
364	60	f
364	19	f
365	48	f
365	50	f
365	67	f
366	47	f
366	51	f
366	52	f
366	16	f
367	59	f
367	23	f
367	24	f
367	26	f
367	27	f
369	44	f
369	1	f
369	2	f
369	6	f
371	24	f
371	27	f
372	2	f
372	6	f
372	8	f
372	65	f
372	66	f
372	67	f
372	70	f
373	60	f
374	32	f
374	33	f
375	3	f
375	5	f
375	8	f
375	12	f
375	13	f
376	60	f
376	4	f
377	48	f
377	49	f
377	50	f
378	12	f
378	13	f
378	15	f
378	35	f
378	36	f
378	40	f
379	49	f
379	51	f
379	69	f
379	70	f
380	55	f
380	57	f
380	3	f
380	6	f
381	38	f
381	55	f
381	56	f
382	49	f
382	22	f
383	9	f
383	16	f
383	4	f
383	6	f
384	63	f
384	41	f
384	51	f
385	54	f
385	56	f
385	36	f
385	38	f
386	34	f
386	2	f
386	7	f
388	44	f
388	50	f
389	51	f
390	4	f
390	5	f
390	41	f
390	43	f
390	66	f
390	67	f
390	70	f
391	2	f
391	3	f
391	7	f
392	52	f
392	23	f
393	54	f
393	56	f
393	27	f
394	48	f
394	46	f
395	51	f
396	24	f
396	25	f
397	29	f
398	21	f
398	56	f
398	58	f
399	68	f
399	70	f
399	36	f
399	3	f
399	5	f
399	7	f
400	52	f
401	59	f
401	62	f
401	47	f
401	39	f
402	29	f
402	30	f
402	39	f
402	41	f
402	42	f
402	45	f
403	59	f
403	47	f
403	52	f
404	60	f
404	50	f
404	69	f
405	9	f
405	15	f
406	50	f
406	67	f
406	22	f
407	67	f
407	69	f
407	11	f
407	14	f
407	15	f
407	16	f
408	59	f
408	60	f
408	62	f
409	21	f
409	41	f
409	33	f
409	34	f
410	11	f
410	67	f
410	68	f
411	67	f
411	31	f
411	32	f
412	69	f
412	32	f
412	34	f
412	46	f
413	23	f
413	60	f
414	56	f
414	2	f
414	3	f
414	4	f
414	5	f
414	6	f
415	53	f
415	57	f
415	5	f
416	69	f
416	23	f
416	28	f
416	10	f
418	17	f
418	21	f
418	22	f
419	19	f
420	35	f
420	36	f
420	3	f
420	8	f
420	45	f
421	41	f
421	42	f
421	29	f
421	31	f
422	57	f
422	4	f
422	19	f
422	28	f
423	65	f
423	66	f
423	46	f
423	35	f
424	38	f
424	39	f
424	40	f
424	65	f
424	66	f
424	67	f
424	17	f
424	21	f
424	61	f
424	64	f
425	30	f
425	31	f
426	48	f
426	49	f
426	51	f
427	2	f
427	62	f
427	47	f
427	51	f
428	38	f
428	40	f
429	43	f
429	10	f
429	13	f
429	16	f
430	11	f
430	13	f
430	56	f
431	61	f
432	22	f
433	33	f
433	34	f
434	2	f
435	17	f
435	18	f
435	21	f
436	30	f
436	32	f
436	33	f
436	63	f
437	24	f
437	28	f
437	36	f
438	65	f
438	69	f
438	9	f
438	10	f
438	13	f
438	40	f
439	30	f
439	28	f
439	50	f
440	9	f
440	16	f
440	58	f
441	5	f
441	8	f
441	18	f
441	55	f
441	58	f
442	25	f
442	10	f
443	62	f
443	9	f
443	12	f
443	16	f
444	69	f
444	54	f
444	57	f
444	28	f
445	3	f
445	55	f
446	10	f
446	14	f
446	29	f
446	60	f
446	61	f
446	36	f
446	40	f
447	40	f
448	65	f
448	69	f
449	29	f
449	35	f
449	38	f
449	40	f
450	31	f
450	32	f
450	57	f
451	53	f
451	58	f
451	16	f
452	47	f
452	48	f
452	50	f
452	60	f
452	63	f
452	11	f
455	69	f
456	13	f
456	29	f
456	31	f
456	47	f
457	65	f
457	67	f
457	47	f
457	50	f
458	17	f
459	12	f
459	4	f
459	30	f
460	48	f
460	50	f
460	31	f
460	34	f
460	68	f
461	18	f
461	20	f
461	21	f
461	67	f
462	27	f
462	22	f
463	38	f
463	61	f
464	10	f
464	14	f
464	41	f
465	5	f
465	8	f
465	19	f
467	16	f
467	55	f
468	53	f
468	18	f
468	22	f
469	36	f
469	39	f
471	6	f
472	1	f
472	8	f
472	21	f
472	42	f
472	45	f
473	68	f
473	10	f
474	37	f
474	20	f
475	48	f
475	49	f
475	50	f
475	2	f
475	6	f
475	43	f
475	44	f
475	46	f
476	44	f
476	46	f
477	19	f
477	22	f
477	45	f
478	55	f
478	29	f
478	30	f
478	31	f
478	33	f
480	29	f
480	30	f
481	50	f
481	52	f
482	29	f
483	47	f
483	52	f
484	43	f
484	45	f
484	9	f
484	13	f
484	16	f
485	20	f
485	24	f
486	37	f
486	22	f
486	28	f
487	41	f
487	44	f
487	46	f
487	1	f
487	3	f
487	5	f
487	7	f
487	65	f
487	66	f
487	67	f
488	1	f
488	6	f
488	8	f
488	60	f
489	37	f
489	40	f
489	10	f
489	13	f
489	44	f
489	46	f
490	64	f
490	40	f
490	54	f
490	57	f
490	47	f
491	62	f
491	64	f
491	67	f
491	35	f
492	45	f
492	18	f
492	20	f
493	24	f
493	26	f
493	27	f
493	59	f
494	30	f
494	33	f
494	34	f
495	8	f
495	34	f
495	10	f
495	16	f
496	1	f
496	4	f
496	7	f
497	19	f
498	41	f
498	45	f
498	17	f
499	9	f
499	11	f
500	64	f
501	32	f
501	42	f
502	45	f
502	29	f
502	30	f
502	31	f
502	36	f
502	37	f
502	39	f
503	56	f
503	8	f
504	27	f
504	62	f
505	61	f
505	63	f
505	69	f
506	41	f
506	42	f
506	45	f
507	29	f
508	38	f
508	40	f
508	2	f
508	70	f
509	1	f
509	3	f
509	8	f
510	59	f
511	41	f
511	43	f
512	39	f
512	48	f
512	50	f
512	51	f
512	3	f
513	42	f
513	53	f
513	55	f
513	58	f
514	61	f
515	12	f
515	21	f
516	52	f
516	55	f
516	56	f
516	57	f
516	29	f
517	61	f
518	4	f
518	5	f
518	29	f
518	49	f
519	55	f
519	56	f
519	57	f
519	42	f
519	45	f
520	31	f
520	32	f
520	57	f
521	19	f
521	22	f
521	28	f
521	70	f
522	63	f
522	64	f
522	3	f
522	32	f
523	50	f
523	54	f
523	55	f
523	58	f
524	10	f
524	16	f
524	23	f
524	24	f
524	26	f
524	27	f
525	43	f
525	67	f
525	69	f
525	37	f
525	40	f
526	53	f
526	57	f
526	58	f
527	36	f
527	38	f
527	45	f
528	13	f
528	16	f
528	49	f
528	51	f
529	67	f
530	41	f
531	54	f
531	59	f
531	39	f
532	31	f
532	34	f
532	50	f
533	47	f
533	49	f
533	50	f
533	52	f
533	19	f
533	20	f
533	32	f
534	28	f
534	3	f
534	4	f
534	7	f
534	8	f
534	68	f
535	10	f
535	11	f
535	14	f
536	41	f
536	43	f
536	44	f
536	2	f
536	35	f
538	32	f
538	36	f
538	39	f
539	23	f
539	26	f
539	28	f
539	43	f
539	57	f
540	23	f
540	24	f
540	26	f
541	51	f
542	24	f
542	19	f
542	20	f
543	62	f
543	30	f
543	33	f
544	24	f
544	25	f
544	26	f
544	41	f
544	45	f
544	46	f
545	31	f
545	65	f
546	54	f
546	55	f
547	12	f
548	55	f
549	25	f
549	48	f
549	50	f
550	18	f
550	20	f
550	42	f
550	44	f
550	30	f
550	34	f
551	63	f
551	64	f
551	53	f
551	55	f
551	18	f
552	28	f
552	55	f
552	58	f
553	11	f
553	14	f
553	16	f
553	3	f
553	8	f
554	13	f
554	14	f
554	16	f
555	3	f
555	5	f
555	7	f
555	12	f
555	16	f
555	31	f
556	50	f
556	51	f
556	53	f
556	55	f
558	1	f
558	51	f
558	66	f
558	67	f
558	9	f
558	14	f
559	27	f
559	30	f
559	32	f
559	39	f
559	40	f
560	22	f
561	23	f
561	25	f
561	52	f
561	34	f
562	38	f
562	13	f
562	15	f
562	16	f
562	64	f
563	50	f
564	3	f
565	54	f
565	57	f
565	40	f
566	17	f
566	21	f
566	68	f
566	69	f
568	7	f
568	56	f
568	57	f
568	15	f
569	13	f
570	9	f
570	13	f
570	17	f
570	21	f
571	28	f
571	59	f
571	62	f
573	11	f
573	13	f
573	15	f
573	50	f
573	24	f
573	25	f
573	28	f
573	57	f
574	26	f
574	27	f
574	50	f
574	5	f
575	55	f
576	18	f
576	28	f
576	64	f
576	40	f
577	18	f
577	21	f
578	55	f
578	56	f
578	57	f
578	35	f
578	37	f
578	40	f
579	36	f
579	2	f
579	6	f
580	64	f
580	66	f
580	42	f
580	44	f
581	66	f
581	49	f
582	68	f
582	62	f
582	54	f
582	55	f
583	55	f
583	39	f
584	49	f
584	51	f
584	65	f
585	45	f
586	60	f
586	64	f
586	4	f
586	6	f
587	17	f
587	18	f
588	39	f
588	24	f
588	26	f
588	27	f
590	68	f
590	9	f
590	14	f
590	15	f
591	46	f
591	1	f
591	7	f
592	21	f
593	36	f
593	39	f
593	14	f
594	17	f
594	19	f
595	65	f
595	69	f
596	67	f
597	1	f
597	2	f
597	6	f
597	46	f
599	10	f
599	12	f
599	13	f
599	41	f
599	42	f
599	44	f
599	45	f
599	46	f
599	2	f
600	9	f
600	11	f
600	13	f
600	16	f
601	52	f
601	43	f
601	44	f
601	46	f
602	35	f
602	40	f
602	19	f
603	48	f
604	42	f
604	43	f
604	46	f
604	3	f
604	17	f
605	69	f
605	35	f
605	3	f
605	4	f
607	24	f
607	25	f
608	70	f
608	61	f
608	54	f
609	67	f
609	70	f
610	16	f
610	63	f
610	64	f
610	48	f
611	9	f
611	12	f
612	29	f
612	31	f
612	33	f
612	41	f
613	53	f
613	56	f
613	48	f
613	13	f
613	25	f
614	65	f
614	70	f
615	32	f
615	33	f
615	12	f
615	14	f
616	61	f
617	35	f
617	37	f
617	38	f
618	1	f
618	5	f
619	44	f
619	46	f
620	5	f
620	6	f
621	8	f
621	10	f
621	11	f
621	15	f
622	47	f
622	52	f
623	49	f
623	51	f
623	67	f
624	67	f
625	2	f
625	17	f
625	18	f
625	22	f
626	29	f
626	30	f
627	24	f
627	25	f
627	27	f
627	28	f
628	46	f
628	9	f
628	59	f
628	62	f
628	63	f
629	37	f
629	40	f
629	1	f
629	4	f
630	8	f
630	16	f
631	25	f
631	26	f
631	49	f
632	49	f
632	51	f
632	52	f
632	17	f
632	21	f
633	47	f
633	51	f
633	52	f
634	68	f
634	69	f
635	28	f
636	8	f
638	35	f
638	40	f
639	49	f
639	52	f
639	2	f
639	4	f
639	5	f
639	12	f
639	13	f
639	14	f
640	17	f
640	19	f
641	67	f
642	9	f
643	41	f
643	45	f
643	53	f
643	56	f
644	23	f
644	15	f
645	31	f
645	18	f
645	21	f
646	66	f
646	67	f
647	2	f
647	17	f
647	62	f
648	68	f
648	17	f
648	18	f
649	70	f
649	22	f
650	47	f
651	63	f
651	64	f
651	25	f
651	2	f
651	7	f
653	35	f
653	39	f
653	40	f
653	20	f
653	21	f
653	22	f
653	23	f
654	18	f
654	21	f
655	25	f
655	65	f
656	50	f
656	61	f
656	62	f
657	57	f
657	47	f
657	52	f
658	60	f
659	49	f
659	51	f
659	6	f
659	8	f
660	42	f
660	43	f
660	5	f
660	6	f
661	2	f
661	8	f
661	42	f
661	45	f
662	64	f
662	53	f
662	66	f
662	69	f
663	47	f
663	9	f
663	11	f
664	61	f
664	2	f
664	3	f
664	4	f
665	45	f
665	46	f
665	18	f
665	19	f
666	59	f
666	60	f
666	70	f
667	11	f
667	16	f
668	26	f
668	27	f
669	41	f
669	45	f
670	12	f
670	13	f
670	15	f
670	20	f
670	21	f
670	46	f
671	35	f
672	50	f
672	51	f
672	52	f
672	26	f
673	9	f
673	13	f
673	14	f
673	15	f
674	27	f
674	21	f
674	22	f
675	36	f
675	40	f
675	60	f
675	33	f
675	34	f
676	48	f
676	50	f
676	40	f
677	8	f
677	18	f
677	20	f
678	32	f
678	55	f
679	32	f
679	53	f
679	56	f
679	57	f
680	18	f
680	20	f
681	1	f
681	2	f
681	5	f
681	6	f
681	10	f
681	11	f
682	53	f
682	54	f
682	55	f
682	1	f
682	4	f
683	40	f
684	40	f
684	48	f
685	32	f
685	34	f
685	2	f
685	3	f
686	43	f
686	45	f
686	46	f
686	49	f
687	27	f
687	1	f
688	60	f
688	63	f
688	67	f
689	54	f
689	37	f
689	38	f
689	40	f
690	4	f
690	5	f
690	6	f
691	10	f
691	13	f
691	15	f
692	60	f
692	4	f
692	6	f
693	65	f
693	66	f
693	70	f
693	61	f
693	64	f
693	37	f
693	19	f
693	21	f
693	22	f
694	52	f
694	59	f
694	61	f
695	18	f
695	20	f
695	32	f
696	5	f
696	29	f
696	33	f
696	34	f
696	41	f
696	46	f
697	20	f
697	46	f
698	60	f
698	64	f
699	22	f
699	33	f
699	34	f
700	20	f
700	21	f
700	2	f
701	51	f
702	25	f
702	60	f
702	53	f
702	58	f
703	24	f
703	26	f
703	28	f
703	43	f
704	9	f
704	11	f
704	15	f
704	19	f
704	20	f
705	42	f
705	45	f
705	46	f
707	11	f
707	13	f
707	15	f
707	52	f
707	22	f
708	52	f
708	66	f
709	1	f
709	23	f
709	26	f
709	28	f
710	66	f
710	68	f
710	69	f
711	16	f
711	69	f
712	63	f
712	13	f
712	53	f
712	57	f
713	30	f
713	36	f
714	17	f
714	59	f
714	61	f
715	50	f
715	51	f
715	52	f
715	30	f
715	32	f
715	33	f
717	35	f
717	40	f
717	14	f
717	56	f
717	57	f
718	70	f
718	27	f
719	66	f
719	67	f
719	29	f
719	51	f
719	52	f
720	51	f
720	33	f
721	53	f
721	59	f
721	61	f
721	63	f
721	41	f
721	42	f
721	43	f
721	44	f
722	29	f
723	16	f
723	23	f
724	29	f
725	33	f
725	34	f
725	13	f
726	27	f
726	28	f
727	29	f
727	33	f
727	34	f
727	67	f
727	69	f
727	13	f
728	1	f
728	5	f
728	45	f
728	32	f
728	33	f
728	34	f
729	27	f
730	28	f
730	50	f
731	41	f
731	12	f
731	14	f
731	15	f
732	24	f
732	53	f
732	58	f
732	50	f
733	32	f
733	18	f
733	20	f
735	3	f
735	7	f
735	51	f
736	20	f
737	60	f
737	61	f
737	63	f
737	64	f
738	46	f
738	25	f
739	24	f
739	25	f
740	30	f
740	34	f
740	42	f
740	43	f
740	45	f
741	7	f
742	9	f
742	10	f
742	64	f
743	41	f
743	43	f
743	46	f
743	67	f
743	68	f
743	69	f
744	56	f
744	11	f
744	12	f
745	54	f
745	47	f
745	50	f
745	51	f
746	40	f
747	6	f
747	28	f
748	41	f
749	38	f
750	29	f
750	31	f
750	65	f
750	68	f
751	29	f
751	31	f
752	35	f
752	37	f
752	65	f
753	29	f
753	30	f
753	34	f
753	2	f
753	3	f
753	4	f
753	6	f
754	7	f
754	57	f
754	58	f
754	35	f
754	36	f
755	21	f
755	44	f
756	63	f
756	53	f
756	55	f
756	57	f
757	17	f
757	18	f
757	4	f
757	5	f
757	6	f
758	51	f
758	52	f
758	41	f
758	42	f
758	53	f
758	55	f
759	41	f
759	16	f
760	40	f
760	68	f
761	57	f
761	7	f
763	17	f
763	48	f
763	60	f
763	61	f
763	62	f
764	23	f
764	24	f
764	60	f
766	48	f
766	49	f
766	51	f
766	4	f
766	6	f
766	7	f
767	41	f
767	46	f
767	4	f
767	8	f
768	17	f
768	53	f
768	55	f
768	1	f
768	7	f
768	8	f
769	3	f
769	14	f
770	15	f
770	24	f
770	25	f
771	9	f
771	37	f
771	27	f
771	28	f
771	45	f
772	9	f
772	11	f
772	12	f
772	55	f
772	57	f
772	63	f
773	68	f
773	69	f
773	1	f
773	3	f
773	4	f
773	6	f
773	7	f
774	37	f
774	38	f
774	2	f
774	3	f
775	60	f
776	68	f
776	42	f
776	43	f
776	46	f
777	58	f
778	65	f
778	67	f
778	68	f
779	63	f
779	2	f
779	4	f
780	54	f
780	56	f
780	47	f
781	54	f
781	56	f
781	25	f
781	48	f
783	69	f
783	62	f
783	63	f
784	38	f
784	39	f
784	29	f
784	26	f
785	51	f
785	34	f
786	57	f
786	4	f
786	7	f
786	8	f
787	47	f
787	7	f
787	8	f
788	66	f
788	68	f
788	69	f
788	70	f
788	16	f
788	63	f
788	64	f
789	19	f
789	20	f
789	64	f
790	55	f
790	33	f
791	45	f
791	17	f
791	18	f
792	43	f
793	65	f
793	45	f
793	18	f
793	20	f
794	12	f
795	61	f
795	64	f
796	66	f
796	67	f
796	68	f
797	35	f
797	60	f
797	63	f
798	20	f
799	17	f
799	20	f
799	41	f
800	63	f
800	9	f
800	15	f
800	44	f
800	21	f
801	61	f
801	64	f
801	39	f
802	63	f
802	21	f
802	43	f
802	44	f
802	45	f
803	9	f
803	16	f
804	23	f
804	27	f
805	57	f
805	46	f
805	18	f
805	22	f
806	61	f
806	2	f
806	6	f
807	17	f
807	18	f
807	22	f
807	4	f
808	18	f
808	21	f
809	50	f
810	50	f
810	36	f
810	37	f
810	38	f
811	28	f
812	4	f
812	6	f
812	17	f
812	18	f
812	22	f
813	22	f
813	6	f
813	60	f
813	63	f
814	53	f
814	55	f
814	57	f
814	39	f
815	32	f
815	34	f
815	54	f
815	55	f
815	56	f
816	3	f
816	4	f
816	66	f
816	70	f
816	56	f
817	40	f
817	33	f
818	39	f
819	35	f
819	37	f
819	39	f
819	9	f
819	14	f
819	33	f
820	8	f
820	50	f
821	60	f
821	53	f
821	54	f
821	57	f
822	22	f
822	67	f
822	69	f
823	23	f
823	25	f
823	26	f
823	19	f
824	60	f
824	62	f
825	61	f
825	42	f
825	43	f
825	23	f
825	28	f
826	17	f
827	4	f
827	7	f
827	10	f
827	11	f
827	12	f
827	13	f
827	14	f
827	15	f
827	16	f
828	63	f
829	69	f
829	23	f
829	48	f
829	52	f
830	37	f
830	40	f
831	53	f
831	58	f
832	35	f
832	39	f
832	23	f
832	26	f
832	7	f
833	65	f
833	68	f
833	63	f
834	2	f
834	5	f
834	38	f
834	52	f
835	29	f
835	30	f
835	18	f
836	19	f
836	25	f
836	31	f
836	34	f
837	23	f
837	24	f
838	20	f
838	21	f
839	67	f
840	5	f
840	6	f
840	7	f
841	9	f
841	12	f
842	55	f
842	56	f
843	58	f
844	49	f
844	52	f
844	9	f
844	11	f
845	4	f
845	6	f
845	66	f
846	69	f
846	9	f
846	11	f
846	12	f
846	14	f
848	27	f
849	65	f
849	66	f
849	69	f
850	29	f
850	43	f
850	57	f
851	32	f
851	66	f
852	36	f
852	39	f
852	40	f
852	11	f
853	65	f
853	67	f
853	68	f
853	69	f
853	23	f
853	26	f
853	34	f
854	62	f
854	25	f
854	28	f
854	7	f
854	47	f
854	52	f
855	1	f
855	5	f
855	8	f
856	67	f
856	70	f
856	24	f
857	9	f
857	11	f
857	12	f
857	16	f
857	50	f
857	51	f
858	10	f
858	15	f
859	51	f
859	18	f
859	21	f
859	22	f
860	19	f
860	3	f
860	5	f
861	58	f
862	66	f
863	66	f
863	67	f
863	68	f
863	69	f
863	42	f
864	17	f
864	18	f
864	62	f
864	9	f
864	11	f
865	23	f
865	25	f
865	28	f
866	67	f
866	68	f
866	58	f
866	9	f
866	11	f
866	12	f
867	30	f
867	33	f
868	39	f
868	40	f
868	6	f
869	23	f
869	25	f
870	63	f
870	52	f
871	27	f
872	21	f
872	32	f
872	34	f
873	64	f
874	34	f
874	17	f
874	19	f
874	20	f
875	39	f
876	36	f
876	38	f
876	40	f
876	54	f
876	57	f
876	58	f
877	33	f
877	34	f
878	2	f
878	6	f
879	20	f
879	49	f
879	51	f
880	62	f
881	28	f
881	69	f
882	42	f
882	66	f
882	67	f
882	69	f
882	2	f
882	5	f
882	8	f
884	68	f
885	41	f
885	44	f
885	9	f
885	12	f
885	16	f
885	66	f
886	66	f
886	68	f
886	69	f
886	27	f
886	54	f
886	56	f
886	41	f
886	45	f
887	25	f
887	47	f
887	50	f
888	44	f
888	56	f
888	57	f
889	37	f
889	40	f
889	9	f
890	10	f
890	13	f
890	16	f
891	41	f
892	17	f
892	14	f
892	43	f
892	46	f
893	57	f
893	41	f
894	33	f
894	21	f
894	6	f
894	7	f
895	3	f
895	4	f
895	5	f
895	7	f
895	54	f
896	29	f
896	32	f
896	33	f
897	18	f
897	21	f
898	29	f
899	10	f
899	12	f
899	13	f
899	15	f
899	16	f
899	36	f
899	37	f
899	39	f
899	40	f
900	29	f
900	30	f
900	25	f
901	15	f
901	16	f
901	28	f
901	50	f
902	35	f
902	36	f
902	40	f
902	66	f
902	70	f
903	65	f
903	66	f
903	60	f
903	62	f
903	38	f
904	65	f
904	68	f
905	36	f
905	44	f
905	11	f
905	49	f
906	14	f
906	35	f
906	37	f
906	38	f
906	4	f
906	7	f
907	38	f
907	39	f
907	40	f
908	25	f
908	27	f
908	5	f
908	68	f
909	10	f
909	21	f
909	41	f
910	45	f
910	1	f
910	4	f
910	8	f
911	36	f
911	40	f
911	12	f
911	13	f
911	14	f
912	27	f
912	66	f
912	34	f
913	16	f
913	68	f
914	48	f
914	49	f
914	51	f
914	17	f
914	36	f
914	37	f
915	59	f
915	62	f
916	53	f
916	58	f
916	29	f
916	34	f
917	54	f
918	26	f
919	68	f
919	54	f
920	54	f
920	31	f
920	32	f
921	69	f
921	48	f
921	52	f
921	13	f
923	70	f
923	41	f
923	44	f
924	54	f
924	7	f
924	50	f
924	52	f
925	18	f
925	52	f
926	29	f
926	34	f
927	56	f
927	22	f
927	1	f
927	2	f
927	7	f
928	18	f
928	19	f
928	44	f
929	44	f
929	15	f
930	54	f
930	58	f
930	1	f
930	5	f
930	59	f
930	64	f
931	35	f
931	40	f
932	30	f
932	31	f
933	29	f
933	30	f
933	53	f
934	21	f
934	33	f
935	13	f
935	16	f
935	2	f
935	3	f
935	4	f
935	5	f
935	6	f
936	19	f
936	20	f
936	21	f
936	22	f
937	35	f
937	61	f
937	62	f
939	66	f
939	70	f
939	60	f
939	64	f
940	3	f
940	11	f
940	15	f
942	35	f
942	38	f
942	68	f
943	17	f
943	49	f
943	51	f
944	67	f
944	69	f
944	70	f
944	17	f
945	30	f
945	48	f
946	2	f
946	7	f
947	53	f
947	54	f
947	56	f
947	42	f
947	43	f
947	7	f
948	21	f
948	56	f
948	57	f
948	58	f
948	41	f
949	30	f
949	32	f
950	35	f
950	38	f
950	62	f
950	64	f
950	66	f
950	67	f
950	69	f
951	43	f
951	44	f
951	35	f
951	38	f
951	4	f
951	7	f
952	3	f
953	31	f
953	33	f
953	52	f
954	43	f
954	46	f
954	22	f
954	27	f
954	49	f
954	51	f
955	1	f
955	7	f
955	11	f
955	13	f
955	55	f
955	57	f
955	58	f
956	55	f
957	41	f
957	42	f
957	43	f
957	44	f
957	46	f
958	44	f
958	24	f
958	33	f
958	34	f
959	53	f
959	57	f
959	59	f
959	62	f
959	64	f
959	3	f
960	57	f
960	9	f
960	15	f
962	17	f
962	65	f
963	45	f
963	46	f
964	59	f
964	61	f
964	64	f
964	6	f
964	68	f
964	70	f
965	10	f
966	42	f
966	1	f
966	2	f
966	61	f
966	63	f
967	53	f
968	57	f
968	38	f
968	40	f
968	25	f
969	66	f
969	69	f
969	26	f
969	2	f
969	3	f
969	7	f
970	28	f
971	36	f
971	38	f
971	46	f
972	54	f
972	9	f
972	10	f
973	2	f
973	41	f
973	26	f
974	35	f
974	11	f
974	16	f
975	41	f
975	17	f
975	20	f
975	22	f
976	12	f
976	13	f
976	34	f
976	35	f
977	36	f
977	38	f
977	31	f
977	33	f
978	35	f
978	38	f
979	45	f
979	40	f
979	50	f
979	52	f
980	42	f
981	30	f
981	31	f
982	61	f
982	42	f
983	23	f
983	27	f
984	52	f
984	26	f
984	27	f
984	28	f
985	41	f
985	43	f
985	46	f
985	68	f
986	35	f
986	36	f
986	38	f
987	37	f
987	47	f
987	67	f
989	32	f
989	48	f
989	49	f
990	55	f
990	56	f
990	15	f
991	14	f
991	20	f
992	44	f
992	45	f
992	66	f
992	67	f
992	68	f
993	61	f
994	24	f
994	26	f
994	28	f
995	26	f
995	28	f
995	58	f
996	47	f
996	51	f
996	37	f
996	38	f
997	43	f
997	46	f
997	8	f
997	53	f
997	47	f
998	58	f
999	42	f
999	44	f
999	56	f
999	57	f
999	13	f
1000	12	f
1001	55	f
1001	37	f
1002	5	f
1002	6	f
1003	55	f
1004	36	f
1005	29	f
1005	34	f
1005	11	f
1006	29	f
1007	29	f
1007	60	f
1007	62	f
1008	33	f
1008	13	f
1009	62	f
1009	63	f
1010	3	f
1010	59	f
1010	61	f
1011	54	f
1011	56	f
1011	58	f
1011	6	f
1012	33	f
1013	64	f
1014	24	f
1014	36	f
1014	67	f
1014	70	f
1014	64	f
1015	34	f
1015	41	f
1016	37	f
1016	39	f
1017	15	f
1017	45	f
1018	35	f
1018	38	f
1018	40	f
1019	26	f
1021	20	f
1021	66	f
1022	16	f
1023	60	f
1024	64	f
1024	23	f
1024	25	f
1024	28	f
1025	4	f
1025	20	f
26	35	t
26	36	t
26	37	t
26	38	t
26	39	t
26	53	t
26	54	t
26	56	t
26	57	t
26	58	t
26	47	t
26	49	t
26	50	t
26	51	t
26	52	t
26	9	t
26	11	t
26	12	t
26	13	t
26	14	t
26	15	t
26	16	t
27	53	t
27	54	t
27	55	t
27	56	t
27	57	t
27	58	t
27	65	t
27	68	t
27	69	t
27	70	t
28	23	t
28	24	t
28	25	t
28	26	t
28	27	t
28	28	t
28	65	t
28	66	t
28	67	t
28	68	t
28	69	t
28	70	t
29	17	t
29	18	t
29	20	t
29	21	t
29	22	t
29	41	t
29	43	t
29	44	t
29	45	t
29	46	t
30	35	t
30	36	t
30	37	t
30	38	t
30	39	t
30	40	t
30	59	t
30	60	t
30	61	t
30	62	t
30	63	t
30	64	t
30	29	t
30	30	t
30	31	t
30	32	t
30	34	t
31	9	t
31	10	t
31	12	t
31	15	t
31	16	t
31	47	t
31	48	t
31	49	t
31	50	t
31	51	t
32	9	t
32	11	t
32	12	t
32	13	t
32	15	t
32	16	t
32	35	t
32	36	t
32	37	t
32	38	t
32	40	t
33	41	t
33	42	t
33	43	t
33	44	t
33	45	t
33	46	t
34	59	t
34	60	t
34	61	t
34	62	t
34	63	t
34	41	t
34	42	t
34	43	t
34	44	t
34	45	t
35	29	t
35	31	t
35	33	t
35	34	t
35	41	t
35	42	t
35	43	t
35	44	t
35	45	t
36	47	t
36	48	t
36	49	t
36	50	t
36	51	t
36	24	t
36	25	t
36	26	t
36	27	t
36	28	t
37	23	t
37	24	t
37	25	t
37	28	t
37	29	t
37	31	t
37	32	t
37	33	t
37	34	t
37	47	t
37	48	t
37	49	t
37	50	t
37	51	t
37	52	t
38	1	t
38	2	t
38	3	t
38	4	t
38	5	t
38	6	t
38	35	t
38	36	t
38	37	t
38	38	t
38	40	t
38	17	t
38	20	t
38	22	t
39	35	t
39	36	t
39	37	t
39	40	t
39	59	t
39	60	t
39	61	t
39	62	t
39	63	t
39	64	t
39	10	t
39	11	t
39	14	t
39	16	t
40	1	t
40	2	t
40	4	t
40	5	t
40	6	t
40	7	t
40	8	t
40	17	t
40	19	t
40	20	t
40	21	t
40	22	t
41	48	t
41	49	t
41	50	t
41	51	t
41	52	t
41	9	t
41	10	t
41	11	t
41	12	t
41	13	t
41	14	t
41	15	t
41	16	t
41	1	t
41	2	t
41	3	t
41	4	t
41	5	t
41	6	t
41	8	t
42	9	t
42	10	t
42	11	t
42	12	t
42	13	t
42	14	t
42	15	t
43	29	t
43	31	t
43	33	t
43	34	t
43	41	t
43	42	t
43	43	t
43	44	t
43	45	t
43	46	t
43	9	t
43	10	t
43	11	t
43	12	t
43	13	t
43	14	t
43	15	t
43	16	t
44	41	t
44	42	t
44	43	t
44	44	t
44	45	t
44	46	t
44	53	t
44	54	t
44	55	t
44	57	t
44	58	t
44	1	t
44	2	t
44	3	t
44	4	t
44	6	t
44	8	t
45	2	t
45	5	t
45	6	t
45	7	t
45	8	t
45	47	t
45	49	t
45	51	t
45	52	t
45	25	t
45	26	t
45	28	t
46	23	t
46	24	t
46	25	t
46	28	t
46	53	t
46	54	t
46	55	t
46	56	t
47	60	t
47	61	t
47	62	t
47	53	t
47	54	t
47	55	t
47	56	t
47	57	t
47	58	t
47	17	t
47	18	t
47	19	t
47	20	t
47	21	t
48	47	t
48	48	t
48	49	t
48	50	t
48	51	t
48	52	t
48	65	t
48	66	t
48	67	t
48	68	t
48	69	t
48	70	t
49	17	t
49	20	t
49	21	t
49	22	t
49	31	t
49	33	t
49	34	t
49	35	t
49	36	t
49	38	t
49	39	t
49	40	t
50	65	t
50	66	t
50	67	t
50	68	t
50	69	t
50	70	t
50	19	t
50	20	t
51	17	t
51	18	t
51	19	t
51	20	t
51	21	t
51	59	t
51	60	t
51	62	t
52	1	t
52	2	t
52	3	t
52	4	t
52	5	t
52	6	t
52	7	t
52	8	t
53	9	t
53	10	t
53	11	t
53	12	t
53	14	t
53	15	t
53	16	t
53	23	t
53	25	t
53	26	t
53	27	t
53	28	t
54	60	t
54	61	t
54	62	t
54	63	t
54	64	t
54	23	t
54	25	t
54	26	t
54	28	t
55	18	t
55	20	t
55	22	t
55	53	t
55	54	t
55	55	t
55	56	t
55	57	t
55	58	t
55	65	t
55	66	t
55	68	t
55	70	t
56	10	t
56	12	t
56	14	t
56	15	t
56	29	t
56	32	t
56	33	t
56	34	t
56	43	t
56	45	t
56	46	t
57	47	t
57	48	t
57	51	t
57	52	t
58	59	t
58	60	t
58	61	t
58	62	t
58	64	t
58	23	t
58	24	t
58	26	t
58	27	t
58	28	t
58	9	t
58	10	t
58	12	t
58	13	t
58	14	t
58	16	t
59	59	t
59	61	t
59	62	t
59	63	t
59	64	t
59	23	t
59	24	t
59	25	t
59	26	t
59	27	t
59	28	t
59	47	t
59	48	t
59	50	t
59	51	t
59	52	t
59	41	t
59	43	t
59	44	t
59	45	t
59	46	t
60	23	t
60	25	t
60	27	t
60	28	t
60	41	t
60	42	t
60	43	t
60	44	t
61	1	t
61	2	t
61	3	t
61	4	t
61	5	t
61	6	t
61	7	t
61	8	t
61	47	t
61	48	t
61	49	t
61	50	t
61	51	t
62	59	t
62	60	t
62	61	t
62	62	t
62	64	t
62	1	t
62	2	t
62	3	t
62	4	t
62	5	t
63	29	t
63	30	t
63	31	t
63	33	t
63	34	t
63	17	t
63	18	t
63	19	t
63	20	t
63	21	t
64	47	t
64	48	t
64	49	t
64	51	t
64	52	t
64	1	t
64	2	t
64	3	t
64	4	t
64	5	t
64	6	t
64	7	t
65	9	t
65	10	t
65	11	t
65	12	t
65	13	t
65	14	t
65	15	t
65	16	t
65	59	t
65	60	t
65	61	t
65	63	t
65	64	t
66	41	t
66	42	t
66	44	t
66	45	t
66	46	t
67	54	t
67	56	t
67	58	t
67	65	t
67	66	t
67	69	t
67	70	t
67	1	t
67	4	t
67	5	t
67	6	t
67	7	t
67	8	t
68	2	t
68	3	t
68	5	t
68	6	t
68	7	t
68	8	t
68	31	t
68	32	t
68	34	t
68	53	t
68	54	t
68	56	t
68	57	t
68	58	t
69	42	t
69	43	t
69	44	t
69	45	t
69	46	t
69	47	t
69	49	t
69	50	t
69	51	t
69	52	t
69	23	t
69	24	t
69	25	t
69	27	t
69	28	t
70	65	t
70	66	t
70	67	t
70	68	t
70	69	t
70	70	t
70	53	t
70	54	t
70	55	t
70	56	t
70	58	t
71	29	t
71	30	t
71	31	t
71	32	t
71	33	t
71	34	t
71	47	t
71	48	t
71	51	t
71	52	t
71	9	t
71	11	t
71	12	t
71	13	t
71	14	t
71	15	t
71	16	t
72	60	t
72	61	t
72	62	t
72	63	t
72	64	t
73	35	t
73	37	t
73	38	t
73	59	t
73	60	t
73	61	t
73	62	t
73	63	t
73	64	t
74	9	t
74	10	t
74	11	t
74	12	t
74	14	t
74	15	t
74	16	t
74	41	t
74	42	t
74	44	t
74	45	t
74	46	t
74	23	t
74	24	t
74	26	t
74	28	t
75	23	t
75	24	t
75	25	t
75	26	t
75	27	t
75	28	t
75	59	t
75	61	t
75	62	t
75	63	t
75	64	t
75	35	t
75	36	t
75	37	t
75	38	t
75	39	t
75	40	t
76	23	t
76	24	t
76	25	t
76	26	t
76	27	t
76	28	t
76	35	t
76	36	t
76	37	t
76	38	t
76	40	t
77	35	t
77	36	t
77	37	t
77	38	t
77	53	t
77	55	t
77	57	t
77	58	t
77	17	t
77	18	t
77	19	t
77	20	t
77	21	t
77	22	t
78	35	t
78	36	t
78	37	t
78	38	t
78	39	t
78	40	t
78	59	t
78	60	t
78	61	t
78	62	t
78	63	t
78	64	t
79	41	t
79	42	t
79	43	t
79	44	t
79	45	t
79	25	t
79	27	t
79	28	t
79	29	t
79	30	t
79	31	t
79	32	t
79	33	t
79	34	t
80	41	t
80	42	t
80	43	t
80	44	t
80	45	t
80	46	t
80	53	t
80	54	t
80	56	t
80	58	t
80	9	t
80	10	t
80	11	t
80	12	t
80	13	t
80	15	t
80	16	t
80	17	t
80	19	t
80	20	t
80	22	t
81	2	t
81	4	t
81	5	t
81	6	t
81	7	t
81	8	t
81	59	t
81	61	t
81	63	t
81	64	t
81	29	t
81	30	t
81	32	t
81	34	t
82	65	t
82	66	t
82	68	t
82	69	t
82	70	t
82	17	t
82	18	t
82	19	t
82	20	t
82	22	t
83	29	t
83	31	t
83	32	t
83	33	t
83	34	t
83	23	t
83	24	t
83	25	t
83	27	t
83	28	t
84	47	t
84	48	t
84	49	t
84	50	t
84	51	t
85	59	t
85	60	t
85	61	t
85	62	t
85	63	t
85	64	t
85	53	t
85	54	t
85	55	t
85	56	t
85	57	t
85	58	t
85	42	t
85	44	t
85	45	t
85	46	t
85	65	t
85	66	t
85	67	t
85	70	t
86	53	t
86	54	t
86	55	t
86	56	t
86	57	t
86	58	t
86	65	t
86	66	t
86	67	t
86	68	t
86	69	t
86	70	t
86	29	t
86	30	t
86	31	t
86	34	t
87	41	t
87	42	t
87	44	t
87	45	t
87	46	t
87	54	t
87	55	t
87	56	t
87	57	t
87	58	t
87	23	t
87	24	t
87	25	t
87	26	t
87	27	t
88	53	t
88	54	t
88	55	t
88	56	t
88	58	t
88	35	t
88	36	t
88	37	t
88	38	t
88	39	t
88	40	t
89	37	t
89	39	t
89	30	t
89	31	t
89	32	t
89	33	t
90	66	t
90	67	t
90	68	t
90	69	t
90	70	t
90	53	t
90	54	t
90	29	t
90	30	t
90	32	t
90	33	t
90	34	t
91	30	t
91	32	t
91	33	t
91	34	t
91	53	t
91	54	t
91	56	t
91	58	t
91	61	t
91	63	t
91	64	t
91	48	t
91	49	t
91	51	t
91	52	t
92	17	t
92	18	t
92	19	t
92	20	t
92	22	t
93	24	t
93	25	t
93	26	t
93	27	t
93	28	t
93	9	t
93	10	t
93	11	t
93	12	t
93	14	t
93	15	t
93	16	t
94	65	t
94	66	t
94	67	t
94	68	t
94	69	t
94	70	t
94	9	t
94	10	t
94	12	t
94	13	t
94	15	t
94	16	t
94	35	t
94	36	t
94	39	t
94	40	t
95	47	t
95	48	t
95	49	t
95	50	t
95	51	t
95	52	t
95	29	t
95	30	t
95	31	t
95	32	t
95	33	t
95	34	t
96	9	t
96	10	t
96	11	t
96	12	t
96	13	t
96	15	t
96	29	t
96	30	t
96	32	t
96	34	t
97	30	t
97	32	t
97	33	t
97	34	t
97	23	t
97	25	t
97	26	t
97	27	t
97	28	t
97	54	t
97	55	t
97	56	t
97	57	t
97	58	t
98	65	t
98	66	t
98	67	t
98	69	t
98	70	t
98	10	t
98	12	t
98	15	t
98	41	t
98	42	t
98	43	t
98	44	t
98	45	t
98	46	t
99	42	t
99	43	t
99	44	t
99	45	t
99	46	t
99	48	t
99	49	t
99	50	t
99	51	t
99	29	t
99	30	t
99	31	t
99	32	t
99	33	t
99	34	t
100	36	t
100	37	t
100	38	t
100	39	t
100	40	t
100	23	t
100	26	t
100	27	t
100	17	t
100	18	t
100	19	t
100	21	t
100	22	t
101	2	t
101	3	t
101	5	t
101	6	t
101	23	t
101	24	t
101	25	t
101	26	t
101	28	t
101	17	t
101	18	t
101	19	t
101	20	t
101	21	t
102	60	t
102	61	t
102	62	t
102	64	t
103	35	t
103	36	t
103	37	t
103	38	t
103	39	t
103	40	t
103	47	t
103	48	t
103	49	t
103	52	t
104	59	t
104	60	t
104	61	t
104	62	t
104	63	t
104	64	t
104	43	t
104	44	t
104	45	t
104	46	t
104	9	t
104	11	t
104	13	t
104	14	t
104	15	t
104	16	t
105	47	t
105	48	t
105	49	t
106	59	t
106	61	t
106	62	t
106	64	t
106	35	t
106	37	t
106	38	t
106	40	t
106	29	t
106	30	t
106	31	t
106	32	t
106	33	t
107	47	t
107	48	t
107	49	t
107	50	t
107	51	t
107	52	t
107	35	t
107	37	t
107	38	t
107	66	t
107	67	t
107	68	t
107	69	t
107	70	t
107	10	t
107	11	t
107	12	t
107	13	t
107	15	t
107	16	t
108	17	t
108	18	t
108	19	t
108	20	t
108	21	t
108	22	t
108	47	t
108	48	t
108	49	t
108	50	t
108	51	t
108	35	t
108	36	t
108	38	t
108	39	t
108	40	t
109	1	t
109	2	t
109	5	t
109	6	t
109	7	t
109	8	t
109	9	t
109	11	t
109	12	t
109	13	t
109	14	t
109	15	t
110	59	t
110	64	t
110	29	t
110	31	t
110	33	t
111	24	t
111	26	t
111	28	t
111	53	t
111	54	t
111	55	t
111	56	t
111	57	t
111	58	t
112	66	t
112	67	t
112	68	t
112	70	t
112	35	t
112	37	t
112	39	t
112	40	t
113	29	t
113	31	t
113	32	t
113	33	t
113	34	t
113	2	t
113	3	t
113	5	t
113	6	t
113	7	t
113	8	t
113	9	t
113	10	t
113	11	t
113	12	t
113	13	t
113	14	t
113	15	t
114	35	t
114	37	t
114	38	t
114	39	t
114	40	t
114	29	t
114	32	t
114	33	t
114	34	t
115	65	t
115	66	t
115	67	t
115	68	t
115	69	t
115	59	t
115	60	t
115	61	t
115	62	t
115	63	t
115	64	t
115	1	t
115	2	t
115	4	t
115	6	t
115	7	t
115	8	t
116	17	t
116	18	t
116	19	t
116	20	t
116	21	t
116	22	t
116	10	t
116	11	t
116	12	t
116	13	t
116	15	t
116	16	t
116	35	t
116	36	t
116	37	t
116	39	t
116	40	t
117	41	t
117	42	t
117	43	t
117	44	t
117	45	t
117	46	t
117	48	t
117	49	t
117	50	t
117	51	t
117	52	t
118	53	t
118	54	t
118	55	t
118	56	t
118	57	t
118	58	t
118	65	t
118	66	t
118	67	t
118	70	t
118	29	t
118	30	t
118	31	t
118	32	t
118	33	t
118	34	t
119	53	t
119	54	t
119	55	t
119	56	t
119	57	t
119	58	t
119	41	t
119	42	t
119	43	t
119	44	t
119	45	t
119	46	t
120	59	t
120	60	t
120	61	t
120	62	t
120	63	t
120	64	t
120	17	t
120	18	t
120	20	t
120	21	t
120	22	t
120	65	t
120	66	t
120	67	t
120	68	t
120	70	t
120	37	t
120	38	t
120	39	t
120	40	t
121	41	t
121	42	t
121	43	t
121	44	t
121	45	t
121	46	t
121	1	t
121	2	t
121	3	t
121	4	t
121	5	t
121	6	t
121	7	t
121	8	t
121	23	t
121	24	t
121	25	t
121	26	t
121	27	t
121	28	t
121	48	t
121	49	t
121	50	t
121	51	t
121	52	t
122	2	t
122	3	t
122	4	t
122	5	t
122	6	t
122	7	t
122	8	t
122	60	t
122	61	t
122	62	t
122	63	t
122	64	t
123	42	t
123	43	t
123	44	t
123	45	t
123	46	t
123	53	t
123	54	t
123	56	t
123	57	t
123	58	t
123	23	t
123	24	t
123	25	t
123	26	t
123	28	t
124	29	t
124	30	t
124	31	t
124	32	t
124	33	t
124	9	t
124	10	t
124	11	t
124	13	t
124	14	t
124	15	t
124	16	t
124	1	t
124	2	t
124	3	t
124	4	t
124	5	t
124	8	t
124	53	t
124	54	t
124	55	t
124	56	t
124	57	t
124	58	t
125	29	t
125	30	t
125	31	t
125	33	t
125	34	t
125	41	t
125	42	t
125	43	t
125	44	t
125	45	t
125	46	t
126	41	t
126	42	t
126	45	t
126	46	t
126	9	t
126	10	t
126	12	t
126	13	t
126	15	t
126	47	t
126	48	t
126	49	t
126	50	t
126	51	t
127	42	t
127	44	t
127	45	t
127	46	t
127	23	t
127	24	t
127	25	t
127	26	t
127	27	t
127	28	t
127	1	t
127	2	t
127	3	t
127	4	t
127	5	t
127	6	t
127	7	t
127	8	t
128	60	t
128	61	t
128	62	t
128	65	t
128	67	t
128	68	t
128	69	t
129	53	t
129	55	t
129	56	t
129	58	t
129	47	t
129	50	t
129	51	t
129	29	t
129	30	t
129	31	t
129	32	t
129	33	t
129	34	t
130	1	t
130	2	t
130	3	t
130	7	t
130	8	t
130	47	t
130	49	t
130	50	t
130	51	t
131	53	t
131	55	t
131	57	t
131	58	t
131	1	t
131	3	t
131	4	t
131	5	t
131	6	t
131	7	t
131	8	t
131	17	t
131	18	t
131	22	t
132	1	t
132	3	t
132	4	t
132	5	t
132	6	t
132	8	t
132	47	t
132	48	t
132	49	t
132	50	t
132	52	t
133	66	t
133	67	t
133	68	t
133	69	t
133	9	t
133	10	t
133	11	t
133	12	t
133	13	t
133	14	t
133	15	t
133	23	t
133	24	t
133	25	t
133	26	t
133	27	t
133	28	t
134	65	t
134	66	t
134	67	t
134	68	t
134	9	t
134	10	t
134	11	t
134	12	t
134	13	t
134	14	t
134	15	t
134	16	t
134	29	t
134	31	t
134	32	t
134	34	t
135	65	t
135	66	t
135	67	t
135	68	t
135	69	t
135	70	t
135	35	t
135	36	t
135	37	t
135	38	t
135	39	t
135	40	t
136	47	t
136	48	t
136	49	t
136	50	t
136	51	t
136	52	t
136	41	t
136	42	t
136	43	t
136	44	t
136	45	t
136	46	t
136	65	t
136	67	t
136	69	t
136	70	t
137	60	t
137	64	t
137	41	t
137	42	t
137	43	t
137	44	t
137	45	t
137	46	t
138	59	t
138	60	t
138	62	t
138	63	t
138	64	t
138	17	t
138	18	t
138	19	t
138	20	t
138	21	t
138	9	t
138	10	t
138	11	t
138	12	t
138	13	t
138	14	t
138	15	t
138	16	t
139	60	t
139	61	t
139	62	t
139	63	t
139	64	t
140	60	t
140	61	t
140	62	t
140	63	t
140	64	t
140	53	t
140	54	t
140	55	t
140	57	t
140	58	t
140	23	t
140	24	t
140	25	t
140	26	t
140	27	t
140	28	t
141	23	t
141	24	t
141	25	t
141	26	t
141	28	t
141	53	t
141	54	t
141	55	t
141	56	t
141	57	t
142	10	t
142	11	t
142	12	t
142	14	t
142	15	t
142	16	t
142	47	t
142	48	t
142	49	t
142	50	t
142	51	t
142	52	t
143	29	t
143	30	t
143	31	t
143	32	t
143	34	t
143	17	t
143	18	t
143	19	t
143	21	t
144	1	t
144	2	t
144	3	t
144	4	t
144	5	t
144	6	t
144	41	t
144	42	t
144	43	t
144	44	t
144	46	t
145	65	t
145	67	t
145	68	t
145	69	t
145	70	t
145	25	t
145	26	t
145	27	t
145	28	t
145	41	t
145	42	t
145	43	t
145	44	t
145	45	t
146	17	t
146	18	t
146	19	t
146	20	t
146	21	t
146	22	t
147	36	t
147	37	t
147	38	t
147	39	t
147	40	t
147	23	t
147	24	t
147	25	t
147	27	t
147	28	t
147	29	t
147	30	t
147	31	t
147	32	t
147	33	t
148	9	t
148	10	t
148	11	t
148	12	t
148	13	t
148	14	t
148	15	t
148	16	t
148	59	t
148	61	t
148	62	t
148	64	t
148	41	t
148	42	t
148	43	t
148	44	t
148	45	t
148	46	t
148	29	t
148	30	t
148	31	t
148	32	t
149	25	t
149	26	t
149	47	t
149	49	t
149	51	t
149	52	t
149	59	t
149	60	t
149	62	t
149	63	t
149	64	t
149	18	t
149	19	t
149	20	t
149	21	t
149	22	t
150	59	t
150	60	t
150	61	t
150	62	t
150	63	t
150	64	t
151	41	t
151	42	t
151	43	t
151	35	t
151	36	t
151	37	t
151	38	t
151	39	t
151	40	t
151	47	t
151	48	t
151	49	t
151	50	t
151	51	t
151	52	t
152	35	t
152	37	t
152	38	t
152	39	t
152	40	t
152	47	t
152	48	t
152	49	t
152	50	t
152	51	t
153	17	t
153	18	t
153	19	t
153	20	t
153	21	t
153	22	t
153	23	t
153	24	t
153	25	t
153	26	t
153	27	t
154	35	t
154	37	t
154	38	t
154	40	t
154	1	t
154	2	t
154	3	t
154	5	t
154	6	t
154	7	t
154	8	t
154	59	t
154	61	t
154	62	t
154	63	t
154	64	t
155	10	t
155	11	t
155	12	t
155	13	t
155	14	t
155	15	t
155	1	t
155	2	t
155	3	t
155	4	t
155	6	t
155	7	t
155	8	t
155	60	t
155	61	t
155	62	t
155	63	t
155	64	t
155	41	t
155	42	t
155	44	t
155	45	t
155	46	t
156	60	t
156	61	t
156	62	t
156	63	t
156	23	t
156	24	t
157	59	t
157	60	t
157	61	t
157	62	t
157	63	t
157	64	t
157	47	t
157	48	t
157	50	t
157	51	t
157	52	t
157	23	t
157	24	t
157	25	t
157	26	t
157	27	t
157	28	t
158	17	t
158	18	t
158	19	t
158	20	t
158	21	t
158	22	t
158	35	t
158	36	t
158	37	t
158	38	t
158	39	t
158	40	t
158	10	t
158	11	t
158	12	t
158	13	t
158	14	t
158	15	t
158	16	t
158	24	t
158	25	t
158	26	t
158	27	t
158	28	t
159	53	t
159	54	t
159	55	t
159	56	t
159	57	t
159	58	t
159	41	t
159	42	t
159	43	t
159	44	t
159	45	t
159	67	t
159	68	t
159	69	t
159	60	t
159	61	t
159	62	t
159	63	t
159	64	t
160	9	t
160	10	t
160	11	t
160	13	t
160	14	t
160	15	t
160	30	t
160	31	t
160	32	t
160	33	t
160	34	t
160	61	t
160	62	t
160	64	t
161	11	t
161	12	t
161	13	t
161	14	t
161	15	t
161	16	t
161	1	t
161	2	t
161	3	t
161	4	t
161	5	t
161	6	t
161	7	t
162	60	t
162	61	t
162	62	t
162	63	t
162	64	t
163	23	t
163	24	t
163	25	t
163	26	t
163	27	t
163	65	t
163	66	t
163	67	t
163	68	t
163	69	t
163	70	t
163	47	t
163	48	t
163	49	t
163	50	t
163	51	t
163	52	t
164	10	t
164	11	t
164	13	t
164	14	t
164	15	t
164	59	t
164	60	t
164	62	t
164	63	t
164	47	t
164	49	t
164	50	t
164	51	t
164	23	t
164	24	t
164	25	t
164	27	t
164	28	t
165	23	t
165	24	t
165	25	t
165	28	t
165	29	t
165	30	t
165	31	t
165	32	t
165	33	t
166	47	t
166	48	t
166	50	t
166	51	t
166	52	t
166	53	t
166	54	t
166	55	t
166	56	t
166	57	t
166	58	t
166	66	t
166	69	t
166	70	t
167	25	t
167	27	t
167	28	t
167	47	t
167	49	t
167	50	t
167	52	t
167	35	t
167	37	t
167	38	t
167	39	t
168	17	t
168	18	t
168	19	t
168	20	t
168	22	t
168	4	t
168	6	t
168	7	t
168	8	t
169	59	t
169	60	t
169	61	t
169	62	t
169	63	t
169	64	t
169	65	t
169	67	t
169	69	t
170	35	t
170	36	t
170	38	t
170	40	t
170	1	t
170	2	t
170	3	t
170	4	t
170	6	t
170	7	t
170	8	t
171	24	t
171	25	t
171	26	t
171	27	t
171	28	t
171	2	t
171	3	t
171	4	t
171	5	t
171	6	t
171	7	t
171	8	t
172	53	t
172	54	t
172	55	t
172	56	t
172	57	t
172	58	t
172	24	t
172	25	t
172	26	t
172	27	t
172	28	t
172	41	t
172	42	t
172	43	t
172	44	t
172	45	t
172	46	t
173	60	t
173	61	t
173	62	t
173	63	t
173	64	t
173	53	t
173	54	t
173	55	t
173	56	t
173	57	t
173	35	t
173	36	t
173	37	t
173	38	t
173	39	t
173	40	t
174	9	t
174	10	t
174	12	t
174	14	t
174	16	t
174	29	t
174	30	t
174	31	t
174	32	t
174	33	t
174	34	t
174	1	t
174	2	t
174	3	t
174	4	t
174	5	t
174	6	t
174	7	t
174	8	t
175	65	t
175	68	t
175	70	t
175	1	t
175	2	t
175	3	t
175	4	t
175	7	t
175	8	t
175	59	t
175	61	t
175	62	t
175	64	t
176	17	t
176	18	t
176	20	t
176	22	t
176	53	t
176	54	t
176	55	t
176	57	t
176	58	t
176	31	t
176	32	t
176	34	t
177	10	t
177	11	t
177	14	t
177	16	t
177	2	t
177	3	t
177	4	t
177	8	t
178	48	t
178	50	t
178	51	t
178	52	t
178	9	t
178	10	t
178	12	t
178	13	t
178	14	t
178	15	t
178	16	t
179	41	t
179	42	t
179	43	t
179	44	t
179	46	t
179	17	t
179	18	t
179	19	t
179	20	t
179	21	t
180	47	t
180	48	t
180	49	t
180	50	t
180	51	t
180	52	t
180	59	t
180	60	t
180	61	t
180	62	t
180	64	t
180	31	t
180	33	t
180	34	t
181	47	t
181	49	t
181	51	t
181	52	t
181	66	t
181	67	t
181	69	t
181	70	t
182	9	t
182	10	t
182	12	t
182	14	t
182	15	t
182	16	t
182	36	t
182	39	t
182	40	t
183	17	t
183	18	t
183	19	t
183	20	t
183	21	t
183	22	t
183	1	t
183	2	t
183	3	t
183	5	t
183	7	t
183	8	t
184	59	t
184	61	t
184	62	t
184	63	t
184	64	t
184	65	t
184	67	t
184	68	t
184	69	t
184	70	t
184	41	t
184	42	t
184	43	t
184	44	t
185	17	t
185	18	t
185	19	t
185	22	t
185	9	t
185	11	t
185	12	t
185	14	t
185	15	t
185	16	t
186	35	t
186	36	t
186	37	t
186	38	t
186	39	t
186	9	t
186	10	t
186	11	t
186	12	t
186	13	t
186	14	t
186	16	t
186	29	t
186	30	t
186	41	t
186	43	t
186	44	t
186	45	t
186	46	t
187	41	t
187	42	t
187	43	t
187	44	t
187	45	t
187	46	t
188	47	t
188	48	t
188	50	t
188	51	t
188	52	t
188	53	t
188	54	t
188	55	t
188	56	t
188	57	t
188	58	t
189	59	t
189	61	t
189	62	t
189	63	t
189	65	t
189	66	t
189	67	t
189	68	t
189	70	t
189	35	t
189	36	t
189	37	t
189	40	t
190	53	t
190	54	t
190	55	t
190	56	t
190	57	t
190	58	t
190	47	t
190	49	t
190	51	t
190	52	t
190	65	t
190	66	t
190	67	t
190	68	t
190	69	t
190	70	t
191	53	t
191	54	t
191	55	t
191	56	t
191	57	t
191	41	t
191	42	t
191	43	t
191	44	t
191	45	t
191	46	t
192	29	t
192	30	t
192	31	t
192	32	t
192	33	t
192	34	t
192	10	t
192	11	t
192	13	t
192	14	t
192	15	t
192	16	t
192	53	t
192	54	t
192	55	t
192	57	t
192	58	t
193	2	t
193	3	t
193	4	t
193	5	t
193	8	t
193	23	t
193	24	t
193	25	t
193	26	t
193	27	t
193	28	t
194	35	t
194	37	t
194	38	t
194	39	t
194	40	t
194	29	t
194	30	t
194	31	t
194	32	t
194	33	t
194	34	t
194	65	t
194	66	t
194	68	t
194	69	t
194	70	t
194	17	t
194	18	t
194	20	t
194	22	t
195	53	t
195	54	t
195	55	t
195	56	t
195	57	t
195	35	t
195	36	t
195	39	t
195	40	t
195	29	t
195	30	t
195	31	t
195	33	t
195	34	t
195	23	t
195	24	t
195	25	t
195	26	t
195	27	t
195	28	t
196	59	t
196	60	t
196	62	t
196	63	t
196	64	t
196	47	t
196	48	t
196	49	t
196	51	t
196	52	t
197	59	t
197	61	t
197	62	t
197	63	t
197	17	t
197	18	t
197	19	t
197	20	t
197	21	t
197	22	t
198	53	t
198	54	t
198	56	t
198	57	t
198	58	t
198	41	t
198	42	t
198	43	t
198	45	t
198	46	t
198	1	t
198	2	t
198	3	t
198	4	t
198	5	t
198	6	t
198	7	t
198	8	t
199	1	t
199	2	t
199	3	t
199	4	t
199	5	t
199	7	t
199	53	t
199	54	t
199	56	t
199	57	t
199	58	t
199	66	t
199	67	t
199	68	t
199	69	t
199	70	t
200	35	t
200	36	t
200	37	t
200	39	t
200	40	t
200	65	t
200	66	t
200	67	t
200	68	t
200	69	t
200	70	t
200	23	t
200	24	t
200	26	t
200	27	t
200	28	t
200	9	t
200	10	t
200	12	t
200	14	t
200	16	t
201	1	t
201	3	t
201	4	t
201	5	t
201	6	t
201	8	t
201	29	t
201	30	t
201	31	t
201	32	t
201	33	t
202	48	t
202	50	t
202	51	t
202	52	t
203	47	t
203	49	t
203	51	t
203	52	t
203	29	t
203	30	t
203	32	t
203	33	t
203	34	t
204	41	t
204	42	t
204	44	t
204	46	t
204	29	t
204	30	t
204	32	t
204	33	t
204	34	t
204	1	t
204	2	t
204	3	t
204	4	t
204	5	t
204	7	t
205	41	t
205	43	t
205	44	t
205	45	t
205	46	t
205	48	t
205	49	t
205	50	t
205	52	t
205	65	t
205	66	t
205	69	t
205	70	t
206	9	t
206	10	t
206	11	t
206	13	t
206	15	t
206	16	t
206	60	t
206	61	t
206	62	t
206	63	t
206	64	t
206	65	t
206	67	t
206	69	t
206	70	t
207	41	t
207	42	t
207	43	t
207	44	t
207	45	t
207	46	t
207	59	t
207	60	t
207	61	t
207	62	t
207	63	t
208	35	t
208	36	t
208	37	t
208	38	t
208	39	t
208	40	t
208	53	t
208	54	t
208	55	t
208	56	t
208	57	t
208	58	t
209	48	t
209	49	t
209	50	t
209	51	t
209	59	t
209	61	t
209	63	t
209	1	t
209	4	t
209	5	t
209	6	t
209	7	t
209	8	t
210	9	t
210	11	t
210	12	t
210	13	t
210	14	t
210	15	t
210	47	t
210	48	t
210	49	t
210	50	t
210	52	t
211	1	t
211	2	t
211	3	t
211	4	t
211	5	t
211	6	t
211	7	t
212	17	t
212	18	t
212	19	t
212	20	t
212	21	t
212	22	t
212	50	t
212	52	t
212	35	t
212	36	t
212	38	t
212	39	t
212	40	t
213	47	t
213	48	t
213	49	t
213	50	t
213	59	t
213	60	t
214	41	t
214	43	t
214	44	t
214	45	t
214	46	t
214	9	t
214	10	t
214	11	t
214	12	t
214	13	t
214	15	t
214	23	t
214	24	t
214	25	t
214	26	t
214	27	t
215	36	t
215	38	t
215	39	t
215	23	t
215	24	t
215	25	t
215	26	t
215	27	t
215	28	t
215	9	t
215	10	t
215	11	t
215	12	t
215	13	t
215	14	t
215	15	t
215	16	t
216	9	t
216	10	t
216	11	t
216	12	t
216	14	t
216	15	t
216	16	t
216	54	t
216	55	t
216	56	t
216	57	t
216	58	t
217	17	t
217	18	t
217	19	t
217	20	t
217	22	t
217	48	t
217	49	t
217	50	t
217	51	t
217	52	t
217	53	t
217	55	t
217	56	t
217	57	t
218	1	t
218	2	t
218	3	t
218	4	t
218	5	t
218	6	t
218	7	t
219	36	t
219	38	t
219	39	t
219	40	t
219	18	t
219	19	t
219	20	t
219	47	t
219	48	t
219	49	t
219	50	t
219	51	t
219	52	t
220	53	t
220	54	t
220	55	t
220	57	t
220	58	t
220	47	t
220	48	t
220	49	t
220	50	t
220	51	t
220	52	t
220	1	t
220	2	t
220	5	t
220	6	t
220	7	t
220	8	t
221	35	t
221	36	t
221	37	t
221	38	t
221	39	t
221	40	t
221	10	t
221	11	t
221	13	t
221	14	t
221	15	t
221	16	t
221	65	t
221	66	t
221	67	t
221	68	t
221	69	t
221	70	t
222	59	t
222	60	t
222	62	t
222	63	t
222	64	t
222	1	t
222	3	t
222	4	t
222	5	t
222	6	t
222	7	t
222	8	t
223	47	t
223	48	t
223	49	t
223	50	t
223	51	t
223	52	t
224	9	t
224	10	t
224	11	t
224	12	t
224	13	t
224	14	t
224	15	t
224	16	t
224	1	t
224	2	t
224	3	t
224	5	t
224	6	t
224	7	t
224	59	t
224	60	t
224	61	t
224	62	t
224	63	t
224	64	t
225	54	t
225	55	t
225	56	t
225	57	t
225	58	t
225	41	t
225	43	t
225	44	t
225	46	t
225	37	t
225	38	t
225	39	t
226	53	t
226	54	t
226	56	t
226	57	t
226	58	t
226	23	t
226	24	t
226	25	t
226	26	t
226	28	t
227	23	t
227	24	t
227	25	t
227	26	t
227	27	t
227	28	t
227	59	t
227	60	t
227	61	t
227	62	t
227	63	t
227	64	t
228	17	t
228	18	t
228	19	t
228	21	t
228	22	t
228	69	t
228	70	t
228	41	t
228	42	t
228	43	t
228	59	t
228	60	t
228	61	t
228	62	t
228	63	t
228	64	t
229	41	t
229	42	t
229	43	t
229	44	t
229	45	t
229	46	t
229	23	t
229	24	t
229	25	t
229	26	t
229	27	t
229	28	t
230	9	t
230	10	t
230	11	t
230	12	t
230	13	t
230	14	t
230	15	t
230	16	t
230	23	t
230	27	t
230	28	t
230	35	t
230	37	t
230	38	t
230	39	t
230	40	t
230	1	t
230	2	t
230	3	t
230	5	t
230	6	t
230	7	t
230	8	t
231	9	t
231	10	t
231	11	t
231	12	t
231	13	t
231	14	t
231	16	t
231	29	t
231	30	t
231	31	t
231	32	t
231	33	t
231	34	t
232	29	t
232	30	t
232	31	t
232	32	t
232	33	t
232	34	t
232	2	t
232	3	t
232	4	t
232	5	t
233	9	t
233	10	t
233	12	t
233	13	t
233	14	t
233	15	t
233	16	t
233	1	t
233	2	t
233	4	t
233	5	t
233	6	t
233	7	t
233	65	t
233	66	t
233	67	t
233	68	t
233	69	t
233	70	t
234	35	t
234	36	t
234	39	t
234	40	t
234	29	t
234	31	t
234	9	t
234	10	t
234	13	t
234	14	t
234	15	t
234	16	t
234	17	t
234	18	t
234	19	t
234	20	t
234	21	t
234	22	t
235	47	t
235	48	t
235	49	t
235	50	t
235	51	t
235	41	t
235	42	t
235	43	t
235	44	t
235	45	t
235	46	t
236	53	t
236	56	t
236	57	t
236	58	t
236	17	t
236	18	t
236	19	t
236	21	t
236	22	t
237	54	t
237	55	t
237	57	t
237	58	t
237	47	t
237	48	t
237	49	t
237	50	t
237	51	t
237	65	t
237	66	t
237	67	t
237	69	t
237	70	t
237	37	t
237	38	t
238	1	t
238	3	t
238	5	t
238	6	t
238	8	t
238	17	t
238	18	t
238	20	t
238	21	t
238	65	t
238	66	t
238	67	t
238	69	t
238	70	t
239	35	t
239	36	t
239	37	t
239	38	t
239	39	t
239	40	t
239	1	t
239	2	t
239	3	t
239	4	t
239	6	t
239	7	t
239	8	t
240	35	t
240	36	t
240	37	t
240	38	t
240	40	t
240	10	t
240	11	t
240	12	t
240	13	t
240	14	t
240	15	t
240	16	t
241	24	t
241	25	t
241	26	t
241	27	t
241	28	t
241	59	t
241	60	t
241	61	t
241	62	t
241	64	t
242	10	t
242	11	t
242	14	t
242	15	t
242	16	t
242	17	t
242	19	t
242	21	t
242	22	t
242	41	t
242	42	t
242	44	t
242	45	t
242	46	t
243	9	t
243	10	t
243	11	t
243	12	t
243	13	t
243	14	t
243	15	t
243	16	t
243	1	t
243	2	t
243	3	t
243	4	t
243	5	t
243	6	t
243	7	t
243	8	t
243	17	t
243	18	t
243	19	t
244	37	t
244	38	t
244	39	t
244	40	t
244	47	t
244	48	t
244	49	t
244	50	t
244	51	t
244	52	t
245	1	t
245	2	t
245	3	t
245	4	t
245	6	t
245	7	t
245	8	t
245	65	t
245	67	t
245	68	t
245	69	t
245	70	t
246	17	t
246	18	t
246	19	t
246	20	t
246	22	t
246	36	t
246	37	t
246	38	t
246	39	t
247	18	t
247	19	t
247	21	t
247	22	t
247	35	t
247	36	t
247	39	t
247	40	t
247	1	t
247	2	t
247	3	t
247	4	t
247	5	t
247	6	t
247	7	t
248	23	t
248	24	t
248	25	t
248	26	t
248	27	t
248	28	t
248	65	t
248	66	t
248	67	t
248	69	t
249	41	t
249	42	t
249	43	t
249	44	t
249	45	t
249	46	t
249	59	t
249	60	t
249	61	t
249	62	t
249	63	t
249	64	t
249	47	t
249	48	t
249	49	t
249	51	t
249	52	t
250	1	t
250	2	t
250	3	t
250	4	t
250	5	t
250	6	t
250	7	t
250	8	t
250	23	t
250	24	t
250	25	t
250	26	t
250	27	t
250	28	t
250	53	t
250	54	t
250	56	t
250	58	t
251	59	t
251	60	t
251	62	t
251	63	t
251	29	t
251	30	t
251	32	t
251	34	t
252	65	t
252	66	t
252	67	t
252	68	t
252	69	t
252	70	t
252	35	t
252	36	t
252	38	t
252	40	t
253	17	t
253	20	t
253	9	t
253	10	t
253	11	t
253	12	t
253	13	t
253	14	t
253	15	t
253	16	t
254	47	t
254	48	t
254	49	t
254	51	t
254	52	t
254	17	t
254	18	t
254	19	t
254	20	t
254	21	t
254	22	t
254	30	t
254	31	t
254	32	t
254	33	t
254	34	t
255	29	t
255	30	t
255	32	t
255	35	t
255	38	t
255	39	t
255	40	t
255	65	t
255	66	t
255	67	t
255	68	t
255	69	t
255	70	t
256	29	t
256	31	t
256	32	t
256	33	t
256	34	t
257	41	t
257	43	t
257	44	t
257	46	t
258	1	t
258	2	t
258	3	t
258	4	t
258	6	t
258	7	t
258	8	t
258	47	t
258	50	t
258	51	t
258	41	t
258	42	t
258	43	t
258	44	t
258	45	t
258	46	t
258	65	t
258	67	t
258	68	t
258	69	t
258	70	t
259	53	t
259	54	t
259	55	t
259	56	t
259	57	t
259	58	t
259	1	t
259	2	t
259	3	t
259	4	t
259	7	t
260	53	t
260	55	t
260	56	t
260	57	t
260	58	t
260	17	t
260	18	t
260	19	t
260	20	t
260	22	t
261	17	t
261	18	t
261	19	t
261	20	t
261	21	t
261	41	t
261	42	t
261	43	t
261	44	t
261	46	t
262	66	t
262	68	t
262	69	t
262	70	t
262	9	t
262	10	t
262	11	t
262	12	t
262	15	t
262	16	t
262	41	t
262	42	t
262	43	t
262	45	t
262	46	t
263	23	t
263	24	t
263	26	t
263	27	t
263	28	t
263	18	t
263	19	t
263	20	t
263	22	t
264	29	t
264	30	t
264	31	t
264	34	t
264	35	t
264	36	t
264	37	t
264	38	t
265	1	t
265	2	t
265	3	t
265	4	t
265	6	t
265	8	t
265	59	t
265	60	t
265	61	t
265	62	t
265	63	t
265	64	t
265	29	t
265	30	t
265	32	t
265	33	t
266	66	t
266	68	t
266	69	t
266	70	t
266	47	t
266	48	t
266	49	t
266	50	t
266	51	t
266	52	t
267	59	t
267	60	t
267	62	t
267	63	t
267	64	t
267	53	t
267	55	t
267	56	t
267	57	t
267	58	t
268	65	t
268	66	t
268	67	t
268	68	t
268	70	t
268	60	t
268	61	t
268	62	t
268	63	t
268	64	t
269	3	t
269	5	t
269	6	t
269	7	t
269	8	t
269	41	t
269	43	t
269	44	t
269	45	t
269	46	t
269	48	t
269	50	t
269	51	t
269	52	t
270	35	t
270	36	t
270	38	t
270	39	t
270	65	t
270	66	t
270	67	t
270	68	t
270	69	t
270	70	t
270	41	t
270	43	t
270	44	t
270	45	t
270	46	t
271	17	t
271	18	t
271	20	t
271	21	t
271	22	t
271	23	t
271	24	t
271	25	t
271	26	t
271	27	t
271	28	t
272	47	t
272	48	t
272	50	t
272	52	t
272	9	t
272	10	t
272	11	t
272	15	t
272	16	t
273	9	t
273	10	t
273	11	t
273	13	t
273	14	t
273	15	t
273	16	t
273	65	t
273	68	t
273	69	t
273	70	t
274	59	t
274	60	t
274	61	t
274	63	t
274	64	t
274	36	t
274	37	t
274	53	t
274	54	t
274	55	t
274	56	t
274	57	t
274	58	t
275	18	t
275	19	t
275	20	t
275	21	t
275	22	t
275	48	t
275	49	t
275	50	t
275	51	t
275	52	t
275	9	t
275	11	t
275	12	t
275	13	t
275	14	t
275	15	t
275	16	t
276	41	t
276	42	t
276	43	t
276	44	t
276	45	t
276	46	t
276	60	t
276	61	t
276	62	t
276	63	t
276	64	t
276	65	t
276	66	t
276	67	t
276	68	t
276	69	t
276	70	t
277	23	t
277	25	t
277	26	t
277	27	t
277	28	t
277	35	t
277	37	t
277	38	t
277	40	t
278	48	t
278	50	t
278	52	t
278	41	t
278	42	t
278	43	t
278	44	t
278	45	t
278	46	t
278	30	t
278	31	t
278	33	t
278	34	t
279	9	t
279	10	t
279	11	t
279	12	t
279	13	t
279	14	t
279	15	t
279	41	t
279	42	t
279	43	t
279	44	t
279	45	t
279	1	t
279	2	t
279	3	t
279	5	t
279	6	t
279	7	t
279	8	t
280	29	t
280	30	t
280	32	t
280	33	t
280	34	t
280	65	t
280	67	t
280	68	t
280	70	t
281	19	t
281	20	t
281	22	t
281	35	t
281	36	t
281	37	t
281	38	t
281	39	t
281	40	t
282	17	t
282	19	t
282	20	t
282	21	t
282	22	t
282	65	t
282	66	t
282	67	t
282	69	t
282	70	t
283	53	t
283	54	t
283	55	t
283	56	t
283	57	t
283	58	t
283	41	t
283	42	t
283	43	t
283	44	t
283	47	t
283	48	t
283	49	t
283	50	t
283	51	t
283	52	t
284	29	t
284	30	t
284	31	t
284	33	t
284	34	t
284	35	t
284	37	t
284	39	t
285	10	t
285	11	t
285	13	t
285	14	t
285	15	t
285	16	t
285	59	t
285	61	t
285	62	t
285	63	t
285	64	t
285	35	t
285	36	t
285	37	t
285	38	t
285	40	t
286	29	t
286	30	t
286	32	t
286	47	t
286	49	t
286	50	t
286	51	t
286	52	t
286	60	t
286	61	t
286	62	t
287	53	t
287	54	t
287	55	t
287	56	t
287	57	t
287	58	t
287	29	t
287	30	t
287	31	t
287	32	t
287	34	t
287	41	t
287	43	t
287	44	t
287	45	t
287	46	t
288	9	t
288	10	t
288	11	t
288	12	t
288	13	t
288	14	t
288	15	t
288	16	t
288	29	t
288	30	t
288	31	t
288	32	t
288	53	t
288	54	t
288	55	t
288	56	t
288	57	t
288	58	t
288	42	t
288	43	t
288	45	t
288	46	t
289	24	t
289	26	t
289	27	t
289	28	t
289	47	t
289	48	t
289	49	t
289	50	t
289	51	t
289	52	t
290	35	t
290	36	t
290	37	t
290	38	t
290	39	t
290	40	t
290	48	t
290	49	t
290	50	t
290	51	t
290	52	t
291	41	t
291	42	t
291	43	t
291	44	t
291	45	t
291	46	t
291	30	t
291	31	t
291	32	t
291	33	t
291	34	t
292	9	t
292	10	t
292	11	t
292	12	t
292	13	t
292	14	t
292	35	t
292	36	t
292	37	t
292	38	t
292	39	t
292	40	t
292	65	t
292	66	t
292	67	t
292	69	t
292	70	t
293	47	t
293	48	t
293	50	t
293	51	t
293	52	t
294	10	t
294	12	t
294	13	t
294	15	t
294	16	t
294	53	t
294	56	t
294	57	t
294	58	t
295	35	t
295	36	t
295	37	t
295	38	t
295	39	t
295	40	t
295	65	t
295	66	t
295	67	t
295	68	t
295	69	t
295	70	t
296	1	t
296	2	t
296	3	t
296	4	t
296	5	t
296	8	t
296	23	t
296	24	t
296	25	t
296	26	t
296	27	t
296	28	t
297	41	t
297	42	t
297	43	t
297	44	t
297	45	t
297	46	t
298	60	t
298	61	t
298	62	t
298	63	t
298	64	t
299	42	t
299	43	t
299	44	t
299	45	t
299	46	t
299	53	t
299	55	t
299	56	t
300	9	t
300	12	t
300	14	t
300	16	t
300	17	t
300	18	t
300	19	t
300	20	t
300	21	t
300	22	t
301	29	t
301	30	t
301	31	t
301	32	t
301	33	t
301	34	t
301	18	t
301	19	t
301	20	t
301	22	t
302	53	t
302	55	t
302	56	t
302	57	t
302	1	t
302	2	t
302	3	t
302	4	t
302	6	t
302	8	t
303	17	t
303	18	t
303	20	t
303	21	t
303	22	t
303	23	t
303	24	t
303	26	t
303	27	t
303	28	t
303	59	t
303	61	t
303	62	t
303	63	t
303	64	t
304	65	t
304	67	t
304	68	t
304	70	t
304	10	t
304	11	t
304	12	t
304	13	t
304	14	t
304	15	t
304	41	t
304	43	t
304	44	t
304	45	t
304	46	t
305	59	t
305	60	t
305	61	t
305	62	t
305	63	t
305	35	t
305	36	t
305	37	t
305	38	t
305	39	t
305	40	t
305	54	t
305	56	t
305	57	t
305	58	t
306	1	t
306	2	t
306	3	t
306	4	t
306	6	t
306	8	t
306	17	t
306	18	t
306	20	t
306	21	t
306	22	t
307	53	t
307	54	t
307	55	t
307	56	t
307	57	t
307	58	t
308	9	t
308	10	t
308	11	t
308	12	t
308	13	t
308	14	t
308	15	t
308	16	t
308	42	t
308	43	t
308	44	t
308	45	t
309	54	t
309	55	t
309	56	t
309	57	t
310	47	t
310	48	t
310	49	t
310	50	t
310	52	t
310	1	t
310	2	t
310	3	t
310	4	t
310	8	t
310	9	t
310	10	t
310	11	t
310	13	t
310	14	t
310	16	t
311	35	t
311	37	t
311	38	t
311	40	t
311	23	t
311	24	t
311	25	t
311	26	t
311	27	t
311	28	t
311	29	t
311	32	t
311	33	t
311	34	t
312	41	t
312	42	t
312	43	t
312	44	t
312	45	t
312	46	t
313	23	t
313	24	t
313	25	t
313	27	t
313	60	t
313	61	t
313	62	t
313	63	t
313	64	t
314	48	t
314	49	t
314	50	t
314	51	t
314	52	t
314	23	t
314	24	t
314	25	t
314	26	t
314	27	t
314	28	t
314	41	t
314	42	t
314	43	t
314	45	t
314	46	t
315	17	t
315	19	t
315	20	t
315	21	t
315	22	t
315	9	t
315	10	t
315	11	t
315	12	t
315	13	t
315	15	t
315	41	t
315	42	t
315	43	t
315	44	t
315	45	t
315	46	t
316	41	t
316	42	t
316	43	t
316	44	t
316	35	t
316	36	t
316	37	t
316	38	t
316	40	t
316	47	t
316	48	t
316	49	t
316	50	t
316	51	t
316	52	t
317	23	t
317	24	t
317	25	t
317	26	t
317	28	t
317	47	t
317	48	t
317	50	t
317	51	t
317	52	t
317	59	t
317	60	t
317	61	t
317	62	t
317	63	t
317	64	t
317	1	t
317	2	t
317	3	t
317	4	t
317	5	t
317	6	t
317	7	t
318	35	t
318	36	t
318	37	t
318	38	t
318	42	t
318	43	t
318	44	t
318	45	t
318	65	t
318	67	t
318	68	t
318	69	t
319	66	t
319	67	t
319	68	t
319	69	t
319	70	t
319	53	t
319	54	t
319	55	t
319	56	t
319	57	t
319	58	t
320	29	t
320	30	t
320	32	t
320	33	t
320	34	t
320	3	t
320	4	t
320	6	t
320	7	t
320	8	t
320	41	t
320	42	t
320	43	t
320	45	t
320	46	t
320	47	t
320	48	t
320	49	t
320	50	t
320	51	t
320	52	t
321	23	t
321	25	t
321	27	t
321	28	t
321	65	t
321	66	t
321	67	t
321	68	t
321	69	t
321	70	t
321	47	t
321	48	t
321	49	t
321	50	t
321	51	t
321	52	t
322	59	t
322	60	t
322	61	t
322	63	t
322	53	t
322	54	t
322	56	t
322	57	t
323	60	t
323	61	t
323	62	t
323	64	t
323	47	t
323	48	t
323	49	t
323	50	t
323	51	t
323	52	t
324	59	t
324	60	t
324	61	t
324	62	t
324	63	t
324	64	t
324	53	t
324	54	t
324	55	t
324	56	t
324	57	t
324	58	t
324	30	t
324	32	t
324	33	t
324	34	t
325	35	t
325	36	t
325	37	t
325	38	t
325	39	t
325	40	t
326	42	t
326	44	t
326	45	t
326	46	t
326	29	t
326	30	t
326	31	t
326	32	t
326	33	t
326	34	t
326	35	t
326	36	t
326	39	t
326	40	t
327	9	t
327	10	t
327	11	t
327	13	t
327	15	t
327	16	t
327	17	t
327	18	t
327	19	t
327	20	t
327	22	t
327	23	t
327	25	t
327	26	t
327	27	t
327	28	t
328	29	t
328	30	t
328	31	t
328	32	t
328	33	t
328	34	t
328	66	t
328	67	t
328	69	t
329	47	t
329	48	t
329	50	t
329	51	t
329	52	t
329	17	t
329	19	t
329	20	t
329	21	t
329	22	t
329	23	t
329	24	t
329	25	t
329	26	t
329	27	t
329	28	t
330	53	t
330	54	t
330	55	t
330	57	t
330	58	t
331	1	t
331	3	t
331	4	t
331	6	t
331	7	t
331	8	t
331	43	t
331	44	t
331	45	t
331	46	t
331	53	t
331	55	t
331	56	t
331	57	t
332	47	t
332	48	t
332	49	t
332	50	t
332	52	t
333	23	t
333	24	t
333	25	t
333	26	t
333	27	t
333	17	t
333	18	t
333	19	t
333	20	t
333	22	t
333	59	t
333	60	t
333	61	t
333	62	t
333	63	t
333	64	t
334	17	t
334	18	t
334	20	t
334	21	t
334	47	t
334	48	t
334	49	t
334	50	t
334	51	t
334	52	t
334	9	t
334	11	t
334	12	t
334	13	t
334	14	t
334	16	t
335	9	t
335	10	t
335	13	t
335	14	t
335	15	t
335	16	t
335	35	t
335	36	t
335	37	t
335	38	t
335	39	t
335	40	t
336	9	t
336	10	t
336	11	t
336	12	t
336	13	t
336	15	t
336	16	t
336	47	t
336	48	t
336	50	t
336	51	t
336	36	t
336	37	t
336	38	t
336	39	t
336	40	t
337	54	t
337	55	t
337	57	t
337	58	t
337	59	t
337	60	t
337	61	t
337	62	t
337	63	t
337	64	t
337	23	t
337	24	t
337	25	t
337	26	t
337	28	t
338	17	t
338	18	t
338	19	t
338	20	t
338	21	t
338	22	t
338	42	t
338	43	t
338	44	t
338	46	t
338	2	t
338	3	t
338	4	t
338	6	t
339	36	t
339	37	t
339	38	t
339	39	t
339	65	t
339	66	t
339	67	t
339	68	t
339	69	t
339	70	t
340	30	t
340	31	t
340	32	t
340	33	t
340	1	t
340	2	t
340	3	t
340	4	t
340	5	t
340	6	t
340	8	t
340	42	t
340	44	t
340	45	t
340	46	t
341	35	t
341	36	t
341	37	t
341	38	t
341	39	t
341	40	t
341	48	t
341	52	t
341	41	t
341	42	t
341	44	t
341	45	t
341	46	t
341	1	t
341	3	t
341	4	t
341	5	t
341	6	t
341	7	t
341	8	t
342	47	t
342	49	t
342	50	t
342	51	t
342	52	t
342	17	t
342	18	t
342	19	t
342	21	t
342	22	t
342	53	t
342	55	t
342	57	t
342	58	t
343	41	t
343	42	t
343	44	t
343	46	t
343	18	t
343	19	t
343	21	t
343	22	t
343	35	t
343	36	t
343	37	t
343	38	t
343	39	t
344	23	t
344	24	t
344	25	t
344	26	t
344	27	t
344	28	t
344	65	t
344	66	t
344	67	t
344	68	t
344	69	t
344	70	t
344	1	t
344	2	t
344	3	t
344	4	t
344	5	t
344	8	t
345	47	t
345	48	t
345	49	t
345	50	t
345	52	t
345	65	t
345	67	t
345	68	t
345	69	t
345	70	t
345	17	t
345	18	t
345	20	t
345	21	t
346	35	t
346	36	t
346	37	t
346	38	t
346	39	t
346	54	t
346	55	t
346	56	t
346	58	t
347	17	t
347	18	t
347	19	t
347	20	t
347	21	t
347	22	t
347	35	t
347	36	t
347	38	t
347	39	t
347	40	t
347	29	t
347	30	t
347	32	t
347	33	t
347	34	t
348	17	t
348	20	t
348	21	t
348	22	t
348	41	t
348	42	t
348	43	t
348	45	t
348	46	t
348	36	t
348	37	t
348	38	t
348	39	t
348	40	t
349	29	t
349	30	t
349	31	t
349	32	t
349	33	t
349	34	t
349	59	t
349	60	t
349	61	t
349	62	t
349	63	t
349	64	t
349	23	t
349	24	t
349	25	t
349	26	t
349	27	t
349	28	t
350	29	t
350	30	t
350	31	t
350	32	t
350	33	t
350	41	t
350	42	t
350	43	t
350	44	t
350	45	t
350	46	t
350	2	t
350	3	t
350	4	t
350	5	t
350	6	t
350	7	t
351	29	t
351	30	t
351	31	t
351	32	t
351	34	t
351	35	t
351	37	t
351	38	t
351	39	t
351	40	t
351	17	t
351	18	t
351	19	t
351	20	t
351	21	t
352	47	t
352	48	t
352	50	t
352	51	t
352	52	t
352	59	t
352	61	t
352	62	t
352	63	t
352	64	t
353	1	t
353	3	t
353	4	t
353	6	t
353	7	t
353	8	t
353	65	t
353	67	t
353	70	t
353	53	t
353	54	t
353	57	t
353	58	t
354	9	t
354	10	t
354	11	t
354	12	t
354	13	t
354	14	t
354	15	t
354	16	t
354	47	t
354	48	t
354	50	t
354	51	t
354	52	t
354	53	t
354	54	t
354	55	t
354	56	t
354	57	t
354	58	t
355	59	t
355	60	t
355	62	t
355	63	t
355	64	t
356	65	t
356	68	t
356	69	t
356	70	t
356	1	t
356	3	t
356	5	t
356	7	t
356	8	t
357	65	t
357	66	t
357	67	t
357	68	t
357	69	t
357	70	t
357	60	t
357	61	t
357	62	t
357	63	t
357	64	t
357	10	t
357	11	t
357	12	t
357	13	t
357	15	t
358	29	t
358	30	t
358	31	t
358	32	t
358	33	t
359	47	t
359	48	t
359	49	t
359	50	t
359	51	t
359	52	t
359	17	t
359	18	t
359	19	t
359	21	t
359	22	t
360	29	t
360	30	t
360	31	t
360	32	t
361	9	t
361	11	t
361	12	t
361	13	t
361	14	t
361	15	t
361	1	t
361	2	t
361	3	t
361	4	t
361	6	t
361	7	t
361	8	t
361	42	t
361	44	t
361	45	t
361	46	t
361	59	t
361	60	t
361	62	t
361	63	t
361	64	t
362	30	t
362	33	t
362	34	t
362	9	t
362	10	t
362	11	t
362	12	t
362	13	t
362	14	t
362	15	t
362	16	t
362	48	t
362	49	t
362	50	t
362	51	t
362	52	t
362	2	t
362	4	t
362	5	t
362	6	t
362	7	t
362	8	t
363	47	t
363	49	t
363	50	t
363	51	t
363	52	t
363	65	t
363	68	t
363	70	t
364	1	t
364	2	t
364	3	t
364	4	t
364	5	t
364	6	t
364	7	t
364	59	t
364	61	t
364	62	t
364	63	t
364	64	t
364	17	t
364	18	t
364	20	t
364	21	t
364	22	t
365	47	t
365	49	t
365	51	t
365	52	t
365	65	t
365	66	t
365	68	t
365	69	t
365	70	t
365	53	t
365	54	t
365	55	t
365	56	t
365	57	t
365	58	t
366	48	t
366	49	t
366	50	t
366	1	t
366	2	t
366	3	t
366	4	t
366	5	t
366	6	t
366	7	t
366	8	t
366	9	t
366	10	t
366	11	t
366	12	t
366	13	t
366	14	t
366	15	t
367	60	t
367	61	t
367	62	t
367	63	t
367	64	t
367	25	t
367	28	t
367	65	t
367	66	t
367	67	t
367	68	t
367	69	t
367	70	t
368	41	t
368	42	t
368	43	t
368	44	t
368	45	t
368	46	t
369	41	t
369	42	t
369	43	t
369	45	t
369	46	t
369	35	t
369	36	t
369	37	t
369	38	t
369	39	t
369	40	t
369	3	t
369	4	t
369	5	t
369	7	t
369	8	t
370	1	t
370	2	t
370	3	t
370	4	t
370	5	t
370	6	t
370	7	t
370	8	t
371	53	t
371	54	t
371	55	t
371	56	t
371	57	t
371	58	t
371	23	t
371	25	t
371	26	t
371	28	t
372	1	t
372	3	t
372	4	t
372	5	t
372	7	t
372	68	t
372	69	t
373	65	t
373	66	t
373	67	t
373	68	t
373	69	t
373	70	t
373	1	t
373	2	t
373	3	t
373	4	t
373	5	t
373	6	t
373	7	t
373	8	t
373	59	t
373	61	t
373	62	t
373	63	t
373	64	t
374	29	t
374	30	t
374	31	t
374	34	t
374	41	t
374	42	t
374	43	t
374	44	t
374	45	t
374	46	t
375	1	t
375	2	t
375	4	t
375	6	t
375	7	t
375	9	t
375	10	t
375	11	t
375	14	t
375	15	t
375	16	t
376	59	t
376	61	t
376	62	t
376	63	t
376	64	t
376	1	t
376	2	t
376	3	t
376	5	t
376	6	t
376	7	t
376	8	t
376	29	t
376	30	t
376	31	t
376	32	t
376	33	t
376	34	t
377	53	t
377	54	t
377	55	t
377	56	t
377	57	t
377	58	t
377	47	t
377	51	t
377	52	t
378	47	t
378	48	t
378	49	t
378	50	t
378	51	t
378	52	t
378	9	t
378	10	t
378	11	t
378	14	t
378	16	t
378	37	t
378	38	t
378	39	t
378	59	t
378	60	t
378	61	t
378	62	t
378	63	t
378	64	t
379	47	t
379	48	t
379	50	t
379	52	t
379	65	t
379	66	t
379	67	t
379	68	t
380	53	t
380	54	t
380	56	t
380	58	t
380	1	t
380	2	t
380	4	t
380	5	t
380	7	t
380	8	t
380	35	t
380	36	t
380	37	t
380	38	t
380	39	t
380	40	t
381	35	t
381	36	t
381	37	t
381	39	t
381	40	t
381	53	t
381	54	t
381	57	t
381	58	t
382	47	t
382	48	t
382	50	t
382	51	t
382	52	t
382	17	t
382	18	t
382	19	t
382	20	t
382	21	t
382	23	t
382	24	t
382	25	t
382	26	t
382	27	t
382	28	t
383	10	t
383	11	t
383	12	t
383	13	t
383	14	t
383	15	t
383	1	t
383	2	t
383	3	t
383	5	t
383	7	t
383	8	t
384	59	t
384	60	t
384	61	t
384	62	t
384	64	t
384	42	t
384	43	t
384	44	t
384	45	t
384	46	t
384	47	t
384	48	t
384	49	t
384	50	t
384	52	t
385	53	t
385	55	t
385	57	t
385	58	t
385	47	t
385	48	t
385	49	t
385	50	t
385	51	t
385	52	t
385	35	t
385	37	t
385	39	t
385	40	t
386	29	t
386	30	t
386	31	t
386	32	t
386	33	t
386	1	t
386	3	t
386	4	t
386	5	t
386	6	t
386	8	t
387	23	t
387	24	t
387	25	t
387	26	t
387	27	t
387	28	t
387	47	t
387	48	t
387	49	t
387	50	t
387	51	t
387	52	t
387	17	t
387	18	t
387	19	t
387	20	t
387	21	t
387	22	t
388	41	t
388	42	t
388	43	t
388	45	t
388	46	t
388	47	t
388	48	t
388	49	t
388	51	t
388	52	t
389	41	t
389	42	t
389	43	t
389	44	t
389	45	t
389	46	t
389	17	t
389	18	t
389	19	t
389	20	t
389	21	t
389	22	t
389	47	t
389	48	t
389	49	t
389	50	t
389	52	t
390	1	t
390	2	t
390	3	t
390	6	t
390	7	t
390	8	t
390	42	t
390	44	t
390	45	t
390	46	t
390	65	t
390	68	t
390	69	t
391	1	t
391	4	t
391	5	t
391	6	t
391	8	t
391	59	t
391	60	t
391	61	t
391	62	t
391	63	t
391	64	t
392	47	t
392	48	t
392	49	t
392	50	t
392	51	t
392	24	t
392	25	t
392	26	t
392	27	t
392	28	t
392	29	t
392	30	t
392	31	t
392	32	t
392	33	t
392	34	t
393	53	t
393	55	t
393	57	t
393	58	t
393	23	t
393	24	t
393	25	t
393	26	t
393	28	t
394	47	t
394	49	t
394	50	t
394	51	t
394	52	t
394	29	t
394	30	t
394	31	t
394	32	t
394	33	t
394	34	t
394	17	t
394	18	t
394	19	t
394	20	t
394	21	t
394	22	t
394	41	t
394	42	t
394	43	t
394	44	t
394	45	t
395	41	t
395	42	t
395	43	t
395	44	t
395	45	t
395	46	t
395	47	t
395	48	t
395	49	t
395	50	t
395	52	t
396	23	t
396	26	t
396	27	t
396	28	t
397	59	t
397	60	t
397	61	t
397	62	t
397	63	t
397	64	t
397	30	t
397	31	t
397	32	t
397	33	t
397	34	t
398	17	t
398	18	t
398	19	t
398	20	t
398	22	t
398	53	t
398	54	t
398	55	t
398	57	t
399	65	t
399	66	t
399	67	t
399	69	t
399	35	t
399	37	t
399	38	t
399	39	t
399	40	t
399	1	t
399	2	t
399	4	t
399	6	t
399	8	t
400	35	t
400	36	t
400	37	t
400	38	t
400	39	t
400	40	t
400	47	t
400	48	t
400	49	t
400	50	t
400	51	t
401	60	t
401	61	t
401	63	t
401	64	t
401	48	t
401	49	t
401	50	t
401	51	t
401	52	t
401	35	t
401	36	t
401	37	t
401	38	t
401	40	t
402	31	t
402	32	t
402	33	t
402	34	t
402	35	t
402	36	t
402	37	t
402	38	t
402	40	t
402	43	t
402	44	t
402	46	t
403	60	t
403	61	t
403	62	t
403	63	t
403	64	t
403	48	t
403	49	t
403	50	t
403	51	t
404	59	t
404	61	t
404	62	t
404	63	t
404	64	t
404	47	t
404	48	t
404	49	t
404	51	t
404	52	t
404	65	t
404	66	t
404	67	t
404	68	t
404	70	t
405	53	t
405	54	t
405	55	t
405	56	t
405	57	t
405	58	t
405	10	t
405	11	t
405	12	t
405	13	t
405	14	t
405	16	t
406	47	t
406	48	t
406	49	t
406	51	t
406	52	t
406	65	t
406	66	t
406	68	t
406	69	t
406	70	t
406	17	t
406	18	t
406	19	t
406	20	t
406	21	t
407	65	t
407	66	t
407	68	t
407	70	t
407	9	t
407	10	t
407	12	t
407	13	t
408	61	t
408	63	t
408	64	t
408	53	t
408	54	t
408	55	t
408	56	t
408	57	t
408	58	t
409	17	t
409	18	t
409	19	t
409	20	t
409	22	t
409	42	t
409	43	t
409	44	t
409	45	t
409	46	t
409	29	t
409	30	t
409	31	t
409	32	t
410	9	t
410	10	t
410	12	t
410	13	t
410	14	t
410	15	t
410	16	t
410	65	t
410	66	t
410	69	t
410	70	t
411	65	t
411	66	t
411	68	t
411	69	t
411	70	t
411	29	t
411	30	t
411	33	t
411	34	t
412	65	t
412	66	t
412	67	t
412	68	t
412	70	t
412	29	t
412	30	t
412	31	t
412	33	t
412	41	t
412	42	t
412	43	t
412	44	t
412	45	t
413	24	t
413	25	t
413	26	t
413	27	t
413	28	t
413	53	t
413	54	t
413	55	t
413	56	t
413	57	t
413	58	t
413	59	t
413	61	t
413	62	t
413	63	t
413	64	t
414	53	t
414	54	t
414	55	t
414	57	t
414	58	t
414	1	t
414	7	t
414	8	t
415	54	t
415	55	t
415	56	t
415	58	t
415	1	t
415	2	t
415	3	t
415	4	t
415	6	t
415	7	t
415	8	t
415	65	t
415	66	t
415	67	t
415	68	t
415	69	t
415	70	t
416	65	t
416	66	t
416	67	t
416	68	t
416	70	t
416	24	t
416	25	t
416	26	t
416	27	t
416	9	t
416	11	t
416	12	t
416	13	t
416	14	t
416	15	t
416	16	t
417	65	t
417	66	t
417	67	t
417	68	t
417	69	t
417	70	t
417	17	t
417	18	t
417	19	t
417	20	t
417	21	t
417	22	t
418	18	t
418	19	t
418	20	t
418	59	t
418	60	t
418	61	t
418	62	t
418	63	t
418	64	t
419	53	t
419	54	t
419	55	t
419	56	t
419	57	t
419	58	t
419	17	t
419	18	t
419	20	t
419	21	t
419	22	t
420	37	t
420	38	t
420	39	t
420	40	t
420	1	t
420	2	t
420	4	t
420	5	t
420	6	t
420	7	t
420	41	t
420	42	t
420	43	t
420	44	t
420	46	t
421	43	t
421	44	t
421	45	t
421	46	t
421	30	t
421	32	t
421	33	t
421	34	t
421	53	t
421	54	t
421	55	t
421	56	t
421	57	t
421	58	t
422	53	t
422	54	t
422	55	t
422	56	t
422	58	t
422	1	t
422	2	t
422	3	t
422	5	t
422	6	t
422	7	t
422	8	t
422	17	t
422	18	t
422	20	t
422	21	t
422	22	t
422	23	t
422	24	t
422	25	t
422	26	t
422	27	t
423	67	t
423	68	t
423	69	t
423	70	t
423	41	t
423	42	t
423	43	t
423	44	t
423	45	t
423	36	t
423	37	t
423	38	t
423	39	t
423	40	t
424	35	t
424	36	t
424	37	t
424	68	t
424	69	t
424	70	t
424	18	t
424	19	t
424	20	t
424	22	t
424	59	t
424	60	t
424	62	t
424	63	t
425	65	t
425	66	t
425	67	t
425	68	t
425	69	t
425	70	t
425	29	t
425	32	t
425	33	t
425	34	t
426	47	t
426	50	t
426	52	t
426	17	t
426	18	t
426	19	t
426	20	t
426	21	t
426	22	t
427	1	t
427	3	t
427	4	t
427	5	t
427	6	t
427	7	t
427	8	t
427	59	t
427	60	t
427	61	t
427	63	t
427	64	t
427	48	t
427	49	t
427	50	t
427	52	t
428	9	t
428	10	t
428	11	t
428	12	t
428	13	t
428	14	t
428	15	t
428	16	t
428	35	t
428	36	t
428	37	t
428	39	t
429	41	t
429	42	t
429	44	t
429	45	t
429	46	t
429	9	t
429	11	t
429	12	t
429	14	t
429	15	t
430	9	t
430	10	t
430	12	t
430	14	t
430	15	t
430	16	t
430	53	t
430	54	t
430	55	t
430	57	t
430	58	t
431	59	t
431	60	t
431	62	t
431	63	t
431	64	t
431	29	t
431	30	t
431	31	t
431	32	t
431	33	t
431	34	t
432	17	t
432	18	t
432	19	t
432	20	t
432	21	t
433	1	t
433	2	t
433	3	t
433	4	t
433	5	t
433	6	t
433	7	t
433	8	t
433	29	t
433	30	t
433	31	t
433	32	t
434	1	t
434	3	t
434	4	t
434	5	t
434	6	t
434	7	t
434	8	t
435	19	t
435	20	t
435	22	t
436	29	t
436	31	t
436	34	t
436	59	t
436	60	t
436	61	t
436	62	t
436	64	t
437	23	t
437	25	t
437	26	t
437	27	t
437	65	t
437	66	t
437	67	t
437	68	t
437	69	t
437	70	t
437	35	t
437	37	t
437	38	t
437	39	t
437	40	t
438	66	t
438	67	t
438	68	t
438	70	t
438	11	t
438	12	t
438	14	t
438	15	t
438	16	t
438	35	t
438	36	t
438	37	t
438	38	t
438	39	t
439	29	t
439	31	t
439	32	t
439	33	t
439	34	t
439	23	t
439	24	t
439	25	t
439	26	t
439	27	t
439	65	t
439	66	t
439	67	t
439	68	t
439	69	t
439	70	t
439	47	t
439	48	t
439	49	t
439	51	t
439	52	t
440	10	t
440	11	t
440	12	t
440	13	t
440	14	t
440	15	t
440	53	t
440	54	t
440	55	t
440	56	t
440	57	t
441	1	t
441	2	t
441	3	t
441	4	t
441	6	t
441	7	t
441	17	t
441	19	t
441	20	t
441	21	t
441	22	t
441	53	t
441	54	t
441	56	t
441	57	t
442	29	t
442	30	t
442	31	t
442	32	t
442	33	t
442	34	t
442	23	t
442	24	t
442	26	t
442	27	t
442	28	t
442	9	t
442	11	t
442	12	t
442	13	t
442	14	t
442	15	t
442	16	t
443	59	t
443	60	t
443	61	t
443	63	t
443	64	t
443	10	t
443	11	t
443	13	t
443	14	t
443	15	t
444	41	t
444	42	t
444	43	t
444	44	t
444	45	t
444	46	t
444	65	t
444	66	t
444	67	t
444	68	t
444	70	t
444	53	t
444	55	t
444	56	t
444	58	t
444	23	t
444	24	t
444	25	t
444	26	t
444	27	t
445	1	t
445	2	t
445	4	t
445	5	t
445	6	t
445	7	t
445	8	t
445	29	t
445	30	t
445	31	t
445	32	t
445	33	t
445	34	t
445	53	t
445	54	t
445	56	t
445	57	t
445	58	t
445	65	t
445	66	t
445	67	t
445	68	t
445	69	t
445	70	t
446	9	t
446	11	t
446	12	t
446	13	t
446	15	t
446	16	t
446	30	t
446	31	t
446	32	t
446	33	t
446	34	t
446	59	t
446	62	t
446	63	t
446	64	t
446	35	t
446	37	t
446	38	t
446	39	t
447	35	t
447	36	t
447	37	t
447	38	t
447	39	t
447	59	t
447	60	t
447	61	t
447	62	t
447	63	t
447	64	t
448	29	t
448	30	t
448	31	t
448	32	t
448	33	t
448	34	t
448	66	t
448	67	t
448	68	t
448	70	t
449	30	t
449	31	t
449	32	t
449	33	t
449	34	t
449	36	t
449	37	t
449	39	t
450	29	t
450	30	t
450	33	t
450	34	t
450	53	t
450	54	t
450	55	t
450	56	t
450	58	t
451	54	t
451	55	t
451	56	t
451	57	t
451	65	t
451	66	t
451	67	t
451	68	t
451	69	t
451	70	t
451	9	t
451	10	t
451	11	t
451	12	t
451	13	t
451	14	t
451	15	t
452	49	t
452	51	t
452	52	t
452	41	t
452	42	t
452	43	t
452	44	t
452	45	t
452	46	t
452	59	t
452	61	t
452	62	t
452	64	t
452	9	t
452	10	t
452	12	t
452	13	t
452	14	t
452	15	t
452	16	t
453	17	t
453	18	t
453	19	t
453	20	t
453	21	t
453	22	t
453	47	t
453	48	t
453	49	t
453	50	t
453	51	t
453	52	t
453	53	t
453	54	t
453	55	t
453	56	t
453	57	t
453	58	t
454	53	t
454	54	t
454	55	t
454	56	t
454	57	t
454	58	t
454	65	t
454	66	t
454	67	t
454	68	t
454	69	t
454	70	t
455	53	t
455	54	t
455	55	t
455	56	t
455	57	t
455	58	t
455	65	t
455	66	t
455	67	t
455	68	t
455	70	t
455	23	t
455	24	t
455	25	t
455	26	t
455	27	t
455	28	t
456	9	t
456	10	t
456	11	t
456	12	t
456	14	t
456	15	t
456	16	t
456	30	t
456	32	t
456	33	t
456	34	t
456	53	t
456	54	t
456	55	t
456	56	t
456	57	t
456	58	t
456	48	t
456	49	t
456	50	t
456	51	t
456	52	t
457	66	t
457	68	t
457	69	t
457	70	t
457	48	t
457	49	t
457	51	t
457	52	t
457	53	t
457	54	t
457	55	t
457	56	t
457	57	t
457	58	t
457	17	t
457	18	t
457	19	t
457	20	t
457	21	t
457	22	t
458	47	t
458	48	t
458	49	t
458	50	t
458	51	t
458	52	t
458	59	t
458	60	t
458	61	t
458	62	t
458	63	t
458	64	t
458	18	t
458	19	t
458	20	t
458	21	t
458	22	t
459	9	t
459	10	t
459	11	t
459	13	t
459	14	t
459	15	t
459	16	t
459	1	t
459	2	t
459	3	t
459	5	t
459	6	t
459	7	t
459	8	t
459	29	t
459	31	t
459	32	t
459	33	t
459	34	t
460	47	t
460	49	t
460	51	t
460	52	t
460	29	t
460	30	t
460	32	t
460	33	t
460	65	t
460	66	t
460	67	t
460	69	t
460	70	t
461	17	t
461	19	t
461	22	t
461	65	t
461	66	t
461	68	t
461	69	t
461	70	t
462	23	t
462	24	t
462	25	t
462	26	t
462	28	t
462	17	t
462	18	t
462	19	t
462	20	t
462	21	t
463	35	t
463	36	t
463	37	t
463	39	t
463	40	t
463	59	t
463	60	t
463	62	t
463	63	t
463	64	t
464	9	t
464	11	t
464	12	t
464	13	t
464	15	t
464	16	t
464	42	t
464	43	t
464	44	t
464	45	t
464	46	t
464	65	t
464	66	t
464	67	t
464	68	t
464	69	t
464	70	t
465	1	t
465	2	t
465	3	t
465	4	t
465	6	t
465	7	t
465	17	t
465	18	t
465	20	t
465	21	t
465	22	t
466	47	t
466	48	t
466	49	t
466	50	t
466	51	t
466	52	t
466	53	t
466	54	t
466	55	t
466	56	t
466	57	t
466	58	t
467	23	t
467	24	t
467	25	t
467	26	t
467	27	t
467	28	t
467	9	t
467	10	t
467	11	t
467	12	t
467	13	t
467	14	t
467	15	t
467	53	t
467	54	t
467	56	t
467	57	t
467	58	t
468	54	t
468	55	t
468	56	t
468	57	t
468	58	t
468	17	t
468	19	t
468	20	t
468	21	t
468	41	t
468	42	t
468	43	t
468	44	t
468	45	t
468	46	t
469	9	t
469	10	t
469	11	t
469	12	t
469	13	t
469	14	t
469	15	t
469	16	t
469	35	t
469	37	t
469	38	t
469	40	t
470	17	t
470	18	t
470	19	t
470	20	t
470	21	t
470	22	t
471	1	t
471	2	t
471	3	t
471	4	t
471	5	t
471	7	t
471	8	t
471	23	t
471	24	t
471	25	t
471	26	t
471	27	t
471	28	t
472	2	t
472	3	t
472	4	t
472	5	t
472	6	t
472	7	t
472	17	t
472	18	t
472	19	t
472	20	t
472	22	t
472	41	t
472	43	t
472	44	t
472	46	t
473	65	t
473	66	t
473	67	t
473	69	t
473	70	t
473	9	t
473	11	t
473	12	t
473	13	t
473	14	t
473	15	t
473	16	t
474	9	t
474	10	t
474	11	t
474	12	t
474	13	t
474	14	t
474	15	t
474	16	t
474	35	t
474	36	t
474	38	t
474	39	t
474	40	t
474	17	t
474	18	t
474	19	t
474	21	t
474	22	t
475	47	t
475	51	t
475	52	t
475	1	t
475	3	t
475	4	t
475	5	t
475	7	t
475	8	t
475	53	t
475	54	t
475	55	t
475	56	t
475	57	t
475	58	t
475	41	t
475	42	t
475	45	t
476	41	t
476	42	t
476	43	t
476	45	t
476	35	t
476	36	t
476	37	t
476	38	t
476	39	t
476	40	t
477	47	t
477	48	t
477	49	t
477	50	t
477	51	t
477	52	t
477	17	t
477	18	t
477	20	t
477	21	t
477	41	t
477	42	t
477	43	t
477	44	t
477	46	t
478	53	t
478	54	t
478	56	t
478	57	t
478	58	t
478	32	t
478	34	t
479	41	t
479	42	t
479	43	t
479	44	t
479	45	t
479	46	t
479	65	t
479	66	t
479	67	t
479	68	t
479	69	t
479	70	t
480	31	t
480	32	t
480	33	t
480	34	t
481	47	t
481	48	t
481	49	t
481	51	t
481	35	t
481	36	t
481	37	t
481	38	t
481	39	t
481	40	t
482	30	t
482	31	t
482	32	t
482	33	t
482	34	t
482	23	t
482	24	t
482	25	t
482	26	t
482	27	t
482	28	t
483	48	t
483	49	t
483	50	t
483	51	t
484	41	t
484	42	t
484	44	t
484	46	t
484	10	t
484	11	t
484	12	t
484	14	t
484	15	t
484	47	t
484	48	t
484	49	t
484	50	t
484	51	t
484	52	t
485	17	t
485	18	t
485	19	t
485	21	t
485	22	t
485	23	t
485	25	t
485	26	t
485	27	t
485	28	t
485	29	t
485	30	t
485	31	t
485	32	t
485	33	t
485	34	t
486	35	t
486	36	t
486	38	t
486	39	t
486	40	t
486	17	t
486	18	t
486	19	t
486	20	t
486	21	t
486	23	t
486	24	t
486	25	t
486	26	t
486	27	t
487	42	t
487	43	t
487	45	t
487	2	t
487	4	t
487	6	t
487	8	t
487	68	t
487	69	t
487	70	t
488	2	t
488	3	t
488	4	t
488	5	t
488	7	t
488	59	t
488	61	t
488	62	t
488	63	t
488	64	t
488	41	t
488	42	t
488	43	t
488	44	t
488	45	t
488	46	t
489	35	t
489	36	t
489	38	t
489	39	t
489	9	t
489	11	t
489	12	t
489	14	t
489	15	t
489	16	t
489	41	t
489	42	t
489	43	t
489	45	t
490	59	t
490	60	t
490	61	t
490	62	t
490	63	t
490	35	t
490	36	t
490	37	t
490	38	t
490	39	t
490	53	t
490	55	t
490	56	t
490	58	t
490	48	t
490	49	t
490	50	t
490	51	t
490	52	t
491	59	t
491	60	t
491	61	t
491	63	t
491	65	t
491	66	t
491	68	t
491	69	t
491	70	t
491	36	t
491	37	t
491	38	t
491	39	t
491	40	t
491	1	t
491	2	t
491	3	t
491	4	t
491	5	t
491	6	t
491	7	t
491	8	t
492	41	t
492	42	t
492	43	t
492	44	t
492	46	t
492	17	t
492	19	t
492	21	t
492	22	t
493	47	t
493	48	t
493	49	t
493	50	t
493	51	t
493	52	t
493	23	t
493	25	t
493	28	t
493	60	t
493	61	t
493	62	t
493	63	t
493	64	t
494	29	t
494	31	t
494	32	t
495	1	t
495	2	t
495	3	t
495	4	t
495	5	t
495	6	t
495	7	t
495	29	t
495	30	t
495	31	t
495	32	t
495	33	t
495	9	t
495	11	t
495	12	t
495	13	t
495	14	t
495	15	t
496	2	t
496	3	t
496	5	t
496	6	t
496	8	t
496	35	t
496	36	t
496	37	t
496	38	t
496	39	t
496	40	t
496	41	t
496	42	t
496	43	t
496	44	t
496	45	t
496	46	t
497	17	t
497	18	t
497	20	t
497	21	t
497	22	t
497	59	t
497	60	t
497	61	t
497	62	t
497	63	t
497	64	t
497	41	t
497	42	t
497	43	t
497	44	t
497	45	t
497	46	t
498	42	t
498	43	t
498	44	t
498	46	t
498	18	t
498	19	t
498	20	t
498	21	t
498	22	t
499	1	t
499	2	t
499	3	t
499	4	t
499	5	t
499	6	t
499	7	t
499	8	t
499	10	t
499	12	t
499	13	t
499	14	t
499	15	t
499	16	t
500	65	t
500	66	t
500	67	t
500	68	t
500	69	t
500	70	t
500	59	t
500	60	t
500	61	t
500	62	t
500	63	t
501	29	t
501	30	t
501	31	t
501	33	t
501	34	t
501	41	t
501	43	t
501	44	t
501	45	t
501	46	t
501	35	t
501	36	t
501	37	t
501	38	t
501	39	t
501	40	t
501	65	t
501	66	t
501	67	t
501	68	t
501	69	t
501	70	t
502	41	t
502	42	t
502	43	t
502	44	t
502	46	t
502	32	t
502	33	t
502	34	t
502	35	t
502	38	t
502	40	t
503	53	t
503	54	t
503	55	t
503	57	t
503	58	t
503	1	t
503	2	t
503	3	t
503	4	t
503	5	t
503	6	t
503	7	t
504	23	t
504	24	t
504	25	t
504	26	t
504	28	t
504	59	t
504	60	t
504	61	t
504	63	t
504	64	t
505	59	t
505	60	t
505	62	t
505	64	t
505	23	t
505	24	t
505	25	t
505	26	t
505	27	t
505	28	t
505	65	t
505	66	t
505	67	t
505	68	t
505	70	t
506	43	t
506	44	t
506	46	t
506	35	t
506	36	t
506	37	t
506	38	t
506	39	t
506	40	t
507	30	t
507	31	t
507	32	t
507	33	t
507	34	t
508	35	t
508	36	t
508	37	t
508	39	t
508	1	t
508	3	t
508	4	t
508	5	t
508	6	t
508	7	t
508	8	t
508	65	t
508	66	t
508	67	t
508	68	t
508	69	t
509	41	t
509	42	t
509	43	t
509	44	t
509	45	t
509	46	t
509	2	t
509	4	t
509	5	t
509	6	t
509	7	t
510	60	t
510	61	t
510	62	t
510	63	t
510	64	t
510	53	t
510	54	t
510	55	t
510	56	t
510	57	t
510	58	t
510	29	t
510	30	t
510	31	t
510	32	t
510	33	t
510	34	t
511	42	t
511	44	t
511	45	t
511	46	t
511	29	t
511	30	t
511	31	t
511	32	t
511	33	t
511	34	t
512	35	t
512	36	t
512	37	t
512	38	t
512	40	t
512	47	t
512	49	t
512	52	t
512	1	t
512	2	t
512	4	t
512	5	t
512	6	t
512	7	t
512	8	t
513	41	t
513	43	t
513	44	t
513	45	t
513	46	t
513	54	t
513	56	t
513	57	t
514	59	t
514	60	t
514	62	t
514	63	t
514	64	t
514	47	t
514	48	t
514	49	t
514	50	t
514	51	t
514	52	t
514	35	t
514	36	t
514	37	t
514	38	t
514	39	t
514	40	t
515	35	t
515	36	t
515	37	t
515	38	t
515	39	t
515	40	t
515	9	t
515	10	t
515	11	t
515	13	t
515	14	t
515	15	t
515	16	t
515	17	t
515	18	t
515	19	t
515	20	t
515	22	t
516	47	t
516	48	t
516	49	t
516	50	t
516	51	t
516	53	t
516	54	t
516	58	t
516	30	t
516	31	t
516	32	t
516	33	t
516	34	t
517	59	t
517	60	t
517	62	t
517	63	t
517	64	t
518	59	t
518	60	t
518	61	t
518	62	t
518	63	t
518	64	t
518	1	t
518	2	t
518	3	t
518	6	t
518	7	t
518	8	t
518	30	t
518	31	t
518	32	t
518	33	t
518	34	t
518	47	t
518	48	t
518	50	t
518	51	t
518	52	t
519	47	t
519	48	t
519	49	t
519	50	t
519	51	t
519	52	t
519	53	t
519	54	t
519	58	t
519	41	t
519	43	t
519	44	t
519	46	t
520	29	t
520	30	t
520	33	t
520	34	t
520	53	t
520	54	t
520	55	t
520	56	t
520	58	t
521	17	t
521	18	t
521	20	t
521	21	t
521	23	t
521	24	t
521	25	t
521	26	t
521	27	t
521	65	t
521	66	t
521	67	t
521	68	t
521	69	t
522	59	t
522	60	t
522	61	t
522	62	t
522	1	t
522	2	t
522	4	t
522	5	t
522	6	t
522	7	t
522	8	t
522	29	t
522	30	t
522	31	t
522	33	t
522	34	t
523	47	t
523	48	t
523	49	t
523	51	t
523	52	t
523	29	t
523	30	t
523	31	t
523	32	t
523	33	t
523	34	t
523	53	t
523	56	t
523	57	t
524	9	t
524	11	t
524	12	t
524	13	t
524	14	t
524	15	t
524	25	t
524	28	t
525	41	t
525	42	t
525	44	t
525	45	t
525	46	t
525	65	t
525	66	t
525	68	t
525	70	t
525	29	t
525	30	t
525	31	t
525	32	t
525	33	t
525	34	t
525	35	t
525	36	t
525	38	t
525	39	t
526	35	t
526	36	t
526	37	t
526	38	t
526	39	t
526	40	t
526	54	t
526	55	t
526	56	t
527	35	t
527	37	t
527	39	t
527	40	t
527	47	t
527	48	t
527	49	t
527	50	t
527	51	t
527	52	t
527	41	t
527	42	t
527	43	t
527	44	t
527	46	t
528	9	t
528	10	t
528	11	t
528	12	t
528	14	t
528	15	t
528	53	t
528	54	t
528	55	t
528	56	t
528	57	t
528	58	t
528	47	t
528	48	t
528	50	t
528	52	t
529	9	t
529	10	t
529	11	t
529	12	t
529	13	t
529	14	t
529	15	t
529	16	t
529	65	t
529	66	t
529	68	t
529	69	t
529	70	t
530	17	t
530	18	t
530	19	t
530	20	t
530	21	t
530	22	t
530	42	t
530	43	t
530	44	t
530	45	t
530	46	t
530	65	t
530	66	t
530	67	t
530	68	t
530	69	t
530	70	t
531	53	t
531	55	t
531	56	t
531	57	t
531	58	t
531	47	t
531	48	t
531	49	t
531	50	t
531	51	t
531	52	t
531	60	t
531	61	t
531	62	t
531	63	t
531	64	t
531	35	t
531	36	t
531	37	t
531	38	t
531	40	t
532	29	t
532	30	t
532	32	t
532	33	t
532	47	t
532	48	t
532	49	t
532	51	t
532	52	t
532	35	t
532	36	t
532	37	t
532	38	t
532	39	t
532	40	t
533	48	t
533	51	t
533	17	t
533	18	t
533	21	t
533	22	t
533	29	t
533	30	t
533	31	t
533	33	t
533	34	t
534	23	t
534	24	t
534	25	t
534	26	t
534	27	t
534	1	t
534	2	t
534	5	t
534	6	t
534	53	t
534	54	t
534	55	t
534	56	t
534	57	t
534	58	t
534	65	t
534	66	t
534	67	t
534	69	t
534	70	t
535	9	t
535	12	t
535	13	t
535	15	t
535	16	t
535	65	t
535	66	t
535	67	t
535	68	t
535	69	t
535	70	t
536	42	t
536	45	t
536	46	t
536	9	t
536	10	t
536	11	t
536	12	t
536	13	t
536	14	t
536	15	t
536	16	t
536	1	t
536	3	t
536	4	t
536	5	t
536	6	t
536	7	t
536	8	t
536	36	t
536	37	t
536	38	t
536	39	t
536	40	t
537	17	t
537	18	t
537	19	t
537	20	t
537	21	t
537	22	t
537	23	t
537	24	t
537	25	t
537	26	t
537	27	t
537	28	t
537	41	t
537	42	t
537	43	t
537	44	t
537	45	t
537	46	t
538	29	t
538	30	t
538	31	t
538	33	t
538	34	t
538	35	t
538	37	t
538	38	t
538	40	t
538	65	t
538	66	t
538	67	t
538	68	t
538	69	t
538	70	t
539	24	t
539	25	t
539	27	t
539	41	t
539	42	t
539	44	t
539	45	t
539	46	t
539	53	t
539	54	t
539	55	t
539	56	t
539	58	t
540	25	t
540	27	t
540	28	t
540	65	t
540	66	t
540	67	t
540	68	t
540	69	t
540	70	t
541	47	t
541	48	t
541	49	t
541	50	t
541	52	t
541	53	t
541	54	t
541	55	t
541	56	t
541	57	t
541	58	t
542	23	t
542	25	t
542	26	t
542	27	t
542	28	t
542	17	t
542	18	t
542	21	t
542	22	t
543	59	t
543	60	t
543	61	t
543	63	t
543	64	t
543	53	t
543	54	t
543	55	t
543	56	t
543	57	t
543	58	t
543	29	t
543	31	t
543	32	t
543	34	t
544	23	t
544	27	t
544	28	t
544	42	t
544	43	t
544	44	t
545	9	t
545	10	t
545	11	t
545	12	t
545	13	t
545	14	t
545	15	t
545	16	t
545	29	t
545	30	t
545	32	t
545	33	t
545	34	t
545	66	t
545	67	t
545	68	t
545	69	t
545	70	t
546	53	t
546	56	t
546	57	t
546	58	t
547	9	t
547	10	t
547	11	t
547	13	t
547	14	t
547	15	t
547	16	t
547	29	t
547	30	t
547	31	t
547	32	t
547	33	t
547	34	t
548	65	t
548	66	t
548	67	t
548	68	t
548	69	t
548	70	t
548	53	t
548	54	t
548	56	t
548	57	t
548	58	t
549	29	t
549	30	t
549	31	t
549	32	t
549	33	t
549	34	t
549	23	t
549	24	t
549	26	t
549	27	t
549	28	t
549	47	t
549	49	t
549	51	t
549	52	t
550	17	t
550	19	t
550	21	t
550	22	t
550	41	t
550	43	t
550	45	t
550	46	t
550	29	t
550	31	t
550	32	t
550	33	t
551	59	t
551	60	t
551	61	t
551	62	t
551	54	t
551	56	t
551	57	t
551	58	t
551	17	t
551	19	t
551	20	t
551	21	t
551	22	t
552	23	t
552	24	t
552	25	t
552	26	t
552	27	t
552	53	t
552	54	t
552	56	t
552	57	t
553	9	t
553	10	t
553	12	t
553	13	t
553	15	t
553	1	t
553	2	t
553	4	t
553	5	t
553	6	t
553	7	t
553	47	t
553	48	t
553	49	t
553	50	t
553	51	t
553	52	t
554	17	t
554	18	t
554	19	t
554	20	t
554	21	t
554	22	t
554	9	t
554	10	t
554	11	t
554	12	t
554	15	t
554	59	t
554	60	t
554	61	t
554	62	t
554	63	t
554	64	t
555	1	t
555	2	t
555	4	t
555	6	t
555	8	t
555	23	t
555	24	t
555	25	t
555	26	t
555	27	t
555	28	t
555	9	t
555	10	t
555	11	t
555	13	t
555	14	t
555	15	t
555	29	t
555	30	t
555	32	t
555	33	t
555	34	t
556	47	t
556	48	t
556	49	t
556	52	t
556	54	t
556	56	t
556	57	t
556	58	t
557	23	t
557	24	t
557	25	t
557	26	t
557	27	t
557	28	t
558	2	t
558	3	t
558	4	t
558	5	t
558	6	t
558	7	t
558	8	t
558	47	t
558	48	t
558	49	t
558	50	t
558	52	t
558	65	t
558	68	t
558	69	t
558	70	t
558	10	t
558	11	t
558	12	t
558	13	t
558	15	t
558	16	t
559	23	t
559	24	t
559	25	t
559	26	t
559	28	t
559	29	t
559	31	t
559	33	t
559	34	t
559	35	t
559	36	t
559	37	t
559	38	t
560	47	t
560	48	t
560	49	t
560	50	t
560	51	t
560	52	t
560	17	t
560	18	t
560	19	t
560	20	t
560	21	t
560	41	t
560	42	t
560	43	t
560	44	t
560	45	t
560	46	t
561	53	t
561	54	t
561	55	t
561	56	t
561	57	t
561	58	t
561	24	t
561	26	t
561	27	t
561	28	t
561	47	t
561	48	t
561	49	t
561	50	t
561	51	t
561	29	t
561	30	t
561	31	t
561	32	t
561	33	t
562	35	t
562	36	t
562	37	t
562	39	t
562	40	t
562	9	t
562	10	t
562	11	t
562	12	t
562	14	t
562	59	t
562	60	t
562	61	t
562	62	t
562	63	t
563	47	t
563	48	t
563	49	t
563	51	t
563	52	t
563	9	t
563	10	t
563	11	t
563	12	t
563	13	t
563	14	t
563	15	t
563	16	t
564	1	t
564	2	t
564	4	t
564	5	t
564	6	t
564	7	t
564	8	t
564	17	t
564	18	t
564	19	t
564	20	t
564	21	t
564	22	t
565	53	t
565	55	t
565	56	t
565	58	t
565	35	t
565	36	t
565	37	t
565	38	t
565	39	t
566	18	t
566	19	t
566	20	t
566	22	t
566	65	t
566	66	t
566	67	t
566	70	t
567	23	t
567	24	t
567	25	t
567	26	t
567	27	t
567	28	t
568	1	t
568	2	t
568	3	t
568	4	t
568	5	t
568	6	t
568	8	t
568	53	t
568	54	t
568	55	t
568	58	t
568	65	t
568	66	t
568	67	t
568	68	t
568	69	t
568	70	t
568	9	t
568	10	t
568	11	t
568	12	t
568	13	t
568	14	t
568	16	t
569	29	t
569	30	t
569	31	t
569	32	t
569	33	t
569	34	t
569	9	t
569	10	t
569	11	t
569	12	t
569	14	t
569	15	t
569	16	t
570	10	t
570	11	t
570	12	t
570	14	t
570	15	t
570	16	t
570	18	t
570	19	t
570	20	t
570	22	t
570	35	t
570	36	t
570	37	t
570	38	t
570	39	t
570	40	t
571	23	t
571	24	t
571	25	t
571	26	t
571	27	t
571	60	t
571	61	t
571	63	t
571	64	t
571	17	t
571	18	t
571	19	t
571	20	t
571	21	t
571	22	t
572	41	t
572	42	t
572	43	t
572	44	t
572	45	t
572	46	t
573	9	t
573	10	t
573	12	t
573	14	t
573	16	t
573	47	t
573	48	t
573	49	t
573	51	t
573	52	t
573	23	t
573	26	t
573	27	t
573	53	t
573	54	t
573	55	t
573	56	t
573	58	t
574	23	t
574	24	t
574	25	t
574	28	t
574	47	t
574	48	t
574	49	t
574	51	t
574	52	t
574	1	t
574	2	t
574	3	t
574	4	t
574	6	t
574	7	t
574	8	t
575	53	t
575	54	t
575	56	t
575	57	t
575	58	t
575	17	t
575	18	t
575	19	t
575	20	t
575	21	t
575	22	t
576	17	t
576	19	t
576	20	t
576	21	t
576	22	t
576	23	t
576	24	t
576	25	t
576	26	t
576	27	t
576	59	t
576	60	t
576	61	t
576	62	t
576	63	t
576	35	t
576	36	t
576	37	t
576	38	t
576	39	t
577	17	t
577	19	t
577	20	t
577	22	t
578	53	t
578	54	t
578	58	t
578	36	t
578	38	t
578	39	t
579	35	t
579	37	t
579	38	t
579	39	t
579	40	t
579	47	t
579	48	t
579	49	t
579	50	t
579	51	t
579	52	t
579	1	t
579	3	t
579	4	t
579	5	t
579	7	t
579	8	t
580	59	t
580	60	t
580	61	t
580	62	t
580	63	t
580	65	t
580	67	t
580	68	t
580	69	t
580	70	t
580	41	t
580	43	t
580	45	t
580	46	t
580	17	t
580	18	t
580	19	t
580	20	t
580	21	t
580	22	t
581	65	t
581	67	t
581	68	t
581	69	t
581	70	t
581	47	t
581	48	t
581	50	t
581	51	t
581	52	t
582	65	t
582	66	t
582	67	t
582	69	t
582	70	t
582	59	t
582	60	t
582	61	t
582	63	t
582	64	t
582	53	t
582	56	t
582	57	t
582	58	t
583	53	t
583	54	t
583	56	t
583	57	t
583	58	t
583	35	t
583	36	t
583	37	t
583	38	t
583	40	t
583	23	t
583	24	t
583	25	t
583	26	t
583	27	t
583	28	t
584	47	t
584	48	t
584	50	t
584	52	t
584	66	t
584	67	t
584	68	t
584	69	t
584	70	t
585	41	t
585	42	t
585	43	t
585	44	t
585	46	t
585	29	t
585	30	t
585	31	t
585	32	t
585	33	t
585	34	t
586	59	t
586	61	t
586	62	t
586	63	t
586	1	t
586	2	t
586	3	t
586	5	t
586	7	t
586	8	t
587	41	t
587	42	t
587	43	t
587	44	t
587	45	t
587	46	t
587	35	t
587	36	t
587	37	t
587	38	t
587	39	t
587	40	t
587	19	t
587	20	t
587	21	t
587	22	t
588	35	t
588	36	t
588	37	t
588	38	t
588	40	t
588	23	t
588	25	t
588	28	t
588	53	t
588	54	t
588	55	t
588	56	t
588	57	t
588	58	t
589	53	t
589	54	t
589	55	t
589	56	t
589	57	t
589	58	t
589	41	t
589	42	t
589	43	t
589	44	t
589	45	t
589	46	t
589	47	t
589	48	t
589	49	t
589	50	t
589	51	t
589	52	t
590	65	t
590	66	t
590	67	t
590	69	t
590	70	t
590	10	t
590	11	t
590	12	t
590	13	t
590	16	t
591	41	t
591	42	t
591	43	t
591	44	t
591	45	t
591	2	t
591	3	t
591	4	t
591	5	t
591	6	t
591	8	t
591	29	t
591	30	t
591	31	t
591	32	t
591	33	t
591	34	t
592	17	t
592	18	t
592	19	t
592	20	t
592	22	t
593	35	t
593	37	t
593	38	t
593	40	t
593	9	t
593	10	t
593	11	t
593	12	t
593	13	t
593	15	t
593	16	t
594	18	t
594	20	t
594	21	t
594	22	t
595	29	t
595	30	t
595	31	t
595	32	t
595	33	t
595	34	t
595	66	t
595	67	t
595	68	t
595	70	t
595	23	t
595	24	t
595	25	t
595	26	t
595	27	t
595	28	t
596	9	t
596	10	t
596	11	t
596	12	t
596	13	t
596	14	t
596	15	t
596	16	t
596	65	t
596	66	t
596	68	t
596	69	t
596	70	t
597	3	t
597	4	t
597	5	t
597	7	t
597	8	t
597	41	t
597	42	t
597	43	t
597	44	t
597	45	t
598	41	t
598	42	t
598	43	t
598	44	t
598	45	t
598	46	t
598	17	t
598	18	t
598	19	t
598	20	t
598	21	t
598	22	t
599	9	t
599	11	t
599	14	t
599	15	t
599	16	t
599	43	t
599	1	t
599	3	t
599	4	t
599	5	t
599	6	t
599	7	t
599	8	t
600	35	t
600	36	t
600	37	t
600	38	t
600	39	t
600	40	t
600	10	t
600	12	t
600	14	t
600	15	t
600	29	t
600	30	t
600	31	t
600	32	t
600	33	t
600	34	t
601	23	t
601	24	t
601	25	t
601	26	t
601	27	t
601	28	t
601	47	t
601	48	t
601	49	t
601	50	t
601	51	t
601	41	t
601	42	t
601	45	t
602	36	t
602	37	t
602	38	t
602	39	t
602	17	t
602	18	t
602	20	t
602	21	t
602	22	t
603	47	t
603	49	t
603	50	t
603	51	t
603	52	t
604	41	t
604	44	t
604	45	t
604	1	t
604	2	t
604	4	t
604	5	t
604	6	t
604	7	t
604	8	t
604	18	t
604	19	t
604	20	t
604	21	t
604	22	t
605	65	t
605	66	t
605	67	t
605	68	t
605	70	t
605	41	t
605	42	t
605	43	t
605	44	t
605	45	t
605	46	t
605	36	t
605	37	t
605	38	t
605	39	t
605	40	t
605	1	t
605	2	t
605	5	t
605	6	t
605	7	t
605	8	t
606	53	t
606	54	t
606	55	t
606	56	t
606	57	t
606	58	t
607	23	t
607	26	t
607	27	t
607	28	t
607	59	t
607	60	t
607	61	t
607	62	t
607	63	t
607	64	t
608	65	t
608	66	t
608	67	t
608	68	t
608	69	t
608	59	t
608	60	t
608	62	t
608	63	t
608	64	t
608	53	t
608	55	t
608	56	t
608	57	t
608	58	t
609	53	t
609	54	t
609	55	t
609	56	t
609	57	t
609	58	t
609	65	t
609	66	t
609	68	t
609	69	t
610	9	t
610	10	t
610	11	t
610	12	t
610	13	t
610	14	t
610	15	t
610	59	t
610	60	t
610	61	t
610	62	t
610	47	t
610	49	t
610	50	t
610	51	t
610	52	t
611	10	t
611	11	t
611	13	t
611	14	t
611	15	t
611	16	t
611	35	t
611	36	t
611	37	t
611	38	t
611	39	t
611	40	t
612	30	t
612	32	t
612	34	t
612	17	t
612	18	t
612	19	t
612	20	t
612	21	t
612	22	t
612	42	t
612	43	t
612	44	t
612	45	t
612	46	t
613	54	t
613	55	t
613	57	t
613	58	t
613	47	t
613	49	t
613	50	t
613	51	t
613	52	t
613	9	t
613	10	t
613	11	t
613	12	t
613	14	t
613	15	t
613	16	t
613	23	t
613	24	t
613	26	t
613	27	t
613	28	t
614	66	t
614	67	t
614	68	t
614	69	t
615	29	t
615	30	t
615	31	t
615	34	t
615	9	t
615	10	t
615	11	t
615	13	t
615	15	t
615	16	t
616	29	t
616	30	t
616	31	t
616	32	t
616	33	t
616	34	t
616	59	t
616	60	t
616	62	t
616	63	t
616	64	t
617	9	t
617	10	t
617	11	t
617	12	t
617	13	t
617	14	t
617	15	t
617	16	t
617	36	t
617	39	t
617	40	t
618	2	t
618	3	t
618	4	t
618	6	t
618	7	t
618	8	t
618	23	t
618	24	t
618	25	t
618	26	t
618	27	t
618	28	t
619	41	t
619	42	t
619	43	t
619	45	t
620	1	t
620	2	t
620	3	t
620	4	t
620	7	t
620	8	t
621	1	t
621	2	t
621	3	t
621	4	t
621	5	t
621	6	t
621	7	t
621	9	t
621	12	t
621	13	t
621	14	t
621	16	t
622	35	t
622	36	t
622	37	t
622	38	t
622	39	t
622	40	t
622	48	t
622	49	t
622	50	t
622	51	t
623	47	t
623	48	t
623	50	t
623	52	t
623	65	t
623	66	t
623	68	t
623	69	t
623	70	t
624	65	t
624	66	t
624	68	t
624	69	t
624	70	t
624	41	t
624	42	t
624	43	t
624	44	t
624	45	t
624	46	t
625	1	t
625	3	t
625	4	t
625	5	t
625	6	t
625	7	t
625	8	t
625	19	t
625	20	t
625	21	t
626	23	t
626	24	t
626	25	t
626	26	t
626	27	t
626	28	t
626	31	t
626	32	t
626	33	t
626	34	t
627	23	t
627	26	t
627	47	t
627	48	t
627	49	t
627	50	t
627	51	t
627	52	t
627	29	t
627	30	t
627	31	t
627	32	t
627	33	t
627	34	t
628	41	t
628	42	t
628	43	t
628	44	t
628	45	t
628	10	t
628	11	t
628	12	t
628	13	t
628	14	t
628	15	t
628	16	t
628	35	t
628	36	t
628	37	t
628	38	t
628	39	t
628	40	t
628	60	t
628	61	t
628	64	t
629	35	t
629	36	t
629	38	t
629	39	t
629	59	t
629	60	t
629	61	t
629	62	t
629	63	t
629	64	t
629	2	t
629	3	t
629	5	t
629	6	t
629	7	t
629	8	t
630	65	t
630	66	t
630	67	t
630	68	t
630	69	t
630	70	t
630	1	t
630	2	t
630	3	t
630	4	t
630	5	t
630	6	t
630	7	t
630	9	t
630	10	t
630	11	t
630	12	t
630	13	t
630	14	t
630	15	t
631	23	t
631	24	t
631	27	t
631	28	t
631	47	t
631	48	t
631	50	t
631	51	t
631	52	t
632	35	t
632	36	t
632	37	t
632	38	t
632	39	t
632	40	t
632	47	t
632	48	t
632	50	t
632	18	t
632	19	t
632	20	t
632	22	t
633	48	t
633	49	t
633	50	t
634	29	t
634	30	t
634	31	t
634	32	t
634	33	t
634	34	t
634	65	t
634	66	t
634	67	t
634	70	t
635	17	t
635	18	t
635	19	t
635	20	t
635	21	t
635	22	t
635	23	t
635	24	t
635	25	t
635	26	t
635	27	t
636	1	t
636	2	t
636	3	t
636	4	t
636	5	t
636	6	t
636	7	t
637	41	t
637	42	t
637	43	t
637	44	t
637	45	t
637	46	t
637	53	t
637	54	t
637	55	t
637	56	t
637	57	t
637	58	t
638	36	t
638	37	t
638	38	t
638	39	t
639	47	t
639	48	t
639	50	t
639	51	t
639	1	t
639	3	t
639	6	t
639	7	t
639	8	t
639	9	t
639	10	t
639	11	t
639	15	t
639	16	t
640	18	t
640	20	t
640	21	t
640	22	t
641	65	t
641	66	t
641	68	t
641	69	t
641	70	t
641	23	t
641	24	t
641	25	t
641	26	t
641	27	t
641	28	t
642	10	t
642	11	t
642	12	t
642	13	t
642	14	t
642	15	t
642	16	t
643	42	t
643	43	t
643	44	t
643	46	t
643	54	t
643	55	t
643	57	t
643	58	t
644	24	t
644	25	t
644	26	t
644	27	t
644	28	t
644	9	t
644	10	t
644	11	t
644	12	t
644	13	t
644	14	t
644	16	t
645	53	t
645	54	t
645	55	t
645	56	t
645	57	t
645	58	t
645	23	t
645	24	t
645	25	t
645	26	t
645	27	t
645	28	t
645	29	t
645	30	t
645	32	t
645	33	t
645	34	t
645	17	t
645	19	t
645	20	t
645	22	t
646	41	t
646	42	t
646	43	t
646	44	t
646	45	t
646	46	t
646	65	t
646	68	t
646	69	t
646	70	t
647	1	t
647	3	t
647	4	t
647	5	t
647	6	t
647	7	t
647	8	t
647	18	t
647	19	t
647	20	t
647	21	t
647	22	t
647	59	t
647	60	t
647	61	t
647	63	t
647	64	t
648	65	t
648	66	t
648	67	t
648	69	t
648	70	t
648	47	t
648	48	t
648	49	t
648	50	t
648	51	t
648	52	t
648	19	t
648	20	t
648	21	t
648	22	t
649	59	t
649	60	t
649	61	t
649	62	t
649	63	t
649	64	t
649	65	t
649	66	t
649	67	t
649	68	t
649	69	t
649	17	t
649	18	t
649	19	t
649	20	t
649	21	t
650	9	t
650	10	t
650	11	t
650	12	t
650	13	t
650	14	t
650	15	t
650	16	t
650	48	t
650	49	t
650	50	t
650	51	t
650	52	t
651	59	t
651	60	t
651	61	t
651	62	t
651	23	t
651	24	t
651	26	t
651	27	t
651	28	t
651	1	t
651	3	t
651	4	t
651	5	t
651	6	t
651	8	t
652	47	t
652	48	t
652	49	t
652	50	t
652	51	t
652	52	t
653	36	t
653	37	t
653	38	t
653	17	t
653	18	t
653	19	t
653	24	t
653	25	t
653	26	t
653	27	t
653	28	t
654	17	t
654	19	t
654	20	t
654	22	t
654	35	t
654	36	t
654	37	t
654	38	t
654	39	t
654	40	t
655	23	t
655	24	t
655	26	t
655	27	t
655	28	t
655	66	t
655	67	t
655	68	t
655	69	t
655	70	t
656	47	t
656	48	t
656	49	t
656	51	t
656	52	t
656	59	t
656	60	t
656	63	t
656	64	t
656	41	t
656	42	t
656	43	t
656	44	t
656	45	t
656	46	t
657	53	t
657	54	t
657	55	t
657	56	t
657	58	t
657	48	t
657	49	t
657	50	t
657	51	t
658	59	t
658	61	t
658	62	t
658	63	t
658	64	t
659	47	t
659	48	t
659	50	t
659	52	t
659	1	t
659	2	t
659	3	t
659	4	t
659	5	t
659	7	t
660	41	t
660	44	t
660	45	t
660	46	t
660	1	t
660	2	t
660	3	t
660	4	t
660	7	t
660	8	t
661	1	t
661	3	t
661	4	t
661	5	t
661	6	t
661	7	t
661	41	t
661	43	t
661	44	t
661	46	t
662	59	t
662	60	t
662	61	t
662	62	t
662	63	t
662	54	t
662	55	t
662	56	t
662	57	t
662	58	t
662	65	t
662	67	t
662	68	t
662	70	t
663	48	t
663	49	t
663	50	t
663	51	t
663	52	t
663	10	t
663	12	t
663	13	t
663	14	t
663	15	t
663	16	t
663	35	t
663	36	t
663	37	t
663	38	t
663	39	t
663	40	t
663	1	t
663	2	t
663	3	t
663	4	t
663	5	t
663	6	t
663	7	t
663	8	t
664	47	t
664	48	t
664	49	t
664	50	t
664	51	t
664	52	t
664	59	t
664	60	t
664	62	t
664	63	t
664	64	t
664	1	t
664	5	t
664	6	t
664	7	t
664	8	t
665	41	t
665	42	t
665	43	t
665	44	t
665	17	t
665	20	t
665	21	t
665	22	t
666	61	t
666	62	t
666	63	t
666	64	t
666	29	t
666	30	t
666	31	t
666	32	t
666	33	t
666	34	t
666	17	t
666	18	t
666	19	t
666	20	t
666	21	t
666	22	t
666	65	t
666	66	t
666	67	t
666	68	t
666	69	t
667	41	t
667	42	t
667	43	t
667	44	t
667	45	t
667	46	t
667	9	t
667	10	t
667	12	t
667	13	t
667	14	t
667	15	t
668	23	t
668	24	t
668	25	t
668	28	t
668	17	t
668	18	t
668	19	t
668	20	t
668	21	t
668	22	t
669	35	t
669	36	t
669	37	t
669	38	t
669	39	t
669	40	t
669	42	t
669	43	t
669	44	t
669	46	t
670	9	t
670	10	t
670	11	t
670	14	t
670	16	t
670	17	t
670	18	t
670	19	t
670	22	t
670	41	t
670	42	t
670	43	t
670	44	t
670	45	t
670	59	t
670	60	t
670	61	t
670	62	t
670	63	t
670	64	t
671	36	t
671	37	t
671	38	t
671	39	t
671	40	t
672	47	t
672	48	t
672	49	t
672	23	t
672	24	t
672	25	t
672	27	t
672	28	t
673	10	t
673	11	t
673	12	t
673	16	t
673	29	t
673	30	t
673	31	t
673	32	t
673	33	t
673	34	t
673	53	t
673	54	t
673	55	t
673	56	t
673	57	t
673	58	t
674	23	t
674	24	t
674	25	t
674	26	t
674	28	t
674	17	t
674	18	t
674	19	t
674	20	t
675	35	t
675	37	t
675	38	t
675	39	t
675	59	t
675	61	t
675	62	t
675	63	t
675	64	t
675	29	t
675	30	t
675	31	t
675	32	t
676	47	t
676	49	t
676	51	t
676	52	t
676	65	t
676	66	t
676	67	t
676	68	t
676	69	t
676	70	t
676	35	t
676	36	t
676	37	t
676	38	t
676	39	t
677	1	t
677	2	t
677	3	t
677	4	t
677	5	t
677	6	t
677	7	t
677	17	t
677	19	t
677	21	t
677	22	t
678	29	t
678	30	t
678	31	t
678	33	t
678	34	t
678	53	t
678	54	t
678	56	t
678	57	t
678	58	t
678	59	t
678	60	t
678	61	t
678	62	t
678	63	t
678	64	t
679	29	t
679	30	t
679	31	t
679	33	t
679	34	t
679	54	t
679	55	t
679	58	t
679	9	t
679	10	t
679	11	t
679	12	t
679	13	t
679	14	t
679	15	t
679	16	t
680	47	t
680	48	t
680	49	t
680	50	t
680	51	t
680	52	t
680	17	t
680	19	t
680	21	t
680	22	t
681	3	t
681	4	t
681	7	t
681	8	t
681	9	t
681	12	t
681	13	t
681	14	t
681	15	t
681	16	t
682	56	t
682	57	t
682	58	t
682	47	t
682	48	t
682	49	t
682	50	t
682	51	t
682	52	t
682	2	t
682	3	t
682	5	t
682	6	t
682	7	t
682	8	t
683	35	t
683	36	t
683	37	t
683	38	t
683	39	t
683	41	t
683	42	t
683	43	t
683	44	t
683	45	t
683	46	t
684	35	t
684	36	t
684	37	t
684	38	t
684	39	t
684	47	t
684	49	t
684	50	t
684	51	t
684	52	t
685	29	t
685	30	t
685	31	t
685	33	t
685	1	t
685	4	t
685	5	t
685	6	t
685	7	t
685	8	t
686	41	t
686	42	t
686	44	t
686	47	t
686	48	t
686	50	t
686	51	t
686	52	t
687	23	t
687	24	t
687	25	t
687	26	t
687	28	t
687	29	t
687	30	t
687	31	t
687	32	t
687	33	t
687	34	t
687	2	t
687	3	t
687	4	t
687	5	t
687	6	t
687	7	t
687	8	t
688	59	t
688	61	t
688	62	t
688	64	t
688	65	t
688	66	t
688	68	t
688	69	t
688	70	t
689	53	t
689	55	t
689	56	t
689	57	t
689	58	t
689	9	t
689	10	t
689	11	t
689	12	t
689	13	t
689	14	t
689	15	t
689	16	t
689	35	t
689	36	t
689	39	t
690	1	t
690	2	t
690	3	t
690	7	t
690	8	t
690	9	t
690	10	t
690	11	t
690	12	t
690	13	t
690	14	t
690	15	t
690	16	t
691	1	t
691	2	t
691	3	t
691	4	t
691	5	t
691	6	t
691	7	t
691	8	t
691	41	t
691	42	t
691	43	t
691	44	t
691	45	t
691	46	t
691	9	t
691	11	t
691	12	t
691	14	t
691	16	t
692	59	t
692	61	t
692	62	t
692	63	t
692	64	t
692	1	t
692	2	t
692	3	t
692	5	t
692	7	t
692	8	t
693	67	t
693	68	t
693	69	t
693	59	t
693	60	t
693	62	t
693	63	t
693	35	t
693	36	t
693	38	t
693	39	t
693	40	t
693	17	t
693	18	t
693	20	t
694	47	t
694	48	t
694	49	t
694	50	t
694	51	t
694	60	t
694	62	t
694	63	t
694	64	t
695	23	t
695	24	t
695	25	t
695	26	t
695	27	t
695	28	t
695	17	t
695	19	t
695	21	t
695	22	t
695	29	t
695	30	t
695	31	t
695	33	t
695	34	t
696	1	t
696	2	t
696	3	t
696	4	t
696	6	t
696	7	t
696	8	t
696	30	t
696	31	t
696	32	t
696	42	t
696	43	t
696	44	t
696	45	t
697	17	t
697	18	t
697	19	t
697	21	t
697	22	t
697	41	t
697	42	t
697	43	t
697	44	t
697	45	t
698	59	t
698	61	t
698	62	t
698	63	t
699	17	t
699	18	t
699	19	t
699	20	t
699	21	t
699	29	t
699	30	t
699	31	t
699	32	t
700	59	t
700	60	t
700	61	t
700	62	t
700	63	t
700	64	t
700	17	t
700	18	t
700	19	t
700	22	t
700	1	t
700	3	t
700	4	t
700	5	t
700	6	t
700	7	t
700	8	t
701	17	t
701	18	t
701	19	t
701	20	t
701	21	t
701	22	t
701	47	t
701	48	t
701	49	t
701	50	t
701	52	t
702	23	t
702	24	t
702	26	t
702	27	t
702	28	t
702	59	t
702	61	t
702	62	t
702	63	t
702	64	t
702	54	t
702	55	t
702	56	t
702	57	t
703	29	t
703	30	t
703	31	t
703	32	t
703	33	t
703	34	t
703	23	t
703	25	t
703	27	t
703	41	t
703	42	t
703	44	t
703	45	t
703	46	t
704	10	t
704	12	t
704	13	t
704	14	t
704	16	t
704	17	t
704	18	t
704	21	t
704	22	t
705	47	t
705	48	t
705	49	t
705	50	t
705	51	t
705	52	t
705	41	t
705	43	t
705	44	t
706	65	t
706	66	t
706	67	t
706	68	t
706	69	t
706	70	t
706	17	t
706	18	t
706	19	t
706	20	t
706	21	t
706	22	t
707	9	t
707	10	t
707	12	t
707	14	t
707	16	t
707	47	t
707	48	t
707	49	t
707	50	t
707	51	t
707	17	t
707	18	t
707	19	t
707	20	t
707	21	t
708	47	t
708	48	t
708	49	t
708	50	t
708	51	t
708	65	t
708	67	t
708	68	t
708	69	t
708	70	t
709	2	t
709	3	t
709	4	t
709	5	t
709	6	t
709	7	t
709	8	t
709	24	t
709	25	t
709	27	t
710	65	t
710	67	t
710	70	t
710	41	t
710	42	t
710	43	t
710	44	t
710	45	t
710	46	t
711	9	t
711	10	t
711	11	t
711	12	t
711	13	t
711	14	t
711	15	t
711	65	t
711	66	t
711	67	t
711	68	t
711	70	t
711	29	t
711	30	t
711	31	t
711	32	t
711	33	t
711	34	t
712	59	t
712	60	t
712	61	t
712	62	t
712	64	t
712	9	t
712	10	t
712	11	t
712	12	t
712	14	t
712	15	t
712	16	t
712	54	t
712	55	t
712	56	t
712	58	t
713	29	t
713	31	t
713	32	t
713	33	t
713	34	t
713	47	t
713	48	t
713	49	t
713	50	t
713	51	t
713	52	t
713	35	t
713	37	t
713	38	t
713	39	t
713	40	t
714	18	t
714	19	t
714	20	t
714	21	t
714	22	t
714	60	t
714	62	t
714	63	t
714	64	t
714	23	t
714	24	t
714	25	t
714	26	t
714	27	t
714	28	t
715	47	t
715	48	t
715	49	t
715	29	t
715	31	t
715	34	t
716	29	t
716	30	t
716	31	t
716	32	t
716	33	t
716	34	t
717	36	t
717	37	t
717	38	t
717	39	t
717	17	t
717	18	t
717	19	t
717	20	t
717	21	t
717	22	t
717	9	t
717	10	t
717	11	t
717	12	t
717	13	t
717	15	t
717	16	t
717	53	t
717	54	t
717	55	t
717	58	t
718	29	t
718	30	t
718	31	t
718	32	t
718	33	t
718	34	t
718	65	t
718	66	t
718	67	t
718	68	t
718	69	t
718	17	t
718	18	t
718	19	t
718	20	t
718	21	t
718	22	t
718	23	t
718	24	t
718	25	t
718	26	t
718	28	t
719	65	t
719	68	t
719	69	t
719	70	t
719	30	t
719	31	t
719	32	t
719	33	t
719	34	t
719	47	t
719	48	t
719	49	t
719	50	t
720	47	t
720	48	t
720	49	t
720	50	t
720	52	t
720	9	t
720	10	t
720	11	t
720	12	t
720	13	t
720	14	t
720	15	t
720	16	t
720	29	t
720	30	t
720	31	t
720	32	t
720	34	t
721	54	t
721	55	t
721	56	t
721	57	t
721	58	t
721	60	t
721	62	t
721	64	t
721	45	t
721	46	t
722	41	t
722	42	t
722	43	t
722	44	t
722	45	t
722	46	t
722	30	t
722	31	t
722	32	t
722	33	t
722	34	t
723	9	t
723	10	t
723	11	t
723	12	t
723	13	t
723	14	t
723	15	t
723	24	t
723	25	t
723	26	t
723	27	t
723	28	t
724	30	t
724	31	t
724	32	t
724	33	t
724	34	t
724	65	t
724	66	t
724	67	t
724	68	t
724	69	t
724	70	t
725	29	t
725	30	t
725	31	t
725	32	t
725	9	t
725	10	t
725	11	t
725	12	t
725	14	t
725	15	t
725	16	t
726	1	t
726	2	t
726	3	t
726	4	t
726	5	t
726	6	t
726	7	t
726	8	t
726	23	t
726	24	t
726	25	t
726	26	t
727	30	t
727	31	t
727	32	t
727	65	t
727	66	t
727	68	t
727	70	t
727	9	t
727	10	t
727	11	t
727	12	t
727	14	t
727	15	t
727	16	t
728	2	t
728	3	t
728	4	t
728	6	t
728	7	t
728	8	t
728	41	t
728	42	t
728	43	t
728	44	t
728	46	t
728	29	t
728	30	t
728	31	t
729	9	t
729	10	t
729	11	t
729	12	t
729	13	t
729	14	t
729	15	t
729	16	t
729	23	t
729	24	t
729	25	t
729	26	t
729	28	t
729	59	t
729	60	t
729	61	t
729	62	t
729	63	t
729	64	t
730	23	t
730	24	t
730	25	t
730	26	t
730	27	t
730	47	t
730	48	t
730	49	t
730	51	t
730	52	t
731	42	t
731	43	t
731	44	t
731	45	t
731	46	t
731	9	t
731	10	t
731	11	t
731	13	t
731	16	t
732	23	t
732	25	t
732	26	t
732	27	t
732	28	t
732	54	t
732	55	t
732	56	t
732	57	t
732	47	t
732	48	t
732	49	t
732	51	t
732	52	t
733	23	t
733	24	t
733	25	t
733	26	t
733	27	t
733	28	t
733	29	t
733	30	t
733	31	t
733	33	t
733	34	t
733	17	t
733	19	t
733	21	t
733	22	t
733	59	t
733	60	t
733	61	t
733	62	t
733	63	t
733	64	t
734	53	t
734	54	t
734	55	t
734	56	t
734	57	t
734	58	t
734	29	t
734	30	t
734	31	t
734	32	t
734	33	t
734	34	t
734	17	t
734	18	t
734	19	t
734	20	t
734	21	t
734	22	t
735	1	t
735	2	t
735	4	t
735	5	t
735	6	t
735	8	t
735	47	t
735	48	t
735	49	t
735	50	t
735	52	t
735	41	t
735	42	t
735	43	t
735	44	t
735	45	t
735	46	t
736	53	t
736	54	t
736	55	t
736	56	t
736	57	t
736	58	t
736	17	t
736	18	t
736	19	t
736	21	t
736	22	t
737	59	t
737	62	t
737	47	t
737	48	t
737	49	t
737	50	t
737	51	t
737	52	t
738	1	t
738	2	t
738	3	t
738	4	t
738	5	t
738	6	t
738	7	t
738	8	t
738	41	t
738	42	t
738	43	t
738	44	t
738	45	t
738	23	t
738	24	t
738	26	t
738	27	t
738	28	t
739	41	t
739	42	t
739	43	t
739	44	t
739	45	t
739	46	t
739	23	t
739	26	t
739	27	t
739	28	t
739	53	t
739	54	t
739	55	t
739	56	t
739	57	t
739	58	t
740	29	t
740	31	t
740	32	t
740	33	t
740	41	t
740	44	t
740	46	t
741	1	t
741	2	t
741	3	t
741	4	t
741	5	t
741	6	t
741	8	t
741	41	t
741	42	t
741	43	t
741	44	t
741	45	t
741	46	t
742	11	t
742	12	t
742	13	t
742	14	t
742	15	t
742	16	t
742	59	t
742	60	t
742	61	t
742	62	t
742	63	t
743	42	t
743	44	t
743	45	t
743	17	t
743	18	t
743	19	t
743	20	t
743	21	t
743	22	t
743	65	t
743	66	t
743	70	t
744	53	t
744	54	t
744	55	t
744	57	t
744	58	t
744	9	t
744	10	t
744	13	t
744	14	t
744	15	t
744	16	t
745	53	t
745	55	t
745	56	t
745	57	t
745	58	t
745	48	t
745	49	t
745	52	t
746	35	t
746	36	t
746	37	t
746	38	t
746	39	t
746	23	t
746	24	t
746	25	t
746	26	t
746	27	t
746	28	t
747	1	t
747	2	t
747	3	t
747	4	t
747	5	t
747	7	t
747	8	t
747	23	t
747	24	t
747	25	t
747	26	t
747	27	t
748	17	t
748	18	t
748	19	t
748	20	t
748	21	t
748	22	t
748	42	t
748	43	t
748	44	t
748	45	t
748	46	t
749	35	t
749	36	t
749	37	t
749	39	t
749	40	t
749	59	t
749	60	t
749	61	t
749	62	t
749	63	t
749	64	t
750	30	t
750	32	t
750	33	t
750	34	t
750	41	t
750	42	t
750	43	t
750	44	t
750	45	t
750	46	t
750	66	t
750	67	t
750	69	t
750	70	t
751	23	t
751	24	t
751	25	t
751	26	t
751	27	t
751	28	t
751	30	t
751	32	t
751	33	t
751	34	t
752	36	t
752	38	t
752	39	t
752	40	t
752	23	t
752	24	t
752	25	t
752	26	t
752	27	t
752	28	t
752	66	t
752	67	t
752	68	t
752	69	t
752	70	t
753	53	t
753	54	t
753	55	t
753	56	t
753	57	t
753	58	t
753	31	t
753	32	t
753	33	t
753	1	t
753	5	t
753	7	t
753	8	t
754	1	t
754	2	t
754	3	t
754	4	t
754	5	t
754	6	t
754	8	t
754	53	t
754	54	t
754	55	t
754	56	t
754	37	t
754	38	t
754	39	t
754	40	t
755	47	t
755	48	t
755	49	t
755	50	t
755	51	t
755	52	t
755	59	t
755	60	t
755	61	t
755	62	t
755	63	t
755	64	t
755	17	t
755	18	t
755	19	t
755	20	t
755	22	t
755	41	t
755	42	t
755	43	t
755	45	t
755	46	t
756	59	t
756	60	t
756	61	t
756	62	t
756	64	t
756	54	t
756	56	t
756	58	t
756	17	t
756	18	t
756	19	t
756	20	t
756	21	t
756	22	t
757	19	t
757	20	t
757	21	t
757	22	t
757	1	t
757	2	t
757	3	t
757	7	t
757	8	t
757	53	t
757	54	t
757	55	t
757	56	t
757	57	t
757	58	t
758	47	t
758	48	t
758	49	t
758	50	t
758	43	t
758	44	t
758	45	t
758	46	t
758	54	t
758	56	t
758	57	t
758	58	t
759	42	t
759	43	t
759	44	t
759	45	t
759	46	t
759	9	t
759	10	t
759	11	t
759	12	t
759	13	t
759	14	t
759	15	t
760	35	t
760	36	t
760	37	t
760	38	t
760	39	t
760	65	t
760	66	t
760	67	t
760	69	t
760	70	t
761	53	t
761	54	t
761	55	t
761	56	t
761	58	t
761	35	t
761	36	t
761	37	t
761	38	t
761	39	t
761	40	t
761	1	t
761	2	t
761	3	t
761	4	t
761	5	t
761	6	t
761	8	t
762	59	t
762	60	t
762	61	t
762	62	t
762	63	t
762	64	t
763	18	t
763	19	t
763	20	t
763	21	t
763	22	t
763	65	t
763	66	t
763	67	t
763	68	t
763	69	t
763	70	t
763	47	t
763	49	t
763	50	t
763	51	t
763	52	t
763	59	t
763	63	t
763	64	t
764	25	t
764	26	t
764	27	t
764	28	t
764	59	t
764	61	t
764	62	t
764	63	t
764	64	t
765	47	t
765	48	t
765	49	t
765	50	t
765	51	t
765	52	t
765	41	t
765	42	t
765	43	t
765	44	t
765	45	t
765	46	t
766	47	t
766	50	t
766	52	t
766	1	t
766	2	t
766	3	t
766	5	t
766	8	t
767	42	t
767	43	t
767	44	t
767	45	t
767	1	t
767	2	t
767	3	t
767	5	t
767	6	t
767	7	t
767	53	t
767	54	t
767	55	t
767	56	t
767	57	t
767	58	t
768	18	t
768	19	t
768	20	t
768	21	t
768	22	t
768	54	t
768	56	t
768	57	t
768	58	t
768	2	t
768	3	t
768	4	t
768	5	t
768	6	t
769	1	t
769	2	t
769	4	t
769	5	t
769	6	t
769	7	t
769	8	t
769	9	t
769	10	t
769	11	t
769	12	t
769	13	t
769	15	t
769	16	t
769	47	t
769	48	t
769	49	t
769	50	t
769	51	t
769	52	t
770	9	t
770	10	t
770	11	t
770	12	t
770	13	t
770	14	t
770	16	t
770	53	t
770	54	t
770	55	t
770	56	t
770	57	t
770	58	t
770	23	t
770	26	t
770	27	t
770	28	t
771	10	t
771	11	t
771	12	t
771	13	t
771	14	t
771	15	t
771	16	t
771	35	t
771	36	t
771	38	t
771	39	t
771	40	t
771	23	t
771	24	t
771	25	t
771	26	t
771	41	t
771	42	t
771	43	t
771	44	t
771	46	t
772	10	t
772	13	t
772	14	t
772	15	t
772	16	t
772	53	t
772	54	t
772	56	t
772	58	t
772	59	t
772	60	t
772	61	t
772	62	t
772	64	t
773	65	t
773	66	t
773	67	t
773	70	t
773	47	t
773	48	t
773	49	t
773	50	t
773	51	t
773	52	t
773	2	t
773	5	t
773	8	t
774	35	t
774	36	t
774	39	t
774	40	t
774	1	t
774	4	t
774	5	t
774	6	t
774	7	t
774	8	t
774	41	t
774	42	t
774	43	t
774	44	t
774	45	t
774	46	t
775	59	t
775	61	t
775	62	t
775	63	t
775	64	t
776	65	t
776	66	t
776	67	t
776	69	t
776	70	t
776	41	t
776	44	t
776	45	t
777	23	t
777	24	t
777	25	t
777	26	t
777	27	t
777	28	t
777	35	t
777	36	t
777	37	t
777	38	t
777	39	t
777	40	t
777	53	t
777	54	t
777	55	t
777	56	t
777	57	t
778	66	t
778	69	t
778	70	t
779	59	t
779	60	t
779	61	t
779	62	t
779	64	t
779	1	t
779	3	t
779	5	t
779	6	t
779	7	t
779	8	t
780	53	t
780	55	t
780	57	t
780	58	t
780	48	t
780	49	t
780	50	t
780	51	t
780	52	t
780	29	t
780	30	t
780	31	t
780	32	t
780	33	t
780	34	t
780	9	t
780	10	t
780	11	t
780	12	t
780	13	t
780	14	t
780	15	t
780	16	t
781	53	t
781	55	t
781	57	t
781	58	t
781	23	t
781	24	t
781	26	t
781	27	t
781	28	t
781	47	t
781	49	t
781	50	t
781	51	t
781	52	t
782	17	t
782	18	t
782	19	t
782	20	t
782	21	t
782	22	t
782	41	t
782	42	t
782	43	t
782	44	t
782	45	t
782	46	t
783	65	t
783	66	t
783	67	t
783	68	t
783	70	t
783	59	t
783	60	t
783	61	t
783	64	t
783	29	t
783	30	t
783	31	t
783	32	t
783	33	t
783	34	t
783	1	t
783	2	t
783	3	t
783	4	t
783	5	t
783	6	t
783	7	t
783	8	t
784	35	t
784	36	t
784	37	t
784	40	t
784	30	t
784	31	t
784	32	t
784	33	t
784	34	t
784	23	t
784	24	t
784	25	t
784	27	t
784	28	t
785	47	t
785	48	t
785	49	t
785	50	t
785	52	t
785	29	t
785	30	t
785	31	t
785	32	t
785	33	t
786	53	t
786	54	t
786	55	t
786	56	t
786	58	t
786	1	t
786	2	t
786	3	t
786	5	t
786	6	t
787	59	t
787	60	t
787	61	t
787	62	t
787	63	t
787	64	t
787	48	t
787	49	t
787	50	t
787	51	t
787	52	t
787	1	t
787	2	t
787	3	t
787	4	t
787	5	t
787	6	t
788	65	t
788	67	t
788	9	t
788	10	t
788	11	t
788	12	t
788	13	t
788	14	t
788	15	t
788	59	t
788	60	t
788	61	t
788	62	t
789	53	t
789	54	t
789	55	t
789	56	t
789	57	t
789	58	t
789	17	t
789	18	t
789	21	t
789	22	t
789	59	t
789	60	t
789	61	t
789	62	t
789	63	t
790	53	t
790	54	t
790	56	t
790	57	t
790	58	t
790	29	t
790	30	t
790	31	t
790	32	t
790	34	t
791	41	t
791	42	t
791	43	t
791	44	t
791	46	t
791	19	t
791	20	t
791	21	t
791	22	t
791	23	t
791	24	t
791	25	t
791	26	t
791	27	t
791	28	t
792	47	t
792	48	t
792	49	t
792	50	t
792	51	t
792	52	t
792	41	t
792	42	t
792	44	t
792	45	t
792	46	t
793	66	t
793	67	t
793	68	t
793	69	t
793	70	t
793	41	t
793	42	t
793	43	t
793	44	t
793	46	t
793	17	t
793	19	t
793	21	t
793	22	t
794	9	t
794	10	t
794	11	t
794	13	t
794	14	t
794	15	t
794	16	t
794	35	t
794	36	t
794	37	t
794	38	t
794	39	t
794	40	t
795	17	t
795	18	t
795	19	t
795	20	t
795	21	t
795	22	t
795	59	t
795	60	t
795	62	t
795	63	t
795	41	t
795	42	t
795	43	t
795	44	t
795	45	t
795	46	t
796	65	t
796	69	t
796	70	t
797	36	t
797	37	t
797	38	t
797	39	t
797	40	t
797	59	t
797	61	t
797	62	t
797	64	t
798	17	t
798	18	t
798	19	t
798	21	t
798	22	t
799	18	t
799	19	t
799	21	t
799	22	t
799	42	t
799	43	t
799	44	t
799	45	t
799	46	t
799	47	t
799	48	t
799	49	t
799	50	t
799	51	t
799	52	t
800	59	t
800	60	t
800	61	t
800	62	t
800	64	t
800	10	t
800	11	t
800	12	t
800	13	t
800	14	t
800	16	t
800	41	t
800	42	t
800	43	t
800	45	t
800	46	t
800	17	t
800	18	t
800	19	t
800	20	t
800	22	t
801	59	t
801	60	t
801	62	t
801	63	t
801	35	t
801	36	t
801	37	t
801	38	t
801	40	t
802	59	t
802	60	t
802	61	t
802	62	t
802	64	t
802	17	t
802	18	t
802	19	t
802	20	t
802	22	t
802	41	t
802	42	t
802	46	t
803	10	t
803	11	t
803	12	t
803	13	t
803	14	t
803	15	t
803	23	t
803	24	t
803	25	t
803	26	t
803	27	t
803	28	t
804	29	t
804	30	t
804	31	t
804	32	t
804	33	t
804	34	t
804	24	t
804	25	t
804	26	t
804	28	t
804	41	t
804	42	t
804	43	t
804	44	t
804	45	t
804	46	t
805	53	t
805	54	t
805	55	t
805	56	t
805	58	t
805	41	t
805	42	t
805	43	t
805	44	t
805	45	t
805	17	t
805	19	t
805	20	t
805	21	t
806	59	t
806	60	t
806	62	t
806	63	t
806	64	t
806	1	t
806	3	t
806	4	t
806	5	t
806	7	t
806	8	t
807	19	t
807	20	t
807	21	t
807	1	t
807	2	t
807	3	t
807	5	t
807	6	t
807	7	t
807	8	t
808	17	t
808	19	t
808	20	t
808	22	t
808	23	t
808	24	t
808	25	t
808	26	t
808	27	t
808	28	t
809	47	t
809	48	t
809	49	t
809	51	t
809	52	t
810	47	t
810	48	t
810	49	t
810	51	t
810	52	t
810	35	t
810	39	t
810	40	t
811	23	t
811	24	t
811	25	t
811	26	t
811	27	t
812	1	t
812	2	t
812	3	t
812	5	t
812	7	t
812	8	t
812	19	t
812	20	t
812	21	t
813	17	t
813	18	t
813	19	t
813	20	t
813	21	t
813	1	t
813	2	t
813	3	t
813	4	t
813	5	t
813	7	t
813	8	t
813	59	t
813	61	t
813	62	t
813	64	t
814	54	t
814	56	t
814	58	t
814	35	t
814	36	t
814	37	t
814	38	t
814	40	t
815	29	t
815	30	t
815	31	t
815	33	t
815	53	t
815	57	t
815	58	t
816	1	t
816	2	t
816	5	t
816	6	t
816	7	t
816	8	t
816	65	t
816	67	t
816	68	t
816	69	t
816	53	t
816	54	t
816	55	t
816	57	t
816	58	t
817	35	t
817	36	t
817	37	t
817	38	t
817	39	t
817	17	t
817	18	t
817	19	t
817	20	t
817	21	t
817	22	t
817	29	t
817	30	t
817	31	t
817	32	t
817	34	t
818	41	t
818	42	t
818	43	t
818	44	t
818	45	t
818	46	t
818	35	t
818	36	t
818	37	t
818	38	t
818	40	t
818	17	t
818	18	t
818	19	t
818	20	t
818	21	t
818	22	t
819	36	t
819	38	t
819	40	t
819	23	t
819	24	t
819	25	t
819	26	t
819	27	t
819	28	t
819	10	t
819	11	t
819	12	t
819	13	t
819	15	t
819	16	t
819	29	t
819	30	t
819	31	t
819	32	t
819	34	t
820	59	t
820	60	t
820	61	t
820	62	t
820	63	t
820	64	t
820	1	t
820	2	t
820	3	t
820	4	t
820	5	t
820	6	t
820	7	t
820	47	t
820	48	t
820	49	t
820	51	t
820	52	t
821	35	t
821	36	t
821	37	t
821	38	t
821	39	t
821	40	t
821	59	t
821	61	t
821	62	t
821	63	t
821	64	t
821	55	t
821	56	t
821	58	t
822	17	t
822	18	t
822	19	t
822	20	t
822	21	t
822	23	t
822	24	t
822	25	t
822	26	t
822	27	t
822	28	t
822	65	t
822	66	t
822	68	t
822	70	t
823	24	t
823	27	t
823	28	t
823	35	t
823	36	t
823	37	t
823	38	t
823	39	t
823	40	t
823	17	t
823	18	t
823	20	t
823	21	t
823	22	t
824	53	t
824	54	t
824	55	t
824	56	t
824	57	t
824	58	t
824	59	t
824	61	t
824	63	t
824	64	t
825	35	t
825	36	t
825	37	t
825	38	t
825	39	t
825	40	t
825	59	t
825	60	t
825	62	t
825	63	t
825	64	t
825	41	t
825	44	t
825	45	t
825	46	t
825	24	t
825	25	t
825	26	t
825	27	t
826	18	t
826	19	t
826	20	t
826	21	t
826	22	t
827	1	t
827	2	t
827	3	t
827	5	t
827	6	t
827	8	t
827	9	t
828	53	t
828	54	t
828	55	t
828	56	t
828	57	t
828	58	t
828	59	t
828	60	t
828	61	t
828	62	t
828	64	t
829	65	t
829	66	t
829	67	t
829	68	t
829	70	t
829	24	t
829	25	t
829	26	t
829	27	t
829	28	t
829	17	t
829	18	t
829	19	t
829	20	t
829	21	t
829	22	t
829	47	t
829	49	t
829	50	t
829	51	t
830	35	t
830	36	t
830	38	t
830	39	t
831	54	t
831	55	t
831	56	t
831	57	t
832	36	t
832	37	t
832	38	t
832	40	t
832	24	t
832	25	t
832	27	t
832	28	t
832	1	t
832	2	t
832	3	t
832	4	t
832	5	t
832	6	t
832	8	t
833	66	t
833	67	t
833	69	t
833	70	t
833	23	t
833	24	t
833	25	t
833	26	t
833	27	t
833	28	t
833	59	t
833	60	t
833	61	t
833	62	t
833	64	t
834	1	t
834	3	t
834	4	t
834	6	t
834	7	t
834	8	t
834	35	t
834	36	t
834	37	t
834	39	t
834	40	t
834	47	t
834	48	t
834	49	t
834	50	t
834	51	t
835	31	t
835	32	t
835	33	t
835	34	t
835	17	t
835	19	t
835	20	t
835	21	t
835	22	t
836	17	t
836	18	t
836	20	t
836	21	t
836	22	t
836	65	t
836	66	t
836	67	t
836	68	t
836	69	t
836	70	t
836	23	t
836	24	t
836	26	t
836	27	t
836	28	t
836	29	t
836	30	t
836	32	t
836	33	t
837	65	t
837	66	t
837	67	t
837	68	t
837	69	t
837	70	t
837	25	t
837	26	t
837	27	t
837	28	t
838	53	t
838	54	t
838	55	t
838	56	t
838	57	t
838	58	t
838	17	t
838	18	t
838	19	t
838	22	t
839	17	t
839	18	t
839	19	t
839	20	t
839	21	t
839	22	t
839	23	t
839	24	t
839	25	t
839	26	t
839	27	t
839	28	t
839	65	t
839	66	t
839	68	t
839	69	t
839	70	t
840	1	t
840	2	t
840	3	t
840	4	t
840	8	t
840	35	t
840	36	t
840	37	t
840	38	t
840	39	t
840	40	t
841	1	t
841	2	t
841	3	t
841	4	t
841	5	t
841	6	t
841	7	t
841	8	t
841	10	t
841	11	t
841	13	t
841	14	t
841	15	t
841	16	t
842	53	t
842	54	t
842	57	t
842	58	t
842	65	t
842	66	t
842	67	t
842	68	t
842	69	t
842	70	t
842	41	t
842	42	t
842	43	t
842	44	t
842	45	t
842	46	t
843	53	t
843	54	t
843	55	t
843	56	t
843	57	t
844	47	t
844	48	t
844	50	t
844	51	t
844	10	t
844	12	t
844	13	t
844	14	t
844	15	t
844	16	t
845	41	t
845	42	t
845	43	t
845	44	t
845	45	t
845	46	t
845	1	t
845	2	t
845	3	t
845	5	t
845	7	t
845	8	t
845	65	t
845	67	t
845	68	t
845	69	t
845	70	t
846	65	t
846	66	t
846	67	t
846	68	t
846	70	t
846	10	t
846	13	t
846	15	t
846	16	t
847	53	t
847	54	t
847	55	t
847	56	t
847	57	t
847	58	t
847	23	t
847	24	t
847	25	t
847	26	t
847	27	t
847	28	t
848	65	t
848	66	t
848	67	t
848	68	t
848	69	t
848	70	t
848	23	t
848	24	t
848	25	t
848	26	t
848	28	t
848	41	t
848	42	t
848	43	t
848	44	t
848	45	t
848	46	t
849	67	t
849	68	t
849	70	t
849	59	t
849	60	t
849	61	t
849	62	t
849	63	t
849	64	t
850	30	t
850	31	t
850	32	t
850	33	t
850	34	t
850	35	t
850	36	t
850	37	t
850	38	t
850	39	t
850	40	t
850	41	t
850	42	t
850	44	t
850	45	t
850	46	t
850	53	t
850	54	t
850	55	t
850	56	t
850	58	t
851	29	t
851	30	t
851	31	t
851	33	t
851	34	t
851	65	t
851	67	t
851	68	t
851	69	t
851	70	t
852	35	t
852	37	t
852	38	t
852	9	t
852	10	t
852	12	t
852	13	t
852	14	t
852	15	t
852	16	t
852	29	t
852	30	t
852	31	t
852	32	t
852	33	t
852	34	t
853	66	t
853	70	t
853	24	t
853	25	t
853	27	t
853	28	t
853	29	t
853	30	t
853	31	t
853	32	t
853	33	t
854	59	t
854	60	t
854	61	t
854	63	t
854	64	t
854	23	t
854	24	t
854	26	t
854	27	t
854	1	t
854	2	t
854	3	t
854	4	t
854	5	t
854	6	t
854	8	t
854	48	t
854	49	t
854	50	t
854	51	t
855	17	t
855	18	t
855	19	t
855	20	t
855	21	t
855	22	t
855	2	t
855	3	t
855	4	t
855	6	t
855	7	t
855	65	t
855	66	t
855	67	t
855	68	t
855	69	t
855	70	t
856	65	t
856	66	t
856	68	t
856	69	t
856	23	t
856	25	t
856	26	t
856	27	t
856	28	t
856	9	t
856	10	t
856	11	t
856	12	t
856	13	t
856	14	t
856	15	t
856	16	t
857	41	t
857	42	t
857	43	t
857	44	t
857	45	t
857	46	t
857	10	t
857	13	t
857	14	t
857	15	t
857	47	t
857	48	t
857	49	t
857	52	t
858	65	t
858	66	t
858	67	t
858	68	t
858	69	t
858	70	t
858	9	t
858	11	t
858	12	t
858	13	t
858	14	t
858	16	t
859	47	t
859	48	t
859	49	t
859	50	t
859	52	t
859	17	t
859	19	t
859	20	t
860	17	t
860	18	t
860	20	t
860	21	t
860	22	t
860	1	t
860	2	t
860	4	t
860	6	t
860	7	t
860	8	t
861	41	t
861	42	t
861	43	t
861	44	t
861	45	t
861	46	t
861	53	t
861	54	t
861	55	t
861	56	t
861	57	t
862	53	t
862	54	t
862	55	t
862	56	t
862	57	t
862	58	t
862	65	t
862	67	t
862	68	t
862	69	t
862	70	t
863	65	t
863	70	t
863	59	t
863	60	t
863	61	t
863	62	t
863	63	t
863	64	t
863	41	t
863	43	t
863	44	t
863	45	t
863	46	t
864	19	t
864	20	t
864	21	t
864	22	t
864	59	t
864	60	t
864	61	t
864	63	t
864	64	t
864	10	t
864	12	t
864	13	t
864	14	t
864	15	t
864	16	t
865	24	t
865	26	t
865	27	t
865	47	t
865	48	t
865	49	t
865	50	t
865	51	t
865	52	t
866	65	t
866	66	t
866	69	t
866	70	t
866	29	t
866	30	t
866	31	t
866	32	t
866	33	t
866	34	t
866	53	t
866	54	t
866	55	t
866	56	t
866	57	t
866	10	t
866	13	t
866	14	t
866	15	t
866	16	t
867	29	t
867	31	t
867	32	t
867	34	t
867	53	t
867	54	t
867	55	t
867	56	t
867	57	t
867	58	t
868	35	t
868	36	t
868	37	t
868	38	t
868	1	t
868	2	t
868	3	t
868	4	t
868	5	t
868	7	t
868	8	t
869	59	t
869	60	t
869	61	t
869	62	t
869	63	t
869	64	t
869	24	t
869	26	t
869	27	t
869	28	t
870	59	t
870	60	t
870	61	t
870	62	t
870	64	t
870	47	t
870	48	t
870	49	t
870	50	t
870	51	t
871	29	t
871	30	t
871	31	t
871	32	t
871	33	t
871	34	t
871	23	t
871	24	t
871	25	t
871	26	t
871	28	t
872	17	t
872	18	t
872	19	t
872	20	t
872	22	t
872	29	t
872	30	t
872	31	t
872	33	t
873	59	t
873	60	t
873	61	t
873	62	t
873	63	t
873	29	t
873	30	t
873	31	t
873	32	t
873	33	t
873	34	t
873	9	t
873	10	t
873	11	t
873	12	t
873	13	t
873	14	t
873	15	t
873	16	t
873	65	t
873	66	t
873	67	t
873	68	t
873	69	t
873	70	t
874	29	t
874	30	t
874	31	t
874	32	t
874	33	t
874	53	t
874	54	t
874	55	t
874	56	t
874	57	t
874	58	t
874	18	t
874	21	t
874	22	t
875	35	t
875	36	t
875	37	t
875	38	t
875	40	t
876	35	t
876	37	t
876	39	t
876	53	t
876	55	t
876	56	t
877	47	t
877	48	t
877	49	t
877	50	t
877	51	t
877	52	t
877	29	t
877	30	t
877	31	t
877	32	t
878	35	t
878	36	t
878	37	t
878	38	t
878	39	t
878	40	t
878	1	t
878	3	t
878	4	t
878	5	t
878	7	t
878	8	t
879	17	t
879	18	t
879	19	t
879	21	t
879	22	t
879	47	t
879	48	t
879	50	t
879	52	t
880	59	t
880	60	t
880	61	t
880	63	t
880	64	t
881	23	t
881	24	t
881	25	t
881	26	t
881	27	t
881	65	t
881	66	t
881	67	t
881	68	t
881	70	t
882	41	t
882	43	t
882	44	t
882	45	t
882	46	t
882	65	t
882	68	t
882	70	t
882	1	t
882	3	t
882	4	t
882	6	t
882	7	t
883	35	t
883	36	t
883	37	t
883	38	t
883	39	t
883	40	t
883	53	t
883	54	t
883	55	t
883	56	t
883	57	t
883	58	t
884	65	t
884	66	t
884	67	t
884	69	t
884	70	t
884	47	t
884	48	t
884	49	t
884	50	t
884	51	t
884	52	t
885	42	t
885	43	t
885	45	t
885	46	t
885	10	t
885	11	t
885	13	t
885	14	t
885	15	t
885	65	t
885	67	t
885	68	t
885	69	t
885	70	t
886	65	t
886	67	t
886	70	t
886	23	t
886	24	t
886	25	t
886	26	t
886	28	t
886	53	t
886	55	t
886	57	t
886	58	t
886	42	t
886	43	t
886	44	t
886	46	t
887	23	t
887	24	t
887	26	t
887	27	t
887	28	t
887	65	t
887	66	t
887	67	t
887	68	t
887	69	t
887	70	t
887	35	t
887	36	t
887	37	t
887	38	t
887	39	t
887	40	t
887	48	t
887	49	t
887	51	t
887	52	t
888	41	t
888	42	t
888	43	t
888	45	t
888	46	t
888	53	t
888	54	t
888	55	t
888	58	t
889	35	t
889	36	t
889	38	t
889	39	t
889	10	t
889	11	t
889	12	t
889	13	t
889	14	t
889	15	t
889	16	t
890	9	t
890	11	t
890	12	t
890	14	t
890	15	t
890	53	t
890	54	t
890	55	t
890	56	t
890	57	t
890	58	t
891	35	t
891	36	t
891	37	t
891	38	t
891	39	t
891	40	t
891	42	t
891	43	t
891	44	t
891	45	t
891	46	t
892	18	t
892	19	t
892	20	t
892	21	t
892	22	t
892	9	t
892	10	t
892	11	t
892	12	t
892	13	t
892	15	t
892	16	t
892	41	t
892	42	t
892	44	t
892	45	t
893	53	t
893	54	t
893	55	t
893	56	t
893	58	t
893	42	t
893	43	t
893	44	t
893	45	t
893	46	t
893	17	t
893	18	t
893	19	t
893	20	t
893	21	t
893	22	t
894	29	t
894	30	t
894	31	t
894	32	t
894	34	t
894	17	t
894	18	t
894	19	t
894	20	t
894	22	t
894	1	t
894	2	t
894	3	t
894	4	t
894	5	t
894	8	t
895	1	t
895	2	t
895	6	t
895	8	t
895	53	t
895	55	t
895	56	t
895	57	t
895	58	t
896	30	t
896	31	t
896	34	t
896	23	t
896	24	t
896	25	t
896	26	t
896	27	t
896	28	t
897	17	t
897	19	t
897	20	t
897	22	t
897	41	t
897	42	t
897	43	t
897	44	t
897	45	t
897	46	t
898	30	t
898	31	t
898	32	t
898	33	t
898	34	t
899	29	t
899	30	t
899	31	t
899	32	t
899	33	t
899	34	t
899	9	t
899	11	t
899	14	t
899	35	t
899	38	t
900	31	t
900	32	t
900	33	t
900	34	t
900	23	t
900	24	t
900	26	t
900	27	t
900	28	t
901	9	t
901	10	t
901	11	t
901	12	t
901	13	t
901	14	t
901	23	t
901	24	t
901	25	t
901	26	t
901	27	t
901	47	t
901	48	t
901	49	t
901	51	t
901	52	t
902	37	t
902	38	t
902	39	t
902	53	t
902	54	t
902	55	t
902	56	t
902	57	t
902	58	t
902	47	t
902	48	t
902	49	t
902	50	t
902	51	t
902	52	t
902	65	t
902	67	t
902	68	t
902	69	t
903	67	t
903	68	t
903	69	t
903	70	t
903	59	t
903	61	t
903	63	t
903	64	t
903	35	t
903	36	t
903	37	t
903	39	t
903	40	t
904	66	t
904	67	t
904	69	t
904	70	t
905	35	t
905	37	t
905	38	t
905	39	t
905	40	t
905	41	t
905	42	t
905	43	t
905	45	t
905	46	t
905	9	t
905	10	t
905	12	t
905	13	t
905	14	t
905	15	t
905	16	t
905	47	t
905	48	t
905	50	t
905	51	t
905	52	t
906	9	t
906	10	t
906	11	t
906	12	t
906	13	t
906	15	t
906	16	t
906	36	t
906	39	t
906	40	t
906	1	t
906	2	t
906	3	t
906	5	t
906	6	t
906	8	t
906	17	t
906	18	t
906	19	t
906	20	t
906	21	t
906	22	t
907	35	t
907	36	t
907	37	t
908	23	t
908	24	t
908	26	t
908	28	t
908	1	t
908	2	t
908	3	t
908	4	t
908	6	t
908	7	t
908	8	t
908	65	t
908	66	t
908	67	t
908	69	t
908	70	t
909	9	t
909	11	t
909	12	t
909	13	t
909	14	t
909	15	t
909	16	t
909	17	t
909	18	t
909	19	t
909	20	t
909	22	t
909	42	t
909	43	t
909	44	t
909	45	t
909	46	t
910	41	t
910	42	t
910	43	t
910	44	t
910	46	t
910	2	t
910	3	t
910	5	t
910	6	t
910	7	t
911	35	t
911	37	t
911	38	t
911	39	t
911	9	t
911	10	t
911	11	t
911	15	t
911	16	t
912	23	t
912	24	t
912	25	t
912	26	t
912	28	t
912	65	t
912	67	t
912	68	t
912	69	t
912	70	t
912	29	t
912	30	t
912	31	t
912	32	t
912	33	t
913	9	t
913	10	t
913	11	t
913	12	t
913	13	t
913	14	t
913	15	t
913	65	t
913	66	t
913	67	t
913	69	t
913	70	t
914	47	t
914	50	t
914	52	t
914	41	t
914	42	t
914	43	t
914	44	t
914	45	t
914	46	t
914	18	t
914	19	t
914	20	t
914	21	t
914	22	t
914	35	t
914	38	t
914	39	t
914	40	t
915	23	t
915	24	t
915	25	t
915	26	t
915	27	t
915	28	t
915	60	t
915	61	t
915	63	t
915	64	t
916	54	t
916	55	t
916	56	t
916	57	t
916	30	t
916	31	t
916	32	t
916	33	t
917	53	t
917	55	t
917	56	t
917	57	t
917	58	t
917	65	t
917	66	t
917	67	t
917	68	t
917	69	t
917	70	t
918	35	t
918	36	t
918	37	t
918	38	t
918	39	t
918	40	t
918	47	t
918	48	t
918	49	t
918	50	t
918	51	t
918	52	t
918	23	t
918	24	t
918	25	t
918	27	t
918	28	t
919	47	t
919	48	t
919	49	t
919	50	t
919	51	t
919	52	t
919	65	t
919	66	t
919	67	t
919	69	t
919	70	t
919	53	t
919	55	t
919	56	t
919	57	t
919	58	t
920	35	t
920	36	t
920	37	t
920	38	t
920	39	t
920	40	t
920	53	t
920	55	t
920	56	t
920	57	t
920	58	t
920	29	t
920	30	t
920	33	t
920	34	t
920	59	t
920	60	t
920	61	t
920	62	t
920	63	t
920	64	t
921	65	t
921	66	t
921	67	t
921	68	t
921	70	t
921	47	t
921	49	t
921	50	t
921	51	t
921	9	t
921	10	t
921	11	t
921	12	t
921	14	t
921	15	t
921	16	t
922	17	t
922	18	t
922	19	t
922	20	t
922	21	t
922	22	t
922	47	t
922	48	t
922	49	t
922	50	t
922	51	t
922	52	t
923	65	t
923	66	t
923	67	t
923	68	t
923	69	t
923	42	t
923	43	t
923	45	t
923	46	t
924	53	t
924	55	t
924	56	t
924	57	t
924	58	t
924	1	t
924	2	t
924	3	t
924	4	t
924	5	t
924	6	t
924	8	t
924	47	t
924	48	t
924	49	t
924	51	t
925	17	t
925	19	t
925	20	t
925	21	t
925	22	t
925	47	t
925	48	t
925	49	t
925	50	t
925	51	t
926	35	t
926	36	t
926	37	t
926	38	t
926	39	t
926	40	t
926	65	t
926	66	t
926	67	t
926	68	t
926	69	t
926	70	t
926	30	t
926	31	t
926	32	t
926	33	t
927	53	t
927	54	t
927	55	t
927	57	t
927	58	t
927	17	t
927	18	t
927	19	t
927	20	t
927	21	t
927	3	t
927	4	t
927	5	t
927	6	t
927	8	t
928	17	t
928	20	t
928	21	t
928	22	t
928	41	t
928	42	t
928	43	t
928	45	t
928	46	t
928	9	t
928	10	t
928	11	t
928	12	t
928	13	t
928	14	t
928	15	t
928	16	t
929	41	t
929	42	t
929	43	t
929	45	t
929	46	t
929	9	t
929	10	t
929	11	t
929	12	t
929	13	t
929	14	t
929	16	t
930	53	t
930	55	t
930	56	t
930	57	t
930	2	t
930	3	t
930	4	t
930	6	t
930	7	t
930	8	t
930	60	t
930	61	t
930	62	t
930	63	t
931	29	t
931	30	t
931	31	t
931	32	t
931	33	t
931	34	t
931	47	t
931	48	t
931	49	t
931	50	t
931	51	t
931	52	t
931	36	t
931	37	t
931	38	t
931	39	t
932	23	t
932	24	t
932	25	t
932	26	t
932	27	t
932	28	t
932	29	t
932	32	t
932	33	t
932	34	t
933	31	t
933	32	t
933	33	t
933	34	t
933	1	t
933	2	t
933	3	t
933	4	t
933	5	t
933	6	t
933	7	t
933	8	t
933	54	t
933	55	t
933	56	t
933	57	t
933	58	t
934	17	t
934	18	t
934	19	t
934	20	t
934	22	t
934	29	t
934	30	t
934	31	t
934	32	t
934	34	t
935	59	t
935	60	t
935	61	t
935	62	t
935	63	t
935	64	t
935	9	t
935	10	t
935	11	t
935	12	t
935	14	t
935	15	t
935	1	t
935	7	t
935	8	t
936	17	t
936	18	t
936	47	t
936	48	t
936	49	t
936	50	t
936	51	t
936	52	t
936	29	t
936	30	t
936	31	t
936	32	t
936	33	t
936	34	t
937	36	t
937	37	t
937	38	t
937	39	t
937	40	t
937	59	t
937	60	t
937	63	t
937	64	t
938	35	t
938	36	t
938	37	t
938	38	t
938	39	t
938	40	t
938	53	t
938	54	t
938	55	t
938	56	t
938	57	t
938	58	t
939	65	t
939	67	t
939	68	t
939	69	t
939	59	t
939	61	t
939	62	t
939	63	t
940	1	t
940	2	t
940	4	t
940	5	t
940	6	t
940	7	t
940	8	t
940	9	t
940	10	t
940	12	t
940	13	t
940	14	t
940	16	t
941	47	t
941	48	t
941	49	t
941	50	t
941	51	t
941	52	t
941	65	t
941	66	t
941	67	t
941	68	t
941	69	t
941	70	t
942	36	t
942	37	t
942	39	t
942	40	t
942	65	t
942	66	t
942	67	t
942	69	t
942	70	t
943	18	t
943	19	t
943	20	t
943	21	t
943	22	t
943	47	t
943	48	t
943	50	t
943	52	t
944	47	t
944	48	t
944	49	t
944	50	t
944	51	t
944	52	t
944	65	t
944	66	t
944	68	t
944	18	t
944	19	t
944	20	t
944	21	t
944	22	t
944	29	t
944	30	t
944	31	t
944	32	t
944	33	t
944	34	t
945	29	t
945	31	t
945	32	t
945	33	t
945	34	t
945	47	t
945	49	t
945	50	t
945	51	t
945	52	t
946	29	t
946	30	t
946	31	t
946	32	t
946	33	t
946	34	t
946	1	t
946	3	t
946	4	t
946	5	t
946	6	t
946	8	t
946	47	t
946	48	t
946	49	t
946	50	t
946	51	t
946	52	t
947	55	t
947	57	t
947	58	t
947	41	t
947	44	t
947	45	t
947	46	t
947	35	t
947	36	t
947	37	t
947	38	t
947	39	t
947	40	t
947	1	t
947	2	t
947	3	t
947	4	t
947	5	t
947	6	t
947	8	t
948	17	t
948	18	t
948	19	t
948	20	t
948	22	t
948	53	t
948	54	t
948	55	t
948	42	t
948	43	t
948	44	t
948	45	t
948	46	t
949	29	t
949	31	t
949	33	t
949	34	t
950	36	t
950	37	t
950	39	t
950	40	t
950	59	t
950	60	t
950	61	t
950	63	t
950	65	t
950	68	t
950	70	t
951	41	t
951	42	t
951	45	t
951	46	t
951	36	t
951	37	t
951	39	t
951	40	t
951	1	t
951	2	t
951	3	t
951	5	t
951	6	t
951	8	t
952	35	t
952	36	t
952	37	t
952	38	t
952	39	t
952	40	t
952	1	t
952	2	t
952	4	t
952	5	t
952	6	t
952	7	t
952	8	t
953	29	t
953	30	t
953	32	t
953	34	t
953	47	t
953	48	t
953	49	t
953	50	t
953	51	t
954	41	t
954	42	t
954	44	t
954	45	t
954	17	t
954	18	t
954	19	t
954	20	t
954	21	t
954	23	t
954	24	t
954	25	t
954	26	t
954	28	t
954	47	t
954	48	t
954	50	t
954	52	t
955	2	t
955	3	t
955	4	t
955	5	t
955	6	t
955	8	t
955	65	t
955	66	t
955	67	t
955	68	t
955	69	t
955	70	t
955	9	t
955	10	t
955	12	t
955	14	t
955	15	t
955	16	t
955	53	t
955	54	t
955	56	t
956	53	t
956	54	t
956	56	t
956	57	t
956	58	t
956	47	t
956	48	t
956	49	t
956	50	t
956	51	t
956	52	t
956	23	t
956	24	t
956	25	t
956	26	t
956	27	t
956	28	t
957	45	t
958	41	t
958	42	t
958	43	t
958	45	t
958	46	t
958	23	t
958	25	t
958	26	t
958	27	t
958	28	t
958	29	t
958	30	t
958	31	t
958	32	t
959	54	t
959	55	t
959	56	t
959	58	t
959	60	t
959	61	t
959	63	t
959	1	t
959	2	t
959	4	t
959	5	t
959	6	t
959	7	t
959	8	t
960	53	t
960	54	t
960	55	t
960	56	t
960	58	t
960	10	t
960	11	t
960	12	t
960	13	t
960	14	t
960	16	t
960	41	t
960	42	t
960	43	t
960	44	t
960	45	t
960	46	t
961	29	t
961	30	t
961	31	t
961	32	t
961	33	t
961	34	t
961	53	t
961	54	t
961	55	t
961	56	t
961	57	t
961	58	t
962	18	t
962	19	t
962	20	t
962	21	t
962	22	t
962	66	t
962	67	t
962	68	t
962	69	t
962	70	t
962	23	t
962	24	t
962	25	t
962	26	t
962	27	t
962	28	t
962	53	t
962	54	t
962	55	t
962	56	t
962	57	t
962	58	t
963	9	t
963	10	t
963	11	t
963	12	t
963	13	t
963	14	t
963	15	t
963	16	t
963	41	t
963	42	t
963	43	t
963	44	t
964	60	t
964	62	t
964	63	t
964	1	t
964	2	t
964	3	t
964	4	t
964	5	t
964	7	t
964	8	t
964	65	t
964	66	t
964	67	t
964	69	t
965	9	t
965	11	t
965	12	t
965	13	t
965	14	t
965	15	t
965	16	t
966	41	t
966	43	t
966	44	t
966	45	t
966	46	t
966	3	t
966	4	t
966	5	t
966	6	t
966	7	t
966	8	t
966	59	t
966	60	t
966	62	t
966	64	t
967	54	t
967	55	t
967	56	t
967	57	t
967	58	t
967	29	t
967	30	t
967	31	t
967	32	t
967	33	t
967	34	t
968	53	t
968	54	t
968	55	t
968	56	t
968	58	t
968	35	t
968	36	t
968	37	t
968	39	t
968	23	t
968	24	t
968	26	t
968	27	t
968	28	t
969	65	t
969	67	t
969	68	t
969	70	t
969	23	t
969	24	t
969	25	t
969	27	t
969	28	t
969	1	t
969	4	t
969	5	t
969	6	t
969	8	t
970	53	t
970	54	t
970	55	t
970	56	t
970	57	t
970	58	t
970	23	t
970	24	t
970	25	t
970	26	t
970	27	t
970	35	t
970	36	t
970	37	t
970	38	t
970	39	t
970	40	t
971	35	t
971	37	t
971	39	t
971	40	t
971	41	t
971	42	t
971	43	t
971	44	t
971	45	t
972	53	t
972	55	t
972	56	t
972	57	t
972	58	t
972	11	t
972	12	t
972	13	t
972	14	t
972	15	t
972	16	t
973	1	t
973	3	t
973	4	t
973	5	t
973	6	t
973	7	t
973	8	t
973	42	t
973	43	t
973	44	t
973	45	t
973	46	t
973	23	t
973	24	t
973	25	t
973	27	t
973	28	t
974	36	t
974	37	t
974	38	t
974	39	t
974	40	t
974	9	t
974	10	t
974	12	t
974	13	t
974	14	t
974	15	t
975	42	t
975	43	t
975	44	t
975	45	t
975	46	t
975	18	t
975	19	t
975	21	t
976	9	t
976	10	t
976	11	t
976	14	t
976	15	t
976	16	t
976	29	t
976	30	t
976	31	t
976	32	t
976	33	t
976	36	t
976	37	t
976	38	t
976	39	t
976	40	t
977	65	t
977	66	t
977	67	t
977	68	t
977	69	t
977	70	t
977	35	t
977	37	t
977	39	t
977	40	t
977	29	t
977	30	t
977	32	t
977	34	t
978	36	t
978	37	t
978	39	t
978	40	t
978	53	t
978	54	t
978	55	t
978	56	t
978	57	t
978	58	t
979	41	t
979	42	t
979	43	t
979	44	t
979	46	t
979	35	t
979	36	t
979	37	t
979	38	t
979	39	t
979	47	t
979	48	t
979	49	t
979	51	t
980	41	t
980	43	t
980	44	t
980	45	t
980	46	t
980	53	t
980	54	t
980	55	t
980	56	t
980	57	t
980	58	t
981	1	t
981	2	t
981	3	t
981	4	t
981	5	t
981	6	t
981	7	t
981	8	t
981	29	t
981	32	t
981	33	t
981	34	t
981	65	t
981	66	t
981	67	t
981	68	t
981	69	t
981	70	t
982	59	t
982	60	t
982	62	t
982	63	t
982	64	t
982	41	t
982	43	t
982	44	t
982	45	t
982	46	t
983	53	t
983	54	t
983	55	t
983	56	t
983	57	t
983	58	t
983	24	t
983	25	t
983	26	t
983	28	t
984	47	t
984	48	t
984	49	t
984	50	t
984	51	t
984	23	t
984	24	t
984	25	t
985	42	t
985	44	t
985	45	t
985	65	t
985	66	t
985	67	t
985	69	t
985	70	t
986	37	t
986	39	t
986	40	t
986	47	t
986	48	t
986	49	t
986	50	t
986	51	t
986	52	t
987	35	t
987	36	t
987	38	t
987	39	t
987	40	t
987	48	t
987	49	t
987	50	t
987	51	t
987	52	t
987	65	t
987	66	t
987	68	t
987	69	t
987	70	t
988	17	t
988	18	t
988	19	t
988	20	t
988	21	t
988	22	t
989	29	t
989	30	t
989	31	t
989	33	t
989	34	t
989	47	t
989	50	t
989	51	t
989	52	t
990	35	t
990	36	t
990	37	t
990	38	t
990	39	t
990	40	t
990	53	t
990	54	t
990	57	t
990	58	t
990	9	t
990	10	t
990	11	t
990	12	t
990	13	t
990	14	t
990	16	t
991	9	t
991	10	t
991	11	t
991	12	t
991	13	t
991	15	t
991	16	t
991	17	t
991	18	t
991	19	t
991	21	t
991	22	t
992	41	t
992	42	t
992	43	t
992	46	t
992	47	t
992	48	t
992	49	t
992	50	t
992	51	t
992	52	t
992	65	t
992	69	t
992	70	t
993	59	t
993	60	t
993	62	t
993	63	t
993	64	t
993	17	t
993	18	t
993	19	t
993	20	t
993	21	t
993	22	t
994	9	t
994	10	t
994	11	t
994	12	t
994	13	t
994	14	t
994	15	t
994	16	t
994	23	t
994	25	t
994	27	t
995	23	t
995	24	t
995	25	t
995	27	t
995	29	t
995	30	t
995	31	t
995	32	t
995	33	t
995	34	t
995	53	t
995	54	t
995	55	t
995	56	t
995	57	t
996	48	t
996	49	t
996	50	t
996	52	t
996	17	t
996	18	t
996	19	t
996	20	t
996	21	t
996	22	t
996	35	t
996	36	t
996	39	t
996	40	t
997	41	t
997	42	t
997	44	t
997	45	t
997	1	t
997	2	t
997	3	t
997	4	t
997	5	t
997	6	t
997	7	t
997	54	t
997	55	t
997	56	t
997	57	t
997	58	t
997	48	t
997	49	t
997	50	t
997	51	t
997	52	t
998	53	t
998	54	t
998	55	t
998	56	t
998	57	t
999	41	t
999	43	t
999	45	t
999	46	t
999	53	t
999	54	t
999	55	t
999	58	t
999	9	t
999	10	t
999	11	t
999	12	t
999	14	t
999	15	t
999	16	t
1000	35	t
1000	36	t
1000	37	t
1000	38	t
1000	39	t
1000	40	t
1000	17	t
1000	18	t
1000	19	t
1000	20	t
1000	21	t
1000	22	t
1000	9	t
1000	10	t
1000	11	t
1000	13	t
1000	14	t
1000	15	t
1000	16	t
1001	53	t
1001	54	t
1001	56	t
1001	57	t
1001	58	t
1001	35	t
1001	36	t
1001	38	t
1001	39	t
1001	40	t
1002	35	t
1002	36	t
1002	37	t
1002	38	t
1002	39	t
1002	40	t
1002	1	t
1002	2	t
1002	3	t
1002	4	t
1002	7	t
1002	8	t
1002	23	t
1002	24	t
1002	25	t
1002	26	t
1002	27	t
1002	28	t
1003	1	t
1003	2	t
1003	3	t
1003	4	t
1003	5	t
1003	6	t
1003	7	t
1003	8	t
1003	53	t
1003	54	t
1003	56	t
1003	57	t
1003	58	t
1004	53	t
1004	54	t
1004	55	t
1004	56	t
1004	57	t
1004	58	t
1004	35	t
1004	37	t
1004	38	t
1004	39	t
1004	40	t
1005	30	t
1005	31	t
1005	32	t
1005	33	t
1005	41	t
1005	42	t
1005	43	t
1005	44	t
1005	45	t
1005	46	t
1005	9	t
1005	10	t
1005	12	t
1005	13	t
1005	14	t
1005	15	t
1005	16	t
1006	30	t
1006	31	t
1006	32	t
1006	33	t
1006	34	t
1006	23	t
1006	24	t
1006	25	t
1006	26	t
1006	27	t
1006	28	t
1007	30	t
1007	31	t
1007	32	t
1007	33	t
1007	34	t
1007	59	t
1007	61	t
1007	63	t
1007	64	t
1007	41	t
1007	42	t
1007	43	t
1007	44	t
1007	45	t
1007	46	t
1008	29	t
1008	30	t
1008	31	t
1008	32	t
1008	34	t
1008	9	t
1008	10	t
1008	11	t
1008	12	t
1008	14	t
1008	15	t
1008	16	t
1009	59	t
1009	60	t
1009	61	t
1009	64	t
1010	1	t
1010	2	t
1010	4	t
1010	5	t
1010	6	t
1010	7	t
1010	8	t
1010	60	t
1010	62	t
1010	63	t
1010	64	t
1011	53	t
1011	55	t
1011	57	t
1011	1	t
1011	2	t
1011	3	t
1011	4	t
1011	5	t
1011	7	t
1011	8	t
1011	59	t
1011	60	t
1011	61	t
1011	62	t
1011	63	t
1011	64	t
1012	29	t
1012	30	t
1012	31	t
1012	32	t
1012	34	t
1012	23	t
1012	24	t
1012	25	t
1012	26	t
1012	27	t
1012	28	t
1013	41	t
1013	42	t
1013	43	t
1013	44	t
1013	45	t
1013	46	t
1013	59	t
1013	60	t
1013	61	t
1013	62	t
1013	63	t
1014	23	t
1014	25	t
1014	26	t
1014	27	t
1014	28	t
1014	35	t
1014	37	t
1014	38	t
1014	39	t
1014	40	t
1014	65	t
1014	66	t
1014	68	t
1014	69	t
1014	59	t
1014	60	t
1014	61	t
1014	62	t
1014	63	t
1015	29	t
1015	30	t
1015	31	t
1015	32	t
1015	33	t
1015	47	t
1015	48	t
1015	49	t
1015	50	t
1015	51	t
1015	52	t
1015	42	t
1015	43	t
1015	44	t
1015	45	t
1015	46	t
1016	35	t
1016	36	t
1016	38	t
1016	40	t
1017	9	t
1017	10	t
1017	11	t
1017	12	t
1017	13	t
1017	14	t
1017	16	t
1017	41	t
1017	42	t
1017	43	t
1017	44	t
1017	46	t
1018	23	t
1018	24	t
1018	25	t
1018	26	t
1018	27	t
1018	28	t
1018	36	t
1018	37	t
1018	39	t
1019	41	t
1019	42	t
1019	43	t
1019	44	t
1019	45	t
1019	46	t
1019	23	t
1019	24	t
1019	25	t
1019	27	t
1019	28	t
1020	47	t
1020	48	t
1020	49	t
1020	50	t
1020	51	t
1020	52	t
1020	41	t
1020	42	t
1020	43	t
1020	44	t
1020	45	t
1020	46	t
1021	17	t
1021	18	t
1021	19	t
1021	21	t
1021	22	t
1021	65	t
1021	67	t
1021	68	t
1021	69	t
1021	70	t
1021	9	t
1021	10	t
1021	11	t
1021	12	t
1021	13	t
1021	14	t
1021	15	t
1021	16	t
1022	9	t
1022	10	t
1022	11	t
1022	12	t
1022	13	t
1022	14	t
1022	15	t
1023	59	t
1023	61	t
1023	62	t
1023	63	t
1023	64	t
1023	35	t
1023	36	t
1023	37	t
1023	38	t
1023	39	t
1023	40	t
1024	35	t
1024	36	t
1024	37	t
1024	38	t
1024	39	t
1024	40	t
1024	59	t
1024	60	t
1024	61	t
1024	62	t
1024	63	t
1024	47	t
1024	48	t
1024	49	t
1024	50	t
1024	51	t
1024	52	t
1024	24	t
1024	26	t
1024	27	t
1025	1	t
1025	2	t
1025	3	t
1025	5	t
1025	6	t
1025	7	t
1025	8	t
1025	17	t
1025	18	t
1025	19	t
1025	21	t
1025	22	t
\.


--
-- Data for Name: students_modules; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.students_modules (id_student, id_module, completed) FROM stdin;
26	27	f
26	6	f
27	27	f
28	35	f
29	22	f
30	19	f
31	5	f
32	8	f
33	21	f
33	22	f
33	23	f
34	32	f
34	23	f
35	23	f
37	26	f
38	3	f
38	19	f
38	20	f
39	6	f
39	7	f
41	25	f
41	5	f
41	8	f
43	17	f
43	21	f
43	8	f
45	2	f
45	3	f
45	12	f
45	13	f
45	14	f
46	29	f
47	28	f
47	11	f
49	10	f
49	15	f
49	20	f
50	35	f
51	31	f
53	7	f
53	8	f
53	13	f
54	30	f
55	9	f
56	5	f
56	8	f
56	16	f
58	12	f
58	14	f
59	30	f
59	32	f
59	13	f
59	14	f
60	23	f
61	1	f
61	24	f
64	3	f
65	8	f
65	30	f
65	31	f
66	21	f
66	22	f
67	27	f
67	28	f
68	17	f
68	29	f
69	25	f
70	29	f
71	7	f
73	19	f
73	20	f
73	30	f
75	12	f
75	14	f
75	19	f
78	19	f
78	30	f
78	32	f
79	17	f
80	28	f
80	29	f
85	31	f
85	27	f
86	33	f
86	15	f
87	21	f
87	22	f
87	27	f
87	12	f
87	13	f
88	27	f
88	29	f
90	29	f
90	15	f
90	16	f
90	17	f
91	15	f
92	11	f
93	8	f
94	8	f
94	18	f
96	5	f
96	8	f
97	15	f
97	12	f
97	28	f
98	8	f
98	21	f
98	22	f
99	24	f
99	25	f
100	18	f
100	20	f
100	14	f
102	30	f
102	32	f
103	24	f
104	22	f
104	5	f
104	6	f
105	26	f
106	18	f
107	7	f
107	8	f
108	10	f
108	20	f
109	5	f
113	3	f
114	19	f
114	17	f
115	33	f
115	30	f
116	10	f
117	24	f
118	17	f
120	30	f
120	10	f
120	35	f
120	19	f
121	23	f
121	2	f
121	3	f
123	12	f
124	15	f
126	22	f
126	25	f
127	21	f
128	31	f
128	34	f
129	25	f
129	15	f
130	2	f
130	25	f
131	2	f
132	26	f
133	33	f
133	5	f
133	14	f
134	34	f
134	35	f
134	5	f
134	8	f
134	15	f
135	20	f
136	22	f
136	34	f
137	23	f
138	31	f
138	11	f
143	17	f
145	34	f
145	35	f
145	13	f
145	22	f
146	11	f
147	17	f
149	10	f
150	31	f
151	22	f
151	20	f
151	25	f
152	19	f
152	25	f
153	10	f
155	7	f
156	13	f
156	14	f
157	24	f
158	9	f
158	11	f
158	20	f
158	7	f
159	21	f
159	23	f
159	33	f
161	2	f
161	4	f
162	32	f
163	35	f
164	5	f
164	32	f
165	13	f
165	15	f
166	24	f
166	29	f
169	30	f
169	33	f
170	4	f
172	14	f
172	21	f
173	28	f
174	5	f
175	30	f
176	27	f
176	15	f
176	17	f
177	7	f
177	4	f
178	24	f
178	26	f
178	6	f
178	8	f
179	23	f
179	10	f
180	24	f
181	35	f
182	5	f
183	2	f
183	3	f
184	30	f
184	35	f
185	6	f
186	8	f
186	17	f
186	22	f
187	23	f
188	24	f
188	28	f
189	33	f
189	34	f
189	35	f
189	20	f
191	27	f
191	21	f
192	27	f
193	13	f
194	33	f
194	10	f
195	28	f
195	15	f
195	13	f
196	32	f
197	30	f
198	21	f
199	3	f
199	4	f
199	27	f
199	28	f
201	4	f
201	16	f
204	16	f
205	24	f
205	25	f
206	6	f
208	27	f
210	5	f
211	1	f
212	25	f
212	20	f
214	23	f
214	6	f
214	8	f
214	13	f
215	12	f
215	5	f
215	6	f
215	7	f
216	7	f
216	27	f
217	9	f
217	10	f
217	29	f
218	4	f
219	18	f
220	24	f
220	25	f
220	2	f
221	20	f
221	5	f
221	33	f
221	35	f
222	3	f
223	26	f
224	8	f
224	1	f
224	3	f
224	4	f
225	28	f
225	29	f
225	19	f
226	29	f
226	12	f
227	12	f
227	13	f
228	11	f
228	30	f
229	21	f
229	23	f
230	5	f
230	1	f
230	2	f
231	8	f
232	1	f
233	8	f
233	3	f
233	4	f
234	16	f
234	6	f
234	9	f
237	27	f
237	28	f
237	24	f
237	34	f
238	10	f
239	19	f
239	2	f
239	3	f
242	5	f
242	8	f
242	23	f
243	6	f
243	8	f
243	2	f
244	24	f
245	2	f
245	4	f
245	33	f
246	18	f
247	19	f
248	13	f
249	21	f
249	30	f
250	1	f
250	4	f
251	16	f
252	19	f
253	9	f
253	10	f
253	5	f
254	24	f
254	9	f
254	15	f
255	33	f
258	26	f
261	21	f
262	33	f
262	35	f
262	5	f
262	8	f
262	22	f
263	12	f
263	14	f
264	17	f
264	19	f
265	4	f
265	32	f
267	29	f
269	3	f
269	21	f
269	24	f
269	25	f
269	26	f
270	34	f
271	12	f
271	14	f
273	5	f
273	6	f
274	19	f
274	20	f
274	28	f
274	29	f
275	9	f
275	10	f
275	25	f
275	5	f
275	8	f
276	21	f
276	30	f
276	31	f
276	32	f
276	33	f
277	12	f
277	20	f
278	22	f
278	23	f
278	17	f
279	6	f
279	21	f
280	17	f
280	33	f
281	20	f
282	34	f
283	26	f
285	31	f
286	16	f
286	31	f
287	16	f
288	6	f
288	8	f
288	15	f
288	28	f
288	29	f
288	21	f
290	20	f
290	25	f
291	16	f
292	5	f
292	8	f
292	18	f
292	34	f
292	35	f
294	6	f
295	18	f
295	20	f
296	12	f
297	22	f
301	16	f
301	10	f
301	11	f
303	11	f
303	13	f
303	14	f
303	30	f
303	32	f
304	35	f
304	7	f
304	23	f
307	29	f
308	21	f
309	27	f
310	26	f
310	3	f
310	5	f
310	8	f
311	18	f
311	16	f
313	12	f
313	32	f
315	10	f
316	20	f
317	1	f
318	18	f
318	33	f
318	35	f
319	35	f
319	29	f
320	3	f
321	14	f
321	33	f
321	35	f
321	26	f
323	24	f
323	26	f
324	32	f
325	18	f
326	18	f
327	10	f
327	14	f
329	24	f
333	12	f
333	9	f
333	31	f
334	6	f
335	5	f
336	19	f
337	12	f
338	23	f
339	34	f
340	1	f
341	20	f
341	24	f
341	22	f
341	3	f
343	21	f
344	3	f
345	10	f
345	11	f
346	20	f
346	28	f
347	9	f
347	17	f
348	21	f
348	22	f
348	20	f
349	13	f
349	14	f
350	17	f
350	22	f
350	1	f
350	3	f
351	16	f
352	24	f
353	4	f
353	27	f
353	28	f
354	6	f
354	24	f
354	25	f
354	27	f
356	4	f
357	30	f
357	6	f
358	15	f
359	25	f
361	21	f
361	30	f
361	32	f
362	6	f
362	8	f
362	1	f
362	2	f
362	3	f
363	24	f
363	34	f
364	1	f
364	32	f
365	34	f
365	27	f
365	28	f
367	30	f
367	31	f
367	14	f
368	21	f
368	22	f
369	22	f
369	23	f
370	2	f
371	28	f
371	12	f
371	13	f
372	2	f
373	3	f
373	30	f
373	31	f
374	17	f
375	1	f
375	5	f
376	30	f
376	32	f
377	25	f
377	26	f
378	24	f
378	19	f
378	31	f
379	34	f
380	2	f
380	3	f
381	20	f
381	27	f
381	29	f
382	10	f
382	12	f
383	3	f
384	21	f
384	26	f
385	19	f
386	15	f
386	16	f
386	17	f
386	3	f
387	26	f
388	22	f
389	23	f
389	24	f
390	21	f
391	31	f
392	25	f
392	26	f
392	14	f
394	25	f
394	15	f
394	16	f
394	22	f
394	23	f
397	32	f
398	9	f
398	11	f
399	19	f
399	3	f
399	4	f
400	20	f
401	32	f
404	31	f
405	27	f
405	7	f
406	33	f
406	34	f
406	9	f
406	10	f
407	33	f
408	31	f
408	28	f
409	9	f
409	22	f
409	23	f
409	16	f
411	35	f
411	15	f
412	35	f
412	16	f
413	14	f
414	28	f
414	4	f
415	28	f
415	1	f
415	34	f
416	34	f
416	13	f
416	6	f
419	27	f
419	9	f
420	3	f
420	22	f
421	17	f
423	34	f
424	34	f
424	35	f
424	30	f
425	35	f
425	15	f
425	17	f
426	9	f
426	10	f
427	31	f
427	24	f
428	7	f
430	27	f
431	32	f
431	15	f
431	16	f
431	17	f
432	10	f
433	16	f
437	34	f
438	34	f
438	8	f
439	12	f
439	13	f
439	25	f
440	5	f
440	8	f
440	27	f
440	28	f
441	9	f
441	10	f
441	11	f
442	5	f
443	5	f
443	8	f
444	29	f
446	8	f
446	20	f
448	16	f
448	34	f
449	16	f
449	17	f
450	15	f
450	29	f
451	28	f
451	6	f
452	22	f
452	31	f
452	5	f
452	7	f
453	9	f
453	24	f
453	26	f
453	28	f
454	33	f
454	34	f
455	28	f
455	33	f
456	17	f
456	25	f
457	25	f
457	26	f
457	27	f
457	10	f
458	25	f
459	8	f
459	3	f
459	16	f
460	24	f
461	33	f
462	14	f
463	18	f
463	20	f
464	8	f
464	21	f
464	34	f
464	35	f
465	2	f
466	25	f
466	26	f
467	6	f
467	7	f
467	8	f
468	27	f
468	10	f
469	19	f
472	4	f
472	10	f
473	33	f
473	34	f
475	3	f
477	26	f
477	11	f
478	15	f
478	17	f
479	22	f
482	16	f
483	26	f
484	24	f
484	26	f
485	16	f
486	20	f
486	12	f
487	1	f
487	4	f
488	21	f
489	20	f
489	7	f
490	32	f
490	20	f
491	30	f
491	18	f
491	4	f
493	31	f
494	15	f
495	1	f
496	1	f
496	2	f
497	9	f
497	21	f
498	21	f
499	1	f
499	2	f
501	16	f
501	21	f
501	20	f
501	35	f
502	22	f
502	15	f
502	17	f
502	19	f
503	27	f
503	4	f
504	12	f
504	13	f
504	14	f
504	30	f
505	13	f
506	22	f
507	15	f
507	17	f
508	19	f
509	4	f
510	29	f
510	17	f
511	15	f
512	19	f
512	25	f
512	26	f
513	29	f
514	30	f
514	24	f
515	20	f
515	7	f
516	26	f
516	27	f
516	17	f
518	32	f
518	25	f
519	25	f
519	27	f
520	27	f
520	28	f
521	10	f
521	13	f
521	34	f
522	16	f
523	29	f
524	7	f
525	22	f
525	17	f
526	19	f
526	27	f
527	19	f
527	25	f
527	21	f
528	5	f
528	8	f
528	25	f
529	6	f
529	7	f
531	26	f
531	31	f
531	32	f
531	20	f
533	24	f
533	25	f
533	9	f
533	11	f
533	16	f
534	2	f
534	35	f
536	23	f
537	10	f
537	22	f
538	20	f
539	29	f
540	35	f
542	9	f
543	27	f
543	17	f
545	7	f
545	34	f
546	29	f
549	14	f
550	11	f
550	21	f
550	15	f
551	32	f
551	10	f
553	4	f
553	24	f
553	26	f
555	14	f
556	27	f
556	28	f
556	29	f
558	2	f
558	3	f
559	12	f
559	18	f
560	25	f
561	29	f
562	19	f
562	5	f
562	6	f
562	32	f
563	24	f
563	25	f
563	5	f
568	34	f
568	35	f
568	8	f
569	8	f
570	10	f
570	11	f
571	14	f
571	31	f
572	22	f
573	6	f
573	7	f
573	25	f
573	12	f
573	13	f
573	27	f
573	29	f
574	13	f
574	14	f
575	29	f
576	14	f
576	19	f
578	28	f
578	19	f
579	25	f
579	1	f
580	21	f
581	34	f
581	35	f
582	34	f
583	20	f
583	13	f
584	25	f
584	26	f
584	33	f
586	1	f
587	22	f
587	18	f
588	18	f
588	19	f
589	27	f
589	28	f
590	33	f
590	34	f
591	23	f
591	17	f
592	10	f
593	20	f
593	5	f
593	6	f
595	17	f
595	33	f
595	13	f
596	6	f
597	2	f
599	7	f
599	3	f
599	4	f
601	21	f
601	22	f
602	18	f
602	10	f
603	25	f
603	26	f
604	22	f
604	10	f
605	19	f
606	27	f
607	30	f
609	28	f
609	34	f
610	5	f
610	8	f
610	30	f
611	5	f
613	5	f
613	13	f
614	33	f
614	34	f
614	35	f
615	15	f
615	16	f
615	5	f
615	6	f
615	7	f
617	19	f
618	1	f
618	3	f
618	13	f
619	21	f
622	24	f
623	35	f
624	23	f
625	3	f
626	16	f
627	26	f
628	22	f
628	8	f
629	19	f
629	31	f
630	1	f
630	2	f
630	5	f
632	26	f
632	10	f
634	34	f
635	11	f
636	1	f
637	29	f
638	19	f
639	25	f
639	26	f
643	21	f
643	22	f
644	13	f
644	14	f
645	9	f
646	22	f
647	1	f
647	10	f
647	32	f
649	30	f
649	9	f
649	10	f
649	11	f
651	31	f
651	32	f
651	1	f
651	2	f
653	14	f
656	21	f
657	26	f
659	26	f
659	3	f
660	3	f
662	27	f
663	7	f
663	2	f
664	24	f
664	26	f
664	31	f
664	4	f
665	9	f
666	17	f
666	9	f
666	11	f
666	34	f
669	22	f
669	23	f
670	7	f
672	13	f
673	7	f
673	8	f
673	28	f
675	32	f
675	15	f
676	20	f
677	4	f
677	11	f
678	15	f
678	28	f
678	31	f
678	32	f
679	17	f
680	9	f
681	2	f
681	3	f
681	4	f
681	7	f
682	27	f
682	28	f
682	24	f
683	20	f
683	22	f
683	23	f
684	25	f
684	26	f
685	4	f
686	22	f
687	14	f
687	16	f
688	35	f
689	29	f
689	19	f
690	3	f
690	5	f
690	6	f
691	4	f
691	21	f
691	5	f
692	30	f
692	31	f
693	33	f
693	35	f
693	30	f
693	18	f
693	20	f
694	24	f
694	30	f
694	32	f
695	12	f
695	9	f
696	4	f
696	15	f
697	9	f
697	22	f
698	30	f
699	9	f
699	11	f
699	17	f
700	30	f
700	10	f
701	11	f
701	25	f
702	12	f
702	31	f
703	17	f
703	12	f
703	21	f
704	11	f
705	21	f
707	7	f
707	24	f
707	9	f
707	11	f
708	24	f
708	34	f
709	12	f
710	34	f
710	21	f
711	5	f
712	5	f
713	15	f
713	18	f
714	31	f
714	14	f
717	7	f
717	8	f
718	15	f
718	10	f
719	17	f
720	16	f
721	32	f
721	22	f
722	21	f
722	16	f
723	5	f
725	17	f
726	1	f
727	5	f
727	7	f
727	8	f
728	2	f
732	25	f
733	12	f
733	13	f
733	15	f
733	11	f
733	31	f
735	24	f
736	11	f
737	32	f
737	26	f
738	2	f
738	14	f
742	8	f
743	22	f
744	28	f
745	28	f
745	26	f
746	20	f
747	4	f
748	10	f
748	11	f
748	22	f
749	32	f
750	15	f
750	21	f
750	34	f
751	12	f
752	14	f
752	34	f
753	28	f
753	2	f
754	3	f
754	28	f
754	18	f
756	27	f
756	28	f
756	11	f
757	9	f
757	3	f
758	22	f
758	28	f
760	33	f
761	3	f
763	10	f
763	26	f
764	12	f
764	30	f
764	32	f
766	24	f
767	29	f
768	10	f
768	11	f
768	3	f
769	2	f
769	6	f
769	8	f
770	6	f
770	28	f
770	29	f
770	12	f
771	7	f
771	20	f
771	22	f
772	7	f
772	31	f
773	24	f
773	25	f
773	4	f
774	3	f
776	33	f
776	23	f
777	13	f
777	20	f
778	35	f
779	1	f
780	29	f
780	26	f
780	7	f
780	8	f
781	28	f
781	24	f
781	25	f
782	10	f
783	30	f
783	3	f
784	16	f
784	13	f
785	15	f
786	28	f
786	1	f
786	4	f
787	31	f
787	26	f
788	6	f
788	7	f
789	10	f
789	31	f
790	27	f
790	28	f
793	21	f
793	23	f
793	9	f
794	7	f
797	19	f
797	31	f
800	30	f
800	8	f
800	21	f
800	9	f
800	10	f
801	32	f
802	31	f
802	9	f
803	13	f
804	12	f
805	28	f
805	29	f
805	10	f
806	31	f
806	2	f
806	3	f
807	9	f
807	11	f
809	25	f
810	26	f
810	18	f
810	20	f
813	2	f
813	4	f
814	18	f
814	19	f
815	28	f
816	33	f
817	9	f
817	11	f
817	17	f
819	13	f
819	8	f
820	3	f
821	27	f
822	35	f
824	29	f
824	31	f
825	18	f
825	13	f
827	2	f
827	3	f
827	5	f
827	7	f
828	31	f
829	33	f
829	34	f
829	14	f
829	9	f
829	24	f
831	27	f
832	19	f
832	13	f
832	4	f
833	35	f
834	1	f
836	11	f
836	15	f
837	34	f
837	12	f
837	13	f
838	10	f
839	11	f
840	19	f
841	2	f
842	35	f
842	22	f
843	29	f
844	26	f
844	7	f
845	34	f
846	7	f
848	14	f
848	23	f
849	31	f
849	32	f
850	17	f
850	18	f
850	23	f
850	28	f
850	29	f
851	15	f
852	17	f
853	33	f
853	35	f
853	16	f
855	11	f
855	1	f
855	4	f
856	35	f
856	7	f
857	21	f
857	5	f
857	25	f
858	34	f
858	7	f
858	8	f
859	26	f
860	10	f
860	11	f
860	2	f
860	4	f
861	21	f
863	31	f
863	32	f
863	21	f
864	30	f
864	32	f
864	5	f
864	7	f
865	24	f
865	26	f
866	17	f
866	28	f
866	8	f
868	19	f
869	31	f
869	13	f
870	26	f
872	16	f
873	30	f
873	31	f
873	17	f
873	35	f
874	9	f
876	28	f
876	29	f
878	3	f
881	13	f
881	14	f
881	34	f
882	22	f
882	34	f
882	35	f
882	1	f
883	19	f
884	34	f
886	14	f
886	21	f
887	20	f
887	25	f
889	7	f
889	8	f
891	20	f
892	21	f
893	27	f
894	16	f
894	3	f
895	3	f
896	14	f
897	22	f
897	23	f
898	15	f
898	17	f
899	8	f
899	20	f
900	15	f
900	16	f
901	6	f
901	12	f
901	24	f
901	25	f
903	31	f
903	32	f
903	19	f
905	19	f
905	21	f
905	25	f
906	19	f
906	1	f
906	9	f
908	3	f
908	4	f
909	8	f
909	21	f
909	22	f
911	5	f
912	12	f
912	16	f
914	25	f
914	26	f
914	21	f
914	23	f
914	18	f
915	13	f
915	14	f
916	17	f
918	20	f
918	24	f
918	26	f
919	33	f
921	25	f
921	7	f
922	9	f
922	24	f
923	35	f
924	1	f
924	24	f
924	25	f
925	11	f
925	24	f
926	20	f
926	34	f
926	15	f
927	3	f
928	9	f
928	23	f
928	7	f
929	21	f
929	5	f
930	28	f
932	14	f
932	15	f
933	4	f
934	9	f
934	17	f
936	9	f
936	10	f
936	26	f
936	16	f
936	17	f
937	20	f
937	30	f
938	18	f
938	20	f
938	27	f
939	32	f
940	2	f
940	7	f
941	25	f
941	26	f
941	34	f
942	20	f
942	34	f
943	11	f
943	25	f
944	26	f
944	34	f
944	16	f
945	16	f
945	26	f
946	1	f
946	24	f
947	18	f
947	1	f
952	19	f
952	20	f
953	26	f
954	9	f
955	33	f
955	27	f
956	27	f
956	24	f
956	13	f
958	13	f
958	17	f
959	27	f
959	2	f
959	4	f
961	28	f
962	35	f
962	29	f
963	6	f
963	21	f
966	21	f
966	2	f
967	27	f
967	28	f
967	15	f
967	16	f
968	12	f
968	14	f
969	1	f
969	4	f
970	12	f
970	13	f
971	20	f
971	22	f
971	23	f
972	7	f
973	3	f
973	22	f
973	14	f
975	22	f
975	11	f
976	15	f
976	18	f
976	20	f
977	19	f
977	15	f
978	19	f
978	28	f
979	18	f
979	25	f
980	23	f
981	2	f
981	16	f
982	22	f
983	27	f
983	12	f
985	33	f
986	19	f
991	5	f
991	10	f
992	24	f
992	25	f
993	30	f
993	10	f
994	5	f
994	13	f
995	12	f
996	19	f
997	1	f
997	2	f
997	28	f
997	24	f
999	22	f
999	8	f
1001	29	f
1002	19	f
1002	2	f
1002	4	f
1003	1	f
1003	2	f
1004	28	f
1005	5	f
1005	6	f
1006	15	f
1006	14	f
1008	8	f
1009	31	f
1010	3	f
1011	28	f
1011	3	f
1011	32	f
1012	16	f
1012	17	f
1012	13	f
1012	14	f
1013	21	f
1013	32	f
1014	12	f
1014	14	f
1014	32	f
1015	25	f
1016	19	f
1017	8	f
1017	23	f
1019	22	f
1019	23	f
1019	12	f
1019	14	f
1020	23	f
1021	5	f
1021	6	f
1021	8	f
1022	5	f
1023	18	f
1024	18	f
1024	32	f
1024	24	f
1024	13	f
26	18	t
26	19	t
26	20	t
26	28	t
26	29	t
26	24	t
26	25	t
26	26	t
26	5	t
26	7	t
26	8	t
27	28	t
27	29	t
27	33	t
27	34	t
27	35	t
28	12	t
28	13	t
28	14	t
28	33	t
28	34	t
29	9	t
29	10	t
29	11	t
29	21	t
29	23	t
30	18	t
30	20	t
30	30	t
30	31	t
30	32	t
30	15	t
30	16	t
30	17	t
31	6	t
31	7	t
31	8	t
31	24	t
31	25	t
31	26	t
32	5	t
32	6	t
32	7	t
32	18	t
32	19	t
32	20	t
34	30	t
34	31	t
34	21	t
34	22	t
35	15	t
35	16	t
35	17	t
35	21	t
35	22	t
36	24	t
36	25	t
36	26	t
36	12	t
36	13	t
36	14	t
37	12	t
37	13	t
37	14	t
37	15	t
37	16	t
37	17	t
37	24	t
37	25	t
38	1	t
38	2	t
38	4	t
38	18	t
38	9	t
38	10	t
38	11	t
39	18	t
39	19	t
39	20	t
39	30	t
39	31	t
39	32	t
39	5	t
39	8	t
40	1	t
40	2	t
40	3	t
40	4	t
40	9	t
40	10	t
40	11	t
41	24	t
41	26	t
41	6	t
41	7	t
41	1	t
41	2	t
41	3	t
41	4	t
42	5	t
42	6	t
42	7	t
42	8	t
43	15	t
43	16	t
43	22	t
43	23	t
43	5	t
43	6	t
43	7	t
44	21	t
44	22	t
44	23	t
44	27	t
44	28	t
44	29	t
44	1	t
44	2	t
44	3	t
44	4	t
45	1	t
45	4	t
45	24	t
45	25	t
45	26	t
46	12	t
46	13	t
46	14	t
46	27	t
46	28	t
47	30	t
47	31	t
47	32	t
47	27	t
47	29	t
47	9	t
47	10	t
48	24	t
48	25	t
48	26	t
48	33	t
48	34	t
48	35	t
49	9	t
49	11	t
49	16	t
49	17	t
49	18	t
49	19	t
50	33	t
50	34	t
50	9	t
50	10	t
50	11	t
51	9	t
51	10	t
51	11	t
51	30	t
51	32	t
52	1	t
52	2	t
52	3	t
52	4	t
53	5	t
53	6	t
53	12	t
53	14	t
54	31	t
54	32	t
54	12	t
54	13	t
54	14	t
55	10	t
55	11	t
55	27	t
55	28	t
55	29	t
55	33	t
55	34	t
55	35	t
56	6	t
56	7	t
56	15	t
56	17	t
56	21	t
56	22	t
56	23	t
57	24	t
57	25	t
57	26	t
58	30	t
58	31	t
58	32	t
58	13	t
58	5	t
58	6	t
58	7	t
58	8	t
59	31	t
59	12	t
59	24	t
59	25	t
59	26	t
59	21	t
59	22	t
59	23	t
60	12	t
60	13	t
60	14	t
60	21	t
60	22	t
61	2	t
61	3	t
61	4	t
61	25	t
61	26	t
62	30	t
62	31	t
62	32	t
62	1	t
62	2	t
62	3	t
62	4	t
63	15	t
63	16	t
63	17	t
63	9	t
63	10	t
63	11	t
64	24	t
64	25	t
64	26	t
64	1	t
64	2	t
64	4	t
65	5	t
65	6	t
65	7	t
65	32	t
66	23	t
67	29	t
67	33	t
67	34	t
67	35	t
67	1	t
67	2	t
67	3	t
67	4	t
68	1	t
68	2	t
68	3	t
68	4	t
68	15	t
68	16	t
68	27	t
68	28	t
69	21	t
69	22	t
69	23	t
69	24	t
69	26	t
69	12	t
69	13	t
69	14	t
70	33	t
70	34	t
70	35	t
70	27	t
70	28	t
71	15	t
71	16	t
71	17	t
71	24	t
71	25	t
71	26	t
71	5	t
71	6	t
71	8	t
72	30	t
72	31	t
72	32	t
73	18	t
73	31	t
73	32	t
74	5	t
74	6	t
74	7	t
74	8	t
74	21	t
74	22	t
74	23	t
74	12	t
74	13	t
74	14	t
75	13	t
75	30	t
75	31	t
75	32	t
75	18	t
75	20	t
76	12	t
76	13	t
76	14	t
76	18	t
76	19	t
76	20	t
77	18	t
77	19	t
77	20	t
77	27	t
77	28	t
77	29	t
77	9	t
77	10	t
77	11	t
78	18	t
78	20	t
78	31	t
79	21	t
79	22	t
79	23	t
79	12	t
79	13	t
79	14	t
79	15	t
79	16	t
80	21	t
80	22	t
80	23	t
80	27	t
80	5	t
80	6	t
80	7	t
80	8	t
80	9	t
80	10	t
80	11	t
81	1	t
81	2	t
81	3	t
81	4	t
81	30	t
81	31	t
81	32	t
81	15	t
81	16	t
81	17	t
82	33	t
82	34	t
82	35	t
82	9	t
82	10	t
82	11	t
83	15	t
83	16	t
83	17	t
83	12	t
83	13	t
83	14	t
84	24	t
84	25	t
84	26	t
85	30	t
85	32	t
85	28	t
85	29	t
85	21	t
85	22	t
85	23	t
85	33	t
85	34	t
85	35	t
86	27	t
86	28	t
86	29	t
86	34	t
86	35	t
86	16	t
86	17	t
87	23	t
87	28	t
87	29	t
87	14	t
88	28	t
88	18	t
88	19	t
88	20	t
89	18	t
89	19	t
89	20	t
89	15	t
89	16	t
89	17	t
90	33	t
90	34	t
90	35	t
90	27	t
90	28	t
91	16	t
91	17	t
91	27	t
91	28	t
91	29	t
91	30	t
91	31	t
91	32	t
91	24	t
91	25	t
91	26	t
92	9	t
92	10	t
93	12	t
93	13	t
93	14	t
93	5	t
93	6	t
93	7	t
94	33	t
94	34	t
94	35	t
94	5	t
94	6	t
94	7	t
94	19	t
94	20	t
95	24	t
95	25	t
95	26	t
95	15	t
95	16	t
95	17	t
96	6	t
96	7	t
96	15	t
96	16	t
96	17	t
97	16	t
97	17	t
97	13	t
97	14	t
97	27	t
97	29	t
98	33	t
98	34	t
98	35	t
98	5	t
98	6	t
98	7	t
98	23	t
99	21	t
99	22	t
99	23	t
99	26	t
99	15	t
99	16	t
99	17	t
100	19	t
100	12	t
100	13	t
100	9	t
100	10	t
100	11	t
101	1	t
101	2	t
101	3	t
101	4	t
101	12	t
101	13	t
101	14	t
101	9	t
101	10	t
101	11	t
102	31	t
103	18	t
103	19	t
103	20	t
103	25	t
103	26	t
104	30	t
104	31	t
104	32	t
104	21	t
104	23	t
104	7	t
104	8	t
105	24	t
105	25	t
106	30	t
106	31	t
106	32	t
106	19	t
106	20	t
106	15	t
106	16	t
106	17	t
107	24	t
107	25	t
107	26	t
107	18	t
107	19	t
107	20	t
107	33	t
107	34	t
107	35	t
107	5	t
107	6	t
108	9	t
108	11	t
108	24	t
108	25	t
108	26	t
108	18	t
108	19	t
109	1	t
109	2	t
109	3	t
109	4	t
109	6	t
109	7	t
109	8	t
110	30	t
110	31	t
110	32	t
110	15	t
110	16	t
110	17	t
111	12	t
111	13	t
111	14	t
111	27	t
111	28	t
111	29	t
112	33	t
112	34	t
112	35	t
112	18	t
112	19	t
112	20	t
113	15	t
113	16	t
113	17	t
113	1	t
113	2	t
113	4	t
113	5	t
113	6	t
113	7	t
113	8	t
114	18	t
114	20	t
114	15	t
114	16	t
115	34	t
115	35	t
115	31	t
115	32	t
115	1	t
115	2	t
115	3	t
115	4	t
116	9	t
116	11	t
116	5	t
116	6	t
116	7	t
116	8	t
116	18	t
116	19	t
116	20	t
117	21	t
117	22	t
117	23	t
117	25	t
117	26	t
118	27	t
118	28	t
118	29	t
118	33	t
118	34	t
118	35	t
118	15	t
118	16	t
119	27	t
119	28	t
119	29	t
119	21	t
119	22	t
119	23	t
120	31	t
120	32	t
120	9	t
120	11	t
120	33	t
120	34	t
120	18	t
120	20	t
121	21	t
121	22	t
121	1	t
121	4	t
121	12	t
121	13	t
121	14	t
121	24	t
121	25	t
121	26	t
122	1	t
122	2	t
122	3	t
122	4	t
122	30	t
122	31	t
122	32	t
123	21	t
123	22	t
123	23	t
123	27	t
123	28	t
123	29	t
123	13	t
123	14	t
124	16	t
124	17	t
124	5	t
124	6	t
124	7	t
124	8	t
124	1	t
124	2	t
124	3	t
124	4	t
124	27	t
124	28	t
124	29	t
125	15	t
125	16	t
125	17	t
125	21	t
125	22	t
125	23	t
126	21	t
126	23	t
126	5	t
126	6	t
126	7	t
126	8	t
126	24	t
126	26	t
127	22	t
127	23	t
127	12	t
127	13	t
127	14	t
127	1	t
127	2	t
127	3	t
127	4	t
128	30	t
128	32	t
128	33	t
128	35	t
129	27	t
129	28	t
129	29	t
129	24	t
129	26	t
129	16	t
129	17	t
130	1	t
130	3	t
130	4	t
130	24	t
130	26	t
131	27	t
131	28	t
131	29	t
131	1	t
131	3	t
131	4	t
131	9	t
131	10	t
131	11	t
132	1	t
132	2	t
132	3	t
132	4	t
132	24	t
132	25	t
133	34	t
133	35	t
133	6	t
133	7	t
133	8	t
133	12	t
133	13	t
134	33	t
134	6	t
134	7	t
134	16	t
134	17	t
135	33	t
135	34	t
135	35	t
135	18	t
135	19	t
136	24	t
136	25	t
136	26	t
136	21	t
136	23	t
136	33	t
136	35	t
137	30	t
137	31	t
137	32	t
137	21	t
137	22	t
138	30	t
138	32	t
138	9	t
138	10	t
138	5	t
138	6	t
138	7	t
138	8	t
139	30	t
139	31	t
139	32	t
140	30	t
140	31	t
140	32	t
140	27	t
140	28	t
140	29	t
140	12	t
140	13	t
140	14	t
141	12	t
141	13	t
141	14	t
141	27	t
141	28	t
141	29	t
142	5	t
142	6	t
142	7	t
142	8	t
142	24	t
142	25	t
142	26	t
143	15	t
143	16	t
143	9	t
143	10	t
143	11	t
144	1	t
144	2	t
144	3	t
144	4	t
144	21	t
144	22	t
144	23	t
145	33	t
145	12	t
145	14	t
145	21	t
145	23	t
146	9	t
146	10	t
147	18	t
147	19	t
147	20	t
147	12	t
147	13	t
147	14	t
147	15	t
147	16	t
148	5	t
148	6	t
148	7	t
148	8	t
148	30	t
148	31	t
148	32	t
148	21	t
148	22	t
148	23	t
148	15	t
148	16	t
148	17	t
149	12	t
149	13	t
149	14	t
149	24	t
149	25	t
149	26	t
149	30	t
149	31	t
149	32	t
149	9	t
149	11	t
150	30	t
150	32	t
151	21	t
151	23	t
151	18	t
151	19	t
151	24	t
151	26	t
152	18	t
152	20	t
152	24	t
152	26	t
153	9	t
153	11	t
153	12	t
153	13	t
153	14	t
154	18	t
154	19	t
154	20	t
154	1	t
154	2	t
154	3	t
154	4	t
154	30	t
154	31	t
154	32	t
155	5	t
155	6	t
155	8	t
155	1	t
155	2	t
155	3	t
155	4	t
155	30	t
155	31	t
155	32	t
155	21	t
155	22	t
155	23	t
156	30	t
156	31	t
156	32	t
156	12	t
157	30	t
157	31	t
157	32	t
157	25	t
157	26	t
157	12	t
157	13	t
157	14	t
158	10	t
158	18	t
158	19	t
158	5	t
158	6	t
158	8	t
158	12	t
158	13	t
158	14	t
159	27	t
159	28	t
159	29	t
159	22	t
159	34	t
159	35	t
159	30	t
159	31	t
159	32	t
160	5	t
160	6	t
160	7	t
160	8	t
160	15	t
160	16	t
160	17	t
160	30	t
160	31	t
160	32	t
161	5	t
161	6	t
161	7	t
161	8	t
161	1	t
161	3	t
162	30	t
162	31	t
163	12	t
163	13	t
163	14	t
163	33	t
163	34	t
163	24	t
163	25	t
163	26	t
164	6	t
164	7	t
164	8	t
164	30	t
164	31	t
164	24	t
164	25	t
164	26	t
164	12	t
164	13	t
164	14	t
165	12	t
165	14	t
165	16	t
165	17	t
166	25	t
166	26	t
166	27	t
166	28	t
166	33	t
166	34	t
166	35	t
167	12	t
167	13	t
167	14	t
167	24	t
167	25	t
167	26	t
167	18	t
167	19	t
167	20	t
168	9	t
168	10	t
168	11	t
168	1	t
168	2	t
168	3	t
168	4	t
169	31	t
169	32	t
169	34	t
169	35	t
170	18	t
170	19	t
170	20	t
170	1	t
170	2	t
170	3	t
171	12	t
171	13	t
171	14	t
171	1	t
171	2	t
171	3	t
171	4	t
172	27	t
172	28	t
172	29	t
172	12	t
172	13	t
172	22	t
172	23	t
173	30	t
173	31	t
173	32	t
173	27	t
173	29	t
173	18	t
173	19	t
173	20	t
174	6	t
174	7	t
174	8	t
174	15	t
174	16	t
174	17	t
174	1	t
174	2	t
174	3	t
174	4	t
175	33	t
175	34	t
175	35	t
175	1	t
175	2	t
175	3	t
175	4	t
175	31	t
175	32	t
176	9	t
176	10	t
176	11	t
176	28	t
176	29	t
176	16	t
177	5	t
177	6	t
177	8	t
177	1	t
177	2	t
177	3	t
178	25	t
178	5	t
178	7	t
179	21	t
179	22	t
179	9	t
179	11	t
180	25	t
180	26	t
180	30	t
180	31	t
180	32	t
180	15	t
180	16	t
180	17	t
181	24	t
181	25	t
181	26	t
181	33	t
181	34	t
182	6	t
182	7	t
182	8	t
182	18	t
182	19	t
182	20	t
183	9	t
183	10	t
183	11	t
183	1	t
183	4	t
184	31	t
184	32	t
184	33	t
184	34	t
184	21	t
184	22	t
184	23	t
185	9	t
185	10	t
185	11	t
185	5	t
185	7	t
185	8	t
186	18	t
186	19	t
186	20	t
186	5	t
186	6	t
186	7	t
186	15	t
186	16	t
186	21	t
186	23	t
187	21	t
187	22	t
188	25	t
188	26	t
188	27	t
188	29	t
189	30	t
189	31	t
189	32	t
189	18	t
189	19	t
190	27	t
190	28	t
190	29	t
190	24	t
190	25	t
190	26	t
190	33	t
190	34	t
190	35	t
191	28	t
191	29	t
191	22	t
191	23	t
192	15	t
192	16	t
192	17	t
192	5	t
192	6	t
192	7	t
192	8	t
192	28	t
192	29	t
193	1	t
193	2	t
193	3	t
193	4	t
193	12	t
193	14	t
194	18	t
194	19	t
194	20	t
194	15	t
194	16	t
194	17	t
194	34	t
194	35	t
194	9	t
194	11	t
195	27	t
195	29	t
195	18	t
195	19	t
195	20	t
195	16	t
195	17	t
195	12	t
195	14	t
196	30	t
196	31	t
196	24	t
196	25	t
196	26	t
197	31	t
197	32	t
197	9	t
197	10	t
197	11	t
198	27	t
198	28	t
198	29	t
198	22	t
198	23	t
198	1	t
198	2	t
198	3	t
198	4	t
199	1	t
199	2	t
199	29	t
199	33	t
199	34	t
199	35	t
200	18	t
200	19	t
200	20	t
200	33	t
200	34	t
200	35	t
200	12	t
200	13	t
200	14	t
200	5	t
200	6	t
200	7	t
200	8	t
201	1	t
201	2	t
201	3	t
201	15	t
201	17	t
202	24	t
202	25	t
202	26	t
203	24	t
203	25	t
203	26	t
203	15	t
203	16	t
203	17	t
204	21	t
204	22	t
204	23	t
204	15	t
204	17	t
204	1	t
204	2	t
204	3	t
204	4	t
205	21	t
205	22	t
205	23	t
205	26	t
205	33	t
205	34	t
205	35	t
206	5	t
206	7	t
206	8	t
206	30	t
206	31	t
206	32	t
206	33	t
206	34	t
206	35	t
207	21	t
207	22	t
207	23	t
207	30	t
207	31	t
207	32	t
208	18	t
208	19	t
208	20	t
208	28	t
208	29	t
209	24	t
209	25	t
209	26	t
209	30	t
209	31	t
209	32	t
209	1	t
209	2	t
209	3	t
209	4	t
210	6	t
210	7	t
210	8	t
210	24	t
210	25	t
210	26	t
211	2	t
211	3	t
211	4	t
212	9	t
212	10	t
212	11	t
212	24	t
212	26	t
212	18	t
212	19	t
213	24	t
213	25	t
213	26	t
213	30	t
213	31	t
213	32	t
214	21	t
214	22	t
214	5	t
214	7	t
214	12	t
214	14	t
215	18	t
215	19	t
215	20	t
215	13	t
215	14	t
215	8	t
216	5	t
216	6	t
216	8	t
216	28	t
216	29	t
217	11	t
217	24	t
217	25	t
217	26	t
217	27	t
217	28	t
218	1	t
218	2	t
218	3	t
219	19	t
219	20	t
219	9	t
219	10	t
219	11	t
219	24	t
219	25	t
219	26	t
220	27	t
220	28	t
220	29	t
220	26	t
220	1	t
220	3	t
220	4	t
221	18	t
221	19	t
221	6	t
221	7	t
221	8	t
221	34	t
222	30	t
222	31	t
222	32	t
222	1	t
222	2	t
222	4	t
223	24	t
223	25	t
224	5	t
224	6	t
224	7	t
224	2	t
224	30	t
224	31	t
224	32	t
225	27	t
225	21	t
225	22	t
225	23	t
225	18	t
225	20	t
226	27	t
226	28	t
226	13	t
226	14	t
227	14	t
227	30	t
227	31	t
227	32	t
228	9	t
228	10	t
228	33	t
228	34	t
228	35	t
228	21	t
228	22	t
228	23	t
228	31	t
228	32	t
229	22	t
229	12	t
229	13	t
229	14	t
230	6	t
230	7	t
230	8	t
230	12	t
230	13	t
230	14	t
230	18	t
230	19	t
230	20	t
230	3	t
230	4	t
231	5	t
231	6	t
231	7	t
231	15	t
231	16	t
231	17	t
232	15	t
232	16	t
232	17	t
232	2	t
232	3	t
232	4	t
233	5	t
233	6	t
233	7	t
233	1	t
233	2	t
233	33	t
233	34	t
233	35	t
234	18	t
234	19	t
234	20	t
234	15	t
234	17	t
234	5	t
234	7	t
234	8	t
234	10	t
234	11	t
235	24	t
235	25	t
235	26	t
235	21	t
235	22	t
235	23	t
236	27	t
236	28	t
236	29	t
236	9	t
236	10	t
236	11	t
237	29	t
237	25	t
237	26	t
237	33	t
237	35	t
237	18	t
237	19	t
237	20	t
238	1	t
238	2	t
238	3	t
238	4	t
238	9	t
238	11	t
238	33	t
238	34	t
238	35	t
239	18	t
239	20	t
239	1	t
239	4	t
240	18	t
240	19	t
240	20	t
240	5	t
240	6	t
240	7	t
240	8	t
241	12	t
241	13	t
241	14	t
241	30	t
241	31	t
241	32	t
242	6	t
242	7	t
242	9	t
242	10	t
242	11	t
242	21	t
242	22	t
243	5	t
243	7	t
243	1	t
243	3	t
243	4	t
243	9	t
243	10	t
243	11	t
244	18	t
244	19	t
244	20	t
244	25	t
244	26	t
245	1	t
245	3	t
245	34	t
245	35	t
246	9	t
246	10	t
246	11	t
246	19	t
246	20	t
247	9	t
247	10	t
247	11	t
247	18	t
247	20	t
247	1	t
247	2	t
247	3	t
247	4	t
248	12	t
248	14	t
248	33	t
248	34	t
248	35	t
249	22	t
249	23	t
249	31	t
249	32	t
249	24	t
249	25	t
249	26	t
250	2	t
250	3	t
250	12	t
250	13	t
250	14	t
250	27	t
250	28	t
250	29	t
251	30	t
251	31	t
251	32	t
251	15	t
251	17	t
252	33	t
252	34	t
252	35	t
252	18	t
252	20	t
253	11	t
253	6	t
253	7	t
253	8	t
254	25	t
254	26	t
254	10	t
254	11	t
254	16	t
254	17	t
255	15	t
255	16	t
255	17	t
255	18	t
255	19	t
255	20	t
255	34	t
255	35	t
256	15	t
256	16	t
256	17	t
257	21	t
257	22	t
257	23	t
258	1	t
258	2	t
258	3	t
258	4	t
258	24	t
258	25	t
258	21	t
258	22	t
258	23	t
258	33	t
258	34	t
258	35	t
259	27	t
259	28	t
259	29	t
259	1	t
259	2	t
259	3	t
259	4	t
260	27	t
260	28	t
260	29	t
260	9	t
260	10	t
260	11	t
261	9	t
261	10	t
261	11	t
261	22	t
261	23	t
262	34	t
262	6	t
262	7	t
262	21	t
262	23	t
263	13	t
263	9	t
263	10	t
263	11	t
264	15	t
264	16	t
264	18	t
264	20	t
265	1	t
265	2	t
265	3	t
265	30	t
265	31	t
265	15	t
265	16	t
265	17	t
266	33	t
266	34	t
266	35	t
266	24	t
266	25	t
266	26	t
267	30	t
267	31	t
267	32	t
267	27	t
267	28	t
268	33	t
268	34	t
268	35	t
268	30	t
268	31	t
268	32	t
269	1	t
269	2	t
269	4	t
269	22	t
269	23	t
270	18	t
270	19	t
270	20	t
270	33	t
270	35	t
270	21	t
270	22	t
270	23	t
271	9	t
271	10	t
271	11	t
271	13	t
272	24	t
272	25	t
272	26	t
272	5	t
272	6	t
272	7	t
272	8	t
273	7	t
273	8	t
273	33	t
273	34	t
273	35	t
274	30	t
274	31	t
274	32	t
274	18	t
274	27	t
275	11	t
275	24	t
275	26	t
275	6	t
275	7	t
276	22	t
276	23	t
276	34	t
276	35	t
277	13	t
277	14	t
277	18	t
277	19	t
278	24	t
278	25	t
278	26	t
278	21	t
278	15	t
278	16	t
279	5	t
279	7	t
279	8	t
279	22	t
279	23	t
279	1	t
279	2	t
279	3	t
279	4	t
280	15	t
280	16	t
280	34	t
280	35	t
281	9	t
281	10	t
281	11	t
281	18	t
281	19	t
282	9	t
282	10	t
282	11	t
282	33	t
282	35	t
283	27	t
283	28	t
283	29	t
283	21	t
283	22	t
283	23	t
283	24	t
283	25	t
284	15	t
284	16	t
284	17	t
284	18	t
284	19	t
284	20	t
285	5	t
285	6	t
285	7	t
285	8	t
285	30	t
285	32	t
285	18	t
285	19	t
285	20	t
286	15	t
286	17	t
286	24	t
286	25	t
286	26	t
286	30	t
286	32	t
287	27	t
287	28	t
287	29	t
287	15	t
287	17	t
287	21	t
287	22	t
287	23	t
288	5	t
288	7	t
288	16	t
288	17	t
288	27	t
288	22	t
288	23	t
289	12	t
289	13	t
289	14	t
289	24	t
289	25	t
289	26	t
290	18	t
290	19	t
290	24	t
290	26	t
291	21	t
291	22	t
291	23	t
291	15	t
291	17	t
292	6	t
292	7	t
292	19	t
292	20	t
292	33	t
293	24	t
293	25	t
293	26	t
294	5	t
294	7	t
294	8	t
294	27	t
294	28	t
294	29	t
295	19	t
295	33	t
295	34	t
295	35	t
296	1	t
296	2	t
296	3	t
296	4	t
296	13	t
296	14	t
297	21	t
297	23	t
298	30	t
298	31	t
298	32	t
299	21	t
299	22	t
299	23	t
299	27	t
299	28	t
299	29	t
300	5	t
300	6	t
300	7	t
300	8	t
300	9	t
300	10	t
300	11	t
301	15	t
301	17	t
301	9	t
302	27	t
302	28	t
302	29	t
302	1	t
302	2	t
302	3	t
302	4	t
303	9	t
303	10	t
303	12	t
303	31	t
304	33	t
304	34	t
304	5	t
304	6	t
304	8	t
304	21	t
304	22	t
305	30	t
305	31	t
305	32	t
305	18	t
305	19	t
305	20	t
305	27	t
305	28	t
305	29	t
306	1	t
306	2	t
306	3	t
306	4	t
306	9	t
306	10	t
306	11	t
307	27	t
307	28	t
308	5	t
308	6	t
308	7	t
308	8	t
308	22	t
308	23	t
309	28	t
309	29	t
310	24	t
310	25	t
310	1	t
310	2	t
310	4	t
310	6	t
310	7	t
311	19	t
311	20	t
311	12	t
311	13	t
311	14	t
311	15	t
311	17	t
312	21	t
312	22	t
312	23	t
313	13	t
313	14	t
313	30	t
313	31	t
314	24	t
314	25	t
314	26	t
314	12	t
314	13	t
314	14	t
314	21	t
314	22	t
314	23	t
315	9	t
315	11	t
315	5	t
315	6	t
315	7	t
315	8	t
315	21	t
315	22	t
315	23	t
316	21	t
316	22	t
316	23	t
316	18	t
316	19	t
316	24	t
316	25	t
316	26	t
317	12	t
317	13	t
317	14	t
317	24	t
317	25	t
317	26	t
317	30	t
317	31	t
317	32	t
317	2	t
317	3	t
317	4	t
318	19	t
318	20	t
318	21	t
318	22	t
318	23	t
318	34	t
319	33	t
319	34	t
319	27	t
319	28	t
320	15	t
320	16	t
320	17	t
320	1	t
320	2	t
320	4	t
320	21	t
320	22	t
320	23	t
320	24	t
320	25	t
320	26	t
321	12	t
321	13	t
321	34	t
321	24	t
321	25	t
322	30	t
322	31	t
322	32	t
322	27	t
322	28	t
322	29	t
323	30	t
323	31	t
323	32	t
323	25	t
324	30	t
324	31	t
324	27	t
324	28	t
324	29	t
324	15	t
324	16	t
324	17	t
325	19	t
325	20	t
326	21	t
326	22	t
326	23	t
326	15	t
326	16	t
326	17	t
326	19	t
326	20	t
327	5	t
327	6	t
327	7	t
327	8	t
327	9	t
327	11	t
327	12	t
327	13	t
328	15	t
328	16	t
328	17	t
328	33	t
328	34	t
328	35	t
329	25	t
329	26	t
329	9	t
329	10	t
329	11	t
329	12	t
329	13	t
329	14	t
330	27	t
330	28	t
330	29	t
331	1	t
331	2	t
331	3	t
331	4	t
331	21	t
331	22	t
331	23	t
331	27	t
331	28	t
331	29	t
332	24	t
332	25	t
332	26	t
333	13	t
333	14	t
333	10	t
333	11	t
333	30	t
333	32	t
334	9	t
334	10	t
334	11	t
334	24	t
334	25	t
334	26	t
334	5	t
334	7	t
334	8	t
335	6	t
335	7	t
335	8	t
335	18	t
335	19	t
335	20	t
336	5	t
336	6	t
336	7	t
336	8	t
336	24	t
336	25	t
336	26	t
336	18	t
336	20	t
337	27	t
337	28	t
337	29	t
337	30	t
337	31	t
337	32	t
337	13	t
337	14	t
338	9	t
338	10	t
338	11	t
338	21	t
338	22	t
338	1	t
338	2	t
338	3	t
338	4	t
339	18	t
339	19	t
339	20	t
339	33	t
339	35	t
340	15	t
340	16	t
340	17	t
340	2	t
340	3	t
340	4	t
340	21	t
340	22	t
340	23	t
341	18	t
341	19	t
341	25	t
341	26	t
341	21	t
341	23	t
341	1	t
341	2	t
341	4	t
342	24	t
342	25	t
342	26	t
342	9	t
342	10	t
342	11	t
342	27	t
342	28	t
342	29	t
343	22	t
343	23	t
343	9	t
343	10	t
343	11	t
343	18	t
343	19	t
343	20	t
344	12	t
344	13	t
344	14	t
344	33	t
344	34	t
344	35	t
344	1	t
344	2	t
344	4	t
345	24	t
345	25	t
345	26	t
345	33	t
345	34	t
345	35	t
345	9	t
346	18	t
346	19	t
346	27	t
346	29	t
347	10	t
347	11	t
347	18	t
347	19	t
347	20	t
347	15	t
347	16	t
348	9	t
348	10	t
348	11	t
348	23	t
348	18	t
348	19	t
349	15	t
349	16	t
349	17	t
349	30	t
349	31	t
349	32	t
349	12	t
350	15	t
350	16	t
350	21	t
350	23	t
350	2	t
350	4	t
351	15	t
351	17	t
351	18	t
351	19	t
351	20	t
351	9	t
351	10	t
351	11	t
352	25	t
352	26	t
352	30	t
352	31	t
352	32	t
353	1	t
353	2	t
353	3	t
353	33	t
353	34	t
353	35	t
353	29	t
354	5	t
354	7	t
354	8	t
354	26	t
354	28	t
354	29	t
355	30	t
355	31	t
355	32	t
356	33	t
356	34	t
356	35	t
356	1	t
356	2	t
356	3	t
357	33	t
357	34	t
357	35	t
357	31	t
357	32	t
357	5	t
357	7	t
357	8	t
358	16	t
358	17	t
359	24	t
359	26	t
359	9	t
359	10	t
359	11	t
360	15	t
360	16	t
360	17	t
361	5	t
361	6	t
361	7	t
361	8	t
361	1	t
361	2	t
361	3	t
361	4	t
361	22	t
361	23	t
361	31	t
362	15	t
362	16	t
362	17	t
362	5	t
362	7	t
362	24	t
362	25	t
362	26	t
362	4	t
363	25	t
363	26	t
363	33	t
363	35	t
364	2	t
364	3	t
364	4	t
364	30	t
364	31	t
364	9	t
364	10	t
364	11	t
365	24	t
365	25	t
365	26	t
365	33	t
365	35	t
365	29	t
366	24	t
366	25	t
366	26	t
366	1	t
366	2	t
366	3	t
366	4	t
366	5	t
366	6	t
366	7	t
366	8	t
367	32	t
367	12	t
367	13	t
367	33	t
367	34	t
367	35	t
368	23	t
369	21	t
369	18	t
369	19	t
369	20	t
369	1	t
369	2	t
369	3	t
369	4	t
370	1	t
370	3	t
370	4	t
371	27	t
371	29	t
371	14	t
372	1	t
372	3	t
372	4	t
372	33	t
372	34	t
372	35	t
373	33	t
373	34	t
373	35	t
373	1	t
373	2	t
373	4	t
373	32	t
374	15	t
374	16	t
374	21	t
374	22	t
374	23	t
375	2	t
375	3	t
375	4	t
375	6	t
375	7	t
375	8	t
376	31	t
376	1	t
376	2	t
376	3	t
376	4	t
376	15	t
376	16	t
376	17	t
377	27	t
377	28	t
377	29	t
377	24	t
378	25	t
378	26	t
378	5	t
378	6	t
378	7	t
378	8	t
378	18	t
378	20	t
378	30	t
378	32	t
379	24	t
379	25	t
379	26	t
379	33	t
379	35	t
380	27	t
380	28	t
380	29	t
380	1	t
380	4	t
380	18	t
380	19	t
380	20	t
381	18	t
381	19	t
381	28	t
382	24	t
382	25	t
382	26	t
382	9	t
382	11	t
382	13	t
382	14	t
383	5	t
383	6	t
383	7	t
383	8	t
383	1	t
383	2	t
383	4	t
384	30	t
384	31	t
384	32	t
384	22	t
384	23	t
384	24	t
384	25	t
385	27	t
385	28	t
385	29	t
385	24	t
385	25	t
385	26	t
385	18	t
385	20	t
386	1	t
386	2	t
386	4	t
387	12	t
387	13	t
387	14	t
387	24	t
387	25	t
387	9	t
387	10	t
387	11	t
388	21	t
388	23	t
388	24	t
388	25	t
388	26	t
389	21	t
389	22	t
389	9	t
389	10	t
389	11	t
389	25	t
389	26	t
390	1	t
390	2	t
390	3	t
390	4	t
390	22	t
390	23	t
390	33	t
390	34	t
390	35	t
391	1	t
391	2	t
391	3	t
391	4	t
391	30	t
391	32	t
392	24	t
392	12	t
392	13	t
392	15	t
392	16	t
392	17	t
393	27	t
393	28	t
393	29	t
393	12	t
393	13	t
393	14	t
394	24	t
394	26	t
394	17	t
394	9	t
394	10	t
394	11	t
394	21	t
395	21	t
395	22	t
395	23	t
395	24	t
395	25	t
395	26	t
396	12	t
396	13	t
396	14	t
397	30	t
397	31	t
397	15	t
397	16	t
397	17	t
398	10	t
398	27	t
398	28	t
398	29	t
399	33	t
399	34	t
399	35	t
399	18	t
399	20	t
399	1	t
399	2	t
400	18	t
400	19	t
400	24	t
400	25	t
400	26	t
401	30	t
401	31	t
401	24	t
401	25	t
401	26	t
401	18	t
401	19	t
401	20	t
402	15	t
402	16	t
402	17	t
402	18	t
402	19	t
402	20	t
402	21	t
402	22	t
402	23	t
403	30	t
403	31	t
403	32	t
403	24	t
403	25	t
403	26	t
404	30	t
404	32	t
404	24	t
404	25	t
404	26	t
404	33	t
404	34	t
404	35	t
405	28	t
405	29	t
405	5	t
405	6	t
405	8	t
406	24	t
406	25	t
406	26	t
406	35	t
406	11	t
407	34	t
407	35	t
407	5	t
407	6	t
407	7	t
407	8	t
408	30	t
408	32	t
408	27	t
408	29	t
409	10	t
409	11	t
409	21	t
409	15	t
409	17	t
410	5	t
410	6	t
410	7	t
410	8	t
410	33	t
410	34	t
410	35	t
411	33	t
411	34	t
411	16	t
411	17	t
412	33	t
412	34	t
412	15	t
412	17	t
412	21	t
412	22	t
412	23	t
413	12	t
413	13	t
413	27	t
413	28	t
413	29	t
413	30	t
413	31	t
413	32	t
414	27	t
414	29	t
414	1	t
414	2	t
414	3	t
415	27	t
415	29	t
415	2	t
415	3	t
415	4	t
415	33	t
415	35	t
416	33	t
416	35	t
416	12	t
416	14	t
416	5	t
416	7	t
416	8	t
417	33	t
417	34	t
417	35	t
417	9	t
417	10	t
417	11	t
418	9	t
418	10	t
418	11	t
418	30	t
418	31	t
418	32	t
419	28	t
419	29	t
419	10	t
419	11	t
420	18	t
420	19	t
420	20	t
420	1	t
420	2	t
420	4	t
420	21	t
420	23	t
421	21	t
421	22	t
421	23	t
421	15	t
421	16	t
421	27	t
421	28	t
421	29	t
422	27	t
422	28	t
422	29	t
422	1	t
422	2	t
422	3	t
422	4	t
422	9	t
422	10	t
422	11	t
422	12	t
422	13	t
422	14	t
423	33	t
423	35	t
423	21	t
423	22	t
423	23	t
423	18	t
423	19	t
423	20	t
424	18	t
424	19	t
424	20	t
424	33	t
424	9	t
424	10	t
424	11	t
424	31	t
424	32	t
425	33	t
425	34	t
425	16	t
426	24	t
426	25	t
426	26	t
426	11	t
427	1	t
427	2	t
427	3	t
427	4	t
427	30	t
427	32	t
427	25	t
427	26	t
428	5	t
428	6	t
428	8	t
428	18	t
428	19	t
428	20	t
429	21	t
429	22	t
429	23	t
429	5	t
429	6	t
429	7	t
429	8	t
430	5	t
430	6	t
430	7	t
430	8	t
430	28	t
430	29	t
431	30	t
431	31	t
432	9	t
432	11	t
433	1	t
433	2	t
433	3	t
433	4	t
433	15	t
433	17	t
434	1	t
434	2	t
434	3	t
434	4	t
435	9	t
435	10	t
435	11	t
436	15	t
436	16	t
436	17	t
436	30	t
436	31	t
436	32	t
437	12	t
437	13	t
437	14	t
437	33	t
437	35	t
437	18	t
437	19	t
437	20	t
438	33	t
438	35	t
438	5	t
438	6	t
438	7	t
438	18	t
438	19	t
438	20	t
439	15	t
439	16	t
439	17	t
439	14	t
439	33	t
439	34	t
439	35	t
439	24	t
439	26	t
440	6	t
440	7	t
440	29	t
441	1	t
441	2	t
441	3	t
441	4	t
441	27	t
441	28	t
441	29	t
442	15	t
442	16	t
442	17	t
442	12	t
442	13	t
442	14	t
442	6	t
442	7	t
442	8	t
443	30	t
443	31	t
443	32	t
443	6	t
443	7	t
444	21	t
444	22	t
444	23	t
444	33	t
444	34	t
444	35	t
444	27	t
444	28	t
444	12	t
444	13	t
444	14	t
445	1	t
445	2	t
445	3	t
445	4	t
445	15	t
445	16	t
445	17	t
445	27	t
445	28	t
445	29	t
445	33	t
445	34	t
445	35	t
446	5	t
446	6	t
446	7	t
446	15	t
446	16	t
446	17	t
446	30	t
446	31	t
446	32	t
446	18	t
446	19	t
447	18	t
447	19	t
447	20	t
447	30	t
447	31	t
447	32	t
448	15	t
448	17	t
448	33	t
448	35	t
449	15	t
449	18	t
449	19	t
449	20	t
450	16	t
450	17	t
450	27	t
450	28	t
451	27	t
451	29	t
451	33	t
451	34	t
451	35	t
451	5	t
451	7	t
451	8	t
452	24	t
452	25	t
452	26	t
452	21	t
452	23	t
452	30	t
452	32	t
452	6	t
452	8	t
453	10	t
453	11	t
453	25	t
453	27	t
453	29	t
454	27	t
454	28	t
454	29	t
454	35	t
455	27	t
455	29	t
455	34	t
455	35	t
455	12	t
455	13	t
455	14	t
456	5	t
456	6	t
456	7	t
456	8	t
456	15	t
456	16	t
456	27	t
456	28	t
456	29	t
456	24	t
456	26	t
457	33	t
457	34	t
457	35	t
457	24	t
457	28	t
457	29	t
457	9	t
457	11	t
458	24	t
458	26	t
458	30	t
458	31	t
458	32	t
458	9	t
458	10	t
458	11	t
459	5	t
459	6	t
459	7	t
459	1	t
459	2	t
459	4	t
459	15	t
459	17	t
460	25	t
460	26	t
460	15	t
460	16	t
460	17	t
460	33	t
460	34	t
460	35	t
461	9	t
461	10	t
461	11	t
461	34	t
461	35	t
462	12	t
462	13	t
462	9	t
462	10	t
462	11	t
463	19	t
463	30	t
463	31	t
463	32	t
464	5	t
464	6	t
464	7	t
464	22	t
464	23	t
464	33	t
465	1	t
465	3	t
465	4	t
465	9	t
465	10	t
465	11	t
466	24	t
466	27	t
466	28	t
466	29	t
467	12	t
467	13	t
467	14	t
467	5	t
467	27	t
467	28	t
467	29	t
468	28	t
468	29	t
468	9	t
468	11	t
468	21	t
468	22	t
468	23	t
469	5	t
469	6	t
469	7	t
469	8	t
469	18	t
469	20	t
470	9	t
470	10	t
470	11	t
471	1	t
471	2	t
471	3	t
471	4	t
471	12	t
471	13	t
471	14	t
472	1	t
472	2	t
472	3	t
472	9	t
472	11	t
472	21	t
472	22	t
472	23	t
473	35	t
473	5	t
473	6	t
473	7	t
473	8	t
474	5	t
474	6	t
474	7	t
474	8	t
474	18	t
474	19	t
474	20	t
474	9	t
474	10	t
474	11	t
475	24	t
475	25	t
475	26	t
475	1	t
475	2	t
475	4	t
475	27	t
475	28	t
475	29	t
475	21	t
475	22	t
475	23	t
476	21	t
476	22	t
476	23	t
476	18	t
476	19	t
476	20	t
477	24	t
477	25	t
477	9	t
477	10	t
477	21	t
477	22	t
477	23	t
478	27	t
478	28	t
478	29	t
478	16	t
479	21	t
479	23	t
479	33	t
479	34	t
479	35	t
480	15	t
480	16	t
480	17	t
481	24	t
481	25	t
481	26	t
481	18	t
481	19	t
481	20	t
482	15	t
482	17	t
482	12	t
482	13	t
482	14	t
483	24	t
483	25	t
484	21	t
484	22	t
484	23	t
484	5	t
484	6	t
484	7	t
484	8	t
484	25	t
485	9	t
485	10	t
485	11	t
485	12	t
485	13	t
485	14	t
485	15	t
485	17	t
486	18	t
486	19	t
486	9	t
486	10	t
486	11	t
486	13	t
486	14	t
487	21	t
487	22	t
487	23	t
487	2	t
487	3	t
487	33	t
487	34	t
487	35	t
488	1	t
488	2	t
488	3	t
488	4	t
488	30	t
488	31	t
488	32	t
488	22	t
488	23	t
489	18	t
489	19	t
489	5	t
489	6	t
489	8	t
489	21	t
489	22	t
489	23	t
490	30	t
490	31	t
490	18	t
490	19	t
490	27	t
490	28	t
490	29	t
490	24	t
490	25	t
490	26	t
491	31	t
491	32	t
491	33	t
491	34	t
491	35	t
491	19	t
491	20	t
491	1	t
491	2	t
491	3	t
492	21	t
492	22	t
492	23	t
492	9	t
492	10	t
492	11	t
493	24	t
493	25	t
493	26	t
493	12	t
493	13	t
493	14	t
493	30	t
493	32	t
494	16	t
494	17	t
495	2	t
495	3	t
495	4	t
495	15	t
495	16	t
495	17	t
495	5	t
495	6	t
495	7	t
495	8	t
496	3	t
496	4	t
496	18	t
496	19	t
496	20	t
496	21	t
496	22	t
496	23	t
497	10	t
497	11	t
497	30	t
497	31	t
497	32	t
497	22	t
497	23	t
498	22	t
498	23	t
498	9	t
498	10	t
498	11	t
499	3	t
499	4	t
499	5	t
499	6	t
499	7	t
499	8	t
500	33	t
500	34	t
500	35	t
500	30	t
500	31	t
500	32	t
501	15	t
501	17	t
501	22	t
501	23	t
501	18	t
501	19	t
501	33	t
501	34	t
502	21	t
502	23	t
502	16	t
502	18	t
502	20	t
503	28	t
503	29	t
503	1	t
503	2	t
503	3	t
504	31	t
504	32	t
505	30	t
505	31	t
505	32	t
505	12	t
505	14	t
505	33	t
505	34	t
505	35	t
506	21	t
506	23	t
506	18	t
506	19	t
506	20	t
507	16	t
508	18	t
508	20	t
508	1	t
508	2	t
508	3	t
508	4	t
508	33	t
508	34	t
508	35	t
509	21	t
509	22	t
509	23	t
509	1	t
509	2	t
509	3	t
510	30	t
510	31	t
510	32	t
510	27	t
510	28	t
510	15	t
510	16	t
511	21	t
511	22	t
511	23	t
511	16	t
511	17	t
512	18	t
512	20	t
512	24	t
512	1	t
512	2	t
512	3	t
512	4	t
513	21	t
513	22	t
513	23	t
513	27	t
513	28	t
514	31	t
514	32	t
514	25	t
514	26	t
514	18	t
514	19	t
514	20	t
515	18	t
515	19	t
515	5	t
515	6	t
515	8	t
515	9	t
515	10	t
515	11	t
516	24	t
516	25	t
516	28	t
516	29	t
516	15	t
516	16	t
517	30	t
517	31	t
517	32	t
518	30	t
518	31	t
518	1	t
518	2	t
518	3	t
518	4	t
518	15	t
518	16	t
518	17	t
518	24	t
518	26	t
519	24	t
519	26	t
519	28	t
519	29	t
519	21	t
519	22	t
519	23	t
520	15	t
520	16	t
520	17	t
520	29	t
521	9	t
521	11	t
521	12	t
521	14	t
521	33	t
521	35	t
522	30	t
522	31	t
522	32	t
522	1	t
522	2	t
522	3	t
522	4	t
522	15	t
522	17	t
523	24	t
523	25	t
523	26	t
523	15	t
523	16	t
523	17	t
523	27	t
523	28	t
524	5	t
524	6	t
524	8	t
524	12	t
524	13	t
524	14	t
525	21	t
525	23	t
525	33	t
525	34	t
525	35	t
525	15	t
525	16	t
525	18	t
525	19	t
525	20	t
526	18	t
526	20	t
526	28	t
526	29	t
527	18	t
527	20	t
527	24	t
527	26	t
527	22	t
527	23	t
528	6	t
528	7	t
528	27	t
528	28	t
528	29	t
528	24	t
528	26	t
529	5	t
529	8	t
529	33	t
529	34	t
529	35	t
530	9	t
530	10	t
530	11	t
530	21	t
530	22	t
530	23	t
530	33	t
530	34	t
530	35	t
531	27	t
531	28	t
531	29	t
531	24	t
531	25	t
531	30	t
531	18	t
531	19	t
532	15	t
532	16	t
532	17	t
532	24	t
532	25	t
532	26	t
532	18	t
532	19	t
532	20	t
533	26	t
533	10	t
533	15	t
533	17	t
534	12	t
534	13	t
534	14	t
534	1	t
534	3	t
534	4	t
534	27	t
534	28	t
534	29	t
534	33	t
534	34	t
535	5	t
535	6	t
535	7	t
535	8	t
535	33	t
535	34	t
535	35	t
536	21	t
536	22	t
536	5	t
536	6	t
536	7	t
536	8	t
536	1	t
536	2	t
536	3	t
536	4	t
536	18	t
536	19	t
536	20	t
537	9	t
537	11	t
537	12	t
537	13	t
537	14	t
537	21	t
537	23	t
538	15	t
538	16	t
538	17	t
538	18	t
538	19	t
538	33	t
538	34	t
538	35	t
539	12	t
539	13	t
539	14	t
539	21	t
539	22	t
539	23	t
539	27	t
539	28	t
540	12	t
540	13	t
540	14	t
540	33	t
540	34	t
541	24	t
541	25	t
541	26	t
541	27	t
541	28	t
541	29	t
542	12	t
542	13	t
542	14	t
542	10	t
542	11	t
543	30	t
543	31	t
543	32	t
543	28	t
543	29	t
543	15	t
543	16	t
544	12	t
544	13	t
544	14	t
544	21	t
544	22	t
544	23	t
545	5	t
545	6	t
545	8	t
545	15	t
545	16	t
545	17	t
545	33	t
545	35	t
546	27	t
546	28	t
547	5	t
547	6	t
547	7	t
547	8	t
547	15	t
547	16	t
547	17	t
548	33	t
548	34	t
548	35	t
548	27	t
548	28	t
548	29	t
549	15	t
549	16	t
549	17	t
549	12	t
549	13	t
549	24	t
549	25	t
549	26	t
550	9	t
550	10	t
550	22	t
550	23	t
550	16	t
550	17	t
551	30	t
551	31	t
551	27	t
551	28	t
551	29	t
551	9	t
551	11	t
552	12	t
552	13	t
552	14	t
552	27	t
552	28	t
552	29	t
553	5	t
553	6	t
553	7	t
553	8	t
553	1	t
553	2	t
553	3	t
553	25	t
554	9	t
554	10	t
554	11	t
554	5	t
554	6	t
554	7	t
554	8	t
554	30	t
554	31	t
554	32	t
555	1	t
555	2	t
555	3	t
555	4	t
555	12	t
555	13	t
555	5	t
555	6	t
555	7	t
555	8	t
555	15	t
555	16	t
555	17	t
556	24	t
556	25	t
556	26	t
557	12	t
557	13	t
557	14	t
558	1	t
558	4	t
558	24	t
558	25	t
558	26	t
558	33	t
558	34	t
558	35	t
558	5	t
558	6	t
558	7	t
558	8	t
559	13	t
559	14	t
559	15	t
559	16	t
559	17	t
559	19	t
559	20	t
560	24	t
560	26	t
560	9	t
560	10	t
560	11	t
560	21	t
560	22	t
560	23	t
561	27	t
561	28	t
561	12	t
561	13	t
561	14	t
561	24	t
561	25	t
561	26	t
561	15	t
561	16	t
561	17	t
562	18	t
562	20	t
562	7	t
562	8	t
562	30	t
562	31	t
563	26	t
563	6	t
563	7	t
563	8	t
564	1	t
564	2	t
564	3	t
564	4	t
564	9	t
564	10	t
564	11	t
565	27	t
565	28	t
565	29	t
565	18	t
565	19	t
565	20	t
566	9	t
566	10	t
566	11	t
566	33	t
566	34	t
566	35	t
567	12	t
567	13	t
567	14	t
568	1	t
568	2	t
568	3	t
568	4	t
568	27	t
568	28	t
568	29	t
568	33	t
568	5	t
568	6	t
568	7	t
569	15	t
569	16	t
569	17	t
569	5	t
569	6	t
569	7	t
570	5	t
570	6	t
570	7	t
570	8	t
570	9	t
570	18	t
570	19	t
570	20	t
571	12	t
571	13	t
571	30	t
571	32	t
571	9	t
571	10	t
571	11	t
572	21	t
572	23	t
573	5	t
573	8	t
573	24	t
573	26	t
573	14	t
573	28	t
574	12	t
574	24	t
574	25	t
574	26	t
574	1	t
574	2	t
574	3	t
574	4	t
575	27	t
575	28	t
575	9	t
575	10	t
575	11	t
576	9	t
576	10	t
576	11	t
576	12	t
576	13	t
576	30	t
576	31	t
576	32	t
576	18	t
576	20	t
577	9	t
577	10	t
577	11	t
578	27	t
578	29	t
578	18	t
578	20	t
579	18	t
579	19	t
579	20	t
579	24	t
579	26	t
579	2	t
579	3	t
579	4	t
580	30	t
580	31	t
580	32	t
580	33	t
580	34	t
580	35	t
580	22	t
580	23	t
580	9	t
580	10	t
580	11	t
581	33	t
581	24	t
581	25	t
581	26	t
582	33	t
582	35	t
582	30	t
582	31	t
582	32	t
582	27	t
582	28	t
582	29	t
583	27	t
583	28	t
583	29	t
583	18	t
583	19	t
583	12	t
583	14	t
584	24	t
584	34	t
584	35	t
585	21	t
585	22	t
585	23	t
585	15	t
585	16	t
585	17	t
586	30	t
586	31	t
586	32	t
586	2	t
586	3	t
586	4	t
587	21	t
587	23	t
587	19	t
587	20	t
587	9	t
587	10	t
587	11	t
588	20	t
588	12	t
588	13	t
588	14	t
588	27	t
588	28	t
588	29	t
589	29	t
589	21	t
589	22	t
589	23	t
589	24	t
589	25	t
589	26	t
590	35	t
590	5	t
590	6	t
590	7	t
590	8	t
591	21	t
591	22	t
591	1	t
591	2	t
591	3	t
591	4	t
591	15	t
591	16	t
592	9	t
592	11	t
593	18	t
593	19	t
593	7	t
593	8	t
594	9	t
594	10	t
594	11	t
595	15	t
595	16	t
595	34	t
595	35	t
595	12	t
595	14	t
596	5	t
596	7	t
596	8	t
596	33	t
596	34	t
596	35	t
597	1	t
597	3	t
597	4	t
597	21	t
597	22	t
597	23	t
598	21	t
598	22	t
598	23	t
598	9	t
598	10	t
598	11	t
599	5	t
599	6	t
599	8	t
599	21	t
599	22	t
599	23	t
599	1	t
599	2	t
600	18	t
600	19	t
600	20	t
600	5	t
600	6	t
600	7	t
600	8	t
600	15	t
600	16	t
600	17	t
601	12	t
601	13	t
601	14	t
601	24	t
601	25	t
601	26	t
601	23	t
602	19	t
602	20	t
602	9	t
602	11	t
603	24	t
604	21	t
604	23	t
604	1	t
604	2	t
604	3	t
604	4	t
604	9	t
604	11	t
605	33	t
605	34	t
605	35	t
605	21	t
605	22	t
605	23	t
605	18	t
605	20	t
605	1	t
605	2	t
605	3	t
605	4	t
606	28	t
606	29	t
607	12	t
607	13	t
607	14	t
607	31	t
607	32	t
608	33	t
608	34	t
608	35	t
608	30	t
608	31	t
608	32	t
608	27	t
608	28	t
608	29	t
609	27	t
609	29	t
609	33	t
609	35	t
610	6	t
610	7	t
610	31	t
610	32	t
610	24	t
610	25	t
610	26	t
611	6	t
611	7	t
611	8	t
611	18	t
611	19	t
611	20	t
612	15	t
612	16	t
612	17	t
612	9	t
612	10	t
612	11	t
612	21	t
612	22	t
612	23	t
613	27	t
613	28	t
613	29	t
613	24	t
613	25	t
613	26	t
613	6	t
613	7	t
613	8	t
613	12	t
613	14	t
615	17	t
615	8	t
616	15	t
616	16	t
616	17	t
616	30	t
616	31	t
616	32	t
617	5	t
617	6	t
617	7	t
617	8	t
617	18	t
617	20	t
618	2	t
618	4	t
618	12	t
618	14	t
619	22	t
619	23	t
620	1	t
620	2	t
620	3	t
620	4	t
621	1	t
621	2	t
621	3	t
621	4	t
621	5	t
621	6	t
621	7	t
621	8	t
622	18	t
622	19	t
622	20	t
622	25	t
622	26	t
623	24	t
623	25	t
623	26	t
623	33	t
623	34	t
624	33	t
624	34	t
624	35	t
624	21	t
624	22	t
625	1	t
625	2	t
625	4	t
625	9	t
625	10	t
625	11	t
626	12	t
626	13	t
626	14	t
626	15	t
626	17	t
627	12	t
627	13	t
627	14	t
627	24	t
627	25	t
627	15	t
627	16	t
627	17	t
628	21	t
628	23	t
628	5	t
628	6	t
628	7	t
628	18	t
628	19	t
628	20	t
628	30	t
628	31	t
628	32	t
629	18	t
629	20	t
629	30	t
629	32	t
629	1	t
629	2	t
629	3	t
629	4	t
630	33	t
630	34	t
630	35	t
630	3	t
630	4	t
630	6	t
630	7	t
630	8	t
631	12	t
631	13	t
631	14	t
631	24	t
631	25	t
631	26	t
632	18	t
632	19	t
632	20	t
632	24	t
632	25	t
632	9	t
632	11	t
633	24	t
633	25	t
633	26	t
634	15	t
634	16	t
634	17	t
634	33	t
634	35	t
635	9	t
635	10	t
635	12	t
635	13	t
635	14	t
636	2	t
636	3	t
636	4	t
637	21	t
637	22	t
637	23	t
637	27	t
637	28	t
638	18	t
638	20	t
639	24	t
639	1	t
639	2	t
639	3	t
639	4	t
639	5	t
639	6	t
639	7	t
639	8	t
640	9	t
640	10	t
640	11	t
641	33	t
641	34	t
641	35	t
641	12	t
641	13	t
641	14	t
642	5	t
642	6	t
642	7	t
642	8	t
643	23	t
643	27	t
643	28	t
643	29	t
644	12	t
644	5	t
644	6	t
644	7	t
644	8	t
645	27	t
645	28	t
645	29	t
645	12	t
645	13	t
645	14	t
645	15	t
645	16	t
645	17	t
645	10	t
645	11	t
646	21	t
646	23	t
646	33	t
646	34	t
646	35	t
647	2	t
647	3	t
647	4	t
647	9	t
647	11	t
647	30	t
647	31	t
648	33	t
648	34	t
648	35	t
648	24	t
648	25	t
648	26	t
648	9	t
648	10	t
648	11	t
649	31	t
649	32	t
649	33	t
649	34	t
649	35	t
650	5	t
650	6	t
650	7	t
650	8	t
650	24	t
650	25	t
650	26	t
651	30	t
651	12	t
651	13	t
651	14	t
651	3	t
651	4	t
652	24	t
652	25	t
652	26	t
653	18	t
653	19	t
653	20	t
653	9	t
653	10	t
653	11	t
653	12	t
653	13	t
654	9	t
654	10	t
654	11	t
654	18	t
654	19	t
654	20	t
655	12	t
655	13	t
655	14	t
655	33	t
655	34	t
655	35	t
656	24	t
656	25	t
656	26	t
656	30	t
656	31	t
656	32	t
656	22	t
656	23	t
657	27	t
657	28	t
657	29	t
657	24	t
657	25	t
658	30	t
658	31	t
658	32	t
659	24	t
659	25	t
659	1	t
659	2	t
659	4	t
660	21	t
660	22	t
660	23	t
660	1	t
660	2	t
660	4	t
661	1	t
661	2	t
661	3	t
661	4	t
661	21	t
661	22	t
661	23	t
662	30	t
662	31	t
662	32	t
662	28	t
662	29	t
662	33	t
662	34	t
662	35	t
663	24	t
663	25	t
663	26	t
663	5	t
663	6	t
663	8	t
663	18	t
663	19	t
663	20	t
663	1	t
663	3	t
663	4	t
664	25	t
664	30	t
664	32	t
664	1	t
664	2	t
664	3	t
665	21	t
665	22	t
665	23	t
665	10	t
665	11	t
666	30	t
666	31	t
666	32	t
666	15	t
666	16	t
666	10	t
666	33	t
666	35	t
667	21	t
667	22	t
667	23	t
667	5	t
667	6	t
667	7	t
667	8	t
668	12	t
668	13	t
668	14	t
668	9	t
668	10	t
668	11	t
669	18	t
669	19	t
669	20	t
669	21	t
670	5	t
670	6	t
670	8	t
670	9	t
670	10	t
670	11	t
670	21	t
670	22	t
670	23	t
670	30	t
670	31	t
670	32	t
671	18	t
671	19	t
671	20	t
672	24	t
672	25	t
672	26	t
672	12	t
672	14	t
673	5	t
673	6	t
673	15	t
673	16	t
673	17	t
673	27	t
673	29	t
674	12	t
674	13	t
674	14	t
674	9	t
674	10	t
674	11	t
675	18	t
675	19	t
675	20	t
675	30	t
675	31	t
675	16	t
675	17	t
676	24	t
676	25	t
676	26	t
676	33	t
676	34	t
676	35	t
676	18	t
676	19	t
677	1	t
677	2	t
677	3	t
677	9	t
677	10	t
678	16	t
678	17	t
678	27	t
678	29	t
678	30	t
679	15	t
679	16	t
679	27	t
679	28	t
679	29	t
679	5	t
679	6	t
679	7	t
679	8	t
680	24	t
680	25	t
680	26	t
680	10	t
680	11	t
681	1	t
681	5	t
681	6	t
681	8	t
682	29	t
682	25	t
682	26	t
682	1	t
682	2	t
682	3	t
682	4	t
683	18	t
683	19	t
683	21	t
684	18	t
684	19	t
684	20	t
684	24	t
685	15	t
685	16	t
685	17	t
685	1	t
685	2	t
685	3	t
686	21	t
686	23	t
686	24	t
686	25	t
686	26	t
687	12	t
687	13	t
687	15	t
687	17	t
687	1	t
687	2	t
687	3	t
687	4	t
688	30	t
688	31	t
688	32	t
688	33	t
688	34	t
689	27	t
689	28	t
689	5	t
689	6	t
689	7	t
689	8	t
689	18	t
689	20	t
690	1	t
690	2	t
690	4	t
690	7	t
690	8	t
691	1	t
691	2	t
691	3	t
691	22	t
691	23	t
691	6	t
691	7	t
691	8	t
692	32	t
692	1	t
692	2	t
692	3	t
692	4	t
693	34	t
693	31	t
693	32	t
693	19	t
693	9	t
693	10	t
693	11	t
694	25	t
694	26	t
694	31	t
695	13	t
695	14	t
695	10	t
695	11	t
695	15	t
695	16	t
695	17	t
696	1	t
696	2	t
696	3	t
696	16	t
696	17	t
696	21	t
696	22	t
696	23	t
697	10	t
697	11	t
697	21	t
697	23	t
698	31	t
698	32	t
699	10	t
699	15	t
699	16	t
700	31	t
700	32	t
700	9	t
700	11	t
700	1	t
700	2	t
700	3	t
700	4	t
701	9	t
701	10	t
701	24	t
701	26	t
702	13	t
702	14	t
702	30	t
702	32	t
702	27	t
702	28	t
702	29	t
703	15	t
703	16	t
703	13	t
703	14	t
703	22	t
703	23	t
704	5	t
704	6	t
704	7	t
704	8	t
704	9	t
704	10	t
705	24	t
705	25	t
705	26	t
705	22	t
705	23	t
706	33	t
706	34	t
706	35	t
706	9	t
706	10	t
706	11	t
707	5	t
707	6	t
707	8	t
707	25	t
707	26	t
707	10	t
708	25	t
708	26	t
708	33	t
708	35	t
709	1	t
709	2	t
709	3	t
709	4	t
709	13	t
709	14	t
710	33	t
710	35	t
710	22	t
710	23	t
711	6	t
711	7	t
711	8	t
711	33	t
711	34	t
711	35	t
711	15	t
711	16	t
711	17	t
712	30	t
712	31	t
712	32	t
712	6	t
712	7	t
712	8	t
712	27	t
712	28	t
712	29	t
713	16	t
713	17	t
713	24	t
713	25	t
713	26	t
713	19	t
713	20	t
714	9	t
714	10	t
714	11	t
714	30	t
714	32	t
714	12	t
714	13	t
715	24	t
715	25	t
715	26	t
715	15	t
715	16	t
715	17	t
716	15	t
716	16	t
716	17	t
717	18	t
717	19	t
717	20	t
717	9	t
717	10	t
717	11	t
717	5	t
717	6	t
717	27	t
717	28	t
717	29	t
718	16	t
718	17	t
718	33	t
718	34	t
718	35	t
718	9	t
718	11	t
718	12	t
718	13	t
718	14	t
719	33	t
719	34	t
719	35	t
719	15	t
719	16	t
719	24	t
719	25	t
719	26	t
720	24	t
720	25	t
720	26	t
720	5	t
720	6	t
720	7	t
720	8	t
720	15	t
720	17	t
721	27	t
721	28	t
721	29	t
721	30	t
721	31	t
721	21	t
721	23	t
722	22	t
722	23	t
722	15	t
722	17	t
723	6	t
723	7	t
723	8	t
723	12	t
723	13	t
723	14	t
724	15	t
724	16	t
724	17	t
724	33	t
724	34	t
724	35	t
725	15	t
725	16	t
725	5	t
725	6	t
725	7	t
725	8	t
726	2	t
726	3	t
726	4	t
726	12	t
726	13	t
726	14	t
727	15	t
727	16	t
727	17	t
727	33	t
727	34	t
727	35	t
727	6	t
728	1	t
728	3	t
728	4	t
728	21	t
728	22	t
728	23	t
728	15	t
728	16	t
728	17	t
729	5	t
729	6	t
729	7	t
729	8	t
729	12	t
729	13	t
729	14	t
729	30	t
729	31	t
729	32	t
730	12	t
730	13	t
730	14	t
730	24	t
730	25	t
730	26	t
731	21	t
731	22	t
731	23	t
731	5	t
731	6	t
731	7	t
731	8	t
732	12	t
732	13	t
732	14	t
732	27	t
732	28	t
732	29	t
732	24	t
732	26	t
733	14	t
733	16	t
733	17	t
733	9	t
733	10	t
733	30	t
733	32	t
734	27	t
734	28	t
734	29	t
734	15	t
734	16	t
734	17	t
734	9	t
734	10	t
734	11	t
735	1	t
735	2	t
735	3	t
735	4	t
735	25	t
735	26	t
735	21	t
735	22	t
735	23	t
736	27	t
736	28	t
736	29	t
736	9	t
736	10	t
737	30	t
737	31	t
737	24	t
737	25	t
738	1	t
738	3	t
738	4	t
738	21	t
738	22	t
738	23	t
738	12	t
738	13	t
739	21	t
739	22	t
739	23	t
739	12	t
739	13	t
739	14	t
739	27	t
739	28	t
739	29	t
740	15	t
740	16	t
740	17	t
740	21	t
740	22	t
740	23	t
741	1	t
741	2	t
741	3	t
741	4	t
741	21	t
741	22	t
741	23	t
742	5	t
742	6	t
742	7	t
742	30	t
742	31	t
742	32	t
743	21	t
743	23	t
743	9	t
743	10	t
743	11	t
743	33	t
743	34	t
743	35	t
744	27	t
744	29	t
744	5	t
744	6	t
744	7	t
744	8	t
745	27	t
745	29	t
745	24	t
745	25	t
746	18	t
746	19	t
746	12	t
746	13	t
746	14	t
747	1	t
747	2	t
747	3	t
747	12	t
747	13	t
747	14	t
748	9	t
748	21	t
748	23	t
749	18	t
749	19	t
749	20	t
749	30	t
749	31	t
750	16	t
750	17	t
750	22	t
750	23	t
750	33	t
750	35	t
751	13	t
751	14	t
751	15	t
751	16	t
751	17	t
752	18	t
752	19	t
752	20	t
752	12	t
752	13	t
752	33	t
752	35	t
753	27	t
753	29	t
753	15	t
753	16	t
753	17	t
753	1	t
753	3	t
753	4	t
754	1	t
754	2	t
754	4	t
754	27	t
754	29	t
754	19	t
754	20	t
755	24	t
755	25	t
755	26	t
755	30	t
755	31	t
755	32	t
755	9	t
755	10	t
755	11	t
755	21	t
755	22	t
755	23	t
756	30	t
756	31	t
756	32	t
756	29	t
756	9	t
756	10	t
757	10	t
757	11	t
757	1	t
757	2	t
757	4	t
757	27	t
757	28	t
757	29	t
758	24	t
758	25	t
758	26	t
758	21	t
758	23	t
758	27	t
758	29	t
759	21	t
759	22	t
759	23	t
759	5	t
759	6	t
759	7	t
759	8	t
760	18	t
760	19	t
760	20	t
760	34	t
760	35	t
761	27	t
761	28	t
761	29	t
761	18	t
761	19	t
761	20	t
761	1	t
761	2	t
761	4	t
762	30	t
762	31	t
762	32	t
763	9	t
763	11	t
763	33	t
763	34	t
763	35	t
763	24	t
763	25	t
763	30	t
763	31	t
763	32	t
764	13	t
764	14	t
764	31	t
765	24	t
765	25	t
765	26	t
765	21	t
765	22	t
765	23	t
766	25	t
766	26	t
766	1	t
766	2	t
766	3	t
766	4	t
767	21	t
767	22	t
767	23	t
767	1	t
767	2	t
767	3	t
767	4	t
767	27	t
767	28	t
768	9	t
768	27	t
768	28	t
768	29	t
768	1	t
768	2	t
768	4	t
769	1	t
769	3	t
769	4	t
769	5	t
769	7	t
769	24	t
769	25	t
769	26	t
770	5	t
770	7	t
770	8	t
770	27	t
770	13	t
770	14	t
771	5	t
771	6	t
771	8	t
771	18	t
771	19	t
771	12	t
771	13	t
771	14	t
771	21	t
771	23	t
772	5	t
772	6	t
772	8	t
772	27	t
772	28	t
772	29	t
772	30	t
772	32	t
773	33	t
773	34	t
773	35	t
773	26	t
773	1	t
773	2	t
773	3	t
774	18	t
774	19	t
774	20	t
774	1	t
774	2	t
774	4	t
774	21	t
774	22	t
774	23	t
775	30	t
775	31	t
775	32	t
776	34	t
776	35	t
776	21	t
776	22	t
777	12	t
777	14	t
777	18	t
777	19	t
777	27	t
777	28	t
777	29	t
778	33	t
778	34	t
779	30	t
779	31	t
779	32	t
779	2	t
779	3	t
779	4	t
780	27	t
780	28	t
780	24	t
780	25	t
780	15	t
780	16	t
780	17	t
780	5	t
780	6	t
781	27	t
781	29	t
781	12	t
781	13	t
781	14	t
781	26	t
782	9	t
782	11	t
782	21	t
782	22	t
782	23	t
783	33	t
783	34	t
783	35	t
783	31	t
783	32	t
783	15	t
783	16	t
783	17	t
783	1	t
783	2	t
783	4	t
784	18	t
784	19	t
784	20	t
784	15	t
784	17	t
784	12	t
784	14	t
785	24	t
785	25	t
785	26	t
785	16	t
785	17	t
786	27	t
786	29	t
786	2	t
786	3	t
787	30	t
787	32	t
787	24	t
787	25	t
787	1	t
787	2	t
787	3	t
787	4	t
788	33	t
788	34	t
788	35	t
788	5	t
788	8	t
788	30	t
788	31	t
788	32	t
789	27	t
789	28	t
789	29	t
789	9	t
789	11	t
789	30	t
789	32	t
790	29	t
790	15	t
790	16	t
790	17	t
791	21	t
791	22	t
791	23	t
791	9	t
791	10	t
791	11	t
791	12	t
791	13	t
791	14	t
792	24	t
792	25	t
792	26	t
792	21	t
792	22	t
792	23	t
793	33	t
793	34	t
793	35	t
793	22	t
793	10	t
793	11	t
794	5	t
794	6	t
794	8	t
794	18	t
794	19	t
794	20	t
795	9	t
795	10	t
795	11	t
795	30	t
795	31	t
795	32	t
795	21	t
795	22	t
795	23	t
796	33	t
796	34	t
796	35	t
797	18	t
797	20	t
797	30	t
797	32	t
798	9	t
798	10	t
798	11	t
799	9	t
799	10	t
799	11	t
799	21	t
799	22	t
799	23	t
799	24	t
799	25	t
799	26	t
800	31	t
800	32	t
800	5	t
800	6	t
800	7	t
800	22	t
800	23	t
800	11	t
801	30	t
801	31	t
801	18	t
801	19	t
801	20	t
802	30	t
802	32	t
802	10	t
802	11	t
802	21	t
802	22	t
802	23	t
803	5	t
803	6	t
803	7	t
803	8	t
803	12	t
803	14	t
804	15	t
804	16	t
804	17	t
804	13	t
804	14	t
804	21	t
804	22	t
804	23	t
805	27	t
805	21	t
805	22	t
805	23	t
805	9	t
805	11	t
806	30	t
806	32	t
806	1	t
806	4	t
807	10	t
807	1	t
807	2	t
807	3	t
807	4	t
808	9	t
808	10	t
808	11	t
808	12	t
808	13	t
808	14	t
809	24	t
809	26	t
810	24	t
810	25	t
810	19	t
811	12	t
811	13	t
811	14	t
812	1	t
812	2	t
812	3	t
812	4	t
812	9	t
812	10	t
812	11	t
813	9	t
813	10	t
813	11	t
813	1	t
813	3	t
813	30	t
813	31	t
813	32	t
814	27	t
814	28	t
814	29	t
814	20	t
815	15	t
815	16	t
815	17	t
815	27	t
815	29	t
816	1	t
816	2	t
816	3	t
816	4	t
816	34	t
816	35	t
816	27	t
816	28	t
816	29	t
817	18	t
817	19	t
817	20	t
817	10	t
817	15	t
817	16	t
818	21	t
818	22	t
818	23	t
818	18	t
818	19	t
818	20	t
818	9	t
818	10	t
818	11	t
819	18	t
819	19	t
819	20	t
819	12	t
819	14	t
819	5	t
819	6	t
819	7	t
819	15	t
819	16	t
819	17	t
820	30	t
820	31	t
820	32	t
820	1	t
820	2	t
820	4	t
820	24	t
820	25	t
820	26	t
821	18	t
821	19	t
821	20	t
821	30	t
821	31	t
821	32	t
821	28	t
821	29	t
822	9	t
822	10	t
822	11	t
822	12	t
822	13	t
822	14	t
822	33	t
822	34	t
823	12	t
823	13	t
823	14	t
823	18	t
823	19	t
823	20	t
823	9	t
823	10	t
823	11	t
824	27	t
824	28	t
824	30	t
824	32	t
825	19	t
825	20	t
825	30	t
825	31	t
825	32	t
825	21	t
825	22	t
825	23	t
825	12	t
825	14	t
826	9	t
826	10	t
826	11	t
827	1	t
827	4	t
827	6	t
827	8	t
828	27	t
828	28	t
828	29	t
828	30	t
828	32	t
829	35	t
829	12	t
829	13	t
829	10	t
829	11	t
829	25	t
829	26	t
830	18	t
830	19	t
830	20	t
831	28	t
831	29	t
832	18	t
832	20	t
832	12	t
832	14	t
832	1	t
832	2	t
832	3	t
833	33	t
833	34	t
833	12	t
833	13	t
833	14	t
833	30	t
833	31	t
833	32	t
834	2	t
834	3	t
834	4	t
834	18	t
834	19	t
834	20	t
834	24	t
834	25	t
834	26	t
835	15	t
835	16	t
835	17	t
835	9	t
835	10	t
835	11	t
836	9	t
836	10	t
836	33	t
836	34	t
836	35	t
836	12	t
836	13	t
836	14	t
836	16	t
836	17	t
837	33	t
837	35	t
837	14	t
838	27	t
838	28	t
838	29	t
838	9	t
838	11	t
839	9	t
839	10	t
839	12	t
839	13	t
839	14	t
839	33	t
839	34	t
839	35	t
840	1	t
840	2	t
840	3	t
840	4	t
840	18	t
840	20	t
841	1	t
841	3	t
841	4	t
841	5	t
841	6	t
841	7	t
841	8	t
842	27	t
842	28	t
842	29	t
842	33	t
842	34	t
842	21	t
842	23	t
843	27	t
843	28	t
844	24	t
844	25	t
844	5	t
844	6	t
844	8	t
845	21	t
845	22	t
845	23	t
845	1	t
845	2	t
845	3	t
845	4	t
845	33	t
845	35	t
846	33	t
846	34	t
846	35	t
846	5	t
846	6	t
846	8	t
847	27	t
847	28	t
847	29	t
847	12	t
847	13	t
847	14	t
848	33	t
848	34	t
848	35	t
848	12	t
848	13	t
848	21	t
848	22	t
849	33	t
849	34	t
849	35	t
849	30	t
850	15	t
850	16	t
850	19	t
850	20	t
850	21	t
850	22	t
850	27	t
851	16	t
851	17	t
851	33	t
851	34	t
851	35	t
852	18	t
852	19	t
852	20	t
852	5	t
852	6	t
852	7	t
852	8	t
852	15	t
852	16	t
853	34	t
853	12	t
853	13	t
853	14	t
853	15	t
853	17	t
854	30	t
854	31	t
854	32	t
854	12	t
854	13	t
854	14	t
854	1	t
854	2	t
854	3	t
854	4	t
854	24	t
854	25	t
854	26	t
855	9	t
855	10	t
855	2	t
855	3	t
855	33	t
855	34	t
855	35	t
856	33	t
856	34	t
856	12	t
856	13	t
856	14	t
856	5	t
856	6	t
856	8	t
857	22	t
857	23	t
857	6	t
857	7	t
857	8	t
857	24	t
857	26	t
858	33	t
858	35	t
858	5	t
858	6	t
859	24	t
859	25	t
859	9	t
859	10	t
859	11	t
860	9	t
860	1	t
860	3	t
861	22	t
861	23	t
861	27	t
861	28	t
861	29	t
862	27	t
862	28	t
862	29	t
862	33	t
862	34	t
862	35	t
863	33	t
863	34	t
863	35	t
863	30	t
863	22	t
863	23	t
864	9	t
864	10	t
864	11	t
864	31	t
864	6	t
864	8	t
865	12	t
865	13	t
865	14	t
865	25	t
866	33	t
866	34	t
866	35	t
866	15	t
866	16	t
866	27	t
866	29	t
866	5	t
866	6	t
866	7	t
867	15	t
867	16	t
867	17	t
867	27	t
867	28	t
867	29	t
868	18	t
868	20	t
868	1	t
868	2	t
868	3	t
868	4	t
869	30	t
869	32	t
869	12	t
869	14	t
870	30	t
870	31	t
870	32	t
870	24	t
870	25	t
871	15	t
871	16	t
871	17	t
871	12	t
871	13	t
871	14	t
872	9	t
872	10	t
872	11	t
872	15	t
872	17	t
873	32	t
873	15	t
873	16	t
873	5	t
873	6	t
873	7	t
873	8	t
873	33	t
873	34	t
874	15	t
874	16	t
874	17	t
874	27	t
874	28	t
874	29	t
874	10	t
874	11	t
875	18	t
875	19	t
875	20	t
876	18	t
876	19	t
876	20	t
876	27	t
877	24	t
877	25	t
877	26	t
877	15	t
877	16	t
877	17	t
878	18	t
878	19	t
878	20	t
878	1	t
878	2	t
878	4	t
879	9	t
879	10	t
879	11	t
879	24	t
879	25	t
879	26	t
880	30	t
880	31	t
880	32	t
881	12	t
881	33	t
881	35	t
882	21	t
882	23	t
882	33	t
882	2	t
882	3	t
882	4	t
883	18	t
883	20	t
883	27	t
883	28	t
883	29	t
884	33	t
884	35	t
884	24	t
884	25	t
884	26	t
885	21	t
885	22	t
885	23	t
885	5	t
885	6	t
885	7	t
885	8	t
885	33	t
885	34	t
885	35	t
886	33	t
886	34	t
886	35	t
886	12	t
886	13	t
886	27	t
886	28	t
886	29	t
886	22	t
886	23	t
887	12	t
887	13	t
887	14	t
887	33	t
887	34	t
887	35	t
887	18	t
887	19	t
887	24	t
887	26	t
888	21	t
888	22	t
888	23	t
888	27	t
888	28	t
888	29	t
889	18	t
889	19	t
889	20	t
889	5	t
889	6	t
890	5	t
890	6	t
890	7	t
890	8	t
890	27	t
890	28	t
890	29	t
891	18	t
891	19	t
891	21	t
891	22	t
891	23	t
892	9	t
892	10	t
892	11	t
892	5	t
892	6	t
892	7	t
892	8	t
892	22	t
892	23	t
893	28	t
893	29	t
893	21	t
893	22	t
893	23	t
893	9	t
893	10	t
893	11	t
894	15	t
894	17	t
894	9	t
894	10	t
894	11	t
894	1	t
894	2	t
894	4	t
895	1	t
895	2	t
895	4	t
895	27	t
895	28	t
895	29	t
896	15	t
896	16	t
896	17	t
896	12	t
896	13	t
897	9	t
897	10	t
897	11	t
897	21	t
898	16	t
899	15	t
899	16	t
899	17	t
899	5	t
899	6	t
899	7	t
899	18	t
899	19	t
900	17	t
900	12	t
900	13	t
900	14	t
901	5	t
901	7	t
901	8	t
901	13	t
901	14	t
901	26	t
902	18	t
902	19	t
902	20	t
902	27	t
902	28	t
902	29	t
902	24	t
902	25	t
902	26	t
902	33	t
902	34	t
902	35	t
903	33	t
903	34	t
903	35	t
903	30	t
903	18	t
903	20	t
904	33	t
904	34	t
904	35	t
905	18	t
905	20	t
905	22	t
905	23	t
905	5	t
905	6	t
905	7	t
905	8	t
905	24	t
905	26	t
906	5	t
906	6	t
906	7	t
906	8	t
906	18	t
906	20	t
906	2	t
906	3	t
906	4	t
906	10	t
906	11	t
907	18	t
907	19	t
907	20	t
908	12	t
908	13	t
908	14	t
908	1	t
908	2	t
908	33	t
908	34	t
908	35	t
909	5	t
909	6	t
909	7	t
909	9	t
909	10	t
909	11	t
909	23	t
910	21	t
910	22	t
910	23	t
910	1	t
910	2	t
910	3	t
910	4	t
911	18	t
911	19	t
911	20	t
911	6	t
911	7	t
911	8	t
912	13	t
912	14	t
912	33	t
912	34	t
912	35	t
912	15	t
912	17	t
913	5	t
913	6	t
913	7	t
913	8	t
913	33	t
913	34	t
913	35	t
914	24	t
914	22	t
914	9	t
914	10	t
914	11	t
914	19	t
914	20	t
915	12	t
915	30	t
915	31	t
915	32	t
916	27	t
916	28	t
916	29	t
916	15	t
916	16	t
917	27	t
917	28	t
917	29	t
917	33	t
917	34	t
917	35	t
918	18	t
918	19	t
918	25	t
918	12	t
918	13	t
918	14	t
919	24	t
919	25	t
919	26	t
919	34	t
919	35	t
919	27	t
919	28	t
919	29	t
920	18	t
920	19	t
920	20	t
920	27	t
920	28	t
920	29	t
920	15	t
920	16	t
920	17	t
920	30	t
920	31	t
920	32	t
921	33	t
921	34	t
921	35	t
921	24	t
921	26	t
921	5	t
921	6	t
921	8	t
922	10	t
922	11	t
922	25	t
922	26	t
923	33	t
923	34	t
923	21	t
923	22	t
923	23	t
924	27	t
924	28	t
924	29	t
924	2	t
924	3	t
924	4	t
924	26	t
925	9	t
925	10	t
925	25	t
925	26	t
926	18	t
926	19	t
926	33	t
926	35	t
926	16	t
926	17	t
927	27	t
927	28	t
927	29	t
927	9	t
927	10	t
927	11	t
927	1	t
927	2	t
927	4	t
928	10	t
928	11	t
928	21	t
928	22	t
928	5	t
928	6	t
928	8	t
929	22	t
929	23	t
929	6	t
929	7	t
929	8	t
930	27	t
930	29	t
930	1	t
930	2	t
930	3	t
930	4	t
930	30	t
930	31	t
930	32	t
931	15	t
931	16	t
931	17	t
931	24	t
931	25	t
931	26	t
931	18	t
931	19	t
931	20	t
932	12	t
932	13	t
932	16	t
932	17	t
933	15	t
933	16	t
933	17	t
933	1	t
933	2	t
933	3	t
933	27	t
933	28	t
933	29	t
934	10	t
934	11	t
934	15	t
934	16	t
935	30	t
935	31	t
935	32	t
935	5	t
935	6	t
935	7	t
935	8	t
935	1	t
935	2	t
935	3	t
935	4	t
936	11	t
936	24	t
936	25	t
936	15	t
937	18	t
937	19	t
937	31	t
937	32	t
938	19	t
938	28	t
938	29	t
939	33	t
939	34	t
939	35	t
939	30	t
939	31	t
940	1	t
940	3	t
940	4	t
940	5	t
940	6	t
940	8	t
941	24	t
941	33	t
941	35	t
942	18	t
942	19	t
942	33	t
942	35	t
943	9	t
943	10	t
943	24	t
943	26	t
944	24	t
944	25	t
944	33	t
944	35	t
944	9	t
944	10	t
944	11	t
944	15	t
944	17	t
945	15	t
945	17	t
945	24	t
945	25	t
946	15	t
946	16	t
946	17	t
946	2	t
946	3	t
946	4	t
946	25	t
946	26	t
947	27	t
947	28	t
947	29	t
947	21	t
947	22	t
947	23	t
947	19	t
947	20	t
947	2	t
947	3	t
947	4	t
948	9	t
948	10	t
948	11	t
948	27	t
948	28	t
948	29	t
948	21	t
948	22	t
948	23	t
949	15	t
949	16	t
949	17	t
950	18	t
950	19	t
950	20	t
950	30	t
950	31	t
950	32	t
950	33	t
950	34	t
950	35	t
951	21	t
951	22	t
951	23	t
951	18	t
951	19	t
951	20	t
951	1	t
951	2	t
951	3	t
951	4	t
952	18	t
952	1	t
952	2	t
952	3	t
952	4	t
953	15	t
953	16	t
953	17	t
953	24	t
953	25	t
954	21	t
954	22	t
954	23	t
954	10	t
954	11	t
954	12	t
954	13	t
954	14	t
954	24	t
954	25	t
954	26	t
955	1	t
955	2	t
955	3	t
955	4	t
955	34	t
955	35	t
955	5	t
955	6	t
955	7	t
955	8	t
955	28	t
955	29	t
956	28	t
956	29	t
956	25	t
956	26	t
956	12	t
956	14	t
957	21	t
957	22	t
957	23	t
958	21	t
958	22	t
958	23	t
958	12	t
958	14	t
958	15	t
958	16	t
959	28	t
959	29	t
959	30	t
959	31	t
959	32	t
959	1	t
959	3	t
960	27	t
960	28	t
960	29	t
960	5	t
960	6	t
960	7	t
960	8	t
960	21	t
960	22	t
960	23	t
961	15	t
961	16	t
961	17	t
961	27	t
961	29	t
962	9	t
962	10	t
962	11	t
962	33	t
962	34	t
962	12	t
962	13	t
962	14	t
962	27	t
962	28	t
963	5	t
963	7	t
963	8	t
963	22	t
963	23	t
964	30	t
964	31	t
964	32	t
964	1	t
964	2	t
964	3	t
964	4	t
964	33	t
964	34	t
964	35	t
965	5	t
965	6	t
965	7	t
965	8	t
966	22	t
966	23	t
966	1	t
966	3	t
966	4	t
966	30	t
966	31	t
966	32	t
967	29	t
967	17	t
968	27	t
968	28	t
968	29	t
968	18	t
968	19	t
968	20	t
968	13	t
969	33	t
969	34	t
969	35	t
969	12	t
969	13	t
969	14	t
969	2	t
969	3	t
970	27	t
970	28	t
970	29	t
970	14	t
970	18	t
970	19	t
970	20	t
971	18	t
971	19	t
971	21	t
972	27	t
972	28	t
972	29	t
972	5	t
972	6	t
972	8	t
973	1	t
973	2	t
973	4	t
973	21	t
973	23	t
973	12	t
973	13	t
974	18	t
974	19	t
974	20	t
974	5	t
974	6	t
974	7	t
974	8	t
975	21	t
975	23	t
975	9	t
975	10	t
976	5	t
976	6	t
976	7	t
976	8	t
976	16	t
976	17	t
976	19	t
977	33	t
977	34	t
977	35	t
977	18	t
977	20	t
977	16	t
977	17	t
978	18	t
978	20	t
978	27	t
978	29	t
979	21	t
979	22	t
979	23	t
979	19	t
979	20	t
979	24	t
979	26	t
980	21	t
980	22	t
980	27	t
980	28	t
980	29	t
981	1	t
981	3	t
981	4	t
981	15	t
981	17	t
981	33	t
981	34	t
981	35	t
982	30	t
982	31	t
982	32	t
982	21	t
982	23	t
983	28	t
983	29	t
983	13	t
983	14	t
984	24	t
984	25	t
984	26	t
984	12	t
984	13	t
984	14	t
985	21	t
985	22	t
985	23	t
985	34	t
985	35	t
986	18	t
986	20	t
986	24	t
986	25	t
986	26	t
987	18	t
987	19	t
987	20	t
987	24	t
987	25	t
987	26	t
987	33	t
987	34	t
987	35	t
988	9	t
988	10	t
988	11	t
989	15	t
989	16	t
989	17	t
989	24	t
989	25	t
989	26	t
990	18	t
990	19	t
990	20	t
990	27	t
990	28	t
990	29	t
990	5	t
990	6	t
990	7	t
990	8	t
991	6	t
991	7	t
991	8	t
991	9	t
991	11	t
992	21	t
992	22	t
992	23	t
992	26	t
992	33	t
992	34	t
992	35	t
993	31	t
993	32	t
993	9	t
993	11	t
994	6	t
994	7	t
994	8	t
994	12	t
994	14	t
995	13	t
995	14	t
995	15	t
995	16	t
995	17	t
995	27	t
995	28	t
995	29	t
996	24	t
996	25	t
996	26	t
996	9	t
996	10	t
996	11	t
996	18	t
996	20	t
997	21	t
997	22	t
997	23	t
997	3	t
997	4	t
997	27	t
997	29	t
997	25	t
997	26	t
998	27	t
998	28	t
998	29	t
999	21	t
999	23	t
999	27	t
999	28	t
999	29	t
999	5	t
999	6	t
999	7	t
1000	18	t
1000	19	t
1000	20	t
1000	9	t
1000	10	t
1000	11	t
1000	5	t
1000	6	t
1000	7	t
1000	8	t
1001	27	t
1001	28	t
1001	18	t
1001	19	t
1001	20	t
1002	18	t
1002	20	t
1002	1	t
1002	3	t
1002	12	t
1002	13	t
1002	14	t
1003	3	t
1003	4	t
1003	27	t
1003	28	t
1003	29	t
1004	27	t
1004	29	t
1004	18	t
1004	19	t
1004	20	t
1005	15	t
1005	16	t
1005	17	t
1005	21	t
1005	22	t
1005	23	t
1005	7	t
1005	8	t
1006	16	t
1006	17	t
1006	12	t
1006	13	t
1007	15	t
1007	16	t
1007	17	t
1007	30	t
1007	31	t
1007	32	t
1007	21	t
1007	22	t
1007	23	t
1008	15	t
1008	16	t
1008	17	t
1008	5	t
1008	6	t
1008	7	t
1009	30	t
1009	32	t
1010	1	t
1010	2	t
1010	4	t
1010	30	t
1010	31	t
1010	32	t
1011	27	t
1011	29	t
1011	1	t
1011	2	t
1011	4	t
1011	30	t
1011	31	t
1012	15	t
1012	12	t
1013	22	t
1013	23	t
1013	30	t
1013	31	t
1014	13	t
1014	18	t
1014	19	t
1014	20	t
1014	33	t
1014	34	t
1014	35	t
1014	30	t
1014	31	t
1015	15	t
1015	16	t
1015	17	t
1015	24	t
1015	26	t
1015	21	t
1015	22	t
1015	23	t
1016	18	t
1016	20	t
1017	5	t
1017	6	t
1017	7	t
1017	21	t
1017	22	t
1018	12	t
1018	13	t
1018	14	t
1018	18	t
1018	19	t
1018	20	t
1019	21	t
1019	13	t
1020	24	t
1020	25	t
1020	26	t
1020	21	t
1020	22	t
1021	9	t
1021	10	t
1021	11	t
1021	33	t
1021	34	t
1021	35	t
1021	7	t
1022	6	t
1022	7	t
1022	8	t
1023	30	t
1023	31	t
1023	32	t
1023	19	t
1023	20	t
1024	19	t
1024	20	t
1024	30	t
1024	31	t
1024	25	t
1024	26	t
1024	12	t
1024	14	t
1025	1	t
1025	2	t
1025	3	t
1025	4	t
1025	9	t
1025	10	t
1025	11	t
\.


--
-- Data for Name: user_types; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.user_types (id, type) FROM stdin;
1	Admin
2	Estudiante
3	Instructor
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: egilmore
--

COPY public.users (id, name, lastname, mail, register_date, password, user_type) FROM stdin;
1	Petey	Poppy	ppoppy0@loc.gov	2024-10-16 06:00:24	$2a$04$4mTE8uQTmkyGAIA1LbCNoedtd2jW6xylS4w5zRsVzrIenIxqSquju	1
2	Miller	Abrahamian	mabrahamian1@bbb.org	2024-06-24 12:42:08	$2a$04$Wn.IzFyDXBct521owIdjZOtS/h10suYv1L0VphVEhswn07XZhrI.S	1
3	Toby	Escalera	tescalera2@intel.com	2024-11-21 15:46:44	$2a$04$rDU9AOz8BjCPh09N4uDJfunTi8DGXUiCwDCf2C1ylq4FXuYgw.JKG	1
4	Tomasina	Cockerell	tcockerell3@sakura.ne.jp	2024-08-25 22:59:32	$2a$04$OAzahTjUwubPwvBG80.enOXBetmrRRS/xt8wNLNaaUu8fScGPnkBa	1
5	Lennie	Goldsberry	lgoldsberry4@github.com	2024-09-21 10:03:02	$2a$04$jo4c7LDK0yUyoGYeyV.8..Gih7rjumoKVouksP5jSs77js55FEF1a	1
6	Simone	Greener	sgreener5@theguardian.com	2025-02-26 10:21:01	$2a$04$09B4nj1aAUzPsTJSKXxQ7exaG0noUZajAEJZtWcdJlh7USl/xfHnC	1
7	Kristopher	Wegenen	kwegenen6@hc360.com	2024-12-20 18:55:37	$2a$04$9OZpcYIo3qa/X5lFSObhp.XxVgmoaq.C73dFCcnQnsv1G9p5Ibtem	1
8	Davide	Suche	dsuche7@addthis.com	2024-05-18 18:01:02	$2a$04$2k7msO7p/LA8q8L4glyHxOua.f0Q8Zeb2P94HLfXHsoGVA/U2CcI2	1
9	Hyacinthie	Aprahamian	haprahamian8@photobucket.com	2024-11-16 04:16:13	$2a$04$exgEfo4SAMpJ8JFYlegkNOrRNmDWBGOCf6EfJ7N2SJO8O86YSeyKu	1
10	Priscella	Sebley	psebley9@chron.com	2024-07-04 23:27:26	$2a$04$i0jR6WaE8Rzjec//hdb37OkvYdPwPRNqy66j0Jd0JJ4NgnM3UH35K	1
11	Flss	Barney	fbarneya@tripod.com	2024-09-02 23:24:45	$2a$04$DpTRP2fRX5xudOPsR1NMY.Adht8GyRfFlCnyA2TbwN5.v2SPOh//6	1
12	Blondelle	Habercham	bhaberchamb@linkedin.com	2024-12-20 22:40:57	$2a$04$PSF9MwJHgm4mOl7Ysq.wXuh3eCx5/a2PW8VYSxYCEtNIUDRD65MJq	1
13	Florentia	Canario	fcanarioc@bing.com	2024-07-20 07:24:07	$2a$04$obFihI3p8ylpTKYZjtqFaOvIPRMgQsk2LgY35gIsRfT0KqvsLDcFW	1
14	Leonanie	Garroch	lgarrochd@youtube.com	2024-03-16 08:57:29	$2a$04$3X2qZsN23VtDACEO5GF48eFjOvmnJYuLv2Nru19ljqzRGfFEoFiV2	1
15	Dorita	Huffadine	dhuffadinee@hud.gov	2024-05-11 16:59:23	$2a$04$6JMOl4ljV.gxWpB9Zs.IlejLfJTNKpiPG8f/ntCXZKa65.p9N56se	1
16	Thom	Morteo	tmorteof@china.com.cn	2024-04-18 01:37:33	$2a$04$C.k7vOfh/pNTEctAtbGSIuNbSse8ZCax2/5H6HoWxRlDkjGJOiZ.6	1
17	Sloane	Morphew	smorphewg@live.com	2024-06-25 05:22:53	$2a$04$alPZ/QSHPVa1xaE388w8OeTDgvE0FHI4c40qHNd7yO9WPtuqqtz92	1
18	Zebedee	Lukasen	zlukasenh@dedecms.com	2024-08-28 06:55:55	$2a$04$Xf5T1DP3Ry.9fcMS5zdMNuE6PAGhsPr4geR1sTWNlexciyUnDfR3u	1
19	Deny	Koba	dkobai@ftc.gov	2025-01-06 19:21:09	$2a$04$sm1segWnqkAxrGJ/bFaEheVkfEA0U6Y1Z/zIqX6CtqXQXKBWvlEju	1
20	Sherlock	Ianitti	sianittij@mashable.com	2024-04-13 13:52:14	$2a$04$PRg97r3Ba.34ZAOZ4Z49FerLvx5MiVoVu2Gw9UgMq8xblkLJRI.zm	1
21	Krystal	Vaughn	kvaughnk@hugedomains.com	2024-07-19 15:14:19	$2a$04$1fEh.1D4NtcqyaoDrmuJyezsiTRHrrfl8rTIuKEIP2BmsPrD0yuxW	1
22	Cleon	Sybbe	csybbel@comsenz.com	2024-10-05 12:00:08	$2a$04$U.B2MR2XeUTl3xERWaW5x.BNgKhq9Q6hdSzM0ktxkmx4Fkr0IZUUC	1
23	Gav	Callicott	gcallicottm@youku.com	2024-09-08 06:57:45	$2a$04$BByTJA8zELianQYUiIIQ1e6eWOjNuF9sadd5jxZIOghYy/eDNXQ1K	1
24	Elvera	Ropert	eropertn@blogs.com	2024-06-10 04:12:39	$2a$04$r0H4Fco8zoe4yySXHjZ7GeR/rHRHphUmNTrcAyrFiSDDPAOg2mMma	1
25	Zack	McBrier	zmcbriero@stumbleupon.com	2025-01-15 20:21:13	$2a$04$rNqafB11hCthA8/KWBqiyep/KaVwRp25kwf7FmzDq0440pVDKtzU2	1
26	Renata	Weekes	rweekes0@etsy.com	2024-10-09 08:20:03	$2a$04$YgNcw2OuUiSnD5WTJHhGPuHlPmmypkw9HkzUIZunweycaMak1.65K	2
27	Margalo	Follis	mfollis1@japanpost.jp	2024-12-11 22:25:05	$2a$04$t4GF/QiWpyCR8gUvqBbKyOJQ7Z3ihfhOW8CxcDIFpvgbXunUte4ou	2
28	Oliy	Bromehed	obromehed2@gov.uk	2024-06-22 22:06:20	$2a$04$mqTKAc6qom2flFHAevvN1utaeDVLJ7/nhahBC7bFWMGoBVmmq1uCy	2
29	Cathrin	Himsworth	chimsworth3@php.net	2024-07-08 16:03:45	$2a$04$N4dNUhefhBDU8ckWP8sp/.6L.36pV43vmzJ1HKET34ulGCTXaQQT.	2
30	Julius	Torres	jtorres4@nih.gov	2025-03-01 21:24:50	$2a$04$td/tFtH9wva2KJyTfhjCEeK2p251XbUJC28HJiptkiYx7kljv63Nu	2
31	Jolynn	Tourmell	jtourmell5@intel.com	2024-08-04 15:43:50	$2a$04$b2t0o4mZ8JAEBGemgR7bUe3rp3EslvuwbBcHRgwjBuPaIHt393DyW	2
32	Theodore	Standring	tstandring6@webeden.co.uk	2024-10-02 16:55:01	$2a$04$AjqTeomVA/NMoIGu0SlAwu1r/BNQMdzQgHrNZwAr8/ypVUTx1b10q	2
33	Melamie	Cremer	mcremer7@msu.edu	2024-05-24 03:54:20	$2a$04$hFYPcgtOSnrQsGWvgBAil.cVhy2Ddcggoiaksg83zD4ybj12mjf8u	2
34	Talyah	Greenmon	tgreenmon8@creativecommons.org	2025-02-16 20:51:35	$2a$04$Jhu7eR8vyvi3EpIdE1.BEeh9AL/m4FCIkZizOlvXnGF4oE/2t83UO	2
35	Nichol	Hazzard	nhazzard9@g.co	2024-07-05 17:25:12	$2a$04$8b2C938s8K5Hebamy07sdek9Z9oqTIkDBXh4Cthsd0CkOawxvKQ8e	2
36	Daile	Chessill	dchessilla@tuttocitta.it	2024-11-18 02:25:19	$2a$04$UYKrMcqSPP0EkvqQUzmMhOvgbT57abqpD6S7dyuesw0ajBf16sr5a	2
37	Sammy	Sergeaunt	ssergeauntb@youtube.com	2024-11-16 16:23:14	$2a$04$4KavjapXnQL3iP6VyVBUPOXWeNwrbQGmZa93pTFh8SeoumZjedLC2	2
38	Town	Collister	tcollisterc@furl.net	2024-05-30 15:10:54	$2a$04$uWxppi5x5Gjp1eMLWjaVPeIYwNfiBcAbudpfiDEgi3LVwpUucf2GW	2
39	Tiebold	Delete	tdeleted@mac.com	2024-10-28 11:22:49	$2a$04$JORC1G9X8rAo9/3rVHLuGuwkElRtG.HX4/8/1i.VblLQB3CUWynG2	2
40	Sanson	Lages	slagese@hhs.gov	2025-02-21 08:38:40	$2a$04$YtEMbs7TIW7XeBOpUsLodO3e6vy3J1Yw5aqYswxbcnI/TW/megMwi	2
41	Eyde	Crecy	ecrecyf@kickstarter.com	2024-03-08 22:36:19	$2a$04$eCklNdPR3EtuSGH5K/rpOuyKUZcUFXtlMnsaNM9PSNyHy3ucQYXxu	2
42	Mickie	Papps	mpappsg@arstechnica.com	2024-08-25 23:08:47	$2a$04$1hVyfLj3wj11oy6Kg7f.I.kOWG3DviVH.ZCp0yihjaSuIQAaT9uge	2
43	Arlene	Drieu	adrieuh@moonfruit.com	2024-06-24 18:12:56	$2a$04$k72d04P/HW4LeQ4bYmFmYusSOSrD4XeGIYITGzyw/lLBus0qbF072	2
44	Terry	Gouinlock	tgouinlocki@cpanel.net	2024-08-18 23:47:49	$2a$04$JfbujhZi/ob1DBZMOiq/lOgJfCLfYofSH2ja9oQgAEjxq4wNvv9JK	2
45	Shanda	Roath	sroathj@adobe.com	2024-07-19 00:42:00	$2a$04$55CY7N9vMLJgcnUqQQjOOuC.F6.CaESBIPpH08g9kVuOfaVQEHs4a	2
46	Hortensia	Taffurelli	htaffurellik@globo.com	2025-01-12 20:10:56	$2a$04$ojtkuZIcAe2mj2pgupi5IexZxDngO2nI2qW8DjLCoa2FROH/fEc26	2
47	Donaugh	Nockells	dnockellsl@ustream.tv	2024-12-23 09:32:00	$2a$04$RrCZFWJn3I/qnffo5WClme8eDWIOMqd5TrYMd66RRqHpf/M3ojjUG	2
48	Patin	Wiffen	pwiffenm@smh.com.au	2025-01-11 08:03:35	$2a$04$INv8zlRm4pcnc245/F/SgOAq3bNA0ku5m0rwE0CRJVg7ehP/IGBmq	2
49	Glenn	Costock	gcostockn@over-blog.com	2024-04-24 17:28:14	$2a$04$mE.LtWbFi0RcRdGbkdsCIuRSwQhZHFl3Zint8cxm1oWkfj.D/ddC2	2
50	Burtie	Vaadeland	bvaadelando@paginegialle.it	2024-05-12 19:20:58	$2a$04$ZDDk1Z0n1nOltwJ6.K2vNucBQSZY8g/ncx40f6tLusSf5bqqzRujW	2
51	Karyn	Maun	kmaunp@simplemachines.org	2024-12-19 15:47:55	$2a$04$18gbT4A0/r23xgFRKpKMquXRjII9E7JxJ7wpjX1kstOS37.nEgKH2	2
52	Josefina	Trillow	jtrillowq@joomla.org	2024-11-17 19:19:51	$2a$04$dKq6Xe7ObIvCXLfCChOCzuZxM9TMkGalarvJQzzvdD0hLJSVrT5Gu	2
53	Leisha	Dumbarton	ldumbartonr@howstuffworks.com	2024-11-23 16:25:02	$2a$04$Yh7KaQS9/M4LvxB/iyrBMOtuSVzjdeYm9L4MrATBEzYFKeOWPMCta	2
54	Elvera	Wiltsher	ewiltshers@epa.gov	2025-02-26 20:30:36	$2a$04$MQwzSu5.kvMTAtZh4aYSRe8JDD5.xrTDogoCdZyLFRcrDtJEORaka	2
55	Gleda	Kilcoyne	gkilcoynet@oracle.com	2024-12-25 01:39:16	$2a$04$YljIzD61ZamVyjIfcyiT4uP5xSegJ0.9HLVkNkO7bWc.XdEatJIQG	2
56	Geraldine	Regis	gregisu@istockphoto.com	2024-12-04 08:04:08	$2a$04$ami83snttOfqYuhWgSuXp.ytebv25d30AojeHC.s16uOzxm4ZIVl6	2
57	Trevor	Hargreves	thargrevesv@unblog.fr	2025-01-25 22:06:46	$2a$04$yZgse.cr27InaYipzCNnw.0gMIl1/fqU5DVSzl0zORZOxodZcqtwa	2
58	Michaela	Cassy	mcassyw@discovery.com	2025-01-15 03:10:20	$2a$04$u7GDiUk5S4DCDe.kLUrq8.Rws51Ew4NeDO4RnjbbV2heZs7lxHLLW	2
59	Blanch	Gaber	bgaberx@about.me	2024-07-13 12:47:02	$2a$04$cf3DQ/TY50VdiOZd8TDbzemB.0Jb.gQXAc8eEYuhUacaZfEQRFwYS	2
60	Kiel	Neame	kneamey@cloudflare.com	2024-10-19 05:43:28	$2a$04$N/FW1ZhtccSEBLh9UjENlOakiw1C3HBl8WtLQMm3q4.9pId0OyR32	2
61	Harris	Caccavale	hcaccavalez@springer.com	2024-07-19 01:40:10	$2a$04$yJE0uRtWqqXkh5I2HBkwY..ij/N2BkLAP/ukm2.96JUc9SP0JD5pS	2
62	Lyle	Rhead	lrhead10@parallels.com	2024-05-16 20:09:24	$2a$04$qH623WuONubID0BrPPx.deQ0D5lSPr9/nmETiczm2RKTdunavF0Cq	2
63	Sophey	Gouch	sgouch11@t.co	2024-07-21 08:20:02	$2a$04$K4pzwHOXbgU/LP71WhnSBOOr5vhF7aqOEB0Z6H1gw0MdjQ2xQxctq	2
64	Onida	Djokovic	odjokovic12@photobucket.com	2024-11-08 12:12:01	$2a$04$U5tjMji8LhlCNkK0hIo3I.oW6/LiUiHRsoxnQlMKN7AnqP9MdlAWi	2
65	Frayda	Kayley	fkayley13@usda.gov	2024-12-30 14:53:44	$2a$04$bQAsI6JOPhYBr1.a/LAgHuENIAxJajneUqqkG3HzJSUwK4YLEHs/6	2
66	Olvan	Isles	oisles14@php.net	2025-02-07 05:12:32	$2a$04$kVrcwKhPATcVSUphXgP7yObwFKWNslHIQl1q5.XWkE4LADqmZ3pQy	2
67	Jordan	Aggus	jaggus15@surveymonkey.com	2024-09-12 08:12:40	$2a$04$buKxOHahuEJ0.Tn88updg.mCzw0s66DaG6cTe8Knoojbh3qfzQv12	2
68	Ogdon	Grasha	ograsha16@stanford.edu	2024-09-18 19:16:01	$2a$04$KTEc9sfWtTZ7KjKRqFhyg.T5G.lfg/BJ1TYHcDQ3PSU3bNkZ7Sm4q	2
69	Etty	Merkel	emerkel17@prlog.org	2025-01-25 09:33:14	$2a$04$rZn4AoypzonMswQVXbwa6OH0SWAsWGpnrQ7/RiPfEvnodnt6rzY72	2
70	Elana	Hyrons	ehyrons18@who.int	2024-07-14 07:36:59	$2a$04$feQROHbEtxZOS7jLtND.bOfHFl1kH3Ng3F4S9kApKiYYFWUE6rhEm	2
71	Carmita	Mead	cmead19@earthlink.net	2024-06-09 07:03:27	$2a$04$0c.bYZ0zUCcZPKNrkxBjLelQaijLwEkBnLaUf4RLXQLJ1UC1Rb3g.	2
72	Ty	Fluger	tfluger1a@canalblog.com	2024-04-19 19:37:07	$2a$04$iUn4J3FNCa7heLc8JamSYudkQMfuYh7XD9TEQVY3UXDewcQh.CN2O	2
73	Alexandra	Blais	ablais1b@go.com	2024-10-06 03:28:14	$2a$04$VUNldB7cpElYezj/SWokuO3GSqAyixoSWo7f9YY6XJf.Mg5HxKw1G	2
74	Mathe	Frusher	mfrusher1c@furl.net	2024-03-20 12:52:32	$2a$04$ZUIvczwag3HgBxZTbR1/6.iJeV4gr8YPIe725rvPJ.M1gum.wTz.6	2
75	Rhona	Sinkinson	rsinkinson1d@salon.com	2024-09-29 08:27:18	$2a$04$8jeF0HJvij3.QOJUlI9jj.HBqw8aZ1WQP7TX8707TMiLVtjiiC4YW	2
76	Alexandro	Travers	atravers1e@feedburner.com	2025-02-22 05:48:48	$2a$04$bsSKQ98AxNOakGRNZ0YiuecTMhN81D7yqZ.otgbsbGgH1XWAgoibm	2
77	Roland	Ceney	rceney1f@comsenz.com	2024-11-03 23:59:37	$2a$04$YeCFs3nTfvTZUrQ28PIZfuJed7/Bbrnu72qkmIeTdEiNok2ffFEai	2
78	Lorry	Boorman	lboorman1g@newsvine.com	2024-05-21 05:59:56	$2a$04$uCDKkzUhIKMyqeUENRiAnO/ooUkS8p6J6SNx/zAP.K2Rej/p/Nmzu	2
79	Allen	Mylechreest	amylechreest1h@sakura.ne.jp	2024-07-10 16:45:01	$2a$04$iSbLX5HQtKrVVkLtPDjT7e5cK5aZJNql5B41jRhZjvwnsDVVEjU.O	2
80	Candida	Guilford	cguilford1i@buzzfeed.com	2024-09-01 05:50:20	$2a$04$R2sEOh2Xk2f4f0Y4oKi6X.aFEg0CaDqIHDY29gabUX6tRiJFqim7m	2
81	Mindy	Pennicott	mpennicott1j@nyu.edu	2024-12-23 02:50:24	$2a$04$OSCFon9mVDIhNO13Eo.WxeVV1gmqWxUHeUyNAVeTzh/lK4yrG0nZa	2
82	Rochella	Nizet	rnizet1k@mashable.com	2024-06-24 18:23:49	$2a$04$hzD8D6WqLRC19mtXJ8aLkeRCSXmqum9JKZ.E6CLTJ2IIFZBIfwksG	2
83	Geordie	Vern	gvern1l@hexun.com	2024-06-15 19:37:20	$2a$04$bNcAO9aRRKMalbKUg.183uS8megOaSSqsbS637j/082GGayA6e14y	2
84	Cynde	Leppington	cleppington1m@springer.com	2024-05-15 14:43:14	$2a$04$7kXdwS8iqy78PuSptuNtju2j5J2s5qlKU9907YOtM01gtW1b/CF5q	2
85	Hanna	Cordell	hcordell1n@opensource.org	2024-08-06 12:25:20	$2a$04$oLCvjNcoWrTIKJkTY0sLC.tOoviWbHoISfaw8.gyWaQlQGG9r69oa	2
86	Renard	Chaudret	rchaudret1o@opensource.org	2024-04-22 21:25:46	$2a$04$W7jZYjU4MfxwQ.z2k10HVesJo2edFJLkJWVZ3QneIJzK5diMlrY3C	2
87	Alyse	Ondricek	aondricek1p@cisco.com	2025-01-07 21:22:25	$2a$04$qyrOdm7hcdzdXadX6QHPjul0jBhwLgu6iaf3ca2aEllAhgVNWy7Ri	2
88	Wadsworth	Dodwell	wdodwell1q@imdb.com	2025-02-24 04:07:49	$2a$04$/fKuFYDQMOXWUTnMSzc0XO14sSZki9tZeNG8nIWGVzTc9e7Y34oIe	2
89	Tabb	Gasparro	tgasparro1r@ocn.ne.jp	2024-05-20 06:04:58	$2a$04$9xSYk0tbrsa9R7y1nMv/TeesYIy7AJT.H1Nud04AcVQbhFU11IM1u	2
90	Packston	Mawne	pmawne1s@ed.gov	2024-12-10 01:00:49	$2a$04$VJ8e8rEw1RaZv2Bchzcrc.rFzAer.5xn7mMOvvfgMg/fmhUMU2pPa	2
91	Querida	Murra	qmurra1t@harvard.edu	2024-06-21 22:03:37	$2a$04$NKsF/r9Tf5DIDYn28ze5Hea5YAiRQLFys1nUH/esgWob4HRc4rkCa	2
92	Chris	Pendle	cpendle1u@techcrunch.com	2025-02-10 02:06:43	$2a$04$bANU62GtjVlUDr9IEIyzceZFDthglIqc5O1rcB.rBXdffMLSSVNxS	2
93	Christal	Juza	cjuza1v@foxnews.com	2024-06-21 19:24:19	$2a$04$yRUOa/KFPWj2KnbcdC2OD./Wf5It8QvbJUeAHRgDmIQQnLP8.gwwi	2
94	Angelo	Luesley	aluesley1w@engadget.com	2025-01-13 10:19:28	$2a$04$aTqt2tFMp361UbpXgzvW7eYocR2.tHJxmerf7CAnQht5fnj4TZ.im	2
95	Melessa	Weine	mweine1x@ft.com	2024-03-10 06:01:59	$2a$04$bWJ/Nvstn.V4EG2v53hYae0U4xSRGhdZB07lotiE6T8oisTf6xlT.	2
96	Tracee	Balloch	tballoch1y@deviantart.com	2024-04-28 16:27:31	$2a$04$l2s6iTkxXrc9DMN2tMajbu5CvzYjGC2nv47erhksVQl/0IqNweo46	2
97	Tim	Dougill	tdougill1z@techcrunch.com	2024-12-29 03:06:55	$2a$04$tC7PNtVYgd1uZ6a1kSxAsefz40Htqc5JWE.wil9aAJHpsWIEMJE2i	2
98	Shaun	Sealy	ssealy20@moonfruit.com	2024-11-25 18:17:29	$2a$04$00QNsA/ZXF4Y0Xs/PqEXWO2ENKt9GyKJ0PUtj7Ilxr.DYYgiCep0q	2
99	Manolo	Howkins	mhowkins21@twitter.com	2024-12-13 20:34:44	$2a$04$t/r8PeZV2ZISNO88saXoT.Z4ZbBh7tQur.kH7Y61v5vR6HZpSDC8W	2
100	Rutledge	Comazzo	rcomazzo22@state.tx.us	2024-04-13 23:20:48	$2a$04$Ii8gEvJIvoeWz0UxVPneEe.fcSHULAFhFqI.9HT9s932/s1gNY6Q.	2
101	Erina	Canaan	ecanaan23@cam.ac.uk	2025-01-31 06:37:45	$2a$04$3k8317.hEAvtyALGZNXxDuIC7TkLs2jPqSz7OcUTOpZPejKvkub4m	2
102	Dannie	Houson	dhouson24@deliciousdays.com	2024-12-27 13:14:10	$2a$04$R/GpZICyB8bc/JGTYlfBnOB9Cx6khIq8aI.qK8iOlEtzsQhiSqXvW	2
103	Susann	Snellman	ssnellman25@cisco.com	2024-06-18 13:03:02	$2a$04$RT1b.eM9cFqEL/VdmxfpveC9DbWSQ5V/4Xp.M/1woAE.LpeM6hDne	2
104	Wally	Carrabot	wcarrabot26@xrea.com	2025-02-14 02:57:00	$2a$04$G2f/VBCpxYpfLNmrZOtClur3DFdl3SSZ1Qc2F8GNUbPbRbb3ptVh2	2
105	Noah	Domel	ndomel27@cmu.edu	2024-10-30 11:30:39	$2a$04$bJP4DKpIK4DsMVzUBuicAu9OrPM9oTxekYe5p1hV2/uW1Jq30mI8u	2
106	Stacey	Gatecliff	sgatecliff28@samsung.com	2024-09-05 09:52:40	$2a$04$FIm4i8.OW7S7mZA4FjvMIuIfxRpIMCGWtYvnabidQiRhHBkAITvIO	2
107	Bradney	Ludvigsen	bludvigsen29@privacy.gov.au	2025-02-01 14:36:51	$2a$04$dhnKnv4Ch7vCZaMvZLXy0uSl02X4luDaMr/IdRe7WaBFVByIdTt9C	2
108	Lannie	Maskew	lmaskew2a@meetup.com	2024-10-16 00:05:35	$2a$04$B46utrSiVjmhQ65.gE8zX.7h0ubWJCeg7w4C/q.F4ibhVO738zcq6	2
109	Amber	Lindl	alindl2b@i2i.jp	2024-04-14 17:58:53	$2a$04$jIRrRg4MCM2E247SpB7DMuswdVtvOS0vsRgtJzel6MvBzydxFoEZS	2
110	Cynthy	Tutin	ctutin2c@mlb.com	2024-11-21 17:09:38	$2a$04$OrMCYbBJzNI7QRJl1vM1lu8vlxXi6fa5LSPI2v2tKRqQslGdAK9yK	2
111	Michaela	Kiessel	mkiessel2d@ameblo.jp	2024-07-14 17:53:28	$2a$04$9M8JmwS8m0axkDXLV0luXefLi826QnSeDO1PiLifSSAENvrwv0nWG	2
112	Arel	Curme	acurme2e@msn.com	2024-08-10 14:02:02	$2a$04$MHtMZm9zxywpJKYQLD/oOena8UivANrAPkVnbK7CbbZ1ffxEj4c0i	2
113	Jenna	Feckey	jfeckey2f@accuweather.com	2024-10-22 07:17:13	$2a$04$7ZlDvapiZkxfILW.jCo0FurtnEKkhrlbR6tHsRK.DyXKvLPTeXu.G	2
114	Diego	Cromleholme	dcromleholme2g@devhub.com	2024-10-12 19:19:47	$2a$04$yeLjCiwpQLDAITm8o/GkFO49mx.qMMkfvISu1AEzj4paf5UGNQ0/y	2
115	Alix	Stoyles	astoyles2h@simplemachines.org	2024-04-18 06:26:44	$2a$04$FGbWdCPa8I5LEzWLZ0Az5OaWN2ryT8A.2LS3pv3i.MXMGrZ7IWGE6	2
116	Ryan	Durnell	rdurnell2i@spotify.com	2024-11-03 03:22:04	$2a$04$qOmPb2S768rAgid/tfU6RehvdbHGH1RTbmKwkuL112jvfNcAD8Oa.	2
117	Ruth	Middle	rmiddle2j@usa.gov	2025-01-26 16:19:12	$2a$04$QeE7QYQ50CVqxn53YKlwNOJykGa7TTIztnXc81AamTTl1FIU7oRue	2
118	Lind	Wagg	lwagg2k@de.vu	2024-03-22 01:38:42	$2a$04$Ipe8Yz2bBFi8mWgU.TqLK.yGkTfQbfyFO.aPRB0yjwe.y6Q0oGhJO	2
119	Cathee	Simmell	csimmell2l@whitehouse.gov	2024-12-10 13:28:47	$2a$04$9n/BWciCNUFIpCTaT1BJn.IdSAg22iN5HuwRHxqzIpGPsXMmrDE3u	2
120	Cacilia	Shimon	cshimon2m@51.la	2025-01-17 07:31:03	$2a$04$9NuAXux3z4aEHxlcG/LR3Ooo5Lt5kr1wK83xwOYBfOp2nDDUnM.G.	2
121	Regina	McClymont	rmcclymont2n@furl.net	2024-11-16 14:36:21	$2a$04$//mvFF8676mmUf1RL0HXA.QNptZm2LGLrbYEDLYPu1p8XXPykGMq2	2
122	Jorrie	Marcum	jmarcum2o@dedecms.com	2024-12-19 02:32:51	$2a$04$8xuz/p/m6tHzB37HjLGPEeL3uxCzqY5Vei2f4LIJTkVvpgR21JXRi	2
123	Chastity	Jorgensen	cjorgensen2p@amazon.co.jp	2024-08-12 14:08:47	$2a$04$mL0bk14DL7qZ9QY8JGA2IeVaX3SdeptfTtb545viCtaFaF90w.UmS	2
124	Halsey	Spry	hspry2q@cnbc.com	2024-05-02 15:27:54	$2a$04$ni8YczG37kgUw5clMNSiou/qM3b3lQxueJL1d3Zdo697eUJm4RISu	2
125	Dorelia	Tanser	dtanser2r@goo.gl	2025-02-07 00:14:02	$2a$04$mAjWpqhlwbiX.VTZJ5PK7uSv/XExLzKXFsyOZuh6yYLt7FONCyVZa	2
126	Jennine	Meehan	jmeehan2s@jugem.jp	2024-11-20 14:33:05	$2a$04$eiREMuur00TJ7HaQcgFz2.E3QvFxIt1xMKbwQH4i.PyndCN8AjLWe	2
127	Consolata	Beeton	cbeeton2t@taobao.com	2025-01-04 23:05:39	$2a$04$CnGtJ/K9LxNcBYJxgc3dFONTu38vSmpwdUbXFooAhSXSGzcmUnjeq	2
128	Elsey	Benbow	ebenbow2u@marriott.com	2024-09-24 22:50:40	$2a$04$wSXNbe4S0nMAyq67ho.YRu111LzmzugECtYg6zYgJ0QmoxiE78FgG	2
129	Brianna	Medcraft	bmedcraft2v@wsj.com	2024-09-24 14:12:16	$2a$04$dd1a88.IfG9SI1oEoyLmUuDnfMuGnHSkspY/NnxV3Y3o5luYzXoSq	2
130	Valentina	Taylder	vtaylder2w@abc.net.au	2024-10-26 19:41:14	$2a$04$T/LWQiUInIK4TIfUQobXGuzm29Bc15JJ/20HGQt.69NgHc337o6KC	2
131	Tobe	Chewter	tchewter2x@constantcontact.com	2024-09-18 11:14:49	$2a$04$OuiqB631EY9yiUmP0HFQIeSlDePufRJxfgWsZq8qyOB3fcSgD5uki	2
132	Bron	Lillegard	blillegard2y@timesonline.co.uk	2024-07-28 13:25:37	$2a$04$VksUne0rQwsXTWc35tH6ue0NHH75BdKUl0EF8R0e2uOSq7YOki962	2
133	Chloette	Bernardez	cbernardez2z@reuters.com	2024-05-26 16:53:48	$2a$04$ClCzPDzBM68r0eC/rtZ0yuahTupJShJNNrnefqq7A7P0TlWhSm3ge	2
134	Abrahan	Stollenberg	astollenberg30@amazon.co.uk	2024-04-08 16:56:26	$2a$04$a4nn6T/7Xxzr0K/.pSH/h.8fu5OfccE2H/YbtnQ0TCfzcOTJdviai	2
135	Annette	Lyal	alyal31@cocolog-nifty.com	2024-12-23 09:59:35	$2a$04$UZSH2LnjcQHypGofOSEILuaj.3vq0hFKKkPA7wiUxLnuiJGpOSN5m	2
136	Dede	Lomasney	dlomasney32@tuttocitta.it	2024-10-27 08:39:50	$2a$04$aEtD6M2RUq8sPCGkIZzrkupMY0JXqTn3ivV6xZLFcgZsC7b0oIqo6	2
137	Keen	Chesher	kchesher33@bing.com	2024-12-03 20:16:22	$2a$04$ROwJhpMFKhVbktaXTzbENe2Usbd18XG7uclHLAxLgTexHAgxy3G0C	2
138	Ichabod	Mordanti	imordanti34@china.com.cn	2024-05-13 02:19:25	$2a$04$j6aNjU3xR3JqQQ.mh.5pWeyHDLMPlwsCmchP7BQTJJjGJC0Gaz4JW	2
139	Sher	Budden	sbudden35@nbcnews.com	2024-05-20 08:27:46	$2a$04$xUkM6Bo.U3Y/aAxSkLgFT.PplWXbobt/YfDSCDpu1hbxq/U7Y6PX.	2
140	Mady	Ayris	mayris36@qq.com	2024-06-17 03:56:01	$2a$04$olXhiLNfOW39a9aJJT7IHOiRUMgAZ0qxBfaitMKa.3M1Ev62aGuq2	2
141	Norry	Buncombe	nbuncombe37@squarespace.com	2024-03-17 17:51:34	$2a$04$KZU8hxx3fL.kGXCEU13sLOYZ25uzbgQr3pubp7T.N22ubaGs01Poe	2
142	Eric	Snoxill	esnoxill38@icio.us	2024-12-08 19:54:45	$2a$04$RblraWYVQFD1KaI4E2OPMOkt2tCUrl0Y1uwy5cEXc.fK6ywEWh66K	2
143	Merla	Haquard	mhaquard39@fotki.com	2024-08-10 03:40:47	$2a$04$ktTmG3r5.HBiqxPt6MRYteEMTav9/HtCSqJOQ00TEhVxkG5hJpcBm	2
144	Demetria	Shimmings	dshimmings3a@craigslist.org	2024-06-16 07:42:10	$2a$04$jjUbilhOe3t4.S4slrqixuvogpWByRZ2IDTLMr6M/fOe8jHSvJ1C.	2
145	Sigismondo	Fossick	sfossick3b@newsvine.com	2024-12-08 22:33:45	$2a$04$Supv23y9lR7GVzc9Jj/2NOXKb7UajBZgpSuinYS7Z2UpFATaZm4P2	2
146	Nikolai	Gorwood	ngorwood3c@vinaora.com	2024-11-26 02:55:03	$2a$04$6aXUZ.LpmQ4eHvvHgAwDHemq1A9l1IQGFy1MnJHOCv7oSpa3oaMk2	2
147	Camilla	Seawell	cseawell3d@flickr.com	2025-01-20 22:08:27	$2a$04$962zEQFcxGWkpZLwE8xC0./5cLdmjfwBbv6DRhTC0UWrqQG./q.te	2
148	Josselyn	Philipson	jphilipson3e@surveymonkey.com	2024-08-31 11:31:34	$2a$04$SMRlpHZvFwS2fA7J/gXHceIWKojkbtKfqKBY0o5RbZvUxRDQ9j8uG	2
149	Gloriana	Cornish	gcornish3f@bing.com	2024-03-21 08:52:59	$2a$04$DKGRf48Lt8kYiwrJibj9NOkRZXXmTDxufxM.NmLIe39xN6fcTp9/q	2
150	Creigh	Pigden	cpigden3g@behance.net	2024-03-05 01:37:33	$2a$04$VcAvF0HRmtRkFOaAY4dm1O5hI9dmMKdZw49Nzrt9GyOarXoc/Qfy6	2
151	Nefen	Botley	nbotley3h@jimdo.com	2024-10-11 00:48:56	$2a$04$vWj5qTkOf60loDiLHSHCGOlszEfZocRFd5Crzt9TNy4d3lb/3GpcO	2
152	Ada	Cossum	acossum3i@cafepress.com	2024-09-23 05:13:26	$2a$04$jdmJedJWbOP0dYyaJAcvB.ackJQFM3AOOwtmk7vJqg8EgH6Ed3M/q	2
153	Arel	Cutten	acutten3j@1und1.de	2024-03-10 21:13:08	$2a$04$DcWWxXoZ3/VpTvGyH6ZxIeWxgTDRoCe9R9qMbK39MYKl7ky0dRP16	2
154	Mitchel	Hamal	mhamal3k@yale.edu	2024-08-17 06:56:15	$2a$04$VgHdu2rnGhYQpC/eWOhVEei4Pq5IQ8IZX2msFkTTYUTHhGnk8upVm	2
155	Essa	Christoffels	echristoffels3l@tuttocitta.it	2024-12-10 20:03:45	$2a$04$xhdpz4IPy1JMBVNPyf8uSO669VGRyUX/1gVQf5gpcnf56pY9d0tdO	2
156	Lind	Wiltshire	lwiltshire3m@linkedin.com	2024-07-24 01:01:28	$2a$04$l1id1PX4VS4G4SY8q/0S.OdJkFBDw38SvbqXhNOHb07zdrorTewNe	2
157	Teodoro	Middler	tmiddler3n@noaa.gov	2025-02-27 19:16:42	$2a$04$bdiaAM.iiTDotaZPrkXQEeiHto.jV/wm9oazD3ugGcLcqHsD4uCGe	2
158	Abey	Macknish	amacknish3o@elpais.com	2024-06-19 16:50:10	$2a$04$NJEibPqTWFa9NvdLTbThZeXiA3XJuvFkA/P3O.pJQcEO89PfhhHqO	2
159	Mile	Philipsen	mphilipsen3p@mozilla.org	2024-08-19 06:24:25	$2a$04$Zhae8l6yBbT/V34TyH5P5.pjzhiPtqwlVYK/AxNUmwA7hWX9HKhVK	2
160	Edmon	Waghorne	ewaghorne3q@eepurl.com	2024-08-21 04:47:13	$2a$04$GxR4Lom1JkmiPGC.BmN4GOAdpLBXap7C1gBRU1upIpd2rTVhpJeLO	2
161	Corbie	Floyd	cfloyd3r@wikispaces.com	2024-05-31 19:08:50	$2a$04$pIrFPmGUb2.zXw8Pbvpmpuu3FNSN/2DLlSG73ou5YHKhT5obNJfVa	2
162	Alvira	Castagno	acastagno3s@yellowbook.com	2024-08-05 14:41:37	$2a$04$yZUdKtnLSOuT5enFtXE7OOjazDcB7c/kMDGPfltAm604NWCR5ucHW	2
163	Maggee	Rickarsey	mrickarsey3t@hao123.com	2024-03-21 10:40:53	$2a$04$/PIGEGdCGgvTsk3RcVvRbuQeg/9UH9NQ5IKPjjoqfwoo4defctsS2	2
164	Even	Toffoloni	etoffoloni3u@princeton.edu	2024-05-16 11:58:18	$2a$04$ud9jGOq7jH4OVCHIQgNJ5uLdx86TjCKIC/9v.OeGnVlICJKw8rhzW	2
165	Rochelle	Seabourne	rseabourne3v@whitehouse.gov	2024-11-17 13:35:11	$2a$04$BRjwabNKLL9nDVzmgHiS1.5jQZUh/QAHzjiFpZi95Go/nOKM2GMR6	2
166	Evelin	Fewlass	efewlass3w@ucoz.ru	2024-08-06 23:45:26	$2a$04$UqMAI8lLuRXQ0A6nYvpLu.KWol3qGxGGnsUM6ktTNI4/uENPbtSRm	2
167	Fredra	Shatliff	fshatliff3x@amazon.de	2024-10-22 23:14:54	$2a$04$UL8eaIvFAU4PkKfCT0mc6uCFlMs8NhQIKgEspxg3pfAwF7d/Wz8ja	2
168	Jody	Tatton	jtatton3y@opensource.org	2024-07-31 00:22:42	$2a$04$bsnwRelA9nLYLat0EuAyBu6v.FsYKmVMCZBKDog9zEvBfURK8XfSS	2
169	Joachim	Shinner	jshinner3z@lulu.com	2024-06-27 11:43:59	$2a$04$IytkbxzN0gTUu5M.NvL1Qejo9kLgHZJbPu.f0ZrgKtg58MLsN6VWO	2
170	Kenon	Astill	kastill40@seattletimes.com	2025-02-10 17:20:43	$2a$04$5S5RmMWUySPwCg85/fStue0WMM2LtE.q044Y6.T9suqCYxKkVxHOC	2
171	Galina	Saphir	gsaphir41@gov.uk	2024-04-25 09:06:06	$2a$04$D3fd6cHEPeuHUsXiGtYAsuQOO9AsqN9wB7Ol6n6nMLEFKm78F/Mju	2
172	Jethro	Gorse	jgorse42@amazon.com	2024-11-15 09:05:24	$2a$04$J8agfoZbG7.ybRmiEghmjOM9/2/aVlSLl5jkM4DemwGEj4EXuaHmy	2
173	Dorothee	Presnail	dpresnail43@symantec.com	2024-04-08 14:14:58	$2a$04$28ceZELrbom/AxOC0Y7Ide1M545.OnNxo0fAJeVvdcSJvIne72D1K	2
174	Warde	Bissett	wbissett44@webeden.co.uk	2025-02-22 23:34:00	$2a$04$/ITKbQ6ZZ..0MBz4HTHhoukfebSy0dW9V9BDUgWIoRjU4Bt5/3QwO	2
175	Ondrea	Robelet	orobelet45@tripod.com	2024-09-19 01:28:11	$2a$04$4gH2cncP4nEl9/eIGBGIqOx/vHFRcFFxC5BcL8rsWbecZkOH75nwK	2
176	Miner	Outram	moutram46@sitemeter.com	2024-08-17 21:53:18	$2a$04$81WuwCfwItk9wOCvSJqUu.mtw7MrkZSMzXFi8PQUFgA/NgqNE1lUW	2
177	Gilburt	Funcheon	gfuncheon47@de.vu	2024-12-07 04:34:14	$2a$04$dVDJYsKdFBWttGQZkYFlBuV/z9LIERSN.zzx1P32oOWjBSo/FVApK	2
178	Larisa	Kirsz	lkirsz48@plala.or.jp	2024-06-26 23:36:01	$2a$04$hpfaV0P8ZFDngCi4hIIurunbH5gr0bNFB1yX6AYPdb0zNGGQhva.6	2
179	Seumas	Ellse	sellse49@ow.ly	2025-01-16 16:57:55	$2a$04$W3exiQyqrEsbE1RRDuJWk.smcZrmFl3lxljXYCzMI6zmNvLR70286	2
180	Prisca	Effemy	peffemy4a@psu.edu	2024-05-13 01:21:24	$2a$04$hryEjQ4sUKOAoG4ogjAcsOHGc.FswSy32pjaX6AAVB6T9Yvm9ZuhG	2
181	Annabell	Bocke	abocke4b@cdc.gov	2025-02-23 04:02:25	$2a$04$M.LhVJLBkfHx3cSa0KBb0eJu0dAoKhUpT9NlAtOn66/N4vxKLAoCy	2
182	Riley	Wightman	rwightman4c@behance.net	2024-07-07 06:12:26	$2a$04$XK85nknsfrwPXZyfEBdo.OOW2Y9BdLBJKon70ypYfsiwprudAKiry	2
183	Benedicta	Loins	bloins4d@nps.gov	2024-11-29 01:21:12	$2a$04$OhG/jLIap4aInNzTWixThupG7rFgurAWCiNgEfpiIpQ7qmI3sqzR.	2
184	Debee	Ingledew	dingledew4e@delicious.com	2024-07-23 19:50:18	$2a$04$OqpTDC1lug13WuQP7ruhMONeS4XjIp0/MnhDlfgYW4LKZmT/33Pgq	2
185	Rebeka	Oman	roman4f@ox.ac.uk	2024-08-04 20:27:57	$2a$04$83EaMNn4sNg1R/ToRsyvGuf010VPDMZQ7jQGrR6iFiMyg1yvMI.l6	2
186	Ethel	Mushet	emushet4g@issuu.com	2024-11-14 23:50:25	$2a$04$/zhuj.JmQsgYTBKGzkDNrej/6MY3ImxfQU5h80rk6h.s1lud6KnhG	2
187	Ike	Linch	ilinch4h@posterous.com	2024-11-23 22:44:24	$2a$04$Q4klhe58dklnddXunjgLOOdOSsIuGJyXFTsts/GxJtOYUHMpYVhQu	2
188	Andee	Bernardez	abernardez4i@tmall.com	2024-09-13 19:15:59	$2a$04$CKMLxERMEmrl8C2wjeTpBOoB9OK4jvfOSuYy6HX39xTYyRg9jWm56	2
189	Reuben	Demangel	rdemangel4j@eventbrite.com	2024-12-18 05:31:28	$2a$04$2E2qumGxnlxWFEDToVLChe7hkwFd8N8ZrHviEu4j3xYb5T5z6qLui	2
190	Milly	Smale	msmale4k@msu.edu	2025-02-01 14:59:01	$2a$04$tHk7g/z17/3A8fXbyE8NGOaAP.FxIDDuyTDVIHaO92EqEBky2nVPy	2
191	Lorenzo	MacCourt	lmaccourt4l@spotify.com	2024-09-30 19:28:48	$2a$04$wV3WnNIDpVp4sz.HM9GHNuBEuOEslR.qVD8QP8R.5IXZEJXi2iE/y	2
192	Wang	Scamwell	wscamwell4m@phoca.cz	2024-07-31 02:38:15	$2a$04$bwFLl4VYwfyXODQFzVNjWey9dDEpR9qTn/Gv.PIHhwsW7yYtOg1cG	2
193	Ailsun	Edgett	aedgett4n@gov.uk	2024-05-11 06:37:57	$2a$04$03lGCkXHkVNURcYuoWUWD.kVSLXPSJk9GPXqKe3Vjz0MmnM393hNW	2
194	Karine	Clowes	kclowes4o@chron.com	2024-04-05 09:35:31	$2a$04$NafkaacZq164YOwDA0FKp.Jdd6yDLERdgOm6AsSje02rL./CSOWa2	2
195	Frannie	Londing	flonding4p@nba.com	2024-07-09 18:36:05	$2a$04$BKWvw5XWLlHTojTqMI7TO.62dzOKLI8pSuVOPR55uN8w5L1/JsT4.	2
196	Ginger	Deniskevich	gdeniskevich4q@github.com	2024-04-03 22:31:43	$2a$04$Ztnz3xMUPiO/EWJRwgq39OAzjv5s8rAuYaN8g2YDKPWBLEJV6ZPXy	2
197	Hamlen	Sowten	hsowten4r@ameblo.jp	2024-04-09 03:01:47	$2a$04$iM7G.7ytkXi/fPp0ELUmV.f7pCJZEkE.ZPNr20qRfeZxP32iRkyCa	2
198	Dione	Hooke	dhooke4s@ihg.com	2025-02-02 05:12:16	$2a$04$F0mLcpIrjs3DIc3n8jWZWeNrU5MXzCD26OiWOD3yWSMtuLIe76dO6	2
199	Wilton	Cours	wcours4t@symantec.com	2024-09-27 08:55:23	$2a$04$GtljaDZkQ3AdADjzANNAHOqLiJyY10u2UM8B1Tv.Kd5MuBKwPn8/S	2
200	Sheffield	Harses	sharses4u@devhub.com	2024-06-02 17:17:23	$2a$04$dvx8A8atdfTDyXW.E6WvKOm5fEafBQeS7gWRrXsa/5NIQIrONTUCW	2
201	Nollie	Gunby	ngunby4v@oakley.com	2024-10-08 14:59:01	$2a$04$pKn4j7rta6NIbkAlZqijv.CMBEJSeFMTDXT4odMa2tyEXivrxpkCK	2
202	Gert	Pindar	gpindar4w@tinyurl.com	2024-10-09 15:40:31	$2a$04$2y8RHG8tNoQYyRYOIkf.VOBybqeFxWWeWZu.e4YdOIHT5T59TZGhu	2
203	Wilmer	Flahy	wflahy4x@example.com	2025-01-31 22:34:46	$2a$04$YuqfKqgVO8SbH.1tIKCzCugt1mU3oqmgXj/KZtnrBl7OFQoRBTVJK	2
204	Lonnie	Mattiazzo	lmattiazzo4y@slashdot.org	2024-12-19 20:50:21	$2a$04$9F85W9STFJdLz6m0GHMInOzSaJY5Aypc.t9PSEuOklzuq56CVwAN6	2
205	Erny	Gerrish	egerrish4z@ycombinator.com	2024-08-09 17:29:32	$2a$04$bLrLGKr85PisRyvcgoUnKuepiQ4SBkA2c0sA.92nfTARIFSsUAAgi	2
206	Andrea	Grigolli	agrigolli50@creativecommons.org	2024-04-19 18:39:22	$2a$04$kAlMod69tvwKLFEb5xna9OzeiIHlUnEJxkXF/HvZhgGamRuL0Gyhe	2
207	Hubert	Orchard	horchard51@nps.gov	2024-12-20 03:32:48	$2a$04$ob5Avd7TPgN9zNv3rp5YPO0CWbwPaPGkp.SSofMTR6OoH1LktzC6e	2
208	Virgina	Pavitt	vpavitt52@washingtonpost.com	2024-09-28 14:40:15	$2a$04$aTbTitnF3jKIfm2UdZ4CuedqYFCz4otaSLDjbXQxkqb1zfI.9Z.om	2
209	Livvy	Seiler	lseiler53@illinois.edu	2024-10-15 22:29:53	$2a$04$g3m.Eg1Hw9PVIjGTn84KoedO8jlX5kDYoFOTxI8G/rFPbvCsfvL1.	2
210	Aimee	Forrestor	aforrestor54@irs.gov	2024-10-18 17:43:47	$2a$04$h2u4hqpqR9m92nvLrKkxwu5EwtVuKQI0ac4az5at4FYOCU2vSFxyG	2
211	Rabi	Servis	rservis55@webeden.co.uk	2024-03-26 12:11:16	$2a$04$4fcRBO41ErKne2mtQ33cduDx24b7JcXTMP.76MkZU/aO2aNlhwoiO	2
212	Nydia	Erb	nerb56@addtoany.com	2024-04-20 18:17:40	$2a$04$as/btqJYnEaBqIRFJBhQKePB/kzyVWzW2FSXhawOTl9cBh0iwFVLW	2
213	Broderic	Clapham	bclapham57@com.com	2024-12-07 08:05:58	$2a$04$pr4p.ChTS5zGauZMe4Ygte9tucevNOlbIAQPH0oKflhfduDfSA3su	2
214	Zacharias	Jelly	zjelly58@cbc.ca	2024-09-29 17:14:27	$2a$04$IGWnNfW0GgXQtDOLKsyDM.RWeFu8KQOI9mR1gOeI7k6d.tz9A1VdG	2
215	Silvana	Braddock	sbraddock59@deviantart.com	2024-07-10 19:04:08	$2a$04$zhLV3bIVku.igpHDaB/TT.v6XT4qN5FT2bVFSlWcll5r7ld1sIEjS	2
216	Holmes	Snewin	hsnewin5a@friendfeed.com	2025-02-18 18:56:03	$2a$04$93fxte7FyKx38ru1g4KsvehclXHMlJTb1TrvTrsANGk0S3eS5l5Vy	2
217	Shell	De Fraine	sdefraine5b@guardian.co.uk	2024-03-15 04:27:20	$2a$04$8J96Qms2xSrcGbpN7S37hOLDJ3EA4yZjvNeqYmMsV.xBwPaUMzJom	2
218	Felicle	Gally	fgally5c@amazon.com	2024-10-17 17:47:43	$2a$04$AmSIXaEV5lOkVEpNBriQTumfyLm/UkZikMS7S0FUaVrtcSfRUXP06	2
219	Ariela	Fareweather	afareweather5d@360.cn	2024-11-09 09:53:27	$2a$04$GDdThTch93lkTmIuQdEYtOzSzgIq0xfaHlQdXAM3LT3HwtB2Z65iK	2
220	Pollyanna	Nellen	pnellen5e@jiathis.com	2024-12-22 06:48:36	$2a$04$RCVqVJE11mbK.9vTUAMkduD/iXC5DY0mY8SMfpZ.kmXzu1J5lxtdW	2
221	Letitia	Pattison	lpattison5f@uol.com.br	2024-07-23 23:47:03	$2a$04$EqYRIRoGkeM0gPdVqCmdiefpiLDKh5l.KoSDw12Ehxu0DjuNxxRHO	2
222	Kayne	Figgs	kfiggs5g@apple.com	2024-07-05 03:27:27	$2a$04$ftLGm.vZ19lL5yUsCq9SX.EPZi0RNscUJEP/20X5u99mXaF3hnP9K	2
223	Christophe	MacMillan	cmacmillan5h@mit.edu	2025-02-16 17:59:29	$2a$04$zJSs4OKaoksvcZiJvS5JNuvTMhaAJ6w0ph53j0mwdj.hMI3Lmseb6	2
224	Nicolle	Stoakley	nstoakley5i@bloomberg.com	2024-09-03 19:51:55	$2a$04$ZJ4sRpyZLU/lI/nW0roFCeDqPVP9185SKp5m/Bznx/3H9EJMVaGfS	2
225	Deeanne	Strickland	dstrickland5j@bloglines.com	2024-11-26 02:41:39	$2a$04$sPtoFEoBgjBBcDlrl6cjee8VE7j1dYhlCVJmYOta12AS2koJOh.uq	2
226	Blaine	McQuilty	bmcquilty5k@salon.com	2024-12-23 11:45:18	$2a$04$cWymiinn022iyxd1.sJ6puGC1PHeyB4AUJx8RM3yRPGuYsgLkPZo2	2
227	Catriona	Swains	cswains5l@joomla.org	2024-12-03 21:29:22	$2a$04$pYZ2aUVcjeanImZ8wjvY5O./4tW8Gq.ksNrJGnUlfd6SLQfT0IIxe	2
228	Candra	Hurley	churley5m@indiatimes.com	2024-12-14 06:16:51	$2a$04$Uo7f53G50BGRM5khWDgwpeIf0IywwLw7V6mez6gHy1.uyNbI2/W4q	2
229	Erroll	Fairlaw	efairlaw5n@desdev.cn	2024-10-10 22:53:46	$2a$04$8cSuA7op36JVZ8pUBxrYAufxZNsym1TX1072q1tvdu1Z0.Qouz6Aq	2
230	Napoleon	Chesterman	nchesterman5o@hugedomains.com	2024-06-30 02:39:52	$2a$04$r/iRKhfgUvTZtOi194txJeLtRqxgY2lVC7aB8FHcHnH/ytkuxl71m	2
231	Kevan	Galtone	kgaltone5p@hatena.ne.jp	2024-04-29 09:17:50	$2a$04$ct6yEYTmO0s.RoRanBVvluCMCg0/YzasFKCadx1dgtI/Ul2AK7PKa	2
232	Shelagh	Slayton	sslayton5q@cargocollective.com	2024-07-15 10:08:33	$2a$04$.aAwEgABXtvL/5xUMIgeiuKSXBLTj6JlbwKoMNQIypImC3Mz1KTu2	2
233	Jeth	Minihane	jminihane5r@storify.com	2024-10-08 19:55:32	$2a$04$GAs1007RhIWgfbU6J3wXkeWF668jDy2lPZyAJJKphlQZVTQTIGqKu	2
234	Sollie	Foord	sfoord5s@jugem.jp	2024-08-17 21:02:15	$2a$04$FNxPgCpHsq3/7LVV.RUUNucsDs3RY4wRjXz2TByvHxmZTEvWFUCfS	2
235	Flss	MacKimm	fmackimm5t@smugmug.com	2025-02-26 20:40:44	$2a$04$.rI8LvOEDzJJm5SvaMUKTeA.vyyCm6OWTR7HO5ImrVtAKgCozU8s.	2
236	Josy	Shapter	jshapter5u@diigo.com	2025-02-09 18:14:49	$2a$04$iT3c/tqjIBUkiSX5DAGjMuJcsz.vjYXxt20VsGucZ8sfKHlz43hSS	2
237	Marchelle	Normavill	mnormavill5v@creativecommons.org	2024-11-04 02:05:28	$2a$04$ByME3hfxqmYIk5vOTitlsemcgWKk52nLfd8ZUmbZRxJGL9kY45DSy	2
238	Frasquito	Gaythor	fgaythor5w@moonfruit.com	2024-04-04 20:29:24	$2a$04$s3T0TPXoouw3lbg8HTixNOAoNoZee00pMHXa2nL/Z3dSumY9arz5W	2
239	Ancell	Morse	amorse5x@booking.com	2025-02-27 14:24:52	$2a$04$js4iPSj18LwTnLXyLEL6Ouxq/D2hBArCxtDPDjNGvDQkba76AFr2m	2
240	Annmaria	Sabathier	asabathier5y@pcworld.com	2024-09-23 23:18:35	$2a$04$Qpna0yWzcLMU2dMeCqTetOo.srl1BtdU/7XjyVdVhcxhv7OfTODke	2
241	Franny	Huggens	fhuggens5z@webmd.com	2024-12-23 10:54:36	$2a$04$5J9vDS51ngrShUAWjGUhc.jLNQjn5Hj4CE0didcXTx.180YwUYpIC	2
242	Collie	Kerner	ckerner60@mail.ru	2024-07-28 13:54:56	$2a$04$5kTQfFsK8fFw8qVaZkLJauOgTuzMCnf5QfdCQaNaO/agv.OsjiD4.	2
243	Ronnica	Lovick	rlovick61@theatlantic.com	2024-07-20 17:08:43	$2a$04$H5U3k0/V4iqxQDDFTOcZ6e1v2eR9qH1a.7E8BLLRhelMd3iVyCeqW	2
244	Genny	Pittson	gpittson62@icq.com	2024-05-24 10:47:17	$2a$04$LxF9u9fD9MDv.7taVX6.1eAHivI9HV7pNvrw9fPvtA8.wFkOPX5Ce	2
245	Cornelia	Wailes	cwailes63@angelfire.com	2024-10-04 23:17:26	$2a$04$wURZJrokuKoPP74fGWzHiuA95UJ7074xN0BsrKTB6yHLoOOTptdKq	2
246	Kristofor	Frankcombe	kfrankcombe64@techcrunch.com	2024-05-04 13:53:07	$2a$04$m4eDb1w5GQE4Y0rFhBgQduNYBUFL3PKulRsuJr66b8jk679RslqTS	2
247	Sallee	Wykey	swykey65@wired.com	2024-12-28 14:26:04	$2a$04$6N/z6h1Ej.5S3KdkMr3Rw.1tM7af8skVMK7Kzrt7lQt34xp5qioGO	2
248	Dominic	Murrum	dmurrum66@cyberchimps.com	2025-01-23 03:10:46	$2a$04$x7SrKiBzK8bJWqGpiQ0a2e.qwhxAX1oP/1mvbQGF4V4WvvJlFKoYq	2
249	Onfre	Linton	olinton67@mtv.com	2025-03-01 19:11:36	$2a$04$RHqktm7Ww49vXupfU6sRw.Az625oZTmvCoiRdhZ3D3MeXovQ8BC3O	2
250	Kylynn	Arran	karran68@1und1.de	2024-03-27 12:55:41	$2a$04$GV7GUTRIlXXIibv7f5COUOD2cBTXSPM2PaWzCfKHomLyHtBbCUfES	2
251	Shannah	Redmille	sredmille69@businessinsider.com	2024-11-03 11:21:46	$2a$04$PV.cDLidfOS9GWQ20pRblO0PkAGte/.kfN1SkJqdejxn5KEawlPGi	2
252	Eric	McNalley	emcnalley6a@cafepress.com	2024-07-25 12:05:34	$2a$04$rVhMmePyny0vAzUV5fmi4.DQbRoVOfs8OuWSGvAkvuWEY25kob1hK	2
253	Ingeborg	Slaight	islaight6b@yolasite.com	2024-07-28 05:24:04	$2a$04$.7FfXLECJj7QmHMMEvLZY.mevi0xnqgQPiTe8Wo4XYqPyT6TEoRGm	2
254	Barry	Anstiss	banstiss6c@hc360.com	2024-03-27 03:54:39	$2a$04$WYm8np/TDxUZFuN1wCPpNu2V9osY/kuic28MHhkvHBsFMyGNK2NOy	2
255	Lynde	Ivanishchev	livanishchev6d@photobucket.com	2025-01-21 08:14:53	$2a$04$mwahHzE06JAl8TufXsulgulxEekomNP1mEaMKEbsfdlWZrlywzO9y	2
256	Delbert	Brinkworth	dbrinkworth6e@goo.gl	2024-09-12 17:09:30	$2a$04$Dg01TN33HVPTEAne6eHtSOQ1yvyaTWPGH2DS24eEAuXgf391ZRypO	2
257	Jenilee	Fordyce	jfordyce6f@nyu.edu	2024-11-19 14:34:45	$2a$04$.S.41AGmKNrEqWMh7zFkjuaOiQTJ581R0adPvgWrul6Sed0I2gpDm	2
258	Hedy	Bazek	hbazek6g@rambler.ru	2024-06-13 06:36:54	$2a$04$Hl4kuzypdWwrakzi4wQW4eELEZufJNLwA0d.47cTz0jNWvbAZR0b2	2
259	Nichols	Hickisson	nhickisson6h@woothemes.com	2024-04-14 15:16:18	$2a$04$t2qwNcuL6KlPNAH0F2ljT.4fGA6qQOaOG0sq7FQZpuORrTYFnjMH6	2
260	Neille	Pincott	npincott6i@unicef.org	2024-11-12 05:47:50	$2a$04$ElIgbu/VfsO74rWq38Hwo.6zgc19yzYPlRtdcU9oWkNzsIpu5PCYq	2
261	Hardy	Dickens	hdickens6j@google.es	2024-12-02 21:23:51	$2a$04$2lZMwFHFdwHkmo3sZi2mB.mNGDRY27n3zjxKw66hDHBgWs50YPj6m	2
262	Holmes	Yosevitz	hyosevitz6k@china.com.cn	2024-10-16 21:33:21	$2a$04$SkxIfQ95Qia26kd9LernUORt6ocdDkSBfXPxdbeaUmSlWzqTz8432	2
263	Rodina	Comfort	rcomfort6l@msn.com	2024-07-30 05:59:00	$2a$04$ptkMNN8LeitKN10Rkwkhx.pNE4j/LH94IgQ45rw.8drkgEDR5GRzW	2
264	Lorri	Nulty	lnulty6m@phoca.cz	2024-11-24 13:57:46	$2a$04$UMaR7f82zOonTQBnxvnc5ebPLYa/mE51ArU4ydNjFXFeYjKkph3re	2
265	Roslyn	Dewbury	rdewbury6n@netvibes.com	2024-05-10 08:43:44	$2a$04$NAJJZIWAcv5uDrJxRKQ3be8Yo3S0SgH2N7dGbPavibUJedwpGgL9S	2
266	Marius	Meiklem	mmeiklem6o@zdnet.com	2024-07-25 17:25:55	$2a$04$eTT4RwsLz7u6Wa0HW3oo/.TGpeHUE09V8CEu.3iN2STWJG8Vr1U0i	2
267	Raeann	Stolberg	rstolberg6p@canalblog.com	2024-08-28 15:28:58	$2a$04$arFQLhrNMsvkoCrne02PueYI0BDyKE20J6/HHnCPu7gykecDjY4SK	2
268	Harp	Luesley	hluesley6q@cisco.com	2024-04-26 16:56:36	$2a$04$k9SCM.nm2uav6Yz0j7JAAOdlsrf3Kdc3obQysUYp4UImfCu9qnYjC	2
269	Thedric	Imm	timm6r@weibo.com	2024-12-03 22:46:16	$2a$04$9aH4uRmfnQp9uFtxrfmaQuMMU0rB27W0rz8CfKRkJNx5KNfiu7o0.	2
270	Aleen	Bonehill	abonehill6s@shop-pro.jp	2024-05-14 05:42:34	$2a$04$nfzK2Ru7Pg4scsnrYUI2pOy2eT8M.qagodfhecJQWV3cQB78bqBEW	2
271	Adelaida	Glassard	aglassard6t@shinystat.com	2024-06-21 17:31:09	$2a$04$3AJWRNjmdT1AOS4c5qRW/uBoP32yvqHZXburY3j3JlvJ1Z3Zmw4ei	2
272	Roxanne	Antonetti	rantonetti6u@cnn.com	2025-01-31 06:58:14	$2a$04$rkhuWuQRCE.70T0xeGeree8h54uGPZcIndTcTSbgU5QzPVXylvJoa	2
273	Valentia	Bunston	vbunston6v@aboutads.info	2024-08-02 04:27:11	$2a$04$azmJ3dPQq/1523T1oEZBKeLqsUmYWpGXuKcwujsze6a4NvIkC2iHe	2
274	Fernanda	Martina	fmartina6w@irs.gov	2024-12-22 22:27:08	$2a$04$JJHREY50GcTPAgimBw5YCOrOa.bzAvO7o7zX6uc2AI6DQNlEdFUX6	2
275	Morten	Yanson	myanson6x@deviantart.com	2024-11-05 12:35:59	$2a$04$WCtubWSJf6cIHqsGttmJYOFbduLMgX34OabB9s2N1gNOobM1WVKHK	2
276	Elliot	Vitler	evitler6y@slashdot.org	2024-03-07 09:03:23	$2a$04$0Anq4P8ZuIQosAB7/aLXGOX5.l0j2LrJTPd7AGgmEYoMf.abKqIQK	2
277	Trisha	Treven	ttreven6z@dailymail.co.uk	2024-04-02 10:22:45	$2a$04$HOOpa6QwfgfHDDhlZ4eyYu2u7LTCJ4wIFGqvz6YWZBdTFoBufeG32	2
278	Cornelle	Izakoff	cizakoff70@phpbb.com	2024-05-10 21:40:57	$2a$04$YQwY.VX.AUInFnz1A5QPBOmNKbGtEKRxnsbSbLT/ME4FTqhC3A6SS	2
279	Walker	McAvinchey	wmcavinchey71@who.int	2024-03-22 11:23:23	$2a$04$4QQzhz8Pv9Xb9eHl.Ex42eCqCimDQM1f1LgTqHjLsaXVe8O6rgEPu	2
280	Bev	Toun	btoun72@hatena.ne.jp	2024-09-15 09:29:33	$2a$04$ZYCJD0.TsP0Yzs2V9GpyyOHoly2jSCg0N.Jw1Xj5Do9TtSLQMdUlC	2
281	Maynord	Lorking	mlorking73@google.com	2024-12-28 11:19:42	$2a$04$wjFEA5S3cYziEcFOExGG/OpEN.Gq8M5omFuLKJ1eIvMT/ungN13fu	2
282	Lanette	Oade	loade74@instagram.com	2024-08-01 01:38:30	$2a$04$B4T2zw19eRLmNZLzR14EouZyz.USXa277lU3EWi5yc/.2cT5YwkGG	2
283	Leandra	Millhouse	lmillhouse75@dmoz.org	2024-07-07 11:34:39	$2a$04$jFker.aH1HrXQ3Jb1Pa1Qu2blYbL0JwkEEo4mmbHVzFTqUzOgEfW6	2
284	Merola	Jorgensen	mjorgensen76@vistaprint.com	2024-12-30 14:33:02	$2a$04$8c/JCa.3EmhYrF6SP9sOMeITnbVkxNy8/jkyMDkMNeUdcnTrjIRGC	2
285	Ardra	Moriarty	amoriarty77@simplemachines.org	2024-04-05 18:07:46	$2a$04$omjscX6H1ab6xy4rx7ZdD.dVF/XGdqq4sU07u0f/S5cWtRDW1Lb4G	2
286	Kelli	Bjerkan	kbjerkan78@dailymail.co.uk	2024-11-29 13:51:32	$2a$04$oCeGlbYORq5VPfuXLjsQxOKyXAOFizbRJsQoLsC.3.5J8NSmmU8YO	2
287	Innis	Hathaway	ihathaway79@nydailynews.com	2024-10-13 05:30:35	$2a$04$sx71AhV9xdXC.k.kwXCRUePLrh0IPLYo3bhdRbUGzYsqCifYOpV4e	2
288	Kassi	Loder	kloder7a@npr.org	2024-08-29 22:57:00	$2a$04$kGD4Fz1aBcD7Y0mcGbF27eGFw8HMVFfMK1/meKa0ed4zTwd3szlOK	2
289	Luca	Threadgill	lthreadgill7b@arizona.edu	2024-05-23 18:57:30	$2a$04$pj93kSwO1WYdjN7jEt1zK.WCDDig0yce333DKtUQpm9EYd/7dzdLO	2
290	Man	Dewsbury	mdewsbury7c@businesswire.com	2024-04-13 11:04:19	$2a$04$hAaQcsWAseMZesPoq.vOR.7OV74Bql10AT0HdF0eOm4O6aoWqwyDK	2
291	Pasquale	Barbrick	pbarbrick7d@umich.edu	2024-05-06 01:59:05	$2a$04$5xtfUWA0IugM3bcbZpD/bOdewBNXdFWE00D66.9BmZ6vW3a3AVLeO	2
292	Rozamond	Epgrave	repgrave7e@patch.com	2024-03-31 15:36:05	$2a$04$lm2vvjQy08hHCZcZKNiQLOvMYYw18UVhv23w57CVhQkDtlpasERxq	2
293	Malinda	Cotte	mcotte7f@hao123.com	2024-07-16 14:48:13	$2a$04$XSxPocvYr0bY4bKayLwlwOilOy2RGIYDc8p1GTjFxV8Kvlz235qmu	2
294	Katerina	Coathup	kcoathup7g@oracle.com	2024-04-10 19:10:51	$2a$04$U/5z.9HmGNN6Hp0pwdIG9u05O1BrnjD43l8XuWXjADqOjXv4jb06q	2
295	Farley	Pendrigh	fpendrigh7h@hud.gov	2024-10-14 09:46:18	$2a$04$..12tkU1X7cyxoyEI9TdDOzJuRBe9cgzHRLIjk5gj3ZOwU3VgHr6W	2
296	Robby	Wick	rwick7i@slashdot.org	2024-10-29 13:19:15	$2a$04$TWhJDtbOhQo2Mc35BkXQluH6Rf049WwljqYyk86rd2q7Vhc.X3Gha	2
297	Ardra	Reglar	areglar7j@spotify.com	2024-07-05 05:27:04	$2a$04$LSHQvVdgg/V2CXHbk1cmU.lJeWX0Z8QyHQyyb.XXpVM5Gp1131uua	2
298	Debor	Krier	dkrier7k@engadget.com	2024-10-02 04:01:56	$2a$04$ycyPMwDYoOE5ziNcm5OwseBO17rWUuLq.RXpc8opb/J9M6/Pc2./S	2
299	Maureen	Matussevich	mmatussevich7l@woothemes.com	2024-09-29 08:04:50	$2a$04$Lc0mLH.Gok2JrX37Sk3by.NOCtHofJauUedVE2ebgDBzokyHkktQq	2
300	Fernanda	Wildin	fwildin7m@cbslocal.com	2024-05-08 23:22:35	$2a$04$GZBjG8xjnGQ5WMkGcAvWNOBtcBTU9mFMYcTkRpte2rxkzOY97hf32	2
301	Vevay	Fitzhenry	vfitzhenry7n@archive.org	2025-01-29 06:07:04	$2a$04$prZeO3OdY0UPpsC9pDeTh.X.6Ad3NNhKI6bSsjrq05Pr5TsgwK106	2
302	Ring	Chaney	rchaney7o@google.it	2024-03-22 22:12:31	$2a$04$z5X.N5sT/0mpCBl8jl/BueBJKkbmZqIM2B8IccWRaQ275HQI3kl2W	2
303	Genevra	Paice	gpaice7p@jalbum.net	2024-06-29 11:35:28	$2a$04$xTdV68iLUabUCt5hJI7gl.cFpy.7pJ1hPkKMRwS0XQTmEObWLIa3i	2
304	Shawna	Sharples	ssharples7q@upenn.edu	2025-01-18 13:03:56	$2a$04$lCFkE99B7hLnoQ5qJnk15.md7f6p1rj5qvXbezrIAwUmOUxGCVuhy	2
305	Fabien	Monery	fmonery7r@trellian.com	2024-03-30 00:59:59	$2a$04$ki.Pq0YP3lWdcCl7OhUxmelWsO2c8P.1QFnSjfKzQXlDe7iagRBdO	2
306	Gena	Simoni	gsimoni7s@paypal.com	2024-03-14 12:06:56	$2a$04$NCKnja4bhoxVg1eaBHufye1OQcDHTw1qf4Y8ygcC6RQd645/.GA2y	2
307	Emmalee	Pawlick	epawlick7t@live.com	2024-04-12 08:37:53	$2a$04$kZrAFp3.qTZ1pEX.PaUsROTQpgvvFiEgL8ILfl2s0rEm.S1uG0Vr2	2
308	Cassius	Dyka	cdyka7u@behance.net	2024-04-21 03:49:43	$2a$04$ZdeHEfkY0I3j//k1LC2pZeuvgpySZyS83j6hGR5SOT5zGQoJp4bZ2	2
309	Deborah	Spavon	dspavon7v@techcrunch.com	2024-09-14 15:39:03	$2a$04$bH.RIKPsdRlJHCFi2vhgI.9VpzVTlGk3qnV.Ljec5Bni.EQqG7NGG	2
310	Buck	Hay	bhay7w@state.tx.us	2024-07-26 03:24:27	$2a$04$VuIVEMy21Pm8IbALHy1YEeHCYUKVKwD/Q1Xs/cSP1Go0uxAkZeCvS	2
311	Rubie	Gonnard	rgonnard7x@google.co.uk	2024-07-16 15:29:26	$2a$04$.WRwacYwtFux.vcandMmOuAbfT0HIy4qaYp00XqnB.5HQnyDAkr9m	2
312	Harman	Robinson	hrobinson7y@mapquest.com	2024-07-07 14:46:08	$2a$04$M5gct7dEOQlcnd9Y3HeJt.7naG3te0G5W2Fm0e6a67OQzD6gmO7b6	2
313	Harold	Dowden	hdowden7z@odnoklassniki.ru	2024-08-10 22:57:30	$2a$04$xQv8hhF5.klIao.4p2HQsOB27UVESlPIuGCdnJe5RitDtG5kqri/a	2
314	Ania	Currey	acurrey80@prnewswire.com	2024-06-22 16:50:54	$2a$04$WoVAdF4MMyBG5RyQRrIT6.x4QwxMfBfYY9ta3uHoMEaeKM2vfQz7K	2
315	Yehudit	Fernao	yfernao81@i2i.jp	2024-04-01 03:28:21	$2a$04$uFH8ehcmTBwoGJcZaufk8.H0Mcz4rPTzlRdLh2AmChE1Z55Oz0Ihe	2
316	Clarabelle	Batalini	cbatalini82@cmu.edu	2024-12-24 10:48:08	$2a$04$cqWEzwyveA31.7IKcKrrMe2rdYGwBFsAlqCrOwzWxg4yt1bI3rkLS	2
317	Broddie	Boundley	bboundley83@cnet.com	2024-08-18 08:22:48	$2a$04$jWfaqs0i2I2YNOmpLPmbnu6s9gpLWltnXyHATUS24y2ukG4irZpy.	2
318	Humfrid	Arnall	harnall84@yahoo.co.jp	2024-03-27 05:54:00	$2a$04$4QYYR7ZjJPTAAab7uvgM/.i2SUMyuY/5lZkKyiRIGJEZ954wN1X9i	2
319	Ellene	Fyndon	efyndon85@mit.edu	2024-03-19 07:18:17	$2a$04$rKKsnqxBJ/4AjKfUz59PfuIa/635LHJfCuChblOz8s396MhQzwpoy	2
320	Shayla	Oswald	soswald86@yellowbook.com	2025-01-02 22:30:58	$2a$04$cscYdU5VWLHmJx0DWzTLmuAKSbeHFhCHJnc1SHijxt1RaGenF1l2y	2
321	Mick	Windibank	mwindibank87@wisc.edu	2024-05-16 14:20:32	$2a$04$/Q7jaKaZirRvyTQItgmA4esXbv3vxAuOSzV8WFnn2MBlACVYA4.EK	2
322	Sylvester	Atteridge	satteridge88@geocities.com	2024-11-21 04:15:00	$2a$04$Ysd54IrWdmRZaoUw43F0y.ENtHOVOqfOq5TCpR6Mw8PcWxOgSvAcu	2
323	Marlie	Graalmans	mgraalmans89@wikia.com	2024-09-17 05:52:32	$2a$04$L.i1HONpiSVfsyEn8wZn7.llmp5KfHWmP3oV/uVcLvheaVHhmw1H.	2
324	Tate	Pohl	tpohl8a@prlog.org	2025-02-09 11:17:55	$2a$04$E/mm9IGG.M3Vv712lM7Ame6qwOT2BUaePh.G.F1399N2IQm1tRLzu	2
325	Goober	Minchinton	gminchinton8b@pbs.org	2024-09-29 11:25:25	$2a$04$I3IKW6dw4q4dNuCkQFBkJ.i/0RoJYMi8kiO4MCgwNT0hcEhQiz8ba	2
326	Hyacintha	Garrood	hgarrood8c@narod.ru	2024-06-10 01:34:46	$2a$04$muFgY9NIgyMlodFSD5oFFu9skwm2vBSgf.8OARlNozyGnXLgsz8e6	2
327	Chastity	Clayill	cclayill8d@aol.com	2024-08-27 19:56:19	$2a$04$24gd/.1/tJcuobXnV9erJ.zHebCpyV35KH03qlTuldp9KWT7qvz06	2
328	Berenice	Levicount	blevicount8e@surveymonkey.com	2024-05-27 17:04:18	$2a$04$4gv1cLbFGjeo9WlDSixmtORm2mLncT7Ee.hUDAcB8ZmnszLQJDbZG	2
329	Ray	Sloey	rsloey8f@slashdot.org	2024-10-17 20:59:27	$2a$04$/pSAOVlnc0tdgQZObxlU7.J0IO/cT4mYOMvdI5rArFUGfL8AuOM4e	2
330	Moe	Dennis	mdennis8g@mashable.com	2024-05-09 05:17:35	$2a$04$70GwKkZ.YCmZJB.wR/UwW.OywZ2LssPmgmZuezTZeQf6T98XXvkaW	2
331	Sky	Tombleson	stombleson8h@hhs.gov	2024-10-30 19:07:31	$2a$04$lDbxE3oEmXd4VA3ILAy2KOWov/jjh6jRhE4.eqgjBFwunHqLHtLNu	2
332	Garrott	Bowell	gbowell8i@storify.com	2024-03-19 16:22:59	$2a$04$2mDR58ocQf7PNks/zxVHdOoTAArIHiWzTELUefVQSaeyzUJc.R/2a	2
333	Aurora	Curnok	acurnok8j@omniture.com	2024-08-15 06:27:23	$2a$04$FBn9tXuN3F.4vKzo.lRX6ez5pI0zi7H75klyRmNBkMjQ6.dwCeaTO	2
334	Iosep	Greatrakes	igreatrakes8k@google.co.jp	2024-08-03 22:13:52	$2a$04$eTfuspJ5A6tef3lAfVabQOZvbsYgCQzXjgVo86D5BvA7rNMlvG5jy	2
335	Leeanne	Klehn	lklehn8l@flavors.me	2024-05-23 04:28:12	$2a$04$nkyCh4Gf4Gf/pXnxbsQaKOm6zXFZr4OF.dbwOhPfK4OKpClaffnKm	2
336	Star	Whatson	swhatson8m@mit.edu	2024-10-30 00:39:21	$2a$04$KM70.Ld5qwcReSDCy0UK5uGbU0wBWBx1Ghuh6tuXx0sXOJzdgutri	2
337	Winny	Oldman	woldman8n@nifty.com	2024-04-05 22:58:28	$2a$04$wMMoiW4DsbM/zA9H7.QUjuyu27Wi.7vEod8SrvMUu9Fsg4mn8Kl5e	2
338	Carla	McKeady	cmckeady8o@yellowbook.com	2024-10-08 08:21:22	$2a$04$K4zV9nRRIqmsqicFXGq16uZQmgoTL6bz2mkL4uJEqtD8GkEws.PnS	2
339	Irita	Yeude	iyeude8p@blog.com	2024-11-04 08:10:30	$2a$04$VZ4ko//vJ3.mpPvr2rHMH.KVlVrFyMLb9LiXxtzm34wGX6oQiWHOa	2
340	Emelda	Dymott	edymott8q@paypal.com	2024-10-07 00:07:04	$2a$04$ATiLrw/3kRAYo3WX/hswguzD9nuERikjlLFWRk7DERYFHzPsP5y4m	2
341	Jefferson	Parfitt	jparfitt8r@ucla.edu	2024-03-24 15:28:22	$2a$04$vfve.8BdD.BU3Oi0umV7/.Kc95IcHILfNDDBIowRl0FvlEit488o.	2
342	Betteann	Dunthorne	bdunthorne8s@wunderground.com	2024-12-26 22:43:15	$2a$04$q2kxjte5nxWsd5iKKado4.nTGhV0O/n63w2pYjtsypTxs9KEnRiG.	2
343	Abrahan	Schieferstein	aschieferstein8t@tamu.edu	2024-05-15 20:56:34	$2a$04$AwlcTmGz7Dn12uc.2hxo0O7Fyke9Ylx.79D5CmI1yEX6kjwpcwc6.	2
344	Janet	Vigours	jvigours8u@toplist.cz	2024-07-19 21:11:58	$2a$04$P3h8YXhIaUWDJfOTAEigh.j9StCBtuEZv7XRRXjM28lGDp0NLXUXq	2
345	Berky	Cairney	bcairney8v@slideshare.net	2024-03-05 02:37:40	$2a$04$GsR2mTjEXek8d3SyK33LgeS2b48nJ9GRxuG9QFZU3xdvUSa0T9hbC	2
346	Kalli	Patesel	kpatesel8w@ucoz.com	2024-03-22 20:41:05	$2a$04$CEB6z5.7cP71LU0dmzMsNeNHXDT2irfs5cS0cXz79wpEBqLeGH89W	2
347	Karita	Player	kplayer8x@wikipedia.org	2025-02-25 02:45:47	$2a$04$ZyOa9thejKI85zkMaQf6uuCe2KfeYhbG/Ajgrv8/x..nnPa5GxLGO	2
348	Hew	Dilks	hdilks8y@mtv.com	2024-06-15 02:59:54	$2a$04$TLkt0IgOBFNNcK8A3oJwNOpZEQ6R/QZm1/9M1BKZDUzx/vr62NOrC	2
349	Wenda	Winsborrow	wwinsborrow8z@cbc.ca	2025-01-31 01:54:22	$2a$04$7bg/Y0sGwKRk4KXOuLB.meOgI9NGTTmFFj//um8dcp0y5R73Pihqm	2
350	Rudie	Coolican	rcoolican90@fastcompany.com	2025-01-29 10:14:15	$2a$04$ZXSIsUQsVd3Uk7L1lgzF9O6xgsLEZdz6Nvun4Tf8FD5XXRl.5lSJW	2
351	Karine	Wainscot	kwainscot91@blogger.com	2025-01-14 10:22:07	$2a$04$c5RvTKcKYEHwvthdmNpij.9fyeVVDFXhUYaY68FOIEUehHe29Ifxq	2
352	Ruddie	Cornick	rcornick92@illinois.edu	2024-06-28 16:54:25	$2a$04$4LIGPZFyKEIsl5YOIwM8fOiv7X.PNokDudy25.lOSZuUQ80gld7w.	2
353	Vale	Feuell	vfeuell93@wsj.com	2024-03-14 10:07:21	$2a$04$BiqpReOEHlbNs6qiCaFknu5M.IZkGL2hy3BPNNKbkuroRxt9rK1n.	2
354	Clareta	Mathelin	cmathelin94@youku.com	2025-01-22 14:35:53	$2a$04$epZJylzkq97PPuAJZGajJeWlv2oEh/UbWl93uTaaVAwGPrvppdFxu	2
355	Milton	Stobbs	mstobbs95@elpais.com	2025-01-22 11:24:01	$2a$04$GMOvN2worBDwLfL4chCfNe1vI79k.j8J9o85Njiw.oW4CqCXYc5Lm	2
356	Mollee	Chaters	mchaters96@army.mil	2024-05-22 16:47:03	$2a$04$geEZ04ZWcT.7RMxGYII4fO9mvv2mPaka/jhOh4aDTZ0ZOaZqcWQeC	2
357	Yale	Tran	ytran97@pagesperso-orange.fr	2025-01-19 03:22:37	$2a$04$pbUJR/ILNTfaxs5/Bjyf1uPEkx4GmmkzhLdx3gMR5XRT1BNBRdURm	2
358	Page	Cunio	pcunio98@com.com	2024-05-30 21:56:28	$2a$04$wa4Gdgk1v.fJ9DON4teMoOf2smUjLxYaJIZE0BjTX/NNMLoIYXwLW	2
359	Abby	Huton	ahuton99@mozilla.org	2024-05-27 01:25:01	$2a$04$TyNut8BbnSc68Z22MYpbneTS1qj1.HiNjSsR0esRuZQWXr9TGJExq	2
360	Julianna	Downing	jdowning9a@reuters.com	2024-07-06 02:42:12	$2a$04$IzypzsC6.4YcJjFt5yba3uYF4p6QjNDp3bDB8Ff826OAd9eftFmIm	2
361	Halie	Pellissier	hpellissier9b@dropbox.com	2025-01-29 07:24:43	$2a$04$UBNqaNRk7aiAdGfKDYnc1e31u3xscUjI2Yyv/v4kYTTu8clE/lfLS	2
362	Christina	Carvell	ccarvell9c@unicef.org	2025-02-28 08:57:18	$2a$04$3t2HC9MfYLnqSKXHKQigneIs5o.ucgNR4Y9uu2bSXlZXyRs1iyHN6	2
363	Randi	Cousans	rcousans9d@51.la	2024-03-14 13:21:01	$2a$04$g0qeDNzYvnF2irU0puAcnOzFCh.rcDctf9da5ERZKc3kNWOoA6HuS	2
364	Jeffie	Bargh	jbargh9e@psu.edu	2024-04-23 23:35:13	$2a$04$9xXKhUFTYg50qko5zwymqu.TLZzkirhpL8DrSOO5JG5PA6B.EGyj.	2
365	Bryana	Leese	bleese9f@newsvine.com	2024-11-09 20:19:34	$2a$04$zpKjrSLsUYI.SPs.PVINfu4reqU/Mfg/Gm4bqVu.qhPctP78pwofG	2
366	Brendan	Allsworth	ballsworth9g@oracle.com	2024-08-06 18:17:11	$2a$04$aCy59qZVZmODilg31ilL8.ZP0j2ueF6TWSpp.aGeGrDO4QPfp8bfW	2
367	Colene	Huckerbe	chuckerbe9h@marketwatch.com	2024-09-27 18:35:12	$2a$04$iyX7dV7yNa28KubpgkHt...h9MG1MIDqKva05KKKzEqNNW1VZRWo6	2
368	Lester	Stirley	lstirley9i@dell.com	2024-11-22 01:02:18	$2a$04$WgYCvfKKhkwAw80qU1ff..vnLiREmef3QFcRcgsWC92v5/pm3NRuq	2
369	Kendrick	Ewles	kewles9j@squidoo.com	2024-11-11 21:07:39	$2a$04$ThkjiIXr/kC23T7UKUIJz.ZqD.aRaaBtmlb/6Yc46bou8pywWW7Xq	2
370	Guy	Tomson	gtomson9k@jiathis.com	2024-12-12 09:57:41	$2a$04$7IvjneohgMHfEnJDm/fnguFT2b3nvqKSzqQBZfAyf9Ch8uDpRJ4ui	2
371	Waldon	Ghidini	wghidini9l@google.cn	2024-11-09 15:47:26	$2a$04$3UxoJhG0jv6lVn8IS09bSuKR0u2jlwE5jtTbdNYkRaPMNmswXBcZy	2
372	Kori	Faulder	kfaulder9m@nytimes.com	2024-08-10 13:56:38	$2a$04$ak9WalXRC3txs2cxlnlR7..xsfAaDvEfdMTqm.6ZcVExek2Oo.Ffq	2
373	Marketa	Rosenfrucht	mrosenfrucht9n@edublogs.org	2024-10-14 23:55:11	$2a$04$sXv1U1QHuAsHecQ2fV5HxOctac9derLb3.xGoYaI6IWsefml.iz1e	2
374	Juline	Huston	jhuston9o@skyrock.com	2024-10-28 10:02:26	$2a$04$Dx/GnyGGoq2f/swsVdMCu.JJAotLJbUz.kZev9YYXwTYhVh9TuZmO	2
375	Urbanus	Bein	ubein9p@loc.gov	2024-11-24 18:50:21	$2a$04$eaO1QaPK14Z3W8yJ4YGzDeZGDsQkNhpBPkmK53SixJnmIeReJWN/a	2
376	Vachel	Hailey	vhailey9q@cbsnews.com	2025-01-05 13:39:16	$2a$04$ViW/MJOWmOB9xNeGi2fwPurLRVyVPutO/6MzqyNSoCPijrpzPMKYe	2
377	Carma	Corran	ccorran9r@intel.com	2024-06-02 06:17:04	$2a$04$/X95olzLyHQ7/E30bCfXs.mqo9I/uu9O4LcvKPt/IblOQ3eHvP0ly	2
378	Felix	Keijser	fkeijser9s@blinklist.com	2024-05-25 14:14:43	$2a$04$AySA.b6FQbw7Ag/kN8f1JuRV.cOqiMoYPIHqX93yx1/AIbOH2awzu	2
379	Gretel	Suller	gsuller9t@sphinn.com	2024-06-15 13:49:20	$2a$04$YCo3tAUpDmMVH.xutooh7.FeePWPJEJ7k/we3Almwfddk7LzeI9rS	2
380	Bird	Willishire	bwillishire9u@tinypic.com	2024-10-08 23:26:59	$2a$04$GwfcvWE.5HWnUyBjNMQWKeGK77DjF0oao33ExV4QGWNtXJYCiqLAi	2
381	Belinda	Dymoke	bdymoke9v@fastcompany.com	2024-09-11 14:14:36	$2a$04$zECi7mFhFlVvqhtqBlrU0.vaagRHhwJTNjqMnxng3LOJ/jjrmFb.i	2
382	Dmitri	Yirrell	dyirrell9w@unicef.org	2024-07-06 19:13:45	$2a$04$FnIx7hfZWxMRFfsjYEdN0.UdCOCcfY2MfcszPX8DTR8OW/MJ0AUdi	2
383	Earl	Vasiliev	evasiliev9x@goo.ne.jp	2024-03-06 02:41:12	$2a$04$sDb8Y7ZVW850SdWUt8K6Xes6URKWEr7H2k0MC1PAebIj0TwfL/XDC	2
384	Doris	Hyland	dhyland9y@rakuten.co.jp	2024-05-03 10:41:50	$2a$04$ZIbGYXDLvRisq3mp/sb9hO1iGWkT2b2t.KAozHK/7AS/bvZKvMT8S	2
385	Vaclav	Fawlks	vfawlks9z@rambler.ru	2024-05-25 08:18:59	$2a$04$Oas8df4ghS4yooRTaLypWekfV3.B8RSaa2ogC.r5J4NulZ5pNxTCy	2
386	Brandais	Ipgrave	bipgravea0@stanford.edu	2024-07-07 19:43:13	$2a$04$3bTNvICkIxUNnaL.sNCrAuLQCjoZ9pnl1jczeXLzMpGOI1KcVAM/2	2
387	Levey	Hunnam	lhunnama1@whitehouse.gov	2024-07-26 04:22:31	$2a$04$iq6llJr7kG2WqiwN4euTi.XuCzMUbsTRQnNBzFBst4yFg0fm79uNS	2
388	Prent	Hurche	phurchea2@booking.com	2024-06-19 10:06:51	$2a$04$Md3QBP9ZAzq7oV39ONipDOpeC3Ys7FkXRP6376836E91x44nrPAPa	2
389	Roxanna	Gorham	rgorhama3@wunderground.com	2024-03-22 15:34:52	$2a$04$70N6o7GIjQJN9im9zGaDy.ZsT7BUYKOkhnIZTthwwI8vxOjfgARlO	2
390	Abbey	Jerdein	ajerdeina4@bigcartel.com	2024-08-10 04:16:55	$2a$04$d6KzWoBDnNkC631TofPieOwdT/X0Rd4OT7bEEGazqgOZ7jjOl.K8u	2
391	Minnie	Verbeke	mverbekea5@constantcontact.com	2024-10-14 10:02:57	$2a$04$.w1Mbtx49SvMO7OhQSTBRO4xRlZRbUzkF1EiHU0C5QLQgQugv36zG	2
392	Margi	Heustace	mheustacea6@cafepress.com	2024-05-25 13:46:57	$2a$04$TCImfNUvcKpTxrUxqMeRNu.fAKbvLahD.ht/uY0T4CDZWYW5suXfS	2
393	Meridith	Adenet	madeneta7@arizona.edu	2024-09-28 21:57:26	$2a$04$yGlzrsdXRdEiQDGFNHDgeuCfaTDEp2BDYyEl/RscMESPB71eg.wm2	2
394	Jennine	Offin	joffina8@paginegialle.it	2025-01-03 11:55:06	$2a$04$7LCXZRIxempjI2wpdunbH.riRqx3yo1Mdi3KaVNkfR/gBJIhVKkUy	2
395	Darryl	Cervantes	dcervantesa9@sourceforge.net	2025-01-07 17:12:13	$2a$04$bxnNg0HZfWdlWbc0Qae7i.5Co1jIzjEXA8eHjt5cfIbuwxE4g1pTq	2
396	Dionis	Panons	dpanonsaa@virginia.edu	2024-05-28 23:48:35	$2a$04$m3zaqAMux.Qe7W.OKEPUbue1Tp9NqOpSRIDZ3ruXBi65QQI4bHs5u	2
397	Teirtza	Dabbs	tdabbsab@go.com	2024-06-10 19:07:17	$2a$04$UcnkNkt2R2ihpcoFskNziu2B0eOREcSO04mT9UEGeq6zXeENxkHq6	2
398	Christopher	Simkovitz	csimkovitzac@walmart.com	2024-06-03 14:13:17	$2a$04$z/8LLcEBEWM07ZIxwmwSmexinZSfLjsedALsKmZ5pA22P.2OP/7JC	2
399	Garvey	Gerardeaux	ggerardeauxad@i2i.jp	2024-03-09 15:39:55	$2a$04$58oTdTIC1kSY5qCOhWEwCew53P93iSZ./oZNFGbs/iJQhYxW0Qcfe	2
400	Jodi	Dullingham	jdullinghamae@answers.com	2024-08-11 03:21:16	$2a$04$QCKqXjUfMm18RjqZeZvsrO6sqy76AMx6pGqn3t52B7vTM482JfqWW	2
401	Mariska	Foxen	mfoxenaf@independent.co.uk	2024-09-09 13:40:03	$2a$04$mdghpG7BEkEEpq6T5lVu7.pRQgFEr.TFf/yrZKUJzhmdxtbFeu3pW	2
402	Sigismund	Brignell	sbrignellag@yellowpages.com	2024-10-03 20:14:49	$2a$04$uBNhvYyytu9DKBbVDP2Wa.djCiq.DG27zxpVI5hKWxETDpgDB0dGe	2
403	Lin	Bindin	lbindinah@livejournal.com	2024-03-26 16:19:35	$2a$04$ehDj/0jKQWr1KE4M4shQmel91htEHxL0iikyew/epJqkWWqx3yFyq	2
404	Maggi	Siddon	msiddonai@xing.com	2024-06-20 02:38:01	$2a$04$2ET.DVEmd88z69Ogqy.SA.5wnCwO8oIQZ4A5vN0vUzX7a6REI11c6	2
405	Thaddeus	Mazdon	tmazdonaj@tmall.com	2024-11-12 00:42:07	$2a$04$cNjX3AHb/0x8bDDtqDF3Y.VX1bCC3jKIn0J5u7ztLluE0WTgSUK0G	2
406	Malachi	Scoggin	mscogginak@vinaora.com	2024-03-19 05:47:41	$2a$04$LK.dmivc63MqQjaaDPs6N.0Gi2DbRkjtTz33mYsgBVUNU67sQeY5S	2
407	Brigitte	Corwin	bcorwinal@qq.com	2024-07-19 12:40:31	$2a$04$HGaGgiVELng3griCcFbE3ef/50ySYh8b183bqnFspaeT9.QYxpTJC	2
408	Evanne	Colisbe	ecolisbeam@goodreads.com	2024-10-26 11:29:17	$2a$04$ddHxWMQaOEAgu1y.au/nJ.ALXBZl0KfGxh7A/ooI1Lj3TZ6J/nB4O	2
409	Madel	Gonthard	mgonthardan@shutterfly.com	2024-12-17 13:32:27	$2a$04$NBQmC2Rkv2ITu0yoKvZ81ulmXCqfduqsSrCXcfhw92sMIzh/RAsKK	2
410	Niccolo	Edginton	nedgintonao@seattletimes.com	2024-08-13 11:38:56	$2a$04$rXrp6XWOnhFWWJS5hLV89.56dzEVI5M7MvJVCc9zVKY7UHpDRPBaC	2
411	Sabrina	Varian	svarianap@businessinsider.com	2024-10-31 07:14:06	$2a$04$V/Hsn.iFW1FeXre/J4Xuau3dgHH/F.aegzqiMSG1tNweHN0JGguAG	2
412	Meg	Weinham	mweinhamaq@google.nl	2024-09-03 05:04:08	$2a$04$bIu78W1RkFbdh1s0f585b.vh1TId2nabm96wG72Iji5H8.DwdBdDO	2
413	Nicolis	Stoffers	nstoffersar@usgs.gov	2025-01-19 16:47:01	$2a$04$a26ym/5FxEjDrPC5G1QeF.1XaGLVNjjIl0O5/SwIUJIG8q5XU33Ke	2
414	Jessamine	Boyse	jboyseas@t.co	2025-02-09 22:41:03	$2a$04$tyHTynvCxVn5RghSvjG7refXKsZ1pQ40XGotrhraAlpjXA1NgFDqq	2
415	Leroy	Horsewood	lhorsewoodat@theglobeandmail.com	2024-08-11 10:37:52	$2a$04$aLe1//X15WVmZlebBM3bY.FI4MZeVFw0ZhFqip.nMDHbMC/Nc1Dqe	2
416	Pandora	Linforth	plinforthau@plala.or.jp	2025-02-24 09:58:16	$2a$04$MfEyLB0kfx1BoosIgMdkh.xLRhV9uuEaKv0DPJp.Btr4koiZzoDau	2
417	Ashley	Good	agoodav@cnn.com	2025-02-21 04:47:36	$2a$04$6LNsDzqDTT95ipSEfEJPbuhmGUdOS6LpzeEH2koAgKTk9wM2qSPRe	2
418	Jacqui	Emanuel	jemanuelaw@go.com	2024-10-31 22:21:45	$2a$04$cNfoAqv7z9RjqBvgygKVdOSC2raGSMCeQXvV3ngrFvRHGqkA9sofy	2
419	Josee	Barkway	jbarkwayax@adobe.com	2025-01-31 03:37:22	$2a$04$Ox13mTkwESCP0bETnstjq.SLTaI8NwcuMvBQ/gHi5Jxod7TYpmycK	2
420	Analise	Elt	aeltay@instagram.com	2024-07-26 12:49:45	$2a$04$QOKrad.H.ysBMNACRwrkIuOhOaufylccOtAOviZURMV.wNJBeiNwe	2
421	Brittni	De Gregoli	bdegregoliaz@newsvine.com	2024-12-15 13:43:48	$2a$04$.XC3TmU0GZMJvHbmisdJSe97xRoUOsnpalJg45iRCbP9iBmMYYYMO	2
422	Josey	Mulrean	jmulreanb0@t.co	2024-03-31 19:32:38	$2a$04$MrY8Wz5l7iblZ4r2Ln.wI.iQ0tOqHiEAJ61E4ZME6VTzoY2hgomX.	2
423	Roxine	Bernadzki	rbernadzkib1@ifeng.com	2024-12-20 18:06:47	$2a$04$KP/ktv20AvDRCLC9ysWIW.2PSjGG2M.zDMWMOSy8mCiBQN.VKJtNm	2
424	Lilas	Deluze	ldeluzeb2@utexas.edu	2024-08-12 16:58:15	$2a$04$dwJXN9KoX/T8lAKnGJ9pGOhIAsy1zbiEfdxYLCRckbLNFoOdwoIJ.	2
425	Mauricio	Trent	mtrentb3@stanford.edu	2024-12-21 14:12:56	$2a$04$E0g2X5WGpY6NbyiAwL5tE.LYmNavfeLauGMQIj1j6Gw1j5kuUxGlC	2
426	Ninetta	Visick	nvisickb4@cdbaby.com	2024-12-21 22:59:25	$2a$04$jwGrLiobFDlRP/xfEgvnwuub8evYzMrzztxVCIMTC/ju.hzbY2lqu	2
427	Gayle	Toffano	gtoffanob5@qq.com	2024-09-12 14:03:05	$2a$04$yLra/48gbuz3u0XWo/hVrutR6Fk.kPWZD8zLtPRLii0YYUYxfMs4S	2
428	Jaye	Tuddall	jtuddallb6@etsy.com	2025-01-26 17:16:33	$2a$04$I0ZoiBJlHf2O.7kiivvCZu4Zp5eiusAquug.2XLRVbjWKt0JcfAtq	2
429	Vitoria	Kleszinski	vkleszinskib7@icq.com	2025-02-17 02:20:58	$2a$04$4i618973NnkgyJ2SN9ntFOUAMiMNb8TpXhQF8qNT/Xt8OuB01P2bm	2
430	Justinian	Melwall	jmelwallb8@cdc.gov	2024-04-24 16:19:45	$2a$04$L..EiY82Kg5gjMtIUdU/I.obdubWvyn0OmciEwP0C9o8jmS2juIke	2
431	Aridatha	Nobles	anoblesb9@seesaa.net	2024-05-05 04:49:29	$2a$04$mzrLicjTJEMhF4akhSbWvOhz1a7OEgiGmmqlPS1nO5MyKHikSBgNW	2
432	Yolanda	Hardacre	yhardacreba@cnbc.com	2024-07-23 21:47:26	$2a$04$bPkyw48k3px1nMGrm/mXOekVuwuxLMLBvCAgfe/P5vQnpeGGbEANu	2
433	Sonni	Salleir	ssalleirbb@earthlink.net	2024-04-23 09:08:01	$2a$04$5z.R86F5zGKqq2EnZxbupu8wIeuK1UHOtllohSPh6Di0TQqvSL7zC	2
434	Happy	Wofenden	hwofendenbc@skyrock.com	2024-05-17 00:09:40	$2a$04$10H5Z8b9yYwmUn4SSiCeUe3gY0VFtdvpa3ev40T4J8w5quKKNa4cK	2
435	Bernhard	Branchflower	bbranchflowerbd@wsj.com	2024-10-29 17:47:37	$2a$04$5ZgTov0HiHFh3h8S5KnAX.snkYT7c7QDiglG13J4uzQplSGgpcfG2	2
436	Jacenta	Lerego	jleregobe@amazon.co.jp	2024-06-21 22:23:19	$2a$04$bupseGHMS3n.5FgO33qHbuIYcdIcbgIqjesNo8FZZDSXkQJLOMlqe	2
437	Giselle	Feldmann	gfeldmannbf@deliciousdays.com	2025-02-16 10:11:41	$2a$04$8PLOV86e.bVujtNFSfLYwOrsXmMC2ueZIUGavtlbm.tGYFfotLMRK	2
438	Derry	Gapper	dgapperbg@odnoklassniki.ru	2024-04-14 03:42:45	$2a$04$fVIBXnXSaEYTnwuYptK/0u/d8X2xi1qpLSF1v1wZg1.RoLAMkf4oa	2
439	Drusy	Cuming	dcumingbh@bing.com	2025-02-25 04:43:06	$2a$04$UqR363djgn6N4d8QydDMr.Tz1ueMmMkxpAaLEQxHa2PBLdlsFo13C	2
440	Giustina	Granham	ggranhambi@about.me	2024-03-04 05:04:28	$2a$04$P.iVxv3v.eGaUxxxDxPIiek0M7OSvJPWUp6l.dyUFZMdAqMSho5Wa	2
441	Florence	Spain-Gower	fspaingowerbj@myspace.com	2024-07-31 19:51:45	$2a$04$1Ry5adyl6NbNrr.M5icNOOoLjFA7R.ziQJK6gIHE8NMJh3fYhKYPC	2
442	Taryn	Skotcher	tskotcherbk@wunderground.com	2024-10-31 16:20:56	$2a$04$e5twzpjMiK5X3CqthxfeM.jT0fkNFvJvWoDUqlX9GGdNjcOuzHcrS	2
443	Angelo	Kyffin	akyffinbl@shareasale.com	2025-02-11 14:35:43	$2a$04$dUFo8EsrZXfMLGFEqog.T.aOk4kOQ2O09NAX4EfyGOiL4msSjb3Na	2
444	Isaac	Guage	iguagebm@icio.us	2024-05-18 19:02:14	$2a$04$sccve8HOoq8T3ncZdosX9.h7lm.hAJ5212mXrJNsnXUiRFrdaFUdy	2
445	Deanne	Kloser	dkloserbn@creativecommons.org	2024-08-01 01:38:55	$2a$04$rMMV.0ApCwBeJ6auGoSmDeQHJg0gq8S3oHUwcz0KiD7Vgj08Ju4Te	2
446	Mandie	Pavolini	mpavolinibo@wikia.com	2024-06-11 04:03:47	$2a$04$Ema20Mn9bc20JX6Hy.3kS.OEOSENtLwCtMlQxPLunL/Gh00Eot/Sy	2
447	Chariot	Olford	colfordbp@pen.io	2025-01-27 09:23:37	$2a$04$GVUu42sE2cXzinJa6JzL3uyLRxngoivv9cN7ACjEmYspj.NZXjpKS	2
448	Corinna	St. Louis	cstlouisbq@yelp.com	2024-05-31 07:40:15	$2a$04$HUU1vUcHCoXwrfy35kOlWOwVJmMKQXgchW6thOJX8n9o1N/1unmqO	2
449	Sharline	Sexty	ssextybr@odnoklassniki.ru	2024-06-07 12:12:02	$2a$04$SF54lL64nXMMHUJxtuBwf.Xrd6u3YOQfKoOPyZmXMqgJCH8NhPvr2	2
450	Ameline	Nouch	anouchbs@princeton.edu	2024-09-15 19:43:55	$2a$04$kPSpfzxgxGr5XgNEDGXn7Og2GzlEMF1pL3/iO6CTtLLJ.3LCI.VTy	2
451	Aila	Nagle	anaglebt@unesco.org	2025-01-17 22:57:47	$2a$04$S7mSPy3X65d0r2KyK3OA2.zPY3XdD6jrTXaNX6K/755k1FHgql6VO	2
452	Mord	Slinn	mslinnbu@oaic.gov.au	2024-03-03 17:47:08	$2a$04$M2/AD6T.Xw62CxAy46dEoOgNrcp.pr8fFxxFvVzj458veToHj3osa	2
453	Maxy	Reggiani	mreggianibv@nbcnews.com	2024-06-26 17:10:34	$2a$04$Idnr7JOuMEWAMgLSlwOaQ.AgLpYSiFJq8Cd78FdaEqNqpZwd48yIS	2
454	Sharl	Dyers	sdyersbw@w3.org	2024-12-08 05:44:27	$2a$04$z.kIykEF8g1Hqo3D/fTs0.UdzQRIHwnFm7RA3rH9AGTkv4e9LMMte	2
455	Bea	Glowinski	bglowinskibx@webmd.com	2024-12-08 03:56:05	$2a$04$ChofQbBOAzabOy2J7OnBvuum23r5fXaHvE98cvFd.KvLN9a3Wh0se	2
456	Kermit	Kimble	kkimbleby@columbia.edu	2024-06-02 04:54:56	$2a$04$fAePE5Takjgd5o4yEarfU.RsmVDDEd0ScvpoaWONiII4MLo8dUYKy	2
457	Elsey	Gunney	egunneybz@drupal.org	2024-11-13 14:01:26	$2a$04$Tu5YITyJrLmAhrktVMt4bO2mFzv33ny0.o3jQnP.XwKpx1CNUYqqW	2
458	Veronika	Moneti	vmonetic0@webeden.co.uk	2024-12-30 11:44:27	$2a$04$Niu1r8c6KtJSzaXvj4yPdOQmKf7OjfNKFK2OLx7CXUxOKjIsyXW5e	2
459	Olvan	Tiltman	otiltmanc1@trellian.com	2024-08-22 04:01:13	$2a$04$/TtQ29CXaOKMdcNsSET3ROcPZ6N1S.envGbpzrowUnI8iA9/gLo16	2
460	Sydelle	Ricson	sricsonc2@vinaora.com	2024-07-10 09:14:40	$2a$04$e3JcWmJFkRG1UNBgiGNzn.NjvLQrkjLeraj.rEZEhXvHbkGS4E/q6	2
461	Charmaine	MacTerrelly	cmacterrellyc3@google.de	2024-05-19 23:28:22	$2a$04$.tgR5Ocg7uzmkucmmobceuT5trFNxnF3pL4guncwPy2X/aJp4jPbK	2
462	Adelice	Gerrit	agerritc4@rambler.ru	2024-06-28 19:14:18	$2a$04$4qzimXm680qaSQGbBWOkBO3bhl3pfycZ9UbQOLhOSIrV5qerFtV1.	2
463	Allianora	Pesik	apesikc5@wikimedia.org	2024-08-28 15:40:29	$2a$04$6LdfVjZhrrMz9d.a9dKvAe3jWWQmzTvfaodsb9mWjkTdAgDb55OPi	2
464	Veriee	Dannehl	vdannehlc6@facebook.com	2024-11-19 07:46:27	$2a$04$nJkjphNLyJlOF8Mm4zq.0ulvYrEuByhDPWpOIgja5EVAG1c0oERY2	2
465	Shep	Baggally	sbaggallyc7@arstechnica.com	2024-10-14 07:21:03	$2a$04$Aa3jGMV71T9EBwtLsVrmyOAmwrThLjSKLQJDjJw1Rq0H2ucUft6vK	2
466	Karoly	Recke	kreckec8@cargocollective.com	2024-03-19 18:08:25	$2a$04$Zietc.r1ZRzxsiDs1Pumze/BvbhCPtEO./CbIO8aE1z7B6JR68UPa	2
467	Bibi	Phython	bphythonc9@1und1.de	2024-10-16 20:06:18	$2a$04$.mj5VKr/h.5FeHQkifwRvOTgSHoH0cwpRzlo9tL7o/PpWaGXU1H3m	2
468	Eduino	Chidley	echidleyca@live.com	2024-03-11 14:38:37	$2a$04$S4B4/1Xt8sjIDoCU7e10LemgNLtVNQ64hkv0Y/rhDji.Dlf6PaDC.	2
469	Skippie	Pennigar	spennigarcb@google.com.hk	2024-06-08 04:00:03	$2a$04$OnNUbcn.noozfGBD7EUcJedoEppRH4W.UV98ULn2sE2vAmzr6pOma	2
470	Candi	Walmsley	cwalmsleycc@yale.edu	2024-11-19 18:58:00	$2a$04$p03xXSkncqAxztf3Og/Kbu5RMPwViUuvl5y4X10ni1t7KoypWm/c.	2
471	Torin	Garnett	tgarnettcd@flickr.com	2025-02-12 22:21:00	$2a$04$G3itBs1jwjta2g7mMvqi7uncWhZXJ9jJsEklqW15nPGhBw7ICp0hm	2
472	Kennith	Hubbucks	khubbucksce@theglobeandmail.com	2024-06-21 16:14:00	$2a$04$PL0mQXfGcr1G2dR.d6hz7.uOEAJ5Al0YcB/pAwUSprHmfk7vwPn2a	2
473	Rourke	Lindro	rlindrocf@scribd.com	2024-11-04 15:31:14	$2a$04$l0gxS6YQXy6yw6IzwE6PaurPj8jOGrEAbHClaZHpzqlGB/.B7pQvK	2
474	Maria	Tirone	mtironecg@boston.com	2024-03-12 20:14:25	$2a$04$DqT1Cto6XSb0.8lsqagQeuR8sm1BhEQy6DdU0/LFtUN4LOnaM.XtO	2
475	Rudyard	Yurinov	ryurinovch@digg.com	2025-01-16 06:21:26	$2a$04$BS2jUb8B0sN4B86PIdh9heWZXgStqzJLjlc9aeYZDb9rWi5Boy.Ky	2
476	Laurene	Rohfsen	lrohfsenci@4shared.com	2024-05-23 22:07:31	$2a$04$BxD6hPYjqbMCFazpDBMHz.jSq5dhnu.ERD9II0kBuQVjY4qRbnJdK	2
477	Conney	Korejs	ckorejscj@cmu.edu	2024-08-15 12:26:55	$2a$04$FULDD8W/Yrmfu96lmHwBoOFsFDCXfYkJiKga8RMiV15M6s0m9mgEK	2
478	Dill	Brum	dbrumck@list-manage.com	2025-02-10 09:14:02	$2a$04$qxBOfHLDkHB3sBnt/FH/gODxFo8W9v5NmFqGgFLUMGYIL5AphgBm6	2
479	Lindsey	Spoor	lspoorcl@blinklist.com	2024-12-05 07:20:32	$2a$04$RapNUnEEFwyvQ7LkNOYCrO.dmIb9nQlYD0Vpty.qsm9SSk2CWBw0W	2
480	Biddy	Alcock	balcockcm@ifeng.com	2024-09-29 09:06:13	$2a$04$U1WK0ozVhoC8VKdFAroaLu0nEJ/fGOfwYDwSAJOfmjR7dGgZxQhbK	2
481	Ewart	Tregear	etregearcn@engadget.com	2024-08-17 05:14:02	$2a$04$99aPqouA0uh9kV0pzYYwMetJpQvdGFCJv5jPxRbbEvr3RU/hESu2.	2
482	Cosimo	Ruperti	crupertico@google.es	2024-11-22 23:34:02	$2a$04$XFNzLCQzgvOe342ifpmqM.YA.dWoxXt8Fs1o6g3gLLimwVkFjSE5G	2
483	Blayne	Blofield	bblofieldcp@lulu.com	2024-08-05 03:14:22	$2a$04$vue4EFdbn1Vic.ARGMX7iuO9smRSKsB6TBjzIsiRwWtNTG/D3C6Wm	2
484	Keely	Mayers	kmayerscq@mysql.com	2024-07-03 03:15:08	$2a$04$FX2Gdp0OFpFfC/AQLlDpuuNSunft4sp55wY6OtURA.KWxz5xGv4gG	2
485	Neddie	Veronique	nveroniquecr@edublogs.org	2024-09-11 17:24:01	$2a$04$DtjWT.jiljFb4d2VoVH4TObyNJyNlucFs9qxv.iDQpLdC0w7SNNGy	2
486	Almire	Piotrkowski	apiotrkowskics@army.mil	2024-05-05 19:03:00	$2a$04$KZUTBQ.66V8zw6iWTC5AiuI3A7PoRN2adFB13LlHSO06Z4yFm7KLi	2
487	Millisent	Dominka	mdominkact@bigcartel.com	2025-02-05 18:59:13	$2a$04$jKDJd2BAlc6VeUzelsAgGOycINm.bGDdJJXdGypbLGMl7d7ct00HG	2
488	Hadley	Coppenhall	hcoppenhallcu@vkontakte.ru	2025-01-31 22:26:15	$2a$04$kaPWsu4T2aeW53qEdvmQIOses1/nwZU1.U5V1Qg/raJWYv9dlIwQu	2
489	Estrella	Wilfling	ewilflingcv@ucoz.com	2024-05-20 07:43:28	$2a$04$fWGkwq5LBM3MtxkXvgejn.fk65vJPeH81odIj8aMf4uJaznsSX48G	2
490	Renelle	Hengoed	rhengoedcw@histats.com	2024-07-08 09:20:41	$2a$04$k0vghivGGCAkk4jxpbVDU.gc7aQkVdIwQ7okjCdMNLgNJ.LCLllde	2
491	Zahara	Musselwhite	zmusselwhitecx@360.cn	2024-07-24 10:16:02	$2a$04$BwNFSiSzJsEWFvmEcwIu6.mz96sK9vwm5C0IRgldysMv3sjr7B8JW	2
492	Alaster	Craiker	acraikercy@freewebs.com	2024-03-14 21:08:20	$2a$04$PvY4tjYVXCGx6wx13BF4geYud9g0498LSRMfFfjMJwmIe514EpsSq	2
493	Dacy	Garwood	dgarwoodcz@bluehost.com	2024-05-20 23:32:23	$2a$04$YHXYnB8EaQGF/GYRwrk.keQ6o0UYyv0NgHfBM9v00vNvc0iL1HFZW	2
494	Justine	Chattey	jchatteyd0@vistaprint.com	2024-11-08 15:45:59	$2a$04$vcvfg6aTmnXzZs7Q0Mqym.7jXOwud73MeRkGgRuHPkIEqTT19x1re	2
495	Shaun	Crockatt	scrockattd1@icio.us	2024-12-30 03:01:29	$2a$04$/vtgHVYj9FvI3HeNa5WT8etu4JLZje9OWlIORz3Rpj9iK7N/kmWsC	2
496	Shepperd	Bwy	sbwyd2@networksolutions.com	2025-02-18 03:09:07	$2a$04$T3itLiPQbVafxCj.PoYVaeZAoKs76SUsv/dJz3dQ/TAVa5VlfliK2	2
497	Sibylla	Tremethack	stremethackd3@sphinn.com	2024-09-16 02:21:52	$2a$04$u.HoBPhL8Zc0JhMfifIbre1Kj6rhssyOst/y.W52qVgI.EXSplG02	2
498	Camellia	Bownes	cbownesd4@yandex.ru	2025-01-24 23:45:42	$2a$04$l..fSylLSP0clHwkYqSLHOk08aBV1H5IGLoqke5ZWrwTqNqZhURui	2
499	Elonore	Culshew	eculshewd5@nih.gov	2024-11-06 13:41:22	$2a$04$/Fa8yOpFJr6ckyLRWlyq3ujNrGFx3jA4kr2RF4gBTXZSt7Oc9YfqW	2
500	Ferdie	Chidley	fchidleyd6@deliciousdays.com	2024-07-08 19:47:24	$2a$04$U6YdgEsjc8QpxBuHRa1h7.K54I4aNbuB7lGgii.ptKj.rlngR1Tbe	2
501	Harmon	Ollin	hollind7@google.co.jp	2024-05-17 10:10:19	$2a$04$t9p/M76BJiND7XcY18pKQeuhCpfGmLviJfeirLT1Zp45T8kQaTS/a	2
502	Rori	Haken	rhakend8@cyberchimps.com	2024-04-12 10:17:03	$2a$04$m1Ha2GAJyFtsSzLzOSrjpu.7giIiM9bT19I.pTOdGk76gfNO85d/q	2
503	Langsdon	Ruddin	lruddind9@huffingtonpost.com	2024-07-24 09:41:16	$2a$04$HZDpxlSJJ1fiPvQ3G3nksukLM9XsCZF90luq3qpgExQ3N3sq/sYu2	2
504	Cherye	Port	cportda@statcounter.com	2024-12-15 23:40:21	$2a$04$0EhvORvZiZqzJOi1zkRLyu5tQcfwrAeFRRf3kuKIWUTrTbxv4nIve	2
505	Evelin	Bellow	ebellowdb@g.co	2024-09-04 05:09:13	$2a$04$GgxAB7CrLpemI5u1i8ElReAxeLrK7qLclZH5VkMnxYBkYNQLfgSWC	2
506	Laurice	Lukes	llukesdc@a8.net	2024-10-23 07:09:57	$2a$04$IyICWPWJ8x32sXFoTcrNL.IApUeS1a1UunELyEbZ/lIQnl4VvzjRS	2
507	Reggi	Stratten	rstrattendd@independent.co.uk	2024-05-12 18:52:19	$2a$04$NnOe7dQROFIyThSAqJ6Wq.ynjTQyv/1xzCDK0.cWGAaL9m3nJHz8K	2
508	Chauncey	Durdy	cdurdyde@eventbrite.com	2025-01-24 21:50:28	$2a$04$DhdjVgH4h.gkJPEocS2YZuftQvG5fjoah2sqaav2Py1zlJxDZDKLy	2
509	Adan	Sked	askeddf@squidoo.com	2024-08-27 20:47:49	$2a$04$pl29MzamIe9tZkFRT0S3s.rfOduucsY4csa5ITkyOzdAxK9EKkWUC	2
510	Janie	Derrington	jderringtondg@nbcnews.com	2024-05-02 06:10:34	$2a$04$4v6D38inzR3BQHqjkz121OC4BMqQ4uhzm.62hT4Tv3Y6m1WecZS2O	2
511	Creigh	Blackey	cblackeydh@goo.ne.jp	2025-02-17 18:09:56	$2a$04$dSRVArwa7SDWErn7gJ9TfuDG79LnMeuaBD34vSTvg62wwfbUmGoz2	2
512	Isabelita	Craisford	icraisforddi@abc.net.au	2024-11-21 03:29:00	$2a$04$9GWRUyQtGoXVcMwGC3/Bd.Yg8bszcfnpu1kMBEt4nr/EuXKGD./be	2
513	Darn	Standring	dstandringdj@dailymotion.com	2024-10-20 12:01:17	$2a$04$FVUeqy4aZ7BKOSfgM1cP8u1OZznJQwkCJ4.yTYwv6yRVPPv6366B2	2
514	Merell	Wennam	mwennamdk@boston.com	2024-10-25 13:10:14	$2a$04$nlVwpDGUU8KFWIAuetsRduFuDE.rZkfqp/HQ5DFCbBmAiIVm9AKDi	2
515	Teddi	Aven	tavendl@blogs.com	2024-06-02 10:18:47	$2a$04$ycayhHOY3Wh.BhCJr7rjVuyHrw6njyLC5Wn63IcLSCQPgOebqV8Ve	2
516	Vikky	Klais	vklaisdm@skype.com	2024-04-21 06:51:16	$2a$04$DUM4TJeaLXIsiBc8neeMKuW/Q.TBgXMtZUooS2juH5VRnGT30Bvye	2
517	Dimitri	Maffini	dmaffinidn@yahoo.com	2025-02-23 01:26:55	$2a$04$TJ3gv37WWKK9Hamc2PL0FuJ7bePYGpu8gODPjecE.88tQjcZ7li7C	2
518	Paton	Manuelli	pmanuellido@mit.edu	2024-04-25 06:07:37	$2a$04$Sh2rV5voeTjW6kjQ/T6ZnOTdv65CJ/B0.CvHFEqVhGXw3nfAyesyW	2
519	Sidonnie	Pennino	spenninodp@springer.com	2024-03-23 05:09:36	$2a$04$/QJNGEqYb0bkPnPD726GM.Wv2pRqflAe6RzcUgUXe/nRFboWMB63O	2
520	Jo ann	LaBastida	jlabastidadq@google.co.jp	2024-04-09 17:05:38	$2a$04$M/Qf66tTtQCRYaEQqklUIOVo8.q5JMdfPb87aisd5D.NcxuxdlFSe	2
521	Carlene	Finden	cfindendr@twitpic.com	2024-08-18 17:23:55	$2a$04$EpRWtuMRyQkEDe3TG5sXCeRnZBZUjazDcuxnjePk7JXd/qQqQxBIy	2
522	Dolli	Siddeley	dsiddeleyds@drupal.org	2024-06-09 12:43:22	$2a$04$j9LezLQex05vSbhFB2ExBOcubALkRohXwjfuPDtaIT.PaYPXXBQ0W	2
523	Iris	Firle	ifirledt@bigcartel.com	2025-01-29 19:25:01	$2a$04$CtRV5s6KJzjFcgARpRB7veLmDKGMR7i9Xq2xV5KHrvWWI2ZHFoCNO	2
524	Ware	McLaughlin	wmclaughlindu@psu.edu	2024-09-03 17:58:38	$2a$04$eIZe1MKbAnvTjrIDcEcOpOqZSGh9tFQA2eHXnBMuacBPJWYjht496	2
525	Townsend	Spire	tspiredv@github.io	2024-12-18 12:31:13	$2a$04$MRI8hkVm9AqcFtgJpVKWG.g0d0/iJmM3yBdlOhhtdpsBVY7APkC8u	2
526	Vania	Cadwell	vcadwelldw@cmu.edu	2025-02-17 15:15:04	$2a$04$T8eDBQJlQDH92RVWtat8oefqzpN99.w1zoQ8qIv3CZl1CiZU255X2	2
527	Odella	Diggell	odiggelldx@sciencedaily.com	2024-03-29 22:53:12	$2a$04$LtIU1eWQnQvJDEtyvfRhA.lZKH./sYwuF2fnOW4P2WFQqH.iPosIG	2
528	Jessalyn	Winterflood	jwinterflooddy@theatlantic.com	2024-08-09 03:43:15	$2a$04$.hh4jh9aLnNn6O6Nm0kZvu8ou8VcGglMwzlN5gkIfQr0wNKJoaXQi	2
529	Jennette	Gaither	jgaitherdz@icq.com	2024-10-27 15:07:08	$2a$04$klZHZFIKKQ5VTOiNcb/tpeLIwNH0bSUxgQpeIwth4AkdshrExnmF.	2
530	Martita	Starbucke	mstarbuckee0@scientificamerican.com	2024-03-21 18:42:15	$2a$04$zM.KDg0JTKSgQTigLtxyZujNrduR0lQdcOF4FSRRdg3Y3R2z5yPzK	2
531	Niall	Vasilyevski	nvasilyevskie1@amazon.co.uk	2024-12-18 10:26:43	$2a$04$FsuLi1ZA3WLmTmYPQTmmju06F6vc1Ztusggk.c6YQ6sd2c6TutPoa	2
532	Ethelbert	Jiranek	ejiraneke2@biblegateway.com	2024-06-21 18:17:18	$2a$04$yKA8NJq5J.sKGmu9sjIJ9Orhp5fB7f44GqZfu5kgdsZC.wu3tqLZC	2
533	Alexi	Pawel	apawele3@goo.gl	2024-09-26 17:44:16	$2a$04$dfBHkJb/xqbWLytMCg.j1OWQJ/OZOZEyUGdAUtpt54lWuEZHNTStu	2
534	Milicent	Frankiewicz	mfrankiewicze4@goo.ne.jp	2024-11-14 22:32:35	$2a$04$J7.YwfE9LkitDmGuT8g4je.a1S5Fmw1tcVgch7cSlH2V53m1/EC/G	2
535	Delores	Rodder	droddere5@yahoo.com	2025-02-12 08:32:39	$2a$04$o94IqyqW1VfyuH518zClauwfITjgYKvXPZA3no6zwL7reLROAjNx6	2
536	Sara-ann	Espasa	sespasae6@house.gov	2025-02-24 03:52:15	$2a$04$6aqtV8JLOlhqtIHSzOSqZe7WknnntnQr3oeH7OLv.tr44zUS1a9La	2
537	Marcellus	Brookz	mbrookze7@hatena.ne.jp	2024-03-30 05:53:36	$2a$04$7X5fZgz.AYbWz4aNGLxt3eWgMReH3Oxgkijl4mpfh4j0vROwluGbK	2
538	Kerby	Harmston	kharmstone8@wsj.com	2024-07-02 01:18:38	$2a$04$Riz2M7pLPo624zyCZtoSKeswPZv9w.WhCGkXZ3tB7sybkem0ssf5i	2
539	Yolane	Decent	ydecente9@google.es	2024-04-05 00:12:51	$2a$04$f3rDyqGCvELvy0QsllNrVu9mHgPdIulGr75KQEeEQkwDokPnGatMK	2
540	Maddie	Stollard	mstollardea@alexa.com	2024-05-15 09:04:57	$2a$04$MFt.cMg0haDmpimfAcSEY.WCV0hlYskCu5ZdSHcn5o1/AE3K/2mBC	2
541	Sioux	Nibloe	snibloeeb@sohu.com	2024-09-01 21:51:15	$2a$04$EWdsgQ4wmOcCHuIutbT4eOH9Ic0.PiWXiXWeESl9NnPzhLBo1dWnW	2
542	Crosby	Vurley	cvurleyec@earthlink.net	2025-02-28 22:58:11	$2a$04$Az6J96fg4Jpwf0g75H.vi.Q1yjDZV2UzqISdwpWwEYF7rwc9V0zOu	2
543	Nehemiah	Rix	nrixed@tripod.com	2024-06-02 23:02:24	$2a$04$8v.lJi6gnXxnnURHQDfW1.mo5Sxkfh.mm3Ry53pmEmac1L27a62ce	2
544	Amara	Karpe	akarpeee@xrea.com	2025-01-07 21:43:32	$2a$04$dWu1apcoju8fve4i.bN8U.YIP5WSYT..t40Ugu8NJP4VP2IP8IPDa	2
545	Barbara-anne	Trask	btraskef@dailymail.co.uk	2025-02-13 04:41:28	$2a$04$ubpYPFSwSyqKRigag3NrDuPlM8hTOzS2XMEYW2pU0JYi.c4i7kg/.	2
546	Kathy	Robertazzi	krobertazzieg@wsj.com	2024-03-29 00:25:13	$2a$04$74LXW1ucRl7yZ0ZX6cBAQ.oJoyothqWMxY22VS/inZK6Xl1tJzdb.	2
547	Darla	Honeywood	dhoneywoodeh@sina.com.cn	2024-08-12 21:59:36	$2a$04$v/4nV8PKXhYB15w9lyiX7OGPaG5InI9HxwWZ49unxoFOSOe.oVcki	2
548	Reggie	Stribling	rstriblingei@github.com	2024-08-21 14:57:26	$2a$04$N5VA/iGswk1qfuJW.ndyP.3l8Gv3A5mnBT4xcNmA15fwk2RUakdAi	2
549	Elladine	Burr	eburrej@google.ca	2024-09-05 00:14:28	$2a$04$ZeJoXnhcx5j9V/7SyCofuOPKSm3SbfqPdvR.Q0lCOW5I6SU43ZkZO	2
550	Estell	Corroyer	ecorroyerek@naver.com	2024-08-29 04:51:52	$2a$04$dxmjQCYtEEggKU.O.ZJP/.c0ZDb7xWW8IPrX0t3PZhABQWrhM2xGi	2
551	Charmine	Haselup	chaselupel@fda.gov	2025-01-22 16:31:39	$2a$04$sl6hoCHD0Kjy/PzbzrjEW.hTjURNrZ11AXT5MZtiozN8rTXhUSYn2	2
552	Aymer	Peirce	apeirceem@mysql.com	2024-05-26 14:49:26	$2a$04$5NzdA871wl7VxuKDeRBqJOr0eJjxcnOFAYuVkMNIO1JpZO7vsPgkW	2
553	Gael	Blakesley	gblakesleyen@businesswire.com	2024-03-10 09:10:46	$2a$04$sq9lKtBZzE7YaAVAVmGJlOM.oSatqaxn.pH/gtTk1.AMPInZwumqO	2
554	Holmes	Goldsbury	hgoldsburyeo@cargocollective.com	2024-04-02 00:33:08	$2a$04$FOvPCwUI52ojsNKJ3c3VFe2.cPU5rB6M4yYJiDjHv6tgZCZNciRpa	2
555	Kinsley	Easdon	keasdonep@arstechnica.com	2024-06-21 13:24:01	$2a$04$QUM1S8Vzo1QUgkIg8CZPm.hoPdF5KP0P6NYRvhZ9d093rB.wydnde	2
556	Pierrette	Rickardsson	prickardssoneq@wired.com	2024-11-23 06:36:13	$2a$04$92kFfHWz7zXRwS/4fC2iW.1ot3gTXoks9KUXWNoNiAqdeQfNODobG	2
557	Kathryne	Doddrell	kdoddreller@statcounter.com	2024-06-02 21:07:38	$2a$04$YwDj4FlxQ3tvcyIAIE9g9.dmM6buuf.7FKp9Mox1BMK/Gn18BXzum	2
558	Gui	Rodrigo	grodrigoes@soup.io	2024-03-13 15:39:10	$2a$04$sc1lHqWyLV4BO/dUVZYzNu6eYIA7s6UUNObvvxpk04K1SVjRJ/irG	2
559	Alix	Kestian	akestianet@constantcontact.com	2025-02-22 10:37:30	$2a$04$inFkQOtOJgWQcImPM0b9k.AkHymuvGjtbwt4XaduaDYd7Ycshj4xq	2
560	Yoko	Cropp	ycroppeu@reddit.com	2024-08-11 11:58:38	$2a$04$h6MvD26uhiVMCcJb.mA/jOl9RShtj1Yp.JTEGf1BmS0YVbBItGR/S	2
561	Niki	Soppeth	nsoppethev@bbb.org	2024-04-27 05:47:07	$2a$04$x3mb1XG6pvR2aGh6O0k8IuEyx7ySChNK9n6exidJ4hTqUu6tmNh1C	2
562	Cassy	Girardengo	cgirardengoew@sciencedaily.com	2024-09-24 00:24:44	$2a$04$MnJa8UazQoT/cE17HBQ3S.3tJeP5dV82fO42xBq1R5VjOwb1D8/qu	2
563	Gabriell	Badger	gbadgerex@oaic.gov.au	2024-07-26 23:35:29	$2a$04$kKG6c.h3TtOrqJ5YWsD2FuaR4e348zUnroHTSd47KQND5ud6w3YVe	2
564	Marget	Clausner	mclausnerey@soup.io	2024-11-11 14:07:09	$2a$04$DQYr.BvXCtyy0qD.z7LGjeKPiRFwwbQCC8C7eJ6ban1SIl3FHqQFu	2
565	Yuri	Jeffcoat	yjeffcoatez@sbwire.com	2025-01-15 09:39:57	$2a$04$whio2kaaaT6XsfB/nl2iwu3LFZz7SHfyqePAaORz2yEBjzb36yI2O	2
566	Kira	Doyley	kdoyleyf0@arstechnica.com	2024-04-23 13:53:13	$2a$04$YVACBXorPNXSkK7eMX6tJ.TXe7kVVmEMXZ4.CP4koT.YuF4D0NXKy	2
567	Sammy	Mcasparan	smcasparanf1@wiley.com	2024-09-01 18:37:07	$2a$04$29IV8W9QmsFqdID3TfSXcOh8vGjMwGxAtTkubdJ91N3GxoQVXuoci	2
568	Elisha	Fetherby	efetherbyf2@oaic.gov.au	2024-08-30 06:39:23	$2a$04$xAQeSj92sAZvwXnbqXvlmet24JF82MiNtbCIqZtxL5ZSQlYUesIcy	2
569	Marigold	Riolfi	mriolfif3@ehow.com	2024-04-24 16:51:45	$2a$04$hhQCO1t1mj0juatMD7dsYO9NFOWSbCNbl3.Xi8gsiKIf300UCkqPO	2
570	Cathyleen	Bennington	cbenningtonf4@tuttocitta.it	2024-03-16 05:53:40	$2a$04$ptHE6mh5NBy..XtdP46j0esRE9lVbtqoPhryGwUg4vkgHdHkC1MQq	2
571	Bartie	Emmet	bemmetf5@mediafire.com	2024-04-06 09:57:34	$2a$04$fvqorcHbbnXu8E4URG2dB.xSY2Tk5luZ4N2jP.bayFDGbqAtBgyg2	2
572	Betta	Haborn	bhabornf6@booking.com	2024-03-23 01:46:16	$2a$04$/F/SHOVMUAOTsmrzNp/NRuSwtus0lHDWlN/StvBtMlLaPURBgucgm	2
573	Bryanty	Szymanowski	bszymanowskif7@mediafire.com	2024-04-06 03:07:15	$2a$04$9.JQ2aMTnmwgRteU9DbNA.qeT9DvTTCvWKOmB/6ozwMKwxzgbvD0O	2
574	Paulo	Rash	prashf8@cmu.edu	2024-09-03 02:01:45	$2a$04$L4r36QApQesjh2ZCOoOIx.vaVEvl5cguj.XSV3LUEehOFYQJnYVIi	2
575	Margarita	Tidbold	mtidboldf9@nbcnews.com	2024-10-28 20:13:34	$2a$04$VG6Pis6p0KCjvjMRhywdGuErnyxEluc1ouSG96t.DsQHGgegXe2GC	2
576	Barret	Barnaclough	bbarnacloughfa@ftc.gov	2025-02-25 16:52:10	$2a$04$s1Q74eiwe6nND4gtSprNRedJH/wJhPom60Wa/jtfvTDwhqgp.G3g2	2
577	Lucia	Rowaszkiewicz	lrowaszkiewiczfb@bravesites.com	2024-06-06 20:23:36	$2a$04$YqWVLSF5fanL9bAQngzJbep6m84JN2bo7YeSIu0PPpntjFH.PHlsy	2
578	Gilly	Barkess	gbarkessfc@livejournal.com	2024-12-07 00:56:02	$2a$04$IyHeRd4iSi.lUhRnUZfCvu2Dps6jlDTcPqnmtBEcIg8TUTwlMdVWO	2
579	Nola	Matthaus	nmatthausfd@theatlantic.com	2024-07-16 14:25:23	$2a$04$VcVPRQR7FS1/EvSIXyiR4.oyWX2sDGaJOEzrhGg/bP/wQRqbyjjsW	2
580	Base	O'Spellissey	bospellisseyfe@hc360.com	2024-03-31 12:39:34	$2a$04$BHRfxoJXEFYF6iOazcCJFuLAoHau6/GiWfFNJqeQZodWqnx8bN4Ne	2
581	Connie	Dumsday	cdumsdayff@forbes.com	2024-03-24 00:16:06	$2a$04$zuJXtabK1szZ7W9Uc9JR0OObwOTQc3M.D26p8O1lfZN8ET5mpOg/G	2
582	Belia	Newburn	bnewburnfg@ehow.com	2024-10-12 04:41:41	$2a$04$92cgm6dCbT2wcHsz/S/qVOTO1Co1gSWed./4aXluQ3nqYLKPrxcOq	2
583	Simone	Fawcus	sfawcusfh@bing.com	2024-10-10 11:20:55	$2a$04$fLGqBQSxffOqjOLs/01a2eNpWI3hESc3DvBChbhqdZGZ1x73WvIf2	2
584	Sayers	De Santos	sdesantosfi@usa.gov	2024-05-09 20:26:40	$2a$04$E73g5RDEIqKfSpnvSImOtOKwkEYGclZrrr88J4Ks3gc1c6pUp8HFy	2
585	Abigale	Doley	adoleyfj@shop-pro.jp	2024-12-03 23:00:02	$2a$04$y6I6vANLr3DONF1E5r3pMuiiZ6RxXrAV4RvdHhdkCenjdcGY56NIG	2
586	Leora	Alejandre	lalejandrefk@multiply.com	2025-03-01 15:24:57	$2a$04$JgZbF6Lw6kSRkaNBXZRnFOysM7OX7k8YPca67MkvWIAKzM/aePoQ2	2
587	Theresita	Golland	tgollandfl@webnode.com	2024-04-03 17:00:41	$2a$04$W2ZLDXz6gvHZw.7e6IgS/.UdOAeqZFxNhlkXxPD7YfniStHFH4G9W	2
588	Vilhelmina	Gallaway	vgallawayfm@gizmodo.com	2024-07-12 18:16:59	$2a$04$DWBRD97parH29l2r8CiwluXEai.ZZ.HjhM.Is4ZY22dRvatAas/7C	2
589	Anderson	Swaffield	aswaffieldfn@php.net	2024-04-05 12:44:31	$2a$04$LtDjvMgbtZ8UkZo4FYpQVeo3LpitFlafnQKwH9NjnxWYx0ZBirj22	2
590	Magda	Geratt	mgerattfo@techcrunch.com	2024-05-30 15:12:01	$2a$04$pNj17./PFJgqYaZwl/ZnnO3wncWpc/al/8m88tqrGvZjap8JuNS8q	2
591	Sara-ann	Coper	scoperfp@dailymail.co.uk	2024-09-15 16:32:18	$2a$04$qjieWmmSZkBwz6w9TkRuNeN7A8OK1tKtvSmPY15llV2oqQT.o0qi2	2
592	Doralyn	Cambden	dcambdenfq@ftc.gov	2024-10-30 06:02:21	$2a$04$gXGHyWDL0O8bWld72xM/F.U69zBnxr4UoeX0b8LlcyDtsh/zDwHPW	2
593	Odell	Brokenshaw	obrokenshawfr@deliciousdays.com	2024-11-13 09:41:55	$2a$04$fCJONI/cMV0qHkE/7g6LIefDc9BhbRz/tb73b3G7DngFLyS4jFeFO	2
594	Kirsten	Lomb	klombfs@geocities.jp	2024-08-10 23:02:14	$2a$04$pLGD1wzqdjefD0SG6P4Ffeoho6cIgbPVbni2ZV4r4jKtRLeKl7CZK	2
595	Svend	Message	smessageft@shareasale.com	2024-11-24 04:51:27	$2a$04$YWeE2Uh7c15EPQONJ4.HHOGEI9NQvpb63atKhZu1.Wlpax.zQaMoi	2
596	Bearnard	Demer	bdemerfu@xinhuanet.com	2024-04-22 20:55:07	$2a$04$Q1vEOB6LigB.rpYCYnwJOe4xVrLyTTrjbplSegdP5EP44ulWxrElW	2
597	Sibilla	Shooter	sshooterfv@photobucket.com	2024-11-01 05:53:52	$2a$04$IA1Ma2OWpHq./3IEZyuFTuFEp.a8Tq0sSfoHD.luBmjcRhFRL4koW	2
598	Cyrus	Dutnell	cdutnellfw@bluehost.com	2024-08-31 03:10:10	$2a$04$G4.9o3lNdSxFyOlRJdw3D.kPgf9IzSTTaYjuNzKsmcMdOu20m/F/6	2
599	Christa	Brummell	cbrummellfx@illinois.edu	2024-08-03 12:20:00	$2a$04$ElxKrLBlwBeDANQv0o58IuwH3KC98vWtr/Huk96FlrQnFlEOmKCV6	2
600	Adele	Volk	avolkfy@ebay.co.uk	2024-07-06 23:16:00	$2a$04$gM1yg7jw5zCI1sDfYWuFOOx/L3oybfFBtvpBcof9U9Se1oZ7zw7M6	2
601	Ruttger	Aggott	raggottfz@unesco.org	2024-08-29 16:52:13	$2a$04$BeUdnu4F0c1ypdJ9QEMjcuIHYiC8etXayBo3yJCLUJhwFxRlGOxXm	2
602	Kristin	Tarr	ktarrg0@desdev.cn	2024-04-21 09:48:24	$2a$04$AkdXwtxDSwsXT/b3rO0kdOXKECeoZaQxJm/xfCeOAC8TCmt21Mwfm	2
603	Tracee	Lawrenson	tlawrensong1@furl.net	2024-10-15 03:02:53	$2a$04$0HwZnKOccWr5kdPdIeUVOu5d3XGhyKoGlBuTw.C8jCVlVwed8DXlS	2
604	Odey	Boness	obonessg2@de.vu	2024-07-22 10:30:52	$2a$04$OvS5ZE6Hmci31FeCwM/.7u3FZwTZx/hB1FfATaGOLrQDwHDdrkiDa	2
605	Angelika	Barnsdall	abarnsdallg3@tamu.edu	2024-08-12 02:47:42	$2a$04$sgqikmGkFJrUKT6tf.uMb.uxsLh.TthcT.vdUpS9Yuq6KMsbs9HSm	2
606	Cecilla	Playhill	cplayhillg4@about.com	2024-08-27 05:03:35	$2a$04$7GT7d2JHxYZdExu/Fe9TLuziAIpt2iDsyST70b2YjSrCUVlWS4NSu	2
607	Terry	Millier	tmillierg5@wiley.com	2024-06-11 20:36:43	$2a$04$FfbMy9xg/296k4LpO6.C3eY37b4qrwCAFE115apGhYgMliNgXY4zq	2
608	Kirsteni	Labitt	klabittg6@feedburner.com	2024-08-03 16:21:26	$2a$04$DewXEoVdjUYT6sqIud.lnu8Ts87jsvQeGaElNq17OgzzFRVimfSDi	2
609	Leanna	Courtenay	lcourtenayg7@cmu.edu	2024-12-13 05:22:47	$2a$04$49gaQlDLUUvDq6Lev3E2b.UYOiSmrtX5H9EOOqLPfAw2mxDWMKTgm	2
610	Yule	Menci	ymencig8@zimbio.com	2025-02-09 19:29:48	$2a$04$hkZDELa.S4u9WmTROhXeyOX6jXz1LJxguGt13S2k1tMvQXeKs6BqW	2
611	Kathy	Bourchier	kbourchierg9@wix.com	2024-09-23 12:40:44	$2a$04$ejLFuEJ1N9yl7Mss/8xWi.Jm1ZfXksJk91FRKQCVL6dw.C7s4g9nW	2
612	Gratiana	Crutcher	gcrutcherga@tripadvisor.com	2024-10-19 12:08:57	$2a$04$AuSobQ3rDpPAcFD1/nZK0uPD0ozsg7uo7ULcgSbdZDok78MfqO8HO	2
613	Tate	Gaither	tgaithergb@irs.gov	2025-01-01 13:38:18	$2a$04$lePpRh/WRkf9osbTvURyn.HehyoKb1897M5jdJsHgML9ywKrR5Wd6	2
614	Theodor	Grammer	tgrammergc@indiegogo.com	2024-07-13 09:26:53	$2a$04$weo89dyqPcsSHGuFKe25W.8sqW.3m4cXm0Gjl3qnkU05IoFH5gdbm	2
615	Morris	Binford	mbinfordgd@mapy.cz	2024-04-23 15:00:15	$2a$04$Lu.gy4KT4f4yrL.sOZqFL.2e1lyjxxHzNqqT4xUlmYXkXVDq.F4/u	2
616	Daisey	Blewmen	dblewmenge@zdnet.com	2024-07-24 19:50:25	$2a$04$gWnIrCCREzZXpj2N3zTN8.ockApUkxmA5EJLR7XIVwf62A1JZYMWC	2
617	Sibyl	Brixey	sbrixeygf@chronoengine.com	2024-10-08 19:03:28	$2a$04$qzU.68oOPPZOjeb5igTwi.DAPGqqi8ZOcUCHk8E6MRdJDj6HWGLrK	2
618	Gladys	Shewring	gshewringgg@huffingtonpost.com	2024-07-22 13:21:51	$2a$04$WfECIdnCR53N9n5DRt3x6.AEOuYFbCwEjt4ExpF1NHItXZHc/79Km	2
619	Syman	Treadgall	streadgallgh@exblog.jp	2024-08-30 02:28:46	$2a$04$5aLWLySgimeD1wibsLon6O8JgisVBhsIQIDOFJgnt30Imziba.tG2	2
620	Carolyn	Cay	ccaygi@sina.com.cn	2024-06-07 23:19:19	$2a$04$ekgKBemdKhTpUpR/nzqIeu5oohs7X0qGQqr6lLQYLcQBqgnDWVvca	2
621	Cary	Aleksahkin	caleksahkingj@hp.com	2024-05-31 03:30:40	$2a$04$8aRMAu8SVvIVPOAY1dxA3OMJukPdenRO3pRK984Fkd2MVsAjjSN5C	2
622	Sofie	McTurlough	smcturloughgk@example.com	2024-06-20 15:28:00	$2a$04$/APDnVFkQIMIxlNSyu1IWeFslYQfMY1H4rJvo6RzmrqOD9OjzyR7W	2
623	Tomasine	Wolford	twolfordgl@webs.com	2024-06-08 09:53:59	$2a$04$6KTRcfHKQ0QsLASArDYQv.3CXQ9ISx5WE/rurKP.d7ZEgKKZV7WHu	2
624	Karen	Elbourne	kelbournegm@yahoo.co.jp	2024-03-11 08:13:25	$2a$04$cpQJyTzrEJn7ssdSOHTOBOq/37PhturZadCIVelqZKg15FwP4udae	2
625	Vern	Frickey	vfrickeygn@google.it	2024-03-22 22:34:04	$2a$04$y88pXoFYZ06VgucfLyjqV.kn20PpFvm8Jd0xzoH3A8GAot/uuYOc2	2
626	Darryl	Boame	dboamego@flickr.com	2024-05-06 23:39:43	$2a$04$avJSW26gMsSO7R9ilTF13e1MDRTJpidIRi8SAKmoOBWaDGIznKWMm	2
627	Fonsie	Bisco	fbiscogp@va.gov	2024-07-07 23:52:03	$2a$04$lkvtAUWQjeioZPnU/zJ1AuTmgy30w3I0kb37vK/zBiEAkfrBTOuPi	2
628	Skipper	Martinez	smartinezgq@prlog.org	2024-04-01 04:42:57	$2a$04$7pxPL8odid7VNufhdF1d0.ldwuEhnxtcEQAgp3Rnc0C0IA0Ksh4J.	2
629	Johannah	Salthouse	jsalthousegr@cam.ac.uk	2024-04-22 08:31:25	$2a$04$PGlW5Lw0Ellwn0cVh7iBr.DWzXOc6/Pdm9a1OmlHR6seQPxXQiM3q	2
630	Domingo	Fredy	dfredygs@meetup.com	2024-08-02 05:06:13	$2a$04$pfW3CIZhn4NP.BLEIcUeoeW46Q99IgSWKmRoppDptDAxnsrO8mTDy	2
631	Sammie	Doerrling	sdoerrlinggt@discovery.com	2024-03-31 00:34:02	$2a$04$hTCG2OeI0gDeJVZDsCWCwOBzK4VmpDAi.uotm3VDUxZLFoadUAMEu	2
632	Beverly	Gerrelts	bgerreltsgu@redcross.org	2024-04-30 19:41:44	$2a$04$8gC930GAEoPPnzjASsXImeIuzJBxtI7pojzxvrLtjFOojJeeCOp5m	2
633	Sandye	Cosgrave	scosgravegv@cbslocal.com	2024-03-16 13:49:37	$2a$04$4q5OlwiBM3Y9nUssW5pFo.DxHJDVbj1eYgJ60bTEGBIj7BlAUvYni	2
634	Vanni	Disman	vdismangw@example.com	2024-04-18 23:22:32	$2a$04$AqwIFRa/8EHpsBD5GA4PW.8vMIr/SU/x2Y0doEdExACbehGL6XDM6	2
635	Rog	Mardall	rmardallgx@hc360.com	2024-08-29 20:54:15	$2a$04$vnEb7lUjsuM5fLidXboAS.bUyHVH0GTF3/R3oXIynGgANdqo.6Y06	2
636	Winnah	Cranney	wcranneygy@infoseek.co.jp	2024-12-21 22:45:10	$2a$04$exzIAhmtGHtXX/2qF3vfheC94xTl27x93MWuZB5l5EwFawW16NbEy	2
637	Webb	Sircombe	wsircombegz@wiley.com	2024-07-08 07:28:08	$2a$04$sCusC6QkJsxUoAduoucNvu0JLNV6VlbxGgmVFqL5TjrCL/wYQsj2i	2
638	Quintana	Mountlow	qmountlowh0@wufoo.com	2024-03-06 12:21:53	$2a$04$Ap3D9cLI.mCC0pp1m/4Em.nmndYFhm54/b/oP7w6JYFF7u8YXQrDy	2
639	Tirrell	Scholl	tschollh1@reverbnation.com	2025-02-26 08:12:34	$2a$04$KwkTa3N1ImV/piITMUcQg.5ybSZIFS.bIJmZPGja1Cxbu75AuFmLS	2
640	Rey	Galpin	rgalpinh2@latimes.com	2024-04-22 04:12:31	$2a$04$C5t93LnmfOYlhdtcYPHSyens7EHXkSD1LmoStrUoMEz3dFAuSCI4G	2
641	Alfred	Tinline	atinlineh3@china.com.cn	2025-01-03 03:16:54	$2a$04$s5sgzY9FoY17oQzmHU2IP.MJjZeQDy2eX6wBfDYA6UMJdn9pZ1E/y	2
642	Brigg	Cordes	bcordesh4@homestead.com	2024-10-21 10:47:30	$2a$04$oMRNaSOdercC0DjRFNsXtOd1LoTCqfC9XY4fUmuA6PX5SUQB9E3f2	2
643	Veronique	Franceschielli	vfranceschiellih5@ehow.com	2024-05-17 02:36:08	$2a$04$GdLL6wh51tjQb1w7TV0TueHInl8gbMdlhrz0C4.HTNlgrG0HCZMei	2
644	Elysia	Combe	ecombeh6@xing.com	2024-11-18 14:37:53	$2a$04$v9BWIXhBTVWymwDpE9AEheIsqR/iJgUFBQ7YYMZNsROk89IS3DFVy	2
645	Del	Penkethman	dpenkethmanh7@cargocollective.com	2024-10-19 12:27:58	$2a$04$YhRxfiRN6HHg1db3UvWGy.gv48xOoUtWctip4b/mSiMXDtq6IHAWK	2
646	Jaymie	Killner	jkillnerh8@alexa.com	2025-02-03 05:38:26	$2a$04$ditd4Xkq1Yh5nb5QSRxxFOusjCuMgv5G7XTPwYslcnORrjXxg4K22	2
647	Electra	Haycroft	ehaycrofth9@1und1.de	2024-07-22 12:33:27	$2a$04$OdyAjR8E8m3YPoNoYWdhEenLJmUuD0rp7e42z781hw3PQW6lZIDKC	2
648	Marji	McMaster	mmcmasterha@yale.edu	2024-03-27 18:41:00	$2a$04$JFrlXkVSX3MJ2Zw/6GloduHq8con5GCRikIhSKdrESwwPYSgGxlry	2
649	Ede	Keveren	ekeverenhb@infoseek.co.jp	2024-07-17 18:52:54	$2a$04$SpvkbUU7msQst5jdgtY/ruFZyYHBvkDLeYroiApgK6PcJJT8WAxeS	2
650	Cyndi	Jendas	cjendashc@irs.gov	2024-03-23 19:20:07	$2a$04$ZfhfGK4.o/rkPUHcXybAJ.m8gERQMVqNN0XKs9KRV.Dc.qSha.MT.	2
651	Clarence	Rackley	crackleyhd@samsung.com	2024-08-30 21:26:54	$2a$04$BTRW8xs6gm49GxOwPG5bdObCL0Z4rYNsESbSNnhByxeVWib0.sVBC	2
652	Luci	Pointing	lpointinghe@people.com.cn	2024-11-30 02:39:56	$2a$04$E6pz3fL6yCX4MfLqXzq9/elO2V9nZXkBJityRMdZcu3/GEUw9c17S	2
653	Ansel	Cantu	acantuhf@washington.edu	2024-07-01 18:57:25	$2a$04$9yoFV6P.yX1QENTqegG1y.4NP0giNF4/kS.bDQafxujRMFfc89Whm	2
654	Netty	Curner	ncurnerhg@harvard.edu	2025-02-02 21:07:56	$2a$04$tkKqkvNCO3ceS12hiJlQyOHiK.GnC/LuQEMh8QcDRPdcBlE.HJHqm	2
655	Roxane	Keddey	rkeddeyhh@wix.com	2025-02-08 04:41:21	$2a$04$K8MElplA98l01GK3gyoiBuYCKsuJtY0AfwONqruZyOYKtePy67V1O	2
656	Babbette	Rawsthorne	brawsthornehi@dyndns.org	2024-08-11 09:35:34	$2a$04$wIRYfYWEHo9lt1GegV2Jxe81B.6V.KtY7OqHh6QM5xRWIvfbmCNEi	2
657	Wald	Towne	wtownehj@cnet.com	2024-12-28 04:14:33	$2a$04$b8mUGJ0/H9sEqt47qpch5eMwVldBp9aekx5TyagpdCGrkprzfnxp2	2
658	Claretta	Acres	cacreshk@clickbank.net	2024-07-14 23:25:08	$2a$04$YNUuS0RzWNhBG25awKU3N.j2zTzmbPF.ngWceseNuBSdqQ4rmECre	2
659	Raven	Ballantine	rballantinehl@google.de	2025-01-25 06:13:58	$2a$04$QyAlZFOTzqeJLclEvPjADeWm8NA0isf0qX3rj13W3f6FUpHOdLupO	2
660	Maryjane	Marnes	mmarneshm@livejournal.com	2025-02-13 19:08:57	$2a$04$CzXxKZ/ppfKZbVUOSATo6.zXWHMNp/GOisEBB3zKWw1jvc.TEq8xW	2
661	Keene	Robertson	krobertsonhn@google.it	2024-03-27 08:14:48	$2a$04$TReblr2h9wwgWbhQknpUyOVXvxyGwfAs.h79UTfQKpiinfBTds/LO	2
662	Didi	Handford	dhandfordho@illinois.edu	2025-02-15 02:52:20	$2a$04$vL5O2mmupyxrv5SgKaU7VuqyH9v7ZxSoo127qCPbTHUGzeqmH1na.	2
663	Gage	Terrington	gterringtonhp@examiner.com	2025-02-12 14:09:50	$2a$04$916884gg05in7XlWmt7ouunWn2vCZWb5scBc.tO8qtVi1DTJKe3NS	2
664	Loutitia	Blake	lblakehq@berkeley.edu	2024-05-29 11:03:41	$2a$04$.efDDFV3NKrjnJHYbH.6qORg9dGgzNkkVtOsnCPcXMrztTv2rSVxa	2
665	Waverly	Kennedy	wkennedyhr@printfriendly.com	2024-06-01 07:34:08	$2a$04$dS.OywqWa4dS6wrvhF9Sn.LqfYWLWNDK26GcHIPaGN7epWHJamvVO	2
666	Orsa	Vinnicombe	ovinnicombehs@dion.ne.jp	2024-03-21 15:50:17	$2a$04$eyGbEtAoYnGxf1xT21yG7.s6rZSVH2Vgcbr4x0dvpByun9B0OF0va	2
667	Jillana	Stroobant	jstroobantht@booking.com	2024-08-30 15:47:43	$2a$04$m22APAUVGYng1cIWF.P09uDTRiGpnw3agmjnWbnrovdXVDpXjwE46	2
668	Christoforo	Crumpton	ccrumptonhu@gmpg.org	2024-03-29 09:30:04	$2a$04$MnT5F7ZFpUSbE0XO2qTilOnNkpO/ldN.T2.lgNyazwAXcMnQ5HrEi	2
669	Amye	Threader	athreaderhv@weather.com	2025-02-03 01:07:30	$2a$04$tw/yNflJExAgFn1pgWM69.eBFPmM4twb6vVM3oGBO0xUsg6NrJqWa	2
670	Wilfred	Barrs	wbarrshw@paypal.com	2024-08-02 20:28:24	$2a$04$jm3AVW1v8On6cPLc1Y5sVuqkaV00iYfqCML8uYqLcq72e/7haPMfu	2
671	Griffin	Challender	gchallenderhx@salon.com	2024-08-26 03:02:21	$2a$04$m1GE9POsMAq6VDydTR3sjunViHZlOkuk5ZbcpLE7p01d4wewchofq	2
672	Kerianne	Pley	kpleyhy@hibu.com	2025-02-03 04:43:15	$2a$04$rIZLoDv3GMaADu54OoVnY.hZE0s32PEamdSWDyA1wty4CvltScE9e	2
673	Amabel	Lesley	alesleyhz@nymag.com	2024-12-29 10:49:34	$2a$04$572A/YtFcyh4GtW2oU7Ol.EiQT3GsiOkveXOtIR8yMhHhoxFkMPw6	2
674	Adaline	Cumber	acumberi0@mapy.cz	2024-11-28 17:16:29	$2a$04$D3/5wUp/nPsoxpXWHlol1eFgm/yI2XhOXK9ewKE5K3C27dbEWIyQO	2
675	Karlyn	Launchbury	klaunchburyi1@time.com	2024-10-30 16:07:36	$2a$04$wLspcQLKkCa/OhvxmWk5X.qBx5MwbdJQ1w.v.VN7oFy20kV4wDx.y	2
676	Nata	Crummie	ncrummiei2@hatena.ne.jp	2024-04-04 17:12:26	$2a$04$yVswGjMGiDZpDuyUsPes5.epHUVLGZsQ0DZm6rtb553p9PAShykyO	2
677	Tally	Craddy	tcraddyi3@wikia.com	2024-07-12 17:02:59	$2a$04$yfkVP7nR2Y/26RaCGws7HO.kAxXsNHdZwPlagT/ta/gKTZ8vjLCsa	2
678	Elia	Wafer	ewaferi4@is.gd	2024-12-17 13:48:10	$2a$04$.pdDXM/934yuNon14RMym.0iqVuZkrTWALv0tBUa0iIG8SC/amZpG	2
679	Timmy	Fee	tfeei5@squarespace.com	2024-04-02 16:39:00	$2a$04$JnotWDCwplTkvDx76Vjupu/28oE.Z6oJuGLzP2OUrAY5hcRSjoRpS	2
680	Cesaro	McKelvie	cmckelviei6@ocn.ne.jp	2024-11-16 10:14:53	$2a$04$NJWOaE7ssaxqQz9/3IxOV.LClqrwpQMbC3LNX37AYs/n/U6e/Mt0m	2
681	Correy	Alben	calbeni7@google.nl	2024-09-26 12:55:28	$2a$04$tB7rxc9JitgdnDl33pz3guhgIF9du57aUHzFO6xnZPHqyfISDKtFa	2
682	Forester	Oldrey	foldreyi8@reddit.com	2024-03-13 22:12:33	$2a$04$qE14M4zVQP3g9l1KIcjXWOw4q5K4jJpLwXI7OaypvuErbHYqjQMB.	2
683	Orton	Flippelli	oflippellii9@google.cn	2024-03-14 08:54:19	$2a$04$AeLPgRFrJ1um/l2l1rT0jeHd9RVIsJNSdtgesbvqeTkWJSmAT6Z7a	2
684	Alfredo	Chamberlin	achamberlinia@uiuc.edu	2024-08-07 10:58:54	$2a$04$6V11331OwDZmZyccs5wVvun5NRPXjv5CCS.J9sTGGMfH0Zwy/8gle	2
685	Nalani	Otteridge	notteridgeib@blogspot.com	2024-05-27 13:36:13	$2a$04$rRsLMlhTk1.UyIEZ7ZJZ6.5vQPbuVf15gfDGSYO0/2DUDRl/SgRz2	2
686	Rheba	Salisbury	rsalisburyic@amazonaws.com	2024-08-14 14:27:26	$2a$04$PtZtjmWJyRCqrrjMfdJ1CuLH3s5EEwp.6DshvYsdORylsDUEf2Iaa	2
687	Charmane	Khalid	ckhalidid@army.mil	2025-02-26 05:31:47	$2a$04$LSXjcTiwEpkJcjIDtAJKDOu2M5NvM/ZWeFeDVGiJJx9FoCtLWdPPS	2
688	Sarena	O'Moylane	somoylaneie@illinois.edu	2024-05-12 07:04:43	$2a$04$NOP6nsbu8bZois0U45DDT.8HVTcGHisWXh18BhnhUjp7Q/Y.kTZtq	2
689	Marisa	Denerley	mdenerleyif@histats.com	2024-12-31 21:22:42	$2a$04$SHY92YdmwFZE5xemfvKnjOs6JwZNUXz4uYjB2p8yPxi/JVqaxUD46	2
690	Gnni	Antat	gantatig@imageshack.us	2024-05-27 00:13:51	$2a$04$UVMUd0yeHLd2Hly.zr1j9OYMiPJQ8cohs6oDRCAME88ztUrJudrHy	2
691	Reagan	Birtwhistle	rbirtwhistleih@cnbc.com	2025-01-01 19:41:11	$2a$04$YZh.nXaZNm/jruUy45ZkX.tVqaUYSTkA63NYSssL6jOqr8BvOixky	2
692	Susette	Silcock	ssilcockii@mozilla.org	2024-06-27 06:14:41	$2a$04$4ExUH24i.DlcvCIbcybrjOFGApjGLLo3uJ7fFYqGelIJ2a./RQTJK	2
693	Irving	McKoy	imckoyij@skype.com	2024-04-28 07:18:00	$2a$04$vKscmiR32B17o.y7oZALruut3bT7sbeL5Xr9k5dQXqAlCZVuoMx.q	2
694	Lotte	Hupe	lhupeik@icio.us	2024-11-14 06:27:25	$2a$04$pNrsZkDkaMVKbxsYfAKFquhHlPmBkcQVHLay0ydL3pFmckQPt5SsS	2
695	Juliane	Dudderidge	jdudderidgeil@desdev.cn	2025-01-29 09:22:29	$2a$04$MLW4RqKB7/rPwwFUiMa2YOppso//cDvLT.EQ6Muu2ZAz/NAfQKEdW	2
696	Shane	Boni	sboniim@nba.com	2024-04-29 21:35:12	$2a$04$GzPX8x5bg/jV4pMHyO4GN.aMbPN9sYEJ7qi21DcIcrlvTVGYqluX.	2
697	Rhetta	Anglim	ranglimin@spiegel.de	2025-03-01 08:56:16	$2a$04$bj4B4Q97w4kgCxvM/38r8.032DeoLBRW8oJGh6ylzA7x1fTiDHayG	2
698	Yank	Rentalll	yrentalllio@ebay.co.uk	2024-08-28 15:57:39	$2a$04$NcIF5pSOxgwMOC362lJjiOo6xtKOkKN30FrRj9cwhgW4BJ736WBYG	2
699	Ike	Harroway	iharrowayip@amazon.de	2024-05-07 07:59:38	$2a$04$11bGmeXKZ1yz63BpkhkKbOMEoXAamWxi7H8BCKQlStovSgpF26LFm	2
700	Milissent	Ogg	moggiq@usatoday.com	2024-07-12 20:13:22	$2a$04$LN2ZZcZ/MkmWuWNRPNSjXuFyusfmhg65/vDhWLgVWKJ.qKw.ur2W2	2
701	Pascale	Gauch	pgauchir@free.fr	2024-11-03 00:15:47	$2a$04$9U9MR3c9oi9jcQV/BGgYKeQC1EhND99qM.z81b.u1qRUqEW/z6qEe	2
702	Grange	Powrie	gpowrieis@dailymotion.com	2024-06-06 23:49:01	$2a$04$k9Kk/6eBGub5UkXnlw3.zux3j8YqRYJDhq7.V1WajoTEIRJFsp0nK	2
703	Alf	Able	aableit@ebay.com	2025-02-13 02:10:23	$2a$04$5apyAGacFafJA3km57wj/O41sXjaZcZRnNCo5IUB1sy6mzzVszSvy	2
704	Dylan	Troy	dtroyiu@joomla.org	2024-09-25 17:03:01	$2a$04$hABuyscfov37xtJhrA9R.eo9x2iBr6EQrPKefPfgt0QLI0AOmdh3W	2
705	Terrance	Halliday	thallidayiv@wix.com	2024-07-26 11:47:13	$2a$04$QX9EKJEdam.cBPlE07ADFeh7tMSuX3D4GbKMEG5Z1iQSr54dRtYNe	2
706	Dannie	Richardet	drichardetiw@webnode.com	2024-08-18 21:02:24	$2a$04$aHDePZ4R2SrQ99MOOwMMK.bULtxTk5MX8bSXYlnnHPu90cHSjbTgS	2
707	Earlie	Chardin	echardinix@amazon.com	2024-10-11 04:12:20	$2a$04$F1VgFlaUAulVdcKSK3PT7eKq8vHHJlyytvFCZP4euvZz6oOaBwInK	2
708	Ossie	Goucher	ogoucheriy@bloomberg.com	2024-03-07 10:31:08	$2a$04$Ec3Tw.E1HrKK/cMK2vqAZ.q.DTh8nwQri34KrtYeJQJoZ/l2YxPTu	2
709	Dinny	Haydn	dhaydniz@yahoo.com	2024-09-10 06:58:56	$2a$04$KTfnHqd8Hj4U8F35viuJUOGgrd1zBby8MPGPV92kYXrgY3XyB/YyO	2
710	Tobit	McQuirk	tmcquirkj0@pbs.org	2024-04-05 10:20:50	$2a$04$hcIUz47smHzghfHAUEF5luAHA6nBtVVeUlGfeJ1SaSS5w7AKW37L6	2
711	Ricca	Bridle	rbridlej1@over-blog.com	2024-12-16 06:45:55	$2a$04$nxRPX3TJl6a7MyGJeCKXU.t300NYDAr1hM8jOOGTTLrm2e813WeSu	2
712	Raffaello	Bachelar	rbachelarj2@opensource.org	2024-03-21 15:31:59	$2a$04$WxHu.tYXEyLwcEAbAaw0L.TDG/t2Bsh5kbi.2Jk5JJ/g4IF7OJFX6	2
713	Ollie	Hounson	ohounsonj3@tinypic.com	2024-03-31 18:23:18	$2a$04$T9.3.wZiloQNVAQTePOxV.TcHum2XKt6Zh3FljE94eK8Hr34tg9tG	2
714	Dionysus	Micklem	dmicklemj4@economist.com	2024-08-07 20:13:41	$2a$04$k3HZedkLnLpTIXCY.r4Zl.ye09.EY5qvGo5spAv6QqFlUa75ie1he	2
715	Ivy	Walburn	iwalburnj5@diigo.com	2024-08-01 08:08:16	$2a$04$HjIzbyovNRisfYr6JetGEuSv09v59qEv3QyeUwY4.yUu0nlUJHZ1.	2
716	Lynn	Jenno	ljennoj6@angelfire.com	2025-02-06 18:08:35	$2a$04$n93F6PQ624G2DsexjTTHlec1qW.R/auiDuqVDj91UxjwrV4co0an2	2
717	Elise	Westpfel	ewestpfelj7@rambler.ru	2024-04-18 01:25:34	$2a$04$eBQqUlDlmsREh3EMe1NneOsi7KjmlU69NTSTAn3X.XnWaqJjDNYAK	2
718	Gerianna	Marjot	gmarjotj8@chronoengine.com	2024-08-18 23:47:08	$2a$04$CDPk0jGDGL2sjG22m8K/qOpFRTxGiqXiUc4HWQnD4Ea5sI173idAe	2
719	Sander	Tansey	stanseyj9@ebay.com	2024-12-11 15:45:51	$2a$04$cy/sCHCR7mXV2doOhizSCu0N4/IniW8FeV08KwKjt2ybY9jF9ajoi	2
720	Mame	Windress	mwindressja@nih.gov	2024-10-31 23:32:30	$2a$04$h.Ib9z4YTCpjS/HzDLmeHOR04oF1TQa8IntdllldS9GLp/sHOOWjK	2
721	Lucais	Truter	ltruterjb@newyorker.com	2024-06-24 06:39:11	$2a$04$1Sql66./qLxOnsrhL4gNROL2hqTp/XOdolb2EkZnb1XNF5t4daWke	2
722	Trix	Routledge	troutledgejc@opensource.org	2024-03-27 14:20:03	$2a$04$d1n2UFLrfC/WsqdCXiEx4uZKDvskqYQcETRUf7cyw7I8GIRYYz1DK	2
723	Agatha	Solway	asolwayjd@last.fm	2024-04-08 01:38:47	$2a$04$h7H00Hwii0kyVTV4P0aleO4yL.tNboQgLJEhO2kqHQAkNvVF4IML6	2
724	Margi	Loughman	mloughmanje@clickbank.net	2024-05-17 19:22:18	$2a$04$hlVkZXZmuvLQD6Yp1YVpgO9kQjQTTETYWU3Ju/b3J2N32fSfYHoy6	2
725	Calla	Paoletto	cpaolettojf@spiegel.de	2024-11-11 12:55:46	$2a$04$kh5HaaLEJbQuUhMV/PmOY.CPD5Zw0NmERiAlIlKvxzYiatqyHIlIi	2
726	Patin	Fayre	pfayrejg@e-recht24.de	2024-09-27 18:31:01	$2a$04$Z4lu0hiVJT7wJZgPDXq0uebg69z74JDwMXzvPMz.dSfXgDjHsZ5Mq	2
727	Arlen	Riping	aripingjh@apple.com	2024-06-24 13:33:06	$2a$04$enWd/tJyjkTtYoU2T6OLyeM2HZpkpc.Pq4KUm0.B/yqs6SS17hSLK	2
728	Madalena	Curston	mcurstonji@odnoklassniki.ru	2024-12-30 21:58:19	$2a$04$xGBCp0QTNWnPKUiePWiUZuw.eDR0Wi/oMKv1W3nVUimPZI28IXDL2	2
729	Robenia	Lofthouse	rlofthousejj@g.co	2025-01-22 06:01:19	$2a$04$mpNaMKdIx6pY4GJBB2D8resD6aVNVx6CwLkLCq.8STBFh/hZouWZu	2
730	Gill	Elvidge	gelvidgejk@webs.com	2024-10-17 05:00:16	$2a$04$D4X60GcE3VLJeOljazrmWOArmQeHFFS/qKlq5f90Dl5v8e74DasBe	2
731	Karlis	Gwinnett	kgwinnettjl@unc.edu	2024-10-25 09:27:19	$2a$04$jAqj4zDEU9tEhu3ixsGYEee0vp9Q.WvF55V3v0l5NMvXNA0C4TUyG	2
732	Marabel	Kippen	mkippenjm@de.vu	2024-05-18 04:01:39	$2a$04$YUu.gjUN6MUALHx/E6vc4O/ca4XSa/JvVXFRfGn2DEmMw.fwYbiOK	2
733	Florian	Cropper	fcropperjn@amazon.com	2024-05-04 04:11:27	$2a$04$jRTR6ThM3MWUrpa9CW7of.2J/LAly87bNCyq9AbXRbwP0YvYur0ei	2
734	Kenna	Manzell	kmanzelljo@engadget.com	2024-11-26 12:25:22	$2a$04$1/MfH2O0Ze/PyxpqjWxY2eetYbRUlff1uYMW9hdrHRDgNveA2VicC	2
735	Brita	Hembrow	bhembrowjp@vimeo.com	2025-02-09 23:39:22	$2a$04$RACzPTHJJiYxU7qhCy2r7eea8IfZwrSGpnyLTBREUAE0y1Fk7dEUm	2
736	Winfred	Tettersell	wtetterselljq@cisco.com	2024-03-15 06:20:39	$2a$04$7/nHPjpj8HmHtwbMOAOUWeXxehKFezjPwPO7g09rdKaAv9iOr5gJS	2
737	Clyve	Duny	cdunyjr@sfgate.com	2024-04-25 17:18:09	$2a$04$VbRPlVSvCvOsdwjFmPtDSORFl4l.1gY7rlWXx4UZAYNS3vQpPyHj.	2
738	Mallorie	Larter	mlarterjs@intel.com	2025-02-28 16:34:38	$2a$04$0UDTiQpJVmYBCwJTlQUbQOJDbZUKKhHQYJsnb21pn0oT9Pe0nMJRO	2
739	Vania	Reedy	vreedyjt@devhub.com	2024-05-16 19:36:41	$2a$04$Ex1a75062Fa/iDseTWGiVOVkaqSjgStO8W5.bfHKqI19UQ1ODTW3W	2
740	Rona	Baddeley	rbaddeleyju@home.pl	2024-03-13 09:59:18	$2a$04$9fF.h6BaqlGr/BjYgRE1auxJxr3c15bV92YFq4M8dzabUwH5AEau6	2
741	Sarina	Forsbey	sforsbeyjv@jimdo.com	2024-09-19 01:29:53	$2a$04$.blXKsb.rfg/ATJjmxkt1uCa3iEkEc24jIjQumtis5qNs1LHItISi	2
742	Bobby	Ledrane	bledranejw@studiopress.com	2024-12-19 19:33:50	$2a$04$FoStwgz6ZvPf7OS1FVejgOt/rmYcj993XV/qoXd50q2BT1.mpUduq	2
743	Martguerita	Giles	mgilesjx@opensource.org	2024-12-30 06:10:32	$2a$04$mEbNKmZtt537VkgZk4ADA.ZqmKtvNJOaRvWX6fLmr2P4CGP.8nZLq	2
744	Kelsey	Masi	kmasijy@nps.gov	2025-02-22 23:31:27	$2a$04$BZPnyywQsHE5TafLcevrgu2/PqHXbVFTYchRgo1WwWzjM2OQib9YC	2
745	Saxe	Moland	smolandjz@typepad.com	2024-11-15 05:27:27	$2a$04$myvrjgYpBoXThXfcAhhlyu1y7VC/GVQT5AkbMPNpytCpJu94AI4IK	2
746	Skelly	Noury	snouryk0@uol.com.br	2025-02-27 06:06:00	$2a$04$/s3SdWUlRFhqxKDgxG0czOtg18Rf9GUkId3r8YLs3bsJX2GR0wyKO	2
747	Ula	Bernardot	ubernardotk1@over-blog.com	2024-04-07 07:23:38	$2a$04$hX3k2KGVPHvwkl8dkCyBr.6m1OcldnTP0NY2TJ7hL6lR350PP2u4y	2
748	Cairistiona	McMenamy	cmcmenamyk2@ustream.tv	2024-06-26 19:04:46	$2a$04$1AJOU6aL7kFOeXbyVRL1zOx3Gwlr15IW0BvCdDgbv1sohrRZzoC5i	2
749	Kimberlyn	Maass	kmaassk3@cnbc.com	2024-04-04 15:25:26	$2a$04$saIWtf0t.gBGCzoWSmXeoOv3pjbQg8Y2Hs5t5wA/QFSacs71ByAsa	2
750	Benny	Scougall	bscougallk4@epa.gov	2024-07-05 02:00:32	$2a$04$P7557wjlQB85JgH2kDQKn.EWqDE/BvvjmFJmDmGLir1SJj3uyWXLO	2
751	Vikki	Farquar	vfarquark5@gizmodo.com	2024-11-10 10:28:15	$2a$04$I0lX6znXgV5gfczVjeR5FeAT.3Zc.vg/BEY5WS9SpKcGuL8s2wVU2	2
752	Jecho	Stannah	jstannahk6@slideshare.net	2024-04-25 01:27:46	$2a$04$3OnKhlVgV8hPKOoY.Es51OqTbC5NEx1DOt2w7Mp6bhhR8eLQYmhV6	2
753	Dur	Iamittii	diamittiik7@army.mil	2025-02-16 12:45:57	$2a$04$rM15vjf6goNiPk2.dTK8T.HeTHjnGjST3qsYHOeda.eizz1LJDJKu	2
754	Rutger	Bell	rbellk8@bigcartel.com	2025-02-05 20:38:51	$2a$04$8r1nlgxE4JWnxDmUFhLHE.ythOELHVjAciIsnw5EySgEf5APEnvvK	2
755	Merline	Redshaw	mredshawk9@miitbeian.gov.cn	2024-10-13 07:55:13	$2a$04$K4YkrK1yUkCB7OQPJPqFru33mRYT45LMz3CaVs2F.Pw7zVQ0U9UXi	2
756	Zea	Trillow	ztrillowka@oakley.com	2024-12-24 14:11:34	$2a$04$Denh33W0I6g0Tm3f14tpm.ikl5B5mhUo5rySYYjFyJcqNmIyO6q.2	2
757	Cleopatra	Ivanyushin	civanyushinkb@biglobe.ne.jp	2024-08-17 23:44:35	$2a$04$kUrl9BN6Klg1I7YlM/uxD.mkfk2F4/BMlmR6XKyOnGkOusyULCvTO	2
758	Carmina	Luquet	cluquetkc@who.int	2025-01-27 18:02:57	$2a$04$Lx2dOQL3xUgopT8jW7H2NemhJf6BzHrt2kzj8GyYnLFSR8uqRRvmG	2
759	Christoforo	Flecknell	cflecknellkd@addtoany.com	2024-05-19 19:18:27	$2a$04$0chRGGKMKpFiWFkVTsBlLuDWU4z5Unelg4Pq2J2n2z2U9NICK8jhi	2
760	Alistair	Renzini	arenzinike@freewebs.com	2025-02-23 19:49:52	$2a$04$uHmv58fw9IhQHUDGQT6/We10rPzXf0w3iGGY0H4pQQlFeVVu1q5tm	2
761	Seka	Mation	smationkf@prlog.org	2025-01-09 21:54:48	$2a$04$YksFZ.lGdi2Ly8DnH2/4DudOVvmEHMzErD9o5cKwHGEXG7hSbSnPO	2
762	Stu	McLenaghan	smclenaghankg@washington.edu	2024-04-12 19:21:04	$2a$04$ECMZtRnnLvBn819WG5rsbuvkf/PI/w88RzEjqsYV0FKFaO6kdFRx2	2
763	Alanna	Beards	abeardskh@hud.gov	2024-10-29 23:45:40	$2a$04$IpLRQbjCzNWjlW2usV8uWuGhEe0qyX4mVmRsd9r5aceYcxEb59xF.	2
764	Thaxter	Waylett	twaylettki@naver.com	2024-10-12 04:35:37	$2a$04$rfgtsejmX9alyG5AiF4q.uP8aaG3vUBx.zy3cWcrd4k30TmGLvLi2	2
765	Adolpho	Paddle	apaddlekj@ftc.gov	2025-01-12 14:33:40	$2a$04$4eedXqfxJpmarILLi7f8vOFmja1NAiFvxRn6vO7t5nDxo6aW6rcGW	2
766	Cary	Winterbourne	cwinterbournekk@sina.com.cn	2024-08-12 00:18:15	$2a$04$ZnvYXXaDM/u5rXTk7WWd9uTXxO7ApfkZa2wXf/ljLY9pkb7T9r38W	2
767	Carlo	Bassham	cbasshamkl@acquirethisname.com	2024-09-28 18:54:26	$2a$04$rnpi1NBdo08a0bv8lQH7f.0uE.E.4XuQHxFFlw9aIp55itRqgFhMK	2
768	Gwenora	Bloggett	gbloggettkm@51.la	2024-11-07 13:12:37	$2a$04$t7quk.nLytTkmBNTFOCtQudCPDJ.mW/nzfNw06FxyS2Ok1rWzDeYK	2
769	Hedi	Weild	hweildkn@mtv.com	2025-01-30 01:52:14	$2a$04$Jw3qh3GJ8QbkCnJVKos4g.Lq7KSo5J/Cxbaybn63oDNvrdhv47rZi	2
770	Dulciana	Audiss	daudissko@blogspot.com	2024-06-06 03:04:37	$2a$04$R.DLBCYdoR7bSbacc7hcZ.syhA/PHmwvAfIV1uvF8bux1fOmgG1qC	2
771	Datha	Grono	dgronokp@fotki.com	2024-10-07 01:08:06	$2a$04$w2sXEF22Meo2Z9SQnY7HluiPuG5/v9GoFKHJwM53cPNZ8gKoVmdS2	2
772	Herb	Felgate	hfelgatekq@tripadvisor.com	2024-07-04 13:02:08	$2a$04$OvKMqCATMWlZmwWE088D/OTLHYjPF5GG.kQjTiMt1mN4adRdxUCES	2
773	Kissie	Ouldred	kouldredkr@sakura.ne.jp	2024-04-12 17:25:41	$2a$04$XtLeX6AoYFGBk3q01HlJuuKNSLcLADHdUEYhWrOS9KKpj7.vXYbmu	2
774	Bancroft	Jaquet	bjaquetks@pinterest.com	2024-05-24 18:34:44	$2a$04$VOp4O.Z4f/zsWLpen2Xtj.npy2dA9nuTJefpbZ/vbnVUp9Up4DShm	2
775	Jerrilee	Macklin	jmacklinkt@123-reg.co.uk	2024-09-07 00:11:06	$2a$04$3JhmyW/HNMg3t8/eHbmE6O7yUj1ab/cBkDDdyHUvyNfXPqG4TZYEG	2
776	Natka	Ianno	niannoku@about.me	2024-03-13 21:45:27	$2a$04$ni0w8u1o5DPy2AeHywkTE.XDM4zFuQnkEoILLrrXQgXvqoS2GTeGO	2
777	Darn	Leuty	dleutykv@webeden.co.uk	2025-01-19 00:48:05	$2a$04$yz8ehi1n8eWg7bgAoA6uSuXsXQdcbPc0piI18dB407GIF0eEs2b6W	2
778	Ella	Farman	efarmankw@webs.com	2024-03-03 17:19:49	$2a$04$w51RMvzj5BUf.I1i9fTffezcvBdYnsUy1zMxDgzddPlEo8PgQ7IiW	2
779	Hailey	MacKomb	hmackombkx@elpais.com	2024-05-30 23:43:25	$2a$04$SJ.K42QLogZ5TLkChdm19O5uo36iHrZQBM5yh4mzpUrlKmn5gJrGW	2
780	Lilla	Burkill	lburkillky@google.cn	2024-06-08 08:30:21	$2a$04$V/eplmaRCqFvgRDWsCfBrevMpsUqhMYV47G9J0J6SR8jVzPNqhfIe	2
781	Brad	Scutt	bscuttkz@hud.gov	2024-07-02 20:50:47	$2a$04$6tdiOOmHLqkIghTRnUkp2.gjJqKj40yzuTezi2VkUum7temmsgvQi	2
782	Archambault	Patis	apatisl0@quantcast.com	2025-03-02 23:53:56	$2a$04$Kk38Kuweqb4eXYhrLorGGeEGQ/39Npti/1iP.WZ0RrnGMaYRhc8yW	2
783	Carlin	Biggans	cbiggansl1@domainmarket.com	2024-03-12 11:08:09	$2a$04$WcvsdJElxTp.ajLwwOaS9ecr0HD/OFtBkOsmRGOg97mI1PebVORw.	2
784	Fania	Schapiro	fschapirol2@google.nl	2024-12-25 02:16:05	$2a$04$OTlIxYEMfUSC/vwhaPGHrOPL.JhApx5hupGv6AAdufWocUTswVNPK	2
785	Alisun	Neal	aneall3@nytimes.com	2024-04-08 14:54:05	$2a$04$eH8laQVm7d.qcwpVXj4hHuTgcSoK2I4ndy.4y27i.8dFDK0ik9B9e	2
786	Johnnie	Kochlin	jkochlinl4@dropbox.com	2025-01-04 21:16:49	$2a$04$mxTzL1I2aZtK9eJqRgPQX.52IzL.StKyrW9b0gzA.Wa.mkCM0jJRG	2
787	Eberto	Kleinlerer	ekleinlererl5@walmart.com	2024-04-11 12:49:54	$2a$04$2Oi1IkExWLgdHNKnamUXSOsFEY5XY2pdIuzCfEDe9DwPkEHERhfGG	2
788	Eamon	Mc Andrew	emcandrewl6@purevolume.com	2024-05-17 10:47:49	$2a$04$lVt3zbqpynxChTP7ef7QGuDmuiVcSD7DSzK68UFVNcs2KXI6uFwzW	2
789	Amby	Rouzet	arouzetl7@psu.edu	2025-01-13 20:48:08	$2a$04$nC2tIkNHOfUFwk67kQrpsOflKD9odPAo5DsrKWrtn2t2KOBlAKIAe	2
790	Kris	Rushbrook	krushbrookl8@g.co	2025-01-15 13:47:23	$2a$04$GoPECUSArZ4u..Jj1vAvc.g5txnp49uma1fYXqMMtj0d/wSAlUt52	2
791	Dominga	Whetnall	dwhetnalll9@webs.com	2024-10-13 03:31:54	$2a$04$ARfIUCfEuPdc8E2bYOgPwO3lYIsQBVg2d46npE1F.9aKnPed7B2Gy	2
792	Myrna	Elmer	melmerla@chronoengine.com	2024-07-20 00:20:26	$2a$04$/4ehSwhJX3Y56hDRLNiVkOfohkS/9Bu/0pL3SoUAETiqIlLvEuwR6	2
793	Wesley	Enston	wenstonlb@wikispaces.com	2024-10-03 10:46:23	$2a$04$Mu1A1SG8VVfey09t9khDHORTMXhWMU93Z/WczjXlNas7tMbakFBXm	2
794	Caryn	Cordrey	ccordreylc@cnet.com	2024-03-17 14:53:32	$2a$04$Fj0NYDtjWSl363H1Mh5G0.D3hNpbQZIXtx2xtZa9OpOQYK9YlEjU6	2
795	Rod	Egdale	regdaleld@mayoclinic.com	2024-05-26 10:14:45	$2a$04$VpPDtBXRpeEqVliCS20PkeMCrOhHEhlknvEjnay1l.JRdCvUrg18O	2
796	Etti	Bayldon	ebayldonle@ameblo.jp	2024-11-09 05:13:43	$2a$04$5pZTeIQHe3qvI2bJrcgV1u0xphjaFZ76kw5ervIyEUhGJQwP2eupG	2
797	Kerk	Cains	kcainslf@cdc.gov	2024-10-01 04:12:46	$2a$04$9CBZ29i4iddCNXZRcSEjju/jMA2B3UcRGiJj1.GLUr6F39gUY6Nwq	2
798	Humphrey	Stenners	hstennerslg@toplist.cz	2024-08-06 21:47:14	$2a$04$8Vzu0O9ITHY1Anezt79H/OcE6PadDtOg7y/xNGnLHbKU13cHMMS6W	2
799	Emilee	Caverhill	ecaverhilllh@zdnet.com	2024-05-28 11:31:49	$2a$04$/zBviutTRCoyh6t1qXmv/urBWNGjiIkGtisOKsC734mYyAj7ka/D6	2
800	Scot	Espina	sespinali@columbia.edu	2024-09-09 08:20:30	$2a$04$MyvFdJfVXhFFM7A3sqpNAeIaBPBPqBMj6PCt7OjHv1ZocIP3HTobS	2
801	Bond	Neate	bneatelj@microsoft.com	2024-05-25 09:03:32	$2a$04$j.vpNnZrFGHppId.5/UMU.ac6sOmAHwCL.K3O0HJVOsenITFGxONy	2
802	Grazia	Papes	gpapeslk@bloglines.com	2024-06-28 09:11:03	$2a$04$jgLrrZF.h5MjsUAIJgx8dOzVPZp0ekjZNZqPqF9xke23UoQD6/q4K	2
803	Georgianne	Stopper	gstopperll@paginegialle.it	2024-07-24 03:21:22	$2a$04$E1YjxtBGlkFjVe/mL3objOAyFWeAz5dgMBnePWXbtfMvzZhZrrVnW	2
804	Shelbi	Novakovic	snovakoviclm@latimes.com	2024-07-21 16:36:21	$2a$04$NkES716eFCrBbHty05SuMeYXiNjVgYCC3CVKoUHK3YEwYRgIxaa2m	2
805	Vernon	Freestone	vfreestoneln@about.me	2025-01-31 10:37:01	$2a$04$qBdvNUqMcYJGdoCr/VT6vOGj2Xxm1QWdX9ycaPVL3hAVf7zF6WMki	2
806	Dianna	Sothern	dsothernlo@mapy.cz	2024-03-16 14:09:38	$2a$04$sBfAkhyGU73eov4vQsYNf.VXVhF0dLxYP8H98JVHkNv8TJu/Edrvi	2
807	Monro	Grimsley	mgrimsleylp@acquirethisname.com	2024-08-28 16:02:35	$2a$04$2zyYXUbIUrfB3Vlue1nQv.5jn2Q4d9wNuBAdOVKxJ2ZWuLaN2NXuW	2
808	Jocelyn	Hills	jhillslq@state.gov	2024-12-06 07:48:29	$2a$04$2H3dstuyVgC4QcxtJQ5SRugSOsQ1GT4bX0xXtObSD8DKOvZk15Jwm	2
809	Chase	Tangye	ctangyelr@accuweather.com	2024-10-30 08:50:07	$2a$04$i8yYSdARpuv9..zbJ4zpauSzt1x01MtqIQlLiLRXk3n7KgaUs9Cta	2
810	Shem	Calway	scalwayls@howstuffworks.com	2024-09-12 09:40:47	$2a$04$vXr9iWkHaM6HYDIHwVC27eomCuJEUq3pynI11NfdKyvWCLfzRUiJi	2
811	Regine	Bracher	rbracherlt@amazon.co.uk	2024-11-03 18:26:05	$2a$04$UtVvAYxNnWoqh/517V80/um4hbMfu/t9OxDCwJKlfGJx1xnn3V43u	2
812	Cyndie	Braga	cbragalu@wikimedia.org	2024-09-02 05:51:03	$2a$04$TMeFwLQ12jFmel7SPJ2uFOq24QGspxjSSpk2WGfhNmOLHs6sSsRzO	2
813	Alanna	Renard	arenardlv@toplist.cz	2024-08-22 19:13:43	$2a$04$yxBkNgNVYetD.WazEdEJJ.2PYQOXvU2nrFgwQe8/Ku5SQ2dH7iJJi	2
814	Shauna	Chaplin	schaplinlw@barnesandnoble.com	2025-02-01 00:06:18	$2a$04$gSZNu7VzYpGq6EKsuvLHBOFg4zsU.OMqfLU4WURJkgkQGFiaXy3tO	2
815	Olivette	Showering	oshoweringlx@google.com.hk	2024-11-11 18:47:07	$2a$04$IvrMhYL5.gQSU3qbcBJR6.oEEeM4/xKTJkH3v9KDX1OJhNdb35eo.	2
816	Barnie	Jeannaud	bjeannaudly@1und1.de	2024-10-11 00:05:19	$2a$04$MGgxY6Vr1H9XUVu2vLN/6uNlXtH7mdS0h.GTkc0Mq2j3qAgr9B3..	2
817	Cole	Craxford	ccraxfordlz@cbsnews.com	2024-11-02 12:26:59	$2a$04$BBIUL7mjzELNwTaMPjl.PuU0XnOeYIj68ul/sc9y5nhgxEDlHuita	2
818	Geno	Romanetti	gromanettim0@shareasale.com	2024-09-13 17:39:14	$2a$04$GZqFvH4M/CHUrC1rRwgZVOAAtGvUM5bU/V1pLorHD1pZxjo/4DX8O	2
819	Maurise	McWhin	mmcwhinm1@miibeian.gov.cn	2025-02-14 16:14:02	$2a$04$bqcTgJNaYB7j2jHKKy7NnOIX1/J1rm2q/InwE3.zCuhp70VviDZ8y	2
820	Millicent	Brookzie	mbrookziem2@vistaprint.com	2024-06-02 01:13:33	$2a$04$R3x58mUopDr5xrCEiUCQme9VktG.10BWpUBxhTUAi4FEjHlAz1npu	2
821	Ferris	Boakes	fboakesm3@diigo.com	2024-05-12 18:36:18	$2a$04$eAo/m17L9BHwMZdXMKFzM.4fn9Va7ljDUgRmuYUGudO81BIHogPZa	2
822	Maxy	Yeeles	myeelesm4@gnu.org	2024-10-20 21:38:31	$2a$04$/LYcsfcP5QlExowrVDrtIu26HnKttUy/2KYKIsd2P8qun9/NY.2Li	2
823	Upton	Gladbach	ugladbachm5@wisc.edu	2024-10-14 11:17:48	$2a$04$hXwbONBVTzT8td5b33H3kO9SOyqRmhXmK43EEmM7la/dbcpo4zP.a	2
824	Sorcha	Widdowfield	swiddowfieldm6@unblog.fr	2024-10-24 07:07:43	$2a$04$7CtVEbzwvm34FZfI1QL4AOiiKlvttULwQPaykMDwPi.ul4KZZ/KAy	2
825	Chiarra	Root	crootm7@amazon.com	2024-06-11 15:29:35	$2a$04$quvBV0HkCMfA42yB9Ybog.GQVchnT1DlCSM4TXFiuBAsI2lFky9mO	2
826	Lucille	Braidman	lbraidmanm8@nydailynews.com	2024-05-20 23:51:48	$2a$04$6FG2O/bT/uossZEC935Q2eTdZfSqjusyYbiolhVJEqR.OaYvMCKAu	2
827	Gilles	Mulbery	gmulberym9@un.org	2024-04-02 06:09:54	$2a$04$6T.5fKfCdV9u1wiSa4GOvuLFzMJPeovuU5V.pkWd3crModLmo/ZeS	2
828	Morgana	Telfer	mtelferma@bbb.org	2025-01-23 14:21:38	$2a$04$MqTIBwDKftyope7l4T1BHumVaYCFLusEsdOFJlgrXh2n6CclA4bk2	2
829	Francene	Duddan	fduddanmb@github.io	2024-08-01 23:50:00	$2a$04$.jnVfkq1Czb38HBfVsXNUeiH/VD8TMiTxaO4idG6/Ndvux2LRkUja	2
830	Lorri	Ilem	lilemmc@forbes.com	2024-08-17 15:45:23	$2a$04$To.lcIrzWOjpFeND4ZeIhOBNK.WoCzgqaXZTM154bQx5FgcG3gDO2	2
831	Winifred	Verbeek	wverbeekmd@house.gov	2024-12-21 21:53:29	$2a$04$WqtwiV2JRYPZaMd.xx4nmOadu9zQ.OV8PGrhxaYyog4BSaavrOFPW	2
832	Wilt	Nazair	wnazairme@spiegel.de	2024-10-26 17:42:04	$2a$04$OZYzMTymETQi/s0/DjdhtOU1VGSHlwYbQu9gS8sIfZHQhig5Did2.	2
833	Grady	Duke	gdukemf@opera.com	2024-07-23 21:15:25	$2a$04$OLGhCFKhIuYOqZClOjTdY.qCCjlRPNzvOImo4IbYFPgNaHMKJUuuG	2
834	Joly	Welford	jwelfordmg@upenn.edu	2024-08-25 11:06:42	$2a$04$RpI/wVTagZCWcN7dJCgQl.Kjv42gxJ.bh.fbf5umi2zskx1njAC4K	2
835	Wilone	Cristofano	wcristofanomh@google.de	2024-09-17 06:11:48	$2a$04$Dgs8NmKjqDT1v1FVsARPOu0VBWsVpk/Uuy00ITcDJF5tEn.iOTm96	2
836	Kirbee	Spearett	kspearettmi@cocolog-nifty.com	2024-10-29 06:03:58	$2a$04$Fh3mylaTljwdNeHuO9B5L.1F0VJtjUmv7f4VL3kyutwaj16Ijy1X.	2
837	Rowan	Spinella	rspinellamj@shinystat.com	2024-08-15 05:12:08	$2a$04$RStAa0AJpQezyVhY9WW4M.4plaTY/Wyo5znAZPylnyI9IWN3.cI/G	2
838	August	Napolione	anapolionemk@hc360.com	2025-02-10 12:38:21	$2a$04$qEx/pc8AZDkzBPSM4rdIIeEqajkuS/gk9lxgwPlcKe5RefPYFm01e	2
839	Nikoletta	Bartleman	nbartlemanml@fema.gov	2024-03-23 17:20:17	$2a$04$CjDfb/hy87nRFfIb660/pO/s.6AWBIwagEDl.KzP8GKDgI1ZDiYHS	2
840	Yuri	Corradini	ycorradinimm@blogger.com	2024-12-15 10:27:21	$2a$04$u0piNYjsi53HcuSCe464z.3dxUHyAxfLBsxEc3Jx6YvVNWo7HyHLC	2
841	Mildrid	Stears	mstearsmn@google.fr	2024-04-16 21:03:30	$2a$04$hNBOxFbjJP8d5MI0fKB7KOB7E77F8hl..VJNwtIZH1Yx7PSVDfafe	2
842	Marcellus	Croux	mcrouxmo@narod.ru	2025-02-10 20:09:46	$2a$04$327qHZ8e1Jcao1cK516G8O1LU5b36y5SJuqSWdnk6fKpeMeGRWknq	2
843	Madeline	Rock	mrockmp@cdc.gov	2024-12-23 02:58:54	$2a$04$uPDrVV91yFfFOQ2rQivwtutLIaZAu/Qg9y3Q8kem58zqenQ1wOzw.	2
844	Natassia	Kensy	nkensymq@elegantthemes.com	2024-06-04 14:25:32	$2a$04$azqPJ8Fa5LPHR2JGuut5neyPq5LyiUi2rgIAuVaFAEJStg/kjM1su	2
845	Jaquelyn	Lynam	jlynammr@friendfeed.com	2024-09-22 18:08:20	$2a$04$yGq4fZLsbenx2C8PjkGqyuJWNBoAI/DKGuzqT4blPxeGczNA4cw1u	2
846	Scotty	Galbraeth	sgalbraethms@fema.gov	2025-01-24 18:02:46	$2a$04$Kx/L24g8iZekyl7Y3O5nT.fUszMGTCT8LEDzYUlTzU3ar5UfFMFFK	2
847	Alex	Pedican	apedicanmt@pinterest.com	2024-05-15 04:42:37	$2a$04$cro6d4Ju6Acr9Av3pT9d6.YCL1zKlxOBuq3896MvkNnrY1HHmbCdS	2
848	Andres	Austwick	aaustwickmu@accuweather.com	2024-07-05 16:32:26	$2a$04$qgEYxd7Rz2jTidmLyOdwoOPcFZiR0h/5iyL7FCd0vuFfx.qxIuJA.	2
849	Rodd	Ambrosch	rambroschmv@sina.com.cn	2025-02-28 11:03:32	$2a$04$6EQ6PIeP5D26OAcIECrhXOAu8buW2a45kleRaXXuhaEl1gO58LCaK	2
850	Selby	Arundell	sarundellmw@facebook.com	2025-01-23 08:24:00	$2a$04$ivqDXAAgIVNAimCdh.IuieJglPBvLawHwjuc83mpy9IIq4C8UbSL2	2
851	Thebault	Rao	traomx@geocities.jp	2024-11-05 02:49:48	$2a$04$RdvW18890nJN8g4vsIjaLeo4HkuaFMMIvIGrcEy/sth730CrAmsJy	2
852	Yehudi	Gillian	ygillianmy@usatoday.com	2024-04-24 11:47:13	$2a$04$RR/rkLYBEWon41XS468VkO60uDf5pmL1vGdyLNomBbepL4Iu6AfdG	2
853	Gunter	Dawtrey	gdawtreymz@youku.com	2024-09-05 11:14:46	$2a$04$prDvP.M1RO0Y.dJ2/U8vP.cPrkNoAyw66HIUddSlYvOjP.o2YQpBi	2
854	Margareta	Costelloe	mcostelloen0@myspace.com	2024-07-18 19:25:13	$2a$04$ubZrwVPLjI4ZTSRlJuxbg.2DXPOhnFmPINV2aIXOrccBgoupeP5cy	2
855	Ash	Heindl	aheindln1@ucoz.ru	2024-07-18 13:09:33	$2a$04$hem/ISjChl4jUGa/tFG8ieTzCewpo8s0rdhPeWjopb.CLngk9mE0K	2
856	Daryl	Neligan	dneligann2@deliciousdays.com	2024-12-17 06:22:40	$2a$04$J7TsmAzk8NHvFl8zlvpmcOfue1yIjz9b64t/Gc.8PqTNkvSyu2oZ6	2
857	Tony	Gorrick	tgorrickn3@quantcast.com	2024-11-16 10:38:58	$2a$04$88Y70LvIrAVEx/7AACfHMed6VHdg1XYycjg7Iownf8cv67UTH/yZG	2
858	Audrie	Ismay	aismayn4@prweb.com	2025-02-01 12:07:26	$2a$04$gn3ZOi0mPqMiH0EoDGQ9I.RVhJfLhCnZQ9zymkHYb/E7rDh6ZFo6W	2
859	Lissa	Compfort	lcompfortn5@quantcast.com	2024-11-06 01:08:17	$2a$04$MagLUdKesc7fFWdbqhcLSOlaofWcUDiVAtLH1sSB6blLOAW9hoJa6	2
860	Milissent	Boards	mboardsn6@blogger.com	2024-07-30 10:39:02	$2a$04$YeLUsir/fI5K9KWeBsE2pOR2lwlIE212E2yVd1BcmKqBkmocgJa66	2
861	Dix	Polson	dpolsonn7@taobao.com	2024-12-09 12:31:44	$2a$04$R2s7.5w4oOxs5fG/6HcSnONI5GoX8RHA1EvzTyUtnsW9A6LHlnD9q	2
862	Bamby	Labdon	blabdonn8@cbslocal.com	2024-10-03 01:47:28	$2a$04$jpwisACcKMz/e4otfcWVveLCN/4RYC2torZpcB38bPKkgWDEVLs/6	2
863	Agnella	Matusovsky	amatusovskyn9@ibm.com	2025-01-26 12:47:54	$2a$04$jefTorQR359a1MYNJrS8NO/j1cdFHFzo0YwTrIGc0cHTovEQvDzUu	2
864	Maryellen	Siddall	msiddallna@free.fr	2024-06-11 04:05:10	$2a$04$YZwQAMcfcczPEP0uqDuzqOVHw/hScNi0QHQRVsWw1q30RK6RJkygC	2
865	Kit	Paffot	kpaffotnb@geocities.com	2024-08-02 04:31:58	$2a$04$MByZcMcw2/TPgVxGC81o.O4HPAMMot66kxB67etsv7KOZscjzfArq	2
866	Tully	Dunk	tdunknc@phpbb.com	2024-07-07 01:39:41	$2a$04$m.m.ndaOe.Il0tvII8TVyewQqfKhzMTvEtxAAPgkY.nWZRctNvmlq	2
867	Kerri	Londing	klondingnd@google.com.au	2024-03-29 07:09:37	$2a$04$SshX204kV5BjG4CxdpMMxeHRifSNh31CRzFCtdWoac8K.8yvkFJ.K	2
868	Booth	Andreutti	bandreuttine@fda.gov	2024-08-21 19:20:44	$2a$04$868iipxX9P7.eCU2kUNEDuuG6ujzxJFUaWl2VsEa.GcnXWEhdxMrW	2
869	Madelene	Biggar	mbiggarnf@adobe.com	2024-08-07 21:17:50	$2a$04$UhI8wzX1P1tsgjssyOMxH.K0EWcvFmIdr7aORvd5Lqyv7h1CMuu6W	2
870	Nona	Figliovanni	nfigliovanning@mediafire.com	2024-10-30 06:18:40	$2a$04$qnE4Ns0TpOyu0MFvpKXNDe/kmPBHjaJtaoOlLu1iIPHcTFXq8nffW	2
871	Saundra	Cowl	scowlnh@fda.gov	2024-09-09 07:36:49	$2a$04$p5oXy3.aNgi9KCfLOoOMcuFnY8epW4ovBQnSzEV8hJBbLAetmZUVe	2
872	Karoline	Pidler	kpidlerni@technorati.com	2024-09-21 14:15:44	$2a$04$HUZgtTThldDiIHCOqtj6p.qk1dPS.2E..L7EJD/34zf8JCj.KqqAu	2
873	Vinnie	Derby	vderbynj@hatena.ne.jp	2025-02-16 18:22:13	$2a$04$2Ps66sr2FH/Pd9X6MLq4SeKePnyOnZUkChG0I2Zki.qt8y6FCjUv2	2
874	Fayina	Leall	fleallnk@gizmodo.com	2024-05-15 02:10:58	$2a$04$GcZe7iB965InamAnGJKXHuJUxhty7uFzH1Ri65eA6gFP6hU9PCy9K	2
875	Maynard	Birchall	mbirchallnl@scribd.com	2024-08-06 01:40:50	$2a$04$ZuvpSARBikj/7l4NK7ltleQsohdeB4OW8/Ne5m0gxWVmIghm7jWS2	2
876	Bree	Bawdon	bbawdonnm@goo.gl	2024-08-13 22:42:51	$2a$04$cLx3bmPYex8o7hBVAPxhReUkfj58nRUjg7d7b7/p4uOQyBO/2ke5O	2
877	Gasper	Basterfield	gbasterfieldnn@1688.com	2024-09-18 00:58:49	$2a$04$42jJt9DXE2o7Hj6AzHWczOE9Bmvn3BGQGJ3xfqX9o1tw/dGNrQYvq	2
878	Merilee	Manders	mmandersno@eepurl.com	2024-10-10 19:06:53	$2a$04$lBoW1o78mPlhswLnEGRIpeI1o8SJCMKkKk4srIu80OxyBW65Tkkti	2
879	Bastian	Hellyer	bhellyernp@prnewswire.com	2025-01-08 08:42:34	$2a$04$hOSJ2WzlQvJKxIfiLcULQeLlz2kO/cMMZT9trehst.ROEtw22Bi4W	2
880	Monika	Baumford	mbaumfordnq@meetup.com	2024-12-13 21:51:41	$2a$04$Dw5PxHm5Sjpjl/4/bqa6HOLuqVp54nyhZWtWjsFoHByogcHfOxdqC	2
881	Elton	Trimming	etrimmingnr@bigcartel.com	2024-04-17 23:50:32	$2a$04$GFaWA48WEmUnuq.Cwe2cROYvLTPhgiZAjLnacEenoR14IyE0WgoJi	2
882	Delainey	Cheves	dchevesns@weibo.com	2025-02-09 18:21:54	$2a$04$vQueWMgOCHx2.5SIZui51epiC/C5s1gpASVVNNZIEHvLgsUzUMBtG	2
883	Allie	Grimshaw	agrimshawnt@cmu.edu	2024-12-07 19:17:07	$2a$04$lvwz5sr/4dfGM3/rdMbej.hgU4pXJT9/1oY3ZE0nh3Ju3eZztG4JW	2
884	Lyell	Navarre	lnavarrenu@over-blog.com	2024-05-27 18:28:10	$2a$04$94gGohMLcahBmhXRHPja9.9HLDqa3j8B6iKRVapLMizjhl1O1vaf6	2
885	Nissa	Maxwell	nmaxwellnv@umn.edu	2024-08-31 15:05:42	$2a$04$FY0ekYBa2N6jEDRUwnbqCuXRKVJ4ViYmSaeKDI9FMl9JPxCtHBeyK	2
886	Franklin	Costelloe	fcostelloenw@time.com	2024-06-11 16:07:50	$2a$04$vJk18tb/IWBM2/EG6gNfgOYNregSuzJC4SdLpW8BLkh26Ita.Rer.	2
887	Huntley	McAline	hmcalinenx@europa.eu	2024-09-28 05:59:51	$2a$04$n00meWzNsJGrmjUn42ysyey5wgXxeKpEA4mzyA9.oZ3EFoet7EQQi	2
888	Wallache	Murden	wmurdenny@wired.com	2024-08-14 01:24:47	$2a$04$rag7wwOiCA69v/K66YT45et.FUZ1dJ4rrZR3i1xzI/MvLsagTRMn2	2
889	Danny	Debenham	ddebenhamnz@illinois.edu	2025-02-06 22:17:06	$2a$04$MeR.CmxwjToDBNkzCDOTA.1E44a8APIfYlr0.LEQp84DBIfIBxxzq	2
890	Nada	Mouat	nmouato0@nytimes.com	2025-01-29 12:23:02	$2a$04$aPyDBY9xzCNv/UqYqsf2LehBI7Dagc8D0iTSp0LPislQz77ZBuA6K	2
891	Jacynth	Saurin	jsaurino1@xrea.com	2024-09-18 14:21:34	$2a$04$vav.Wh3o7vMafkMDM3x6QOZb55uIEOlAifh/ocofDH97v6Z.MxHtK	2
892	Marrilee	Yakunkin	myakunkino2@prweb.com	2024-03-19 07:07:17	$2a$04$5DtbvyyO/Krv3F3QVYMJ7use/9bRmKtRG4weFfKEjSTaY4ltdMnUK	2
893	Daffy	Kirkman	dkirkmano3@census.gov	2024-04-09 19:19:09	$2a$04$Z.KNiMoq3NyNtiIU6mfGPupGiATLbRXwcOt9FOCRW4KeNIRW/FjwS	2
894	Kayne	Viel	kvielo4@amazon.de	2024-05-10 12:36:19	$2a$04$h5MvGRC8iOrYnR9NRyi7ZOnGhoN1t5/t0vHlWnbMP06lYkiqJK7/.	2
895	Sergio	Dalla	sdallao5@cnet.com	2024-03-24 11:34:49	$2a$04$biHzzGL24DmIJWt5iKBG7.8yEpdk.aj6OfiHwqMCrjlQ1IL.7Y0ju	2
896	Bee	Joules	bjouleso6@economist.com	2024-07-04 18:28:48	$2a$04$sHq8qFYe5Gbkg0U/24h8juRG1n64MDSsjhi5nTd2aJ7M8xD8QatjK	2
897	Marcelline	Luxon	mluxono7@reference.com	2024-06-04 14:28:50	$2a$04$jshKorqeZh18qhDpLTOthu7Uovv7ucI.yzovNdWlXZQRt31CIOjha	2
898	Raviv	Snuggs	rsnuggso8@jugem.jp	2024-03-30 08:34:16	$2a$04$Da/CgV7ggMD2yC9L2mNtN.dOnJSVU0UV2227wMrmVtGb9GVJ3zFfi	2
899	Prince	Jordin	pjordino9@fastcompany.com	2024-10-19 04:02:49	$2a$04$bya2Dctve9z//A1wo0c2r.2wsMvjFLpsza0493ovk/0qFCziOoinS	2
900	Felipe	Keelin	fkeelinoa@fastcompany.com	2024-08-22 18:53:31	$2a$04$JY7Lq.t1/Z4mg7joM1KyfeiaMmkqvap4N6kGsaRCbyGsP4ZxG8EY.	2
901	Bride	Morrill	bmorrillob@google.com	2024-09-10 01:34:16	$2a$04$HF8yCc4uTbrVpT1WjxqmUO1MnYfK23zaFNrgbUxLlK.uYkZau9GEW	2
902	Victor	Gawkes	vgawkesoc@reverbnation.com	2024-07-02 03:07:03	$2a$04$wYEcNlgGDquqUdzn/b4sl.sVX4juEFPz4JSVUO1J1P9XDo5wxxwlm	2
903	Erina	Torn	etornod@hugedomains.com	2025-01-16 08:37:16	$2a$04$4MH9zzga./FxKgpbAIWb0egkQ/8EEZzSZNP8Ab9rN.35ZLzEmIPIG	2
904	Dewey	Feehery	dfeeheryoe@angelfire.com	2024-08-22 23:45:25	$2a$04$EBqRtiHFB23qCAa67ndMLeihJo3XFwYxtZCDGPg/kPzXQLpVKIBVG	2
905	Arne	Torbett	atorbettof@a8.net	2024-04-25 10:42:25	$2a$04$oLI1OzZK9skbRuGux1LrIOu2HNum9nwvWMgeQsFZazfJdkJJVK1Eu	2
906	Gusty	Taylorson	gtaylorsonog@clickbank.net	2024-03-03 11:38:48	$2a$04$/ivRKDg7L/uyFlz7eapdY.VznXaOP6fohoJGDQXinBLChyzQyWgeO	2
907	Ringo	Curman	rcurmanoh@nps.gov	2024-12-12 17:30:02	$2a$04$9vAteRsjEtNEPzGi3sYm0OSURQE9XNThfRO516d/uqls83CVZEcLi	2
908	Stanley	Shellard	sshellardoi@gnu.org	2025-01-16 12:55:08	$2a$04$mDjFtQhgaFQBjfLov1wiDui062IDGz78P7SqVWlfEEawO1DVGwmHu	2
909	Aveline	Saladine	asaladineoj@mediafire.com	2024-05-02 09:07:13	$2a$04$e1OyIHLhoUo.63tyfrEHYuYleSrdht2pyCW/00UhNaBzhcNHWmyy6	2
910	Ivette	Vermer	ivermerok@1und1.de	2024-10-10 01:45:04	$2a$04$FTTIQoGQJoUX4jCgmzSOkuJGiEL43aGGvr7dUJJDL/6/.NvZYosEG	2
911	Sigfrid	Hiddy	shiddyol@latimes.com	2024-09-12 13:27:22	$2a$04$PssrchCnO/sZW2gkb72KQ.2Zai2EZ5v1uHqifrMaTeqC4wHEaMgve	2
912	Pen	Ropking	propkingom@weather.com	2024-08-18 22:04:42	$2a$04$Q1aTwSkP0up/FMxrlXq3SewYbgipLIzydhRdCiYv0cZ7kFxfDp50S	2
913	Annie	McKane	amckaneon@google.pl	2024-09-02 03:56:33	$2a$04$KhRZBUMV84i.RPvdthFLbedFl54TVtdBnR7Myk3aNczzqGQ1y8qHa	2
914	Rayna	Alenshev	ralenshevoo@hhs.gov	2024-03-16 09:18:20	$2a$04$M6yxwUC9npyTtZLXq2a3euiUKtqgo64GxaKei9rTrigHtaYfGJswq	2
915	Alaric	Snaddon	asnaddonop@mozilla.org	2024-08-20 13:16:06	$2a$04$s3oK5oHsoYVo3qQN1vTdTu94EIEgtMri58NxVmC8UvrtQ9yBWcwW2	2
916	Sanson	Baston	sbastonoq@wordpress.org	2024-04-02 09:54:22	$2a$04$D/U7EhfRHx4QzMlQ8w8sjuVK9V5TxSXUdhS.yF3gBXPb0/D5T2BzS	2
917	Piotr	Wagnerin	pwagnerinor@umn.edu	2024-09-12 09:04:44	$2a$04$AydjbzOere4Xin0kFJs/oernnwbue5pJToeLa3vwZOmW.6HBCxlTW	2
918	Rosemonde	Westcarr	rwestcarros@google.pl	2024-07-26 15:40:34	$2a$04$JPXGkH5sax3x.dc0YhxBz.bFf7A4J76UFyoxojuJqxK4CgO4HcCce	2
919	Livy	Lightollers	llightollersot@freewebs.com	2024-08-20 12:42:23	$2a$04$vd63TrmHwPpSUf.ztDKgCeXTEaUwAAvv//QrQvYTKyL2Ul0U26amG	2
920	Margaretha	Eden	medenou@bravesites.com	2024-04-23 06:47:40	$2a$04$kf5FVrK4QYt0fFRHnYdj3.V9seYhQjyJh/gQZf8vhG50qxrxZZKB6	2
921	Devland	Terron	dterronov@desdev.cn	2024-03-08 06:58:11	$2a$04$GZ45J167G8G5QuKUSuLQleUk52DaujqEgpyLoAnyDHAUviyLVsvAS	2
922	Deena	Lowry	dlowryow@fastcompany.com	2024-07-12 01:29:39	$2a$04$fYSyhwS3MS/96HAyeVbGfe2QeILM53Nr6VqN9.Wt9o.mlXywLoDjm	2
923	Gare	Yeardsley	gyeardsleyox@miitbeian.gov.cn	2024-06-21 11:07:00	$2a$04$dY5Vv6zxIQY/XuUo25bB5uCY.kcbM0lordi9rC2dXYFLNN/XtPCZK	2
924	Kacie	Bingle	kbingleoy@merriam-webster.com	2024-12-21 05:59:48	$2a$04$Pnwzm0ICBgtqk4gM341D7uWVyS30zId.J6IokEDTzXG9jnaNL8Aa.	2
925	Andie	Fishley	afishleyoz@reverbnation.com	2024-03-27 12:43:38	$2a$04$8p1TwypzwqMzIDwA10lKZOr4wUjTI69F95jhzy1LyabLQqo5.ZcL2	2
926	Thom	Blankhorn	tblankhornp0@typepad.com	2024-09-08 07:14:08	$2a$04$/S3BAbqccVy9eXH7dpSafuH.aUD7AVfbjpnAcWjk..VcARCLZ4tMW	2
927	Cynde	Driussi	cdriussip1@upenn.edu	2025-01-09 20:34:06	$2a$04$n.fZCUOqd6A4/wopOPPJfu1Ag0gXl/otaBNr4dMieDkHJFfHp3BAe	2
928	Maisey	Eayres	meayresp2@homestead.com	2025-02-28 12:21:29	$2a$04$xhZ.ohxvqP2kB/7CaXB9h.qEW8JuflKBxVI3MeV0ztApUY1.ULwyC	2
929	Donall	Bruna	dbrunap3@csmonitor.com	2024-09-20 20:49:20	$2a$04$p6Vdgo6ExzlJZHifZmurve8wVzrbCBu4mMQeKEom2qUTfVUsB0a6y	2
930	Ignacio	Mayworth	imayworthp4@creativecommons.org	2024-06-12 16:26:18	$2a$04$iDti7ptE1wn50RifA/SJeO/vur1Q.a88r.h.zGDrtIFOBFzs0VJYG	2
931	Gunilla	Neubigin	gneubiginp5@icio.us	2024-03-13 19:37:29	$2a$04$n2vWDkD5BYBqYHaF0dLGQOzCFGiMCe4bq5Ym9A/ezN5XIsttNFQXu	2
932	Elnar	Strange	estrangep6@latimes.com	2024-08-18 20:00:40	$2a$04$3XGFfjlQgaM.26Tr1ZmsceJfkO.Q6PyKuSREGU8yshn7XVjeO6M06	2
933	Shermie	Wingar	swingarp7@cpanel.net	2025-01-09 19:49:39	$2a$04$7nT/RDAEfrXO9jBkhjSygeEL/YHDAlIY2UeuTHSJvbgh/ipPa.o3m	2
934	Leicester	Cartan	lcartanp8@addthis.com	2024-11-30 17:36:02	$2a$04$3kziR76jw4q.D7sd.m4V.ewLaFRY.PKWcmptYyGlvIQLOnRh3MkQa	2
935	Obidiah	Easbie	oeasbiep9@istockphoto.com	2025-01-18 13:29:12	$2a$04$GVNTrVXOUGHak7cNlahcO.hJItrA4fyoNyUGXw2PC.UxV6V2f.z9O	2
936	Lea	Gammell	lgammellpa@shareasale.com	2024-09-23 06:56:08	$2a$04$l5J1rKym9uBms9YxCD0foee8dmLpG8LBf.biS/qFE2zKJlgz1IFem	2
937	Danni	Wikey	dwikeypb@toplist.cz	2024-08-18 06:00:40	$2a$04$.Y7Fl3NNjR4vLRxPBtCHhOKkkATQwbTNXPWXPNzxpNbBy./iDqw7G	2
938	Nalani	Boerder	nboerderpc@princeton.edu	2024-08-18 12:45:27	$2a$04$1xnLWOWlMh60LJOG4egvxO2PQfiIGNz/AtoyEyBIVgn0pp4TwdJDa	2
939	Molli	Shaul	mshaulpd@google.ca	2024-04-19 14:27:07	$2a$04$pBPzTzhvm3yA73QBAb33LOSBZB3G.CQgHg2aCskTmoUnHivYkG2oq	2
940	Aimil	Teasdale-Markie	ateasdalemarkiepe@businessweek.com	2025-02-19 20:17:19	$2a$04$jCeyecrLodT2pr77azzq4.u/XtWzJUSjwsqYalal5zoRtcrt2bWg.	2
941	Scarface	MacEveley	smaceveleypf@theglobeandmail.com	2024-07-26 20:37:22	$2a$04$P0A5Z3C.7.15E1W9.u7Is.CCE.3eV0xeRabXdBe6YyisXPjPsoGDC	2
942	Yance	Primett	yprimettpg@infoseek.co.jp	2024-07-13 01:09:11	$2a$04$QUBm7DCdybm8C0bNVWIOIuS3KFjZUfEamHC7tNPk3XbJdoCFsxXta	2
943	Phillis	Moseby	pmosebyph@howstuffworks.com	2024-11-26 18:03:28	$2a$04$RJeKdq/eGd8MSxDs.vaQ3u9qkTKKrQ.s43ocC209UFJXzLs991J02	2
944	Allyson	Adamovsky	aadamovskypi@networkadvertising.org	2024-05-27 21:09:01	$2a$04$TPfs6HDRtwODUpMvcyjrJuHdGh.w/IBsd3DkX/0KedEgGx8ed3A3m	2
945	Belicia	Bavridge	bbavridgepj@opera.com	2024-12-20 04:01:51	$2a$04$UYOgFQsioeGvZx0MLduEj.Fxi38/yHTV9vD/9thxKUHfjI.xtHYzq	2
946	Simon	Samweyes	ssamweyespk@cbc.ca	2024-11-13 06:14:59	$2a$04$m85E.yFIb65/RY9j1vzaD.Mc6/wBW9EdeB5lHj5YDtdNWDq6aaVJS	2
947	Kerby	Macilhench	kmacilhenchpl@bandcamp.com	2024-06-05 13:40:42	$2a$04$i/YQ8yDSlmkEaaLu1FDp2eZckIwZDWFHSiFKQaAXqhglDWdQjjXnG	2
948	Erna	Le Sieur	elesieurpm@patch.com	2025-01-29 04:28:29	$2a$04$2zAbfjKULFLNvcthvp7rx.6ajp8NOZ58O2Ytn7vxQQuVoey39kRq.	2
949	Jenelle	McKinie	jmckiniepn@163.com	2024-12-10 21:10:00	$2a$04$3nlak5cIws4sNqRRY2MLi.98QE.U.WoeapChQRcTgfgiPlLMNjrbq	2
950	Danice	Van Der Vlies	dvandervliespo@godaddy.com	2024-12-05 00:41:04	$2a$04$BgPOseBpaKNxEzovkBPGMuJvxhJPwB4MLYyd/5o93OQc01RDJF5a2	2
951	Kelsy	Trathen	ktrathenpp@opera.com	2024-05-01 14:08:47	$2a$04$Hl5.0kSc9kH5WpwQDCvyP.qKqtX5Rzs5vnHLgblcQoMo5gNtAnGDG	2
952	Jerrilee	Jackways	jjackwayspq@sitemeter.com	2024-11-26 10:01:23	$2a$04$ygsYeyktxjZjXLrzhdsXPOIC2ca.I5uZBGDJOh7J9rfwCH0Izp7Li	2
953	Albrecht	Cloney	acloneypr@quantcast.com	2024-07-01 11:29:50	$2a$04$Xqk08c4PxDMAmnP6y6fRH.2lBcqlm402XIQibwNZVYcSDBp2H5Q5i	2
954	Conway	Petre	cpetreps@php.net	2025-01-29 16:25:03	$2a$04$gFD9xcp8DQSQeZaOnEps1.fuYCLnmmdfYUJQqIAv5/B2JGwY5LCGS	2
955	Kelci	Wasiela	kwasielapt@fema.gov	2024-09-21 15:30:48	$2a$04$JpRUXKyszczlAI5aQFytk.DpQ2zRym3ezlEfUKcj4z1xuTGLZLyAK	2
956	Swen	Duly	sdulypu@fotki.com	2025-02-13 21:13:41	$2a$04$Ccpn2.D2WABl.J9Yix2wOu8soKXFclKcWtDXuoZYv.oZOZJAiUzR2	2
957	Vin	De Freyne	vdefreynepv@taobao.com	2024-03-27 07:25:13	$2a$04$J/dGChzFszxArLH9rsPD7u3QTKPByeWOtIahkEgKYQOdom7yD7XA2	2
958	Tiena	Jerrans	tjerranspw@com.com	2024-06-30 06:47:19	$2a$04$tebhFknUqRJ24awfMM55Buy8wr8R22AFnG1XRYSJkAyVlP/6.vBlS	2
959	Mechelle	Going	mgoingpx@reddit.com	2024-12-17 23:52:11	$2a$04$ilKHcmfdaF7JL1AorybTmO9aZK6AUgO.WuOiJIkhZoAiiLn8JMa4.	2
960	Bertine	Frantzeni	bfrantzenipy@github.com	2024-07-03 16:08:43	$2a$04$O8oGwy.iwcbfeG2b6zxkd.WQkImV0ko5GxU.mIzmWpUH9XSKVs8jm	2
961	Rollin	O'Sullivan	rosullivanpz@ameblo.jp	2024-03-06 11:55:12	$2a$04$wv6kkeCjCeb01Zw3v/eMTelOuN5vmhnTbt5n6Vj9MmD2EeSe4a34W	2
962	Korrie	Mullett	kmullettq0@eventbrite.com	2024-08-10 01:47:45	$2a$04$ZZ0YlkrC9I/TakBUAmcKiO9JZkBzGibuKyLqU1syWCF8aVdnkha6G	2
963	Frederique	Aksell	faksellq1@craigslist.org	2024-10-06 21:35:58	$2a$04$hwrRmmbqfq2OannwglKQtuR8VCFeRNWcUbTgt9E2.O2TaVbqnPHoC	2
964	Morgen	Worner	mwornerq2@addthis.com	2024-09-07 14:03:18	$2a$04$l7pJxfbupT5SUg4O..By.uLFeO2HnQ9eqLn28g688beEyRytiF9e6	2
965	Caro	Inkpen	cinkpenq3@uol.com.br	2024-10-31 14:06:36	$2a$04$zglrik2rmUxFr1KRiOH4WeZ0ovQR9xvlSn3bZPBYhQZoOUimscCo6	2
966	Keary	Wrightson	kwrightsonq4@princeton.edu	2024-11-09 03:11:49	$2a$04$x55HD9TRWOZcKPzqb263P.TswHuZLTYqyPcBS52O4xLhZK1cXHS8W	2
967	Kit	Isley	kisleyq5@ycombinator.com	2024-03-24 04:41:14	$2a$04$rlmW8dzkB8QdrRdklAngZeWJi8cQF0VUo4BEguhGRkHrt9T5eS2ty	2
968	Gearalt	O' Dornan	godornanq6@bbb.org	2025-01-27 08:02:26	$2a$04$NctUhXgdvKuVL63v6gSkNuzuPefd4Pa2pX.dXs/pJDPXjrmRCiFyW	2
969	Dallas	Margrie	dmargrieq7@unc.edu	2025-01-11 07:36:15	$2a$04$tGsHL1HQ40Q1c8Mv1GSAvef7sQDcCw1Lt5y8gMMr2D9WWbhugo4va	2
970	Maiga	Robelin	mrobelinq8@constantcontact.com	2025-02-02 19:43:25	$2a$04$PzNhAyfK.PkLl2jXjkimxOemfJyDOvHVMTxdC8LM0q2ep5jNIhfwS	2
971	Monika	Gretham	mgrethamq9@about.me	2025-01-11 04:40:45	$2a$04$EsHTxbIlYrrwVDrHDnN7W.5XtOW5z8.sHMZvLtJ1DCmQnh1U092Ci	2
972	Vivyanne	Blackwood	vblackwoodqa@sciencedaily.com	2024-11-12 12:39:16	$2a$04$D9Axf73KRy5bWJzGQBetG.PUQWU/royoGWF04yKH17Ing9upEdLJG	2
973	Rebeka	Fevers	rfeversqb@tmall.com	2024-05-19 05:48:45	$2a$04$k3T6B6eszDcy9KPwf.6ITujsF6wch/VUHIA9dOQJTgnAwj1H8JmIe	2
974	Rowland	Rowlson	rrowlsonqc@blogs.com	2024-07-07 03:26:41	$2a$04$Uhi8FHbEAbPOY1jQvdymXethIu//9e7FZgd5VCwVfxq8h83tHnusW	2
975	Amos	Risman	arismanqd@infoseek.co.jp	2025-03-01 03:50:23	$2a$04$mPFRctIjH6xqi3Jk.o3gPOxlLl06U9CXuxxb0t57qvwFUs9AjJJT.	2
976	Modesty	Rosenvasser	mrosenvasserqe@gnu.org	2024-07-20 00:39:59	$2a$04$DXDPvco5Vvr4wqWvd30n0uL1DC3Wz2FojSZKKlAov6K7ps0ELieBa	2
977	Zackariah	Grestye	zgrestyeqf@timesonline.co.uk	2024-12-07 16:55:27	$2a$04$V.1w3ScVpoFvU3NMHacCW.z2ubG4YUdu3Ag9MeL6XnfcGWBhezH8y	2
978	Dyane	Van der Velde	dvanderveldeqg@github.com	2024-07-18 10:13:55	$2a$04$zzz9t0sGpYtofV28SGZCeepWoGq8F2h/Hk2KKM0W6BytpW6zTOrpu	2
979	Issiah	Filby	ifilbyqh@flavors.me	2025-01-07 22:04:51	$2a$04$wA1alSkS057yxezU6AX8Reg6rv8q.nE17Bu00hAffSMf282So8O5O	2
980	Carmelle	Cratchley	ccratchleyqi@army.mil	2024-06-25 17:58:12	$2a$04$V2MQ4CVEp.wiuk0Y8gc8reafi2IcO.W1jCb5UQRu/JPP1B/sAMx4y	2
981	De	Sturge	dsturgeqj@storify.com	2024-03-30 09:59:26	$2a$04$.X95VbtUZFT0YdhAPG6Zx.o.WmYqXwhbl/fKDl0iSkjf3y2MHOuFS	2
982	Alleyn	Hasnney	ahasnneyqk@state.tx.us	2024-04-22 23:12:26	$2a$04$OafTlPBlQC1h3A83cgk1CesfZr1G7KI5pLG6URtaMsPdIeeE1hipO	2
983	Padraig	Lowthorpe	plowthorpeql@furl.net	2024-05-07 22:58:04	$2a$04$31f2y6gzwcbaksHPcHnq3efi8eKpXJh5HUmf.5cSkw2Bv6Iw5ib7y	2
984	Pauly	Abbati	pabbatiqm@nature.com	2024-11-24 15:39:38	$2a$04$x7JuNv6DN4X8x/LsWhifYOhp97WOHQldty6eFDRiMTI0W.6aHjBhe	2
985	Tedie	Skinner	tskinnerqn@nifty.com	2024-10-15 23:21:19	$2a$04$wDdhKvZX8kHQWPB8vyJcU.REokztzOwce.VLfj8YmfdixL8A4Rj3y	2
986	Vern	Oakenford	voakenfordqo@nydailynews.com	2024-10-18 12:56:39	$2a$04$419l.u1P/BNVOjT.ZtAD9eq4lyjIv5l2ZZhVyLo3HhbEg/6UlaYzS	2
987	Dionysus	Fitchett	dfitchettqp@xrea.com	2024-06-15 17:15:27	$2a$04$9pxjRoHLzrlt5l767n324.1YPdktsNTBYjgNitJWXynOiFkUdgwOm	2
988	Kendricks	Blackett	kblackettqq@canalblog.com	2024-09-17 12:10:28	$2a$04$IomIqPISUIPrw0IrFd7hJuc4U5w9kojB1ohK2ADrlv/KydqUObKrq	2
989	Jacquetta	McSwan	jmcswanqr@paginegialle.it	2024-03-18 06:58:52	$2a$04$J9Fz3/roJ9rK.rnJ4u6ez.LKZvlNBMVaGAcJGUYK5.sIUMniujjP2	2
990	Peyter	Gleadle	pgleadleqs@tiny.cc	2024-05-27 14:01:32	$2a$04$bilDfru93dhvBsbTQofKc.GYdXVLS9G/ih3gtraEwc/GrFR7.IPCK	2
991	Brandy	Dmitriev	bdmitrievqt@archive.org	2025-01-05 21:43:38	$2a$04$2zwj2.l.pR5owQJsH682DeIaCH3qQFiSmdyOlz1KXKaNUeMQpmnJu	2
992	Gardie	Kirk	gkirkqu@gizmodo.com	2024-12-29 00:20:47	$2a$04$FzxVCK6ngZsGJbt6zFQTsew3zizazSFvp.np.Xw9Ewlo15m6GxgX2	2
993	Hertha	Rottery	hrotteryqv@flickr.com	2024-09-05 01:22:02	$2a$04$oSrWIr1VjhlLhap2uQb/UuNl/shGK7QlIyyRSl9EWl8Jxog3hu7VK	2
994	Jacky	Dutton	jduttonqw@java.com	2025-02-15 01:06:15	$2a$04$v5MKqqQElGpTKohbW5WCZO4idWosehLTaqnNfUpljwNfqLFuChdOO	2
995	Arlan	Spoerl	aspoerlqx@dedecms.com	2025-01-08 05:33:55	$2a$04$xPvOE88MyCvTfp74Dgqun.xbUEjxeIPwMv2HVabRshjpp3LkOI7..	2
996	Cymbre	Hercock	chercockqy@biglobe.ne.jp	2024-05-08 23:14:08	$2a$04$phapZtqHaCnhXnODyscWN.3gERlKBmALCfT0xRlOuwM0Cb7Dsep6m	2
997	Laina	Stock	lstockqz@ted.com	2024-12-07 10:08:28	$2a$04$zdMMZcP6yyZq2Ky1uSJ9DOveH0R9NTJ40ZzyXB5l9ijGJ0CvB5eMW	2
998	Dottie	Keddey	dkeddeyr0@cpanel.net	2024-06-30 21:19:50	$2a$04$Y.n5hpxFHjAD6zmxjIW83OK5xFX8FrkZss/IAlUtjcpaMcQ/b8Vxu	2
999	Chastity	Cannings	ccanningsr1@ibm.com	2024-09-11 11:56:25	$2a$04$wYr79gphrYF8KESdiMmC0erqMbtTaFtDoI0vUlAwcz/gaeIdRkgc.	2
1000	Arlyne	Ashe	aasher2@adobe.com	2024-03-14 02:42:51	$2a$04$egeNXZWnxRoBfWsGhYiC9OGF5pI3KVaFpinPxTUPROFYsC0zclvZq	2
1001	Keane	Teese	kteeser3@yahoo.co.jp	2024-08-29 06:00:51	$2a$04$XmVOntBrwuyzbdPq8eoQ1O/B6KetuCusJC/X7RkK6fL6DN4b1Vmqq	2
1002	Solomon	Clapson	sclapsonr4@skyrock.com	2024-05-24 07:28:04	$2a$04$zvfEvxVmOqiVRXZ33djpBubnTbQf9jdgCNC1fo.r7Dsef9y49e3IS	2
1003	Christiano	Eggle	ceggler5@scientificamerican.com	2024-05-10 12:07:48	$2a$04$GO7/qJCzeSfUHmjv6rkGvus2KjPscNkjy9mKNU1LYa4H3mjN3nGIe	2
1004	Aubrie	Disbrey	adisbreyr6@nsw.gov.au	2024-07-16 20:14:08	$2a$04$BbS.ZuWf9um7rO4aRfSgRuqvFLszx0XfKYrwPITzZuij4O6TNOJZG	2
1005	Tim	Camblin	tcamblinr7@joomla.org	2024-09-20 08:57:42	$2a$04$caH8Yv1zoASfGFwC5aAjWer9RIvFMwjINj8QSo7h8Pd8MwZ7HD8ue	2
1006	Nial	Connal	nconnalr8@domainmarket.com	2024-05-27 14:36:38	$2a$04$EaD4AwtglTXZLpe/XDINLO/MfCay7J8Re94K1ax8Q06GvtbAm1e7K	2
1007	Lotti	Learoyde	llearoyder9@alexa.com	2024-10-31 22:52:13	$2a$04$4vnapP/.cjH7C7gHs144Ee1W1r6MfqFUPX5lKTSdcn17Vrn1R9dGC	2
1008	Cammi	Leiden	cleidenra@state.tx.us	2024-11-05 09:25:26	$2a$04$umNVU4jlXnappSx5XQWFx.5oEazWWMB3T50Eb5TPVh5F34atg1E.2	2
1009	Shelden	Tern	sternrb@wisc.edu	2025-02-10 15:51:00	$2a$04$Jc/Q42BMpwwY6hDKGiuCpObfdfo6inHfFYDeapmnbL3sNjrWqCp5G	2
1010	Verina	Scinelli	vscinellirc@statcounter.com	2024-11-26 02:26:43	$2a$04$pRcunyzff2vWq.IE6c4QN.6PtTG/9dE55czbxy7imCC.4N8xy0Ccy	2
1011	Kippar	Ducarel	kducarelrd@archive.org	2024-10-29 18:32:16	$2a$04$GpR83/9xTpffnA1rNXWjqOI6i8FA1zle5/XCSE8xYN6YCVXnVglDa	2
1012	Aloisia	Catterson	acattersonre@quantcast.com	2024-08-08 10:12:13	$2a$04$GGCRc57Y40FGGQQMBsWvQe13dwG3ara6XNdCRGbeNyM6mFWzXeeS2	2
1013	Ivett	Longstaff	ilongstaffrf@ycombinator.com	2024-09-04 22:55:46	$2a$04$Tzk3QALIt2skUGL4uLbaYuZ7VZBGjwhUvsDmmDHkdpXm.vv7AFTCG	2
1014	Dara	O'Hartagan	dohartaganrg@creativecommons.org	2024-04-19 10:03:42	$2a$04$v0B3VhwHSGh0PsLLGNOtdO/zsW/IqDgzUZA1gdr5Ou9BxDxrAdnlG	2
1015	Rosina	Vido	rvidorh@hao123.com	2024-11-11 00:56:51	$2a$04$Pm3zOWVxhu1BSkG8IA.cx.obvzcjeA7vUSFZIWLxLOmNfdJSq.T16	2
1016	Rodolphe	Peschke	rpeschkeri@pcworld.com	2024-11-05 13:45:14	$2a$04$PL48YocOvB/oiOrfa2lbWunwCfpldAYyvBTgPr2nkZggZePGUzbV6	2
1017	Trever	Beamont	tbeamontrj@comcast.net	2025-01-28 16:17:43	$2a$04$UFr8/vYjkNCVhQs5ghmLNOCm7MCkQzwN.EH1P20zWeLoNE6KL/6VW	2
1018	Charlton	Gutsell	cgutsellrk@cnet.com	2025-01-25 19:04:23	$2a$04$6hwFcqWaBjKVl7MCEcNDau5SHJ7iNn4WpFMFKPuOrceeWrBtWR/Mu	2
1019	Kelley	Shevlin	kshevlinrl@wikispaces.com	2024-10-21 05:33:57	$2a$04$36H9Ed3CcQ9Kp2HX3aD9EOcW4DugjTVWNbEccp00Ny76/da1S9YAW	2
1020	Lewie	Sievewright	lsievewrightrm@ehow.com	2024-06-30 21:30:11	$2a$04$KMCgimHMzlzRRVfzQMfZOeJmBtgj48.4fcUE9MflQNbwOybziMnXW	2
1021	Nikolaus	Deniske	ndeniskern@shop-pro.jp	2024-10-06 06:01:01	$2a$04$ICGKwyW.wKiHMRIciuFwZO1KFY/ICUDLyYEst5pqNDNI7lkjjyS4y	2
1022	Jeralee	Angear	jangearro@sohu.com	2024-07-29 18:47:26	$2a$04$Gonk0Ie4x5LeFIcCtA1u5OeJf/aNdl587dHAMFj8VsCa9ggCpbHxe	2
1023	Niccolo	Kiefer	nkieferrp@blogger.com	2024-09-21 14:21:01	$2a$04$eFLn/PNVmkIJv4uAUMQI0ez5BdGU8JJbfcljRRFfBor5r/tjCO.dy	2
1024	Sallyann	Villiers	svilliersrq@cnet.com	2024-03-28 19:39:06	$2a$04$nlnP3AgAO3ig5jS7m3b6QONasfvnzDGXN9QBK3nsBYza17pYjfgsi	2
1025	Juan	Kitlee	jkitleerr@unicef.org	2024-05-11 12:16:08	$2a$04$joxDPm5EH4Xxgi1VRPcvzOdWnvRFpoeed5Ioz1vQAeLMKhUyb6zMq	2
1026	Gwenore	Carlton	gcarlton0@oracle.com	2024-08-14 22:44:08	$2a$04$2MrI.6m4lutYTr9EZxNA8uAxLIhNIRdVhIeVgSDpL6gwL5Qx9YzLq	3
1027	Zoe	Pettwood	zpettwood1@auda.org.au	2024-11-06 21:34:25	$2a$04$2qZCjSb.4wp7448YoxEPLeIb3Kjhk3WqFT8Qp0ypXxVY1lJ6koPdm	3
1028	Kiel	Luppitt	kluppitt2@ted.com	2025-02-15 04:16:33	$2a$04$TekHdFuBGyMygDK0HunarupAvvtu4em2Usw5pwlKl7vQh169sDn1q	3
1029	Carlie	Runnett	crunnett3@opera.com	2024-09-15 23:32:26	$2a$04$4VBxD3eoANGWOqrG8zrf2e.9U/F/T5mFPMQk7joxmwmc9E/8VcePG	3
1030	Agna	Laye	alaye4@tamu.edu	2024-03-21 20:54:20	$2a$04$MlCYalNunIejRz/o0Ap.C.PgXPVagTWAmBZMZ4uHe3SyFLtvvS5XG	3
1031	Isaac	Forstall	iforstall5@bloomberg.com	2024-09-07 20:44:28	$2a$04$ajtH2LK9Xm2mox2cK9TQWeomisW8xPF4h1tFAzQRyeXybH.qiRTeq	3
1032	Neron	Brawley	nbrawley6@dion.ne.jp	2025-02-02 02:57:11	$2a$04$ZL/SH6qOEjDgHJ2G01f1ReMn.ff6pdkEQag1Lj6e.66.9EpE/v/OG	3
1033	Davie	Guiden	dguiden7@hibu.com	2025-01-10 00:30:55	$2a$04$ZbSwyrnoIXjh3M9WN/Sdd.gl0vsmTOuMC4uFI3HsP5S/fQhhYteDq	3
1034	Ladonna	Pettingill	lpettingill8@squarespace.com	2024-08-26 00:28:07	$2a$04$cPJWfrQfzooWvCTsjLMCEeTMBr2tpgn7jE0zvgFboIITkGw9cNpv6	3
1035	Andrea	Beccero	abeccero9@furl.net	2024-03-20 00:36:45	$2a$04$m2xLY6QfVBUXmr7l2logxOeO0fiVuuv430a2hrgTvIUxbgtY6Tlti	3
1036	Gregor	Brech	gbrecha@howstuffworks.com	2024-08-31 15:05:07	$2a$04$YdRICDv8Frk/S9VQoojE.Oxo0Lm.gysDpHDssxqR9eFf4SH/1XWxO	3
1037	Karie	Jannequin	kjannequinb@google.com.hk	2024-08-23 03:27:01	$2a$04$lV8ppOk1JNYZjPOR28x4rOziMZdaP842ZyodFpeKoQctbnJBozfc2	3
1038	Mae	Dell Casa	mdellcasac@msu.edu	2024-12-13 19:41:20	$2a$04$vbFRzH56GCufhEfjFtWxDuMyeMVPq1NtF3p62pIzbm.vpYG6sjCcW	3
1039	Florian	Skyram	fskyramd@ovh.net	2024-10-27 01:22:38	$2a$04$7CnBaddGdK9SYADQhVfazuI87iTreUO/ZqcjESS9RefUHAzOCDgyi	3
1040	Louie	Ogbourne	logbournee@multiply.com	2024-09-24 03:16:02	$2a$04$Wmukp1da2d.SlOWyHQT8mufcYoZQUpzgftFGYbSwB0c6rjmz4TeZu	3
1041	Oberon	Matveyev	omatveyevf@barnesandnoble.com	2024-07-14 16:21:23	$2a$04$FFaWEjKZSY1Akf8FCkSmUecmxr7KOaXSFlSE1veDVyOjf1LcOYKQi	3
1042	Jolee	Cuddihy	jcuddihyg@vinaora.com	2024-07-26 23:07:25	$2a$04$ksjPIF4CE4fXOxfVpMzVQOrNAdkniQTsORIKtYGTpew7T6P3SqYHC	3
1043	Huey	Hallet	hhalleth@foxnews.com	2024-08-16 03:59:00	$2a$04$sC6JqBYW10EW.yYIY.ogU.CD/XBPAAb8nIEtgCcmDwyPkYCcdZqua	3
1044	Dennet	Meekin	dmeekini@seattletimes.com	2024-12-19 20:35:30	$2a$04$y7BhQiiG4SlKvyeBKkHRx.gh4vU1taxGrM80Mc3nuBJFPMBmLrPxa	3
1045	Dona	Candlin	dcandlinj@disqus.com	2025-02-21 00:59:48	$2a$04$XcZ23leLdp9nRfjXBrwQAuLd.imUGlLCFSK76lvsONRXZhs9T5xXq	3
1046	Kerrill	Delf	kdelfk@amazonaws.com	2024-07-03 19:49:19	$2a$04$wWJRiraQqg1fSMilD6yJ2.dWZs6Fr41TIOeqVEhGOuHAJk3hkMouq	3
1047	Shannah	Speerman	sspeermanl@mysql.com	2024-11-23 21:19:21	$2a$04$drWdmN2qpWW78JNOx4ZTW.TOaoU1s1OordV8d79LTvidHYo.S1s5u	3
1048	Shannon	Howcroft	showcroftm@apple.com	2024-08-22 22:37:41	$2a$04$sBFKvAaCP8gvIHvTPUXtpeyUIhptJR2ZpOj7o/PnNy3CL1OJ/Gf/G	3
1049	Mil	Karppi	mkarppin@biblegateway.com	2024-03-20 23:13:46	$2a$04$B/.SKfU/kZFrzC2XV80jXugIhVeSqYAx.VqZ4CRvNctFpSbXpm2tG	3
1050	Nicolais	Hagley	nhagleyo@craigslist.org	2024-04-09 06:25:49	$2a$04$7BohuP56n2TFppODXn0A2uCQUkwDfaNBmapa0E0jx.9/XzUg/2Fsy	3
1051	Vassili	Lorek	vlorekp@devhub.com	2024-07-27 01:59:39	$2a$04$o/9NmkxiYiZ4Ux9128ducerT4E75Cl8IhTd6U/gyx5mQVNquuOAHi	3
1052	Midge	Loghan	mloghanq@wordpress.com	2024-12-13 12:50:29	$2a$04$Xt7cMNRAJeobBr/6EheBc.305Sk.vu03HaA2.QsQvskcfCdJSCcB6	3
1053	Waldo	Spiby	wspibyr@live.com	2024-05-27 03:43:41	$2a$04$WgsMkPg1yMApumRuzXCMVOcjBmDaBsLDb2jOktU/FwroDfEh4.Zu.	3
1054	Ania	Spadaro	aspadaros@wsj.com	2024-11-06 10:27:58	$2a$04$c5f23GNtGdB4U8kW6AY81.cTAl8oq5i3mpOv2.AwUv1Qtpl7.WEHS	3
1055	Lucie	Shimmin	lshimmint@is.gd	2024-11-29 02:20:34	$2a$04$ReIQo1ZyK808YVEpxuKUoOAPEZl.YZJTeAJeQcaVJRYi4OyTJ2l8W	3
1056	Vitoria	Jedraszek	vjedraszeku@1und1.de	2024-03-18 17:16:20	$2a$04$8D5PzCRb65RkvBHBR9P1wu1r3e//gNIIcLyRmOutjAueVREQK2B7i	3
1057	Jeffrey	Milella	jmilellav@mtv.com	2024-12-26 23:37:31	$2a$04$0p0TLbi7Lm9yIeE0sAeT2Of2MmnrXgac7fzvA98CBxnfHeZuICb6q	3
1058	Nan	Iannuzzi	niannuzziw@nbcnews.com	2024-05-17 17:42:08	$2a$04$DFk8qCigOi2Dq3CX4xmh/e9wAMPEzAYI84FjhtR3.RUtqmqTdH4qq	3
1059	Fern	Petley	fpetleyx@aboutads.info	2024-04-08 19:32:07	$2a$04$miOtGHPw2q8U6Viil2c.FuRWGTEyUbrSSLzIgvjYqX4TWEswtYIPq	3
1060	Fidela	Leon	fleony@posterous.com	2025-02-15 15:54:15	$2a$04$YzGTK7lyD.2mT42TBjHNAe1X8T5DTlBv3z0GjtWhF7HFPpByNojPC	3
1061	Elfrida	Niesing	eniesingz@state.tx.us	2024-07-05 09:22:54	$2a$04$3ZNDM8JDm3J/D.qG6bUsvenO8YscA8tMB5v/BouIf/MrWG/o0VJou	3
1062	Nonie	Dorrins	ndorrins10@ucoz.com	2025-02-03 22:27:14	$2a$04$63oVTDfOKIX2rXO.u1CIEuVL1rI4NwKyZBMvExUNB9Liv7LPKjSYG	3
1063	Lindsey	Slyne	lslyne11@gmpg.org	2025-02-20 11:17:57	$2a$04$OC8RQrFj4oI7FuBKSSavpOBK/YKTnOoSD2OyhLWSsBmZpKCWafG4m	3
1064	Kirsteni	Kienzle	kkienzle12@intel.com	2024-06-11 04:01:59	$2a$04$hLhkcNKZhmj4jvMutFbZz.oyqfm38UPT5mMUl8fWr4SNl0SSpqcnS	3
1065	Nissie	Wiley	nwiley13@phpbb.com	2024-12-21 07:50:56	$2a$04$GJ1iPRfC5pk3E0fMBl0b2ebR7aNbKH/U5JmDBU7EQL2UiOx8ycHvq	3
1066	Ernie	Loreit	eloreit14@sun.com	2024-03-03 20:05:53	$2a$04$qL7/lYSKxSAXmhGEcdVoNOpl/3YRwndkmSN95eQ7SMtMPUB3eZiD.	3
1067	Hayden	Whal	hwhal15@si.edu	2024-04-11 20:38:06	$2a$04$/OR1RNOqBCjYD7TLOFg1fOdpshBRGeFz.j16n5SGhi5JMz.3XaUce	3
1068	Amandie	Laurant	alaurant16@so-net.ne.jp	2024-12-04 05:55:06	$2a$04$N9Z8T1iZXjJVKKYWk3JKMOO0qSYVYLT1Z3jw1/mTQUey6O77pQLi2	3
1069	Land	McBoyle	lmcboyle17@ow.ly	2024-12-13 10:12:18	$2a$04$VYcBpTt0E30dBFVKDWx5lOUSzf8UIZ883KoJItdk64oPTAPl5o/Ue	3
1070	Jewelle	Faers	jfaers18@ask.com	2024-04-17 11:59:50	$2a$04$Mi7K3SnQ7vbaWaXbNIvkwuFrvSFWvNn413StXYw4D9smoyF2Zd7ii	3
1071	Abbot	Palle	apalle19@nsw.gov.au	2024-11-04 02:08:40	$2a$04$pv3f2Amsl6h13lTfhLSuYOOO1rsguJvmPu.d.zg9B7cz/jA4jEr3e	3
1072	Magdalena	Willard	mwillard1a@ameblo.jp	2025-02-19 12:54:13	$2a$04$yiMWQmYMzAmGMUgY1mhvkOihRIqS.nZI5t/G5k5H.VAIBjYl3lS/S	3
1073	Amery	Fendlow	afendlow1b@netvibes.com	2025-01-01 06:16:02	$2a$04$s/iYhiU8Pabm1ZumgSiF7.zLbRSjMpl0zznMqpcMDwzYkRA8U.fvK	3
1074	Thibaut	Catterell	tcatterell1c@discuz.net	2024-08-24 00:46:39	$2a$04$LihEmXE8KiwFXrurp5go.OKqAm2QqLqZkR.GIoXE9A.NL0tz4lD86	3
1075	Mag	Domingues	mdomingues1d@oracle.com	2024-03-11 23:02:30	$2a$04$zKe13LJzrTagzfogUPmuLeoS1SLohwdWXcE6Gki5j5HEcwZS9p076	3
1076	Jereme	Backhouse	jbackhouse1e@baidu.com	2024-09-05 22:47:03	$2a$04$a.AIs/W5PzCr5Nr.AhyBoun6e30j4dcUZyX7J2mc.8a8voPrNjkNS	3
1077	Alano	Grundy	agrundy1f@jalbum.net	2024-09-03 05:56:58	$2a$04$aAuYIu42Y6O9eQYOR.rTQe3roh3BsnwByrIlnWvJow9IEY1oPPYaW	3
1078	Gael	Grzesiewicz	ggrzesiewicz1g@telegraph.co.uk	2024-11-07 07:14:07	$2a$04$pxSjvPGLcoeRhLY14shgbOBOBFXjKiuczjogInZ28ZqN43fkDINGS	3
1079	Ethelind	Theakston	etheakston1h@youtube.com	2025-01-02 23:33:32	$2a$04$8u5Iw9sSTCgnVKpwto6EB.H12Hz4UHgznrNwItwLkmsDQWhdbbTVW	3
1080	Dylan	Ruff	druff1i@answers.com	2025-02-14 21:51:37	$2a$04$9uzxy1oPes8uqgf.qigE/eZfTC17WVBf40jVgTmMe3KEavbvmr0oa	3
1081	Lilllie	St Leger	lstleger1j@storify.com	2024-03-26 08:01:00	$2a$04$dJPHdEdqzNhL8TPVdSSoJ.8x2hYo7HAgwjzeZESo7oH3TiJ3foqJu	3
1082	Shaina	Wingatt	swingatt1k@mashable.com	2024-10-01 04:40:36	$2a$04$xX.fouEC8rpNxwsYvQDp8uGACndXSGW0GH156SrrBFU0lWQpeYd8.	3
1083	Nicko	Bertenshaw	nbertenshaw1l@bing.com	2024-12-25 19:00:49	$2a$04$bid.RD5.RENCixM5B7lY9uvP3SYbDFi5jcJmbDL6qCBNQpHZ8lOd.	3
1084	Luella	Lambole	llambole1m@intel.com	2024-10-27 09:07:23	$2a$04$6UUr60PQuu/TobHZFfa5yuhAf8pbewSCmK6GNhWI7JPiQg0So8Ejy	3
1085	Ursuline	Shorton	ushorton1n@sfgate.com	2024-04-29 14:23:19	$2a$04$hR/ytIGm34AbgVg3bt5/Zu3sYVjx56eTv1leesWcB5D9hojSaEy5a	3
1086	Cecile	Cicconetti	ccicconetti1o@multiply.com	2024-12-23 18:48:47	$2a$04$29cXPz7O5PLnLZ4zgsdVbOI4PU5EwCKQbml4IviKCFwnW02Lah.I.	3
1087	Michale	Restall	mrestall1p@freewebs.com	2024-03-23 05:59:37	$2a$04$4atbtZz/fimLEXO8C9uqneDDDAXJQQ/dpmlQvSOQxfhTrkkzRPN6y	3
1088	Olvan	Polgreen	opolgreen1q@state.tx.us	2025-02-18 07:09:34	$2a$04$aA4ryTLkogtOho/.HIwlc.UcvsNG.FeLptmnEbMRuT4opnZHSGa7S	3
1089	Page	Butler-Bowdon	pbutlerbowdon1r@e-recht24.de	2024-08-13 07:38:22	$2a$04$En3wWg4KeJpFrjBsE5DtNevIwPpd3ORqk3cx9cMxRpdEaGLr/zq8a	3
1090	Darci	Stote	dstote1s@tinypic.com	2024-12-24 17:57:35	$2a$04$Qq0KDQ2EAKJXUB7qnxVlXutzlt3lozLu9YnH0tilA2kg5BVQGL4fq	3
1091	Prudence	Tomkys	ptomkys1t@house.gov	2024-11-20 08:51:05	$2a$04$efXHXWnv5.2vF4XWYw7ryuRkGeO9ilaj/isBMhoyHLeRYIcMTTRyO	3
1092	Marcus	Breckell	mbreckell1u@ibm.com	2024-06-12 13:31:34	$2a$04$vliKkLMWacARn5YJIcCfYOZTzCcV0W4ZxpTbPijHrinkMkEefYTzC	3
1093	Aura	Bradforth	abradforth1v@topsy.com	2024-10-15 16:26:27	$2a$04$Ve4bHPkoSmSNUkyQ9XBTJeEIEbgXrIHBmLGjh3pqW7tL3zzmgK7te	3
1094	Chas	Underwood	cunderwood1w@ibm.com	2024-09-25 16:48:49	$2a$04$MSFS6CtZJseDY0NzvJsw7.Vj.fbSKhwm.X2JF3He4FEqsauy0kNVO	3
1095	Bev	Colaton	bcolaton1x@wiley.com	2024-05-26 22:30:59	$2a$04$OXo8rYmmx.5Vhp4I4azej.dS/DLn7/9ioqo36L7YdLR4mk/PlRu.S	3
1096	Elvina	Bridges	ebridges1y@yahoo.com	2024-11-02 23:22:51	$2a$04$1RWsfVYoly8j36D1qEgPvuHVV/T2mk638Q5UGwY/2wc5uAgd6MORK	3
1097	Kilian	Schimoni	kschimoni1z@ezinearticles.com	2024-08-31 23:17:50	$2a$04$lxYU6OI07Qi0tp5BShoiEeh6TGiYPXmCS1NU1Uk07qQ420M3t3c4y	3
1098	Forrester	Geall	fgeall20@quantcast.com	2024-05-22 22:05:08	$2a$04$DGV0PwhbEZ3czfa4QOWWq.AHX8EmalIGU9ZuFzMam9vkMPaaB5lWS	3
1099	Germana	Stoop	gstoop21@oracle.com	2024-08-26 11:40:17	$2a$04$hlWSObpom3q5./gJUjaIi.VrAJW3MU7l3JwO/THScESSsNZrvcJBm	3
1100	Karalee	Scarborough	kscarborough22@marriott.com	2024-08-16 12:20:26	$2a$04$KcMKQlsUVbEXnhrecnzmcevpBbxK/ykcFBuqWz3KAzNMDcBrVvzSK	3
1101	Kelci	Mahoney	kmahoney23@tinypic.com	2024-11-19 13:36:19	$2a$04$jLkReGyRQ8iq4lcckAZmFuArMIktKxQpzuruuqkbhrTzq6ug3rLTK	3
1102	Ralina	Rattrie	rrattrie24@amazon.de	2024-11-23 15:29:14	$2a$04$54GOM3lOzO/RQkkNre9TKucPUZ2XWMyLx4Foa908ALVFI8YuBRNCS	3
1103	Derrick	Shuttle	dshuttle25@china.com.cn	2024-04-13 11:00:36	$2a$04$qzymy6hviyzGYyAR2GMjNebTC9BX01pb.HIiZUJ1wxJuvh6Mx2LAK	3
1104	Kaitlynn	Bosley	kbosley26@epa.gov	2025-02-11 02:32:33	$2a$04$IUIDf2vT4YPtt.kZVUvAeeV0xaoncXdul3seVOVttWGX7hmiLmo3.	3
1105	Jarvis	Knifton	jknifton27@rambler.ru	2024-09-23 13:48:54	$2a$04$svZtJP25XW4efJJaOmJYg..zESkaWQ.oyxEFo.tlz4jq28tWQCT1.	3
1106	Eddy	Demicoli	edemicoli28@meetup.com	2025-01-24 20:27:46	$2a$04$op2ty4wGjbbCIFxDLEjyuOX1sIzs6p5OugX4yqU2yqriVp/neI8I.	3
1107	Garrek	Romero	gromero29@google.ca	2025-02-02 15:02:32	$2a$04$eF1J15MSP.S1vkTAC4rQGODoNOt1Ql1.zbYuyAJb7pBKN5kPkxmXu	3
1108	Consuelo	Huyge	chuyge2a@wunderground.com	2024-03-13 21:00:01	$2a$04$gglDEep9a5aWWlU2YjpDtuRWyG4e0i9i1LQehVPtzkkhnyWmqSJvC	3
1109	Ramona	Rudgerd	rrudgerd2b@shop-pro.jp	2024-06-04 16:59:13	$2a$04$08eEsJnzVJX.6UGbvzz0d.gpXArN8SusBnAgBwsCRq.t4mutbzO16	3
1110	Dorise	Scotts	dscotts2c@ibm.com	2024-03-16 04:18:54	$2a$04$6zNcJSvepxsNYccgQISwA.m3w1dBm/J37r7A/Mkk6UsQ9Gg5aeIcu	3
1111	Trude	Haccleton	thaccleton2d@networkadvertising.org	2025-02-02 21:59:28	$2a$04$I6jN6Yh/25JS6zNn4PNy0.n1UnugndJxP6S0NGfKV/RcefSw8IUpi	3
1112	Ola	Sighard	osighard2e@naver.com	2024-03-14 20:40:17	$2a$04$G3HOy1.puaH8FSc.ArwmoOf6faxkcKT1PVgH.Qh5gfC9QxeWt3Upi	3
1113	Eal	Crumpton	ecrumpton2f@dailymail.co.uk	2024-10-31 18:48:46	$2a$04$p8nm12IyuY09rWEd6vdKDeiKQ2RlxOqMpNzV1Lw1Z97x8JPMy5CEW	3
1114	Denver	Seefeldt	dseefeldt2g@prweb.com	2024-12-18 12:10:24	$2a$04$3SdE5uo717hGJAykvlzLAeeKeP4sWXigat4JzQE/DaJJ/ws8ypPCa	3
1115	Gloriana	Allkins	gallkins2h@sina.com.cn	2024-04-28 19:58:04	$2a$04$i.APssqjLo3GnGqz992IYewSSZ6gd1kH3X7UYpPCQW49uUYv/DqU6	3
1116	Viv	Scyone	vscyone2i@wiley.com	2024-05-28 06:04:02	$2a$04$3ZFzPlNXuzgzvP6P20VmH.crtM/HyFbs8uRSLBe.jteTwu3JFQjrC	3
1117	Maynord	Print	mprint2j@wiley.com	2024-04-23 08:54:36	$2a$04$jF/GLiPlVbqBHCLH9atwN.3tjdwgONO/YzTGnj2rpSg4.0x5CclgW	3
1118	Nessie	Edgeller	nedgeller2k@newyorker.com	2024-05-09 06:40:16	$2a$04$UK4MB9UnHEuR4QFRIlLj.u8VEakARVaO/Ybl87.dmgiU8r4y6JAfK	3
1119	Paige	Legate	plegate2l@usnews.com	2024-05-06 08:38:30	$2a$04$2yFK.QWnFclRWVNqUQlF.ObnZh/Vw.Bd5/CSQi4xPd9iP3HBjll9y	3
1120	Karon	Doree	kdoree2m@cam.ac.uk	2024-07-22 21:55:09	$2a$04$QFxxIuHrd/SKEXGNFCEiVO3ih93gcKOZCr5zBIo4HDP55S3.z/uKW	3
1121	Fenelia	Reardon	freardon2n@census.gov	2024-06-13 00:38:04	$2a$04$mHirko2EyahQzLymFKI2kO3wHRyuCqSHGkO/2HaLkBbQOW2yJ/yB6	3
1122	Millard	Etoile	metoile2o@google.cn	2024-12-27 01:31:27	$2a$04$7KNnV0FdLmtdNZ6DDSmS3OBVU9vNu8hZyg2PGUmh/5unfXHjOjvqy	3
1123	Alexandrina	Stanes	astanes2p@barnesandnoble.com	2024-11-19 20:30:05	$2a$04$Cdg4oK4EBp5AQ.n4Lyeo2ewInxQBz70OGE4xb65scHeQRc3WUGQ5q	3
1124	Bartholomeo	Dobbyn	bdobbyn2q@wsj.com	2024-07-19 02:30:52	$2a$04$4WZiie4/QzRoPRpeveAZueVQXnZfAZa1JQ/emUtiSBJwIYCE2QRFy	3
1125	Gram	Dorcey	gdorcey2r@virginia.edu	2024-10-15 12:46:24	$2a$04$MBjujZKcbWqxhiSMf.E0QO/.I6LQnDQy4v4Q6f8xoTU3GViyTPMWC	3
\.


--
-- Name: badges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.badges_id_seq', 4, true);


--
-- Name: content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.content_id_seq', 210, true);


--
-- Name: content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.content_type_id_seq', 5, true);


--
-- Name: course_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.course_category_id_seq', 4, true);


--
-- Name: course_level_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.course_level_id_seq', 3, true);


--
-- Name: course_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.course_status_id_seq', 2, true);


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.courses_id_seq', 11, true);


--
-- Name: evaluations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.evaluations_id_seq', 35, true);


--
-- Name: lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.lessons_id_seq', 70, true);


--
-- Name: modules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.modules_id_seq', 35, true);


--
-- Name: specialties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.specialties_id_seq', 6, true);


--
-- Name: user_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.user_types_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egilmore
--

SELECT pg_catalog.setval('public.users_id_seq', 1125, true);


--
-- Name: badges badges_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_pkey PRIMARY KEY (id);


--
-- Name: content_lessons content_lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.content_lessons
    ADD CONSTRAINT content_lessons_pkey PRIMARY KEY (id_content, id_lesson);


--
-- Name: content content_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_pkey PRIMARY KEY (id);


--
-- Name: content_type content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.content_type
    ADD CONSTRAINT content_type_pkey PRIMARY KEY (id);


--
-- Name: content content_url_key; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_url_key UNIQUE (url);


--
-- Name: course_category course_category_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.course_category
    ADD CONSTRAINT course_category_pkey PRIMARY KEY (id);


--
-- Name: course_level course_level_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.course_level
    ADD CONSTRAINT course_level_pkey PRIMARY KEY (id);


--
-- Name: course_status course_status_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.course_status
    ADD CONSTRAINT course_status_pkey PRIMARY KEY (id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: evaluations evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_pkey PRIMARY KEY (id);


--
-- Name: instructors_courses instructors_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.instructors_courses
    ADD CONSTRAINT instructors_courses_pkey PRIMARY KEY (id_instructor, id_course);


--
-- Name: instructors instructors_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT instructors_pkey PRIMARY KEY (id);


--
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);


--
-- Name: specialties specialties_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.specialties
    ADD CONSTRAINT specialties_pkey PRIMARY KEY (id);


--
-- Name: students_courses students_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_courses
    ADD CONSTRAINT students_courses_pkey PRIMARY KEY (id_student, id_course);


--
-- Name: students_evaluations students_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_evaluations
    ADD CONSTRAINT students_evaluations_pkey PRIMARY KEY (id_student, id_evaluation);


--
-- Name: students_lessons students_lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_lessons
    ADD CONSTRAINT students_lessons_pkey PRIMARY KEY (id_student, id_lesson);


--
-- Name: students_modules students_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_modules
    ADD CONSTRAINT students_modules_pkey PRIMARY KEY (id_student, id_module);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: user_types user_types_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.user_types
    ADD CONSTRAINT user_types_pkey PRIMARY KEY (id);


--
-- Name: users users_mail_key; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_mail_key UNIQUE (mail);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_course; Type: INDEX; Schema: public; Owner: egilmore
--

CREATE INDEX idx_course ON public.courses USING btree (name);


--
-- Name: idx_u_type; Type: INDEX; Schema: public; Owner: egilmore
--

CREATE INDEX idx_u_type ON public.user_types USING btree (type);


--
-- Name: idx_user_type; Type: INDEX; Schema: public; Owner: egilmore
--

CREATE INDEX idx_user_type ON public.user_types USING btree (type);


--
-- Name: students_courses inscripcion_estudiante; Type: TRIGGER; Schema: public; Owner: egilmore
--

CREATE TRIGGER inscripcion_estudiante AFTER INSERT ON public.students_courses FOR EACH ROW EXECUTE FUNCTION public.inscripcion_estudiante();


--
-- Name: content_lessons content_lessons_id_content_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.content_lessons
    ADD CONSTRAINT content_lessons_id_content_fkey FOREIGN KEY (id_content) REFERENCES public.content(id);


--
-- Name: content_lessons content_lessons_id_lesson_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.content_lessons
    ADD CONSTRAINT content_lessons_id_lesson_fkey FOREIGN KEY (id_lesson) REFERENCES public.lessons(id);


--
-- Name: content content_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_type_fkey FOREIGN KEY (type) REFERENCES public.content_type(id);


--
-- Name: courses courses_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_category_fkey FOREIGN KEY (category) REFERENCES public.course_category(id);


--
-- Name: courses courses_level_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_level_fkey FOREIGN KEY (level) REFERENCES public.course_level(id);


--
-- Name: courses courses_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_status_fkey FOREIGN KEY (status) REFERENCES public.course_status(id);


--
-- Name: evaluations evaluations_id_module_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_id_module_fkey FOREIGN KEY (id_module) REFERENCES public.modules(id);


--
-- Name: instructors instructors_badge_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT instructors_badge_fkey FOREIGN KEY (badge) REFERENCES public.badges(id);


--
-- Name: instructors_courses instructors_courses_id_course_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.instructors_courses
    ADD CONSTRAINT instructors_courses_id_course_fkey FOREIGN KEY (id_course) REFERENCES public.courses(id);


--
-- Name: instructors_courses instructors_courses_id_instructor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.instructors_courses
    ADD CONSTRAINT instructors_courses_id_instructor_fkey FOREIGN KEY (id_instructor) REFERENCES public.instructors(id);


--
-- Name: instructors instructors_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT instructors_id_fkey FOREIGN KEY (id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: instructors instructors_specialty_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT instructors_specialty_fkey FOREIGN KEY (specialty) REFERENCES public.specialties(id);


--
-- Name: lessons lessons_id_module_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_id_module_fkey FOREIGN KEY (id_module) REFERENCES public.modules(id);


--
-- Name: modules modules_id_course_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_id_course_fkey FOREIGN KEY (id_course) REFERENCES public.courses(id);


--
-- Name: students students_badge_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_badge_fkey FOREIGN KEY (badge) REFERENCES public.badges(id);


--
-- Name: students_courses students_courses_id_course_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_courses
    ADD CONSTRAINT students_courses_id_course_fkey FOREIGN KEY (id_course) REFERENCES public.courses(id);


--
-- Name: students_courses students_courses_id_student_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_courses
    ADD CONSTRAINT students_courses_id_student_fkey FOREIGN KEY (id_student) REFERENCES public.students(id);


--
-- Name: students_evaluations students_evaluations_id_evaluation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_evaluations
    ADD CONSTRAINT students_evaluations_id_evaluation_fkey FOREIGN KEY (id_evaluation) REFERENCES public.evaluations(id);


--
-- Name: students_evaluations students_evaluations_id_student_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_evaluations
    ADD CONSTRAINT students_evaluations_id_student_fkey FOREIGN KEY (id_student) REFERENCES public.students(id);


--
-- Name: students students_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_id_fkey FOREIGN KEY (id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: students_lessons students_lessons_id_lesson_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_lessons
    ADD CONSTRAINT students_lessons_id_lesson_fkey FOREIGN KEY (id_lesson) REFERENCES public.lessons(id);


--
-- Name: students_lessons students_lessons_id_student_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_lessons
    ADD CONSTRAINT students_lessons_id_student_fkey FOREIGN KEY (id_student) REFERENCES public.students(id);


--
-- Name: students_modules students_modules_id_module_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_modules
    ADD CONSTRAINT students_modules_id_module_fkey FOREIGN KEY (id_module) REFERENCES public.modules(id);


--
-- Name: students_modules students_modules_id_student_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.students_modules
    ADD CONSTRAINT students_modules_id_student_fkey FOREIGN KEY (id_student) REFERENCES public.students(id);


--
-- Name: users users_user_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: egilmore
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_user_type_fkey FOREIGN KEY (user_type) REFERENCES public.user_types(id);


--
-- PostgreSQL database dump complete
--

