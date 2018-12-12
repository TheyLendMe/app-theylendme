

///This class only have static methos, just for login and register process through the firebase api.abstract

///Dependencies needed  flutter_facebook_login: ^1.1.1 , firebase_core: ^0.2.5,   google_sign_in: ^3.0.5, firebase_auth: ^0.5.20

import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Utilities/errorHandler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart';

///Responsetype 10:cuenta login, sin verificar email
//////Responsetye: 11, login true,
///Resposetype: 12, recien creada
///
class Auth {

  ///Method to loging with facebook
  static void facebookAuth(){
  }
  static Future<bool> login({String email,String pass, bool google= false, bool facebook= false, BuildContext context, String name}) async{
    ///First we have to make sure that the user is loged in 
    FirebaseUser user;
    if(UserSingleton().login){return true;}
    try{
      if(google){user = await _googleAuth();}
      if(email !=null){user = await _emailAuth(email,pass);}
    }on PlatformException catch(e){ 
      _onError(e); return false;
      }
    ///First filter
    if(user == null){return false;}
    user = await FirebaseAuth.instance.currentUser();
    ///Second Filter
    if(user != null){

      
      ///Download profile Image from firebase
      

      File image= await downloadProfileImage(user.photoUrl);
      UserSingleton(user: user);
      await UserSingleton().refreshUser();
      if((await new RequestPost('login').dataBuilder(userInfo: true, nickName: name, img: image).doRequest()).hasError){
         UserSingleton().login = false; 
         return false;
      }
      if(await _checkFirstLogIn()){print("First Login"); _firstSteps(google :google, pass: pass,facebook: facebook);}

      
    }else{ ErrorToast().handleError(msg: "Algo ha fallado"); return false; }
    return true;
  }

  static Future<File> downloadProfileImage(String url) async {
    String filename = basename(url);
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
}


  static Future<FirebaseUser> _googleAuth() async{
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if(googleUser == null){return null;}
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
  static Future<bool> emailRegister(String email, String pass) async{
    FirebaseAuth _auth= FirebaseAuth.instance;
    try{
      await _auth.createUserWithEmailAndPassword(email: email,password:pass);
      String name = email.split("@")[0];
      return await login(email: email, pass: pass, name: name);
    }on PlatformException catch(e){_onError(e); return false;}

  }
  static Future signOut() async{
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.clear();
    await FirebaseAuth.instance.signOut();
    UserSingleton().refreshUser();

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
  static void _onError(PlatformException e) async{
    String msg = e.message;
      switch (e.code){
        case "auth/email-already-exists" : {msg = "A user with this email already exists"; break;}
        case "auth/user-not-found" : {msg = "This user doesn't exist"; break;}
        case "auth/invalid-credential" : {msg = "Email or Password are Incorrect"; break;}
      }
      await signOut();
      ErrorToast().handleError(msg: msg, id: e.code);
  }
  static Future<bool> _checkFirstLogIn() async{
    SharedPreferences sh = await SharedPreferences.getInstance();
    ///If welcome
    bool wasLoged = (sh.getBool('wasLoged') ?? false);
    return !wasLoged;
}
}