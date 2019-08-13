<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idLoan'
]);
$optionalArgs = ArgumentManager::addOptionalPostArguments([
  'claimMsg'
]);

$UsersObjects = new UsersObjects($pdo);
$UsersLoans = new UsersLoans($pdo);
$UsersClaims = new UsersClaims($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$loan = $UsersLoans->getLoan($neededArgs['idLoan']);
if ($loan == null) ResponseManager::returnErrorResponse('invalidData');
$object = $UsersObjects->getObject($loan['idObject']);
if ($object == null) ResponseManager::returnErrorResponse('invalidData');
if ($object['idUser'] != $neededArgs['idUser']) ResponseManager::returnErrorResponse('permission');
// }

$idClaim = $UsersClaims->createClaim(
  $neededArgs['idLoan'],
  $optionalArgs['claimMsg']
);
if ($idClaim == null) ResponseManager::returnErrorResponse('invalidData');

//Return
$json['idClaim'] = $idClaim;
ResponseManager::returnSuccessResponse(1, $json);
?>
