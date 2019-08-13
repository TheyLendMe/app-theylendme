<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idMember',
  'idGroup'
]);

//Logic
$GroupsMembers = new GroupsMembers($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $neededArgs['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');
$member = $GroupsMembers->getMember($neededArgs['idMember']);
if ($member == null) ResponseManager::returnErrorResponse('invalidData');
if ($member['idGroup'] != $neededArgs['idGroup']) ResponseManager::returnErrorResponse('permission');
// }

//Upgrade the user
$upgraded = $GroupsMembers->updateMember(
  $neededArgs['idMember'],
  ['admin'],
  [1]
);

//Return
$json['success'] = ($upgraded === 1 ? true : false);
ResponseManager::returnSuccessResponse(2, $json);
?>
