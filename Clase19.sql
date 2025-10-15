USE sakila;

# === Practice Exercise: Managing User Privileges in MySQL ===

/*
Steps:
1. Create a user named report_user.
2. Grant SELECT, UPDATE, and DELETE permissions on all sakila tables.
3. Login as report_user and attempt to create a table.
4. Update the title of a movie.
5. Revoke the UPDATE privilege.
6. Try the same update again and check the result.
*/


# 1) Create a new user called report_user
CREATE USER 'report_user'@'%'
IDENTIFIED BY 'dataPass!23';


# 2) Grant specific permissions to this user
GRANT SELECT, UPDATE, DELETE 
ON sakila.* 
TO 'report_user'@'%';


# 3) (After logging in as report_user)
# Try creating a new table – this should fail
CREATE TABLE test_permissions (
  name VARCHAR(50),
  created_at DATETIME
);

-- Expected output:
-- ERROR 1142 (42000): CREATE command denied to user 'report_user'@'localhost' for table 'test_permissions'


# 4) Attempt to modify an existing movie title
UPDATE film
SET title = 'ANALYST ADVENTURE'
WHERE title = 'ACADEMY DINOSAUR';

-- Expected output:
-- Query OK, 1 row affected


# 5) Revoke the UPDATE permission using an admin account
REVOKE UPDATE 
ON sakila.* 
FROM 'report_user'@'%';


# 6) Log back in as report_user and retry the same update
UPDATE film
SET title = 'ACADEMY DINOSAUR'
WHERE title = 'ANALYST ADVENTURE';

-- Expected output:
-- ERROR 1142 (42000): UPDATE command denied to user 'report_user'@'localhost' for table 'film'