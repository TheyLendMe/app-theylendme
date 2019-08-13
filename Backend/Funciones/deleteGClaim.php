<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idClaim'
]);

//Logic
$GroupsMembers = new GroupsMembers($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$GroupsLoans = new GroupsLoans($pdo);
$GroupsClaims = new GroupsClaims($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$claim = $GroupsClaims->getClaim($neededArgs['idClaim']);
if ($claim == null) ResponseManager::returnErrorResponse('invalidData');
$loan = $GroupsLoans->getLoan($claim['idLoan']);
if ($loan == null) ResponseManager::returnErrorResponse('invalidData');
$object = $GroupsObjects->getObject($loan['idObject']);
if ($object == null) ResponseManager::returnErrorResponse('invalidData');

$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $object['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');
// }

$del = $GroupsClaims->deleteClaim($neededArgs['idLoan']);

//Return
$json['success'] = $del;
ResponseManager::returnSuccessResponse(2, $json);
?>
