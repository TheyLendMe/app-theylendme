<?php
//FIXME : Para cambiar de la version anterior a la actual en la forma de los updates
// 1 : cambiar en los parametros de entrada fieldName y fieldValue por updateRequest
// 2 : cambiar ArgumentManager::stringToArray por ArgumentManager::readUpdateRequest
// 3 : test it

//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'updateRequest'
]);

$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);
$ImageManager = new ImageManager('public', 'images');

//Auth
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

//Get update values
$updates = ArgumentManager::readUpdateRequest($neededArgs['updateRequest']);
$fieldNameArray = $updates['fieldName'];
$fieldValueArray = $updates['fieldValue'];

//Check for image
$valid_image = ArgumentManager::checkImage();
if ($valid_image === true) {
  //Save the new one
  $imageName = $ImageManager->saveImageUser($neededArgs['idUser']);
  //Remove the old one
  $oldImage = $usersInstance->getUser($neededArgs['idUser'])['imagen'];
  if ($oldImage != null && file_exists("rm ../$oldImage")) system("rm ../$oldImage");
  //Push the path to the update
  $fieldNameArray[] = 'imagen';
  $fieldValueArray[] = $imageName;
}

//Check for empty update
if ( (count($fieldNameArray) === 0) || (count($fieldValueArray) === 0) ){
  ResponseManager::returnErrorResponse('emptyUpdate');
}

//Exec the update
$updated = $usersInstance->updateUser(
  $neededArgs['idUser'],
  $fieldNameArray,
  $fieldValueArray
);

//Return
$json['success'] = $updated;
ResponseManager::returnSuccessResponse(2, $json);
?>
