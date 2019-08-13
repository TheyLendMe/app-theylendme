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

$objects = $UsersObjects->getObjects($neededArgs['idUser']);
$requests = $UsersRequests->getRequestsToUser($neededArgs['idUser']);

$result = $objects; // MY OBJECTS + REQUESTS TO THEM
for ($i=0; $i < count($objects) ; $i++) {
  $result[$i]['reqN'] = 0;
  $result[$i]['requests'] = [];

  //Add the requests
  foreach ($requests as &$req) {
    if ($result[$i]['idObject'] === $req['idObject']){
      $requester = $usersInstance->getUser($req['idUser']);
      $req['requesterNickname'] = $requester['nickname'];

      $result[$i]['reqN']++;
      $result[$i]['requests'][] = $req;
    }
  }
}

//Return
$response = [];
foreach ($result as &$obj) {
  if ($obj['reqN'] > 0){
    $response[] = $obj;
  }
}

ResponseManager::returnSuccessResponse(4, $response);
?>
