import 'package:TheyLendMe/Objects/entity.dart';

class JoinRequest{
  final int _id;
  final Group _group;
  final User _user;

  JoinRequest(this._id,this._group,this._user);

  int get id => _id;
  Group get group => _group;
  User get user => _user;




}