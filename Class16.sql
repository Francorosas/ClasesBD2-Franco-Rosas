# ejercicio 1
# intento de insertar un empleado con email nulo
drop database if exists Class16DB;
create database Class16DB;
use Class16DB;

CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

insert into employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
values (1001, 'Rosas', 'Franco', 'x123', null, '1', null, 'sales rep');
# resultado: error, porque email tiene la constraint not null

# ejercicio 2
# primera actualizacion
update employees
set employeeNumber = employeeNumber - 20;
# resultado: esto ocurre porque mysql workbench trae activado por defecto el "safe update mode".
# el safe update mode es una protección que impide ejecutar updates o deletes que afecten muchas filas
# si no se incluye un where basado en una columna clave (primary key o columna indexada).
# de esta forma se evita actualizar o borrar accidentalmente toda la tabla.
#
# opciones para resolverlo:
# 1) desactivar safe update mode en la sesión con:
#        set sql_safe_updates = 0;
#    luego correr el update y, si se desea, reactivarlo con:
#        set sql_safe_updates = 1;
#
# 2) incluir un where que haga referencia a la clave primaria, por ejemplo:
#        update employees
#        set employeenumber = employeenumber - 20
#        where employeenumber > 0;

# segunda actualizacion
update employees
set employeeNumber = employeeNumber + 20;
# resultado: el error es el mismo que el de arriba.

# ejercicio 3
# agregar columna age con restriccion entre 16 y 70
alter table employees
add column age int,
add constraint chk_age check (age between 16 and 70);

# ejercicio 4
/*
Explicacion de integridad referencial en sakila:
la tabla film_actor es intermedia (many-to-many).
film(film_id) es primary key y actor(actor_id) es primary key.
film_actor tiene foreign key (film_id) que referencia a film(film_id)
y foreign key (actor_id) que referencia a actor(actor_id).
esto asegura que solo se registren actores y films que existan en las tablas principales.
*/

# ejercicio 5
# agregar columna lastupdate y trigger para actualizar fecha-hora en insert y update
alter table employees
add column lastupdate datetime;

delimiter //
create trigger trg_employees_insert
before insert on employees
for each row
begin
    set new.lastupdate = current_timestamp();
end;
//

create trigger trg_employees_update
before update on employees
for each row
begin
    set new.lastupdate = current_timestamp();
end;
//
delimiter ;

# bonus: agregar columna lastupdateuser y trigger para guardar el usuario mysql que modifica la fila
alter table employees
add column lastupdateuser varchar(100);

delimiter //
create trigger trg_employees_insert_user
before insert on employees
for each row
begin
    set new.lastupdateuser = user();
end;
//

create trigger trg_employees_update_user
before update on employees
for each row
begin
    set new.lastupdateuser = user();
end;
//
delimiter ;

# ejercicio 6
/*
Triggers de sakila relacionados con film_text:

sakila tiene 2 triggers en la tabla film que actualizan film_text.

codigo de los triggers:

create trigger ins_film after insert on film
for each row begin
  insert into film_text (film_id, title, description)
  values(new.film_id, new.title, new.description);
end;

create trigger upd_film after update on film
for each row begin
  update film_text
  set title = new.title,
      description = new.description,
      film_id = new.film_id
  where film_id = old.film_id;
end;

explicacion:
- el trigger ins_film copia los datos de la nueva pelicula en film_text cada vez que se inserta una en film.
- el trigger upd_film sincroniza los cambios (title, description, id) en film_text cuando se actualiza un registro en film.
*/