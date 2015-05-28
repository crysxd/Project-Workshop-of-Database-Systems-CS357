<?php
  define("DB_HOST", "localhost");
  define("DB_USER", "root");
  define("DB_PASS", "");
  define("DB_NAME", "mydb");
  define("IMAGE_DIRECTORY", "img");
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
    foreach($params as $i => $p) {
      if(!array_key_exists ($p, $_GET)) {
        return "Required parameter \"$p\" is missing.";
      }
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
?>

