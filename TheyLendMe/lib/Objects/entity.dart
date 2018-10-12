import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

abstract class Entity{
  final dynamic _idEntity;
  final EntityType _type;
  String _name,_info,_img;

  


  Entity(this._type,this._idEntity,this._name,{String info ="",String img =""}){

  }


  ///Getters and settes
  get idEntity => _idEntity;
  String get name => _name;
  String get info => _info;

  EntityType get type => _type;


  set name(name) => _name = name;
  set info(info) => _info = info;


  ///Other functions
  ///
  

  ///Add an object to a group or to a user.
  void addObject(String name, int amount);





  void updateInfo();


////INFOOOOOOOOOOOOOOO
  Future<List<Obj>> getObjects();
  void getRequest();

}



class User extends Entity{

  String userEmail;
  String tfno;
  User(String idEntity, String name, {this.userEmail}) : super(EntityType.USER, idEntity, name);

  @override
  void addObject(String name, int amount) {
     new Request("createObject").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        name: name 
    ).doRequest();
    
  }



  ///This is a Future<List<Obj>> , to get the list must use await otherwise it will return a Future!
  @override
  Future<List<Obj>> getObjects() async{
    Response res = await new Request("getObjectsByUser").dataBuilder(
        idUser: this.idEntity,
    ).doRequest();
    return res.objectsBuilder(this);
  }

  @override
  void getRequest() {
    // TODO: implement getRequest
  }



///TODO falta probar
  @override
  void updateInfo({String nickName , String info,String email, String tfno}) async {


     Response res = await new Request("updateUser").dataBuilder(
        idUser: this.idEntity,
        info: info,
        email:email,
        tfno: tfno,
        nickName : nickName
    ).doRequest();
  }


  get email => userEmail;



}

class Group extends Entity{
  Group(EntityType type, String idEntity, String name) : super(EntityType.GROUP, idEntity, name);

  @override
  void addObject(String name, int amount) {
    // TODO: implement addObject
  }

  @override
  void getRequest() {
    // TODO: implement getRequest
  }


  void addUser(){

  }

  void delUser({User u}){
  
  }

  void addAdmin({User u}){
  }


///Method to obtain all the user of the group
  void getUsers(){

  }

  @override
  void updateInfo() {
    // TODO: implement updateInfo
  }

  @override
  Future<List<Obj>> getObjects() async{
    ///TODO change link 
    Response res = await new Request("getObjectsByUser").dataBuilder(
        idGroup: this.idEntity,
    ).doRequest();
    return res.objectsBuilder(this);
  }
}



  enum EntityType {
    USER, GROUP, Default
  }