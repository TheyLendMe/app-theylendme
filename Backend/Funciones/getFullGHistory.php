<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token'
]);

//Logic
$UsersObjects = new UsersObjects($pdo);
$UsersHistory = new UsersHistory($pdo);
$Users = new Users($pdo);
$authManager = new AuthManager($Users);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$history = array(
  'lentByGroup' => [],
  'lentToGroup' => [],
  'returnedByGroup' => [],
  'returnedToGroup' => []
);
$byme = $UsersHistory->getHistoryByUser($neededArgs['idUser'], true);
$tome = $UsersHistory->getHistoryByUser($neededArgs['idUser'], false);
if($byme == null) $byme = [];
if($tome == null) $tome = [];

foreach ($byme as &$transact) {
  $usr = $Users->getUser($transact['idUser']);
  unset($usr['email']);
  unset($usr['tfno']);
  unset($usr['info']);
  unset($usr['signUpDate']);

  $obj = $UsersObjects->getObject($transact['idObject']);
  $owner = $Users->getUser($obj['idUser']);
  unset($obj['idUser']);
  unset($owner['email']);
  unset($owner['tfno']);
  unset($owner['info']);
  unset($owner['signUpDate']);

  $item = $transact;
  unset($item['idUser']);
  unset($item['idObject']);
  unset($obj['idUser']);
  $item['keeper'] = $usr;
  $obj['owner'] = $owner;
  $item['object'] = $obj;

  if ($transact['returned'] === false) $history['lentByMe'][] = $item;
  else $history['returnedToMe'][] = $item;
}

foreach ($tome as &$transact) {
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

  if ($transact['returned'] === false) $history['lentToMe'][] = $item;
  else $history['returnedByMe'][] = $item;
}

//Return
ResponseManager::returnSuccessResponse(3, $history);
?>
