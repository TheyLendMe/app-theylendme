<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idClaim'
]);

//Class instances
$UsersObjects = new UsersObjects($pdo);
$UsersRequests = new UsersRequest($pdo);
$UsersClaims = new UsersClaims($pdo);
$UsersLoans = new UsersClaims($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$claim = $UsersClaims->getClaim($neededArgs['idClaim']);
if ($claim == null) ResponseManager::returnErrorResponse('invalidData');
$loan = $UsersLoans->getLoan($claim['idLoan']);
if ($loan == null) ResponseManager::returnErrorResponse('invalidData');
$obj = $UsersObjects->getObject($loan['idObject']);
if ($obj == null) ResponseManager::returnErrorResponse('invalidData');

if ($neededArgs['idUser'] != $obj['idUser']) ResponseManager::returnErrorResponse('permission');
// }

//Delete the claim
$deleted = $UsersClaims->deleteClaim($neededArgs['idClaim']);

//Return
$json['deleted'] = $deleted;
ResponseManager::returnSuccessResponse(2, $json);
?>
