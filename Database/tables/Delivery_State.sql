-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 02, 2015 at 08:30 PM
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
-- Table structure for table `Delivery_State`
--

CREATE TABLE IF NOT EXISTS `Delivery_State` (
  `Delivery_delivery_id_pk` int(11) NOT NULL,
  `date_pk` datetime NOT NULL,
  `Delivery_State_Type_delivery_status_type` int(11) NOT NULL,
  `comment` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`Delivery_delivery_id_pk`,`date_pk`),
  KEY `fk_DeliveryState_delivery1_idx` (`Delivery_delivery_id_pk`),
  KEY `fk_delivery_state_delivery_state_type1_idx` (`Delivery_State_Type_delivery_status_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Delivery_State`
--

INSERT INTO `Delivery_State` (`Delivery_delivery_id_pk`, `date_pk`, `Delivery_State_Type_delivery_status_type`, `comment`) VALUES
(1, '2015-05-01 18:08:10', 1, NULL);


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
