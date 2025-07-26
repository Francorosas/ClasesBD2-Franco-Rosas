drop view if exists list_of_customers;
create view list_of_customers as
select 
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as full_name,
    a.address,
    a.postal_code as zip_code,
    a.phone,
    ci.city,
    co.country,
    case when c.active = 1 then 'active' else 'inactive' end as status,
    c.store_id
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id;


drop view if exists film_details;
create view film_details as
select
    f.film_id,
    f.title,
    f.description,
    c.name as category,
    f.rental_rate as price,
    f.length,
    f.rating,
    group_concat(concat(a.first_name, ' ', a.last_name) separator ', ') as actors
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
group by f.film_id;


drop view if exists sales_by_film_category;
create view sales_by_film_category as
select
    c.name as category,
    count(r.rental_id) as total_rental
from category c
join film_category fc on c.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by c.name;


drop view if exists actor_information;
create view actor_information as
select
    a.actor_id,
    a.first_name,
    a.last_name,
    count(fa.film_id) as film_count
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id;


# 5. Análisis completo de la vista actor_info original de la base de datos Sakila

/*
CREATE VIEW actor_info AS
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    (
        SELECT GROUP_CONCAT(CONCAT(c.name, ': ', COUNT(f.film_id)) ORDER BY c.name SEPARATOR '; ')
        FROM film f
        INNER JOIN film_category fc ON f.film_id = fc.film_id
        INNER JOIN category c ON c.category_id = fc.category_id
        INNER JOIN film_actor fa ON f.film_id = fa.film_id
        WHERE fa.actor_id = a.actor_id
        GROUP BY fa.actor_id
    ) AS film_info
FROM actor a;

--- EXPLICACIÓN DETALLADA:

La vista `actor_info` muestra:
- El ID, nombre y apellido del actor.
- Un campo `film_info` que contiene un resumen en forma de texto con todas las categorías de películas en las que actuó ese actor, seguido de la cantidad de películas en cada categoría.

DESCOMPOSICIÓN:

1. `SELECT a.actor_id, a.first_name, a.last_name`:
   Se seleccionan los datos básicos de cada actor desde la tabla `actor`.

2. Subconsulta correlacionada (dentro del SELECT) → `film_info`:
   Esta subconsulta se ejecuta por cada actor individualmente (`WHERE fa.actor_id = a.actor_id`).
   Devuelve una cadena de texto con el siguiente formato:
   `'Action: 5; Comedy: 3; Drama: 2'` (por ejemplo), indicando la cantidad de películas por categoría para ese actor.

3. FROM dentro de la subconsulta:
   - `film f`: se parte desde la tabla de películas.
   - `INNER JOIN film_category fc ON f.film_id = fc.film_id`: se enlaza cada película con su categoría.
   - `INNER JOIN category c ON c.category_id = fc.category_id`: se obtiene el nombre de la categoría.
   - `INNER JOIN film_actor fa ON f.film_id = fa.film_id`: se enlazan las películas con los actores que participaron en ellas.

4. `WHERE fa.actor_id = a.actor_id`:
   Filtro clave. Hace que la subconsulta sea **correlacionada**, es decir, se evalúa para cada fila de la tabla `actor`.
   Aquí se buscan solamente las películas en las que actuó el actor actual del SELECT externo.

5. `GROUP BY fa.actor_id`:
   Agrupa todas las películas de ese actor para poder usar funciones de agregación.

6. `GROUP_CONCAT(CONCAT(c.name, ': ', COUNT(f.film_id)) ORDER BY c.name SEPARATOR '; ')`:
   - `COUNT(f.film_id)`: cuenta la cantidad de películas por categoría.
   - `CONCAT(c.name, ': ', COUNT(...))`: crea un texto por categoría, como `'Comedy: 3'`.
   - `GROUP_CONCAT(... SEPARATOR '; ')`: une todos los textos por categoría en una sola cadena, separados por `;`.
   - `ORDER BY c.name`: ordena alfabéticamente por nombre de categoría.

Resultado:
→ Una vista que devuelve una fila por actor, y en la última columna un resumen de las categorías en las que actuó y cuántas películas hay por cada una.

Esta vista es útil para reportes y análisis generales, y utiliza una subconsulta correlacionada dentro del SELECT principal para calcular información agregada por actor.
*/


# 6. Descripción de Materialized Views

/*
Una materialized view (vista materializada) es una vista que almacena físicamente los resultados de una consulta.
A diferencia de una vista normal, que se ejecuta cada vez que se consulta, una vista materializada guarda los datos
y solo se actualiza cuando se le indica (manualmente o programado).

Ventajas:
- Mejora drásticamente el rendimiento en consultas complejas.
- Se puede indexar como si fuera una tabla.
- Es útil cuando los datos no cambian con frecuencia y se necesita velocidad de lectura.

Desventajas:
- Ocupa espacio en disco.
- Puede quedar desactualizada si no se refresca.

Alternativas en DBMS que no las soportan nativamente:
- Crear una tabla con los resultados.
- Programar una rutina que actualice la tabla periódicamente.
- Usar triggers o eventos programados (en MySQL por ejemplo).

Soporte por motor de base de datos:
- PostgreSQL: Soportado con 'refresh materialized view'
- Oracle: Soportado, con muchas opciones de refresco
- SQL Server: No lo soporta directamente, pero tiene vistas indexadas
- MySQL: No las soporta directamente. Se puede simular manualmente
*/