
import 'entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'dart:io';

abstract class Obj{
  final ObjType _type;
  final int _idObject;
  final Entity owner;
  ObjState _objState;
  
  ///TODO pensar mejor el tema de las imagenes. Deberia de ser una lista???
  String _name, _desc, _img;
  // Group groupBorrowed;
  // User userBorrowed;



  ///Constructor
  Obj(this._type,this._idObject,this.owner,String name,{String desc,String image ="",ObjState objState}){
    this._name = name;
    this._desc = desc;
    this._img = image;
    this._objState = objState;
  }



///Abstract Methods 
  Future lendObj({var context});
  Future requestObj({int amount = 1, String msg, var context});
  ///Devolver--> no me deja poner return D: valdra solo con requestObj???
  Future returnObj({var context});
  Future claimObj({String claimMsg, var context});
  Future delObj({var context});
  Future objHistory({var context});
  Future updateObject({String name,File img,int amount = 1, var context});
///Getters and setters methods
  String get name => _name;
  String get desc => _desc;
  String get image => _img;
  ObjState get objState => _objState;
  int get idObject => _idObject;
  ObjType get type => _type;
  set name(String name) => this._name = name;
  set desc(String desc) => this._desc = desc;
  ///TODO pensar mejor este tema
  set image(String image) => this._name = image;

  ///Static Methods 
  static Future<List<Obj>> getObjects({var context}) async{
    ResponsePost res = await new RequestPost("getObjects").dataBuilder(
    ).doRequest(context : context);
    return res.objectsBuilder();
  }
}

class UserObject extends Obj{
  ///Constructor
  UserObject(int idObject, User owner, String name, {String desc, String image ="", ObjState objState})
  : super(ObjType.USER_OBJECT, idObject, owner, name, desc: desc, image: image, objState: objState);
  @override
  Future lendObj({int idRequest, var context}) {
    new RequestPost("lendObject").dataBuilder(
        userInfo: true,
        idRequest: idRequest != null ? idRequest : _objState.idState
    ).doRequest(context : context);
  }
  ///If the user does not set any amount, it will ask just for one object
  @override
  Future requestObj({int amount = 1, String msg, var context}) {
    new RequestPost("requestObject").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        requestMsg : msg
    ).doRequest(context : context);
  }
  @override
  Future claimObj({int idLoan ,String claimMsg, var context}) {
    new RequestPost("claimObject").dataBuilder(
        userInfo: true,
        idLoan: idLoan != null ? idLoan : _objState.idState,
        claimMsg: claimMsg
    ).doRequest(context : context);
  }
  @override
  Future delObj({var context}) {
    new RequestPost("deleteObject").dataBuilder(
        userInfo: true,
        idObject : _idObject
    ).doRequest(context : context);
  }

  @override
  Future objHistory({var context}) {
    // TODO: implement objHistory
  }


  @override
  Future returnObj({int idLoan, var context}) {
    new RequestPost("returnLendedObject").dataBuilder(
      userInfo: true,
      idLoan: idLoan != null ? idLoan : _objState.idState
    ).doRequest(context : context);
  }
  @override
  Future updateObject({String name,File img,int amount, var context}) {
    List l = fieldNameFieldValue(name: name, amount: amount);
    new RequestPost("updateObject").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        fieldname: l[0],
        fieldValue: l[1],
        img: img

    ).doRequest(context : context);
  }
}

class GroupObject extends Obj{
  //Constructor
  GroupObject(int idObject, Entity owner, String name, {String desc, ObjState objState}) 
  : super(ObjType.GROUP_OBJECT, idObject, owner, name, desc : desc, objState:objState);
  @override
  void lend(int idRequest) {
    // TODO: implement lend
  }
  @override
  Future requestObj({int amount = 1, String msg, var context}) {
    // TODO: implement requestObj
  }
  @override
  Future claimObj({int idLoan ,String claimMsg, var context}) {
    // TODO: implement claim
  }
  @override
  Future delObj({var context}) {
    new RequestPost("deleteGObject").dataBuilder(
      userInfo: true,
      idObject : this._idObject
    ).doRequest(context : context);
  }
  @override
  Future objHistory({var context}) {
    // TODO: implement objHistory
  }
  @override
  Future returnObj({int idLoan, var context}) {
        new RequestPost("returnLendedObject").dataBuilder(
      userInfo: true,
      idLoan: idLoan != null ? idLoan : _objState.idState
    ).doRequest(context : context);
  }
  @override
  Future updateObject({String name,File img,int amount = 1, var context}) {
    // TODO: implement updateObject
  }
  @override
  Future lendObj({int idRequest, var context}) async {
    await new RequestPost("lendGObject").dataBuilder(
        userInfo: true,
        idRequest: idRequest != null ? idRequest : _objState.idState
    ).doRequest(context : context);
  }

  Future groupObjectRequest({int amount =1, var context}) async{
    ResponsePost res = await new RequestPost("intraRequest").dataBuilder(
      userInfo: true,
      idObject: this.idObject,
      amount: amount,
    ).doRequest(context : context);
  }
}

  enum ObjType {
    USER_OBJECT, GROUP_OBJECT
  }
