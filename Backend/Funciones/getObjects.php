<?php
//Logic
$Users = new Users($pdo);
$Groups = new Groups($pdo);
$UsersObjects = new UsersObjects($pdo);
$GroupsObjects = new GroupsObjects($pdo);

$UsersObj = $UsersObjects->getObjects();
$GroupsObj = $GroupsObjects->getPublicObjects();
if ($UsersObj == null) $UsersObj = [];
if ($GroupsObj == null) $GroupsObj = [];

$json['UsersObjects'] = [];
$json['GroupsObjects'] = [];

//Cambiamos los datos de los objetos para anidar a los dueños de cada uno
foreach ($UsersObj as &$obj){
  $user = $Users->getUser($obj['idUser']);

  unset($user['email']);
  unset($user['tfno']);
  unset($user['info']);
  unset($user['signUpDate']);

  unset($obj['idUser']);
  $obj['owner'] = $user;
  $json['UsersObjects'][] = $obj;
}

foreach ($GroupsObj as &$obj){
  $grp = $Groups->getGroup($obj['idGroup']);

  unset($grp['email']);
  unset($grp['tfno']);
  unset($grp['info']);
  unset($grp['foundDate']);
  unset($grp['private']);
  unset($grp['autoloan']);

  unset($obj['idGroup']);
  $obj['owner'] = $grp;
  $json['GroupsObjects'][] = $obj;
}


//Return
ResponseManager::returnSuccessResponse(4, $json);
?>
