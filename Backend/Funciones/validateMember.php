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

//Create a member instance for that user
$idMember = $GroupsMembers->addMember(
  $request['idUser'],
  $request['idGroup'],
  false
);
if ($idMember == null) ResponseManager::returnErrorResponse('invalidData');

//Delete the request
$del = $JoinRequests->removeRequest($neededArgs['idRequest']);
//This error should not happen at this point.
if ($del === false) ResponseManager::returnErrorResponse('invalidData');

//Return
$json['idMember'] = $idMember;
ResponseManager::returnSuccessResponse(1, $json);
?>
