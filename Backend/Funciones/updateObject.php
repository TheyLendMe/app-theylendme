<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idObject',
  'updateRequest'
]);

//Logic
$UsersObjects = new UsersObjects($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);
$ImageManager = new ImageManager('public', 'images');

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$updatedObject = $UsersObjects->getObject($neededArgs['idObject']);
if ($updatedObject == null) ResponseManager::returnErrorResponse('invalidData');
if ($updatedObject['idUser'] != $neededArgs['idUser']) ResponseManager::returnErrorResponse('permission');
// }

//Get values for the update
$updates = ArgumentManager::readUpdateRequest($neededArgs['updateRequest']);
$fieldNameArray = $updates['fieldName'];
$fieldValueArray = $updates['fieldValue'];

//Check for image
$valid_image = ArgumentManager::checkImage();
if ($valid_image === true) {
  //Save new image
  $imageName = $ImageManager->saveImageUser($neededArgs['idUser']);
  //Remove old one
  $oldImage = $UsersObjects->getObject($neededArgs['idObject'])['imagen'];
  if ($oldImage != null) system("rm ../$oldImage");
  //Update the new one in the db
  $fieldNameArray[] = 'imagen';
  $fieldValueArray[] = $imageName;
}

//Check for empty update
if ( (count($fieldNameArray) === 0) || (count($fieldValueArray) === 0) ){
  ResponseManager::returnErrorResponse('emptyUpdate');
}

//Exec the update
$updated = $UsersObjects->updateObject(
  $neededArgs['idObject'],
  $fieldNameArray,
  $fieldValueArray
);

//Return
$json['success'] = $updated;
ResponseManager::returnSuccessResponse(2, $json);
?>
