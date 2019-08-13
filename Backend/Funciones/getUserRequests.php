<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token'
]);

//Logic
$UsersObjects = new UsersObjects($pdo);
$UsersRequests = new UsersRequests($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$requestsToUser = $UsersRequests->getRequestsToUser($neededArgs['idUser']);
$requestsByUser = $UsersRequests->getRequestsByUser($neededArgs['idUser']);
if ($requestsToUser == null) $requestsToUser = [];
if ($requestsByUser == null) $requestsByUser = [];

$byUser = [];
$toUser = [];

foreach ($requestsToUser as &$request) {
  $obj = $UsersObjects->getObject($request['idObject']);
  $requester = $usersInstance->getUser($request['idUser']);
  $item = $request;

  unset($item['idUser']);
  unset($item['idObject']);
  $item['requester'] = $requester;
  $item['object'] = $obj;

  $toUser[] = $item;
}

foreach ($requestsByUser as &$request) {
  $obj = $UsersObjects->getObject($request['idObject']);
  $owner = $usersInstance->getUser($obj['idUser']);
  $item = $request;

  unset($obj['idUser']);
  unset($item['idObject']);
  $obj['owner'] = $owner;
  $item['object'] = $obj;

  $byUser[] = $item;
}

$response['toUser'] = $toUser;
$response['byUser'] = $byUser;
ResponseManager::returnSuccessResponse(4, $response);
?>
