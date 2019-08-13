<?php
header("Content-type: application/json; charset=utf-8");

//Newest version && min valid version
$response = array(
  'error' => false,
  'errorCode' => 0,
  'errorMsg' => '',
  'responseType' => 0,
  'responseData' => array(
    'server_addr' => 'YOUR SERVER IP ADDRESS OR DNS',
    'max_version' => '1.0',
    'min_version' => '0.0'
  )
);
die( json_encode($response) );
?>
