USE `mymeal` ;

--
-- Test class for the sql select commands in the restaurant php file
--

-- Outputs the average rating and the number of ratings for each restaurant
SELECT
    Meal.Restaurant_restaurant_id, AVG(Rating.rating) rating, COUNT(Rating.rating) rating_count
  FROM
    Meal
  INNER JOIN
    Rating
  ON
    Meal.meal_id_pk = Rating.Meal_meal_id_pk
  GROUP BY
    Meal.Restaurant_restaurant_id

-- Outputs all restaurants
SELECT r.restaurant_id_pk, r.name, r.position_lat, r.position_long, Meal_j_Rating.rating, Meal_j_Rating.rating_count, r.shipping_cost, r.min_order_value
FROM
  Restaurant r
INNER JOIN
  (SELECT
    Meal.Restaurant_restaurant_id, AVG(Rating.rating) rating, COUNT(Rating.rating) rating_count
  FROM
    Meal
  INNER JOIN
    Rating
  ON
    Meal.meal_id_pk = Rating.Meal_meal_id_pk
  GROUP BY
    Meal.Restaurant_restaurant_id) Meal_j_Rating
ON 
  r.restaurant_id_pk = Meal_j_Rating.Restaurant_restaurant_id
WHERE
  r.offered = 1
ORDER BY
  r.restaurant_id_pk

-- Outputs all restaurants near 800 Dongchuan Lu
SELECT r.restaurant_id_pk, r.name, r.position_lat, r.position_long, Meal_j_Rating.rating, Meal_j_Rating.rating_count, r.shipping_cost, r.min_order_value
FROM
  Restaurant r
INNER JOIN
  (SELECT
    Meal.Restaurant_restaurant_id, AVG(Rating.rating) rating, COUNT(Rating.rating) rating_count
  FROM
    Meal
  INNER JOIN
    Rating
  ON
    Meal.meal_id_pk = Rating.Meal_meal_id_pk
  GROUP BY
    Meal.Restaurant_restaurant_id) Meal_j_Rating
ON 
  r.restaurant_id_pk = Meal_j_Rating.Restaurant_restaurant_id
WHERE
  r.offered = 1 &&
  r.max_delivery_range >= DISTANCE( r.position_lat, r.position_long, 31.02188, 121.43097 )
ORDER BY
  r.restaurant_id_pk

-- for REST interface
SELECT r.restaurant_id_pk id, r.name, r.position_lat , r.position_long, Meal_j_Rating.avg_rating, Meal_j_Rating.rating_count, r.shipping_cost, r.min_order_value
FROM Restaurant r
INNER JOIN (
  SELECT Meal.Restaurant_restaurant_id, AVG( Rating.rating ) avg_rating, COUNT( Rating.rating ) rating_count
  FROM Meal
  INNER JOIN Rating ON Meal.meal_id_pk = Rating.Meal_meal_id_pk
	WHERE Meal.offered = 1
  GROUP BY Meal.Restaurant_restaurant_id
) Meal_j_Rating
ON r.restaurant_id_pk = Meal_j_Rating.Restaurant_restaurant_id
WHERE r.offered =1 && r.max_delivery_range >= DISTANCE( r.position_lat, r.position_long, 31.02188, 121.43097 ) 
ORDER BY r.restaurant_id_pk

-- Computation time optimized NOT FINISHED
SELECT r.restaurant_id_pk id, r.name, r.position_lat , r.position_long, Meal_j_Rating.avg_rating, Meal_j_Rating.rating_count, r.shipping_cost, r.min_order_value
FROM Restaurant r
INNER JOIN (
  SELECT Meal.Restaurant_restaurant_id, AVG( Rating.rating ) avg_rating, COUNT( Rating.rating ) rating_count
  FROM Meal
	WHERE Meal.offered = 1
  INNER JOIN Rating ON Meal.meal_id_pk = Rating.Meal_meal_id_pk
  GROUP BY Meal.Restaurant_restaurant_id
) Meal_j_Rating
ON r.restaurant_id_pk = Meal_j_Rating.Restaurant_restaurant_id
WHERE r.offered =1 && r.max_delivery_range >= DISTANCE( r.position_lat, r.position_long, 31.02188, 121.43097 ) 
ORDER BY r.restaurant_id_pk

  SELECT Meal.Restaurant_restaurant_id, AVG( Rating.rating ) avg_rating, COUNT( Rating.rating ) rating_count
  FROM Restaurant r
	WHERE r.offered = 1 && r.max_delivery_range >= DISTANCE( r.position_lat, r.position_long, 31.02188, 121.43097 ) 
  INNER JOIN Meal ON Meal.meal_id_pk = Rating.Meal_meal_id_pk
	WHERE Meal.offered = 1
  GROUP BY Meal.Restaurant_restaurant_id


