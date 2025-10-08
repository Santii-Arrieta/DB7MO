USE sakila;

-- --------------------------------------------------------
-- 1) Function: count_copies_in_store
-- --------------------------------------------------------

DELIMITER $$

CREATE FUNCTION count_copies_in_store(
    film_input VARCHAR(100),
    store_input INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE film_code INT;
    DECLARE total_copies INT;

    -- Check if film_input is numeric (film_id) or a title
    IF film_input REGEXP '^[0-9]+$' THEN
        SET film_code = CAST(film_input AS UNSIGNED);
    ELSE
        SELECT film_id INTO film_code
        FROM film
        WHERE title = film_input
        LIMIT 1;
    END IF;

    -- Count copies for that film in the selected store
    SELECT COUNT(*) INTO total_copies
    FROM inventory
    WHERE film_id = film_code
      AND store_id = store_input;

    RETURN total_copies;
END $$

DELIMITER ;


-- --------------------------------------------------------
-- 2) Procedure: list_customers_by_country
-- --------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE list_customers_by_country(
    IN country_name VARCHAR(50),
    OUT customers_list TEXT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE fname VARCHAR(45);
    DECLARE lname VARCHAR(45);

    DECLARE cur CURSOR FOR
        SELECT c.first_name, c.last_name
        FROM customer c
        INNER JOIN address a ON c.address_id = a.address_id
        INNER JOIN city ci ON a.city_id = ci.city_id
        INNER JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = country_name;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SET customers_list = '';

    OPEN cur;
    loop_customers: LOOP
        FETCH cur INTO fname, lname;
        IF done THEN
            LEAVE loop_customers;
        END IF;

        SET customers_list = CONCAT_WS('; ', customers_list, CONCAT(fname, ' ', lname));
    END LOOP;
    CLOSE cur;
END $$

DELIMITER ;


-- --------------------------------------------------------
-- 3) Review + Examples: inventory_in_stock and film_in_stock
-- --------------------------------------------------------

-- Function inventory_in_stock checks if a specific inventory item is currently available.
-- It returns TRUE if it was never rented or all rentals were returned.

DELIMITER $$

CREATE FUNCTION inventory_in_stock(p_inv_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE total_rentals INT;
    DECLARE active_rentals INT;

    SELECT COUNT(*) INTO total_rentals
    FROM rental
    WHERE inventory_id = p_inv_id;

    SELECT COUNT(*) INTO active_rentals
    FROM rental
    WHERE inventory_id = p_inv_id
      AND return_date IS NULL;

    IF total_rentals = 0 THEN
        RETURN TRUE;
    ELSEIF active_rentals > 0 THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END $$

DELIMITER ;


-- Procedure film_in_stock counts available copies in a specific store using the function above.

DELIMITER $$

CREATE PROCEDURE film_in_stock(
    IN film_code INT,
    IN store_code INT,
    OUT available_count INT
)
READS SQL DATA
BEGIN
    SELECT COUNT(*) INTO available_count
    FROM inventory
    WHERE film_id = film_code
      AND store_id = store_code
      AND inventory_in_stock(inventory_id) = TRUE;
END $$

DELIMITER ;


-- --------------------------------------------------------
-- Examples of usage
-- --------------------------------------------------------

-- Example 1: Function
SELECT count_copies_in_store('ACADEMY DINOSAUR', 1);

-- Example 2: Procedure
CALL list_customers_by_country('Canada', @names);
SELECT @names;

-- Example 3: film_in_stock
CALL film_in_stock(1, 1, @stock);
SELECT @stock;