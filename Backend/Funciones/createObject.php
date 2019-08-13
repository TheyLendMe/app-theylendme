<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token'
]);
$optionalArgs = ArgumentManager::addOptionalPostArguments([
  'name',
  'amount',
  'desc'
]);

$UsersObjects = new UsersObjects($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);
$ImageManager = new ImageManager('public', 'images');
$UsersEstadistics = new UsersEstadistics($pdo);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');
// }

//Save the image if a valid one is provided
$valid_image = ArgumentManager::checkImage();
if ($valid_image === true) {
  $optionalArgs['imagen'] = $ImageManager->saveImageUser($neededArgs['idUser']);
}else{
  $optionalArgs['imagen'] = null;
}

//Create the object
$idObject = $UsersObjects->createObject(
  $neededArgs['idUser'],
  $optionalArgs['name'],
  $optionalArgs['imagen'],
  $optionalArgs['amount'],
  $optionalArgs['desc']
);
if ($idObject == null) ResponseManager::returnErrorResponse('invalidData');

// $UsersEstadistics->incrementObjectsPublished($neededArgs['idUser']);

//Return
$json['idObject'] = $idObject;
ResponseManager::returnSuccessResponse(1, $json);
?>
