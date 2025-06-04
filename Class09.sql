select co.country_id, co.country, count(ci.city_id) as cantidad_ciudades from country co
join city ci on co.country_id = ci.country_id
group by co.country_id, co.country
order by co.country, co.country_id;


select co.country_id, co.country, count(ci.city_id) as cantidad_ciudades from country co
join city ci on co.country_id = ci.country_id
group by co.country_id, co.country
having count(ci.city_id) > 10
order by cantidad_ciudades desc;


select cu.first_name, cu.last_name, a.address, count(r.rental_id) as total_alquileres, sum(p.amount) as total_gastado from customer cu
join address a on cu.address_id = a.address_id
join rental r on cu.customer_id = r.customer_id
join payment p on r.rental_id = p.rental_id
group by cu.customer_id, cu.first_name, cu.last_name, a.address
order by total_gastado desc;


select c.name as categoria, avg(f.length) as duracion_promedio from category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
group by c.name
order by duracion_promedio desc;


select f.rating, sum(p.amount) as total_ventas from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by f.rating
order by total_ventas desc;
