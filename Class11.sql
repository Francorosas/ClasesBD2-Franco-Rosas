select f.title
from film f
left join inventory i on f.film_id = i.film_id
where i.inventory_id is null;


select f.title, i.inventory_id
from inventory i
join film f on i.film_id = f.film_id
left join rental r on i.inventory_id = r.inventory_id
where r.rental_id is null;


select c.first_name, c.last_name, s.store_id, f.title, r.rental_date, r.return_date
from customer c
join store s on c.store_id = s.store_id
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
order by s.store_id, c.last_name;


select concat(ci.city, ', ', co.country) as location,
       concat(m.first_name, ' ', m.last_name) as manager_name,
       sum(p.amount) as total_sales
from store s
join address a on s.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
join staff m on s.manager_staff_id = m.staff_id
join customer c on s.store_id = c.store_id
join payment p on c.customer_id = p.customer_id
group by s.store_id;


select a.first_name, a.last_name, count(fa.film_id) as total_films
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id
having count(fa.film_id) = (
    select max(film_count)
    from (
        select count(film_id) as film_count
        from film_actor
        group by actor_id
    ) as sub
);