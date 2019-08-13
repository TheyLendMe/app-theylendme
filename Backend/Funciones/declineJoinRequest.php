<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idRequest'
]);

//Logic
$GroupsMembers = new GroupsMembers($pdo);
$JoinRequests = new JoinRequests($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$request = $JoinRequests->getRequest($neededArgs['idRequest']);
if ($request == null) ResponseManager::returnErrorResponse('invalidData');
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $request['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');
// }

//Delete the request
$del = $JoinRequests->removeRequest($neededArgs['idRequest']);

//Return
$json['success'] = $del;
ResponseManager::returnSuccessResponse(2, $json);
?>
