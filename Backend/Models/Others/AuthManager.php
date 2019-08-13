<?php

use Kreait\Firebase\Factory;
use Kreait\Firebase\ServiceAccount;
use Kreait\Firebase\Exception\Auth;
use Kreait\Firebase\Exception\Auth\UserNotFound;
use Symfony\Component\Cache\Simple\FilesystemCache;

class AuthManager{

  private $emailVerificationTime = (60*60*24*7); //one week in seconds

  private $serviceAccount;
	private $firebase;
  private $users;

  public function AuthManager($UsersInstance){
    $cache = new FilesystemCache();
    $this->users = $UsersInstance;
   	$this->serviceAccount = ServiceAccount::fromJsonFile("../app/Secreto/secret.json");
   	$this->firebase = (new Factory)
    	->withServiceAccount($this->serviceAccount,'YOUR FIREBASE API KEY')
      ->withVerifierCache($cache)
    	->create();
  }

  public function login($idUser, $token){
    return ($this->verifyAuth($idUser, $token, true) );
  }

  public function verifyAuth($idUser, $token, $emailCheck = false){

    //If any of this point fails, error is returned
    $uid = $this->verifyToken($token);                                 //INVALID TOKEN ERROR
    $user = $this->verifyFirebaseUser($uid, $idUser);                   //INVALID USER ERROR

    //At this point, the token given, and the user given are valid.
    //The token also point to the given user.

    ///Verify if the user exists on the api database
    $exists = $this->users->checkUser($uid);

    if (!$emailCheck) return $exists;                                   //YOU HAVE(NOT) AUTH
    if (!$exists) return false;                                         //USER NOT FOUND

    $emailVerificated = $this->verifyUserEmail($user);
    if ($emailVerificated) return true;                                 //USER VERIFICATED


    $signUpDate = $this->users
      ->getSignUpDate($idUser)['signUpDate'];
    $timeSinceLogin = time() - strtotime($signUpDate);
    if ( $timeSinceLogin < $emailVerificationTime ) return 1;           //EARLY USER

    //TEMP: forced email verification disabled
    return true;
    // ResponseManager::returnErrorResponse('verifyEmail');                //MUST VERIFICATE ERROR
  }

  public function signUp($idUser, $token, $optionalArgs){

    //If any of this point fails, error is returned
    $uid = $this->verifyToken($token);                                 //INVALID TOKEN ERROR
    $user = $this->verifyFirebaseUser($uid, $idUser);                   //INVALID USER ERROR

    //At this point, the token given, and the user given are valid.
    //The token also point to the given user.

    ///We check that this user does NOT exists on the database.
    $exists = $this->users->checkUser($uid);
    if ($exists) ResponseManager::returnErrorResponse('existingUser');  //USER ALREADY EXISTS ERROR

    //We create such user
    if ($optionalArgs['nickname'] === '') $optionalArgs['nickname'] = explode("@", $user->email)[0];
    if ($optionalArgs['email'] === '') $optionalArgs['email'] = $user->email;
    // if ($optionalArgs['tfno'] === '') $optionalArgs['tfno'] = $user->phoneNumber; //TODO FIXME ??
    $created = $this->users->createUser(
      $uid,
      $optionalArgs['nickname'],
      $optionalArgs['email'],
      $optionalArgs['tfno'],
      $optionalArgs['info']
    );

    return $created;                                                  //SIGNED UP
  }

  private function verifyToken($token){
    ///Verify if the token that the user give is valid
    try {
      $verifiedIdToken = $this->firebase->getAuth()->verifyIdToken($token);
      $uid = $verifiedIdToken->getClaim('sub');
      return $uid;
    }catch (Exception $e) {
      ResponseManager::returnErrorResponse('invalidToken');           //RETURN ERROR InvalidToken
    }
  }

  private function verifyFirebaseUser($uid, $idUser){
    if($uid != $idUser){
      ResponseManager::returnErrorResponse('invalidUser');            // RETURN ERROR InvalidUser
    }

    ///This may throw a UserNotFoundException in that case, this means that the user does not exist
    ///on he firebase database, meaning that he is trying to login or signup before doing the standart
    ///login given by the googles library of FirebaseAuth
    $auth = $this->firebase->getAuth();
    try{
      $user = $auth->getUser($uid);
      return $user;
      //https://firebase-php.readthedocs.io/en/stable/user-management.html?highlight=firebase%20user#get-information-about-a-specific-user
    }catch(UserNotFound $e){
      ResponseManager::returnErrorResponse('invalidUser');            // RETURN ERROR InvalidUser
    }
  }

  private function verifyUserEmail($user){
    return ($user->emailVerified);
  }

}?>
