
USE sakila;

/* Ejercicios: queries y medición de índices y FULLTEXT */




-- --------------------------------------------------------------------------------------
-- 1) Address table queries

SET profiling = 1;


-- ANTES DEL ÍNDICE
SELECT a.address, a.postal_code, c.city, co.country
FROM address a
INNER JOIN city c USING(city_id)
INNER JOIN country co USING(country_id)
WHERE a.postal_code IN ('35200', '17886', '83579', '53561', '42399');


SELECT * FROM address a
WHERE a.postal_code NOT IN ('35200', '17886');

SHOW PROFILES;

-- Crear índice
CREATE INDEX idx_address_postal_code ON address(postal_code);



-- DESPUÉS DEL ÍNDICE
SELECT a.address, a.postal_code, c.city, co.country
FROM address a
INNER JOIN city c USING(city_id)
INNER JOIN country co USING(country_id)
WHERE a.postal_code IN ('35200', '17886', '83579', '53561', '42399');

SHOW PROFILES;

-- Resultado: la consulta con índice es más rápida.


-- --------------------------------------------------------------------------------------
-- 2) Actor table searches

SELECT * FROM actor a
WHERE a.first_name LIKE 'PENELOPE%';



SELECT * FROM actor a
WHERE a.last_name LIKE '%NESS';

SHOW PROFILES;

-- Resultado: índices funcionan con patrones anclados a la izquierda.




-- --------------------------------------------------------------------------------------
-- 3) Film description search LIKE vs FULLTEXT



SELECT film_id, title, description
FROM film
WHERE description LIKE '%Action%';

ALTER TABLE film ADD FULLTEXT idx_film_desc (description);



SELECT film_id, title, description, MATCH(description) AGAINST('Action') AS score
FROM film
WHERE MATCH(description) AGAINST('Action');


SHOW PROFILES;

-- Resultado: FULLTEXT mucho más rápido que LIKE para búsquedas de palabras.
