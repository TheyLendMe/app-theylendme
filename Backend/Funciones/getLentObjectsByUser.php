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

$objects = $UsersObjects->getObjects($neededArgs['idUser']);
$loans = $UsersLoans->getLoansByUser($neededArgs['idUser']);

$result = $objects;
for ($i=0; $i < count($objects) ; $i++) {
  $result[$i]['loanN'] = 0;
  $result[$i]['loans'] = [];
  $result[$i]['maxAmount'] = $result[$i]['amount'];

  //Add the loans and substract the amount
  foreach ($loans as &$lo) {
    if ($lo['idObject'] === $result[$i]['idObject']){
      $result[$i]['loanN']++;
      $keeper = $usersInstance->getUser($lo['idUser']);
      $lo['userNickname'] = $keeper['nickname'];
      $result[$i]['loans'][] = $lo;
      $result[$i]['amount'] -= $lo['amount'];
    }
  }


}

//Remove the objects with no loans
$response = [];
foreach ($result as &$obj) {
  if ($obj['loanN'] > 0){
    $response[] = $obj;
  }
}

ResponseManager::returnSuccessResponse(3, $response);
?>
