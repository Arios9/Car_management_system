


CREATE TABLE vehicle (
    id serial,
    brand VARCHAR(255),
    model VARCHAR(255),
    myear VARCHAR(255),
    engine_size INT,
    color VARCHAR(255),
    price INT,
    PRIMARY KEY (id)
);

CREATE TABLE customer (
    id serial,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    city VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE sales (
    id serial,
    vid INT NOT NULL,   
    cid INT NOT NULL, 
    PRIMARY KEY (id),
    FOREIGN KEY (vid) REFERENCES vehicle(id),
    FOREIGN KEY (cid) REFERENCES customer(id)
);

CREATE OR REPLACE PROCEDURE insert_new_car(
    brand VARCHAR(255),
    model VARCHAR(255),
    myear INT,
    engine_size INT,
    color VARCHAR(255),
    price INT
)
LANGUAGE SQL
AS $$
    INSERT INTO vehicle (brand,model,myear,engine_size,color,price) 
    VALUES (brand,model,myear,engine_size,color,price);
$$ ;

CREATE OR REPLACE PROCEDURE insert_new_customer(
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    city VARCHAR(255)
)
LANGUAGE SQL
AS $$
    INSERT INTO customer (firstname,lastname,email,phone,city) 
    VALUES (firstname,lastname,email,phone,city);
$$  ;

CREATE OR REPLACE PROCEDURE insert_new_sale(
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    city VARCHAR(255),
    car_id INT
)
LANGUAGE SQL
AS $$
    CALL insert_new_customer(firstname,lastname,email,phone,city);
    INSERT INTO sales (vid,cid) VALUES (car_id,(SELECT max(id) FROM customer));
$$ ;

CREATE OR REPLACE PROCEDURE update_car(
    car_id INT,
    brand VARCHAR(255),
    model VARCHAR(255),
    myear INT,
    engine_size INT,
    color VARCHAR(255),
    price INT   
)
LANGUAGE SQL
AS $$
    UPDATE vehicle
    SET brand=brand,model=model,myear=myear,engine_size=engine_size,color=color,price=price
    WHERE id = car_id;
$$;

CREATE OR REPLACE PROCEDURE update_customer(
    c_id INT,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    city VARCHAR(255)  
)
LANGUAGE SQL
AS $$ 
    UPDATE customer
    SET firstname=firstname,lastname=lastname,email=email,phone=phone,city=city
    WHERE id = c_id;
$$ ;

CREATE OR REPLACE PROCEDURE update_sale(
    sale_id INT,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    city VARCHAR(255),
    car_id INT   
)
LANGUAGE SQL
AS $$ 
    CALL update_customer(sale_id,firstname,lastname,email,phone,city);
    UPDATE sales SET vid=car_id WHERE id = sale_id;
$$ ;

CREATE OR REPLACE PROCEDURE delete_car(c_id INT)
LANGUAGE SQL
AS $$ 
    DELETE FROM sales WHERE vid=c_id;
    DELETE FROM vehicle WHERE id=c_id;   
$$  ;


CREATE OR REPLACE PROCEDURE delete_sale(s_id INT)
LANGUAGE SQL
AS $$  
    DELETE FROM sales WHERE id=s_id; 
$$ ;


CREATE OR REPLACE FUNCTION delete_customer_function()
RETURNS TRIGGER AS $$
BEGIN
DELETE FROM customer WHERE id=OLD.id;
RETURN OLD;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_customer AFTER DELETE ON sales
FOR EACH ROW
EXECUTE FUNCTION delete_customer_function();



