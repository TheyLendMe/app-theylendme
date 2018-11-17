
import 'entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'dart:io';

const String endpoint = "http://54.188.52.254/";

abstract class Obj{
  final ObjType _type;
  final int _idObject;
  int _amount;
  final Entity owner;
  ObjState _objState;
  DateTime _date;
  
  ///TODO pensar mejor el tema de las imagenes. Deberia de ser una lista???
  String _name, _desc, _img;
  // Group groupBorrowed;
  // User userBorrowed;



  ///Constructor
  Obj(this._type,this._idObject,this.owner,String name,{String desc,String image ="",ObjState objState, int amount = 1, DateTime date}){
    this._name = name;
    this._desc = desc;
    if (image!=null) {
      this._img = endpoint + image;
    }
    this._amount = amount;
    this._objState = objState == null ? new ObjState(state: StateOfObject.DEFAULT) : objState;
    this._date = date;
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
  DateTime get date => _date;
  int get amount => _amount;
  int get idObject => _idObject;
  ObjState get objState => _objState;
  ObjType get type => _type;
  set date(DateTime date) => _date = date;
  set name(String name) => this._name = name;
  set desc(String desc) => this._desc = desc;
  set amount(int amoun) => this._amount = amount;
  set objState(ObjState objState) => _objState = objState;
  ///TODO pensar mejor este tema
  set image(String image) => this._name = endpoint + image;

  ///Static Methods 
  static Future<List<Obj>> getObjects({var context}) async{
    ResponsePost res = await new RequestPost("getObjects").dataBuilder(
    ).doRequest(context : context);
    return res.objectsUserBuilder();
  }


}

class UserObject extends Obj{
  ///Constructor
  UserObject(int idObject, User owner, String name, {String desc, String image ="", ObjState objState, int amount, DateTime date})
  : super(ObjType.USER_OBJECT, idObject, owner, name, desc: desc, image: image, objState: objState, amount:amount, date : date);
  @override
  Future lendObj({int idRequest, var context}) async {
    await new RequestPost("lendObject").dataBuilder(
        userInfo: true,
        idRequest: idRequest != null ? idRequest : _objState.idState
    ).doRequest(context : context);
  }
  ///If the user does not set any amount, it will ask just for one object
  @override
  Future requestObj({int amount = 1, String msg, var context}) async {
    await new RequestPost("requestObject").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        requestMsg : msg
    ).doRequest(context : context);
  }
  @override
  Future claimObj({int idLoan ,String claimMsg, var context}) async{
    await new RequestPost("claimObject").dataBuilder(
        userInfo: true,
        idLoan: idLoan != null ? idLoan : _objState.idState,
        claimMsg: claimMsg
    ).doRequest(context : context);
  }
  @override
  Future delObj({var context}) async{
    await new RequestPost("deleteObject").dataBuilder(
        userInfo: true,
        idObject : _idObject
    ).doRequest(context : context);
  }

  @override
  Future objHistory({var context}) {
    // TODO: implement objHistory
  }



  @override
  Future returnObj({int idLoan, var context}) async {
    await new RequestPost("returnLendedObject").dataBuilder(
      userInfo: true,
      idLoan: idLoan != null ? idLoan : _objState.idState
    ).doRequest(context : context);
  }
  @override
  Future updateObject({String name,File img,int amount, var context}) async {
    List l = fieldNameFieldValue(name: name, amount: amount);
    await new RequestPost("updateObject").dataBuilder(
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
  GroupObject(int idObject, Entity owner, String name, {String desc, GroupObjState objState, int amount, String image, DateTime date}) 
  : super(ObjType.GROUP_OBJECT, idObject, owner, name, desc : desc, objState:objState, amount : amount, image :image, date : date);
  @override
  Future lend(int idRequest,{var context}) async {
    new RequestPost("lendGObject").dataBuilder(
        userInfo: true,
        idRequest: idRequest != null ? idRequest : _objState.idState
    ).doRequest(context : context);
  }
  @override
  Future requestObj({int amount = 1, String msg, var context}) async{
    await new RequestPost("RequestAsGroup").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        requestMsg : msg,
        idGroup: this.owner.idEntity
    ).doRequest(context : context);
  }
  Future requestAsMember({int amount = 1, String msg, var context}) async{
    await new RequestPost("intraRequest").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        requestMsg : msg,
    ).doRequest(context : context);
  }
  Future requestAsUser({int amount = 1, String msg, var context}) async{
    await new RequestPost("RequestAsUser").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        requestMsg : msg,
    ).doRequest(context : context);
  }
  @override
  Future claimObj({int idLoan ,String claimMsg, var context}) async{
    await new RequestPost("claimGObject").dataBuilder(
        userInfo: true,
        idLoan: idLoan != null ? idLoan : _objState.idState,
        claimMsg: claimMsg
    ).doRequest(context : context);
  }
  @override
  Future delObj({var context}) async{
    await new RequestPost("deleteGObject").dataBuilder(
      userInfo: true,
      idObject : this._idObject
    ).doRequest(context : context);
  }
  @override
  Future objHistory({var context}) async {
    // TODO: implement objHistory
  }
  @override
  Future returnObj({int idLoan, var context}) async{
      new RequestPost("returnLentGObject").dataBuilder(
      userInfo: true,
      idLoan: idLoan != null ? idLoan : _objState.idState
    ).doRequest(context : context);
  }
  @override
  Future updateObject({String name,File img,int amount = 1, var context}) async{
    List l = fieldNameFieldValue(name: name, amount: amount);
    await new RequestPost("updateGObject").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        fieldname: l[0],
        fieldValue: l[1],
        idGroup: owner.idEntity,
        img: img

    ).doRequest(context : context);
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
  @override
  GroupObjState get objState => _objState;


}

  enum ObjType {
    USER_OBJECT, GROUP_OBJECT
  }
