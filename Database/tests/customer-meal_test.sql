-- Implementing
-- Get the general restaurant information
/*
"description": "The best restaurant you will find!",
"min_order_value": 12.4,
"shipping_cost": 0,
*/

SELECT description, min_order_value, shipping_cost
FROM Restaurant
WHERE restaurant_id_pk = 1

-- For php
/*
SELECT description, min_order_value, shipping_cost
FROM Restaurant
WHERE restaurant_id_pk = ?
*/

-- Implementing
-- Get the data
/*
"data": [
    {
        "name": "Hot Rice",
        "price": 2.5,
        "spicy": 3,
        "avg_rating": 4.8,
        "rating_count": 24
        "tags": [
            {"name": "Vegan", "color": "#FF0000"},
            {"name": "Vegetarian", "color": "#00FF00"}
        ]
    },
*/

SELECT
  Meal.meal_id_pk meal_id, Meal.name name, Meal.price price, Meal.spiciness spicy, AVG(Rating.rating) rating, COUNT(Rating.rating) rating_count
FROM
  Meal
INNER JOIN
  Rating
ON
  Meal.meal_id_pk = Rating.Meal_meal_id_pk
WHERE
  Meal.offered = 1 && Meal.Restaurant_restaurant_id = 1
GROUP BY
  Meal.Restaurant_restaurant_id
ORDER BY
  name ASC
LIMIT
  0, 30;

-- For php
/*
SELECT Meal.meal_id_pk meal_id, Meal.name name, Meal.price price, Meal.spiciness spicy, AVG( Rating.rating ) rating, COUNT( Rating.rating ) rating_count
FROM Meal
INNER JOIN Rating ON Meal.meal_id_pk = Rating.Meal_meal_id_pk
WHERE Meal.offered =1 && Meal.Restaurant_restaurant_id =?
GROUP BY Meal.Restaurant_restaurant_id
ORDER BY ? ?
LIMIT ?, ?
*/

-- Implementing
-- For Tags
/*
"tags": [
    {"name": "Vegan", "color": "#FF0000"},
    {"name": "Vegetarian", "color": "#00FF00"}
	]
*/

SELECT
  Tag.name, Tag.color
FROM
  Tag
INNER JOIN
  (SELECT
    Meal_Tag_Map.Tag_tag_id_pk
  FROM
    Meal
  INNER JOIN
    Meal_Tag_Map
  ON
    Meal.meal_id_pk = Meal_Tag_Map.Meal_meal_id_pk
  WHERE
    Meal.offered = 1 &&
    Meal.Restaurant_restaurant_id = 1 &&
	Meal.meal_id_pk = 2

	) Meal_x_Meal_Tag_Map
ON
  Tag.tag_id_pk = Meal_x_Meal_Tag_Map.Tag_tag_id_pk

-- For php
/*

SELECT Tag.name, Tag.color
FROM Tag
INNER JOIN (

  SELECT Meal_Tag_Map.Tag_tag_id_pk
  FROM Meal
  INNER JOIN Meal_Tag_Map ON Meal.meal_id_pk = Meal_Tag_Map.Meal_meal_id_pk
  WHERE Meal.offered =1 && Meal.Restaurant_restaurant_id =1 && Meal.meal_id_pk = ?
)Meal_x_Meal_Tag_Map ON Tag.tag_id_pk = Meal_x_Meal_Tag_Map.Tag_tag_id_pk
*/
