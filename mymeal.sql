-- phpMyAdmin SQL Dump
-- version 4.4.8
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Tempo de geração: 10/06/2015 às 12:36
-- Versão do servidor: 5.6.24
-- Versão do PHP: 5.6.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Banco de dados: `mymeal`
--

DELIMITER $$
--
-- Funções
--
CREATE DEFINER=`root`@`localhost` FUNCTION `DISTANCE`(lat1 DOUBLE, long1 DOUBLE, lat2 DOUBLE, long2 DOUBLE) RETURNS float
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
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `Customer`
--

CREATE TABLE IF NOT EXISTS `Customer` (
  `customer_id_pk` int(11) NOT NULL COMMENT 'used as identifer.\nthere may be no two users with the same number\nhas to be double because with in we just can represent 10 digits, but chinese phone numbers have 11 digits\na list as representation would take more space',
  `region_code` varchar(3) DEFAULT NULL COMMENT 'the region code of the phone number',
  `national_number` varchar(15) DEFAULT NULL,
  `last_name` varchar(256) DEFAULT NULL,
  `first_name` varchar(256) DEFAULT NULL,
  `nick` varchar(45) NOT NULL DEFAULT 'Name' COMMENT 'the nickname of the user\ndefault is combination of name',
  `password` varchar(256) DEFAULT NULL,
  `session_id` varchar(64) DEFAULT NULL COMMENT 'unique and truly random 256 key'
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Fazendo dump de dados para tabela `Customer`
--

INSERT INTO `Customer` (`customer_id_pk`, `region_code`, `national_number`, `last_name`, `first_name`, `nick`, `password`, `session_id`) VALUES
(1, '49', '3070143434', 'Sturm', 'Gerald', 'garrythestorm', 'PASSWORD1', 'SESSIONC1'),
(2, '86', '14324389911', 'Yao', 'Lan', 'localj', 'PASSWORD2', 'SESSIONC2'),
(3, '86', '14232323989', 'Zhènfán', 'Lǐ', 'dragon_punch_1940', 'PASSWORD', 'SESSIONC4'),
(4, '1', '7184572531', 'Branton', 'Gloria', 'bunnybee', 'PASSWORD', 'SESSIONC4'),
(5, '1', '2126844814', 'John', 'Thomas H.', 'johnny', 'PASSWORD', 'SESSIONC3');

-- --------------------------------------------------------

--
-- Estrutura para tabela `Delivery`
--

CREATE TABLE IF NOT EXISTS `Delivery` (
  `delivery_id_pk` int(11) NOT NULL,
  `Customer_customer_id` int(11) NOT NULL,
  `Restaurant_restaurant_id` int(11) NOT NULL,
  `street` varchar(256) NOT NULL,
  `postcode` varchar(45) NOT NULL,
  `city` varchar(256) NOT NULL,
  `province` varchar(256) NOT NULL,
  `add_info` varchar(256) DEFAULT NULL,
  `comment` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `Delivery_Dish_Map`
--

CREATE TABLE IF NOT EXISTS `Delivery_Dish_Map` (
  `Delivery_delivery_id_pk` int(11) NOT NULL,
  `Meal_meal_id_pk` int(11) NOT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `Delivery_State`
--

CREATE TABLE IF NOT EXISTS `Delivery_State` (
  `Delivery_delivery_id_pk` int(11) NOT NULL,
  `date_pk` datetime NOT NULL,
  `Delivery_State_Type_delivery_status_type` int(11) NOT NULL,
  `comment` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `Delivery_State_Type`
--

CREATE TABLE IF NOT EXISTS `Delivery_State_Type` (
  `delivery_status_type_id_pk` int(11) NOT NULL,
  `name` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `Meal`
--

CREATE TABLE IF NOT EXISTS `Meal` (
  `meal_id_pk` int(11) NOT NULL,
  `Restaurant_restaurant_id` int(11) NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `price` varchar(45) DEFAULT NULL,
  `Meal_Category_meal_category_id` int(11) DEFAULT NULL,
  `description` text COMMENT 'optional',
  `spiciness` tinyint(3) unsigned DEFAULT NULL COMMENT 'Range 0-3',
  `icon_name` varchar(256) DEFAULT NULL,
  `offered` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

--
-- Fazendo dump de dados para tabela `Meal`
--

INSERT INTO `Meal` (`meal_id_pk`, `Restaurant_restaurant_id`, `name`, `price`, `Meal_Category_meal_category_id`, `description`, `spiciness`, `icon_name`, `offered`) VALUES
(1, 1, 'Jidan Guangbing', '8', NULL, 'Turnover filled with Jidan', 1, '', 1),
(2, 1, 'Cai Bing without egg', '6', NULL, 'A regular Cai Bing without egg', 0, '', 1),
(3, 1, 'Jingbing', '7', NULL, 'Jingbing with egg', 1, NULL, 1),
(4, 2, 'Salad', '20', 1, 'Salad with tomatoes, olives and onions ', 0, NULL, 1),
(5, 2, 'Veggie Burger', '70', 2, 'Veggie Burger with tofu and salad and pickles.', 0, NULL, 1),
(6, 2, 'Soya Ice Cream', '30', 3, 'Ice cream made with soya instead of milk', 0, NULL, 1),
(7, 3, 'Vegetable Kebab', '18', 2, 'Mustafas famous vegetable kebab', 1, NULL, 1),
(8, 4, 'Chicken Banfan', '15', 2, 'A typical korean food with chicken meat. Delicious!', 1, NULL, 1),
(9, 4, 'Little shrimp cake', '20', 1, '', 0, NULL, 1),
(10, 4, 'Rice cake with ham', '16', 2, 'Rice cake with a spicy ketchup and ham.', 2, NULL, 1),
(11, 4, 'Rice cake with cheese', '25', 2, 'Rice cake with chesse inside, a spicy ketchup and some mayonaisse.', 2, NULL, 1),
(12, 4, 'Coke (330ml)', '3', 1, NULL, 0, NULL, 1),
(13, 12, 'Shrimp''s Bobo', '25', 2, 'Some sauce, shrimp, vegetables and a lot of dende.', 1, NULL, 1),
(14, 12, 'Acaraje with vatapa and shrimp', '10', 1, 'A delicious bread made by white beans. Have shrimp and vatapa inside.', 0, NULL, 1),
(15, 5, 'Chicken a la Gong Pao Style', '28', 2, 'Our 5 stars best meal!', 3, NULL, 1),
(16, 5, 'Chinese Hamburguer', '7', 1, 'Chinese hamburguer, house speciality. Have some bread and pork.', 0, NULL, 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `Meal_Category`
--

CREATE TABLE IF NOT EXISTS `Meal_Category` (
  `meal_category_id_pk` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Fazendo dump de dados para tabela `Meal_Category`
--

INSERT INTO `Meal_Category` (`meal_category_id_pk`, `name`) VALUES
(1, 'appetizer'),
(2, 'main menu'),
(3, 'desert');

-- --------------------------------------------------------

--
-- Estrutura para tabela `Meal_Tag_Map`
--

CREATE TABLE IF NOT EXISTS `Meal_Tag_Map` (
  `Meal_meal_id_pk` int(11) NOT NULL,
  `Tag_tag_id_pk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='A dish is never tagged twice with the same tag';

-- --------------------------------------------------------

--
-- Estrutura para tabela `Opening_Time`
--

CREATE TABLE IF NOT EXISTS `Opening_Time` (
  `opening_time_id_pk` int(11) NOT NULL,
  `day_id` int(11) DEFAULT NULL COMMENT 'allow enums like weekday, weekend',
  `starting_time` int(11) DEFAULT NULL COMMENT 'i would save starting time an closing time as int\nlike this representation 1030 = 10:30',
  `closing_time` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='a restaurant may have multiple opening times';

-- --------------------------------------------------------

--
-- Estrutura para tabela `Rating`
--

CREATE TABLE IF NOT EXISTS `Rating` (
  `Meal_meal_id_pk` int(11) NOT NULL,
  `Customer_customer_id_pk` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `rating` tinyint(4) DEFAULT NULL COMMENT 'not be bigger than 5',
  `comment` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Every user can rate a dish just once';

--
-- Fazendo dump de dados para tabela `Rating`
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

-- --------------------------------------------------------

--
-- Estrutura para tabela `Restaurant`
--

CREATE TABLE IF NOT EXISTS `Restaurant` (
  `restaurant_id_pk` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `min_order_value` float unsigned DEFAULT NULL,
  `shipping_cost` float unsigned DEFAULT NULL COMMENT 'must be >= 0\n',
  `max_delivery_range` int(11) DEFAULT NULL COMMENT 'in kilometers, \nadditional enums like:\ncitys, districts\nin 100 meter steps',
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
  `session_id` varchar(64) DEFAULT NULL COMMENT 'unique and truly random 256 key'
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Fazendo dump de dados para tabela `Restaurant`
--

INSERT INTO `Restaurant` (`restaurant_id_pk`, `name`, `min_order_value`, `shipping_cost`, `max_delivery_range`, `icon_name`, `description`, `street`, `postcode`, `city`, `province`, `add_info`, `position_lat`, `position_long`, `offered`, `password`, `session_id`) VALUES
(1, 'Hualian', 10, 0, 10000, 'restaurant_0.jpg', 'Taste special Jidan Guangbing here.', '800 Dongchuan Road', '201109', 'Shanghai', 'Shanghai', 'on the campus', 31.02188, 121.43097, 1, 'GEHEIM', 'SESSION0'),
(2, 'Veggi Palace', 25, 10, 20000, 'restaurant_1.jpg', 'The best Veggi dishes you get in Shanghai', '1954 Huashan Road', '200030', 'Shanghai', 'Shanghai', NULL, 31.19875, 121.4364, 1, 'GEHEIM1', 'SESSION1'),
(3, 'Mustafa''s Vegetable Kebap', 0, 5, 5000, 'restaurant_2.jpg', 'Mustafa''s famous vegetable kebap only in Berlin', 'Mehringdamm 32', '10961', 'Berlin', 'Berlin', 'Next to the apartment blocks.', 52.49383, 13.38787, 1, 'GEHEIM2', 'SESSION2'),
(4, 'House Korea', 15, 0, 15000, NULL, 'The best of the korean cuisine in a single place.', '800 Dong Chuan Road', '200240', 'Shanghai', 'Shanghai', NULL, 31.017993, 121.433647, 1, '98eb470b2b60482e259d28648895d9e1', '3d319b24ca846323080895a52f4e7417'),
(5, 'The Terracotas House', 15, 0, 10000, NULL, 'The best meals of Xian', 'Siping Road 40', '201225', 'Shanghai', 'Shanghai', NULL, 29.213387, 120.622314, 1, 'a1316c20dd4b9a182c9f0cd0d1b6809f', '8ecc574a6ce6fad4aba7ffbc467a68b8'),
(12, 'Itapua''s Lighthouse Restaurant', 30, 5, 20000, NULL, 'The good and always respect cuisine from Salvador, now in Shanghai!', '45 Siping Road', '201225', 'Shanghai', 'Shanghai', 'Next from the Line10 Tongji University Metro Station, exit #2', 31.281386, 121.507713, 1, 'd8c24e5c47d2b086ee5a355e4803d861', 'd3cc8f97dfe87238eac11c3daa0df865');

-- --------------------------------------------------------

--
-- Estrutura para tabela `Restaurant_Opening_Time_Map`
--

CREATE TABLE IF NOT EXISTS `Restaurant_Opening_Time_Map` (
  `restaurant_opening_time_map_id_pk` int(11) NOT NULL,
  `Restaurant_restaurant_id` int(11) NOT NULL,
  `Opening_Time_opening_time_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura para tabela `Tag`
--

CREATE TABLE IF NOT EXISTS `Tag` (
  `tag_id_pk` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `color` varchar(6) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Fazendo dump de dados para tabela `Tag`
--

INSERT INTO `Tag` (`tag_id_pk`, `name`, `color`) VALUES
(1, 'Vegetarian', '195805'),
(2, 'Vegan', '22c13e'),
(3, 'Pork', 'f97990'),
(4, 'Cold', '73b9c1'),
(5, 'Kosher', '6c1547');

--
-- Índices de tabelas apagadas
--

--
-- Índices de tabela `Customer`
--
ALTER TABLE `Customer`
  ADD PRIMARY KEY (`customer_id_pk`),
  ADD UNIQUE KEY `nick_UNIQUE` (`nick`);

--
-- Índices de tabela `Delivery`
--
ALTER TABLE `Delivery`
  ADD PRIMARY KEY (`delivery_id_pk`),
  ADD KEY `fk_User_has_Restaurant_Restaurant1_idx` (`Restaurant_restaurant_id`),
  ADD KEY `fk_delivery_users1_idx` (`Customer_customer_id`);

--
-- Índices de tabela `Delivery_Dish_Map`
--
ALTER TABLE `Delivery_Dish_Map`
  ADD PRIMARY KEY (`Delivery_delivery_id_pk`,`Meal_meal_id_pk`),
  ADD KEY `fk_delivery_has_dish_dish1_idx` (`Meal_meal_id_pk`),
  ADD KEY `fk_delivery_has_dish_delivery1_idx` (`Delivery_delivery_id_pk`);

--
-- Índices de tabela `Delivery_State`
--
ALTER TABLE `Delivery_State`
  ADD PRIMARY KEY (`Delivery_delivery_id_pk`,`date_pk`),
  ADD KEY `fk_DeliveryState_delivery1_idx` (`Delivery_delivery_id_pk`),
  ADD KEY `fk_delivery_state_delivery_state_type1_idx` (`Delivery_State_Type_delivery_status_type`);

--
-- Índices de tabela `Delivery_State_Type`
--
ALTER TABLE `Delivery_State_Type`
  ADD PRIMARY KEY (`delivery_status_type_id_pk`);

--
-- Índices de tabela `Meal`
--
ALTER TABLE `Meal`
  ADD PRIMARY KEY (`meal_id_pk`),
  ADD KEY `fk_Menu_Restaurant1_idx` (`Restaurant_restaurant_id`),
  ADD KEY `fk_Meal_Dish_Category1_idx` (`Meal_Category_meal_category_id`);

--
-- Índices de tabela `Meal_Category`
--
ALTER TABLE `Meal_Category`
  ADD PRIMARY KEY (`meal_category_id_pk`);

--
-- Índices de tabela `Meal_Tag_Map`
--
ALTER TABLE `Meal_Tag_Map`
  ADD PRIMARY KEY (`Meal_meal_id_pk`,`Tag_tag_id_pk`),
  ADD KEY `fk_dish_has_tag_tag1_idx` (`Tag_tag_id_pk`),
  ADD KEY `fk_dish_has_tag_dish1_idx` (`Meal_meal_id_pk`);

--
-- Índices de tabela `Opening_Time`
--
ALTER TABLE `Opening_Time`
  ADD PRIMARY KEY (`opening_time_id_pk`),
  ADD KEY `day_id_fk` (`day_id`);

--
-- Índices de tabela `Rating`
--
ALTER TABLE `Rating`
  ADD PRIMARY KEY (`Customer_customer_id_pk`,`Meal_meal_id_pk`),
  ADD KEY `fk_Rating_dish1_idx` (`Meal_meal_id_pk`),
  ADD KEY `fk_Rating_user1_idx` (`Customer_customer_id_pk`);

--
-- Índices de tabela `Restaurant`
--
ALTER TABLE `Restaurant`
  ADD PRIMARY KEY (`restaurant_id_pk`);

--
-- Índices de tabela `Restaurant_Opening_Time_Map`
--
ALTER TABLE `Restaurant_Opening_Time_Map`
  ADD PRIMARY KEY (`restaurant_opening_time_map_id_pk`),
  ADD KEY `fk_restaurants_has_opening_times_opening_times1_idx` (`Opening_Time_opening_time_id`),
  ADD KEY `fk_restaurants_has_opening_times_restaurants1_idx` (`Restaurant_restaurant_id`);

--
-- Índices de tabela `Tag`
--
ALTER TABLE `Tag`
  ADD PRIMARY KEY (`tag_id_pk`);

--
-- AUTO_INCREMENT de tabelas apagadas
--

--
-- AUTO_INCREMENT de tabela `Customer`
--
ALTER TABLE `Customer`
  MODIFY `customer_id_pk` int(11) NOT NULL AUTO_INCREMENT COMMENT 'used as identifer.\nthere may be no two users with the same number\nhas to be double because with in we just can represent 10 digits, but chinese phone numbers have 11 digits\na list as representation would take more space',AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de tabela `Delivery`
--
ALTER TABLE `Delivery`
  MODIFY `delivery_id_pk` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de tabela `Delivery_State_Type`
--
ALTER TABLE `Delivery_State_Type`
  MODIFY `delivery_status_type_id_pk` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de tabela `Meal`
--
ALTER TABLE `Meal`
  MODIFY `meal_id_pk` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT de tabela `Meal_Category`
--
ALTER TABLE `Meal_Category`
  MODIFY `meal_category_id_pk` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de tabela `Opening_Time`
--
ALTER TABLE `Opening_Time`
  MODIFY `opening_time_id_pk` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de tabela `Restaurant`
--
ALTER TABLE `Restaurant`
  MODIFY `restaurant_id_pk` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT de tabela `Restaurant_Opening_Time_Map`
--
ALTER TABLE `Restaurant_Opening_Time_Map`
  MODIFY `restaurant_opening_time_map_id_pk` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de tabela `Tag`
--
ALTER TABLE `Tag`
  MODIFY `tag_id_pk` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- Restrições para dumps de tabelas
--

--
-- Restrições para tabelas `Delivery`
--
ALTER TABLE `Delivery`
  ADD CONSTRAINT `fk_User_has_Restaurant_Restaurant1` FOREIGN KEY (`Restaurant_restaurant_id`) REFERENCES `Restaurant` (`restaurant_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_delivery_users1` FOREIGN KEY (`Customer_customer_id`) REFERENCES `Customer` (`customer_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `Delivery_Dish_Map`
--
ALTER TABLE `Delivery_Dish_Map`
  ADD CONSTRAINT `fk_delivery_has_dish_delivery1` FOREIGN KEY (`Delivery_delivery_id_pk`) REFERENCES `Delivery` (`delivery_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_delivery_has_dish_dish1` FOREIGN KEY (`Meal_meal_id_pk`) REFERENCES `Meal` (`meal_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `Delivery_State`
--
ALTER TABLE `Delivery_State`
  ADD CONSTRAINT `fk_DeliveryState_delivery1` FOREIGN KEY (`Delivery_delivery_id_pk`) REFERENCES `Delivery` (`delivery_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_delivery_state_delivery_state_type1` FOREIGN KEY (`Delivery_State_Type_delivery_status_type`) REFERENCES `Delivery_State_Type` (`delivery_status_type_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `Meal`
--
ALTER TABLE `Meal`
  ADD CONSTRAINT `fk_Meal_Dish_Category1` FOREIGN KEY (`Meal_Category_meal_category_id`) REFERENCES `Meal_Category` (`meal_category_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Menu_Restaurant1` FOREIGN KEY (`Restaurant_restaurant_id`) REFERENCES `Restaurant` (`restaurant_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `Meal_Tag_Map`
--
ALTER TABLE `Meal_Tag_Map`
  ADD CONSTRAINT `fk_dish_has_tag_dish1` FOREIGN KEY (`Meal_meal_id_pk`) REFERENCES `Meal` (`meal_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_dish_has_tag_tag1` FOREIGN KEY (`Tag_tag_id_pk`) REFERENCES `Tag` (`tag_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `Rating`
--
ALTER TABLE `Rating`
  ADD CONSTRAINT `fk_Rating_dish1` FOREIGN KEY (`Meal_meal_id_pk`) REFERENCES `Meal` (`meal_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Rating_user1` FOREIGN KEY (`Customer_customer_id_pk`) REFERENCES `Customer` (`customer_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `Restaurant_Opening_Time_Map`
--
ALTER TABLE `Restaurant_Opening_Time_Map`
  ADD CONSTRAINT `fk_restaurants_has_opening_times_opening_times1` FOREIGN KEY (`Opening_Time_opening_time_id`) REFERENCES `Opening_Time` (`opening_time_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_restaurants_has_opening_times_restaurants1` FOREIGN KEY (`Restaurant_restaurant_id`) REFERENCES `Restaurant` (`restaurant_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
