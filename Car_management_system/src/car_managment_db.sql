-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Φιλοξενητής: 127.0.0.1
-- Χρόνος δημιουργίας: 17 Φεβ 2021 στις 20:36:47
-- Έκδοση διακομιστή: 10.4.14-MariaDB
-- Έκδοση PHP: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Βάση δεδομένων: `car_managment_db`
--

DELIMITER $$
--
-- Διαδικασίες
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_car` (`c_id` INT)  BEGIN 
    DELETE FROM vehicle WHERE id=c_id;   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_sale` (`s_id` INT)  BEGIN 
    DELETE FROM sales WHERE id=s_id; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_new_car` (`brand` VARCHAR(255), `model` VARCHAR(255), `myear` INT, `engine_size` INT, `color` VARCHAR(255), `price` INT)  BEGIN
    INSERT INTO vehicle (brand,model,myear,engine_size,color,price) VALUES (brand,model,myear,engine_size,color,price);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_new_customer` (`firstname` VARCHAR(255), `lastname` VARCHAR(255), `email` VARCHAR(255), `phone` VARCHAR(255), `city` VARCHAR(255))  BEGIN
    INSERT INTO customer (firstname,lastname,email,phone,city) VALUES (firstname,lastname,email,phone,city);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_new_sale` (`firstname` VARCHAR(255), `lastname` VARCHAR(255), `email` VARCHAR(255), `phone` VARCHAR(255), `city` VARCHAR(255), `car_id` INT)  BEGIN
    CALL insert_new_customer(firstname,lastname,email,phone,city);
    INSERT INTO sales (vid,cid) VALUES (car_id,LAST_INSERT_ID());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_action_history` ()  BEGIN 
    SELECT * FROM action_history;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_sales` (IN `name_of_column` VARCHAR(255), IN `is_desc_sorting` BOOLEAN)  BEGIN 
SET @sql ='SELECT sales.id,customer.firstname,customer.lastname,customer.email,customer.phone,customer.city,sales.vid
FROM sales join customer on (sales.cid=customer.id)';
IF name_of_column<>'' THEN 
SET @sql = CONCAT(@sql,' order by `', name_of_column,'`'); 
END IF; 
IF is_desc_sorting THEN SET @sql = CONCAT(@sql,' DESC'); 
END IF; 
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_user` (IN `u` VARCHAR(255), IN `p` VARCHAR(255))  SELECT * FROM users where username=u and password=p$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_vehicles` (IN `name_of_column` VARCHAR(255), IN `is_desc_sorting` BOOLEAN)  BEGIN
SET @sql ='SELECT * FROM vehicle';
IF name_of_column<>'' THEN 
SET @sql = CONCAT(@sql,' order by `', name_of_column,'`'); 
END IF; 
IF is_desc_sorting THEN SET @sql = CONCAT(@sql,' DESC'); 
END IF; 
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_car` (`car_id` INT, `brand` VARCHAR(255), `model` VARCHAR(255), `myear` INT, `engine_size` INT, `color` VARCHAR(255), `price` INT)  BEGIN
    UPDATE vehicle
    SET brand=brand,model=model,myear=myear,engine_size=engine_size,color=color,price=price
    WHERE id = car_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_customer` (`c_id` INT, `firstname` VARCHAR(255), `lastname` VARCHAR(255), `email` VARCHAR(255), `phone` VARCHAR(255), `city` VARCHAR(255))  BEGIN 
    UPDATE customer
    SET firstname=firstname,lastname=lastname,email=email,phone=phone,city=city
    WHERE id = c_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_sale` (`sale_id` INT, `firstname` VARCHAR(255), `lastname` VARCHAR(255), `email` VARCHAR(255), `phone` VARCHAR(255), `city` VARCHAR(255), `car_id` INT)  BEGIN 
    CALL update_customer(sale_id,firstname,lastname,email,phone,city);
    UPDATE sales SET vid=car_id WHERE id = sale_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `action_history`
--

