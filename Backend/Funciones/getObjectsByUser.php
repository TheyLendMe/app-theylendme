<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser'
]);

//Logic
$UsersObjects = new UsersObjects($pdo);
$Users = new Users($pdo);

$usr = $Users->getUser($neededArgs['idUser']);
if ($usr == null) ResponseManager::returnErrorResponse('invalidData');

unset($usr['email']);
unset($usr['tfno']);
unset($usr['info']);
unset($usr['signUpDate']);

$objects = $UsersObjects->getObjects($neededArgs['idUser']);
if ($objects == null) $objects = [];
foreach ($objects as &$obj) {
  unset($obj['idUser']);
  $obj['owner'] = $usr;
}

//Return
ResponseManager::returnSuccessResponse(3, $objects);
?>
