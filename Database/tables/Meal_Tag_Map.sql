-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 02, 2015 at 04:22 PM
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
-- Table structure for table `Meal_Tag_Map`
--

CREATE TABLE IF NOT EXISTS `Meal_Tag_Map` (
  `Meal_meal_id_pk` int(11) NOT NULL,
  `Tag_tag_id_pk` int(11) NOT NULL,
  PRIMARY KEY (`Meal_meal_id_pk`,`Tag_tag_id_pk`),
  KEY `fk_dish_has_tag_tag1_idx` (`Tag_tag_id_pk`),
  KEY `fk_dish_has_tag_dish1_idx` (`Meal_meal_id_pk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='A dish is never tagged twice with the same tag';

--
-- Dumping data for table `Meal_Tag_Map`
--

INSERT INTO `Meal_Tag_Map` (`Meal_meal_id_pk`, `Tag_tag_id_pk`) VALUES
(1, 1),
(2, 1),
(3, 1),
(2, 2);



/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
