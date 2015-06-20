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
      rest_delete();  
      break;
    case 'GET':
      rest_get();  
      break;
    case 'POST':
      rest_post();  
      break;
    case 'PUT':
      rest_put();  
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
    
    // create answer 
    $answer = array();
    $answer['success'] = true;
    $answer['data'] = array();
    $meal_id = 0;
    
    // prepare statement to fetch all tags for a dish
    if(!$stmt_tags = $db_link->prepare("SELECT name, color ".
                                       "FROM tag ".
                                       "INNER JOIN meal_tag_map ON tag.tag_id_pk = meal_tag_map.tag_tag_id_pk ".
                                       "WHERE meal_tag_map.meal_meal_id_pk = ?")) {
      db_error();
    }
    
    // bind
    if(!$stmt_tags->bind_param("s", $meal_id)) {
      db_error();
    }
    
    // prepare statement to fetch all dishes
    if(!$stmt_dishes = $db_link->prepare("SELECT meal_id_pk AS id, name, price, description ".
                                         "FROM meal ".
                                         "WHERE restaurant_restaurant_id = ? AND offered = true")) {
      db_error();
    }
    
    // bind, execute and get result
    if(!$stmt_dishes->bind_param("s", $_GET['id']) || !$stmt_dishes->execute() || !$result=$stmt_dishes->get_result()) {
      db_error();
    }
    
    // copy to answer
    while($row = $result->fetch_assoc()) {
      // bind
      $meal_id = $row['id'];
      
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
      $answer['data'][] = $row;
      
    }
    
    // Send result
    echo json_encode($answer);

  }

  /****************************************************************************************************************************
   * Handles delete requests
   */    
  function rest_delete() {
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
    echo json_encode(array("success" => true));
    
  }

  /****************************************************************************************************************************
   * Handles put requests
   */    
  function rest_put() {
    global $db_link;
    
    // assure all params needed are supplied
    check_parms_available(array("name", "price", "description", "tags", "spiciness"));

    // This works by inserting an empty meal, fetching the id and then updating it
    $stmt = $db_link->prepare("INSERT into meal(restaurant_restaurant_id, name, price, description, spiciness, offered) ".
                              "VALUES (?, 'undefined', 0, 'undefined', 0, 0)");
    
    // bind, execute and fetch result
    if(!$stmt || !$stmt->bind_param("s", $_GET['id']) || !$stmt->execute()) {
      db_error();
    }
    
    // Inject the id of the new meal into $_GET and call post to update
    $_GET['dish'] = $db_link->insert_id;
    
    // Call post to update the new entry with the values
    rest_post();
    
  }

  /****************************************************************************************************************************
   * Handles delete requests
   */    
  function rest_post() {
    global $db_link;

    // assure all params needed are supplied
    check_parms_available(array("name", "price", "description", "tags", "spiciness", "dish"));
    
     // This works by inserting an empty meal, fetching the id and then updating it
    if(!$stmt = $db_link->prepare("UPDATE meal ".
                                  "SET name = ?, price = ?, description = ?, spiciness = ?, offered = 1 ".
                                  "WHERE restaurant_restaurant_id = ? AND meal_id_pk = ?")) {
      db_error();
    }
    
    // bind, execute and fetch result
    $bind = $stmt->bind_param("sisiii", 
                              $_GET['name'], 
                              $_GET['price'], 
                              $_GET['description'], 
                              $_GET['spiciness'], 
                              $_GET['id'], 
                              $_GET['dish']);
    
    // check bind and execute
    if(!$bind || !$stmt->execute()) {
      db_error();
    }
    
    // clean the tags
    $stmt = $db_link->prepare("DELETE FROM meal_tag_map WHERE meal_meal_id_pk = ?");
    
    // bind, execute and fetch result
    if(!$stmt || !$stmt->bind_param("i", $_GET['dish']) || !$stmt->execute()) {
      db_error();
    }
    
    // Parse tags array
    $tags = json_decode($_GET['tags']);
    
    // Prepare insert statement
    $stmt = $db_link->prepare("INSERT INTO meal_tag_map (meal_meal_id_pk, tag_tag_id_pk) VALUES (?, ?)");
    
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
    
    // send answer
    echo json_encode(array("success" => true, "dish" => $_GET['dish']));
  
  }

?>