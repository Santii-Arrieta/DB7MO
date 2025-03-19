-- #Ej 1: Crear la base de datos imdb
DROP DATABASE IF EXISTS imdb;
CREATE DATABASE IF NOT EXISTS imdb;
USE imdb;

-- #Ej 2: Crear la tabla film
CREATE TABLE film (
    film_id INT AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year INT,
    CONSTRAINT PK_film PRIMARY KEY (film_id)
);

-- #Ej 3: Crear la tabla actor
CREATE TABLE actor (
    actor_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    CONSTRAINT PK_actor PRIMARY KEY (actor_id)
);

-- #Ej 4: Crear la tabla intermedia film_actor para la relación muchos a muchos
CREATE TABLE film_actor (
    actor_id INT,
    film_id INT,
    CONSTRAINT PK_film_actor PRIMARY KEY (actor_id, film_id)
);

-- #Ej 5: Agregar la columna last_update a film
ALTER TABLE film
ADD COLUMN last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- #Ej 6: Agregar la columna last_update a actor
ALTER TABLE actor
ADD COLUMN last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- #Ej 7: Agregar claves foráneas a film_actor
ALTER TABLE film_actor
ADD CONSTRAINT FK_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON DELETE CASCADE,
ADD CONSTRAINT FK_film_actor_film FOREIGN KEY (film_id) REFERENCES film(film_id) ON DELETE CASCADE;

-- #Ej 8: Insertar algunos actores
INSERT INTO actor (first_name, last_name) VALUES
('Tom', 'Cruise'),
('Keanu', 'Reeves'),
('Scarlett', 'Johansson'),
('Morgan', 'Freeman'),
('Emma', 'Stone');

-- #Ej 9: Insertar algunas películas
INSERT INTO film (title, description, release_year) VALUES
('Top Gun', 'Pilotos de combate en accion', 1986),
('Matrix Resurrections', 'Neo regresa a la Matrix', 2021),
('Black Widow', 'Historia de Natasha Romanoff', 2021),
('Shawshank Redemption', 'Un hombre injustamente encarcelado', 1994),
('La La Land', 'Historia de amor entre un músico y una actriz', 2016);

-- #Ej 10: Relacionar actores con películas
INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1),
(2, 2),
(3, 3), 
(4, 4), 
(5, 5), 
(1, 2), 
(3, 4), 
(2, 5); 