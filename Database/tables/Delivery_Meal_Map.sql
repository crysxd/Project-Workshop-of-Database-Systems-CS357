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

-- --------------------------------------------------------

--
-- Table structure for table `Delivery_Meal_Map`
--

CREATE TABLE IF NOT EXISTS `Delivery_Meal_Map` (
  `Delivery_delivery_id_pk` int(11) NOT NULL,
  `Meal_meal_id_pk` int(11) NOT NULL,
  `amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`Delivery_delivery_id_pk`,`Meal_meal_id_pk`),
  KEY `fk_delivery_has_dish_dish1_idx` (`Meal_meal_id_pk`),
  KEY `fk_delivery_has_dish_delivery1_idx` (`Delivery_delivery_id_pk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Delivery_Meal_Map`
--

INSERT INTO `Delivery_Meal_Map` (`Delivery_delivery_id_pk`, `Meal_meal_id_pk`, `amount`) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 2),
(2, 5, 1),
(2, 6, 2),
(3, 5, 3);


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
