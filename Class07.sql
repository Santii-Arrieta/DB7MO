USE sakila;

-- 1. Find the films with less duration, show the title and rating.

SELECT title, rating
FROM film
WHERE length = (SELECT MIN(length) FROM film WHERE length IS NOT NULL);

-- 2. Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.

SELECT f.title
FROM film f
WHERE f.length = (SELECT MIN(length) FROM film)
  AND (
      SELECT COUNT(*) 
      FROM film 
      WHERE length = f.length
  ) = 1;

-- 3. Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    p.amount AS lowest_payment
FROM 
    customer c
INNER JOIN 
    address a ON a.address_id = c.address_id
INNER JOIN 
    payment p ON p.customer_id = c.customer_id
WHERE 
    p.amount = (
        SELECT MIN(amount)
        FROM payment
        WHERE customer_id = c.customer_id
    )
ORDER BY 
    c.customer_id;

-- 4. Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    pm.min_amount AS lowest_payment,
    pm.max_amount AS highest_payment
FROM 
    customer c
JOIN 
    address a ON a.address_id = c.address_id
JOIN (
    SELECT 
        customer_id,
        MIN(amount) AS min_amount,
        MAX(amount) AS max_amount
    FROM 
        payment
    GROUP BY 
        customer_id
) pm ON pm.customer_id = c.customer_id
ORDER BY 
    c.customer_id;
