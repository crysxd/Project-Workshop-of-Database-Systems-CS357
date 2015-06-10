<?php
  define("DB_HOST", "localhost");
  define("DB_USER", "mymeal_admin");
  define("DB_PASS", "u9wZpVbs7xbD45JR");
  define("DB_NAME", "mymeal");
  define("IMAGE_DIRECTORY", "img");
  define("PASSWORD_HASH_FUNCTION", "sha1");
  define("ERROR_GENERAL", 0);
  define("ERROR_UNAUTHORIZED", 1);
  define("ERROR_MISSING_PARAM", 2);

  /****************************************************************************************************************************
   * Opens a connection to the database
   */
  function db_open() {
    global $db_link;
    
    //Abbrechen wenn bereits geöffnet
    if($db_link != null) {
      return;
    }
    
    $db_link = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

    if (!$db_link || $db_link->connect_error) {
      echo $db_link->connect_error;
      die();
    }
  }

  /****************************************************************************************************************************
   * Closes the connection to the database
   */
  function db_close() {
    global $db_link;
    
    if($db_link != null) {
      $db_link->close();
      $db_link = null;
    
    } 
  }  

  /****************************************************************************************************************************
   * Assures all neeeded parameteres are availabel in $_GET
   */
  function check_parms_available($params) { 
	global $db_link;
	
    foreach($params as $i => $p) {
      // Check if key is available
      if(!array_key_exists ($p, $_GET) || strlen($_GET[$p]) == 0) {
        die(json_encode(array("success" => false, "err_no" => ERROR_MISSING_PARAM, "err_msg" => "Required parameter \"$p\" is missing.")));
      }
      
      //escape the value
      $_GET[$p] = htmlentities($db_link->real_escape_string($_GET[$p]));
    }
  }

  /****************************************************************************************************************************
   * Returns the path to the icon file for the restaurant with the given id.
   */
  function get_restaurant_icon_file_name($restaurant_id) {
    return get_image_dir()."/restaurant_".$restaurant_id;
  }

  /****************************************************************************************************************************
   * Returns the path to the directory storing all images
   */
  function get_image_dir() {
    return dirname(__FILE__)."/".IMAGE_DIRECTORY;
  }

  /****************************************************************************************************************************
   * Checks if the given session is valid for the given customer. Kills the PHP script if the user is unauthorized
   */
  function check_customer_session($user, $session) {
    global $db_link;
    
    // Create a answer for unauthorized users
    $answer = json_encode(array("success" => false, "err_no" => ERROR_UNAUTHORIZED));

    // Preapre query
    if(!$stmt = $db_link->prepare("SELECT COUNT(*) as ok FROM customer WHERE nick=? AND session=?")) {
      die($answer);
    }
    
    // Bind params
    if(!$stmt->bind_param("ss", $user, $session)) {
      die($answer);
    }
    
    // Execute
    if(!$stmt->execute()) {
      die($answer);
    }
    
    // Check result
    if($stmt->get_result()->fetch_assoc()['ok'] != 1) {
      die($answer);
    }
  }

  /****************************************************************************************************************************
   * Starts a new session for the given user. The session id is returned
   */
  function start_session($user) {
    global $db_link;
   
    // Generate session id
    $session = bin2hex(openssl_random_pseudo_bytes(32));

    // Put session id
    $db_link->query("UPDATE customer SET session=\"$session\" WHERE nick=$user");
    
    //return
    return $session;
  }
?>

