

///This class only have static methos, just for login and register process through the firebase api.abstract

///Dependencies needed  flutter_facebook_login: ^1.1.1 , firebase_core: ^0.2.5,   google_sign_in: ^3.0.5, firebase_auth: ^0.5.20

import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

///Responsetype 10:cuenta login, sin verificar email
//////Responsetye: 11, login true,
///Resposetype: 12, recien creada
///
class Auth {

///Method to loging with facebook

static void facebookAuth(){


}

static Future<bool> login({String email,String pass, bool google= false, bool facebook= false, BuildContext context}) async{
  ///First we have to make sure that the user is loged in 
  
  FirebaseUser user;
  if(UserSingleton().login){return true;}
  try{
    if(google){await _googleAuth();}
    if(email !=null){await _emailAuth(email,pass);}
  }catch(e){
    return false;
  }
  user = await FirebaseAuth.instance.currentUser();
  
  if(user != null){
    UserSingleton(user: user);
    await UserSingleton().refreshUser();
    await new RequestPost('login').dataBuilder(userInfo: true).doRequest();
    if(await _checkFirstLogIn()){print("First Login"); _firstSteps(google :google, pass: pass,facebook: facebook);}
  }else{
    print("Esto no esta muy bien"); return false;
  }


}

static Future<FirebaseUser> _googleAuth() async{
 final GoogleSignIn _googleSignIn = GoogleSignIn();
 final FirebaseAuth _auth = FirebaseAuth.instance;
 GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  FirebaseUser user = await _auth.signInWithGoogle(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return user;
}

static Future<FirebaseUser> _emailAuth(String email,String pass) async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  return await _auth.signInWithEmailAndPassword(email:email,password:pass);
}


static Future emailRegister(String email, String pass) async{
   FirebaseAuth _auth= FirebaseAuth.instance;
   try{
    _auth.createUserWithEmailAndPassword(email: email,password:pass);
    await login(email: email, pass: pass);
   }catch(e){
    ///TODO hay que poner todos los errores posbiles y ver como manejarlos
      print(e);
   }



}

static Future signOut() async{
  await FirebaseAuth.instance.signOut();
  SharedPreferences sh = await SharedPreferences.getInstance();
  sh.clear();

 }

static Future _firstSteps({String email,String pass, bool google= false, bool facebook= false}) async{
  SharedPreferences sh = await SharedPreferences.getInstance();
  User u = UserSingleton().user;
  sh.setBool('wasLogged', true);
  sh.setString("uid", u.idEntity);
  sh.setString("name", u.name);
  sh.setString("email",u.email);

  if(pass != null){sh.setString("pass", pass); sh.setString("logType", "email");}
  if(google){sh.setString("logType", "google");}
  if(facebook){sh.setString("logType", "facebook");}

}
///When the user, has been logged in for the first time on the mobile phone (when he has sig in)
///it is going to be suscribed too all the groups that he belongs as and admin.
static Future _firstSubsCribe() async{
  String uid = UserSingleton().user.idEntity;
  UserSingleton().notifications.firebaseMessaging.subscribeToTopic(uid);
  UserSingleton().user.getNotTopics();


}


static Future<bool> _checkFirstLogIn() async{
  SharedPreferences sh = await SharedPreferences.getInstance();
  ///If welcome
  bool wasLoged = (sh.getBool('wasLoged') ?? false);
  return !wasLoged;
}










}