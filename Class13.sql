USE sakila ;


-- 1) add new customer (store 1 + last address from united states)
INSERT INTO customer ( store_id , first_name , last_name , email , address_id , active )
VALUES
(1 ,'RICARDO' ,'FERREYRA' ,'RICARDO.F@mail.com' ,(
    SELECT a.address_id
    FROM address a
    JOIN city c ON a.city_id = c.city_id
    JOIN country co ON c.country_id = co.country_id
    WHERE co.country = 'UNITED STATES'
    ORDER BY a.address_id DESC
    LIMIT 1
  ) ,1) ;



-- 2) add rental using film title + highest inventory + staff from store 2
INSERT INTO rental ( rental_date , inventory_id , customer_id , staff_id )
VALUES
(NOW() ,(
    SELECT inventory_id
    FROM inventory
    WHERE film_id =
    (
      SELECT film_id
      FROM film
      WHERE title = 'ACADEMY DINOSAUR'
      LIMIT 1
    )
    ORDER BY inventory_id DESC
    LIMIT 1
  ) ,(
    SELECT customer_id
    FROM customer
    ORDER BY customer_id DESC
    LIMIT 1
  ) ,( SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1 )) ;



-- 3) update film year based on rating
UPDATE film SET release_year = 2001 WHERE rating = 'G' ;
UPDATE film SET release_year = 2003 WHERE rating = 'PG' ;
UPDATE film SET release_year = 2005 WHERE rating = 'PG-13' ;
UPDATE film SET release_year = 2007 WHERE rating = 'R' ;
UPDATE film SET release_year = 2009 WHERE rating = 'NC-17' ;



-- 4) return latest non-returned rental
UPDATE rental
SET return_date = NOW()
WHERE rental_id =
(
  SELECT rental_id
  FROM rental
  WHERE return_date IS NULL
  ORDER BY rental_date DESC
  LIMIT 1
) ;



-- 5) delete a film completely
DELETE FROM payment
WHERE rental_id IN
(
  SELECT r.rental_id
  FROM rental r
  JOIN inventory i ON r.inventory_id = i.inventory_id
  WHERE i.film_id =
  (
    SELECT film_id
    FROM film
    WHERE title = 'ACADEMY DINOSAUR'
    LIMIT 1
  )
) ;

DELETE FROM rental
WHERE inventory_id IN
(
  SELECT inventory_id
  FROM inventory
  WHERE film_id =
  (
    SELECT film_id
    FROM film
    WHERE title = 'ACADEMY DINOSAUR'
    LIMIT 1
  )
) ;

DELETE FROM inventory
WHERE film_id =
(
  SELECT film_id
  FROM film
  WHERE title = 'ACADEMY DINOSAUR'
  LIMIT 1
) ;

DELETE FROM film_actor
WHERE film_id =
(
  SELECT film_id
  FROM film
  WHERE title = 'ACADEMY DINOSAUR'
  LIMIT 1
) ;

DELETE FROM film_category
WHERE film_id =
(
  SELECT film_id
  FROM film
  WHERE title = 'ACADEMY DINOSAUR'
  LIMIT 1
) ;

DELETE FROM film
WHERE title = 'ACADEMY DINOSAUR' ;



-- 6) rent a film + add payment without variables (subqueries only)
INSERT INTO rental ( rental_date , inventory_id , customer_id , staff_id )
VALUES
(NOW() ,(
    SELECT i.inventory_id
    FROM inventory i
    LEFT JOIN rental r
      ON i.inventory_id = r.inventory_id
      AND r.return_date IS NULL
    WHERE r.inventory_id IS NULL
    LIMIT 1
  ) ,
  ( SELECT customer_id
    FROM customer
    ORDER BY customer_id DESC
    LIMIT 1
  ) ,
  ( SELECT staff_id
    FROM staff
    LIMIT 1
  )
) ;



INSERT INTO payment ( customer_id , staff_id , rental_id , amount , payment_date )
VALUES
(
  ( SELECT customer_id
    FROM customer
    ORDER BY customer_id DESC
    LIMIT 1
  ) ,
  ( SELECT staff_id
    FROM staff
    LIMIT 1
  ) ,
  ( SELECT rental_id
    FROM rental
    ORDER BY rental_date DESC
    LIMIT 1
  ) ,
  4.99 ,
  NOW()
) ;

