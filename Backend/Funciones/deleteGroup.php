<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup'
]);

$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);
$ImageManager = new ImageManager('public', 'images');

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$grp = $Groups->getGroup($neededArgs['idGroup']);
if ($grp === null) ResponseManager::returnErrorResponse('invalidData');
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $neededArgs['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');
// }

//delete the group
$deleted = $Groups->deleteGroup(
  $neededArgs['idGroup']
);

//Remove the group's images directory and all inside
if ($deleted === true){
  $dir = $ImageManager->getGroupPath($grp['idGroup'], $grp['foundDate']);
  if (is_dir("../$dir")) system("rm -r ../$dir");
}

//Return
$json['success'] = $deleted;
ResponseManager::returnSuccessResponse(2, $json);
?>
