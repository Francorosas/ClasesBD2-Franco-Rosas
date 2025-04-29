select title, rating from film
where length = (select min(length) from film);


select title from film
where length = (select min(length) from film)
group by title
having count(*) = 1;


select c.customer_id, c.first_name, c.last_name, a.address, p.amount from customer c
join address a on c.address_id = a.address_id
join payment p on c.customer_id = p.customer_id
where p.amount <= all (
    select amount from payment where customer_id = c.customer_id
);


select c.customer_id, c.first_name, c.last_name, a.address, min(p.amount) as lowest_payment from customer c
join address a on c.address_id = a.address_id
join payment p on c.customer_id = p.customer_id
group by c.customer_id, c.first_name, c.last_name, a.address;


select c.customer_id, c.first_name, c.last_name, max(p.amount) as highest_payment, min(p.amount) as lowest_payment from customer c
join payment p on c.customer_id = p.customer_id
group by c.customer_id, c.first_name, c.last_name;