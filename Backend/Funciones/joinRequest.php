<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup'
]);

//Logic
$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$JoinRequests = new JoinRequests($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$grp = $Groups->getGroup($neededArgs['idGroup']);
if ($grp == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ($member === true) ResponseManager::returnErrorResponse('member');
$requested = $JoinRequests->haveRequestToGroup($neededArgs['idUser'], $neededArgs['idGroup']);
if ($requested === true) ResponseManager::returnErrorResponse('requested');
// }

//Request to the group
$idRequest = $JoinRequests->addJoinRequest($neededArgs['idUser'], $neededArgs['idGroup']);
if ($idRequest == null) ResponseManager::returnErrorResponse('invalidData');

//Return
$json['idRequest'] = $idRequest;
ResponseManager::returnSuccessResponse(1, $json);
?>
