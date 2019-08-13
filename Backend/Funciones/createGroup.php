<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token'
]);
$optionalArgs = ArgumentManager::addOptionalPostArguments([
  'private',
  'groupName',
  'autoloan',
  'email',
  'tfno',
  'info'
]);

$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);
$ImageManager = new ImageManager('public', 'images');

//Auth
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

//TODO: Limit nº of groups / user >>>> ?¿?¿?¿

//Creamos el grupo
$idGroup = $Groups->createGroup(
  $optionalArgs['groupName'],
  $optionalArgs['private'],
  $optionalArgs['autoloan'],
  $optionalArgs['email'],
  $optionalArgs['tfno'],
  $optionalArgs['info']
);
if ($idGroup == null) ResponseManager::returnErrorResponse('invalidData');

//Nos suscribimos como admin automaticamente
$idMember = $GroupsMembers->addMember(
  $neededArgs['idUser'],
  $idGroup,
  true
);
if ($idMember == null) ResponseManager::returnErrorResponse('invalidData');

//Creamos un directorio para el grupo
$group = $Groups->getGroup($idGroup);
$ImageManager->createGroupDir($group['idGroup'], $group['foundDate']);

//Comprobamos si hay imagen valida asociada
$valid_image = ArgumentManager::checkImage();
if ($valid_image === true) {
  //La guardamos y hacemos update del grupo
  $image_path = $ImageManager->saveImageGroup($group['idGroup'], $group['foundDate']);
  $success = $Groups->updateGroup($group['idGroup'], ['imagen'], [$image_path]);
  if ($success != 1) ResponseManager::returnErrorResponse('imageSaving2');
}

//Return
$json['idGroup'] = $idGroup;
$json['idMember'] = $idMember;
ResponseManager::returnSuccessResponse(1, $json);
?>
