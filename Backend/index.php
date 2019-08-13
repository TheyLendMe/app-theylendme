<?php
header("Content-type: application/json; charset=utf8");

//General classes
include_once('Models/Others/ArgumentManager.php');
include_once('Models/Others/AccountingManager.php');
include_once('Models/Others/ConnectionManager.php');
include_once('Models/Others/ErrorManager.php');
include_once('Models/Others/ImageManager.php');
include_once('Models/Others/PrivateCodeManager.php');
include_once('Models/Others/ResponseManager.php');
$pdo = ConnectionManager::connectPDO();

//Firebase auth classes
require('vendor/autoload.php');
include_once('Models/Others/AuthManager.php');

//Models
include_once('Models/models_loader.php');

//Accounting
AccountingManager::setup('../../api_logs/logs.json');
AccountingManager::recordInput();
AccountingManager::save('../../api_logs/logs.json');

//Function request
//this line throws a notice when accesing index 1 in "endpoint/anything/" (anything instead app, which works nice)
//if there is something before, like : anything/something -> function not found.
$function = explode('/',filter_var(trim($_SERVER['REQUEST_URI'], '/'), FILTER_SANITIZE_URL))[1];
if (!@include_once("Funciones/$function.php")){
  ResponseManager::returnErrorResponse('function');
}
?>
