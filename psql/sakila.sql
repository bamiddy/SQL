-- Active: 1771076581161@@127.0.0.1@5432@sakila@sakila


CREATE DATABASE world;

-- To load in a sql file either data, query or schema. You use.. 
-- mysql -u root -p sakila < sakila.sql path
-- psql -U postgres -d sakila -f sakila.sql path
-- search schema. \dn

SET search_path TO sakila; 
--To set the search path to the sakila database, instead of using the full table name (sakila.table_name), you can just use table_name.

SELECT a.address, a.district, u.country, a.phone 
    FROM address a
     JOIN city c ON a.city_id = c.city_id
     JOIN country u ON c.country_id = u.country_id
     WHERE u.country = 'Nigeria';


SELECT DISTINCT a.first_name, a.last_name, f.title, f.release_year, f.special_features, c.name, l.name
FROM actor a 
 JOIN film_actor fa ON a.actor_id = fa.film_id
 JOIN film f ON fa.film_id = f.film_id
 JOIN language l ON f.language_id = l.language_id
 JOIN film_category fc ON f.film_id = fc.film_id
 JOIN category c ON fc.category_id = c.category_id
    WHERE a.first_name = 'JULIA';

