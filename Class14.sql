# 1. Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.
select 
    concat(c.first_name, ' ', c.last_name) as full_name,
    a.address,
    ci.city
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where lower(co.country) = 'argentina';
/*
 2. Write a query that shows the film title, language and rating. 
 Rating shall be shown as the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.
*/
select 
    f.title,
    l.name as language,
    case f.rating
        when 'G' then 'General Audiences – All Ages Admitted'
        when 'PG' then 'Parental Guidance Suggested – Some Material May Not Be Suitable for Children'
        when 'PG-13' then 'Parents Strongly Cautioned – Some Material May Be Inappropriate for Children Under 13'
        when 'R' then 'Restricted – Under 17 Requires Accompanying Parent or Adult Guardian'
        when 'NC-17' then 'Adults Only – No One 17 and Under Admitted'
        else 'Not Rated'
    end as rating_description
from film f
join language l on f.language_id = l.language_id;

/* 
3. Write a search query that shows all the films (title and release year) an actor was part of. 
Assume the actor comes from a text box introduced by hand from a web page. 
Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.
*/
select 
    f.title as film_title,
    f.release_year
from film f
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
where lower(concat(a.first_name, ' ', a.last_name)) like concat('%', lower(trim('ALBERT NOLTE')), '%')
order by f.release_year, f.title;

/* 
4. Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. 
There should be returned column with two possible values 'Yes' and 'No'.
*/
select 
    f.title,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    case 
        when r.return_date is not null then 'yes'
        else 'no'
    end as returned
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join customer c on r.customer_id = c.customer_id
where month(r.rental_date) in (5, 6);

/* 
5. CAST vs CONVERT in MySQL
   - Ambos se usan para convertir tipos de datos.
   - CAST(expr AS type) → sintaxis estándar ANSI SQL.
   - CONVERT(expr, type) → sintaxis propietaria de MySQL (también existe en SQL Server pero con diferencias).
   - CAST es más portable, CONVERT es específico y soporta conversiones de charset.
   Ejemplos en Sakila:
*/
-- Ejemplo: convertir release_year (YEAR) a CHAR para concatenarlo
select 
    f.title,
    cast(f.release_year as char) as release_year_char
from film f;

-- Ejemplo con CONVERT:
select 
    f.title,
    convert(f.release_year, char) as release_year_char
from film f;

/* 
6. NVL, ISNULL, IFNULL, COALESCE, etc.
   - NVL(expr1, expr2): Devuelve expr2 si expr1 es NULL (Oracle). No está en MySQL.
   - ISNULL(expr): En MySQL devuelve 1 si expr es NULL, 0 si no. En SQL Server ISNULL(expr1, expr2) funciona como IFNULL.
   - IFNULL(expr1, expr2): MySQL y MariaDB → devuelve expr2 si expr1 es NULL, si no expr1.
   - COALESCE(expr1, expr2, ...): Devuelve el primer valor NO NULL de la lista. Es ANSI SQL y funciona en MySQL.
   Ejemplos en Sakila:
*/
-- IFNULL: Mostrar 'Unknown' si no hay address2
select 
    a.address,
    ifnull(a.address2, 'Unknown') as secondary_address
from address a;

-- COALESCE: Mostrar numero de telefono, si es NULL mostrar postal_code, si ambos NULL mostrar 'No data'
select 
    a.address,
    coalesce(a.phone, a.postal_code, 'No data') as contact_info
from address a;

-- NVL: No existe en MySQL, sería equivalente a IFNULL(expr1, expr2)
-- ISNULL(expr): Ejemplo para marcar registros con phone vacío
select 
    a.address,
    isnull(a.phone) as is_phone_null
from address a;