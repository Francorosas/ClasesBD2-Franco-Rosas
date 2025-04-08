select first_name, last_name from actor 
where last_name in (
    select last_name from actor 
    group by last_name 
    having count(*) > 1
)
order by last_name, first_name;


select first_name, last_name from actor 
where actor_id not in (
    select distinct actor_id from film_actor
);


select first_name, last_name from customer 
where customer_id in (
    select customer_id from rental 
    group by customer_id 
    having count(distinct inventory_id) = 1
);


select first_name, last_name from customer 
where customer_id in (
    select customer_id from rental 
    group by customer_id 
    having count(distinct inventory_id) > 1
);


select first_name, last_name from actor 
where actor_id in (
    select actor_id from film_actor 
    where film_id in (
        select film_id from film where title in ('BETRAYED REAR', 'CATCH AMISTAD')
    )
);


select first_name, last_name from actor 
where actor_id in (
    select actor_id from film_actor 
    where film_id = (select film_id from film where title = 'BETRAYED REAR')
)
and actor_id not in (
    select actor_id from film_actor 
    where film_id = (select film_id from film where title = 'CATCH AMISTAD')
);


select first_name, last_name from actor 
where actor_id in (
    select actor_id from film_actor 
    where film_id = (select film_id from film where title = 'BETRAYED REAR')
)
and actor_id in (
    select actor_id from film_actor 
    where film_id = (select film_id from film where title = 'CATCH AMISTAD')
);


select first_name, last_name from actor 
where actor_id not in (
    select actor_id from film_actor 
    where film_id in (
        select film_id from film where title in ('BETRAYED REAR', 'CATCH AMISTAD')
    )
);