-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 31, 2015 at 04:25 PM
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
-- Dumping data for table `Rating`
--

INSERT INTO `Rating` (`Meal_meal_id_pk`, `Customer_customer_id_pk`, `date`, `rating`, `comment`) VALUES
(1, 2, '2015-05-01 18:43:22', 4, 'really tasty, but a bit salty'),
(3, 2, '2015-05-05 12:14:54', 3, 'Really good, but way too expensive'),
(5, 3, '2015-05-13 17:00:00', 5, 'Good, a!'),
(6, 3, '2015-05-24 17:00:04', 5, 'Hen Good!');

/*
(1, 2, '2015-05-05 18:43:22', 4, 'really tasty, but a bit salty'),
(4, 2, '2015-05-10 12:14:54', 3, 'Really good, but way too expensive'),
(6, 2, '2015-05-05 12:15:32', 5, 'Mhmmm... tasty'),
(1, 3, '2015-05-02 20:08:56', 2, 'Really did not like the one without egg'),
(2, 3, '2015-05-15 17:00:01', 3, 'Okeh!'),
(3, 3, '2015-05-12 17:00:00', 4, 'Good!'),
(4, 3, '2015-05-14 17:00:01', 5, 'Hen Good!'),
(5, 3, '2015-05-13 17:00:00', 5, 'Good, a!');
*/

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
