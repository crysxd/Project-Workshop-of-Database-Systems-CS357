-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 30, 2015 at 12:42 AM
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

--
-- Constraints for table `Meal`
--
ALTER TABLE `Meal`
  ADD CONSTRAINT `fk_Menu_Restaurant1` FOREIGN KEY (`Restaurant_restaurant_id`) REFERENCES `Restaurant` (`restaurant_id_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