CREATE TABLE `action_history` (
  `id` int(11) NOT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operation_type` varchar(40) NOT NULL,
  `tablename` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `action_history`
--

INSERT INTO `action_history` (`id`, `time_stamp`, `operation_type`, `tablename`) VALUES
(1, '2020-12-08 00:57:29', 'INSERT', 'vehicle'),
(2, '2020-12-08 00:58:01', 'INSERT', 'vehicle'),
(3, '2020-12-08 00:58:10', 'UPDATE', 'vehicle'),
(4, '2020-12-08 00:58:55', 'INSERT', 'sales'),
(5, '2020-12-08 01:02:23', 'INSERT', 'sales'),
(6, '2020-12-08 01:03:39', 'INSERT', 'vehicle'),
(7, '2020-12-08 01:03:54', 'UPDATE', 'vehicle'),
(8, '2020-12-08 01:08:10', 'UPDATE', 'vehicle'),
(10, '2020-12-08 01:13:52', 'INSERT', 'sales'),
(11, '2020-12-08 01:17:15', 'INSERT', 'sales');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `customer`
--

CREATE TABLE `customer` (
  `id` int(11) NOT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `customer`
--

INSERT INTO `customer` (`id`, `firstname`, `lastname`, `email`, `phone`, `city`) VALUES
(1, 'babis', 'bab', 'bab@', '321323', 'disneyland'),
(2, 'antonis', 'peponis', 'anto@', '---', 'nisia feroe'),
(3, 'Marinos', 'Casinos', 'mc@', '6969', 'drimiklada'),
(4, 'Mpiras', 'xrisothiras', 'gold@', '---', 'eldorado');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `vid` int(11) NOT NULL,
  `cid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `sales`
--

INSERT INTO `sales` (`id`, `vid`, `cid`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 4, 3),
(4, 3, 4);

--
-- Δείκτες `sales`
--
DELIMITER $$
CREATE TRIGGER `delete_customer` AFTER DELETE ON `sales` FOR EACH ROW BEGIN 
    DELETE FROM customer WHERE id=OLD.id; 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `delete_sales_history` AFTER DELETE ON `sales` FOR EACH ROW BEGIN 
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'DELETE','vehicle');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_sales_history` AFTER INSERT ON `sales` FOR EACH ROW BEGIN 
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'INSERT','sales');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_sales_history` AFTER UPDATE ON `sales` FOR EACH ROW BEGIN 
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'UPDATE','vehicle');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'admin', '123456');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `vehicle`
--

CREATE TABLE `vehicle` (
  `id` int(11) NOT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `myear` int(11) DEFAULT NULL,
  `engine_size` int(11) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `price` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Άδειασμα δεδομένων του πίνακα `vehicle`
--

INSERT INTO `vehicle` (`id`, `brand`, `model`, `myear`, `engine_size`, `color`, `price`) VALUES
(1, 'bmw', 'm3', 2009, 3000, 'black', 330000),
(2, 'Audi', 'a5', 2000, 2000, 'yellow', 222222),
(3, 'Ferrari', '458', 2003, 4500, 'red', 250000),
(4, 'Lambo', 'huracan', 2010, 4000, 'white', 1000000);

--
-- Δείκτες `vehicle`
--
DELIMITER $$
CREATE TRIGGER `delete_cars_history` AFTER DELETE ON `vehicle` FOR EACH ROW BEGIN 
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'DELETE','vehicle');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `delete_sold_cars` BEFORE DELETE ON `vehicle` FOR EACH ROW BEGIN 
    DELETE FROM sales WHERE vid=OLD.id; 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_cars_history` AFTER INSERT ON `vehicle` FOR EACH ROW BEGIN 
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'INSERT','vehicle');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_cars_history` AFTER UPDATE ON `vehicle` FOR EACH ROW BEGIN 
    INSERT INTO action_history (time_stamp,operation_type,tablename) VALUES (NOW(),'UPDATE','vehicle');
END
$$
DELIMITER ;

--
-- Ευρετήρια για άχρηστους πίνακες
--

--
-- Ευρετήρια για πίνακα `action_history`
--
ALTER TABLE `action_history`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vid` (`vid`),
  ADD KEY `cid` (`cid`);

--
-- Ευρετήρια για πίνακα `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT για άχρηστους πίνακες
--

--
-- AUTO_INCREMENT για πίνακα `action_history`
--
ALTER TABLE `action_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT για πίνακα `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT για πίνακα `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT για πίνακα `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT για πίνακα `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Περιορισμοί για άχρηστους πίνακες
--

--
-- Περιορισμοί για πίνακα `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`vid`) REFERENCES `vehicle` (`id`),
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`cid`) REFERENCES `customer` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
