USE `mymeal` ;

-- NOT FINISHED
SELECT r.restaurant_id_pk, r.name, r.position_lat, r.position_long, AVG(Meal_x_Rating.rating), COUNT(Meal_x_Rating.rating), r.shipping_cost, r.min_order_value, r.icon_name
FROM
  Restaurant r
INNER JOIN
  (SELECT
    Meal.meal_id_pk, Meal.Restaurant_restaurant_id, Rating.rating
  FROM
    Meal
  INNER JOIN
    Rating
  ON
    Meal.meal_id_pk = Rating.Meal_meal_id_pk) Meal_x_Rating
ON 
  r.restaurant_id_pk = Meal_x_Rating.Restaurant_restaurant_id
WHERE
  r.offered = 1 &&
  r.max_delivery_range >= DISTANCE( r.position_lat, r.position_long, r.position_lat, r.position_long )
ORDER BY
  r.restaurant_id_pk
