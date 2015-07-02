-- phpMyAdmin SQL Dump
-- version 4.2.11
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 02, 2015 at 08:50 AM
-- Server version: 5.6.21
-- PHP Version: 5.6.3

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
-- Dumping data for table `Restaurant`
--

INSERT INTO `Restaurant` (`restaurant_id_pk`, `name`, `min_order_value`, `shipping_cost`, `max_delivery_range`, `description`, `country`, `postcode`, `city`, `district`, `street_name`, `street_number`, `add_info`, `position_lat`, `position_long`, `offered`, `password`, `session_id`, `region_code`, `national_number`, `email`) VALUES
(1, 'Hualian', 10, 0, 10000, 'Taste special Jidan Guangbing here.', 'China', '200030', 'Shanghai', 'Minghang Qu', 'Dongchuan Road', '800', NULL, 31.02188, 121.43097, 1, '098f6bcd4621d373cade4e832627b4f6', '26dfe8116b93ced6cfca858f375d23f1489d3207', '86', '17336010252', NULL),
(2, 'Veggi Palace', 25, 10, 20000, 'The best Veggi dishes you get in Shanghai', 'China', '200030', 'Shanghai', 'Xuhui Qu', 'Huashan Road', '1954', NULL, 31.19875, 121.4364, 1, 'bdc87b9c894da5168059e00ebffb9077', '4570258f13c64eefb56a26bac08093636f0fc102', '86', '17455250768', NULL),
(3, 'Mustafa''s Vegetable Kebap', 0, 5, 5000, 'Mustafa''s famous vegetable kebap only in Berlin', 'Germany', '10961', 'Berlin', 'Schoeneberg', 'Mehringdamm', '32', 'Next to the apartment blocks.', 52.49383, 13.38787, 1, '5f4dcc3b5aa765d61d8327deb882cf99', '75a2b6313ea2d41950160cc12678cf12ec461b79', '86', '14893035276', NULL),
(4, 'å¿…èƒœå®…æ€¥é€', 25, 0, 10000, 'Order some awsome pizza!', 'China', '', 'Minhang Qu', NULL, '2370 Dong Chuan Lu', NULL, NULL, 31.012494, 121.410644, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', 'bcc87b640667c0ca1a2d998ccd07fb1cb91821ef84031084fbb3ff45613a8cc5', '86', '13096883169', NULL),
(5, 'è‚¯å¾·åŸºå®…æ€¥é€', 25, 5, 10000, 'Get some fried chicken', 'æ±Ÿå·è·¯248å¼„134å·ä¸Šæµ·å¸‚é—µè¡ŒåŒºæ±Ÿå·è·¯è¡—é“ä¸œé£Žæ–°æ‘ç¬¬ä¸€å±…å§”å®¶åº­è®¡åˆ’æŒ‡å¯¼å®¤ é‚®æ”¿ç¼–ç : 200240', '', 'Shanghai Shi', NULL, 'China', NULL, NULL, 31.007075, 121.420572, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', 'aee0384e9238d080309c28a01aa3c9a9e0c148edbb279567208fcab37bae7275', '86', '13096883169', NULL),
(6, 'æžå®¢ä¾¿å½“ ', 10, 0, 10000, 'ä¸‰ä¸ªè€ç”·å­©çš„åˆ›ä¸šæ•…äº‹ï¼Œå†ä¸å¹²ç‚¹äº‹å°±è€äº†ï¼ŒæŠ“ä½é’æ˜¥çš„å°¾å·´ã€‚æˆ‘ä»¬ç”¨å¿ƒæŠŠå…³é£ŸæåŠé…æ–™ï¼Œç²¾å¿ƒçƒ¹åˆ¶ï¼Œè„šè¸å®žåœ°ï¼Œåšåˆ°æžè‡´ï¼', 'China', '', 'Minhang Qu', NULL, '800 Dong Chuan Lu', NULL, NULL, 31.0218816, 121.4309663, 1, '0', '884006e0cb074556c26c22e0aee3c6b7b5307adf192cb1775b4bef6303486c61', '86', '13096883169', NULL),
(7, 'æžå®¢ä¾¿å½“ ', 10, 0, 10000, 'ä¸‰ä¸ªè€ç”·å­©çš„åˆ›ä¸šæ•…äº‹ï¼Œå†ä¸å¹²ç‚¹äº‹å°±è€äº†ï¼ŒæŠ“ä½é’æ˜¥çš„å°¾å·´ã€‚æˆ‘ä»¬ç”¨å¿ƒæŠŠå…³é£ŸæåŠé…æ–™ï¼Œç²¾å¿ƒçƒ¹åˆ¶ï¼Œè„šè¸å®žåœ°ï¼Œåšåˆ°æžè‡´ï¼', 'China', '', 'Minhang Qu', NULL, '800 Dong Chuan Lu', NULL, NULL, 31.0218816, 121.4309663, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '247ccce33e9558df4666b2f8ebdcf31f8acfa47fbb79d1a91343f02283f8f388', '86', '13096883169', NULL),
(8, 'å°ä¹”', 50, 0, 10000, 'å°ä¹”å®—æ—¨ï¼šè®©æ‚¨åƒçš„å¹²å‡€&amp;middot;å¥åº·&amp;middot;å«ç”Ÿï¼Œåº”å¯¹ç”Ÿæ´»ä¸­çš„ä¸€åˆ‡æŒ‘æˆ˜ï¼~', 'China', '', 'Minhang Qu', NULL, '800 Dong Chuan Lu', NULL, NULL, 31.0218816, 121.4309663, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '6ce9700bba683d8ef6c10731dfa64242dbcf9f006ef4cd42cefc195630dd3e4b', '86', '13096883169', NULL),
(9, 'æ­£å®—æ²™åŽ¿å°åƒ', 15, 0, 10000, 'æ‚¨çš„æ”¯æŒæ˜¯æˆ‘ä»¬å‰è¿›çš„åŠ¨åŠ›ï¼Œæ‚¨çš„æ»¡æ„æ˜¯æˆ‘ä»¬æ°¸è¿œçš„è¿½æ±‚ï¼Œæˆ‘ä»¬ä¼šå°†ä¸æ‡ˆçš„è¿½æ±‚åŒ–ä¸ºæ°¸æ’çš„åŠ¨åŠ›ï¼Œåšå‡ºæœ€ç¾Žçš„ç¾Žé£Ÿï¼Œä»¥ä¿åŒå­¦ä»¬çš„æ»¡æ„', 'China', '', 'Minhang Qu', NULL, '889 Dong Chuan Lu', NULL, NULL, 31.016787, 121.429583, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '7bfeff713839c3dd5472677c6fc75024ae75724ab16ec59cf9cd58fc913dd4fc', '86', '13096883169', NULL),
(10, 'æ³¡æ³¡é¦™é¦™é¸¡.ç²¥.ä¾¿å½“', 20, 5, 10000, 'æ³¡æ³¡æ‰€æœ‰äº§å“å‡ä¸ºçŽ°åšçŽ°å–ï¼', 'China', '', 'Minhang Qu', NULL, '840 Dong Chuan Lu', NULL, NULL, 31.0177304, 121.4322453, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', 'd291bdac0b2b2693e97efa6d00bef2b7bfe8858f0d1ad95212594c241ff74ed3', '86', '13096883169', NULL),
(11, 'å•¤é…’é¸­é¥­', 30, 10, 10000, 'æ†¨å¤§å” ç»™åŠ›æ¯ä¸€å¤©ï¼å€¼å¾—ä½ æ‹¥æœ‰(*^__^*)', 'China', '', 'Minhang Qu', NULL, '811 Dong Chuan Lu', NULL, NULL, 31.0180851, 121.4336476, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '16eb04e6f154843bef1dfffcb42e734b8bafc91d4eb62a4506fd4613247f390f', '86', '13096883169', NULL),
(12, 'é¥­æœ‰å¼•åŠ›', 10, 0, 10000, 'æˆ‘ä»¬è‰¯å¿ƒç»è¥ï¼ŒåŠªåŠ›åšåˆ°è®©æ‚¨æ»¡æ„,å¸Œæœ›å¤šææ„è§ï¼Œè®©æˆ‘ä»¬æ…¢æ…¢å‘å‰è¿ˆè¿›ï¼ï¼ï¼', 'China', '', 'Minhang Qu', NULL, '375 Shi Ping Lu', NULL, NULL, 31.0171109, 121.4198246, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '206379db4227f79e2faa00fbc6fbb32ffdd7b4244b56d83af88ca29e9976182b', '86', '13096883169', NULL),
(13, 'å´”å¤§å¦ˆ', 10, 4, 10000, 'ç”¨ä¸­é¤ï¼Œå·¦æ‰‹æ‰§ç¢—ï¼Œå³æ‰‹æŒç­·', 'China', '', 'Minhang Qu', NULL, '811 Dong Chuan Lu', NULL, NULL, 31.0180851, 121.4336476, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '6f23f21851d85f949387fefcc40521c7209f54f2e25b90b124185c1e9a19f37b', '86', '13096883169', NULL),
(14, 'çŽ›ç‰¹å¿«é¤ ', 10, 2, 10000, 'æ–°åº—å¼€å¼ ï¼Œæ³¨é‡å“è´¨å’Œå£å‘³ï¼Œè®©æ‚¨åƒçš„å®‰å¿ƒï¼Œåƒçš„èˆ’å¿ƒã€‚', 'China', '', 'Minhang Qu', NULL, '805 Dong Chuan Lu', NULL, NULL, 31.0182305, 121.4341035, 1, '7c4a8d09ca3762af61e59520943dc26494f8941b', '1c8f85a0eb09a5dc493e69deb6794dd832fcae282c848d7efc8ba5c87df337bd', '86', '13096883169', NULL);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
