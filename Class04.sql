-- #Ejercicio numero 4 Santiago Oviedo Arrieta
USE sakila;

-- #EJ 1: Consulta sobre películas con clasificación PG-13
SELECT title, special_features 
FROM film 
WHERE rating LIKE 'PG-13';

-- #EJ 2: Obtención de la duración del alquiler de todas las películas
SELECT rental_duration 
FROM film;

-- #EJ 3: Películas con costos de reemplazo entre $20.00 y $24.00
SELECT title, rental_rate, replacement_cost 
FROM film 
WHERE replacement_cost BETWEEN 20.00 AND 24.00;

-- #EJ 4: Películas que incluyen 'Behind the Scenes' y su categoría
SELECT film.title, category.name, film.rating 
FROM film_category
INNER JOIN film ON film_category.film_id = film.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE special_features LIKE 'Behind the Scenes';

-- #EJ 5: Búsqueda de actores que participaron en 'ZOOLANDER FICTION'
SELECT first_name, last_name 
FROM film_actor
INNER JOIN film ON film_actor.film_id = film.film_id
INNER JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE title LIKE 'ZOOLANDER FICTION';

-- #CEJ 6: onsulta de ciudad y país según una dirección específica
SELECT city, country 
FROM address
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE address_id = 1;

-- #EJ 7: Consulta sobre películas con rating existente en la base de datos
SELECT title, rating 
FROM film
WHERE rating IN (SELECT DISTINCT rating FROM film);

-- #EJ 8: Películas y sus gerentes de tienda correspondientes
SELECT film.title, staff.first_name, staff.last_name 
FROM inventory
INNER JOIN film ON inventory.film_id = film.film_id
INNER JOIN store ON inventory.store_id = store.store_id
INNER JOIN staff ON store.manager_staff_id = staff.staff_id
WHERE film.film_id = 2;
