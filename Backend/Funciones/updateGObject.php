<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idObject',
  'updateRequest'
]);

$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);
$ImageManager = new ImageManager('public', 'images');

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$object = $GroupsObjects->getObject($neededArgs['idObject']);
if ($object == null) ResponseManager::returnErrorResponse('invalidData');
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $object['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');
// }

//Get the values from the array and the check its itegrity
$updates = ArgumentManager::readUpdateRequest($neededArgs['updateRequest']);
$fieldNameArray = $updates['fieldName'];
$fieldValueArray = $updates['fieldValue'];

//Check if a image is provided for the update
$valid_image = ArgumentManager::checkImage();
if ($valid_image === true) {
  //Save the image
  $grp = $Groups->getGroup($object['idGroup']);
  $imageName = $ImageManager->saveImageGroup($grp['idGroup'], $grp['foundDate']);
  //Get the old img path and remove it
  $oldImage = $object['imagen'];
  if ($oldImage != null) system("rm ../$oldImage");
  //Push the new path to get updated in the request
  $fieldNameArray[] = 'imagen';
  $fieldValueArray[] = $imageName;
}

//Check for empty update
if ( (count($fieldNameArray) === 0) || (count($fieldValueArray) === 0) )
  ResponseManager::returnErrorResponse('emptyUpdate');

//Update the object in the datebase
$updated = $GroupsObjects->updateObject(
  $neededArgs['idObject'],
  $fieldNameArray,
  $fieldValueArray
);

//Return
$json['success'] = $updated;
ResponseManager::returnSuccessResponse(2, $json);
?>
