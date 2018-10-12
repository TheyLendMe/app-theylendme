import 'package:flutter/material.dart';
import 'package:TheyLendMe/the_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Utilities/auth.dart';
import 'Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'Singletons/UserSingleton.dart';

void main() => runApp(TheApp());



class TheApp extends StatelessWidget {
  // This widget is the root of your application.7

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void pruebas() async{

   // _handleSignIn();

    new User("myid","nombre").getObjects();

  }


Future<FirebaseUser> _handleSignIn() async {
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  FirebaseUser user = await _auth.signInWithGoogle(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  print("signed in " + user.displayName);
  return user;
}



  @override
  Widget build(BuildContext context) {









    
    return MaterialApp(
      title: 'app de préstamos',
      theme: ThemeData( primarySwatch: Colors.blue, ),
      home: new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: pruebas
        ),
        body: new Container()
      ),
    );
  }
}
