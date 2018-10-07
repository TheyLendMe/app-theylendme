import 'package:flutter_app/Utilities/reqresp.dart';
import 'package:flutter_app/Objects/obj.dart';
import 'package:flutter_app/Singletons/UserSingleton.dart';

abstract class Entity{
  final dynamic _idEntity;
  final EntityType _type;
  String _name,_desc,_img;

  


  Entity(this._type,this._idEntity,this._name,{String desc,String img}){

  }


  ///Getters and settes
  get idEntity => _idEntity;
  String get name => _name;
  String get desc => _desc;

  EntityType get type => _type;


  set name(name) => _name = name;
  set desc(desc) => _desc = desc;


  ///Other functions
  ///
  

  ///Add an object to a group or to a user.
  void addObject(String name, int amount);



  Future<List<Obj>> getObjects();

  void getRequest();

  void updateInfo();

}



class User extends Entity{

  String userEmail;
  User(String idEntity, String name, {this.userEmail}) : super(EntityType.USER, idEntity, name);

  @override
  void addObject(String name, int amount) {
     new Request("http://54.188.52.254/Funciones/createObject.php").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        name: name 
    ).doRequest();
    
  }


  @override
  Future<List<Obj>> getObjects() async{
    Response res = await new Request("http://54.188.52.254/Funciones/getObjectsByUser.php").dataBuilder(
        idUser: this.idEntity,
    ).doRequest();
    return res.objectsBuilder(this);
  }

  @override
  void getRequest() {
    // TODO: implement getRequest
  }

  @override
  void updateInfo() {
    // TODO: implement updateInfo
  }


  get email => email;



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
    Response res = await new Request("http://54.188.52.254/Funciones/getObjectsByUser.php").dataBuilder(
        idGroup: this.idEntity,
    ).doRequest();
    return res.objectsBuilder(this);
  }
}



  enum EntityType {
    USER, GROUP, Default
  }