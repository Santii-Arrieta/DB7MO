use sakila;

# Point number 1
SELECT 
    CONCAT_WS(' ', cust.first_name, cust.last_name) AS full_name,
    addr.address,
    city.city
FROM country AS country 
INNER JOIN city AS city 
    ON country.country_id = city.country_id
INNER JOIN address AS addr 
    ON city.city_id = addr.city_id
INNER JOIN customer AS cust 
    ON addr.address_id = cust.address_id
WHERE country.country = 'Argentina';

# Point number 2
SELECT 
    f.title,
    lang.name AS language,
    CASE f.rating
        WHEN 'G'      THEN 'General Audiences – All ages admitted'
        WHEN 'PG'     THEN 'Parental Guidance Suggested – Some material may not be suitable for children'
        WHEN 'PG-13'  THEN 'Parents Strongly Cautioned – Some material may be inappropriate for children under 13'
        WHEN 'R'      THEN 'Restricted – Under 17 requires accompanying parent or adult guardian'
        WHEN 'NC-17'  THEN 'Adults Only – No one 17 and under admitted'
        ELSE 'Not Rated'
    END AS rating_full
FROM film AS f
LEFT JOIN language AS lang
    ON f.language_id = lang.language_id;

# Point number 3

SET @input_actor = 'Will Smith';

SELECT 
    f.title,
    f.release_year
FROM actor AS a
INNER JOIN film_actor AS fa 
    ON a.actor_id = fa.actor_id
INNER JOIN film AS f 
    ON fa.film_id = f.film_id
WHERE UPPER(CONCAT_WS(' ', a.first_name, a.last_name)) 
      LIKE CONCAT('%', UPPER(TRIM(@input_actor)), '%');

# Point number 4
SELECT 
    f.title,
    CONCAT_WS(' ', c.first_name, c.last_name) AS customer_name,
    IF(r.return_date IS NULL, 'No', 'Yes') AS returned
FROM rental AS r
JOIN inventory AS i 
    ON r.inventory_id = i.inventory_id
JOIN film AS f 
    ON i.film_id = f.film_id
JOIN customer AS c 
    ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) BETWEEN 5 AND 6;


# Point number 5

-- CAST example: convert date to string
SELECT CAST(rental_date AS CHAR) AS rental_str
FROM rental
LIMIT 5;

-- CONVERT example: same conversion
SELECT CONVERT(rental_date, CHAR) AS rental_str
FROM rental
LIMIT 5;


# Point number 6

SELECT 
    CONCAT_WS(' ', c.first_name, c.last_name) AS name,
    IFNULL(a.phone, 'No phone') AS phone_number
FROM customer AS c
JOIN address AS a 
    ON c.address_id = a.address_id;
