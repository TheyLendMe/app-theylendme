import 'package:flutter_app/Utilities/reqresp.dart';

abstract class Entity{
  final String _idEntity;
  final EntityType _type;
  String _name,_desc,_img;

  


  Entity(this._type,this._idEntity,this._name,{String desc,String img}){

  }


  ///Getters and settes
  String get idEntity => _idEntity;
  String get name => _name;
  String get desc => desc;

  EntityType get type => _type;


  set name(name) => _name = name;
  set desc(desc) => _desc = desc;


  ///Other functions
  ///
  

  ///Add an object to a group or to a user.
  void addObject(String name, int amount);

  void delObject();

  void getObjects();

  void getRequest();

  void updateInfo();

}



class User extends Entity{
  User(String idEntity, String name) : super(EntityType.USER, idEntity, name);

  @override
  void addObject(String name, int amount) {
     new Request("http://54.188.52.254/Funciones/createObject.php").dataBuilder(
        idUser: _idEntity,
        name: name 
    ).doRequest();
    
  }

  @override
  void delObject() {
    // TODO: implement delObject
  }

  @override
  void getObjects() {
      new Request("http://54.188.52.254/Funciones/getObjectsByUser.php").dataBuilder(
        idUser: _idEntity,
    ).doRequest();
  }

  @override
  void getRequest() {
    // TODO: implement getRequest
  }

  @override
  void updateInfo() {
    // TODO: implement updateInfo
  }




}

class Group extends Entity{
  Group(EntityType type, String idEntity, String name) : super(EntityType.GROUP, idEntity, name);

  @override
  void addObject(String name, int amount) {
    // TODO: implement addObject
  }

  @override
  void delObject() {
    // TODO: implement delObject
  }

  
  @override
  void getObjects() {
    // TODO: implement getObjects
  }

  @override
  void get() {
    // TODO: implement get
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
  void getUser(){

  }

  @override
  void updateInfo() {
    // TODO: implement updateInfo
  }


  

}



  enum EntityType {
    USER, GROUP, Default
  }