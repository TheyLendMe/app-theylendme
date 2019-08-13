<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup'
]);
$optionalArgs = ArgumentManager::addOptionalPostArguments([
  'name',
  'amount',
  'desc'
]);

$ImageManager = new ImageManager('public', 'images');
$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$grp = $Groups->getGroup($neededArgs['idGroup']);
if ($grp === null) ResponseManager::returnErrorResponse('invalidData');
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $neededArgs['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');
// }

//Save the image if a valid one is provided
$valid_image = ArgumentManager::checkImage();
if ($valid_image === true) {
  $optionalArgs['imagen'] = $ImageManager->saveImageGroup($grp['idGroup'], $grp['foundDate']);
}else{
  $optionalArgs['imagen'] = null;
}

//Create the object
$idObject = $GroupsObjects->createObject(
  $neededArgs['idGroup'],
  $optionalArgs['name'],
  $optionalArgs['imagen'],
  $optionalArgs['amount'],
  $optionalArgs['desc']
);
if ($idObject == null) ResponseManager::returnErrorResponse('invalidData');

//Return
$json['idObject'] = $idObject;
ResponseManager::returnSuccessResponse(1, $json);
?>
