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

//Logic
$GroupsObjects = new GroupsObjects($pdo);
$GroupsRequests = new GroupsRequests($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$object = $GroupsObjects->getObject($neededArgs['idObject']);
if ($object == null) ResponseManager::returnErrorResponse('invalidData');
// }

//Make the request
$id = $GroupsRequests->createRequestByUser(
  $neededArgs['idUser'],
  $neededArgs['idObject'],
  null,
  $optionalArgs['amount'],
  $optionalArgs['requestMsg']
);
if ($id == null) ResponseManager::returnErrorResponse('invalidData');

//Return
$json['idRequest'] = $id;
ResponseManager::returnSuccessResponse(1, $json);
?>
