-- Active: 1770944022851@@127.0.0.1@5432@sakila


CREATE DATABASE sakila;

-- To load in a sql file either data, query or schema. You use.. 
-- mysql -u root -p sakila < sakila.sql path
-- psql -U postgres -d sakila -f sakila.sql path
-- search schema. \dn

-- SET search_path TO sakila; To set the search path to the sakila database, instead of using the full table name (sakila.table_name), you can just use table_name.
