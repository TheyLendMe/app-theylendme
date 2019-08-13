<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idObject'
]);
$optionalArgs = ArgumentManager::addOptionalPostArguments([
  'amount',
  'requestMsg'
]);

$UsersObjects = new UsersObjects($pdo);
$UsersRequests = new UsersRequests($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

// Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$object = $UsersObjects->getObject($neededArgs['idObject']);
if ($object == null) ResponseManager::returnErrorResponse('invalidData');
if ($object['idUser'] === $neededArgs['idUser']) ResponseManager::returnErrorResponse('yourself');
// }

//iF already requested that object -> return the already done request
$request = $UsersRequests->getRequestsByUser($neededArgs['idUser'], $neededArgs['idObject']);
if ($request != null) {
  $json['idRequest'] = $request['idRequest'];
  $json['alreadyRequested'] = true;
  ResponseManager::returnSuccessResponse(1, $json);
}
//else..

//Request the object
$idRequest = $UsersRequests->createRequest(
  $neededArgs['idUser'],
  $neededArgs['idObject'],
  $optionalArgs['amount'],
  $optionalArgs['requestMsg']
);
if ($idRequest == null) ResponseManager::returnErrorResponse('invalidData');

//Return
$json['idRequest'] = $idRequest;
$json['alreadyRequested'] = false;
ResponseManager::returnSuccessResponse(1, $json);
?>
