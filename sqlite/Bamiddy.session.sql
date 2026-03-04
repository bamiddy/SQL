-- Active: 1772100084811@@127.0.0.1@3306
SELECT COUNT("last_name") FROM "actor";

CREATE TABLE customer2(
    "id" INTEGER,
    "email" TEXT,
    "full_name" TEXT,
    "date" DATE,
    "age" INTEGER,
    PRIMARY KEY("id")
);

ALTER TABLE customer2
RENAME COLUMN "date" TO "created_at";
DROP TABLE customer2;

INSERT INTO customer2 (email, full_name, created_at, age) VALUES
('olivia.martin@gmail.com', 'Olivia Martin', '2021-03-15', 29),
('liam.johnson@yahoo.com', 'Liam Johnson', '2020-11-22', 34),
('emma.williams@hotmail.com', 'Emma Williams', '2019-07-09', 27),
('noah.brown@gmail.com', 'Noah Brown', '2022-01-18', 31),
('ava.jones@yahoo.com', 'Ava Jones', '2023-05-12', 25),
('william.garcia@gmail.com', 'William Garcia', '2018-09-30', 40),
('sophia.miller@hotmail.com', 'Sophia Miller', '2021-06-25', 33),
('james.davis@yahoo.com', 'James Davis', '2020-02-14', 38),
('isabella.rodriguez@gmail.com', 'Isabella Rodriguez', '2022-08-03', 26),
('benjamin.martinez@yahoo.com', 'Benjamin Martinez', '2019-12-11', 45),
('mia.hernandez@gmail.com', 'Mia Hernandez', '2021-10-05', 30),
('lucas.lopez@hotmail.com', 'Lucas Lopez', '2023-03-27', 28),
('amelia.gonzalez@yahoo.com', 'Amelia Gonzalez', '2020-07-19', 36),
('henry.wilson@gmail.com', 'Henry Wilson', '2018-04-22', 41),
('harper.anderson@yahoo.com', 'Harper Anderson', '2022-09-14', 24),
('alexander.thomas@gmail.com', 'Alexander Thomas', '2021-12-01', 37),
('evelyn.taylor@hotmail.com', 'Evelyn Taylor', '2019-05-17', 32),
('michael.moore@yahoo.com', 'Michael Moore', '2023-01-09', 39),
('abigail.jackson@gmail.com', 'Abigail Jackson', '2020-06-28', 27),
('daniel.martin@hotmail.com', 'Daniel Martin', '2022-11-16', 35),
('ella.lee@yahoo.com', 'Ella Lee', '2021-08-07', 23),
('matthew.perez@gmail.com', 'Matthew Perez', '2019-03-29', 42),
('scarlett.thompson@hotmail.com', 'Scarlett Thompson', '2020-10-13', 29),
('jack.white@yahoo.com', 'Jack White', '2023-04-04', 31),
('victoria.harris@gmail.com', 'Victoria Harris', '2018-12-21', 44),
('sebastian.sanchez@hotmail.com', 'Sebastian Sanchez', '2021-02-08', 28),
('aria.clark@yahoo.com', 'Aria Clark', '2022-06-30', 26),
('david.ramirez@gmail.com', 'David Ramirez', '2019-09-15', 40),
('chloe.lewis@hotmail.com', 'Chloe Lewis', '2020-01-20', 33),
('joseph.robinson@yahoo.com', 'Joseph Robinson', '2023-07-11', 38),
('grace.walker@gmail.com', 'Grace Walker', '2021-04-18', 25),
('samuel.hall@hotmail.com', 'Samuel Hall', '2018-11-05', 46),
('zoey.allen@yahoo.com', 'Zoey Allen', '2022-03-23', 27),
('owen.young@gmail.com', 'Owen Young', '2020-08-16', 34),
('lily.king@hotmail.com', 'Lily King', '2023-02-28', 30);

SELECT * FROM customer2;


ALTER TABLE customer2
ADD COLUMN deleted INTEGER DEFAULT 0;

# CREATE A VIEWS FOR SOFT DELETE. USING 0 AND 1
CREATE VIEW customer_view
AS 
SELECT `id`, `email`, `full_name`, `age`, `created_at`
FROM customer2
WHERE deleted = 0;


SELECT * FROM customer_view;

DROP TRIGGER delete_view;

DELETE FROM customer_view
WHERE age = 29;

INSERT INTO customer_view(email, full_name, age, date_co)
VALUES('esther@gmail.com', 'Esther Ajala', 22, '1999-08-20');


## TRIGGER FROM DELETION AND INSERTION INTO THE VIEW TABLE.
## In mysql and psql you can modify view, but you cannot do it in mysqlite.

CREATE TRIGGER delete_view
INSTEAD OF DELETE ON customer_view
FOR EACH ROW
BEGIN
    UPDATE customer2
    SET deleted = 1
    WHERE id = OLD.id;
END;

#Run Triger that insert when not exist
CREATE TRIGGER insert_view
INSTEAD OF INSERT ON customer_view
FOR EACH ROW
# Can Use WHEN NOT EXISTS
WHEN NEW.id NOT IN (           
    SELECT id FROM customer2
)
BEGIN 
    INSERT INTO customer2 (id, email, full_name, age, created_at) 
    VALUES
        (NEW.id, NEW.email, NEW.full_name, NEW.age, NEW.created_at);
END; 

#Run Triger that insert when exist

CREATE TRIGGER insert_view2
INSTEAD OF INSERT ON customer_view
FOR EACH ROW
WHEN EXISTS(
-- This select at least one record if any EXISTS. if not none is selected
    SELECT 1 FROM customer2
    WHERE NEW.id = id
)
BEGIN
    UPDATE customer2
    SET deleted = 0
    WHERE id = NEW.id;
END;
    


# TEST THE TRIGGER
SELECT * FROM customer2;
SELECT * FROM customer_view;

DROP TRIGGER IF EXISTS insert_view;

INSERT INTO customer_view("id", "email", "full_name", "age", "created_at")
VALUES(36, 'esther@gmail.com', 'Esther Ajala', 22, '1999-08-20');


UPDATE customer2
SET deleted = 1
WHERE id = 36;