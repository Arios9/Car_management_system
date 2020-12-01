


DROP DATABASE IF EXISTS CAR_MANAGMENT_DB;

CREATE DATABASE CAR_MANAGMENT_DB;

USE  CAR_MANAGMENT_DB;

CREATE TABLE vehicle (
    id INT NOT NULL AUTO_INCREMENT,
    brand VARCHAR(255),
    model VARCHAR(255),
    myear INT,
    engine_size INT,
    color VARCHAR(255),
    price INT,
    PRIMARY KEY (id)
);

CREATE TABLE customer (
    id INT NOT NULL AUTO_INCREMENT,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    city VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE sales (
    id INT NOT NULL AUTO_INCREMENT,
    vid INT NOT NULL,   
    cid INT NOT NULL, 
    PRIMARY KEY (id),
    FOREIGN KEY (vid) REFERENCES vehicle(id),
    FOREIGN KEY (cid) REFERENCES customer(id)
);




------------------insert

DELIMITER $$
CREATE PROCEDURE insert_new_car(
    brand VARCHAR(255),
    model VARCHAR(255),
    myear INT,
    engine_size INT,
    color VARCHAR(255),
    price INT
)
BEGIN
    INSERT INTO vehicle (brand,model,myear,engine_size,color,price) VALUES (brand,model,myear,engine_size,color,price);
END
$$ DELIMITER ;


DELIMITER $$
CREATE PROCEDURE insert_new_customer(
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    city VARCHAR(255)
)
BEGIN
    INSERT INTO customer (firstname,lastname,email,phone,city) VALUES (firstname,lastname,email,phone,city);
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_new_sale(
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    city VARCHAR(255),
    car_id INT
)
BEGIN
    CALL insert_new_customer(firstname,lastname,email,phone,city);
    INSERT INTO sales (vid,cid) VALUES (car_id,LAST_INSERT_ID());
END
$$ DELIMITER ;




------------------update

DELIMITER $$
CREATE PROCEDURE update_car(
    car_id INT,
    brand VARCHAR(255),
    model VARCHAR(255),
    myear INT,
    engine_size INT,
    color VARCHAR(255),
    price INT   
)
BEGIN
    UPDATE vehicle
    SET brand=brand,model=model,myear=myear,engine_size=engine_size,color=color,price=price
    WHERE id = car_id;
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_sale(
    sale_id INT,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    city VARCHAR(255),
    car_id INT   
)
BEGIN 
    CALL update_customer(sale_id,firstname,lastname,email,phone,city);
    UPDATE sales SET vid=car_id WHERE id = sale_id;
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_customer(
    c_id INT,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    city VARCHAR(255)  
)
BEGIN 
    UPDATE customer
    SET firstname=firstname,lastname=lastname,email=email,phone=phone,city=city
    WHERE id = c_id;
END
$$ DELIMITER ;

------------------delete

DELIMITER $$
CREATE PROCEDURE delete_car(c_id INT)
BEGIN 
    DELETE FROM vehicle WHERE id=c_id;   
END
$$ DELIMITER ;

DELIMITER $$
CREATE TRIGGER delete_sold_cars BEFORE DELETE ON vehicle
FOR EACH ROW
BEGIN 
    DELETE FROM sales WHERE vid=OLD.id; 
END
$$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE delete_sale(s_id INT)
BEGIN 
    DELETE FROM sales WHERE id=s_id; 
END
$$ DELIMITER ;

DELIMITER $$
CREATE TRIGGER delete_customer AFTER DELETE ON sales
FOR EACH ROW
BEGIN 
    DELETE FROM customer WHERE id=OLD.id;
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'DELETE','sales');
END
$$ DELIMITER ;



------------------select


DELIMITER $$ 
CREATE PROCEDURE select_vehicles(IN name_of_column VARCHAR(255),IN is_desc_sorting BOOLEAN ) 
BEGIN
SET @sql ='SELECT * FROM vehicle';
IF name_of_column<>'' THEN 
SET @sql = CONCAT(@sql,' order by `', name_of_column,'`'); 
END IF; 
IF is_desc_sorting THEN SET @sql = CONCAT(@sql,' DESC'); 
END IF; 
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt; 
END $$ 
DELIMITER ; 

DELIMITER $$ 
CREATE PROCEDURE select_sales(IN name_of_column VARCHAR(255),IN is_desc_sorting BOOLEAN ) 
BEGIN 
SET @sql ='SELECT sales.id,customer.firstname,customer.lastname,customer.email,customer.phone,customer.city,sales.vid
FROM sales join customer on (sales.cid=customer.id)';
IF name_of_column<>'' THEN 
SET @sql = CONCAT(@sql,' order by `', name_of_column,'`'); 
END IF; 
IF is_desc_sorting THEN SET @sql = CONCAT(@sql,' DESC'); 
END IF; 
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt; 
END $$ 
DELIMITER ; 



DROP TABLE IF EXISTS action_history;
CREATE TABLE action_history(
    id INT NOT NULL AUTO_INCREMENT,
    time_stamp timestamp NOT NULL,
    operation_type varchar(40) NOT NULL,
    tablename varchar(40) NOT NULL,
    PRIMARY KEY (id)
);


CREATE TRIGGER insert_cars_history AFTER INSERT ON vehicle
FOR EACH ROW
INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'INSERT','vehicle');


CREATE TRIGGER update_cars_history AFTER UPDATE ON vehicle
FOR EACH ROW
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'UPDATE','vehicle');


CREATE TRIGGER delete_cars_history AFTER DELETE ON vehicle
FOR EACH ROW
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'DELETE','vehicle');


CREATE TRIGGER insert_sales_history AFTER INSERT ON sales
FOR EACH ROW 
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'INSERT','sales');


CREATE TRIGGER update_sales_history AFTER UPDATE ON sales
FOR EACH ROW
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'UPDATE','sales');



CREATE TRIGGER delete_sales_history AFTER DELETE ON sales
FOR EACH ROW
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'DELETE','sales');


CREATE PROCEDURE select_action_history()
    SELECT * FROM action_history;

CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(255),
    password VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE PROCEDURE select_user(IN u VARCHAR(255),IN p VARCHAR(255))
    SELECT * FROM users where username=u and password=p;



INSERT INTO users (username, password)
VALUES ('admin','123456');


