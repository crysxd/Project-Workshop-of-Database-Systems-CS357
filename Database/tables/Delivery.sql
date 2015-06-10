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

-- --------------------------------------------------------

--
-- Table structure for table `Delivery`
--

CREATE TABLE IF NOT EXISTS `Delivery` (
  `delivery_id_pk` int(11) NOT NULL AUTO_INCREMENT,
  `Customer_customer_id` int(11) NOT NULL,
  `Restaurant_restaurant_id` int(11) NOT NULL,
  `street` varchar(256) NOT NULL,
  `postcode` varchar(45) NOT NULL,
  `city` varchar(256) NOT NULL,
  `add_info` varchar(256) DEFAULT NULL,
  `comment` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`delivery_id_pk`),
  KEY `fk_User_has_Restaurant_Restaurant1_idx` (`Restaurant_restaurant_id`),
  KEY `fk_delivery_users1_idx` (`Customer_customer_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `Delivery`
--

INSERT INTO `Delivery` (`delivery_id_pk`, `Customer_customer_id`, `Restaurant_restaurant_id`, `street_number`, `street_name`, `postcode`, `city`, `add_info`, `comment`) VALUES
(1, 2, 1, '723', 'Dongchuan Road', '200030', 'Shanghai', NULL, NULL);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
