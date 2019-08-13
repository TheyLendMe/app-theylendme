<?php
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token'
]);
$optionalArgs = ArgumentManager::addOptionalPostArguments([
  'nickname',
  'email',
  'tfno',
  'info'
]);

//Logic
$ImageManager = new ImageManager('public', 'images');
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);
$UsersEstadistics = new UsersEstadistics($pdo);
//Try to log in -> errors inside
$loged = $authManager->login($neededArgs['idUser'], $neededArgs['token']);
if ($loged != false) {
  //Loged successfully -> loged could be true or 1

  //TEMP :
  if (!$UsersEstadistics->haveEstadistics($neededArgs['idUser'])) $UsersEstadistics->initEstadistics($neededArgs['idUser']);

  ResponseManager::returnSuccessResponse(
    ($loged === 1) ? 10 : 11,               //Code 10 -------- Early user
    array(                                  //Code 11 -------- Verificated user
      'success' => true,
      'misingsFields' => $usersInstance->getNullFields($neededArgs['idUser'])
    )
  );
//Try to sing up
}else{
  $signed = $authManager->signUp(
    $neededArgs['idUser'],
    $neededArgs['token'],
    $optionalArgs
  );
  if ($signed === true){
    //Create a private dir for this new user
    $ImageManager->createUserDir($neededArgs['idUser']);
    //Try to save the user image
    $valid_image = ArgumentManager::checkImage();
    if ($valid_image === true) {
      $image = $ImageManager->saveImageUser($neededArgs['idUser']);
      $saved = $usersInstance->updateUser(
        $neededArgs['idUser'],
        ['imagen'],
        [$image]
      );
    }
    //Try to create a user estadistics row in the table
    $UsersEstadistics->initEstadistics($neededArgs['idUser']);
  }else{
    ResponseManager::returnErrorResponse('registerError');
  }

  ResponseManager::returnSuccessResponse(
    12,                                     //Code 12 -------- Signed up
    array(
      'success' => $signed,
      'misingsFields' => $usersInstance->getNullFields($neededArgs['idUser'])
    )
  );
}

?>
