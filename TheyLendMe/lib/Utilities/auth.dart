

///This class only have static methos, just for login and register process through the firebase api.abstract

///Dependencies needed  flutter_facebook_login: ^1.1.1 , firebase_core: ^0.2.5,   google_sign_in: ^3.0.5, firebase_auth: ^0.5.20

import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';

class Auth {



///Method to loging with facebook

static void facebookAuth(){


}


static Future login({String email,String pass, bool google, bool facebook}) async{
  ///First we have to make sure that the user is loged in
  try{
    if(google){await googleAuth();}
  
  }catch(e){
    
    return;
  }
    await UserSingleton.singleton.refreshUser();
    new RequestPost('login').dataBuilder(userInfo: true).doRequest();

  


}

static Future googleAuth() async{

  GoogleSignInAccount googleUser;
  FirebaseAuth _auth= FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  try{
    googleUser = await _googleSignIn.signIn();
  }catch (e) {
    return null;
  }

  if(googleUser == null){return null;}
  
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final FirebaseUser user = await _auth.signInWithGoogle(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  ).catchError((e){
    print("Error: there is another account using this email.");
  });

}

static void emailAuth(){


}


static void emailRegister(){

}












}