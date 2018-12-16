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
  String _userImage;
  String token;
  bool emailVerified = false;

  factory UserSingleton({FirebaseUser user}){
    if(_singleton == null){
      _singleton = new UserSingleton._internal();
    }
    return _singleton;
    }
  UserSingleton._internal(){
    firebaseUser.then((user) async{
        if(user != null){this._user = new User(user.uid, user.displayName,email: user.email); await refreshUser();}
        else{ _user = await sharedPrefUser(); await refreshUser();
       }    
    });
  } 

  Future<User> sharedPrefUser() async{
    SharedPreferences sh = await SharedPreferences.getInstance();
    bool wasLoged = sh.getBool('wasLogged');
    if(wasLoged == null || !wasLoged){return null;}
    return User(
      sh.getString("uid"), 
      sh.getString("name"),
      email:sh.getString("email"),
    );
  }

  Future refreshUser({bool first = false}) async{
    FirebaseUser firebaseUser = await this.firebaseUser;
    if(firebaseUser == null){this._user = null;}else{
      this.token = await firebaseUser.getIdToken();
      emailVerified = firebaseUser.isEmailVerified;
      if(_user == null || _user.idEntity == ""){

        this._user = new User(firebaseUser.uid, firebaseUser.displayName, email: firebaseUser.email);
        print("Me actualizo");} 
      try{
        if(!first){
          User u = await _user.getEntityInfo();
          _userImage = u.img;
        }
        /*if(u.img == null){_user.updateInfo(img: await Auth.downloadProfileImage(firebaseUser.photoUrl));}*/
      }catch(e){}
    }
    ///Esto en caso de que x info de google difiera de info de la base de datos o cierta info falte ya que solo
    ///se guarda en la base de datos.
    
  }

  Future<bool> resendEmail() async{
    if(!(await firebaseUser).isEmailVerified){(await firebaseUser).sendEmailVerification();}
  }

  set userImage (String img) => _userImage = img;
  String get userImage =>  _userImage;
  set user(user) => _user = user;
  User get user { return _user; } 
  Future<FirebaseUser> get firebaseUser => FirebaseAuth.instance.currentUser();
  bool get login=> user != null;
  set login(bool login)=> user == null;

}