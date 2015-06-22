<?php
  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("center_lat", "center_long", "start", "count"));

// create answer array
  $answer = array();

  // Prepare Statements
  $stmt_result = $db_link->prepare("
      SELECT r.restaurant_id_pk restaurant, r.name, r.position_lat , r.position_long, Meal_j_Rating.avg_rating, Meal_j_Rating.rating_count, r.shipping_cost, r.min_order_value
      FROM Restaurant r
      INNER JOIN (
        SELECT Meal.Restaurant_restaurant_id, AVG( Rating.rating ) avg_rating, COUNT( Rating.rating ) rating_count
        FROM Meal
        LEFT JOIN Rating ON Meal.meal_id_pk = Rating.Meal_meal_id_pk
        GROUP BY Meal.Restaurant_restaurant_id
      ) Meal_j_Rating
      ON r.restaurant_id_pk = Meal_j_Rating.Restaurant_restaurant_id
      WHERE r.offered =1 && r.max_delivery_range >= DISTANCE( r.position_lat, r.position_long, ?, ? )
      ORDER BY r.restaurant_id_pk
      LIMIT ?, ?");
  $stmt_result->bind_param("ddii", $center_lat, $center_long, $start, $count);

  // assure query parameters are clean and set parameters
  $center_lat = $db_link->real_escape_string($_GET['center_lat']);
  $center_long = $db_link->real_escape_string($_GET['center_long']);
  $start = $db_link->real_escape_string($_GET['start']);
  $count = $db_link->real_escape_string($_GET['count']);

  // Execute queries
  $result = $stmt_result->execute();
  $result = $stmt_result->get_result();

  // if an error occured while performing the query
  if($db_link->errno || !$stmt_result || !$result) {
    // set fields for array
    $answer['success'] = false;
    $answer['err_no'] = ERROR_GENERAL;

    // THIS IS ONLY FOR DEBUGGING PURPOSE!
    // WE SHOULD NOT GIVE AN SQL-ERROR DESCRIPTION TO A POTENTIAL ATTACKER!
    // WE INSTEAD SEND BACK AN EMPTY ARRAY TO HIDE THE ERROR!
    $answer['err_msg'] = "[$db_link->errno] $db_link->error";
    die(json_encode($answer));

  }

  // Everything is fine
  $answer['success'] = true;
  $answer['item_count'] = $result->num_rows;
  $answer['data'] = array();

  while($result && ($row = $result->fetch_assoc())) {
    $row['eta'] = 0;
    //TODO check if he gets min_order_value
    // Test if a icon is available
    $icon_file = get_restaurant_icon_file_name($row['restaurant']);
    if(file_exists($icon_file)) {
      // Store icon as base64
      $row['icon'] = file_get_contents($icon_file);
    }

    // the avg rating is returned as string, so we have to transform it back
    $row['avg_rating'] = floatval($row['avg_rating']);
    
    // append row to data array
    $answer['data'][] = $row;

  }

  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close database connection
  db_close();
?>
