Use sakila;

# 1. consultas usando la tabla address
# consulta con postal_code en where
select address_id, address, postal_code
from address
where postal_code in ('24321', '49250', '34689');
#0.015 sec

# consulta con not in
select address_id, address, postal_code
from address
where postal_code not in ('24321', '34689', '49250');
#0.016 sec

# consulta con join hacia city y country
select a.address_id, a.address, a.postal_code, c.city, co.country
from address a
join city c on a.city_id = c.city_id
join country co on c.country_id = co.country_id
where a.postal_code = '49521';
#0.016 sec


# Crear índice sobre postal_code en address
create index idx_postalcode on address (postal_code);

# volver a ejecutar las consultas anteriores y medir tiempos
# la diferencia debería ser que con el índice las búsquedas por postal_code
# usan el index scan en lugar de un full table scan, por lo que son más rápidas.
# Casi no hay diferencia, pero esto porque la tabla 'address' no es tan grande, en bases de datos mas grandes si es mucho mas eficiente.

# explicación:
# sin índice -> mysql revisa todas las filas (full table scan).
# con índice -> mysql localiza directamente las filas que cumplen postal_code,
# reduciendo tiempos de ejecución de forma notable si la tabla es grande.

# 2. consultas sobre actor con búsquedas por first_name y last_name
# búsqueda por first_name
select actor_id, first_name, last_name
from actor
where first_name = 'nick';

# búsqueda por last_name
select actor_id, first_name, last_name
from actor
where last_name = 'cage';

# explicación:
# las diferencias se deben a si hay índices creados sobre cada columna.
# en sakila, actor tiene un índice sobre last_name (idx_actor_last_name),
# lo que hace que las búsquedas por last_name sean más rápidas que por first_name.
# si se crean índices sobre ambas columnas, el rendimiento seria similar.

# 3. comparación full-text search vs like
# búsqueda con like en film.description
select film_id, title, description
from film
where description like '%epic%';

# búsqueda con full-text en film_text
select film_id, title, description
from film_text
where match(title, description) against('epic');

# explicación:
# like '%epic%' fuerza a mysql a revisar fila por fila y comparar caracteres
# (no puede usar índices si el patrón empieza con '%'), por lo que es más lento.
# match ... against usa un índice full-text ya creado en film_text(title, description),
# lo que hace que la búsqueda sea mucho más eficiente y rápida para texto grande.