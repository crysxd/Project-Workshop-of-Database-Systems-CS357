SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Restaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Restaurant` (
  `restaurant_id_pk` INT NOT NULL,
  `name` VARCHAR(256) NULL,
  `min_order_value` FLOAT NULL,
  `shipping_cost` FLOAT NULL COMMENT 'must be >= 0\n',
  `max_delivery_range` FLOAT NULL COMMENT 'in kilometers, \nadditional enums like:\ncitys, districts\nin 100 meter steps',
  `icon_name` VARCHAR(256) NULL DEFAULT NULL,
  `street` VARCHAR(256) NULL COMMENT 'http://www.bitboost.com/ref/international-address-formats/prc-china/',
  `postcode` VARCHAR(45) NULL,
  `city` VARCHAR(256) NULL,
  `province` VARCHAR(256) NULL,
  `add_info` VARCHAR(256) NULL,
  `position_lat` FLOAT NULL,
  `position_long` FLOAT NULL,
  `password` VARCHAR(256) NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`restaurant_id_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Customer` (
  `phone_pk` VARCHAR(45) NOT NULL COMMENT 'used as identifer.\nthere may be no two users with the same number\nhas to be double because with in we just can represent 10 digits, but chinese phone numbers have 11 digits\na list as representation would take more space',
  `first_name` VARCHAR(256) NULL,
  `sure_name` VARCHAR(256) NULL,
  `nick` VARCHAR(45) NULL DEFAULT 'Name' COMMENT 'the nickname of the user\ndefault is combination of name',
  `street` VARCHAR(256) NULL COMMENT 'with house\nnumber\n',
  `postcode` VARCHAR(45) NULL,
  `city` VARCHAR(256) NULL,
  `province` VARCHAR(256) NULL,
  `add_info` VARCHAR(256) NULL,
  `password` VARCHAR(256) NULL,
  PRIMARY KEY (`phone_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dish`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dish` (
  `dish_id_pk` INT NOT NULL,
  `Restaurant_restaurant_id` INT NOT NULL,
  `name` VARCHAR(256) NULL,
  `price` VARCHAR(45) NULL,
  `dish_category_id` INT NULL,
  `description` TEXT NULL DEFAULT NULL COMMENT 'optional',
  `spiciness` INT NULL COMMENT 'Range 0-3',
  `icon_name` VARCHAR(256) NULL,
  PRIMARY KEY (`dish_id_pk`),
  INDEX `fk_Menu_Restaurant1_idx` (`Restaurant_restaurant_id` ASC),
  CONSTRAINT `fk_Menu_Restaurant1`
    FOREIGN KEY (`Restaurant_restaurant_id`)
    REFERENCES `mydb`.`Restaurant` (`restaurant_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Opening_Time`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Opening_Time` (
  `opening_time_id_pk` INT NOT NULL,
  `day_id` INT NULL COMMENT 'allow enums like weekday, weekend',
  `starting_time` INT NULL COMMENT 'i would save starting time an closing time as int\nlike this representation 1030 = 10:30',
  `closing_time` INT NULL,
  PRIMARY KEY (`opening_time_id_pk`),
  INDEX `day_id_fk` (`day_id` ASC))
ENGINE = InnoDB
COMMENT = 'a restaurant may have multiple opening times';


-- -----------------------------------------------------
-- Table `mydb`.`Delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Delivery` (
  `delivery_id_pk` INT NOT NULL,
  `Restaurant_restaurant_id` INT NOT NULL,
  `Customer_phone` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`delivery_id_pk`),
  INDEX `fk_User_has_Restaurant_Restaurant1_idx` (`Restaurant_restaurant_id` ASC),
  INDEX `fk_delivery_users1_idx` (`Customer_phone` ASC),
  CONSTRAINT `fk_User_has_Restaurant_Restaurant1`
    FOREIGN KEY (`Restaurant_restaurant_id`)
    REFERENCES `mydb`.`Restaurant` (`restaurant_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery_users1`
    FOREIGN KEY (`Customer_phone`)
    REFERENCES `mydb`.`Customer` (`phone_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Rating` (
  `Dish_dish_id_pk` INT NOT NULL,
  `Customer_phone_pk` VARCHAR(45) NOT NULL,
  `date` DATETIME NULL,
  `rating` SMALLINT NULL COMMENT 'smallint because the number will not be bigger than 10',
  `comment` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`Customer_phone_pk`, `Dish_dish_id_pk`),
  INDEX `fk_Rating_dish1_idx` (`Dish_dish_id_pk` ASC),
  INDEX `fk_Rating_user1_idx` (`Customer_phone_pk` ASC),
  CONSTRAINT `fk_Rating_dish1`
    FOREIGN KEY (`Dish_dish_id_pk`)
    REFERENCES `mydb`.`dish` (`dish_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Rating_user1`
    FOREIGN KEY (`Customer_phone_pk`)
    REFERENCES `mydb`.`Customer` (`phone_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Every user can rate a dish just once';


-- -----------------------------------------------------
-- Table `mydb`.`Delivery_State_Type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Delivery_State_Type` (
  `delivery_status_type_id_pk` INT NOT NULL,
  `name` VARCHAR(256) NULL,
  PRIMARY KEY (`delivery_status_type_id_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Delivery_State`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Delivery_State` (
  `Delivery_delivery_id_pk` INT NOT NULL,
  `date_pk` DATETIME NOT NULL,
  `Delivery_State_Type_delivery_status_type_fk` INT NOT NULL,
  `comment` VARCHAR(256) NULL,
  PRIMARY KEY (`Delivery_delivery_id_pk`, `date_pk`),
  INDEX `fk_DeliveryState_delivery1_idx` (`Delivery_delivery_id_pk` ASC),
  INDEX `fk_delivery_state_delivery_state_type1_idx` (`Delivery_State_Type_delivery_status_type_fk` ASC),
  CONSTRAINT `fk_DeliveryState_delivery1`
    FOREIGN KEY (`Delivery_delivery_id_pk`)
    REFERENCES `mydb`.`Delivery` (`delivery_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery_state_delivery_state_type1`
    FOREIGN KEY (`Delivery_State_Type_delivery_status_type_fk`)
    REFERENCES `mydb`.`Delivery_State_Type` (`delivery_status_type_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Restaurant_Opening_Time_Map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Restaurant_Opening_Time_Map` (
  `restaurant_opening_time_map_id_pk` INT NOT NULL,
  `Restaurant_restaurant_id` INT NOT NULL,
  `Opening_Time_opening_time_id` INT NOT NULL,
  PRIMARY KEY (`restaurant_opening_time_map_id_pk`),
  INDEX `fk_restaurants_has_opening_times_opening_times1_idx` (`Opening_Time_opening_time_id` ASC),
  INDEX `fk_restaurants_has_opening_times_restaurants1_idx` (`Restaurant_restaurant_id` ASC),
  CONSTRAINT `fk_restaurants_has_opening_times_restaurants1`
    FOREIGN KEY (`Restaurant_restaurant_id`)
    REFERENCES `mydb`.`Restaurant` (`restaurant_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_restaurants_has_opening_times_opening_times1`
    FOREIGN KEY (`Opening_Time_opening_time_id`)
    REFERENCES `mydb`.`Opening_Time` (`opening_time_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dish_tag_dish_map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dish_tag_dish_map` (
  `dish_tag_dish_id_pk` INT NOT NULL,
  `dish_dish_id_fk` INT NOT NULL,
  `dish_tag_id` INT NULL,
  PRIMARY KEY (`dish_tag_dish_id_pk`),
  INDEX `fk_dish_tag_has_dish_dish1_idx` (`dish_dish_id_fk` ASC),
  CONSTRAINT `fk_dish_tag_has_dish_dish1`
    FOREIGN KEY (`dish_dish_id_fk`)
    REFERENCES `mydb`.`dish` (`dish_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Delivery_Dish_Map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Delivery_Dish_Map` (
  `Delivery_delivery_id_pk` INT NOT NULL,
  `Dish_dish_id_pk` INT NOT NULL,
  `amount` INT NULL,
  PRIMARY KEY (`Delivery_delivery_id_pk`, `Dish_dish_id_pk`),
  INDEX `fk_delivery_has_dish_dish1_idx` (`Dish_dish_id_pk` ASC),
  INDEX `fk_delivery_has_dish_delivery1_idx` (`Delivery_delivery_id_pk` ASC),
  CONSTRAINT `fk_delivery_has_dish_delivery1`
    FOREIGN KEY (`Delivery_delivery_id_pk`)
    REFERENCES `mydb`.`Delivery` (`delivery_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery_has_dish_dish1`
    FOREIGN KEY (`Dish_dish_id_pk`)
    REFERENCES `mydb`.`dish` (`dish_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Tag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Tag` (
  `tag_id_pk` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `color` VARCHAR(6) NULL,
  PRIMARY KEY (`tag_id_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Dish_Tag_Map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Dish_Tag_Map` (
  `Dish_dish_id_pk` INT NOT NULL,
  `Tag_tag_id_pk` INT NOT NULL,
  PRIMARY KEY (`Dish_dish_id_pk`, `Tag_tag_id_pk`),
  INDEX `fk_dish_has_tag_tag1_idx` (`Tag_tag_id_pk` ASC),
  INDEX `fk_dish_has_tag_dish1_idx` (`Dish_dish_id_pk` ASC),
  CONSTRAINT `fk_dish_has_tag_dish1`
    FOREIGN KEY (`Dish_dish_id_pk`)
    REFERENCES `mydb`.`dish` (`dish_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dish_has_tag_tag1`
    FOREIGN KEY (`Tag_tag_id_pk`)
    REFERENCES `mydb`.`Tag` (`tag_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'A dish is never tagged twice with the same tag';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;