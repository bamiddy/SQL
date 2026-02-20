-- Active: 1771080877515@@127.0.0.1@3306@sakila
SHOW TABLES;

# Add column to customer2
ALTER TABLE customer2
ADD COLUMN 
age SMALLINT NOT NULL;

# UPDATE TABLE
UPDATE customer2
SET `age` = 23
WHERE `customer_id` = 1;

UPDATE customer2
SET `age` = 30
WHERE `customer_id` = 34;

SELECT * FROM customer_audit;

SELECT * FROM customer2;

INSERT INTO customer2
 VALUES (35, 'amina.johnson@gmail.com', 'Amina Johnson', '2022-11-15', 28),
(36, 'david.okoro@yahoo.com', 'David Okoro', '2021-07-09', 34),
(37, 'sophia.williams@mail.com', 'Sophia Williams', '2023-01-21', 26),
(38, 'emeka.adams@gmail.com', 'Emeka Adams', '2020-05-30', 41),
(39, 'linda.brown@yahoo.com', 'Linda Brown', '2022-09-12', 29),
(40, 'michael.smith@mail.com', 'Michael Smith', '2023-03-18', 32),
(41, 'grace.taylor@gmail.com', 'Grace Taylor', '2021-12-02', 27),
(42, 'daniel.martin@yahoo.com', 'Daniel Martin', '2020-08-25', 38),
(43, 'olivia.jackson@mail.com', 'Olivia Jackson', '2023-06-14', 24),
(44, 'samuel.clark@gmail.com', 'Samuel Clark', '2022-04-07', 36);

UPDATE customer2
SET `full_name` = LCASE(`full_name`);

CREATE TABLE cus_del_table(
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_name VARCHAR(30),
    del_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER soft_delete
AFTER DELETE ON customer2
FOR EACH ROW
BEGIN
    INSERT INTO cus_del_table(customer_id, customer_name)
    VALUES (OLD.customer_id, OLD.full_name);
END //

DELIMITER ;

DELETE FROM customer2
WHERE `email` = 'bamiddy@gmail.com';

SELECT * FROM cus_del_table;

DELETE FROM customer2
WHERE customer_id = 35;

SELECT * FROM `customer_audit`;

# Add column for grade
ALTER TABLE customer2
ADD COLUMN 
    `grade` VARCHAR(1);

DELIMITER //
CREATE TRIGGER update_customer
BEFORE UPDATE ON customer2
FOR EACH ROW
BEGIN
    IF NEW.age < 20 THEN 
        SET NEW.grade = 'F';

    ELSEIF NEW.age >= 20 AND NEW.age < 30 THEN 
        SET NEW.grade = 'C';
    
    ELSEIF NEW.age >= 30 AND NEW.age < 50 THEN 
        SET NEW.grade = 'A';

    END IF;
END //
DELIMITER ;


UPDATE customer2
SET age = 15
WHERE email = 'bolu@gmail.com';

SELECT * FROM customer2;

DELIMITER //
CREATE TRIGGER after_insert
AFTER INSERT ON customer2
FOR EACH ROW
BEGIN 
    IF NEW.grade = 'F' THEN
    INSERT INTO customer_audit(customer_id, action, added_date)
    VALUES(NEW.customer_id, "poor", CURRENT_TIMESTAMP());
    END IF;
END //

INSERT INTO customer2(email, full_name, date_co, age)
VALUES('tobby@gmail.com', 'bami bello', CURRENT_DATE, 10);
