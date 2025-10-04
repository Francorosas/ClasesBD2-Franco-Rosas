# 1. crear un usuario llamado data_analyst
create user 'data_analyst'@'localhost' identified by 'analyst123';

# 2. otorgar permisos solo de select, update y delete sobre todas las tablas de sakila
grant select, update, delete on sakila.* to 'data_analyst'@'localhost';

# aplicar los cambios de privilegios
flush privileges;

# 3. iniciar sesión con data_analyst e intentar crear una tabla
# si intentamos:
create table test_table(id int);
# Esto deberia dar error, porque el usuario no tiene permiso CREATE

# 4. intentar actualizar el título de una película (siendo data_analyst)
update film
set title = 'new film title'
where film_id = 1;

# esto funciona porque el usuario tiene permiso de update

# 5. como root o admin, revocar el permiso de update
revoke update on sakila.* from 'data_analyst'@'localhost';
flush privileges;

# 6. volver a iniciar sesión con data_analyst e intentar otra vez el update del punto 4
# deberia saltar error ya que en el punto 5 se lo quitamos con REVOKE
