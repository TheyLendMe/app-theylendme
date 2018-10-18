import 'package:TheyLendMe/Objects/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserSingleton{
  static final UserSingleton singleton = new UserSingleton._internal();
  User _user;
  FirebaseUser firebaseUser;
  String token;

  factory UserSingleton(){return singleton;}
  UserSingleton._internal(){
    FirebaseAuth.instance.currentUser().then((user){
      this._user = new User(user.uid, user.displayName);
      this.firebaseUser = user;
    });
  } 



  Future refreshUser() async{
    firebaseUser = await FirebaseAuth.instance.currentUser();
    this.token = await firebaseUser.getIdToken();

    if(user == null){this._user = new User(firebaseUser.uid, firebaseUser.displayName); print("Me actaulizo");}
  }

  set user(user) => _user = user;
  User get user=> _user;

  bool get login=> firebaseUser != null;




}