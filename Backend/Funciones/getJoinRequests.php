<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup'
]);

//Logic
$usersInstance = new Users($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$Groups = new Groups($pdo);
$JoinRequests = new JoinRequests($pdo);
$authManager = new AuthManager($usersInstance);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');
$group = $Groups->getGroup($neededArgs['idGroup']);
if ($group == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ($member === false) ResponseManager::returnErrorResponse('permission');

$requests = $JoinRequests->getRequestsByGroup($neededArgs['idGroup']);
if ($requests == null) ResponseManager::returnSuccessResponse(4, [] );
foreach ($requests as &$request) {
  $user = $usersInstance->getUser($request['idUser']);
  unset($request['idUser']);
  $request['user'] = $user;
}

ResponseManager::returnSuccessResponse(3, $requests);
?>
