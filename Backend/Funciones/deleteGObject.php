<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idObject'
]);

$GroupsMembers = new GroupsMembers($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$object = $GroupsObjects->getObject($neededArgs['idObject']);
if ($object == null) ResponseManager::returnErrorResponse('invalidData');
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $object['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');
// }

//Delete the object
$deleted = $GroupsObjects->deleteObject(
  $neededArgs['idObject']
);

//Eliminamos la imagen del objeto si existe
$image_path = $object['imagen'];
if ( ($deleted === true) && ($image_path != null) ) {
  if (file_exists("../$image_path")) system("rm ../$image_path");
}

//Return
$json['success'] = $deleted;
ResponseManager::returnSuccessResponse(2, $json);
?>
