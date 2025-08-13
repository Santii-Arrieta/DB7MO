USE Sakila;

-- 1. Find all the film titles that are not in the inventory

SELECT f.title
FROM film f
WHERE f.film_id NOT IN (
    SELECT DISTINCT i.film_id
    FROM inventory i
);

-- 2. Find all the films that are in the inventory but were never rented

SELECT f.title, i.inventory_id
FROM inventory i
JOIN film f ON i.film_id = f.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

-- 3. Generate a report

SELECT 
    c.first_name,
    c.last_name,
    c.store_id,
    f.title,
    r.rental_date,
    r.return_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY c.store_id, c.last_name;

-- 4. Show sales per store (money from rented films)

SELECT 
    s.store_id,
    CONCAT(ci.city, ', ', co.country) AS location,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    SUM(p.amount) AS total_sales
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
JOIN staff m ON s.manager_staff_id = m.staff_id
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY s.store_id, location, manager_name;

-- 5. Which actor has appeared in the most films?

SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;
