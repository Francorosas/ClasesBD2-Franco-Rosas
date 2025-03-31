#Ejercicio 1
select title, special_features from film where rating = 'PG-13';

#Ejercicio 2
select distinct length from film;

#Ejercicio 3
select title, rental_rate, replacement_cost from film where replacement_cost between 20.00 and 24.00;

#Ejercicio 4
select f.title, c.name as category, f.rating 
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where f.special_features like '%Behind the Scenes%';

#Ejercicio 5
select a.first_name, a.last_name 
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
where f.title = 'ZOOLANDER FICTION';

#Ejercicio 6
select a.address, c.city, co.country 
from store s
join address a on s.address_id = a.address_id
join city c on a.city_id = c.city_id
join country co on c.country_id = co.country_id
where s.store_id = 1;

#Ejercicio 7
select f1.title as film1, f2.title as film2, f1.rating 
from film f1
join film f2 on f1.rating = f2.rating and f1.film_id < f2.film_id;

#Ejercicio 8
select f.title, s.store_id, st.first_name, st.last_name 
from inventory i
join film f on i.film_id = f.film_id
join store s on i.store_id = s.store_id
join staff st on s.manager_staff_id = st.staff_id
where s.store_id = 2;
