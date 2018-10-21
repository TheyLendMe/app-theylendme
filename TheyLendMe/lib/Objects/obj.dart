
import 'entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/objState.dart';

abstract class Obj{
  final ObjType _type;
  final int _idObject;
  final Entity owner;
  ObjState _objState;
  
  ///TODO pensar mejor el tema de las imagenes. Deberia de ser una lista???
  String _name, _desc, _image;
  // Group groupBorrowed;
  // User userBorrowed;



  ///Constructor
  Obj(this._type,this._idObject,this.owner,String name,{String desc,String image ="",ObjState objState}){
    this._name = name;
    this._desc = desc;
    this._image = image;
    this._objState = objState;
  }



///Abstract Methods 
  void lendObj({int idRequest});

  void requestObj();

  ///Devolver--> no me deja poner return D: valdra solo con requestObj???
  void returnObj({int idLoan});

  void claim({int idLoan});

  void delObject();

  void objHistory();


  void updateObject({String name,String imagen,int amount});
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

  ///Static Methods 
  static Future<List<Obj>> getObjects() async{
    ResponsePost res = await new RequestPost("getObjects").dataBuilder(
    ).doRequest();
    return res.objectsBuilder();
  }



}

class UserObject extends Obj{


  ///Constructor
  UserObject(int idObject, User owner, String name, {String desc, ObjState objState}) 
  : super(ObjType.USER_OBJECT, idObject, owner, name, desc: desc, objState: objState);

  @override
  void lendObj({int idRequest}) {
    new RequestPost("lendObject").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        idRequest: idRequest != null ? idRequest : _objState.idState
    ).doRequest();
  }


  ///If the user does not set any amount, it will ask just for one object
  @override
  void requestObj({int amount = 1, String msg, var context}) {
    new RequestPost("requestObject").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        idObject : _idObject,
        msg : msg
    ).doRequest(context : context);
  }


  @override
  void claim({int idLoan ,String claimMsg}) {
    new RequestPost("claimObject").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        idLoan: idLoan != null ? idLoan : _objState.idState,
        claimMsg: claimMsg
    ).doRequest();
  }

  @override
  void setObjectInfo({String name, String desc}) {
    // TODO: implement setObjectInfo
  }

  @override
  void delObject() {
    new RequestPost("deleteObject").dataBuilder(
        idUser: UserSingleton.singleton.user.idEntity,
        idObject : _idObject
    ).doRequest();
  }

  @override
  void objHistory() {
    // TODO: implement objHistory
  }


  @override
  void returnObj({int idLoan, String idUser}) {
    new RequestPost("returnLendedObject").dataBuilder(
      idUser: idUser != null ? idUser : UserSingleton.singleton.user.idEntity,
      idLoan: idLoan != null ? idLoan : _objState.idState
    ).doRequest();
  }



///TODO Falta por probar
  @override
  void updateObject({String name,String imagen,int amount}) {
    new RequestPost("updateObject").dataBuilder(
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
  GroupObject(int idObject, Entity owner, String name, {String desc, ObjState objState}) 
  : super(ObjType.GROUP_OBJECT, idObject, owner, name, desc : desc, objState:objState);

  @override
  void lend(int idRequest) {
    // TODO: implement lend
  }

  @override
  void requestObj() {
    // TODO: implement requestObj
  }

  @override
  void claim({int idLoan}) {
    // TODO: implement claim
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
  void returnObj({int idLoan}) {
    // TODO: implement returnObj
  }

  @override
  void updateObject({String name,String imagen,int amount}) {
    // TODO: implement updateObject
  }

  @override
  void lendObj({int idRequest}) {
    // TODO: implement lendObj
  }



}








  enum ObjType {
    USER_OBJECT, GROUP_OBJECT
  }
