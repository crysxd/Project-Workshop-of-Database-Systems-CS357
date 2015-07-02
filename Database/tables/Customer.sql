-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 02, 2015 at 02:02 PM
-- Server version: 5.5.43-0ubuntu0.14.04.1-log
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
-- Dumping data for table `Customer`
--

INSERT INTO `Customer` (`customer_id_pk`, `region_code`, `national_number`, `last_name`, `first_name`, `nick`, `password`, `session_id`, `email`) VALUES
(1, '49', '3070143434', 'Sturm', 'Gerald', 'garrythestorm', '6787017c44f171579326c2207f82a3da', NULL, 'demo@kart4you.de'),
(2, '86', '14324389911', 'Yao', 'Lan', 'user', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(3, '86', '14232323989', 'Zhenfan', 'Li', 'dragonpunch1940', '2acf35c77fff945a69c2d79a2f8713fd', NULL, 'demo@kart4you.de'),
(4, '1', '7184572531', 'Branton', 'Gloria', 'bunnybee', '42a6b10b2c1daa800a25f3e740edb2b3', NULL, 'demo@kart4you.de'),
(5, '1', '2126844814', 'John', 'Thomas H.', 'johnny', '229657d8b627ffd14a3bccca1a0f9b6e', NULL, 'demo@kart4you.de'),
(6, '86', '13133349212', 'Li', 'Han', 'newby', '2dbbd680949db33f7912382d10459dd0c28c37e5', NULL, 'demo@kart4you.de'),
(7, '86', '15580305935', 'I.M.', 'Pei', 'impei', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(8, '86', '15718679133', 'Guan', 'Tianlang', 'chinesetiger', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(9, '86', '15580305935', 'Charles', 'Ng', 'murder', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(10, '86', '11230305935', 'Du', 'Fu', 'poet', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(11, '86', '18311515308i', 'Yip', 'Man', 'laoshi', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(12, '86', '16533991188', 'Ming', 'Na', 'mingi', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(13, '86', '11446454529', 'Jiang', 'Qing', 'theadvisor', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de'),
(14, '86', '16577356513', 'Ding', 'Ling', 'jiangqu', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'demo@kart4you.de');
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
