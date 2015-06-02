
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `mymeal` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mymeal` ;

-- -----------------------------------------------------
-- Table `mymeal`.`Restaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Restaurant` (
  `restaurant_id_pk` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(256) NOT NULL,
  `min_order_value` FLOAT UNSIGNED NULL,
  `shipping_cost` FLOAT UNSIGNED NULL COMMENT 'must be >= 0\n',
  `max_delivery_range` INT NULL COMMENT 'in kilometers, \nadditional enums like:\ncitys, districts\nin 100 meter steps',
  `icon_name` VARCHAR(256) NULL DEFAULT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `street` VARCHAR(256) NOT NULL COMMENT 'http://www.bitboost.com/ref/international-address-formats/prc-china/',
  `postcode` VARCHAR(45) NOT NULL,
  `city` VARCHAR(256) NOT NULL,
  `province` VARCHAR(256) NOT NULL,
  `add_info` VARCHAR(256) NULL,
  `position_lat` DOUBLE NULL,
  `position_long` DOUBLE NULL,
  `offered` TINYINT(1) NULL COMMENT 'Describes if a current restaurant an',
  `password` VARCHAR(256) NULL,
  `session_id` VARCHAR(64) NULL COMMENT 'unique and truly random 256 key',
  PRIMARY KEY (`restaurant_id_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Customer` (
  `customer_id_pk` INT NOT NULL AUTO_INCREMENT COMMENT 'used as identifer.\nthere may be no two users with the same number\nhas to be double because with in we just can represent 10 digits, but chinese phone numbers have 11 digits\na list as representation would take more space',
  `region_code` VARCHAR(3) NULL COMMENT 'the region code of the phone number',
  `national_number` VARCHAR(15) NULL,
  `last_name` VARCHAR(256) NULL,
  `first_name` VARCHAR(256) NULL,
  `nick` VARCHAR(45) NOT NULL DEFAULT 'Name' COMMENT 'the nickname of the user\ndefault is combination of name',
  `password` VARCHAR(256) NULL,
  `session_id` VARCHAR(64) NULL COMMENT 'unique and truly random 256 key',
  PRIMARY KEY (`customer_id_pk`),
  UNIQUE INDEX `nick_UNIQUE` (`nick` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Meal_Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Meal_Category` (
  `meal_category_id_pk` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`meal_category_id_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Meal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Meal` (
  `meal_id_pk` INT NOT NULL AUTO_INCREMENT,
  `Restaurant_restaurant_id` INT NOT NULL,
  `name` VARCHAR(256) NULL,
  `price` VARCHAR(45) NULL,
  `Meal_Category_meal_category_id` INT NULL,
  `description` TEXT NULL DEFAULT NULL COMMENT 'optional',
  `spiciness` TINYINT UNSIGNED NULL COMMENT 'Range 0-3',
  `icon_name` VARCHAR(256) NULL,
  `offered` TINYINT(1) NULL,
  PRIMARY KEY (`meal_id_pk`),
  INDEX `fk_Menu_Restaurant1_idx` (`Restaurant_restaurant_id` ASC),
  INDEX `fk_Meal_Dish_Category1_idx` (`Meal_Category_meal_category_id` ASC),
  CONSTRAINT `fk_Menu_Restaurant1`
    FOREIGN KEY (`Restaurant_restaurant_id`)
    REFERENCES `mymeal`.`Restaurant` (`restaurant_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Meal_Dish_Category1`
    FOREIGN KEY (`Meal_Category_meal_category_id`)
    REFERENCES `mymeal`.`Meal_Category` (`meal_category_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Opening_Time`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Opening_Time` (
  `opening_time_id_pk` INT NOT NULL AUTO_INCREMENT,
  `day_id` INT NULL COMMENT 'allow enums like weekday, weekend',
  `starting_time` INT NULL COMMENT 'i would save starting time an closing time as int\nlike this representation 1030 = 10:30',
  `closing_time` INT NULL,
  PRIMARY KEY (`opening_time_id_pk`),
  INDEX `day_id_fk` (`day_id` ASC))
ENGINE = InnoDB
COMMENT = 'a restaurant may have multiple opening times';


-- -----------------------------------------------------
-- Table `mymeal`.`Delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Delivery` (
  `delivery_id_pk` INT NOT NULL AUTO_INCREMENT,
  `Customer_customer_id` INT NOT NULL,
  `Restaurant_restaurant_id` INT NOT NULL,
  `street` VARCHAR(256) NOT NULL,
  `postcode` VARCHAR(45) NOT NULL,
  `city` VARCHAR(256) NOT NULL,
  `province` VARCHAR(256) NOT NULL,
  `add_info` VARCHAR(256) NULL,
  `comment` VARCHAR(256) NULL,
  PRIMARY KEY (`delivery_id_pk`),
  INDEX `fk_User_has_Restaurant_Restaurant1_idx` (`Restaurant_restaurant_id` ASC),
  INDEX `fk_delivery_users1_idx` (`Customer_customer_id` ASC),
  CONSTRAINT `fk_User_has_Restaurant_Restaurant1`
    FOREIGN KEY (`Restaurant_restaurant_id`)
    REFERENCES `mymeal`.`Restaurant` (`restaurant_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery_users1`
    FOREIGN KEY (`Customer_customer_id`)
    REFERENCES `mymeal`.`Customer` (`customer_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Rating` (
  `Meal_meal_id_pk` INT NOT NULL,
  `Customer_customer_id_pk` INT NOT NULL,
  `date` DATETIME NULL,
  `rating` TINYINT NULL COMMENT 'not be bigger than 5',
  `comment` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`Customer_customer_id_pk`, `Meal_meal_id_pk`),
  INDEX `fk_Rating_dish1_idx` (`Meal_meal_id_pk` ASC),
  INDEX `fk_Rating_user1_idx` (`Customer_customer_id_pk` ASC),
  CONSTRAINT `fk_Rating_dish1`
    FOREIGN KEY (`Meal_meal_id_pk`)
    REFERENCES `mymeal`.`Meal` (`meal_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Rating_user1`
    FOREIGN KEY (`Customer_customer_id_pk`)
    REFERENCES `mymeal`.`Customer` (`customer_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Every user can rate a dish just once';


-- -----------------------------------------------------
-- Table `mymeal`.`Delivery_State_Type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Delivery_State_Type` (
  `delivery_status_type_id_pk` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(256) NULL,
  PRIMARY KEY (`delivery_status_type_id_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Delivery_State`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Delivery_State` (
  `Delivery_delivery_id_pk` INT NOT NULL,
  `date_pk` DATETIME NOT NULL,
  `Delivery_State_Type_delivery_status_type` INT NOT NULL,
  `comment` VARCHAR(256) NULL,
  PRIMARY KEY (`Delivery_delivery_id_pk`, `date_pk`),
  INDEX `fk_DeliveryState_delivery1_idx` (`Delivery_delivery_id_pk` ASC),
  INDEX `fk_delivery_state_delivery_state_type1_idx` (`Delivery_State_Type_delivery_status_type` ASC),
  CONSTRAINT `fk_DeliveryState_delivery1`
    FOREIGN KEY (`Delivery_delivery_id_pk`)
    REFERENCES `mymeal`.`Delivery` (`delivery_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery_state_delivery_state_type1`
    FOREIGN KEY (`Delivery_State_Type_delivery_status_type`)
    REFERENCES `mymeal`.`Delivery_State_Type` (`delivery_status_type_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Restaurant_Opening_Time_Map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Restaurant_Opening_Time_Map` (
  `restaurant_opening_time_map_id_pk` INT NOT NULL AUTO_INCREMENT,
  `Restaurant_restaurant_id` INT NOT NULL,
  `Opening_Time_opening_time_id` INT NOT NULL,
  PRIMARY KEY (`restaurant_opening_time_map_id_pk`),
  INDEX `fk_restaurants_has_opening_times_opening_times1_idx` (`Opening_Time_opening_time_id` ASC),
  INDEX `fk_restaurants_has_opening_times_restaurants1_idx` (`Restaurant_restaurant_id` ASC),
  CONSTRAINT `fk_restaurants_has_opening_times_restaurants1`
    FOREIGN KEY (`Restaurant_restaurant_id`)
    REFERENCES `mymeal`.`Restaurant` (`restaurant_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_restaurants_has_opening_times_opening_times1`
    FOREIGN KEY (`Opening_Time_opening_time_id`)
    REFERENCES `mymeal`.`Opening_Time` (`opening_time_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Delivery_Dish_Map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Delivery_Dish_Map` (
  `Delivery_delivery_id_pk` INT NOT NULL,
  `Meal_meal_id_pk` INT NOT NULL,
  `amount` INT NULL,
  PRIMARY KEY (`Delivery_delivery_id_pk`, `Meal_meal_id_pk`),
  INDEX `fk_delivery_has_dish_dish1_idx` (`Meal_meal_id_pk` ASC),
  INDEX `fk_delivery_has_dish_delivery1_idx` (`Delivery_delivery_id_pk` ASC),
  CONSTRAINT `fk_delivery_has_dish_delivery1`
    FOREIGN KEY (`Delivery_delivery_id_pk`)
    REFERENCES `mymeal`.`Delivery` (`delivery_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery_has_dish_dish1`
    FOREIGN KEY (`Meal_meal_id_pk`)
    REFERENCES `mymeal`.`Meal` (`meal_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Tag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Tag` (
  `tag_id_pk` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `color` VARCHAR(6) NULL,
  PRIMARY KEY (`tag_id_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Meal_Tag_Map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Meal_Tag_Map` (
  `Meal_meal_id_pk` INT NOT NULL,
  `Tag_tag_id_pk` INT NOT NULL,
  PRIMARY KEY (`Meal_meal_id_pk`, `Tag_tag_id_pk`),
  INDEX `fk_dish_has_tag_tag1_idx` (`Tag_tag_id_pk` ASC),
  INDEX `fk_dish_has_tag_dish1_idx` (`Meal_meal_id_pk` ASC),
  CONSTRAINT `fk_dish_has_tag_dish1`
    FOREIGN KEY (`Meal_meal_id_pk`)
    REFERENCES `mymeal`.`Meal` (`meal_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dish_has_tag_tag1`
    FOREIGN KEY (`Tag_tag_id_pk`)
    REFERENCES `mymeal`.`Tag` (`tag_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'A dish is never tagged twice with the same tag';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
GRANT USAGE ON *.* TO 'mymeal_admin'@'localhost' IDENTIFIED BY PASSWORD '*A90C4DA8A12927FB29B396EB67B95E7677CA6B20';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER ON `mymeal`.* TO 'mymeal_admin'@'localhost';
USE `mymeal` ;

-- created after http://www.movable-type.co.uk/scripts/latlong.html
DROP FUNCTION IF EXISTS DISTANCE;
DELIMITER $$
CREATE FUNCTION DISTANCE(lat1 DOUBLE, long1 DOUBLE, lat2 DOUBLE, long2 DOUBLE)
  RETURNS FLOAT
BEGIN
  DECLARE R, phi1, phi2, dphi, dlam, a, c, d FLOAT;
  SET R = 6371000; -- metres
  SET phi1 = RADIANS(lat1);
  SET phi2 = RADIANS(lat2);
  SET dphi = RADIANS(lat2-lat1);
  SET dlam = RADIANS(long2-long1);
    
  SET a = SIN(dphi/2) * SIN(dphi/2) +
         COS(phi1) * COS(phi2) *
         SIN(dlam/2) * SIN(dlam/2);
  SET c = 2 * ATAN2(SQRT(a), SQRT(1-a));
  
  SET d = R * c;
  RETURN d;
END;
$$
DELIMITER ;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 30, 2015 at 04:22 PM
-- Server version: 5.5.43-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mymeal`
--

-- --------------------------------------------------------

--
-- Table structure for table `Tag`
--

CREATE TABLE IF NOT EXISTS `Tag` (
  `tag_id_pk` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `color` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`tag_id_pk`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `Tag`
--

INSERT INTO `Tag` (`tag_id_pk`, `name`, `color`) VALUES
(1, 'Vegetarian', '195805'),
(2, 'Vegan', '22c13e'),
(3, 'Pork', 'f97990'),
(4, 'Cold', '73b9c1'),
(5, 'Kosher', '6c1547');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 31, 2015 at 11:55 AM
-- Server version: 5.5.43-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mymeal`
--

-- --------------------------------------------------------

--
-- Table structure for table `Meal_Category`
--

CREATE TABLE IF NOT EXISTS `Meal_Category` (
  `meal_category_id_pk` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`meal_category_id_pk`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `Meal_Category`
--

INSERT INTO `Meal_Category` (`meal_category_id_pk`, `name`) VALUES
(1, 'appetizer'),
(2, 'main menu'),
(3, 'desert');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 30, 2015 at 12:43 AM
-- Server version: 5.5.43-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mymeal`
--

-- --------------------------------------------------------

--
-- Table structure for table `Restaurant`
--

CREATE TABLE IF NOT EXISTS `Restaurant` (
  `restaurant_id_pk` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `min_order_value` float unsigned DEFAULT NULL,
  `shipping_cost` float unsigned DEFAULT NULL COMMENT 'must be >= 0\n',
  `max_delivery_range` float DEFAULT NULL COMMENT 'in kilometers, \nadditional enums like:\ncitys, districts\nin 100 meter steps',
  `icon_name` varchar(256) DEFAULT NULL,
  `description` text,
  `street` varchar(256) NOT NULL COMMENT 'http://www.bitboost.com/ref/international-address-formats/prc-china/',
  `postcode` varchar(45) NOT NULL,
  `city` varchar(256) NOT NULL,
  `province` varchar(256) NOT NULL,
  `add_info` varchar(256) DEFAULT NULL,
  `position_lat` double DEFAULT NULL,
  `position_long` double DEFAULT NULL,
  `offered` tinyint(1) DEFAULT NULL COMMENT 'Describes if a current restaurant an',
  `password` varchar(256) DEFAULT NULL,
  `session_id` varchar(64) DEFAULT NULL COMMENT 'unique and truly random 256 key',
  PRIMARY KEY (`restaurant_id_pk`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `Restaurant`
--

INSERT INTO `Restaurant` (`restaurant_id_pk`, `name`, `min_order_value`, `shipping_cost`, `max_delivery_range`, `icon_name`, `description`, `street`, `postcode`, `city`, `province`, `add_info`, `position_lat`, `position_long`, `offered`, `password`, `session_id`) VALUES
(1, 'Hualian', 10, 0, 10000, 'restaurant_0.jpg', 'Taste special Jidan Guangbing here.', '800 Dongchuan Road', '201109', 'Shanghai', 'Shanghai', 'on the campus', 31.02188, 121.43097, 1, 'GEHEIM', 'SESSION0'),
(2, 'Veggi Palace', 25, 10, 20000, 'restaurant_1.jpg', 'The best Veggi dishes you get in Shanghai', '1954 Huashan Road', '200030', 'Shanghai', 'Shanghai', NULL, 31.19875, 121.4364, 1, 'GEHEIM1', 'SESSION1'),
(3, 'Mustafa''s Vegetable Kebap', 0, 5, 5000, 'restaurant_2.jpg', 'Mustafa''s famous vegetable kebap only in Berlin', 'Mehringdamm 32', '10961', 'Berlin', 'Berlin', 'Next to the apartment blocks.', 52.49383, 13.38787, 1, 'GEHEIM2', 'SESSION2');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 31, 2015 at 04:25 PM
-- Server version: 5.5.43-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mymeal`
--

-- --------------------------------------------------------

--
-- Table structure for table `Customer`
--

CREATE TABLE IF NOT EXISTS `Customer` (
  `customer_id_pk` int(11) NOT NULL AUTO_INCREMENT COMMENT 'used as identifer.\nthere may be no two users with the same number\nhas to be double because with in we just can represent 10 digits, but chinese phone numbers have 11 digits\na list as representation would take more space',
  `region_code` varchar(2) DEFAULT NULL COMMENT 'the region code of the phone number',
  `national_number` varchar(15) DEFAULT NULL,
  `last_name` varchar(256) DEFAULT NULL,
  `first_name` varchar(256) DEFAULT NULL,
  `nick` varchar(45) NOT NULL DEFAULT 'Name' COMMENT 'the nickname of the user\ndefault is combination of name',
  `password` varchar(256) DEFAULT NULL,
  `session_id` varchar(64) DEFAULT NULL COMMENT 'unique and truly random 256 key',
  PRIMARY KEY (`customer_id_pk`),
  UNIQUE KEY `nick_UNIQUE` (`nick`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `Customer`
--

INSERT INTO `Customer` (`customer_id_pk`, `region_code`, `national_number`, `last_name`, `first_name`, `nick`, `password`, `session_id`) VALUES
(1, '49', '3070143434', 'Sturm', 'Gerald', 'garrythestorm', 'PASSWORD1', 'SESSIONC1'),
(2, '86', '14324389911', 'Yao', 'Lan', 'localj', 'PASSWORD2', 'SESSIONC2'),
(3, '86', '14232323989', 'Zhènfán', 'Lǐ', 'dragon_punch_1940', 'PASSWORD', 'SESSIONC4'),
(4, '1', '7184572531', 'Branton', 'Gloria', 'bunnybee', 'PASSWORD', 'SESSIONC4'),
(5, '1', '2126844814', 'John', 'Thomas H.', 'johnny', 'PASSWORD', 'SESSIONC3');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 31, 2015 at 11:59 AM
-- Server version: 5.5.43-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mymeal`
--

-- --------------------------------------------------------

--
-- Table structure for table `Meal`
--

CREATE TABLE IF NOT EXISTS `Meal` (
  `meal_id_pk` int(11) NOT NULL AUTO_INCREMENT,
  `Restaurant_restaurant_id` int(11) NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `price` varchar(45) DEFAULT NULL,
  `Meal_Category_meal_category_id` int(11) DEFAULT NULL,
  `description` text COMMENT 'optional',
  `spiciness` tinyint(3) unsigned DEFAULT NULL COMMENT 'Range 0-3',
  `icon_name` varchar(256) DEFAULT NULL,
  `offered` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`meal_id_pk`),
  KEY `fk_Menu_Restaurant1_idx` (`Restaurant_restaurant_id`),
  KEY `fk_Meal_Dish_Category1_idx` (`Meal_Category_meal_category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `Meal`
--

INSERT INTO `Meal` (`meal_id_pk`, `Restaurant_restaurant_id`, `name`, `price`, `Meal_Category_meal_category_id`, `description`, `spiciness`, `icon_name`, `offered`) VALUES
(1, 1, 'Jidan Guangbing', '8', NULL, 'Turnover filled with Jidan', 1, '', 1),
(2, 1, 'Cai Bing without egg', '6', NULL, 'A regular Cai Bing without egg', 0, '', 1),
(3, 1, 'Jingbing', '7', NULL, 'Jingbing with egg', 1, NULL, 1),
(4, 2, 'Salad', '20', 1, 'Salad with tomatoes, olives and onions ', 0, NULL, 1),
(5, 2, 'Veggie Burger', '70', 2, 'Veggie Burger with tofu and salad and pickles.', 0, NULL, 1),
(6, 2, 'Soya Ice Cream', '30', 3, 'Ice cream made with soya instead of milk', 0, NULL, 1),
(7, 3, 'Vegetable Kebab', '18', 2, 'Mustafas famous vegetable kebab', 1, NULL, 1);

--
-- Constraints for dumped tables
--


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 31, 2015 at 04:25 PM
-- Server version: 5.5.43-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mymeal`
--

-- --------------------------------------------------------

--
-- Table structure for table `Rating`
--

CREATE TABLE IF NOT EXISTS `Rating` (
  `Meal_meal_id_pk` int(11) NOT NULL,
  `Customer_customer_id_pk` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `rating` smallint(6) DEFAULT NULL COMMENT 'smallint because the number will not be bigger than 10',
  `comment` text,
  PRIMARY KEY (`Customer_customer_id_pk`,`Meal_meal_id_pk`),
  KEY `fk_Rating_dish1_idx` (`Meal_meal_id_pk`),
  KEY `fk_Rating_user1_idx` (`Customer_customer_id_pk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Every user can rate a dish just once';

--
-- Dumping data for table `Rating`
--

INSERT INTO `Rating` (`Meal_meal_id_pk`, `Customer_customer_id_pk`, `date`, `rating`, `comment`) VALUES
(1, 1, '2015-05-07 00:00:00', 5, 'Best ever'),
(7, 1, '2015-05-28 18:30:43', 4, 'Tasty, but overrated and crowdy'),
(1, 2, '2015-05-01 18:43:22', 4, 'really tasty, but a bit salty'),
(4, 2, '2015-05-05 12:14:54', 3, 'Really good, but way too expensive'),
(6, 2, '2015-05-05 12:15:32', 5, 'Mhmmm... tasty'),
(1, 3, '2015-05-02 20:08:56', 2, 'Really did not like the one without egg'),
(2, 3, '2015-05-15 17:00:01', 3, 'Okeh!'),
(3, 3, '2015-05-12 17:00:00', 4, 'Good!'),
(4, 3, '2015-05-14 17:00:01', 5, 'Hen Good!'),
(5, 3, '2015-05-13 17:00:00', 5, 'Good, a!');


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;