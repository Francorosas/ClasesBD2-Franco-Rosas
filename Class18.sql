use sakila;

# 1. funcion que retorna la cantidad de copias 
#    de una pelicula en una tienda

delimiter //

create function copies_in_store(p_film_id int, p_store_id int) 
returns int
deterministic
begin
    declare v_count int;

    select count(i.inventory_id)
    into v_count
    from inventory i
    inner join film f on f.film_id = i.film_id
    where (f.film_id = p_film_id or f.title = cast(p_film_id as char))
      and i.store_id = p_store_id;

    return v_count;
end//

delimiter ;

# uso ejemplo:
select copies_in_store(1, 1);
select copies_in_store('ACADEMY DINOSAUR', 1);


# 2. procedimiento con cursor
#    devuelve clientes de un pais concatenados

delimiter //

create procedure customers_by_country(
    in p_country varchar(50),
    out p_customers text
)
begin
    declare v_done int default 0;
    declare v_first varchar(45);
    declare v_last varchar(45);

    declare cur cursor for
        select c.first_name, c.last_name
        from customer c
        inner join address a on c.address_id = a.address_id
        inner join city ci on a.city_id = ci.city_id
        inner join country co on ci.country_id = co.country_id
        where co.country = p_country;

    declare continue handler for not found set v_done = 1;

    set p_customers = '';

    open cur;

    read_loop: loop
        fetch cur into v_first, v_last;
        if v_done = 1 then
            leave read_loop;
        end if;

        if p_customers = '' then
            set p_customers = concat(v_first, ' ', v_last);
        else
            set p_customers = concat(p_customers, ';', v_first, ' ', v_last);
        end if;
    end loop;

    close cur;
end//

delimiter ;

# uso ejemplo:
call customers_by_country('Argentina', @custs);
select @custs;


# 3. explicacion de inventory_in_stock y film_in_stock

/*
la base sakila ya trae:

1) funcion inventory_in_stock(p_inventory_id int) returns tinyint
- recibe un id de inventario.
- consulta en la tabla rental si esa copia fue alquilada y todavía no fue devuelta.
- si existe un alquiler sin fecha de devolución retorna 0 (no disponible).
- si no existe, retorna 1 (disponible).

codigo original (resumen):
create function inventory_in_stock(p_inventory_id int) returns tinyint
begin
  declare v_rentals int;
  declare v_out int;
  select count(*) into v_rentals
  from rental r
  where r.inventory_id = p_inventory_id;
  
  if v_rentals = 0 then
     return 1;
  end if;

  select count(r.rental_id) into v_out
  from rental r
  where r.inventory_id = p_inventory_id
    and r.return_date is null;

  if v_out > 0 then
     return 0;
  else
     return 1;
  end if;
end
*/
# uso:
select inventory_in_stock(1);
/*
2) procedimiento film_in_stock(p_film_id int, p_store_id int, out p_count int)
- busca todas las copias de una pelicula en una tienda que estén disponibles.
- usa la funcion inventory_in_stock() para verificar cada copia.
- retorna la lista de inventory_id (select) y además un out parameter con la cantidad.

codigo original (resumen):
create procedure film_in_stock(
   in p_film_id int,
   in p_store_id int,
   out p_count int
)
begin
  select i.inventory_id
  from inventory i
  where i.film_id = p_film_id
    and i.store_id = p_store_id
    and inventory_in_stock(i.inventory_id);

  select found_rows() into p_count;
end
*/
# uso:
call film_in_stock(1, 1, @count);
select @count;
/*

en resumen:
- inventory_in_stock() se fija si un item está alquilado o disponible.
- film_in_stock() lista todos los items disponibles de un film en una tienda y da la cantidad.
*/
