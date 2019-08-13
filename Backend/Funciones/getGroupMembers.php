<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup'
]);

//Class declarations
$usersInstance = new Users($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$Groups = new Groups($pdo);
$authManager = new AuthManager($usersInstance);

//Auth & checking
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');
$group = $Groups->getGroup($neededArgs['idGroup']);
if ($group == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ($member === false) ResponseManager::returnErrorResponse('permission');

//Request logic
$regularMembers = $GroupsMembers->getMembersByGroup($neededArgs['idGroup'], false);
$adminMembers = $GroupsMembers->getMembersByGroup($neededArgs['idGroup'], true);
if ($regularMembers == null) $regularMembers = [];
if ($adminMembers == null) $adminMembers = [];
$members = array_merge($regularMembers, $adminMembers);

foreach ($members as &$member) {
  $user = $usersInstance->getUser($member['idUser']);
  unset($member['idUser']);
  $member['user'] = $user;
}

//Response
ResponseManager::returnSuccessResponse(3, $members);
?>
