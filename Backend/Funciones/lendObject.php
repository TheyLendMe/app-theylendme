<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idRequest'
]);

//Logic
$UsersLoans = new UsersLoans($pdo);
$UsersRequests = new UsersRequests($pdo);
$UsersObjects = new UsersObjects($pdo);
$UsersHistory = new UsersHistory($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$request = $UsersRequests->getRequest($neededArgs['idRequest']);
if ($request == null) ResponseManager::returnErrorResponse('invalidData');
$requestedObject = $UsersObjects->getObject($request['idObject']);
if ($requestedObject == null) ResponseManager::returnErrorResponse('invalidData');
if ($requestedObject['idUser'] != $neededArgs['idUser']) ResponseManager::returnErrorResponse('permission');
// }

//Check that we have enough items to lend
$lentAmount = $UsersLoans->getLentAmountByObject($request['idObject']);
$left = $requestedObject['amount'] - $lentAmount;
if ($left < $request['amount']) ResponseManager::returnErrorResponse('amount');

//Lend the object and delete the request
$idLoan = $UsersLoans->createLoan(
  $request['idObject'],
  $request['idUser'],
  $request['amount']
);
if ($idLoan == null) ResponseManager::returnErrorResponse('invalidData');   // Estos errores no deberan suceder
$deleted = $UsersRequests->deleteRequest($neededArgs['idRequest']);
if ($deleted === false) ResponseManager::returnErrorResponse('invalidData');

//Store the transacton
$UsersHistory->createHistoryEntry(
  $request['idObject'],
  $request['idUser'],
  false,
  $request['amount']
);
// $UsersEstadistics = new UsersEstadistics($pdo);
// $UsersEstadistics->incrementLoansDone($neededArgs['idUser']);
// $UsersEstadistics->incrementLoansReceived($request['idUser']);


//Return
$json['idLoan'] = $idLoan;
ResponseManager::returnSuccessResponse(1, $json);
?>
