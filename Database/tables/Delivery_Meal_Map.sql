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
