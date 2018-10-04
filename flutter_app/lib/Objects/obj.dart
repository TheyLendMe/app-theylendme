
import 'entity.dart';

abstract class Obj{
  final ObjType _type;
  final String _idObject;
  final Entity owner;

  ///TODO pensar mejor el tema de las imagenes. Deberia de ser una lista???
  String _name, _desc, _image;
  // Group groupBorrowed;
  // User userBorrowed;



  ///Constructor
  Obj(this._type,this._idObject,this.owner,String name, String desc, {String image =""}){
    this._name = name;
    this._desc = desc;
    this._image = image;
  }



///Abstract Methods 
  void lend(Entity e);

  void requestObj();

  ///Devolver--> no me deja poner return D: valdra solo con requestObj???
  void bringBack();

  void claim();

  void setObjectInfo({String name, String desc});

  void delObject({User user}){
    ///Funciones/deleteObject.php
    new Request("http://54.188.52.254/Funciones/getObjectsByUser.php").dataBuilder(
        idUser: _idEntity,
    ).doRequest();
  }

  void objHistory();

  void getInventory();
///Getters and setters methods

  String get name => _name;
  String get desc => _desc;
  String get image => _image;

  String get idObject => _idObject;
  ObjType get type => _type;
  



  set name(String name) => this._name = name;
  set desc(String desc) => this._desc = desc;

  ///TODO pensar mejor este tema
  set image(String image) => this._name = image;


}

class UserObject extends Obj{


  ///Constructor
  UserObject(String idObject, Entity owner, String name, String desc) : super(ObjType.USER_OBJECT, idObject, owner, name, desc){



  }

  @override
  void lend(Entity e) {
    // TODO: implement lend
  }

  @override
  void requestObj() {
    // TODO: implement requestObj
  }



  @override
  void claim() {
    // TODO: implement claim
  }

  @override
  void setObjectInfo({String name, String desc}) {
    // TODO: implement setObjectInfo
  }

  @override
  void delObject({User user}) {
    // TODO: implement delObject
  }

  @override
  void objHistory() {
    // TODO: implement objHistory
  }

  @override
  void getInventory() {
    // TODO: implement getInventory
  }

  @override
  void bringBack() {
    // TODO: implement bringBack
  }


 



}



class GroupObject extends Obj{


  ///Constructor
  GroupObject(String idObject, Entity owner, String name, String desc) : super(ObjType.GROUP_OBJECT, idObject, owner, name, desc){
  }


  @override
  void lend(Entity e) {
    // TODO: implement lend
  }

  @override
  void requestObj() {
    // TODO: implement requestObj
  }

  @override
  void claim() {
    // TODO: implement claim
  }

  @override
  void setObjectInfo({String name, String desc}) {
    // TODO: implement setObjectInfo
  }

  
  @override
  void delObject({User user} ) {
    // TODO: implement delObject
  }

  @override
  void objHistory() {
    // TODO: implement objHistory
  }

  @override
  void getInventory() {
    // TODO: implement getInventory
  }

  @override
  void bringBack() {
    // TODO: implement bringBack
  }



}








  enum ObjType {
    USER_OBJECT, GROUP_OBJECT
  }