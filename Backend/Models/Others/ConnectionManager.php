<?php class ConnectionManager {

  public static function connectPDO(){
    //Declare connection variables
    $pdo_description="mysql:host=localhost;dbname=db_api";
    $pdo_user="root";
    $pdo_pass="YOUR SQL PASSWORD";

    //Connect
    try {
    	$pdo = new PDO( $pdo_description, $pdo_user , $pdo_pass);
    } catch (PDOException $e) {
    	ResponseManager::returnErrorResponse('connection');
    }

    //Configure error mode
    //TODO: COMENTAR ATTRIBUTE, DESCOMENTAR ERROR REPORTING EN EL PUBLISH
    $pdo->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // error_reporting(0);

    //return the conexion
    return $pdo;
  }

} ?>
