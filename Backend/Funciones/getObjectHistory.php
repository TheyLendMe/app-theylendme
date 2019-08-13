<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idObject'
]);

//Logic
$UsersObjects = new UsersObjects($pdo);
$UsersHistory = new UsersHistory($pdo);
$Users = new Users($pdo);
$authManager = new AuthManager($Users);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');
$obj = $UsersObjects->getObject($neededArgs['idUser']);
if ($obj == null) ResponseManager::returnErrorResponse('invalidData');

$history = array(
  'lent' => [],
  'returned' => []
);

$transactions = $UsersHistory->getHistoryByObject($neededArgs['idObject']);
if($transactions == null) $transactions = [];

foreach ($transactions as &$transact) {
  $usr = $Users->getUser($transact['idUser']);
  unset($usr['email']);
  unset($usr['tfno']);
  unset($usr['info']);
  unset($usr['signUpDate']);

  $obj = $UsersObjects->getObject($transact['idObject']);
  $owner = $Users->getUser($obj['idUser']);
  unset($owner['email']);
  unset($owner['tfno']);
  unset($owner['info']);
  unset($owner['signUpDate']);
  unset($obj['idUser']);
  $obj['owner'] = $owner;

  $item = $transact;
  unset($item['idUser']);
  unset($item['idObject']);
  $item['keeper'] = $usr;
  $item['object'] = $obj;

  if ($transact['returned'] === false) $history['lent'][] = $item;
  else $history['returned'][] = $item;
}

//Return
ResponseManager::returnSuccessResponse(3, $history);
?>
