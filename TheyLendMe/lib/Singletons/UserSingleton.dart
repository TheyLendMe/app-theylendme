import 'package:TheyLendMe/Objects/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:TheyLendMe/Utilities/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSingleton{
  static UserSingleton _singleton;
  User _user;
  FirebaseUser firebaseUser;
  Notifications notifications;
  String token;

  factory UserSingleton(){
    if(_singleton == null){
      _singleton = new UserSingleton._internal();
    }
    return _singleton;
    }


  UserSingleton._internal(){
    notifications = Notifications();
    FirebaseAuth.instance.currentUser().then((user){
      if(user != null){
        this._user = new User(user.uid, user.displayName,userEmail: user.email);
        this.firebaseUser = user;
      }
    });
  
  } 

  Future refreshUser() async{
    firebaseUser = await FirebaseAuth.instance.currentUser();
    if(firebaseUser == null){return;}
    this.token = await firebaseUser.getIdToken();
    if(_user == null){this._user = new User(firebaseUser.uid, firebaseUser.displayName); print("Me actaulizo");}
  }

  set user(user) => _user = user;
  User get user => _user;

  bool get login=> firebaseUser != null;

}