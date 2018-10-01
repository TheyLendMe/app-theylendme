
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

  void request();

  ///Devolver--> no me deja poner return D: valdra solo con request???
  void bringBack();

  void claim();

  void setObjectInfo({String name, String desc});

  void delObject({User user});

  void objHistory();
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
  void request() {
    // TODO: implement request
  }

  @override
  void bringBack() {
    // TODO: implement bringBack
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
  void request() {
    // TODO: implement request
  }

  @override
  void bringBack() {
    // TODO: implement bringBack
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



}








  enum ObjType {
    USER_OBJECT, GROUP_OBJECT
  }