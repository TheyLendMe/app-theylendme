<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token'
]);

//Logic
$UsersObjects = new UsersObjects($pdo);
$UsersLoans = new UsersLoans($pdo);
$UsersClaims = new UsersClaims($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$claimsToUser = $UsersClaims->getClaimsToUser($neededArgs['idUser']);
$claimsByUser = $UsersClaims->getClaimsByUser($neededArgs['idUser']);
if ($claimsToUser == null) $claimsToUser = [];
if ($claimsByUser == null) $claimsByUser = [];

$byUser = [];
$toUser = [];

foreach ($claimsToUser as &$claim) {
  $loan = $UsersLoans->getLoan($claim['idLoan']);
  $obj = $UsersObjects->getObject($loan['idObject']);
  $owner = $usersInstance->getUser($obj['idUser']);
  $item = $claim;

  unset($item['idLoan']);
  unset($loan['idObject']);
  unset($obj['idUser']);
  $obj['owner'] = $owner;
  $loan['object'] = $obj;
  $item['loan'] = $loan;

  $toUser[] = $item;
}

foreach ($claimsByUser as &$claim) {
  $loan = $UsersLoans->getLoan($claim['idLoan']);
  $obj = $UsersObjects->getObject($loan['idObject']);
  $keeper = $usersInstance->getUser($loan['idUser']);
  $item = $claim;

  unset($item['idLoan']);
  unset($loan['idUser']);
  unset($loan['idObject']);
  $loan['keeper'] = $keeper;
  $loan['object'] = $obj;
  $item['loan'] = $loan;

  $byUser[] = $item;
}

$response['toUser'] = $toUser;
$response['byUser'] = $byUser;
ResponseManager::returnSuccessResponse(4, $response);
?>
