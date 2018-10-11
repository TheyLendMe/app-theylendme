
import 'entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';

abstract class Obj{
  final ObjType _type;
  final int _idObject;
  final Entity owner;
  






  ///TODO pensar mejor el tema de las imagenes. Deberia de ser una lista???
  String _name, _desc, _image;
  // Group groupBorrowed;
  // User userBorrowed;



  ///Constructor
  Obj(this._type,this._idObject,this.owner,String name,{String desc,String image ="",}){
    this._name = name;
    this._desc = desc;
    this._image = image;
  }



///Abstract Methods 
  void lend(int idRequest);

  void requestObj();

  ///Devolver--> no me deja poner return D: valdra solo con requestObj???
  void returnObj(int idLoan);

  void claim(int idLoan);

  void setObjectInfo({String name, String desc});

  void delObject();

  void objHistory();

  void getInventory();

  void updateObject();
///Getters and setters methods

  String get name => _name;
  String get desc => _desc;
  String get image => _image;

  int get idObject => _idObject;
  ObjType get type => _type;
  



  set name(String name) => this._name = name;
  set desc(String desc) => this._desc = desc;

  ///TODO pensar mejor este tema
  set image(String image) => this._name = image;


}

class UserObject extends Obj{


  ///Constructor
  UserObject(int idObject, Entity owner, String name, {String desc}) : super(ObjType.USER_OBJECT, idObject, owner, name, desc: desc){



  }

  @override
  void lend(int idRequest) {
    new Request("http://54.188.52.254/Funciones/lendObject.php").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        idRequest: idRequest
    ).doRequest();
  }


  ///If the user does not set any amount, it will ask just for one object
  @override
  void requestObj({int amount = 1, String msg, var context}) {
    new Request("http://54.188.52.254/Funciones/requestObject.php").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        idObject : _idObject,
        msg : msg
    ).doRequest(context : context);
  }



  @override
  void claim(int idLoan, {String claimMsg}) {
    new Request("http://54.188.52.254/Funciones/claimObject.php").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        idLoan: idLoan,
        claimMsg: claimMsg
    ).doRequest();
  }

  @override
  void setObjectInfo({String name, String desc}) {
    // TODO: implement setObjectInfo
  }

  @override
  void delObject() {
    new Request("http://54.188.52.254/Funciones/deleteObject.php").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        idObject : _idObject
    ).doRequest();
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
  void returnObj(int idLoan) {
    new Request("http://54.188.52.254/Funciones/returnLendedObject.php").dataBuilder(
      idUser: UserSingleton.singleton.user.idEntity,
      idLoan: idLoan
    ).doRequest();
  }



///TODO Falta por probar
  @override
  void updateObject({String name,String imagen,int amount}) {
    new Request("http://54.188.52.254/Funciones/updateObject.php").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        idObject : _idObject,
        name: name,
        imagen: imagen,
        amount: amount,
    ).doRequest();
  }
}



class GroupObject extends Obj{


  ///Constructor
  GroupObject(int idObject, Entity owner, String name, {String desc}) : super(ObjType.GROUP_OBJECT, idObject, owner, name, desc : desc){
  }


  @override
  void lend(int idRequest) {
    // TODO: implement lend
  }

  @override
  void requestObj() {
    // TODO: implement requestObj
  }

  @override
  void claim(int idLoan) {
    // TODO: implement claim
  }

  @override
  void setObjectInfo({String name, String desc}) {
    // TODO: implement setObjectInfo
  }

  
  @override
  void delObject() {
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
  void returnObj(int idLoan) {
    // TODO: implement returnObj
  }

  @override
  void updateObject() {
    // TODO: implement updateObject
  }



}








  enum ObjType {
    USER_OBJECT, GROUP_OBJECT
  }

  enum ObjetState{
    
    DEFAULT, LENDED, REQUESTED, LENT, BORROWED, CLAIMED, 

  }