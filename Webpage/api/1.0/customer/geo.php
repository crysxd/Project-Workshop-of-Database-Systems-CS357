<?php

  // include main database script
  include_once("../db.php");
  
  // assure all required parameters are available
  if($err = check_parms_available(array("address"))) {
    // set fields for array
    $answer['success'] = false;
    $answer['err_no'] = ERROR_MISSING_PARAM;
    $answer['err_msg'] = $err;
    
  } else {
    // Get the address
    $address = urlencode($_GET['address']);
     
    // google map geocode api url
    $key = "AIzaSyDyIrjYcKwn8UUz2ilfQaBlcqzq-cHT7xQ";
    $url = "https://maps.googleapis.com/maps/api/geocode/json?address={$address}&key={$key}";

    try {
      // get the json response
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_URL, $url);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      $resp_json = curl_exec($ch);
                 
      // decode the json
      $resp = json_decode($resp_json, true);

      // generate answer
      $answer['success'] = true;
      $answer['data'] = $resp;
      
      // generate a simple version of the adress
      foreach($answer['data']['results'] as $k => $v) {
        $address_simple = explode(", ", $v['formatted_address']);
        $answer['data']['results'][$k]['simple'] = array();
        $answer['data']['results'][$k]['simple']['road'] = $address_simple[0];
        $answer['data']['results'][$k]['simple']['city'] = $address_simple[1];
		$answer['data']['results'][$k]['simple']['state'] = $address_simple[2];
        $answer['data']['results'][$k]['simple']['country'] = $address_simple[3];
        $answer['data']['results'][$k]['simple']['postal_code'] = $address_simple[4];
      }
      
    } catch(Exception $e) {
      // set fields for array
      $answer['success'] = false;
      $answer['err_no'] = ERROR_GENERAL;
      $answer['err_msg'] = $e;
    }
  }

  // Encode answer as json and print aka send
  echo json_encode($answer);

?>