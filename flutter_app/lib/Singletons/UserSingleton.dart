import 'package:flutter_app/Objects/entity.dart';

class UserSingleton{
  static final UserSingleton singleton = new UserSingleton._internal();
  User _user;
  factory UserSingleton(){return singleton;}
  UserSingleton._internal();   

  set user(user) => _user = user;
  User get user=> _user;


}