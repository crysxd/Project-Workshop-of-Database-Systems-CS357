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
  `offered` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`meal_id_pk`),
  KEY `fk_Menu_Restaurant1_idx` (`Restaurant_restaurant_id`),
  KEY `fk_Meal_Dish_Category1_idx` (`Meal_Category_meal_category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

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
(7, 3, 'Vegetable Kebab', '18', 'Mustafas famous vegetable kebab', 1, 1);

--
-- Constraints for dumped tables
--


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
