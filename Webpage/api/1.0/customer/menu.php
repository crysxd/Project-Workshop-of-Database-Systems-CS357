<?php
  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("restaurant", "order", "direction", "start", "count"));
  
  // assure query parameters are clean and set parameters
  $restaurant = $db_link->real_escape_string($_GET['restaurant']);
  $order = $db_link->real_escape_string($_GET['order']);
  $direction = $db_link->real_escape_string($_GET['direction']);
  $start = $db_link->real_escape_string($_GET['start']);
  $count = $db_link->real_escape_string($_GET['count']);

  // create answer array
  $answer = array();

  // Prepare Statements

  // For restaurant information
  $stmt_restaurant_result = $db_link->prepare("
      SELECT description, min_order_value, shipping_cost
      FROM Restaurant
      WHERE restaurant_id_pk = ?");
  $stmt_restaurant_result->bind_param("i", $restaurant);
  // $stmt_restaurant_result->close();

  // For meal information
  $ascOrDesc = ($direction=="DESC") ? "DESC" : "ASC";
  $stmt_meal = "
      SELECT Meal.meal_id_pk meal_id, Meal.name name, Meal.price price, Meal.spiciness spicy, AVG( Rating.rating ) rating, COUNT( Rating.rating ) rating_count
      FROM Meal
      INNER JOIN Rating ON Meal.meal_id_pk = Rating.Meal_meal_id_pk
      WHERE Meal.offered = 1 && Meal.Restaurant_restaurant_id = ?
      GROUP BY Meal.meal_id_pk
      ORDER BY ? $ascOrDesc
      LIMIT ?, ?";
  $stmt_meal_result = $db_link->prepare($stmt_meal);
  $stmt_meal_result->bind_param("isii", $restaurant, $order, $start, $count);

  //For tag information of meal
  $stmt_tag_result = $db_link->prepare("
      SELECT Tag.name, Tag.color
      FROM Tag
      INNER JOIN (

        SELECT Meal_Tag_Map.Tag_tag_id_pk
        FROM Meal
        INNER JOIN Meal_Tag_Map ON Meal.meal_id_pk = Meal_Tag_Map.Meal_meal_id_pk
        WHERE Meal.offered =1 && Meal.Restaurant_restaurant_id = ? && Meal.meal_id_pk = ?
      )Meal_x_Meal_Tag_Map ON Tag.tag_id_pk = Meal_x_Meal_Tag_Map.Tag_tag_id_pk");

  // Execute queries
  $restaurant_result = $stmt_restaurant_result->execute();
  $restaurant_result = $stmt_restaurant_result->get_result();
  $meal_result = $stmt_meal_result->execute();
  $meal_result = $stmt_meal_result->get_result();


  // if an error occured while performing the query
  if($db_link->errno || !$stmt_restaurant_result || !$restaurant_result || !$stmt_meal_result || !$meal_result) {
    // set fields for array
    $answer['success'] = false;
    $answer['err_no'] = ERROR_GENERAL;

    // THIS IS ONLY FOR DEBUGGING PURPOSE!
    // WE SHOULD NOT GIVE AN SQL-ERROR DESCRIPTION TO A POTENTIAL ATTACKER!
    // WE INSTEAD SEND BACK AN EMPTY ARRAY TO HIDE THE ERROR!
    $answer['err_msg'] = "[$db_link->errno] $db_link->error";
    die(json_encode($answer));

  }

  if($restaurant_result && ($fetched_restaurant_row = $restaurant_result->fetch_assoc())) {
    $answer['description'] = $fetched_restaurant_row['description'];
    $answer['min_order_value'] = $fetched_restaurant_row['min_order_value'];
    $answer['shipping_cost'] = $fetched_restaurant_row['shipping_cost'];
  }

  // Test if a icon is available
  $icon_file = get_restaurant_icon_file_name($restaurant);
  if(file_exists($icon_file)) {
    // Store icon as base64
    $answer['icon'] = base64_encode(file_get_contents($icon_file));
  }
  // create meal data array
  $answer['data'] = array();

  // Fetches the meal data
  while($meal_result && ($fetched_meal_row = $meal_result->fetch_assoc())) {
	// Creates tag data array
	$fetched_meal_row['tags'] = array();

    // Bind and execute tag statement
    $stmt_tag_result->bind_param("ii", $restaurant, $fetched_meal_row['meal_id']);
    $tag_result = $stmt_tag_result->execute();
    $tag_result = $stmt_tag_result->get_result();

    // if an error occured while performing the query
    if($db_link->errno || !$stmt_tag_result || !$tag_result) {
      // set fields for array
      $answer['success'] = false;
      $answer['err_no'] = ERROR_GENERAL;

      // THIS IS ONLY FOR DEBUGGING PURPOSE!
      // WE SHOULD NOT GIVE AN SQL-ERROR DESCRIPTION TO A POTENTIAL ATTACKER!
      // WE INSTEAD SEND BACK AN EMPTY ARRAY TO HIDE THE ERROR!
      $answer['err_msg'] = "[$db_link->errno] $db_link->error";
      die(json_encode($answer));

    }

    while($meal_result && ($fetched_tag_row = $tag_result->fetch_assoc())) {
      $fetched_meal_row['tags'][] = $fetched_tag_row;
    }

    // Delete information of meal id
    $fetched_meal_row['meal_id'] = 0;
    unset($fetched_meal_row['meal_id']);

    // append row to data array
    $answer['data'][] = $fetched_meal_row;

  }

  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close database connection
  db_close();
?>
