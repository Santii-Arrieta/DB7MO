use sakila;

-- #1: List all the actors that share the last name. Show them in order
select first_name, last_name
from actor
where last_name in (
    select last_name
    from actor
    group by last_name
    having count(*) > 1  -- Busca apellidos repetidos
)
order by last_name, first_name;  -- Orden alfabético por apellido y nombre

-- #2: Find actors that don't work in any film
select first_name, last_name from actor
where actor_id not in (select actor_id from film_actor);  -- Filtra actores sin registros en film_actor

-- #3: Find customers that rented only one film
select c.first_name, c.last_name, f.title
from customer c
inner join rental r on c.customer_id = r.customer_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
where c.customer_id in (
    select r.customer_id
    from rental r
    inner join inventory i on r.inventory_id = i.inventory_id
    group by r.customer_id
    having count(distinct i.film_id) = 1  -- Clientes que alquilaron solo una película distinta
);

-- #4: Find customers that rented more than one film
select c.first_name, c.last_name, f.title
from customer c
inner join rental r on c.customer_id = r.customer_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
where c.customer_id in (
    select r.customer_id from rental r
    inner join inventory i on r.inventory_id = i.inventory_id
    group by r.customer_id
    having count(distinct i.film_id) > 1  -- Clientes que alquilaron más de una película
);

-- #5: List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
select distinct a.first_name, a.last_name from film_actor fa
inner join actor a on fa.actor_id = a.actor_id
inner join film f on fa.film_id = f.film_id
where a.actor_id in (
	select fa.actor_id from film_actor fa 
	inner join actor a on fa.actor_id = a.actor_id
	inner join film f on fa.film_id = f.film_id
	where f.title like 'BETRAYED REAR' or 'CATCH AMISTAD'  -- Participaron en una de las dos películas
);

-- #6: List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
select distinct a.first_name, a.last_name from film_actor fa
inner join actor a on fa.actor_id = a.actor_id
inner join film f on fa.film_id = f.film_id
where a.actor_id in (
	select fa.actor_id from film_actor fa 
	inner join actor a on fa.actor_id = a.actor_id
	inner join film f on fa.film_id = f.film_id
	where f.title like 'BETRAYED REAR' and f.title not like 'CATCH AMISTAD'  -- Solo en 'BETRAYED REAR'
);

-- #7: List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
select distinct a.first_name, a.last_name from film_actor fa
inner join actor a on fa.actor_id = a.actor_id
inner join film f on fa.film_id = f.film_id
where a.actor_id in (
	select fa.actor_id from film_actor fa 
	inner join actor a on fa.actor_id = a.actor_id
	inner join film f on fa.film_id = f.film_id
	where f.title like 'BETRAYED REAR' and f.title like 'CATCH AMISTAD'  -- Participaron en ambas
);

-- #8: List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
select distinct a.first_name, a.last_name from film_actor fa
inner join actor a on fa.actor_id = a.actor_id
inner join film f on fa.film_id = f.film_id
where a.actor_id not in (
	select fa.actor_id from film_actor fa 
	inner join actor a on fa.actor_id = a.actor_id
	inner join film f on fa.film_id = f.film_id
	where f.title like 'BETRAYED REAR' or 'CATCH AMISTAD'  -- Excluye los actores que trabajaron en esas películas
);
