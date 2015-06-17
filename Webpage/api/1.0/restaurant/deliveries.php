<?php
  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  global $db_link;

  $args_str = array("state", "session", "id", "start", "count");
  check_parms_available($args_str);
  escape_parms($args_str);

  $args = array();
  foreach ($args_str as $arg_str)
    $args[$arg_str] = $_GET[$arg_str];

  $answer = array();

  check_restaurant_session($args['id'], $args['session']);

  // gives the delivery ids for a restaurant id, NOT USED just for better understanding
  $stmt_select_delivery_for_rest_id = "
    SELECT  delivery_id_pk
    FROM Delivery
    INNER JOIN (

      SELECT restaurant_id_pk
      FROM Restaurant
      WHERE restaurant_id_pk =1
    )Restaurant ON Restaurant.restaurant_id_pk = Delivery.Restaurant_restaurant_id
    ";

  // gives the total price for every delivery corresponding to a restaurant id
  $stm_select_dishes_total_price = "
    SELECT m.price * dmm.amount total_amount, dmm.Delivery_delivery_id_pk
    FROM (

      SELECT * 
      FROM Delivery_Meal_Map
      WHERE Delivery_delivery_id_pk IN 
        (
          SELECT  delivery_id_pk
          FROM Delivery
          INNER JOIN (

            SELECT restaurant_id_pk
            FROM Restaurant
            WHERE restaurant_id_pk = ?
          )Restaurant ON Restaurant.restaurant_id_pk = Delivery.Restaurant_restaurant_id
        )
    )dmm
    INNER JOIN Meal m ON dmm.Meal_meal_id_pk = m.meal_id_pk
  GROUP BY Delivery_delivery_id_pk
    ";


  $stmt_select_delivery="
    SELECT xd.delivery_id_pk id, xd.date, xd.shipping_cost, mdmm.total_amount, xd.nick customer, xd.name state
    FROM (
      SELECT m.price * dmm.amount total_amount, dmm.Delivery_delivery_id_pk
      FROM (

        SELECT * 
        FROM Delivery_Meal_Map
        WHERE Delivery_delivery_id_pk IN 
          (
            SELECT  delivery_id_pk
            FROM Delivery
            INNER JOIN (

              SELECT restaurant_id_pk
              FROM Restaurant
              WHERE restaurant_id_pk = ?
            )Restaurant ON Restaurant.restaurant_id_pk = Delivery.Restaurant_restaurant_id
          )
      )dmm
      INNER JOIN Meal m ON dmm.Meal_meal_id_pk = m.meal_id_pk
      GROUP BY Delivery_delivery_id_pk

    ) mdmm
    INNER JOIN (
      SELECT c.nick , rd.delivery_id_pk, dsdst.date, dsdst.name, rd.shipping_cost
      FROM (

        SELECT d.Customer_customer_id, d.delivery_id_pk, r.shipping_cost
        FROM Delivery d
        INNER JOIN (

          SELECT restaurant_id_pk, shipping_cost
          FROM Restaurant
          WHERE restaurant_id_pk = ?
        )r ON r.restaurant_id_pk = d.Restaurant_restaurant_id
      )rd
      INNER JOIN (
        SELECT ds.Delivery_delivery_id_pk, ds.date, dst.name
        FROM (

          SELECT Delivery_delivery_id_pk, date_pk date, ds.Delivery_State_Type_delivery_status_type
          FROM Delivery_State ds
          WHERE ds.Delivery_State_Type_delivery_status_type = ?
        )ds
        INNER JOIN Delivery_State_Type dst ON dst.delivery_status_type_id_pk = ds.Delivery_State_Type_delivery_status_type

      )dsdst ON dsdst.Delivery_delivery_id_pk = rd.delivery_id_pk
      INNER JOIN Customer c ON rd.Customer_customer_id = c.customer_id_pk
    ) xd ON xd.delivery_id_pk = mdmm.Delivery_delivery_id_pk
    LIMIT ?, ?
    ";

  // Gets the dishes for a specifiv delivery id
  $stmt_select_dish_for_delivery_id = "
    SELECT m.name, dmm.amount,  m.price price_per_item
    FROM (

      SELECT * 
      FROM Delivery_Meal_Map
      WHERE Delivery_delivery_id_pk IN 
        (
          SELECT  delivery_id_pk
          FROM Delivery
          WHERE delivery_id_pk = ?
        )
    )dmm
    INNER JOIN Meal m ON dmm.Meal_meal_id_pk = m.meal_id_pk
    ";


  $answer['success'] = true;

  $answer['data'] = array();
  // Processes $stmt_select_head_info statement
  if(!($select_delivery_result = push_stmt($stmt_select_delivery, "iiiii", 
          array(&$args['id'], &$args['id'], &$args['state'], &$args['start'], &$args['count']))))
    db_error($answer);

  while($select_delivery_result && ($fetched_select_delivery_row = $select_delivery_result->fetch_assoc())) {
    // adds the top level of answer
    $delivery = $fetched_select_delivery_row;

    // adds the dishes
    $delivery['dishes'] = array();
    if(!($select_dish_for_delivery_id_result = push_stmt($stmt_select_dish_for_delivery_id, "i", 
            array(&$delivery['id']))))
      db_error($answer);
    
    while($select_dish_for_delivery_id_result && 
          ($fetched_select_dish_for_delivery_id_row = $select_dish_for_delivery_id_result->fetch_assoc())) {
      $delivery['dishes'][] = $fetched_select_dish_for_delivery_id_row;
    }
    
    $answer['data'][] = $delivery;
  }
  echo json_encode($answer);

?>