-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 02, 2015 at 02:49 PM
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
-- Dumping data for table `Meal`
--

INSERT INTO `Meal` (`meal_id_pk`, `Restaurant_restaurant_id`, `name`, `price`, `description`, `spiciness`, `offered`) VALUES
(1, 1, 'Jidan Guangbing', '8', 'Turnover filled with Jidan', 1, 1),
(2, 1, 'Cai Bing without egg', '6', 'A regular Cai Bing without egg', 0, 1),
(3, 1, 'Jingbing', '7', 'Jingbing with egg', 1, 1),
(4, 2, 'Salad', '20', 'Salad with tomatoes, olives and onions ', 0, 1),
(5, 2, 'Veggie Burger', '70', 'Veggie Burger with tofu and salad and pickles.', 0, 1),
(6, 2, 'Soya Ice Cream', '30', 'Ice cream made with soya instead of milk', 0, 1),
(7, 3, 'Vegetable Kebab', '18', 'Mustafas famous vegetable kebab', 1, 1),

(8, 6, 'Sour Beef', '14', NULL , 0, 1),
(9, 6, 'Shredded Cabbage', '9', NULL , 1, 1),
(10, 6, 'Fragrant Duck', '14', NULL , 1, 1),
(11, 6, 'Rice', '2', NULL , 0, 1),
(12, 6, 'Spicy Chicken', '14', NULL , 3, 1),
(13, 6, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(14, 6, 'Mapo Tofu', '9', NULL , 2, 1),

(15, 7, 'Sour Beef', '14', NULL , 0, 1),
(16, 7, 'Shredded Cabbage', '9', NULL , 1, 1),
(17, 7, 'Fragrant Duck', '14', NULL , 1, 1),
(18, 7, 'Rice', '2', NULL , 0, 1),
(19, 7, 'Spicy Chicken', '14', NULL , 3, 1),
(20, 7, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(21, 7, 'Mapo Tofu', '9', NULL , 2, 1),

(22, 8, 'Sour Beef', '14', NULL , 0, 1),
(23, 8, 'Shredded Cabbage', '9', NULL , 1, 1),
(24, 8, 'Fragrant Duck', '14', NULL , 1, 1),
(25, 8, 'Rice', '2', NULL , 0, 1),
(26, 8, 'Spicy Chicken', '14', NULL , 3, 1),
(27, 8, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(28, 8, 'Mapo Tofu', '9', NULL , 2, 1),

(29, 9, 'Sour Beef', '14', NULL , 0, 1),
(30, 9, 'Shredded Cabbage', '9', NULL , 1, 1),
(31, 9, 'Fragrant Duck', '14', NULL , 1, 1),
(32, 9, 'Rice', '2', NULL , 0, 1),
(33, 9, 'Spicy Chicken', '14', NULL , 3, 1),
(34, 9, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(35, 9, 'Mapo Tofu', '9', NULL , 2, 1),

(36, 10, 'Sour Beef', '14', NULL , 0, 1),
(37, 10, 'Shredded Cabbage', '9', NULL , 1, 1),
(38, 10, 'Fragrant Duck', '14', NULL , 1, 1),
(39, 10, 'Rice', '2', NULL , 0, 1),
(40, 10, 'Spicy Chicken', '14', NULL , 3, 1),
(41, 10, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(42, 10, 'Mapo Tofu', '9', NULL , 2, 1),

(43, 11, 'Sour Beef', '14', NULL , 0, 1),
(44, 11, 'Shredded Cabbage', '9', NULL , 1, 1),
(45, 11, 'Fragrant Duck', '14', NULL , 1, 1),
(46, 11, 'Rice', '2', NULL , 0, 1),
(47, 11, 'Spicy Chicken', '14', NULL , 3, 1),
(48, 11, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(49, 11, 'Mapo Tofu', '9', NULL , 2, 1),

(50, 12, 'Sour Beef', '14', NULL , 0, 1),
(51, 12, 'Shredded Cabbage', '9', NULL , 1, 1),
(52, 12, 'Fragrant Duck', '14', NULL , 1, 1),
(53, 12, 'Rice', '2', NULL , 0, 1),
(54, 12, 'Spicy Chicken', '14', NULL , 3, 1),
(55, 12, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(56, 12, 'Mapo Tofu', '9', NULL , 2, 1),

(57, 13, 'Sour Beef', '14', NULL , 0, 1),
(58, 13, 'Shredded Cabbage', '9', NULL , 1, 1),
(59, 13, 'Fragrant Duck', '14', NULL , 1, 1),
(60, 13, 'Rice', '2', NULL , 0, 1),
(61, 13, 'Spicy Chicken', '14', NULL , 3, 1),
(62, 13, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(63, 13, 'Mapo Tofu', '9', NULL , 2, 1),

(64, 14, 'Sour Beef', '14', NULL , 0, 1),
(65, 14, 'Shredded Cabbage', '9', NULL , 1, 1),
(66, 14, 'Fragrant Duck', '14', NULL , 1, 1),
(67, 14, 'Rice', '2', NULL , 0, 1),
(68, 14, 'Spicy Chicken', '14', NULL , 3, 1),
(69, 14, 'Tomato scrambled eggs', '11', NULL , 0, 1),
(70, 14, 'Mapo Tofu', '9', NULL , 2, 1),

(71, 4, 'Super Extreme Bisa Pu + Italian caviar fan Beibisapu', '66.5', NULL , 1, 1),
(72, 4, 'Super Supreme pizza large + Italian caviar fan Bei Bisa large', '98.5', NULL , 2, 1),
(73, 4, 'Seafood supreme Bisa Pu + Korean beef Bisa Pu Zhen', '69.5', NULL , 1, 1),
(74, 4, 'Korean beef Bisa Pu Zhen', '98.5', NULL , 3, 1),
(75, 4, 'Mango Pineapple', '12', NULL , 0, 1),

(76, 5, 'New Orleans roast wings', '11', NULL , 2, 1),
(77, 5, 'Hibiscus fresh vegetable soup', '6', NULL , 2, 1),
(78, 5, 'Corn salad', '5', NULL , 2, 1),
(79, 5, 'Old Beijing Chicken Roll', '15', NULL , 2, 1),
(80, 5, 'Spicy chicken wings (2)', '10', NULL , 2, 1);
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
