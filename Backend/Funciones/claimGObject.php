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

$loan = $GroupsLoans->getLoan($neededArgs['idLoan']);
if ($loan == null) ResponseManager::returnErrorResponse('invalidData');
$object = $GroupsObjects->getObject($loan['idObject']);
if ($object == null) ResponseManager::returnErrorResponse('invalidData');
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $object['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');
// }


$idClaim = $GroupsClaims->createClaim(
  $neededArgs['idLoan'],
  $optionalArgs['claimMsg']
);
if ($idClaim == null) ResponseManager::returnErrorResponse('invalidData');

//Return
$json['idClaim'] = $idClaim;
ResponseManager::returnSuccessResponse(1, $json);
?>
