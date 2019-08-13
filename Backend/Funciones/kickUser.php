<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idMember'
]);

//Logic
$GroupsMembers = new GroupsMembers($pdo);
$GroupsLoans = new GroupsLoans($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$member = $GroupsMembers->getMember($neededArgs['idMember']);
if ($member == null) ResponseManager::returnErrorResponse('invalidData');
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $member['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission');
if ($neededArgs['idUser'] === $member['idUser']) ResponseManager::returnErrorResponse('kickYourself');
// }

//Check that the user does not have not returned loans
$loans = $GroupsLoans->getLoansToUser($member['idUser'], $member['idGroup']);
if ($loans == null) $loans = [];
if (count($loans) > 0) ResponseManager::returnErrorResponse('kickWithLoans');

//Remove that member!
$deleted = $GroupsMembers->removeMember($member['idMember']);

//Return
$json['success'] = $deleted;
ResponseManager::returnSuccessResponse(2, $json);
?>
