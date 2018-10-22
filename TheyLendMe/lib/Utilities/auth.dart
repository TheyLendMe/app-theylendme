

///This class only have static methos, just for login and register process through the firebase api.abstract

///Dependencies needed  flutter_facebook_login: ^1.1.1 , firebase_core: ^0.2.5,   google_sign_in: ^3.0.5, firebase_auth: ^0.5.20

import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';


///Responsetype 10:cuenta login, sin verificar eail
//////Responsetye: 11, login true,
///Resposetype: 12, recien creada
///
class Auth {



///Method to loging with facebook

static void facebookAuth(){


}


static Future login({String email,String pass, bool google= false, bool facebook= false}) async{
  ///First we have to make sure that the user is loged in
  try{
    if(google){await googleAuth();}
    if(email !=null){emailAuth(email,pass);}
  
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

static void emailAuth(String email,String pass){
  FirebaseAuth _auth= FirebaseAuth.instance;
  _auth.signInWithEmailAndPassword(email:email,password:pass);

}


static Future emailRegister(String email, String pass) async{
   FirebaseAuth _auth= FirebaseAuth.instance;
   try{
   _auth.createUserWithEmailAndPassword(email: email,password:pass);

   //(await _auth.currentUser()).sendEmailVerification();
   print(UserSingleton.singleton.firebaseUser.uid);
   //login(email: email, pass: pass);

   }catch(e){
    ///TODO hay que poner todos los errores posbiles y ver como manejarlos
      print(e);
   }



}












}