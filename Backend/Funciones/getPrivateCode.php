<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup'
]);

//Logic
$GroupsMembers = new GroupsMembers($pdo);
$Groups = new Groups($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $neededArgs['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');

$grp = $Groups->getGroup($neededArgs['idGroup']);
$tmpCode = PrivateCodeManager::getPrivateCode($grp['idGroup'], $grp['foundDate']);

//Return
$json['code'] = $tmpCode;
ResponseManager::returnSuccessResponse(1, $json);
?>
