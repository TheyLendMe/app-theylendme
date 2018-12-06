
import 'entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'dart:io';



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
  Obj(this._type,this._idObject,this.owner,String name,{String desc,String image,ObjState objState, int amount = 1, String date, int actualAmount = null}){
    this._name = name;
    this._desc = desc;
    if (image!=null) {
      this._img = endpoint + image;
    }else{
      _img = null;
    }
    this._amount = amount;
    this._objState = objState == null ? new ObjState(state: StateOfObject.DEFAULT, amount: actualAmount == null ? amount : actualAmount) : objState;
    this._date = dateFormat.parse(date);

  }



///Abstract Methods 
  Future<bool> lendObj({var context});
  Future<bool> requestObj({int amount = 1, String msg, var context});
  ///Devolver--> no me deja poner return D: valdra solo con requestObj???
  Future<bool> returnObj({var context});
  Future<bool> claimObj({String claimMsg, var context});
  Future<bool> delObj({var context});
  Future objHistory({var context});
  Future<bool> updateObject({String name,File img,int amount = 1, var context});
  Future<bool> deleteRequest();
///Getters and setters methods
  String get name => _name;
  String get desc => _desc;
  String get image => _img;
  DateTime get date => _date;
  int get amount => _amount;
  int get idObject => _idObject;
  ObjState get objState => _objState;
  ObjType get type => _type;
  get actualAmount => objState.amount;
  set actualAmount(int actualAmount) => objState.amount = amount;
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
  UserObject(int idObject, User owner, String name, {String desc, String image ="", ObjState objState, int amount, String date, int actualAmount})
  : super(ObjType.USER_OBJECT, idObject, owner, name, desc: desc, image: image, objState: objState, amount:amount, date : date, actualAmount : actualAmount);
  
  Future<bool> lendObj({int idRequest, var context}) async {
    ResponsePost res = await new RequestPost("lendObject").dataBuilder(
        userInfo: true,
        idRequest: idRequest != null ? idRequest : _objState.idState
    ).doRequest(context : context);
    return res.hasError;
  }
  ///If the user does not set any amount, it will ask just for one object
  
  Future<bool> requestObj({int amount = 1, String msg, var context, bool asUser = true}) async {
    ResponsePost res = await new RequestPost("requestObject").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        requestMsg : msg
    ).doRequest(context : context);
    return res.hasError;
  }
  
  Future<bool> claimObj({int idLoan ,String claimMsg, var context}) async{
    ResponsePost res = await new RequestPost("claimObject").dataBuilder(
        userInfo: true,
        idLoan: idLoan != null ? idLoan : _objState.idState,
        claimMsg: claimMsg
    ).doRequest(context : context);
    return res.hasError;
  }

  Future<bool> delObj({var context}) async{
    ResponsePost res = await new RequestPost("deleteObject").dataBuilder(
        userInfo: true,
        idObject : _idObject
    ).doRequest(context : context);
    return res.hasError;
  }

  
  Future objHistory({var context}) {
    // TODO: implement objHistory
  }



  
  Future<bool> returnObj({int idLoan, var context}) async {
    ResponsePost res = await new RequestPost("returnLendedObject").dataBuilder(
      userInfo: true,
      idLoan: idLoan != null ? idLoan : _objState.idState
    ).doRequest(context : context);
    return res.hasError;
  }
  
  Future<bool> updateObject({String name,File img,int amount, var context}) async {
    List l = fieldNameFieldValue(name: name, amount: amount);
    ResponsePost res = await new RequestPost("updateObject").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        fieldname: l[0],
        fieldValue: l[1],
        img: img

    ).doRequest(context : context);
    return res.hasError;
  }

  
  Future<bool> deleteRequest({var context}) async{
    ResponsePost res = await new RequestPost("deleteRequest").dataBuilder(
      idObject: this.idObject,
      userInfo: true,
      idRequest: _objState.idState
    ).doRequest(context: context);
    return res.hasError;
  }
}

class GroupObject extends Obj{
  
  //Constructor
  GroupObject(int idObject, Entity owner, String name, {String desc, GroupObjState objState, int amount, String image, String date, int actualAmount }) 
  : super(ObjType.GROUP_OBJECT, idObject, owner, name, desc : desc, objState:objState, amount : amount, image :image, date : date, actualAmount : actualAmount);
  
  Future<bool> requestObjAsGroup({Group group,int amount = 1, String msg, var context}) async{
    ResponsePost res = await new RequestPost("RequestAsGroup").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        requestMsg : msg,
        idGroup: owner.idEntity
    ).doRequest(context : context);
    return res.hasError;
  }
  Future<bool> requestAsMember({int amount = 1, String msg, var context}) async{
    ResponsePost res = await new RequestPost("intraRequest").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        requestMsg : msg,
    ).doRequest(context : context);
    return res.hasError;
  }
  Future<bool> requestObjAsUser({int amount = 1, String msg, var context}) async{
    ResponsePost res = await new RequestPost("RequestAsUser").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        requestMsg : msg,
    ).doRequest(context : context);
    return res.hasError;
  }
  @override
  Future<bool> requestObj({int amount = 1, String msg, var context, bool asUser = true}) async{
    return asUser ? await requestObjAsUser(amount: amount, msg: msg,context: context) : 
      await requestObjAsGroup(amount: amount, msg: msg,context: context);
  }
  
  Future<bool> claimObj({int idLoan ,String claimMsg, var context}) async{
    ResponsePost res = await new RequestPost("claimGObject").dataBuilder(
        userInfo: true,
        idLoan: idLoan != null ? idLoan : _objState.idState,
        claimMsg: claimMsg
    ).doRequest(context : context);
    return res.hasError;
  }
  
  Future<bool> delObj({var context}) async{
    ResponsePost res = await new RequestPost("deleteGObject").dataBuilder(
      userInfo: true,
      idObject : this._idObject
    ).doRequest(context : context);
    return res.hasError;
  }
  
  Future objHistory({var context}) async {
    // TODO: implement objHistory
  }
  
  Future<bool> returnObj({int idLoan, var context}) async{
    ResponsePost res = await new RequestPost("returnLentGObject").dataBuilder(
      userInfo: true,
      idLoan: idLoan != null ? idLoan : _objState.idState
    ).doRequest(context : context);
    return res.hasError;
  }
  
  Future<bool> updateObject({String name,File img,int amount = 1, var context}) async{
    List l = fieldNameFieldValue(name: name, amount: amount);
    ResponsePost res = await new RequestPost("updateGObject").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        fieldname: l[0],
        fieldValue: l[1],
        idGroup: owner.idEntity,
        img: img

    ).doRequest(context : context);
    return res.hasError;
  }
  
  Future<bool> lendObj({int idRequest, var context}) async {
    ResponsePost res = await new RequestPost("lendGObject").dataBuilder(
        userInfo: true,
        idRequest: idRequest != null ? idRequest : _objState.idState
    ).doRequest(context : context);
    return res.hasError;
  }

  /*Future groupObjectRequest({int amount =1, var context}) async{
    ResponsePost res = await new RequestPost("intraRequest").dataBuilder(
      userInfo: true,
      idObject: this.idObject,
      amount: amount,
    ).doRequest(context : context);
  }*/
  
  ObjState get objState => _objState;

  
  Future<bool> deleteRequest() {
    // TODO: implement deleteRequest
    return null;
  }


}

  enum ObjType {
    USER_OBJECT, GROUP_OBJECT
  }
