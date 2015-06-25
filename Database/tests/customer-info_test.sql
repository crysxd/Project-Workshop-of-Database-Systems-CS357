-- Selects the id's of deliveries which are completed
            SELECT d.delivery_id_pk
            FROM (

              SELECT customer_id_pk
              FROM Customer
              WHERE nick =  'dragonpunch1940'
            )c
            INNER JOIN Delivery d ON c.customer_id_pk = d.Customer_customer_id
            INNER JOIN Delivery_State ds ON d.delivery_id_pk = ds.Delivery_delivery_id_pk
            WHERE ds.Delivery_State_Type_delivery_status_type = 4

-- Selects the rows where delivery_id_pk's status is not done
SELECT d.delivery_id_pk, d.Restaurant_restaurant_id, ds.date_pk, ds.Delivery_State_Type_delivery_status_type
TYPE 
FROM (

SELECT customer_id_pk
FROM Customer
WHERE nick =  'user'
)c
INNER JOIN Delivery d ON c.customer_id_pk = d.Customer_customer_id
INNER JOIN Delivery_State ds ON d.delivery_id_pk = ds.Delivery_delivery_id_pk
WHERE d.delivery_id_pk != ( 
SELECT d.delivery_id_pk
FROM (

SELECT customer_id_pk
FROM Customer
WHERE nick =  'user'
)c
INNER JOIN Delivery d ON c.customer_id_pk = d.Customer_customer_id
INNER JOIN Delivery_State ds ON d.delivery_id_pk = ds.Delivery_delivery_id_pk
WHERE ds.Delivery_State_Type_delivery_status_type =4 ) 