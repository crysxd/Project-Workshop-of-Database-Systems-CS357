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
