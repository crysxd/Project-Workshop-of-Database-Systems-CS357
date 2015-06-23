<?php

  // include main database script
  include_once("../db.php");

  // open db 
  db_open();

  //Init answer
  $answer = array();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("session", "id"));

  // assure user is logged in
  check_restaurant_session($_GET['id'], $_GET['session']);

  // Create answer array 
  $answer = array();

  // Select which code to run based on request method
  switch ($_SERVER['REQUEST_METHOD']) {
    case 'DELETE':
      rest_delete(true);  
      break;
    case 'GET':
      rest_get();  
      break;
    case 'POST':
      rest_post();  
      break;
    case 'PUT':
      rest_put(array());  
      break;
    default:
      db_error($answer, "Unsuported method {$_SERVER['REQUEST_METHOD']}");
    
  }

  // close database connection
  db_close();

  /****************************************************************************************************************************
   * Handles get requests
   */    
  function rest_get() {
    global $db_link;
    
    check_parms_available(array("session", "id", "dish"));
    
    // prepare statement to fetch all tags for a dish
    if(!$stmt_tags = $db_link->prepare("SELECT name, color, tag_id_pk AS id
                                        FROM tag
                                        INNER JOIN meal_tag_map ON tag.tag_id_pk = meal_tag_map.tag_tag_id_pk
                                        WHERE meal_tag_map.meal_meal_id_pk = ?")) {
      db_error();
    }
    
    // bind
    if(!$stmt_tags->bind_param("s", $_GET['dish'])) {
      db_error();
    }
    
    // prepare statement to fetch all dishes
    if(!$stmt_dishes = $db_link->prepare("SELECT meal_id_pk AS id, name, price, description, spiciness
                                          FROM meal
                                          WHERE restaurant_restaurant_id = ? AND meal_id_pk = ? AND offered = true")) {
      db_error();
    }
    
    // bind, execute and get result
    if(!$stmt_dishes->bind_param("ss", $_GET['id'], $_GET['dish']) || !$stmt_dishes->execute() || !$result=$stmt_dishes->get_result()) {
      db_error();
    }
    
    // There must be one answer
    if(!$row = $result->fetch_assoc()) {
      db_error();
    }
    
    // execute
    if(!$stmt_tags->execute()) {
      db_error();
    }

    // fetch results
    if(!$tag_result = $stmt_tags->get_result()) {
      db_error();
    }

    // copy tags
    $row['tags'] = array();
    while($tag = $tag_result->fetch_assoc()) {
      $row['tags'][] = $tag;
    } 

    // append to answer
    $row['success'] = true;

    // Send result
    echo json_encode($row);

  }

  /****************************************************************************************************************************
   * Handles delete requests
   */    
  function rest_delete($output_answer) {
    global $db_link;
    
    // check param
    check_parms_available(array("dish"));
    
    // check if meal belongs to restaurant
    if(!$stmt_assure = $db_link->prepare("SELECT restaurant_restaurant_id AS id FROM meal WHERE meal_id_pk = ?")) {
      db_error();
    }
    
    // bind, execute and fetch result
    if(!$stmt_assure->bind_param("s", $_GET['dish']) || !$stmt_assure->execute() || !$result=$stmt_assure->get_result()) {
      db_error();
    }

    // check if meal belongs to restaurant
    if($result->fetch_assoc()['id'] != $_GET['id']) {
      db_error(array(), "Unauthorized", ERROR_UNAUTHORIZED);
    }
    
    // delete (set offered flag to false)
    if(!$stmt_delete = $db_link->prepare("UPDATE meal SET offered = false WHERE meal_id_pk = ?")) { 
      db_error();
    }

    // bind, execute and fetch result
    if(!$stmt_delete->bind_param("s", $_GET['dish']) || !$stmt_delete->execute()) {
      db_error();
    }
    
    // echo answer
    if($output_answer)
      echo json_encode(array("success" => true, "id" => $_GET['dish']));
    
  }

  /****************************************************************************************************************************
   * Handles put requests
   */    
  function rest_put($answer) {
    global $db_link;
    
    // assure all params needed are supplied
    check_parms_available(array("name", "price", "description", "tags", "spiciness"));

    // This works by inserting an empty meal, fetching the id and then updating it
    $stmt = $db_link->prepare("INSERT into meal(restaurant_restaurant_id, name, price, description, spiciness, offered) ".
                              "VALUES (?, ?, ?, ?, ?, 1)");
    
    // Check for error
    if(!$stmt) {
      db_error();
    }
    
    // bind, execute and fetch result
    $bind = $stmt->bind_param("isisi", 
                              $_GET['id'], 
                              $_GET['name'], 
                              $_GET['price'], 
                              $_GET['description'], 
                              $_GET['spiciness']);
    
    // check bind and execute
    if(!$bind || !$stmt->execute()) {
      db_error();
    }
    
    // Parse tags array
    $tags = json_decode($_GET['tags']);
    
    // Prepare insert statement
    $stmt = $db_link->prepare("INSERT INTO meal_tag_map (meal_meal_id_pk, tag_tag_id_pk) VALUES (?, ?)");
    
    // Inject dish id into GET
    $_GET['dish'] = $db_link->insert_id;
    
    // Bind param
    $tag_id = 0;
    if(!$stmt || !$stmt->bind_param("ii", $_GET['dish'], $tag_id)) {
      db_error();
    }
    
    // Insert all tags
    foreach($tags as $i => $tag_id) {
      if(!$stmt->execute()) {
        db_error();
      }
    }
    
    // Update image if supplied
    $input = file_get_contents('php://input');
    if($input) {
      $file = get_meal_image_file_name($_GET['dish']);
      save_image_from_input($file);
    }
    
    // return answer
    $answer['success'] = true;
    $answer['id'] = $_GET['dish'];
    $answer['name'] = $_GET['name'];    
    echo json_encode($answer);
    
  }

  /****************************************************************************************************************************
   * Handles delete requests
   */    
  function rest_post() {
    
    // disable the old entry
    rest_delete(false);

    // Create a new entry
    rest_put(array('old_id' => $_GET['dish']));
    
  }

?>