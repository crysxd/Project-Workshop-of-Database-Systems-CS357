-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 02, 2015 at 03:19 PM
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
-- Table structure for table `Customer`
--

CREATE TABLE IF NOT EXISTS `Customer` (
  `customer_id_pk` int(11) NOT NULL AUTO_INCREMENT COMMENT 'used as identifer.\nthere may be no two users with the same number\nhas to be double because with in we just can represent 10 digits, but chinese phone numbers have 11 digits\na list as representation would take more space',
  `region_code` varchar(3) DEFAULT NULL COMMENT 'the region code of the phone number',
  `national_number` varchar(15) DEFAULT NULL,
  `last_name` varchar(256) DEFAULT NULL,
  `first_name` varchar(256) DEFAULT NULL,
  `nick` varchar(45) NOT NULL DEFAULT 'Name' COMMENT 'the nickname of the user\ndefault is combination of name',
  `password` varchar(256) DEFAULT NULL,
  `session_id` varchar(64) DEFAULT NULL COMMENT 'unique and truly random 256 key',
  PRIMARY KEY (`customer_id_pk`),
  UNIQUE KEY `nick_UNIQUE` (`nick`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `Customer`
--

INSERT INTO `Customer` (`customer_id_pk`, `region_code`, `national_number`, `last_name`, `first_name`, `nick`, `password`, `session_id`) VALUES
(1, '49', '3070143434', 'Sturm', 'Gerald', 'garrythestorm', '6787017c44f171579326c2207f82a3da', '8aa84cf899b633d0a143780a49fa69b865417bca'),
(2, '86', '14324389911', 'Yao', 'Lan', 'user', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'f71a2b3076455873248203bc1dc1cd4946972d99'),
(3, '86', '14232323989', 'Zhenfán', 'Li', 'dragonpunch1940', '2acf35c77fff945a69c2d79a2f8713fd', '539862b13f47be78c65fbe150baf930601a1c628'),
(4, '1', '7184572531', 'Branton', 'Gloria', 'bunnybee', '42a6b10b2c1daa800a25f3e740edb2b3', '4ef047a953b200ce3a5a58f322dcb663fe73a885'),
(5, '1', '2126844814', 'John', 'Thomas H.', 'johnny', '229657d8b627ffd14a3bccca1a0f9b6e', '3f9004d2643b05cbc645087c65088684d1d70e79');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
