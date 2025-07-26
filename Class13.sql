insert into customer (store_id, first_name, last_name, email, address_id, active, create_date)
values (
  1,
  'Franco',
  'Rosas',
  'franco.rosas@email.com',
  (
    select max(a.address_id)
    from address a
    join city ci on a.city_id = ci.city_id
    join country co on ci.country_id = co.country_id
    where co.country = 'United States'
  ),
  1,
  current_timestamp
);


insert into rental (rental_date, inventory_id, customer_id, staff_id)
values (
  current_timestamp,
  (
    select max(i.inventory_id)
    from inventory i
    join film f on i.film_id = f.film_id
    where f.title = 'ACADEMY DINOSAUR'
  ),
  (
    select c.customer_id
    from customer c
    where c.customer_id = (
      select min(customer_id) from customer
    )
  ),
  (
    select s.staff_id
    from staff s
    where s.store_id = 2
    and s.staff_id = (
      select min(staff_id) from staff where store_id = 2
    )
  )
);


update film set release_year = 2001 where rating = 'G';
update film set release_year = 2003 where rating = 'PG';
update film set release_year = 2005 where rating = 'PG-13';
update film set release_year = 2007 where rating = 'R';
update film set release_year = 2009 where rating = 'NC-17';


update rental
set return_date = current_timestamp
where rental_id = (
  select rental_id
  from rental
  where return_date is null
  and rental_date = (
    select max(rental_date)
    from rental
    where return_date is null
  )
);


delete from rental
where inventory_id in (
  select inventory_id from inventory where film_id = 1
);

delete from payment
where rental_id in (
  select rental_id from rental
  where inventory_id in (
    select inventory_id from inventory where film_id = 1
  )
);

delete from inventory where film_id = 1;
delete from film_actor where film_id = 1;
delete from film_category where film_id = 1;
delete from film where film_id = 1;


#Paso 1: rentar una película disponible
insert into rental (rental_date, inventory_id, customer_id, staff_id)
values (
  current_timestamp,
  (
    select inventory_id
    from inventory i
    left join rental r on i.inventory_id = r.inventory_id and r.return_date is null
    where r.rental_id is null
    and i.inventory_id = (
      select min(i2.inventory_id)
      from inventory i2
      left join rental r2 on i2.inventory_id = r2.inventory_id and r2.return_date is null
      where r2.rental_id is null
    )
  ),
  (
    select min(customer_id) from customer
  ),
  (
    select min(staff_id)
    from staff
    where store_id = (
      select store_id
      from inventory
      where inventory_id = (
        select inventory_id
        from inventory i
        left join rental r on i.inventory_id = r.inventory_id and r.return_date is null
        where r.rental_id is null
        and i.inventory_id = (
          select min(i2.inventory_id)
          from inventory i2
          left join rental r2 on i2.inventory_id = r2.inventory_id and r2.return_date is null
          where r2.rental_id is null
        )
      )
    )
  )
);

#Paso 2: registrar el pago correspondiente
insert into payment (customer_id, staff_id, rental_id, amount, payment_date)
values (
  (
    select min(customer_id) from customer
  ),
  (
    select min(staff_id)
    from staff
    where store_id = (
      select store_id
      from inventory
      where inventory_id = (
        select inventory_id
        from inventory i
        left join rental r on i.inventory_id = r.inventory_id and r.return_date is null
        where r.rental_id is null
        and i.inventory_id = (
          select min(i2.inventory_id)
          from inventory i2
          left join rental r2 on i2.inventory_id = r2.inventory_id and r2.return_date is null
          where r2.rental_id is null
        )
      )
    )
  ),
  (
    select max(rental_id)
    from rental
    where inventory_id = (
      select inventory_id
      from inventory i
      left join rental r on i.inventory_id = r.inventory_id and r.return_date is null
      where r.rental_id is null
      and i.inventory_id = (
        select min(i2.inventory_id)
        from inventory i2
        left join rental r2 on i2.inventory_id = r2.inventory_id and r2.return_date is null
        where r2.rental_id is null
      )
    )
  ),
  4.99,
  current_timestamp
);