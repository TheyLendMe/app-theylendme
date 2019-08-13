<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup',
  'updateRequest'
]);

$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);
$ImageManager = new ImageManager('public', 'images');

//Auth
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$grp = $Groups->getGroup($neededArgs['idGroup']);
if ($grp == null) ResponseManager::returnErrorResponse('invalidData');
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $neededArgs['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');
// }

//Get uppdate var array -> ArrayFormat and length errors
$updates = ArgumentManager::readUpdateRequest($neededArgs['updateRequest']);
$fieldNameArray = $updates['fieldName'];
$fieldValueArray = $updates['fieldValue'];

//Check for image
$valid_image = ArgumentManager::checkImage();
if ($valid_image === true) {
  //Save the image
  $imageName = $ImageManager->saveImageGroup($grp['idGroup'], $grp['foundDate']);
  //Remove the old one
  $oldImage = $grp['imagen'];
  if ($$oldImage != null) system("rm ../$oldImage");
  //Push the new path to the update
  $fieldNameArray[] = 'imagen';
  $fieldValueArray[] = $imageName;
}

//Check for empty update
if ( (count($fieldNameArray) === 0) || (count($fieldValueArray) === 0) )
  ResponseManager::returnErrorResponse('emptyUpdate');

//Update the group
$updated = $Groups->updateGroup(
  $neededArgs['idGroup'],
  $fieldNameArray,
  $fieldValueArray
);

//Return
$json['success'] = $updated;
ResponseManager::returnSuccessResponse(2, $json);
?>
