<?php

  // include main database script
  include_once("../db.php");

  // open db 
  db_open();

  //Init answer
  $answer = array();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("session", "id", "meal"));

  // assure user is logged in
  check_restaurant_session($_GET['id'], $_GET['session']);

  // Create answer array 
  $answer = array();

  // Check if meal belongs to restaurant
  $stmt = $db_link->prepare("SELECT COUNT(*) AS ok ".
                            "FROM meal ".
                            "WHERE meal_id_pk = ? AND restaurant_restaurant_id = ?");

  // If preperation failed
  if(!$stmt) {
    db_error($answer);

  }

  //bind params
  $stmt->bind_param("ss", $_GET['meal'], $_GET['id']);

  // Execute
  $stmt->execute();
  $result = $stmt->get_result();   

  // If error or meal belongs not to restaurant
  if(!$result || $result->fetch_assoc()['ok'] < 1) {
    db_error($answer, "Meal belongs not to restaurant", ERROR_UNAUTHORIZED);

  }

  // Select which code to run based on request method
  switch ($_SERVER['REQUEST_METHOD']) {
    case 'PUT':
      rest_put();  
      break;
    case 'GET':
      rest_get();  
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
    
    // Init answer
    $answer = array();
    $answer['image'] = null;
    $answer['image_mime'] = null;
    
    // Load image if exists
    $file = get_meal_image_file_name($_GET['meal']);
    if(file_exists($file)) {
      // Load image
      $answer['image'] = base64_encode(file_get_contents($file));
      
      //Get MIME (PNG, JPEG, etc...)
      $answer['image_mime'] = mime_content_type ($file);

    }
    
    // Encode answer as json and print aka send
    echo json_encode($answer);

  }

  /****************************************************************************************************************************
   * Handles put requests
   */    
  function rest_put() {
    global $db_link;
    
    // Load the icon
    $icon = file_get_contents("php://input");

    // Remove data URL
    $start = strpos($icon, ",");
    $icon = substr($icon, $start);

    // Decode
    $raw = base64_decode($icon);

    // Open stream and handle errors
    $file_path = get_meal_image_file_name($_GET['meal']);
    $file = fopen($file_path, "w");
    if(!$file) {
      db_error(array(), "Unable to open output file: \"$file_path\"");
    }
    
    // Write
    fwrite($file, $raw);
    fclose($file);
      
    echo json_encode(array("success" => true));

  }

?>