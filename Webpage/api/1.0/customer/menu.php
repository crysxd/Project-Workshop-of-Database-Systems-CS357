<?php
  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("restaurant", "order", "direction", "start", "count"));
  
  // assure query parameters are clean and set parameters
  escape_parms(array("restaurant", "order", "direction", "start", "count", "search"));

  $restaurant = $_GET['restaurant'];
  $order = $_GET['order'];
  $direction = $_GET['direction'];
  $start = $_GET['start'];
  $count = $_GET['count'];
  $search = $_GET['search'];
  // Adding for MySQL search support
  $search = '%' . $search . '%';

  // create answer array
  $answer = array();

  // Prepare Statements

  // For restaurant information
  $stmt_restaurant ="
      SELECT r.restaurant_id_pk restaurant, r.name name, r.description, r.min_order_value, r.shipping_cost ,Meal_j_Rating.avg_rating, Meal_j_Rating.rating_count
      FROM Restaurant r
      INNER JOIN (
        SELECT Meal.meal_id_pk, Meal.Restaurant_restaurant_id, AVG( Rating.rating ) avg_rating, COUNT( Rating.rating ) rating_count
        FROM Meal
        LEFT JOIN Rating ON Meal.meal_id_pk = Rating.Meal_meal_id_pk
        WHERE Meal.Restaurant_restaurant_id = ?
        GROUP BY Meal.Restaurant_restaurant_id
      ) Meal_j_Rating
      ON r.restaurant_id_pk = Meal_j_Rating.Restaurant_restaurant_id
      WHERE r.offered = 1";

  if ($stmt_restaurant_result = $db_link->prepare($stmt_restaurant))
    $stmt_restaurant_result->bind_param("i", $restaurant);
  else  
    db_error($answer, "" . __LINE__);
  // $stmt_restaurant_result->close();

  // For meal information
  $ascOrDesc = ($direction=="DESC") ? "DESC" : null;
  $ascOrDesc = ($direction=="ASC") ? "ASC" : $ascOrDesc;

  // Cancel execution if the direction is not ASC or DESC, potential hack
  if($ascOrDesc == null)
    db_error($answer, '$ascOrDesc was not proper initialized in line '. __LINE__);
  
  // The $order string cannot be passed in the statement because it ends up as 'CONTENT_OF_$order' which mysql does not recognize
  // Therefore we to insert it in the statement and build a switch case for security reasons
  switch($order) {
    case 'name':
      break;
    case 'price':
      break;
    case 'spicy':
      $order='spiciness';
      break;
    case 'spiciness':
      break;
    case 'avg_rating':
      break;
    case 'rating_count':
      break;
    default:
      die(json_encode(array("success" => false, "err_no" => ERROR_GENERAL, "err_msg" => "Unsuported method {$_SERVER['REQUEST_METHOD']}")));
  }

  $stmt_meal = "
      SELECT Meal.meal_id_pk meal_id, Meal.name name, Meal.price price, Meal.spiciness spicy, AVG( Rating.rating ) avg_rating, COUNT( Rating.rating ) rating_count
      FROM Meal
      LEFT JOIN Rating ON Meal.meal_id_pk = Rating.Meal_meal_id_pk
      WHERE Meal.offered = 1 && Meal.Restaurant_restaurant_id = ? && Meal.name LIKE ?
      GROUP BY Meal.meal_id_pk
      ORDER BY $order $ascOrDesc 
      LIMIT ?, ?";
  if($stmt_meal_result = $db_link->prepare($stmt_meal))
    $stmt_meal_result->bind_param("ssss", $restaurant, $search, $start, $count );
  else
    db_error($answer, "" . __LINE__);


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


  // Execute restaurant queries
  $restaurant_result = $stmt_restaurant_result->execute();
  $restaurant_result = $stmt_restaurant_result->get_result();

  // if an error occured while performing the query
  if($db_link->errno || !$stmt_restaurant_result || !$restaurant_result)
    db_error($answer, "Something failed " . __LINE__);

  if($restaurant_result && ($fetched_restaurant_row = $restaurant_result->fetch_assoc())) {
    $answer['restaurant'] = $fetched_restaurant_row['restaurant'];
    $answer['description'] = $fetched_restaurant_row['description'];
    $answer['min_order_value'] = $fetched_restaurant_row['min_order_value'];
    $answer['name'] = $fetched_restaurant_row['name'];
    $answer['shipping_cost'] = $fetched_restaurant_row['shipping_cost'];
    $answer['avg_rating'] = floatval($fetched_restaurant_row['avg_rating']);
    $answer['rating_count'] = $fetched_restaurant_row['rating_count'];
  }

  // create meal data array
  $answer['data'] = array();

  // execute meal queries

  $meal_result = $stmt_meal_result->execute();
  $meal_result = $stmt_meal_result->get_result();

  if(!$stmt_meal_result || !$meal_result)
    db_error($answer, "Something failed " . __LINE__);

  //var_dump($meal_result);
  // Fetches the meal data
 // var_dump($meal_result->fetch_assoc());
  while($meal_result && ($fetched_meal_row = $meal_result->fetch_assoc())) {
    //var_dump($fetched_meal_row);
	// Creates tag data array
	$fetched_meal_row['tags'] = array();

    // Bind and execute tag statement
    $stmt_tag_result->bind_param("ii", $restaurant, $fetched_meal_row['meal_id']);
    $tag_result = $stmt_tag_result->execute();
    $tag_result = $stmt_tag_result->get_result();

    // if an error occured while performing the query
    if($db_link->errno || !$stmt_tag_result || !$tag_result) 
      db_error($answer, "Meal selecting failed " . __LINE__);

    while($meal_result && ($fetched_tag_row = $tag_result->fetch_assoc())) {
      $fetched_meal_row['tags'][] = $fetched_tag_row;
    }
    
    // the avg rating is returned as string, so we have to transform it back
    $fetched_meal_row['avg_rating'] = floatval($fetched_meal_row['avg_rating']);
    
    // append row to data array
    $answer['data'][] = $fetched_meal_row;
    
  }

  // Test if a icon is available
  $icon_file = get_restaurant_icon_file_name($restaurant);
  $answer['icon'] = null;
  if(file_exists($icon_file)) {
    // Store icon as base64
    $answer['icon'] = file_get_contents($icon_file);
  }

  $answer['success'] = true;

  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close database connection
  db_close();
?>
