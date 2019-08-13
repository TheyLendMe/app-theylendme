<?php
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup'
]);

//Logic
$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$Users = new Users($pdo);
$authManager = new AuthManager($Users);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$grp = $Groups->getGroup($neededArgs['idGroup']);
if ($grp ==  null) ResponseManager::returnErrorResponse('invalidData');
//Require to be a member if the group is private
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ( ($grp['private'] == true) && ($member === false) ) ResponseManager::returnErrorResponse('permission');

//Return
$json['group'] = $grp;
ResponseManager::returnSuccessResponse(4, $json);
?>
