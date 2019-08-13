<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idObject'
]);

//Class instances
$UsersObjects = new UsersObjects($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);
$UsersEstadistics = new UsersEstadistics($pdo);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$obj = $UsersObjects->getObject($neededArgs['idObject']);
if ($obj == null) ResponseManager::returnErrorResponse('invalidData');
if ($obj['idUser'] != $neededArgs['idUser']) ResponseManager::returnErrorResponse('permission');
// }

//Logic
$success = $UsersObjects->deleteObject(
  $neededArgs['idObject'],
  $neededArgs['idUser']
);

if ($success === true){
  //Delete obj image if exists
  $image_path = $obj['imagen'];
  if ($image_path != null) {
    if (file_exists("../$image_path")) system("rm ../$image_path");
  }
  //Decrement published objects
  // $UsersEstadistics->decrementObjectsPublished($neededArgs['idUser']);
}

//Return
$json['status'] = $success;
ResponseManager::returnSuccessResponse(2, $json);
?>
