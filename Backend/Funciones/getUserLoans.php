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

$loansToUser = $UsersLoans->getLoansToUser($neededArgs['idUser']);
$loansByUser = $UsersLoans->getLoansByUser($neededArgs['idUser']);
if ($loansToUser == null) $loansToUser = [];
if ($loansByUser == null) $loansByUser = [];

$byUser = [];
$toUser = [];

foreach ($loansToUser as &$loan) {
  $obj = $UsersObjects->getObject($loan['idObject']);
  $owner = $usersInstance->getUser($obj['idUser']);
  $item = $loan;

  unset($item['idObject']);
  unset($obj['idUser']);
  $obj['owner'] = $owner;
  $item['object'] = $obj;

  $toUser[] = $item;
}

foreach ($loansByUser as &$loan) {
  $obj = $UsersObjects->getObject($loan['idObject']);
  $keeper = $usersInstance->getUser($loan['idUser']);
  $item = $loan;

  unset($item['idUser']);
  unset($item['idObject']);
  $item['keeper'] = $keeper;
  $item['object'] = $obj;

  $byUser[] = $item;
}

$response['toUser'] = $toUser;
$response['byUser'] = $byUser;
ResponseManager::returnSuccessResponse(4, $response);
?>
