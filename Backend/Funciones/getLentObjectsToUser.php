<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token'
]);

//Logic
$UsersObjects = new UsersObjects($pdo);
$UsersLoans = new UsersLoans($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$loans = $UsersLoans->getLoansToUser($neededArgs['idUser']);
$objects = [];
for ($i=0; $i < count($loans) ; $i++) {
  //Add the loan
  $item = $loans[$i];
  //Add the object
  $obj = $UsersObjects->getObject($loans[$i]['idObject']);
  $owner = $usersInstance->getUser($obj['idUser']);
  $item['objectData'] = array(
    'owner_id' => $obj['idUser'],
    'owner_nickname' => $owner['nickname'],
    'idObject' => $obj['idObject'],
    'imagen' => $obj['imagen'],
    'name' => $obj['name']
  );

  $keeper = $usersInstance->getUser($req['idUser']);
  $req['requesterNickname'] = $requester['nickname'];
  //Add the item
  $objects[] = $item;
}

//Return
ResponseManager::returnSuccessResponse(4, $objects);
?>
