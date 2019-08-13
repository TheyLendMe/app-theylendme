<?php
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idOtherUser'
]);

//Logic
$UsersEstadistics = new UsersEstadistics($pdo);
$Users = new Users($pdo);
$authManager = new AuthManager($Users);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$usr = $Users->getUser($neededArgs['idOtherUser']);
if ($usr ==  null) ResponseManager::returnErrorResponse('invalidData');
// $estadistics = $UsersEstadistics->getUserEstadistics($neededArgs['idUser']);
// if ($estadistics == null) ResponseManager::returnErrorResponse('invalidData');

//Return
// $usr['estadistics'] = $estadistics;
$json['user'] = $usr;
ResponseManager::returnSuccessResponse(4, $json);
?>
