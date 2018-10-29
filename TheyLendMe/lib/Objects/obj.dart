
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
  Future lendObj({int idRequest});

  Future requestObj();

  ///Devolver--> no me deja poner return D: valdra solo con requestObj???
  Future returnObj({int idLoan});

  Future claim({int idLoan});

  Future delObject();

  Future objHistory();


  Future updateObject({String name,String imagen,int amount});
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
  Future lendObj({int idRequest}) {
    new RequestPost("lendObject").dataBuilder(
        userInfo: true,
        idRequest: idRequest != null ? idRequest : _objState.idState
    ).doRequest();
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
  Future claim({int idLoan ,String claimMsg}) {
    new RequestPost("claimObject").dataBuilder(
        userInfo: true,
        idLoan: idLoan != null ? idLoan : _objState.idState,
        claimMsg: claimMsg
    ).doRequest();
  }

  @override
  void setObjectInfo({String name, String desc}) {
    // TODO: implement setObjectInfo
  }

  @override
  Future delObject() {
    new RequestPost("deleteObject").dataBuilder(
        userInfo: true,
        idObject : _idObject
    ).doRequest();
  }

  @override
  Future objHistory() {
    // TODO: implement objHistory
  }


  @override
  Future returnObj({int idLoan, String idUser}) {
    new RequestPost("returnLendedObject").dataBuilder(
      userInfo: true,
      idLoan: idLoan != null ? idLoan : _objState.idState
    ).doRequest();
  }



///TODO Como añadimos imagenes? 
  @override
  Future updateObject({String name,String imagen,int amount}) {
    List l = fieldNameFieldValue(name: name, amount: amount);
    new RequestPost("updateObject").dataBuilder(
        userInfo: true,
        idObject : _idObject,
        fieldname: l[0],
        fieldValue: l[1]
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
  Future requestObj() {
    // TODO: implement requestObj
  }

  @override
  Future claim({int idLoan}) {
    // TODO: implement claim
  }


  
  @override
  Future delObject() {
    new RequestPost("deleteGObject").dataBuilder(
      userInfo: true,
      idObject : this._idObject
    ).doRequest();
  }

  @override
  Future objHistory() {
    // TODO: implement objHistory
  }


  @override
  Future returnObj({int idLoan}) {
        new RequestPost("returnLendedObject").dataBuilder(
      userInfo: true,
      idLoan: idLoan != null ? idLoan : _objState.idState
    ).doRequest();
  }

  @override
  Future updateObject({String name,String imagen,int amount}) {
    // TODO: implement updateObject
  }

  @override
  Future lendObj({int idRequest}) async {
    await new RequestPost("lendGObject").dataBuilder(
        userInfo: true,
        idRequest: idRequest != null ? idRequest : _objState.idState
    ).doRequest();
  }



}








  enum ObjType {
    USER_OBJECT, GROUP_OBJECT
  }
