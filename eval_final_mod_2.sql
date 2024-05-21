-- EVALUACIÓN FINAL MÓDULO 2

-- Seleccionamos el esquema sobre el que vamos a realizar las consultas:
USE sakila;

-- 1.Selecciona todos los nombres de las películas sin que aparezcan duplicados.

-- Usamos la cláusula distinct para evitar los duplicados.
SELECT 
DISTINCT title
FROM film;


-- 2.Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

-- Usamos la cláusula WHERE para que nos busque un valor determinado, en este caso para seleccionar sólo las películas con clasificación "PG-13".
SELECT 
DISTINCT title
FROM film
WHERE rating = 'PG-13';

-- 3.Encuentra el título y la descripción de todas las películas que contengan la palabra
-- "amazing" en su descripción.

-- Para esta consulta podemos usar tanto la función REGEXP como la cláusula LIKE, ambas nos van a permitir hacer una búsqueda en función
-- de un patrón.

SELECT 
DISTINCT title,
description
FROM film 
WHERE description REGEXP 'amazing';

SELECT 
DISTINCT title,
description
FROM film 
WHERE description LIKE '%amazing%';

-- 4.Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

-- Primero hacemos una selección de la tabla 'film' al completo para averiguar qué columna es la que almacena la duración de las películas:
SELECT * 
FROM film;

-- Identificamos que la duración de las películas está en la columna 'length'
-- Para seleccionar las películas con duración mayor a 120, usaremos la cláusula WHERE y el operador de comparación 'mayor que' >:
SELECT 
DISTINCT title,
length
FROM film 
WHERE length > 120;


-- 5.Recupera los nombres de todos los actores.

SELECT 
first_name
FROM actor;


-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

-- Usamos la cláusula WHERE y el comparador '=' para que nos devuelva exactamente el valor que le indicamos.
SELECT 
first_name,
last_name
FROM actor
WHERE last_name = 'GIBSON';


-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

-- Para hacer una búsqueda dentro de un rango usamos la cláusula BETWEEN.
SELECT 
first_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;


-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en
-- cuanto a su clasificación.

-- Usamos la cláusula WHERE con el comparador distinto '<>' y como nos piden que no sean dos valores, añadimos el segundo valor con AND.
SELECT 
DISTINCT title,
rating
FROM film
WHERE rating <> 'R' AND rating <>'PG-13';


-- 9.Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la
-- clasificación junto con el recuento.

-- Usamos la función COUNT para hacer la suma de las películas y lo aplicamos en rating para hacer esta suma según su clasificación.
SELECT 
rating,
COUNT(rating)
FROM film
GROUP BY rating;


-- 10.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del
-- cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

-- Para esta consulta usaremos la cláusula INNER JOIN porque la información que nos piden está en dos tablas diferentes.
SELECT
c.customer_id,
first_name,
last_name,
COUNT(rental.rental_id)
FROM customer c
INNER JOIN rental
ON c.customer_id = rental.customer_id
GROUP BY customer_id, first_name, last_name;


-- 11.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de
-- la categoría junto con el recuento de alquileres
SELECT * FROM film;
SELECT
category.name,
COUNT(rental.rental_id)
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY category.name;


-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla
-- film y muestra la clasificación junto con el promedio de duración.

-- Para calcular el promedio utilizados la función AVERAGE(AVG)
SELECT
rating,
AVG(length)
FROM film
GROUP BY rating;


-- 13.Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

-- Para obtener esta información necesitamos hacer la consulta a tres tablas distintas, por lo que usaremos las subconsultas.
SELECT
first_name,
last_name
FROM actor
WHERE actor_id IN(
	SELECT 
    actor_id
    FROM film_actor
    WHERE film_id IN(
		SELECT
		film_id
		FROM film
		WHERE title = 'Indian Love'));
    
    
-- 14.Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

-- Aplicamos la función REGEXP, que nos permite hacer una búsqueda en función de un patrón. Además separamos las palabras a buscar con una barra vertical que nos indica
-- que debe buscar una u otra.
SELECT
title
FROM film
WHERE description REGEXP 'dog|cat';

-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.

-- Hacemos una subconsulta con la cláusula NOT IN para indicar que queremos que nos devuelva los resultados que no aparezcan en dicha subconsulta.
SELECT
first_name
FROM actor
WHERE actor_id NOT IN(
	SELECT
    actor_id
    FROM film_actor);


-- 16.Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010film

-- Usamos la cláusula between para establecer el rango para el que queremos hacer la consulta.
SELECT
title,
release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;


-- 17.Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT
title
FROM film
WHERE film_id IN(
	SELECT film_id
    FROM film_category
    WHERE category_id IN(
    SELECT category_id
    FROM category
    WHERE name = 'Family'));
    
    
    
-- 18.Muestra el nombre y apellido de los actores que aparecen en más de 10 películas

SELECT
first_name,
last_name
FROM actor
WHERE actor_id IN (
	SELECT 
	actor_id
	FROM film_actor
	GROUP BY actor_id
	HAVING COUNT(film_id) > 10);
    
    
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2
-- horas en la tabla film.

SELECT 
title,
rating,
length
FROM film
WHERE RATING = 'R' AND length > 120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120
-- minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT
category.name,
AVG (film.length)
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN film
ON film_category.film_id = film.film_id
GROUP BY category.name
HAVING AVG (film.length) > 120;


-- 21.Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del
-- actor junto con la cantidad de películas en las que han actuado.

SELECT
first_name,
COUNT(film_id)
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY first_name;

-- 22.Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza
-- una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego
-- selecciona las películas correspondientes.

-- Para hacer esta consulta a través de una subconsulta tendremos que añadir la función DATEDIFF:
SELECT
title
FROM film
WHERE film_id IN (
	SELECT 
    film_id
    FROM inventory
    WHERE inventory_id IN(
		SELECT
        inventory_id
        FROM rental
        WHERE DATEDIFF(rental_date, return_date)));

-- Si quisieramos que la consulta nos devolviese los id, lo haríamos usando varios INNER JOIN:
SELECT
rental.rental_id,
film.title
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id
GROUP BY film.title, rental.rental_id;

-- Por último, la forma más sencilla de hacer esta consulta sería a través de una sola tabla donde están todos los datos.
SELECT
title,
rental_duration
FROM film
WHERE rental_duration > 5;


-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de
-- la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado
-- en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT 
first_name,
last_name,
actor_id
FROM actor
WHERE actor_id NOT IN(
	SELECT
	actor_id
	FROM film_actor
	WHERE film_id IN(
		SELECT film_id
		FROM film_category
		WHERE category_id IN(
			SELECT
			category_id
			FROM category
			WHERE name = 'Horror')));


-- 24.Encuentra el título de las películas que son comedias y tienen una duración mayor
-- a 180 minutos en la tabla film.

SELECT 
title,
length
FROM film
WHERE length > 120 AND film_id IN (
	SELECT
    film_id
    FROM film_category
    WHERE category_id = (
		SELECT 
        category_id
        FROM category
        WHERE name = 'Comedy'));
