USE Sakila;
-- 1 Create a view named list_of_customers

CREATE OR REPLACE VIEW list_of_customers AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    a.address,
    a.postal_code AS zip_code,
    a.phone,
    ci.city,
    co.country,
    CASE 
        WHEN c.active = 1 THEN 'active'
        ELSE 'inactive'
    END AS status,
    c.store_id
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;


-- 2 Create a view named film_details

CREATE OR REPLACE VIEW film_details AS
SELECT 
    f.film_id,
    f.title,
    f.description,
    c.name AS category,
    f.rental_rate AS price,
    f.length,
    f.rating,
    GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) SEPARATOR ', ') AS actors
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id;

-- 3 Create view sales_by_film_category

CREATE OR REPLACE VIEW sales_by_film_category AS
SELECT 
    c.name AS category,
    SUM(p.amount) AS total_rental
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

-- 4 Create a view called actor_information where it should return

CREATE OR REPLACE VIEW actor_information AS
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;


-- 5 Analyze view actor_info

CREATE OR REPLACE VIEW actor_info AS
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(DISTINCT fa.film_id) AS film_count
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;

-- 6. Materialized Views (as comment, since not supported in MySQL)
-- Description:
-- A materialized view is a physical copy of query results stored in the DB.
-- It improves performance for heavy queries, and can be refreshed manually or automatically.
-- Alternatives: indexed views (SQL Server), caching, ETL pipelines.
-- Supported in PostgreSQL, Oracle, BigQuery, Snowflake, Redshift (not in MySQL or MariaDB).



