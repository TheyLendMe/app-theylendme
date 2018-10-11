

///This class only have static methos, just for login and register process through the firebase api.abstract

///Dependencies needed  flutter_facebook_login: ^1.1.1 , firebase_core: ^0.2.5,   google_sign_in: ^3.0.5, firebase_auth: ^0.5.20

import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/entity.dart';

class Auth {



///Method to loginf with facebook

static void facebookAuth(){


}


static void googleAuth(){

  UserSingleton.singleton.user = new User("myid","nombre");

}

static void emailAuth(){


}


static void emailRegister(){



}











}