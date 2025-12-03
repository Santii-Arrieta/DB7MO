USE sakila ;


-- 1) get the amount of cities per country ordered by country and country_id
SELECT co.country_id ,
       co.country ,
       COUNT(ci.city_id) AS total_cities
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country_id , co.country
ORDER BY co.country , co.country_id ;


-- 2) get countries with more than 10 cities ordered from highest to lowest
SELECT co.country ,
       COUNT(ci.city_id) AS total_cities
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country
HAVING COUNT(ci.city_id) > 10
ORDER BY total_cities DESC ;



-- 3) customer report with total rentals and total money spent
SELECT cu.first_name ,
       cu.last_name ,
       ad.address ,
       COUNT(r.rental_id) AS total_films ,
       SUM(p.amount) AS total_spent
FROM customer cu
JOIN address ad ON cu.address_id = ad.address_id
LEFT JOIN rental r ON cu.customer_id = r.customer_id
LEFT JOIN payment p ON cu.customer_id = p.customer_id
GROUP BY cu.customer_id ,
         cu.first_name ,
         cu.last_name ,
         ad.address
ORDER BY total_spent DESC ;



-- 4) film categories with highest average duration
SELECT ca.name AS category ,
       AVG(f.length) AS avg_duration
FROM category ca
JOIN film_category fc ON ca.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY ca.name
ORDER BY avg_duration DESC ;



-- 5) total sales per film rating
SELECT f.rating ,
       COUNT(p.payment_id) AS total_sales ,
       SUM(p.amount) AS total_income
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY total_income DESC ;
