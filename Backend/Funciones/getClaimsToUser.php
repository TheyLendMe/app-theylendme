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

$claims = $UsersClaims->getClaimsByUser($neededArgs['idUser']);

$result = [];
for ($i=0; $i < count($claims) ; $i++) {
  $item = $claims[$i];

  $loan = $UsersLoans->getLoan($item['idLoan']);
  $item['loanData'] = $loan;

  $keeper = $usersInstance->getUser($loan['idUser']);
  $item['claim_target'] = $keeper['nickname'];

  $obj = $UsersObjects->getObject($loan['idObject']);
  $owner = $usersInstance->getUser($obj['idUser']);
  $obj['owner_name'] = $owner['nickname'];
  $item['object_data'] = $obj;

  $result[] = $item;
}

//Return
ResponseManager::returnSuccessResponse(3, $result);
?>
