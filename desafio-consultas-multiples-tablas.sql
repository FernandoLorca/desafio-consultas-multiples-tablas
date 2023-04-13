CREATE DATABASE desafio3_fernando_lorca_123;
 
\c desafio3_fernando_lorca_123

CREATE TABLE users (id SERIAL PRIMARY KEY, email VARCHAR, name VARCHAR, lastname VARCHAR, role VARCHAR);

INSERT INTO users(email, name, lastname, role) VALUES 
('juan@mail.com', 'juan', 'perez', 'administrador'), ('diego@mail.com', 'diego', 'munoz', 'usuario'), ('maria@mail.com', 'maria', 'meza', 'usuario'), ('roxana@mail.com','roxana', 'diaz', 'usuario'), ('pedro@mail.com', 'pedro', 'diaz', 'usuario');

CREATE TABLE posts (id SERIAL PRIMARY KEY, title VARCHAR, content TEXT, date_creation DATE, update_date DATE, highlighted BOOLEAN, user_id BIGINT);

INSERT INTO posts (id, title, content, date_creation,
update_date, highlighted, user_id) VALUES 
('prueba', 'contenido prueba', '01/01/2021', '01/02/2021', true, 1), ('prueba2', 'contenido prueba2', '01/03/2021', '01/03/2021', true, 1), ('ejercicios', 'contenido ejercicios', '02/05/2021', '03/04/2021', true, 2), ('ejercicios2', 'contenido ejercicios2', '03/05/2021', '04/04/2021', false, 2), ('random', 'contenido random', '03/06/2021', '04/05/2021', false, null);

CREATE TABLE comments (id SERIAL PRIMARY KEY, content VARCHAR, date_creation
DATE, user_id BIGINT, post_id BIGINT);

INSERT INTO comments (id, content, date_creation, user_id,
post_id) VALUES  ('comentario 1', '03/06/2021', 1, 1), ('comentario 2', '03/06/2021', 2, 1), ('comentario 3', '04/06/2021', 3, 1), ('comentario 4', '04/06/2021', 1, 2);

--02 Cruza los datos de la tabla users y posts mostrando las siguientes columnas. name y email del usuario junto al título y content del post

SELECT users.name, users.email, posts.title, posts.content FROM users JOIN posts ON users.id = posts.user_id;

--03 Muestra el id, título y content de los posts de los administradores. El administrador puede ser cualquier id y debe ser seleccionado dinámicamente. 

SELECT posts.id, posts.title, posts.content FROM users JOIN posts ON users.id = posts.user_id WHERE users.role = 'administrador';

--04 Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id y email del usuario junto con la cantidad de posts de cada usuario

SELECT users.id, users.email, COUNT(posts.id) FROM users LEFT JOIN posts ON users.id = posts.user_id GROUP BY users.id, users.email;

--05 Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email. 

SELECT users.email FROM posts JOIN users ON posts.user_id = users.id GROUP BY users.id, users.email ORDER BY COUNT(posts.id) DESC;

--06 Muestra la fecha del último post de cada usuario.

SELECT name, MAX(date_creation) FROM (SELECT posts.content,posts.date_creation, users.name FROM users JOIN posts ON users.id = posts.user_id) AS p GROUP BY p.name;

--07 Muestra el título y content del post (artículo) con más comments. 

SELECT title, content FROM posts JOIN (SELECT post_id, COUNT(post_id) FROM comments GROUP BY post_id ORDER BY count DESC LIMIT 1) AS c ON posts.id = c.post_id;


--08 Muestra en una tabla el título de cada post, el content de cada post y el contenido de cada comentario asociado a los post mostrados, junto con el email del usuario que lo escribió.

SELECT posts.title as title_post, posts.content as content_post, comments.content as content_comment, users.email FROM posts JOIN comments ON posts.id = comments.post_id JOIN users ON comments.user_id = users.id;

--09 Muestra el content del último comentario de cada usuario.

SELECT date_creation, content, user_id FROM comments as c JOIN users as u ON c.user_id = u.id WHERE c.date_creation = (SELECT MAX(date_creation) FROM comments WHERE user_id = u.id);

--10 Muestra los emails de los users que no han escrito ningún comentario.

SELECT users.email FROM users LEFT JOIN comments ON users.id = comments.user_id GROUP BY users.email HAVING COUNT(comments.id) = 0;
