
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
  `min_order_value` FLOAT UNSIGNED NOT NULL,
  `shipping_cost` FLOAT UNSIGNED NOT NULL COMMENT 'must be >= 0\n',
  `max_delivery_range` INT NOT NULL COMMENT 'in kilometers, \nadditional enums like:\ncitys, districts\nin 100 meter steps',
  `description` TEXT NULL,
  `country` VARCHAR(256) NOT NULL,
  `postcode` VARCHAR(45) NOT NULL,
  `city` VARCHAR(256) NULL,
  `district` VARCHAR(45) NULL,
  `street_name` VARCHAR(256) NOT NULL,
  `street_number` VARCHAR(45) NULL,
  `add_info` VARCHAR(256) NULL,
  `position_lat` DOUBLE NULL,
  `position_long` DOUBLE NULL,
  `offered` TINYINT(1) NULL DEFAULT 1 COMMENT 'Describes if a current restaurant an',
  `password` VARCHAR(256) NOT NULL,
  `session_id` VARCHAR(64) NULL COMMENT 'unique and truly random 256 key',
  `region_code` VARCHAR(3) NOT NULL,
  `national_number` VARCHAR(15) NOT NULL,
  `email` VARCHAR(256) NULL,
  PRIMARY KEY (`restaurant_id_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Customer` (
  `customer_id_pk` INT NOT NULL AUTO_INCREMENT COMMENT 'used as identifer.\nthere may be no two users with the same number\nhas to be double because with in we just can represent 10 digits, but chinese phone numbers have 11 digits\na list as representation would take more space',
  `region_code` VARCHAR(3) NOT NULL COMMENT 'the region code of the phone number',
  `national_number` VARCHAR(15) NOT NULL,
  `last_name` VARCHAR(256) NOT NULL,
  `first_name` VARCHAR(256) NOT NULL,
  `nick` VARCHAR(45) NOT NULL COMMENT 'the nickname of the user\ndefault is combination of name',
  `password` VARCHAR(256) NOT NULL,
  `session_id` VARCHAR(64) NULL COMMENT 'unique and truly random 256 key',
  `email` VARCHAR(256) NULL,
  PRIMARY KEY (`customer_id_pk`),
  UNIQUE INDEX `nick_UNIQUE` (`nick` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Meal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Meal` (
  `meal_id_pk` INT NOT NULL AUTO_INCREMENT,
  `Restaurant_restaurant_id` INT NOT NULL,
  `name` VARCHAR(256) NOT NULL,
  `price` VARCHAR(45) NOT NULL,
  `description` TEXT NULL DEFAULT NULL COMMENT 'optional',
  `spiciness` TINYINT UNSIGNED NULL COMMENT 'Range 0-3',
  `offered` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`meal_id_pk`),
  INDEX `fk_Menu_Restaurant1_idx` (`Restaurant_restaurant_id` ASC),
  CONSTRAINT `fk_Menu_Restaurant1`
    FOREIGN KEY (`Restaurant_restaurant_id`)
    REFERENCES `mymeal`.`Restaurant` (`restaurant_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mymeal`.`Delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Delivery` (
  `delivery_id_pk` INT NOT NULL AUTO_INCREMENT,
  `Customer_customer_id` INT NOT NULL,
  `Restaurant_restaurant_id` INT NOT NULL,
  `country` VARCHAR(256) NOT NULL,
  `postcode` VARCHAR(45) NOT NULL,
  `city` VARCHAR(256) NULL,
  `district` VARCHAR(45) NULL,
  `street_name` VARCHAR(256) NOT NULL,
  `street_number` VARCHAR(45) NULL,
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
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `rating` TINYINT NOT NULL COMMENT 'not be bigger than 5',
  `comment` TEXT NULL,
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
  `date_pk` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
-- Table `mymeal`.`Delivery_Meal_Map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mymeal`.`Delivery_Meal_Map` (
  `Delivery_delivery_id_pk` INT NOT NULL,
  `Meal_meal_id_pk` INT NOT NULL,
  `amount` INT NOT NULL,
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
CREATE USER 'mymeal_admin'@'localhost' IDENTIFIED BY 'u9wZpVbs7xbD45JR';
GRANT USAGE ON *.* TO 'mymeal_admin'@'localhost' IDENTIFIED BY 'u9wZpVbs7xbD45JR';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER ON `mymeal`.* TO 'mymeal_admin'@'localhost';
CREATE USER 'mymeal_user'@'localhost' IDENTIFIED BY 'BFGHQvGR7MBCphXP';
GRANT SELECT, INSERT, DELETE, UPDATE, EXECUTE ON mymeal.* TO 'mymeal_user'@'localhost';

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
-- Generation Time: Jun 02, 2015 at 03:14 PM
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
-- Table structure for table `Delivery_State_Type`
--

CREATE TABLE IF NOT EXISTS `Delivery_State_Type` (
  `delivery_status_type_id_pk` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`delivery_status_type_id_pk`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `Delivery_State_Type`
--

INSERT INTO `Delivery_State_Type` (`delivery_status_type_id_pk`, `name`) VALUES
(1, 'Pending'),
(2, 'Processing'),
(3, 'In delivery'),
(4, 'Done');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.2.11
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 02, 2015 at 08:50 AM
-- Server version: 5.6.21
-- PHP Version: 5.6.3

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
-- Dumping data for table `Restaurant`
--

INSERT INTO `Restaurant` (`restaurant_id_pk`, `name`, `min_order_value`, `shipping_cost`, `max_delivery_range`, `description`, `country`, `postcode`, `city`, `district`, `street_name`, `street_number`, `add_info`, `position_lat`, `position_long`, `offered`, `password`, `session_id`, `region_code`, `national_number`, `email`) VALUES
(1, 'Hualian', 10, 0, 10000, 'Taste special Jidan Guangbing here.', 'China', '200030', 'Shanghai', 'Minghang Qu', 'Dongchuan Road', '800', NULL, 31.02188, 121.43097, 1, '098f6bcd4621d373cade4e832627b4f6', '26dfe8116b93ced6cfca858f375d23f1489d3207', '86', '17336010252', NULL),
(2, 'Veggi Palace', 25, 10, 20000, 'The best Veggi dishes you get in Shanghai', 'China', '200030', 'Shanghai', 'Xuhui Qu', 'Huashan Road', '1954', NULL, 31.19875, 121.4364, 1, 'bdc87b9c894da5168059e00ebffb9077', '4570258f13c64eefb56a26bac08093636f0fc102', '86', '17455250768', NULL),
(3, 'Mustafa''s Vegetable Kebap', 0, 5, 5000, 'Mustafa''s famous vegetable kebap only in Berlin', 'Germany', '10961', 'Berlin', 'Schoeneberg', 'Mehringdamm', '32', 'Next to the apartment blocks.', 52.49383, 13.38787, 1, '5f4dcc3b5aa765d61d8327deb882cf99', '75a2b6313ea2d41950160cc12678cf12ec461b79', '86', '14893035276', NULL),
(4, 'å¿…èƒœå®…æ€¥é€', 25, 0, 10000, 'Order some awsome pizza!', 'China', '', 'Minhang Qu', NULL, '2370 Dong Chuan Lu', NULL, NULL, 31.012494, 121.410644, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', 'bcc87b640667c0ca1a2d998ccd07fb1cb91821ef84031084fbb3ff45613a8cc5', '86', '13096883169', NULL),
(5, 'è‚¯å¾·åŸºå®…æ€¥é€', 25, 5, 10000, 'Get some fried chicken', 'æ±Ÿå·è·¯248å¼„134å·ä¸Šæµ·å¸‚é—µè¡ŒåŒºæ±Ÿå·è·¯è¡—é“ä¸œé£Žæ–°æ‘ç¬¬ä¸€å±…å§”å®¶åº­è®¡åˆ’æŒ‡å¯¼å®¤ é‚®æ”¿ç¼–ç : 200240', '', 'Shanghai Shi', NULL, 'China', NULL, NULL, 31.007075, 121.420572, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', 'aee0384e9238d080309c28a01aa3c9a9e0c148edbb279567208fcab37bae7275', '86', '13096883169', NULL),
(6, 'æžå®¢ä¾¿å½“ ', 10, 0, 10000, 'ä¸‰ä¸ªè€ç”·å­©çš„åˆ›ä¸šæ•…äº‹ï¼Œå†ä¸å¹²ç‚¹äº‹å°±è€äº†ï¼ŒæŠ“ä½é’æ˜¥çš„å°¾å·´ã€‚æˆ‘ä»¬ç”¨å¿ƒæŠŠå…³é£ŸæåŠé…æ–™ï¼Œç²¾å¿ƒçƒ¹åˆ¶ï¼Œè„šè¸å®žåœ°ï¼Œåšåˆ°æžè‡´ï¼', 'China', '', 'Minhang Qu', NULL, '800 Dong Chuan Lu', NULL, NULL, 31.0218816, 121.4309663, 1, '0', '884006e0cb074556c26c22e0aee3c6b7b5307adf192cb1775b4bef6303486c61', '86', '13096883169', NULL),
(7, 'æžå®¢ä¾¿å½“ ', 10, 0, 10000, 'ä¸‰ä¸ªè€ç”·å­©çš„åˆ›ä¸šæ•…äº‹ï¼Œå†ä¸å¹²ç‚¹äº‹å°±è€äº†ï¼ŒæŠ“ä½é’æ˜¥çš„å°¾å·´ã€‚æˆ‘ä»¬ç”¨å¿ƒæŠŠå…³é£ŸæåŠé…æ–™ï¼Œç²¾å¿ƒçƒ¹åˆ¶ï¼Œè„šè¸å®žåœ°ï¼Œåšåˆ°æžè‡´ï¼', 'China', '', 'Minhang Qu', NULL, '800 Dong Chuan Lu', NULL, NULL, 31.0218816, 121.4309663, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '247ccce33e9558df4666b2f8ebdcf31f8acfa47fbb79d1a91343f02283f8f388', '86', '13096883169', NULL),
(8, 'å°ä¹”', 50, 0, 10000, 'å°ä¹”å®—æ—¨ï¼šè®©æ‚¨åƒçš„å¹²å‡€&amp;middot;å¥åº·&amp;middot;å«ç”Ÿï¼Œåº”å¯¹ç”Ÿæ´»ä¸­çš„ä¸€åˆ‡æŒ‘æˆ˜ï¼~', 'China', '', 'Minhang Qu', NULL, '800 Dong Chuan Lu', NULL, NULL, 31.0218816, 121.4309663, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '6ce9700bba683d8ef6c10731dfa64242dbcf9f006ef4cd42cefc195630dd3e4b', '86', '13096883169', NULL),
(9, 'æ­£å®—æ²™åŽ¿å°åƒ', 15, 0, 10000, 'æ‚¨çš„æ”¯æŒæ˜¯æˆ‘ä»¬å‰è¿›çš„åŠ¨åŠ›ï¼Œæ‚¨çš„æ»¡æ„æ˜¯æˆ‘ä»¬æ°¸è¿œçš„è¿½æ±‚ï¼Œæˆ‘ä»¬ä¼šå°†ä¸æ‡ˆçš„è¿½æ±‚åŒ–ä¸ºæ°¸æ’çš„åŠ¨åŠ›ï¼Œåšå‡ºæœ€ç¾Žçš„ç¾Žé£Ÿï¼Œä»¥ä¿åŒå­¦ä»¬çš„æ»¡æ„', 'China', '', 'Minhang Qu', NULL, '889 Dong Chuan Lu', NULL, NULL, 31.016787, 121.429583, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '7bfeff713839c3dd5472677c6fc75024ae75724ab16ec59cf9cd58fc913dd4fc', '86', '13096883169', NULL),
(10, 'æ³¡æ³¡é¦™é¦™é¸¡.ç²¥.ä¾¿å½“', 20, 5, 10000, 'æ³¡æ³¡æ‰€æœ‰äº§å“å‡ä¸ºçŽ°åšçŽ°å–ï¼', 'China', '', 'Minhang Qu', NULL, '840 Dong Chuan Lu', NULL, NULL, 31.0177304, 121.4322453, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', 'd291bdac0b2b2693e97efa6d00bef2b7bfe8858f0d1ad95212594c241ff74ed3', '86', '13096883169', NULL),
(11, 'å•¤é…’é¸­é¥­', 30, 10, 10000, 'æ†¨å¤§å” ç»™åŠ›æ¯ä¸€å¤©ï¼å€¼å¾—ä½ æ‹¥æœ‰(*^__^*)', 'China', '', 'Minhang Qu', NULL, '811 Dong Chuan Lu', NULL, NULL, 31.0180851, 121.4336476, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '16eb04e6f154843bef1dfffcb42e734b8bafc91d4eb62a4506fd4613247f390f', '86', '13096883169', NULL),
(12, 'é¥­æœ‰å¼•åŠ›', 10, 0, 10000, 'æˆ‘ä»¬è‰¯å¿ƒç»è¥ï¼ŒåŠªåŠ›åšåˆ°è®©æ‚¨æ»¡æ„,å¸Œæœ›å¤šææ„è§ï¼Œè®©æˆ‘ä»¬æ…¢æ…¢å‘å‰è¿ˆè¿›ï¼ï¼ï¼', 'China', '', 'Minhang Qu', NULL, '375 Shi Ping Lu', NULL, NULL, 31.0171109, 121.4198246, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '206379db4227f79e2faa00fbc6fbb32ffdd7b4244b56d83af88ca29e9976182b', '86', '13096883169', NULL),
(13, 'å´”å¤§å¦ˆ', 10, 4, 10000, 'ç”¨ä¸­é¤ï¼Œå·¦æ‰‹æ‰§ç¢—ï¼Œå³æ‰‹æŒç­·', 'China', '', 'Minhang Qu', NULL, '811 Dong Chuan Lu', NULL, NULL, 31.0180851, 121.4336476, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '6f23f21851d85f949387fefcc40521c7209f54f2e25b90b124185c1e9a19f37b', '86', '13096883169', NULL),
(14, 'çŽ›ç‰¹å¿«é¤ ', 10, 2, 10000, 'æ–°åº—å¼€å¼ ï¼Œæ³¨é‡å“è´¨å’Œå£å‘³ï¼Œè®©æ‚¨åƒçš„å®‰å¿ƒï¼Œåƒçš„èˆ’å¿ƒã€‚', 'China', '', 'Minhang Qu', NULL, '805 Dong Chuan Lu', NULL, NULL, 31.0182305, 121.4341035, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '1c8f85a0eb09a5dc493e69deb6794dd832fcae282c848d7efc8ba5c87df337bd', '86', '13096883169', NULL);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 02, 2015 at 02:02 PM
-- Server version: 5.5.43-0ubuntu0.14.04.1-log
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

--
-- Dumping data for table `Customer`
--

INSERT INTO `Customer` (`customer_id_pk`, `region_code`, `national_number`, `last_name`, `first_name`, `nick`, `password`, `session_id`, `email`) VALUES
(1, '49', '3070143434', 'Sturm', 'Gerald', 'garrythestorm', '6787017c44f171579326c2207f82a3da', NULL, 'demo@kart4you.de'),
(2, '86', '14324389911', 'Yao', 'Lan', 'user', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(3, '86', '14232323989', 'Zhenfan', 'Li', 'dragonpunch1940', '2acf35c77fff945a69c2d79a2f8713fd', NULL, 'demo@kart4you.de'),
(4, '1', '7184572531', 'Branton', 'Gloria', 'bunnybee', '42a6b10b2c1daa800a25f3e740edb2b3', NULL, 'demo@kart4you.de'),
(5, '1', '2126844814', 'John', 'Thomas H.', 'johnny', '229657d8b627ffd14a3bccca1a0f9b6e', NULL, 'demo@kart4you.de'),
(6, '86', '13133349212', 'Li', 'Han', 'newby', '2dbbd680949db33f7912382d10459dd0c28c37e5', NULL, 'demo@kart4you.de'),
(7, '86', '15580305935', 'I.M.', 'Pei', 'impei', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(8, '86', '15718679133', 'Guan', 'Tianlang', 'chinesetiger', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(9, '86', '15580305935', 'Charles', 'Ng', 'murder', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(10, '86', '11230305935', 'Du', 'Fu', 'poet', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(11, '86', '18311515308i', 'Yip', 'Man', 'laoshi', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(12, '86', '16533991188', 'Ming', 'Na', 'mingi', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(13, '86', '11446454529', 'Jiang', 'Qing', 'theadvisor', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(14, '86', '16577356513', 'Ding', 'Ling', 'jiangqu', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de');
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 02, 2015 at 02:49 PM
-- Server version: 5.5.43-0ubuntu0.14.04.1-log
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

--
-- Dumping data for table `Meal`
--

INSERT INTO `Meal` (`meal_id_pk`, `Restaurant_restaurant_id`, `name`, `price`, `description`, `spiciness`, `offered`) VALUES
(1, 1, 'Jidan Guangbing', '8', 'Turnover filled with Jidan', 1, 1),
(2, 1, 'Cai Bing without egg', '6', 'A regular Cai Bing without egg', 0, 1),
(3, 1, 'Jingbing', '7', 'Jingbing with egg', 1, 1),
(4, 2, 'Salad', '20', 'Salad with tomatoes, olives and onions ', 0, 1),
(5, 2, 'Veggie Burger', '70', 'Veggie Burger with tofu and salad and pickles.', 0, 1),
(6, 2, 'Soya Ice Cream', '30', 'Ice cream made with soya instead of milk', 0, 1),
(7, 3, 'Vegetable Kebab', '18', 'Mustafas famous vegetable kebab', 1, 1),

(8, 6, 'Sour Beef', '14', NULL , 0, 1),
(9, 6, 'Shredded Cabbage', '9', NULL , 1, 1),
(10, 6, 'Fragrant Duck', '14', NULL , 1, 1),
(11, 6, 'Rice', '2', NULL , 0, 1),
(12, 6, 'Spicy Chicken', '14', NULL , 3, 1),
(13, 6, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(14, 6, 'Mapo Tofu', '9', NULL , 2, 1),

(15, 7, 'Sour Beef', '14', NULL , 0, 1),
(16, 7, 'Shredded Cabbage', '9', NULL , 1, 1),
(17, 7, 'Fragrant Duck', '14', NULL , 1, 1),
(18, 7, 'Rice', '2', NULL , 0, 1),
(19, 7, 'Spicy Chicken', '14', NULL , 3, 1),
(20, 7, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(21, 7, 'Mapo Tofu', '9', NULL , 2, 1),

(22, 8, 'Sour Beef', '14', NULL , 0, 1),
(23, 8, 'Shredded Cabbage', '9', NULL , 1, 1),
(24, 8, 'Fragrant Duck', '14', NULL , 1, 1),
(25, 8, 'Rice', '2', NULL , 0, 1),
(26, 8, 'Spicy Chicken', '14', NULL , 3, 1),
(27, 8, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(28, 8, 'Mapo Tofu', '9', NULL , 2, 1),

(29, 9, 'Sour Beef', '14', NULL , 0, 1),
(30, 9, 'Shredded Cabbage', '9', NULL , 1, 1),
(31, 9, 'Fragrant Duck', '14', NULL , 1, 1),
(32, 9, 'Rice', '2', NULL , 0, 1),
(33, 9, 'Spicy Chicken', '14', NULL , 3, 1),
(34, 9, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(35, 9, 'Mapo Tofu', '9', NULL , 2, 1),

(36, 10, 'Sour Beef', '14', NULL , 0, 1),
(37, 10, 'Shredded Cabbage', '9', NULL , 1, 1),
(38, 10, 'Fragrant Duck', '14', NULL , 1, 1),
(39, 10, 'Rice', '2', NULL , 0, 1),
(40, 10, 'Spicy Chicken', '14', NULL , 3, 1),
(41, 10, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(42, 10, 'Mapo Tofu', '9', NULL , 2, 1),

(43, 11, 'Sour Beef', '14', NULL , 0, 1),
(44, 11, 'Shredded Cabbage', '9', NULL , 1, 1),
(45, 11, 'Fragrant Duck', '14', NULL , 1, 1),
(46, 11, 'Rice', '2', NULL , 0, 1),
(47, 11, 'Spicy Chicken', '14', NULL , 3, 1),
(48, 11, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(49, 11, 'Mapo Tofu', '9', NULL , 2, 1),

(50, 12, 'Sour Beef', '14', NULL , 0, 1),
(51, 12, 'Shredded Cabbage', '9', NULL , 1, 1),
(52, 12, 'Fragrant Duck', '14', NULL , 1, 1),
(53, 12, 'Rice', '2', NULL , 0, 1),
(54, 12, 'Spicy Chicken', '14', NULL , 3, 1),
(55, 12, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(56, 12, 'Mapo Tofu', '9', NULL , 2, 1),

(57, 13, 'Sour Beef', '14', NULL , 0, 1),
(58, 13, 'Shredded Cabbage', '9', NULL , 1, 1),
(59, 13, 'Fragrant Duck', '14', NULL , 1, 1),
(60, 13, 'Rice', '2', NULL , 0, 1),
(61, 13, 'Spicy Chicken', '14', NULL , 3, 1),
(62, 13, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(63, 13, 'Mapo Tofu', '9', NULL , 2, 1),

(64, 14, 'Sour Beef', '14', NULL , 0, 1),
(65, 14, 'Shredded Cabbage', '9', NULL , 1, 1),
(66, 14, 'Fragrant Duck', '14', NULL , 1, 1),
(67, 14, 'Rice', '2', NULL , 0, 1),
(68, 14, 'Spicy Chicken', '14', NULL , 3, 1),
(69, 14, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(70, 14, 'Mapo Tofu', '9', NULL , 2, 1),

(71, 4, 'Super Extreme Bisa Pu + Italian caviar fan Beibisapu', '66.5', NULL , 1, 1),
(72, 4, 'Super Supreme pizza large + Italian caviar fan Bei Bisa large', '98.5', NULL , 2, 1),
(73, 4, 'Seafood supreme Bisa Pu + Korean beef Bisa Pu Zhen', '69.5', NULL , 1, 1),
(74, 4, 'Korean beef Bisa Pu Zhen', '98.5', NULL , 3, 1),
(75, 4, 'Mango Pineapple', '12', NULL , 0, 1),

(76, 5, 'New Orleans roast wings', '11', NULL , 2, 1),
(77, 5, 'Hibiscus fresh vegetable soup', '6', NULL , 2, 1),
(78, 5, 'Corn salad', '5', NULL , 2, 1),
(79, 5, 'Old Beijing Chicken Roll', '15', NULL , 2, 1),
(80, 5, 'Spicy chicken wings (2)', '10', NULL , 2, 1);
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 02, 2015 at 04:22 PM
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

--
-- Dumping data for table `Meal_Tag_Map`
--

INSERT INTO `Meal_Tag_Map` (`Meal_meal_id_pk`, `Tag_tag_id_pk`) VALUES
(1, 1),
(2, 1),
(3, 1),
(2, 2),

(9,2),
(11,2),
(13,1),
(14,2),

(16,2),
(18,2),
(20,1),
(21,2),

(23,2),
(25,2),
(27,1),
(28,2),

(30,2),
(32,2),
(34,1),
(35,2),

(37,2),
(39,2),
(41,1),
(42,2),

(44,2),
(46,2),
(48,1),
(49,2),

(51,2),
(53,2),
(55,1),
(56,2),

(58,2),
(60,2),
(62,1),
(63,2),

(65,2),
(67,2),
(69,1),
(70,2),

(75,2),

(77,1),
(78,2);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 02, 2015 at 08:16 PM
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

--
-- Dumping data for table `Delivery`
--

INSERT INTO `Delivery` (`delivery_id_pk`, `Customer_customer_id`, `Restaurant_restaurant_id`, `country`, `postcode`, `city`, `district`, `street_name`, `street_number`, `add_info`, `comment`) VALUES
(1, 2, 1, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '723', NULL, NULL),
(2, 3, 2, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '654', NULL, NULL),
(3, 2, 2, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '723', NULL, NULL),

(4, 7, 4, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '724', NULL, NULL),
(5, 8, 5, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '725', NULL, NULL),
(6, 9, 6, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '726', NULL, NULL),
(7, 10, 7, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '727', NULL, NULL),
(8, 11, 8, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '728', NULL, NULL),
(9, 12, 9, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '729', NULL, NULL),
(10, 13, 10, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '730', NULL, NULL),
(11, 14, 11, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '731', NULL, NULL),

(12, 7, 12, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '724', NULL, NULL),
(13, 8, 13, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '725', NULL, NULL),
(14, 9, 14, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '726', NULL, NULL),

(15, 10, 4, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '727', NULL, NULL),
(16, 11, 8, 'China', '200030', 'Shanghai', 'Minhang', 'Dongchuan Road', '728', NULL, NULL);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 02, 2015 at 08:30 PM
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

--
-- Dumping data for table `Delivery_State`
--

INSERT INTO `Delivery_State` (`Delivery_delivery_id_pk`, `date_pk`, `Delivery_State_Type_delivery_status_type`, `comment`) VALUES
(1, '2015-05-01 18:08:10', 1, NULL),
(1, '2015-05-01 18:10:12', 2, NULL),
(1, '2015-05-01 18:25:44', 3, NULL),
(1, '2015-05-01 18:43:38', 4, NULL),
(2, '2015-05-24 12:08:10', 1, NULL),
(2, '2015-05-24 13:10:21', 2, NULL),
(2, '2015-05-24 13:45:56', 3, NULL),
(2, '2015-05-24 14:20:43', 4, NULL),
(3, '2015-06-10 17:08:42', 1, NULL),
(3, '2015-06-10 18:10:23', 2, NULL),
(3, '2015-06-10 18:55:44', 3, NULL),

(4, '2015-07-01 16:12:02', 1, NULL),
(4, '2015-07-01 16:42:02', 2, NULL),
(4, '2015-07-01 17:12:02', 3, NULL),
(4, '2015-07-01 17:32:02', 4, NULL),

(5, '2015-07-01 16:12:02', 1, NULL),
(5, '2015-07-01 16:42:02', 2, NULL),
(5, '2015-07-01 17:12:02', 3, NULL),
(5, '2015-07-01 17:32:02', 4, NULL),

(6, '2015-07-01 16:12:02', 1, NULL),
(6, '2015-07-01 16:42:02', 2, NULL),
(6, '2015-07-01 17:12:02', 3, NULL),
(6, '2015-07-01 17:32:02', 4, NULL),

(7, '2015-07-01 16:12:02', 1, NULL),
(7, '2015-07-01 16:42:02', 2, NULL),
(7, '2015-07-01 17:12:02', 3, NULL),
(7, '2015-07-01 17:32:02', 4, NULL),

(8, '2015-07-01 16:12:02', 1, NULL),
(8, '2015-07-01 16:42:02', 2, NULL),
(8, '2015-07-01 17:12:02', 3, NULL),
(8, '2015-07-01 17:32:02', 4, NULL),

(9, '2015-07-01 16:12:02', 1, NULL),
(9, '2015-07-01 16:42:02', 2, NULL),
(9, '2015-07-01 17:12:02', 3, NULL),
(9, '2015-07-01 17:32:02', 4, NULL),

(10, '2015-07-01 16:12:02', 1, NULL),
(10, '2015-07-01 16:42:02', 2, NULL),
(10, '2015-07-01 17:12:02', 3, NULL),
(10, '2015-07-01 17:32:02', 4, NULL),

(11, '2015-07-01 16:12:02', 1, NULL),
(11, '2015-07-01 16:42:02', 2, NULL),
(11, '2015-07-01 17:12:02', 3, NULL),
(11, '2015-07-01 17:32:02', 4, NULL),


(12, '2015-07-02 11:12:02', 1, NULL),
(12, '2015-07-02 11:42:02', 2, NULL),
(12, '2015-07-02 12:12:02', 3, NULL),
(12, '2015-07-02 12:32:02', 4, NULL),

(13, '2015-07-02 16:12:02', 1, NULL),
(13, '2015-07-02 16:42:02', 2, NULL),

(14, '2015-07-02 16:12:02', 1, NULL),
(14, '2015-07-02 16:42:02', 2, NULL),
(14, '2015-07-02 17:12:02', 3, NULL),

(15, '2015-07-02 16:12:02', 1, NULL),

(16, '2015-07-02 16:12:02', 1, NULL),
(16, '2015-07-02 16:42:02', 2, NULL),
(16, '2015-07-02 17:12:02', 3, NULL),
(16, '2015-07-02 17:15:03', 4, NULL);


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 02, 2015 at 08:31 PM
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

--
-- Dumping data for table `Delivery_Meal_Map`
--

INSERT INTO `Delivery_Meal_Map` (`Delivery_delivery_id_pk`, `Meal_meal_id_pk`, `amount`) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 2),
(2, 5, 1),
(2, 6, 2),
(3, 5, 3),

(4,71,1),

(5,78,1),
(5,79,2),
(5,80,2),

(6,14,1),
(6,13,1),

(7,16,1),
(7,21,2),

(8,22,5),
(8,24,3),

(9,30,2),
(9,31,2),
(9,33,2),

(10,38,1),

(11,47,10),

(12,53,1),

(13,60,2),

(14,65,7),

(15,73,1),
(15,74,1),
(15,75,1),

(16,28,100);

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
(1, 2, '2015-05-01 18:43:22', 4, 'really tasty, but a bit salty'),
(3, 2, '2015-05-05 12:14:54', 3, 'Really good, but way too expensive'),
(5, 3, '2015-05-13 17:00:00', 5, 'Good, a!'),
(6, 3, '2015-05-24 17:00:04', 5, 'Hen Good!');

/*
(1, 2, '2015-05-05 18:43:22', 4, 'really tasty, but a bit salty'),
(4, 2, '2015-05-10 12:14:54', 3, 'Really good, but way too expensive'),
(6, 2, '2015-05-05 12:15:32', 5, 'Mhmmm... tasty'),
(1, 3, '2015-05-02 20:08:56', 2, 'Really did not like the one without egg'),
(2, 3, '2015-05-15 17:00:01', 3, 'Okeh!'),
(3, 3, '2015-05-12 17:00:00', 4, 'Good!'),
(4, 3, '2015-05-14 17:00:01', 5, 'Hen Good!'),
(5, 3, '2015-05-13 17:00:00', 5, 'Good, a!');
*/

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- joins the Delivery_State with Delivery_State_Type together

CREATE VIEW Delivery_State_View AS 
SELECT Delivery_delivery_id_pk, date_pk, name as delivery_status_type, comment
FROM Delivery_State ds
INNER JOIN Delivery_State_Type dst ON ds.Delivery_State_Type_delivery_status_type = dst.delivery_status_type_id_pk;

-- joins the Delivery with Delivery_State together

CREATE VIEW Delivery_View AS 
SELECT d . * , ds.date_pk, Delivery_State_Type_delivery_status_type AS delivery_status_type_number, name AS delivery_status_type, ds.comment AS delivery_state_comment
FROM Delivery_State ds
INNER JOIN Delivery_State_Type dst ON ds.Delivery_State_Type_delivery_status_type = dst.delivery_status_type_id_pk
INNER JOIN Delivery d ON d.delivery_id_pk = ds.Delivery_delivery_id_pk;
-- Constraints Delivery_Meal_Map
DELIMITER $$
CREATE TRIGGER delivery_meal_map_constraints BEFORE INSERT ON Delivery_Meal_Map FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    IF !(NEW.amount > 0) THEN
        SET msg = "DIE: You inserted a resctricted VALUE";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;
$$
DELIMITER ;
-- Constraints for restaurant

DELIMITER $$
CREATE TRIGGER restaurant_constraints BEFORE INSERT ON Restaurant FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    IF !(NEW.shipping_cost >= 0 &&
        NEW.min_order_value >= 0 &&
        NEW.max_delivery_range >= 0 &&
        NEW.position_lat >= 0 &&
        NEW.position_long >= 0)
    THEN
        SET msg = "DIE: You inserted a resctricted VALUE";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;
$$
DELIMITER ;
-- Constraints for Meal
DELIMITER $$
CREATE TRIGGER meal_constraints BEFORE INSERT ON Meal FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);
    IF !(NEW.price >= 0 &&
        NEW.spiciness <= 3 &&
        NEW.spiciness >= 0)
    THEN
        SET msg = "DIE: You inserted a resctricted VALUE";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER rating_constraints BEFORE INSERT ON Rating FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(255);

    -- Gets a Table with all the Meals from the customer and checks if the one which is needed for the rating is presente
    SELECT COUNT( * ) INTO @o_existent
    FROM (

        SELECT dmm.Meal_meal_id_pk
        FROM Delivery_Meal_Map dmm
        INNER JOIN (

            SELECT * 
            FROM Delivery_View
            WHERE Customer_customer_id = NEW.Customer_customer_id_pk && delivery_status_type_number = 4
        )d ON d.delivery_id_pk = dmm.Delivery_delivery_id_pk
    )ddmm
    WHERE ddmm.Meal_meal_id_pk = NEW.Meal_meal_id_pk;

    IF !(NEW.rating >= 0 &&
        NEW.rating <= 5 &&
        @o_existent = 1)
    THEN
        SET msg = "DIE: You inserted a resctricted VALUE";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;
$$
DELIMITER ;
