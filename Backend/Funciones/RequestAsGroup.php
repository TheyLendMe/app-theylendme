<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idObject',
  'idGroup'
]);
$optionalArgs = ArgumentManager::addOptionalPostArguments([
  'amount',
  'requestMsg'
]);

//Logic
$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$GroupsRequests = new GroupsRequests($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$object = $GroupsObjects->getObject($neededArgs['idObject']);
if ($object == null) ResponseManager::returnErrorResponse('invalidData');
$grp = $Groups->getGroup($neededArgs['idGroup']);
if ($grp == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ($member === false) ResponseManager::returnErrorResponse('permission');
// }

//Make the request
$id = $GroupsRequests->createRequestByGroup(
  $neededArgs['idGroup'],
  $neededArgs['idObject'],
  $neededArgs['idUser'],
  $optionalArgs['amount'],
  $optionalArgs['requestMsg']
);
if ($id == null) ResponseManager::returnErrorResponse('invalidData');

//Return
$json['idRequest'] = $id;
ResponseManager::returnSuccessResponse(1, $json);
?>
