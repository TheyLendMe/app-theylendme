<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup'
]);

//Logic
$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$GroupsLoans = new GroupsLoans($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);
$ImageManager = new ImageManager('public', 'images');

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$grp = $Groups->getGroup($neededArgs['idGroup']);
if ($grp == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ($member === false) ResponseManager::returnErrorResponse('permission');
// }

//Check that the user does not have not returned loans
$loans = $GroupsLoans->getLoansToUser($neededArgs['idUser'], $neededArgs['idGroup']);
if ($loans == null) $loans = [];
if (count($loans) > 0) ResponseManager::returnErrorResponse('leaveWithLoans');

//Check if is the last user || last admin
$members = $GroupsMembers->getMembersByGroup($neededArgs['idGroup']);
$admins = $GroupsMembers->getMembersByGroup($neededArgs['idGroup'], true);

//Si es el ultimo miembro borramos el grupo entero
if (count($members) == 1){
  $deleted = $Groups->deleteGroup($neededArgs['idGroup']); //On delete cascade --> borra miembros y objetos -> etc
  $msg = 'There where no more members. Group removed';

  //Remove the group's images directory and all inside
  if ($deleted === true){
    $dir = $ImageManager->getGroupPath($grp['idGroup'], $grp['foundDate']);
    if (is_dir("../$dir")) system("rm -r ../$dir");
  }
//En caso contrario podremos sacarlo del grupo sin borrarlo
}else{
  $admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $neededArgs['idGroup']);
  //Si el usuario es admin, y es el ultimo, upgradeamos a otro usuario aleatoriamente
  if ( ($admin === true) && (count($admins) == 1) ){
    //Eliminamos al usuario que quiere salirse como candidato
    $self = -1;
    for ($i=0; $i < count($members); $i++) {
      if ($members[$i]['idUser'] === $neededArgs['idUser']){
        $self = $i;
      }
    }
    array_splice($members, $i, 1);

    //Upgradeamos a un usuario
    $newAdmin = $members[rand(0, count($members) - 1)];
    $upgraded = $GroupsMembers->updateMember(
      $newAdmin['idMember'],
      ['admin'],
      [true]
    );

    //Si se ha realizado con exito, podemos abandonar el grupo
    if ($upgraded == true){
      $mem = $GroupsMembers->getRequestsByUser($neededArgs['idUser'], $neededArgs['idGroup']);
      $deleted = $GroupsMembers->removeMember($mem['idMember']);
      $msg = 'Group leaved successfully. New admin is randomly selected';
    }else{
      $deleted = false;
      $msg = 'Unknown error happened';
    }

  //Si no, simplemente abandonamos el grupo
  }else{
    $mem = $GroupsMembers->getRequestsByUser($neededArgs['idUser'], $neededArgs['idGroup']);
    $deleted = $GroupsMembers->removeMember($mem['idMember']);
    $msg = 'Group leaved successfully';
  }
}

//Return
$json['success'] = $deleted;
$json['msg'] = $msg;
ResponseManager::returnSuccessResponse(2, $json);
?>
