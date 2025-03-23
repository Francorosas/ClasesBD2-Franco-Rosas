drop database if exists imdb;
create database imdb;
use imdb;

create table film (
    film_id int auto_increment primary key,
    title varchar(255) not null,
    description text,
    release_year year
);

create table actor (
    actor_id int auto_increment primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null
);

create table film_actor (
    actor_id int,
    film_id int,
    primary key (actor_id, film_id),
    foreign key (actor_id) references actor(actor_id),
    foreign key (film_id) references film(film_id)
);

alter table film 
add column last_update timestamp default current_timestamp on update current_timestamp;
alter table actor 
add column last_update timestamp default current_timestamp on update current_timestamp;

insert into actor (first_name, last_name) values
('andrew', 'garfield'),
('brad', 'pitt'),
('leonardo', 'dicaprio'),
('dennis', 'quaid');

insert into film (title, description, release_year) values
('hasta el ultimo hombre', 'el primer objetor de conciencia que va a la guerra', 2016),
('fight club', 'No podemos hablar de esta pelicula', 1999),
('titanic', 'historia de amor en un barco', 1997),
('la razon de estar contigo', 'un perro que rencarna en muchas vidas busca a su verdadero dueño', 2017);

insert into film_actor (actor_id, film_id) values
(1, 1),
(1, 2),
(2, 2),
(3, 3),
(4, 4);
