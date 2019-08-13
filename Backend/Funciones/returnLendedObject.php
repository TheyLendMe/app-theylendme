<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idLoan'
]);

//Logic
$UsersObjects = new UsersObjects($pdo);
$UsersLoans = new UsersLoans($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$loan = $UsersLoans->getLoan($neededArgs['idLoan']);
if ($loan == null) ResponseManager::returnErrorResponse('invalidData');
$obj = $UsersObjects->getObject($loan['idObject']);
if ($obj == null) ResponseManager::returnErrorResponse('invalidData');
if ($obj['idUser'] != $neededArgs['idUser']) ResponseManager::returnErrorResponse('permission'); // You have to be the obj owner
// }

//Remove the loan
$success = $UsersLoans->deleteLoan($neededArgs['idLoan']);

//Store history transaction
if ($success){
  $UsersHistory = new UsersHistory($pdo);
  $UsersHistory->createHistoryEntry(
    $loan['idObject'],
    $loan['idUser'],
    true,
    $loan['amount']
  );
  // $UsersEstadistics = new UsersEstadistics($pdo);
  // $UsersEstadistics->incrementLoansReturned($loan['idUser']);
}

//Return
$json['success'] = $success;
ResponseManager::returnSuccessResponse(2, $json);
?>
