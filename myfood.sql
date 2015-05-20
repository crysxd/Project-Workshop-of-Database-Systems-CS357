SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`restaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`restaurant` (
  `restaurant_id_pk` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `min_order_value` FLOAT NULL,
  `shipping_cost` FLOAT NULL COMMENT 'must be >= 0\n',
  `max_delivery_range` FLOAT NULL COMMENT 'in kilometers, \nadditional enums like:\ncitys, districts\nin 100 meter steps',
  `icon` TEXT NULL DEFAULT NULL,
  `street` VARCHAR(256) NULL COMMENT 'http://www.bitboost.com/ref/international-address-formats/prc-china/',
  `postcode` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `district` VARCHAR(45) NULL,
  `province` VARCHAR(256) NULL,
  `position_lat` FLOAT NULL,
  `position_long` FLOAT NULL,
  `password` VARCHAR(256) NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`restaurant_id_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`customer` (
  `phone_pk` VARCHAR(45) NOT NULL COMMENT 'used as identifer.\nthere may be no two users with the same number\nhas to be double because with in we just can represent 10 digits, but chinese phone numbers have 11 digits\na list as representation would take more space',
  `first_name` VARCHAR(45) NULL,
  `sure_name` VARCHAR(45) NULL,
  `nick` VARCHAR(45) NULL DEFAULT 'Name' COMMENT 'the nickname of the user\ndefault is combination of name',
  `street` VARCHAR(45) NULL,
  `postcode` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `district` VARCHAR(45) NULL,
  `province` VARCHAR(45) NULL,
  `password` VARCHAR(256) NULL,
  PRIMARY KEY (`phone_pk`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dish`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dish` (
  `dish_id_pk` INT NOT NULL,
  `restaurant_restaurant_id_fk` INT NOT NULL,
  `name` VARCHAR(256) NULL,
  `price` VARCHAR(45) NULL,
  `dish_category_id` INT NULL,
  `description` TEXT NULL DEFAULT NULL COMMENT 'optional',
  PRIMARY KEY (`dish_id_pk`),
  INDEX `fk_Menu_Restaurant1_idx` (`restaurant_restaurant_id_fk` ASC),
  CONSTRAINT `fk_Menu_Restaurant1`
    FOREIGN KEY (`restaurant_restaurant_id_fk`)
    REFERENCES `mydb`.`restaurant` (`restaurant_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`opening_time`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`opening_time` (
  `opening_time_id_pk` INT NOT NULL,
  `day_id` INT NULL COMMENT 'allow enums like weekday, weekend',
  `starting_time` INT NULL COMMENT 'i would save starting time an closing time as int\nlike this representation 1030 = 10:30',
  `closing_time` INT NULL,
  PRIMARY KEY (`opening_time_id_pk`),
  INDEX `day_id_fk` (`day_id` ASC))
ENGINE = InnoDB
COMMENT = 'a restaurant may have multiple opening times';


-- -----------------------------------------------------
-- Table `mydb`.`delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`delivery` (
  `delivery_id_pk` INT NOT NULL,
  `restaurant_restaurant_id_fk` INT NOT NULL,
  `customer_phone_fk` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`delivery_id_pk`),
  INDEX `fk_User_has_Restaurant_Restaurant1_idx` (`restaurant_restaurant_id_fk` ASC),
  INDEX `fk_delivery_users1_idx` (`customer_phone_fk` ASC),
  CONSTRAINT `fk_User_has_Restaurant_Restaurant1`
    FOREIGN KEY (`restaurant_restaurant_id_fk`)
    REFERENCES `mydb`.`restaurant` (`restaurant_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery_users1`
    FOREIGN KEY (`customer_phone_fk`)
    REFERENCES `mydb`.`customer` (`phone_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`rating` (
  `dish_dish_id_fk` INT NOT NULL,
  `customer_phone_fk` VARCHAR(45) NOT NULL,
  `date` DATETIME NULL,
  `rating` SMALLINT NULL COMMENT 'smallint because the number will not be bigger than 10',
  `comment` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`customer_phone_fk`, `dish_dish_id_fk`),
  INDEX `fk_Rating_dish1_idx` (`dish_dish_id_fk` ASC),
  INDEX `fk_Rating_user1_idx` (`customer_phone_fk` ASC),
  CONSTRAINT `fk_Rating_dish1`
    FOREIGN KEY (`dish_dish_id_fk`)
    REFERENCES `mydb`.`dish` (`dish_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Rating_user1`
    FOREIGN KEY (`customer_phone_fk`)
    REFERENCES `mydb`.`customer` (`phone_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`delivery_state_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`delivery_state_type` (
  `delivery_status_type_id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`delivery_status_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`delivery_state`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`delivery_state` (
  `delivery_delivery_id_pk` INT NOT NULL,
  `date_pk` DATETIME NOT NULL,
  `delivery_state_type_delivery_status_type_fk` INT NOT NULL,
  `comment` VARCHAR(256) NULL,
  PRIMARY KEY (`delivery_delivery_id_pk`, `date_pk`),
  INDEX `fk_DeliveryState_delivery1_idx` (`delivery_delivery_id_pk` ASC),
  INDEX `fk_delivery_state_delivery_state_type1_idx` (`delivery_state_type_delivery_status_type_fk` ASC),
  CONSTRAINT `fk_DeliveryState_delivery1`
    FOREIGN KEY (`delivery_delivery_id_pk`)
    REFERENCES `mydb`.`delivery` (`delivery_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery_state_delivery_state_type1`
    FOREIGN KEY (`delivery_state_type_delivery_status_type_fk`)
    REFERENCES `mydb`.`delivery_state_type` (`delivery_status_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`restaurant_opening_time_map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`restaurant_opening_time_map` (
  `restaurant_opening_time_map_id_pk` INT NOT NULL,
  `restaurant_restaurant_id_fk` INT NOT NULL,
  `restaurant_opening_time_id_pk` INT NOT NULL,
  PRIMARY KEY (`restaurant_opening_time_map_id_pk`),
  INDEX `fk_restaurants_has_opening_times_opening_times1_idx` (`restaurant_opening_time_id_pk` ASC),
  INDEX `fk_restaurants_has_opening_times_restaurants1_idx` (`restaurant_restaurant_id_fk` ASC),
  CONSTRAINT `fk_restaurants_has_opening_times_restaurants1`
    FOREIGN KEY (`restaurant_restaurant_id_fk`)
    REFERENCES `mydb`.`restaurant` (`restaurant_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_restaurants_has_opening_times_opening_times1`
    FOREIGN KEY (`restaurant_opening_time_id_pk`)
    REFERENCES `mydb`.`opening_time` (`opening_time_id_pk`)
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
-- Table `mydb`.`delivery_dish_map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`delivery_dish_map` (
  `delivery_delivery_id_pk` INT NOT NULL,
  `dish_dish_id_pk` INT NOT NULL,
  `amount` INT NULL,
  PRIMARY KEY (`delivery_delivery_id_pk`, `dish_dish_id_pk`),
  INDEX `fk_delivery_has_dish_dish1_idx` (`dish_dish_id_pk` ASC),
  INDEX `fk_delivery_has_dish_delivery1_idx` (`delivery_delivery_id_pk` ASC),
  CONSTRAINT `fk_delivery_has_dish_delivery1`
    FOREIGN KEY (`delivery_delivery_id_pk`)
    REFERENCES `mydb`.`delivery` (`delivery_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery_has_dish_dish1`
    FOREIGN KEY (`dish_dish_id_pk`)
    REFERENCES `mydb`.`dish` (`dish_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tag` (
  `tag_id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `color` VARCHAR(6) NULL,
  PRIMARY KEY (`tag_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dish_tag_map`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dish_tag_map` (
  `dish_dish_id_pk` INT NOT NULL,
  `tag_tag_id` INT NOT NULL,
  PRIMARY KEY (`dish_dish_id_pk`, `tag_tag_id`),
  INDEX `fk_dish_has_tag_tag1_idx` (`tag_tag_id` ASC),
  INDEX `fk_dish_has_tag_dish1_idx` (`dish_dish_id_pk` ASC),
  CONSTRAINT `fk_dish_has_tag_dish1`
    FOREIGN KEY (`dish_dish_id_pk`)
    REFERENCES `mydb`.`dish` (`dish_id_pk`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dish_has_tag_tag1`
    FOREIGN KEY (`tag_tag_id`)
    REFERENCES `mydb`.`tag` (`tag_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
