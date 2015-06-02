
USE `mymeal` ;

--
-- Function to check distance
--

DROP FUNCTION IF EXISTS DISTANCE;
DELIMITER $$
CREATE FUNCTION DISTANCE(lat1 DOUBLE, long1 DOUBLE, lat2 DOUBLE, long2 DOUBLE)
  RETURNS FLOAT
BEGIN
  DECLARE R, phi1, phi2, dphi, dlam, a, c, d FLOAT;
  SET R = 6371000; -- metres
  SET phi1 = RADIANS(lat1);
  SET phi2 = RADIANS(lat2);
  SET dphi = RADIANS(lat2-lat1);
  SET dlam = RADIANS(long2-long1);
    
  SET a = SIN(dphi/2) * SIN(dphi/2) +
         COS(phi1) * COS(phi2) *
         SIN(dlam/2) * SIN(dlam/2);
  SET c = 2 * ATAN2(SQRT(a), SQRT(1-a));
  
  SET d = R * c;
  RETURN d;
END;
$$
DELIMITER ;

--
-- Dumping data for table `Restaurant`
--

DELETE FROM `Restaurant` WHERE 1;
INSERT INTO `Restaurant` (`restaurant_id_pk`, `name`, `min_order_value`, `shipping_cost`, `max_delivery_range`, `icon_name`, `description`, `street`, `postcode`, `city`, `province`, `add_info`, `position_lat`, `position_long`, `offered`, `password`, `session_id`) VALUES
(1, 'Hualian', 10, 0, 10000, 'restaurant_0.jpg', 'Taste special Jidan Guangbing here.', '800 Dongchuan Road', '201109', 'Shanghai', 'Shanghai', 'on the campus', 31.02188, 121.43097, 1, 'GEHEIM', 'SESSION0'),
(2, 'Veggie Palace', 25, 10, 20000, 'restaurant_1.jpg', 'The best Veggie dishes you get in Shanghai', '1954 Huashan Road', '200030', 'Shanghai', 'Shanghai', NULL, 31.19875, 121.43640, 1, 'GEHEIM1', 'SESSION1'),
(3, 'Mustafa''s Vegetable Kebap', 0, 5, 5000, 'restaurant_2.jpg', 'Mustafa''s famous vegetable kebap only in Berlin', 'Mehringdamm 32', '10961', 'Berlin', 'Berlin', 'Next to the apartment blocks.', 52.49383, 13.38787, 1, 'GEHEIM2', 'SESSION2');


-- For testing the function: CROSS JOIN tables and then check distance

SELECT r1.restaurant_id_pk, r1.name, r1.position_lat, r1.position_long, r2.restaurant_id_pk, r2.name, r2.position_lat, r2.position_long, r1.max_delivery_range,
DISTANCE( r1.position_lat, r1.position_long, r2.position_lat, r2.position_long ), r1.max_delivery_range >= DISTANCE( r1.position_lat, r1.position_long, r2.position_lat, r2.position_long )
FROM
  Restaurant r1
CROSS JOIN
  Restaurant r2
WHERE
  r1.offered = 1 && r2.offered = 1
ORDER BY
  r1.restaurant_id_pk

-- For testing the function: CROSS JOIN tables and then check distance

