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
  `region_code` VARCHAR(3) NULL,
  `national_number` VARCHAR(15) NULL,
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
