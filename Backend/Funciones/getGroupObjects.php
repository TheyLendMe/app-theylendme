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
$GroupsObjects = new GroupsObjects($pdo);
$Groups = new Groups($pdo);
$authManager = new AuthManager($usersInstance);

//Auth & checking
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$group = $Groups->getGroup($neededArgs['idGroup']);
if ($group == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ( ($member === false) && ($group['private'] === true) ) ResponseManager::returnErrorResponse('permission');

//Request logic
$objects = $GroupsObjects->getObjects($neededArgs['idGroup']);
if ($objects == null) $objects = [];

//Response
ResponseManager::returnSuccessResponse(3, $objects);
?>
