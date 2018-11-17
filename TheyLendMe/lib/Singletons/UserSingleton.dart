import 'package:TheyLendMe/Objects/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TheyLendMe/Utilities/notifications.dart';
import 'package:TheyLendMe/Utilities/auth.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSingleton{
  static UserSingleton _singleton;
  User _user;
  Notifications notifications;
  String token;

  factory UserSingleton({FirebaseUser user}){
    if(_singleton == null){
      _singleton = new UserSingleton._internal();
      }
    return _singleton;
    }
  UserSingleton._internal(){
    firebaseUser.then((user) async{
        if(user != null){this._user = new User(user.uid, user.displayName,email: user.email);}
        else{ _user = await sharedPrefUser();}       
    });
  } 

  Future<User> sharedPrefUser() async{
    SharedPreferences sh = await SharedPreferences.getInstance();
    bool wasLoged = sh.getBool('wasLogged');
    if(wasLoged == null || !wasLoged){return null;}
    return new User(
      sh.getString("uid"), 
      sh.getString("name"),
      email:sh.getString("email")
    );
      
  }

  Future refreshUser() async{
    FirebaseUser firebaseUser = await this.firebaseUser;
    if(firebaseUser == null){this._user = null;}else{
      this.token = await firebaseUser.getIdToken();
       if(_user == null || _user.idEntity == ""){this._user = new User(firebaseUser.uid, firebaseUser.displayName); print("Me actualizo");}
    }
   
  }
  set user(user) => _user = user;
  User get user { return _user; } 
  Future<FirebaseUser> get firebaseUser => FirebaseAuth.instance.currentUser();
  bool get login=> user != null;

}