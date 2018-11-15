import 'package:TheyLendMe/Objects/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TheyLendMe/Utilities/notifications.dart';
import 'package:TheyLendMe/Utilities/auth.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';

class UserSingleton{
  static UserSingleton _singleton;
  static String _anomid = "";
  User _user;
  FirebaseUser firebaseUser;
  Notifications notifications;
  String token;

  factory UserSingleton({FirebaseUser user}){
    if(_singleton == null){
      
      _singleton = new UserSingleton._internal(user);
    }
    return _singleton;
    }
  UserSingleton._internal(FirebaseUser user){
    if(user == null){
      FirebaseAuth.instance.currentUser().then((user){
        this._user = new User(user.uid, user.displayName,email: user.email);
        this.firebaseUser = user;
      });
    }else{
      notifications = Notifications();
      this._user = new User(user.uid, user.displayName,email: user.email);
      this.firebaseUser = user;
    }
 

  } 
  Future refreshUser() async{
    firebaseUser = await FirebaseAuth.instance.currentUser();
    if(firebaseUser == null){throw Exception;}
    this.token = await firebaseUser.getIdToken();
    if(_user == null || _user.idEntity == ""){this._user = new User(firebaseUser.uid, firebaseUser.displayName); print("Me actaulizo");}
  }

  set user(user) => _user = user;
  User get user {
    return _user;
  } 

  bool get login=> firebaseUser != null;

}