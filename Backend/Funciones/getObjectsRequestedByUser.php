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

$requests = $UsersRequests->getRequestsByUser($neededArgs['idUser']);
$objects = [];
for ($i=0; $i < count($requests) ; $i++) {
  //Add the request
  $item = $requests[$i];
  //Add the object
  $obj = $UsersObjects->getObject($requests[$i]['idObject']);
  $owner = $usersInstance->getUser($obj['idUser']);
  $item['objectData'] = array(
    'owner_id' => $obj['idUser'],
    'owner_nickname' => $owner['nickname'],
    'idObject' => $obj['idObject'],
    'imagen' => $obj['imagen'],
    'name' => $obj['name']
  );

  //Add the item
  $objects[] = $item;
}

//Return
ResponseManager::returnSuccessResponse(4, $objects);
?>
