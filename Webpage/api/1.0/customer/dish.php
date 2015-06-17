<?php
  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("dish", "start", "count"));

  // assure query parameters are clean and set parameters
  escape_parms(array("dish", "start", "count"));
                      
  $dish = $_GET['dish'];
  $start = $_GET['start'];
  $count = $_GET['count'];

  // create answer array
  $answer = array();

  $stmt_select_head_info = "
      SELECT m.description, AVG( r.rating ) avg_rating, COUNT( r.rating ) rating_count
      FROM (

        SELECT meal_id_pk, description
        FROM Meal
        WHERE meal_id_pk = ?
        LIMIT ?, ?
      )m 
      INNER JOIN Rating r ON m.meal_id_pk = r.Meal_meal_id_pk";

  $stmt_select_data = "
    SELECT c.nick composer, c.first_name sure_name, c.last_name, r.rating, r.comment, r.date
    FROM Customer c
    INNER JOIN (

      SELECT Customer_customer_id_pk composer_id, rating, 
      COMMENT , DATE
      FROM Rating
      WHERE Meal_meal_id_pk = ?
      LIMIT ?, ?
    )r ON r.composer_id = c.customer_id_pk
  ";

  $answer['success'] = true;

  // Bind $stmt_select_head_info and execute
  if($stmt_select_head_info_result = $db_link->prepare($stmt_select_head_info)){
    $stmt_select_head_info_result->bind_param("iii", $dish, $start, $count);
    $select_head_info_result = $stmt_select_head_info_result->execute();
    $select_head_info_result = $stmt_select_head_info_result->get_result();
  } else {
    db_error($answer, "Line " . __LINE__);
  }

  if($select_head_info_result && $select_head_info_result->num_rows == 1
      && ($fetched_select_head_info_row = $select_head_info_result->fetch_assoc())){   
    $answer['description'] = $fetched_select_head_info_row['description'];
    $answer['avg_rating'] = $fetched_select_head_info_row['avg_rating'];  
    $answer['rating_count'] = $fetched_select_head_info_row['rating_count'];  
  } else {
    db_error($answer, "Line " . __LINE__);
  }

  $answer['data'] = array();

  if($stmt_select_data_result = $db_link->prepare($stmt_select_data)){
    $stmt_select_data_result->bind_param("iii", $dish, $start, $count);
    $select_data_result = $stmt_select_data_result->execute();
    $select_data_result = $stmt_select_data_result->get_result();
  } else {
    db_error($answer, "Line " . __LINE__);
  }

  while($select_data_result && ($fetched_data_row = $select_data_result->fetch_assoc()))
      $answer['data'][] = $fetched_data_row;
  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close database connection
  db_close();
?>
