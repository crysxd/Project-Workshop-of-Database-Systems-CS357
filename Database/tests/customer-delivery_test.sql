-- Implementing
-- PUT a delivery with customer information
/*
            - user: The user's nick name
            - session: The session which is used to order
            - PUT: the order, encoded as following:
                {
                    "restaurant": 0,
                    "dishes": [
                        {"id": 0, "quantity": 1},
                        {"id": 5, "quantity": 1},
                        {"id": 42, "quantity": 12},
                        {"id": 1337, "quantity": 1},
                    ]
                    "address": [
                        "number": 800,
                        "street": "Dong Chuan Lu",
                        "city": "Minghang Qu",
                        "postcode": "23423",
                        "lat": 23.3434,
                        "lang": 23.344
                    ]
                }
*/

SELECT c.customer_id_pk
FROM Customer c
WHERE c.nick = 'localj'

/*php
SELECT c.customer_id_pk ,
FROM Customer c
WHERE c.nick = user
*/

/* NOT USED Second approach in which php does not have to send a SELECT to the database to get the customer_id_pk
the database just creates a table by its own an fuses them with the selection
CREATE TABLE IF NOT EXISTS `mymeal`.`temp` (Restaurant_restaurant_id INT);
INSERT INTO temp VALUES (1);

DROP TABLE temp;
*/

/*php
CREATE TABLE IF NOT EXISTS `mymeal`.`temp` (Restaurant_restaurant_id INT);
INSERT INTO temp VALUES (restaurant);
*/

INSERT INTO `Delivery` (`delivery_id_pk`, `Customer_customer_id`, `Restaurant_restaurant_id`, `street_number`, `street_name`, `postcode`, `city`, `province`, `add_info`, `comment`) VALUES
(1, 2, 1, '723', 'Dongchuan Road', '200030', 'Shanghai', 'Shanghai', NULL, NULL);


INSERT INTO `Delivery_Meal_Map` (`Delivery_delivery_id_pk`, `Meal_meal_id_pk`, `amount`) VALUES
(1, 1, 1),
(1, 3, 2);

INSERT INTO `Delivery_State` (`Delivery_delivery_id_pk`, `date_pk`, `Delivery_State_Type_delivery_status_type`, `comment`) VALUES
(1, '2015-06-08 14:53:26', 1, NULL);


INSERT INTO `Delivery` (`delivery_id_pk`, `Customer_customer_id`, `Restaurant_restaurant_id`, `street_number`, `street_name`, `postcode`, `city`, `province`, `add_info`, `comment`) VALUES
(1, 2, 1, '723', 'Dongchuan Road', '200030', 'Shanghai', 'Shanghai', NULL, NULL);

INSERT INTO `Delivery_Meal_Map` (`Delivery_delivery_id_pk`, `Meal_meal_id_pk`, `amount`) VALUES
(1, 1, 1),
(1, 3, 2);

INSERT INTO `Delivery_State` (`Delivery_delivery_id_pk`, `date_pk`, `Delivery_State_Type_delivery_status_type`, `comment`) VALUES
(1, '2015-05-01 18:08:10', 1, NULL);


-- For get request
/*
            "success": true,
            "restaurant": "A cool restaurant",
            "phone": "8347897942",
            "shipping_costs": 34,
            "number": 800,
            "street": "Dong Chuan Lu",
            "city": "Shanghai",
            "postcode": "435435"
            "dishes": [
                        {"id": 0, "quantity": 1, "price": 34},
                        {"id": 5, "quantity": 1, "price": 34},
                        {"id": 42, "quantity": 12, "price": 34},
                        {"id": 1337, "quantity": 1, "price": 34},
                    ]
            "states": [
                        {"state": "Pending", "date": "13:23 2015-03-31",},
                        {"state": "Processing", "date": "13:23 2015-03-31"},
                        {"state": "In Delivery", "date": "13:23 2015-03-31"},
                        {"state": "Done", "date": "13:23 2015-03-31"}
            ]
*/

-- For dishes
SELECT dmm.Meal_meal_id_pk id, dmm.amount quantity
FROM (

SELECT delivery_id_pk
FROM Delivery
WHERE delivery_id_pk =1
)d
INNER JOIN Delivery_Meal_Map dmm ON dmm.Delivery_delivery_id_pk = d.delivery_id_pk