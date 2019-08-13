<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idRequest'
]);

//Class instances
$UsersObjects = new UsersObjects($pdo);
$UsersRequests = new UsersRequests($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$request = $UsersRequests->getRequest($neededArgs['idRequest']);
if ($request == null) ResponseManager::returnErrorResponse('invalidData');
$obj = $UsersObjects->getObject($request['idObject']);
if ($obj == null) ResponseManager::returnErrorResponse('invalidData');
if ( ($neededArgs['idUser'] != $obj['idUser']) && ($neededArgs['idUser'] != $request['idUser']) ) //Owner of the object o user who had requested
  ResponseManager::returnErrorResponse('permission');
// }

//Delete the request
$deleted = $UsersRequests->deleteRequest($neededArgs['idRequest']);

//Return
$json['deleted'] = $deleted;
ResponseManager::returnSuccessResponse(2, $json);
?>
