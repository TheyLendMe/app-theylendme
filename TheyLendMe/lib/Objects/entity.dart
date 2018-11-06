import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:TheyLendMe/Utilities/errorHandler.dart';
import 'dart:io';

abstract class Entity{

  dynamic _idEntity;
  final EntityType _type;
  String _name,_info,_img,_tfno,_email;

  ///COnstructor, you may need info and the url of the image
  Entity(this._type,this._idEntity,this._name,{String info,String img,String tfno, String email}){
    _info = info;
    _img = img;
    _tfno = tfno;
    _email = email;
  }

  ///Getters and setters
  get idEntity => _idEntity;
  String get name => _name;
  String get info => _info;
  set idEntity(dynamic id) => _idEntity =id;
  EntityType get type => _type;
  set name(name) => _name = name;
  set info(info) => _info = info;
  get email => _email;
  set email(String email) => _email = email;
  get tfno => _tfno;
  set tfno(String tfno) => _tfno = tfno;
  get img => _img;
  set img(String img) => _img = img;



  ///Add an object to a group or to a user.
  Future addObject(String name, int amount,{var context});
  ///Update info for the user ----> only for the actual user UserSingleton.user!!
  Future updateInfo({var context});
  ///To get the actual objects of the user
  Future<List<Obj>> getObjects({var context});
  ///Get the actual petitions of a user
  Future<List<Obj>> getRequests({var context});
  Future<List<Obj>> getLoans({var context});
  Future<List<Obj>> getReturns({var context});
  Future<List<Obj>> getClaims({var context});
  Future<List<Obj>> getLents({var context});


}

class User extends Entity{
  int idMember;
  ///You may need the email and the idMember (if you are searching for a group)
  User(String idEntity, String name, {this.idMember,String email,String tfno,String info, String img}) : 
  super(EntityType.USER, idEntity, name, tfno : tfno, info : info, img : img, email : email);

  @override
  Future addObject(String name, int amount,{String info,File img, var context}) async{

     await new RequestPost("createObject").dataBuilder(
        //userInfo: true,
        name: name,
        info: info,
        img: img,
    ).doRequest(context: context, errorHandler: new ErrorToast());
    
  }

  ///This is a Future<List<Obj>> , to get the list must use await otherwise it will return a Future!
  @override
  Future<List<Obj>> getObjects({var context}) async{
    ResponsePost res = await new RequestPost("getObjectsByUser_v2").dataBuilder(
        userInfo: true,
    ).doRequest(context: context);
    //return res.objectsBuilder(entity: this);
    return null;
  }

  
  @override 
  Future updateInfo({String nickName , String info,String email, String tfno, File img, var context}) async {
    var l = fieldNameFieldValue(nickName: nickName, email: email, tfno: tfno, info: info);
    ResponsePost res = await new RequestPost("updateUser").dataBuilder(
      userInfo: true,
      fieldname: l[0],
      fieldValue: l[1],
      img: img

    ).doRequest(context: context);
  }

  Future createGroup({String groupName, String info, String email, String tfno, bool autoloan = false, bool private = false, File img, var context}) async{
    ResponsePost res = await new RequestPost("createGroup").dataBuilder(
      userInfo: true,
      groupName: groupName,
      info: info,
      email : email,
      autoLoan: autoloan,
      private: private,
      tfno: tfno,
      img: img
    ).doRequest(context: context);
  }

  Future joinGroup(Group group, {var context}) async{
    ResponsePost res = await new RequestPost("joinRequest").dataBuilder(
      userInfo: true,
      idGroup: group.idEntity,
    ).doRequest(context: context);
  }

  Future<List<String>> getNotTopics({var context}) async{
    ResponsePost res = await new RequestPost("getAsociatedGroups").dataBuilder(
      userInfo: true,
    ).doRequest(context: context);
    print(res.topicsBuilder());
    return res.topicsBuilder();
  }


  @override
  Future<List<UserObject>> getRequests({var context}) async {
    ResponsePost res = await new RequestPost("getRequestedObjects").dataBuilder(
      userInfo: true,
    ).doRequest(context:context);
    return res.objectsUserBuilder(stateType: "requested");
  }

  @override
  Future<List<Obj>> getClaims({var context}) async{
    ResponsePost res = await new RequestPost("getClaimsByUser").dataBuilder(
      userInfo: true,
    ).doRequest(context:context);
    return res.objectsUserBuilder(stateType: "claims");
  }

  @override
  Future<List<Obj>> getLoans({var context}) {
    // TODO: implement getLoans
    return null;
  }

  @override
  Future<List<Obj>> getReturns({var context}) {
    // TODO: implement getReturns
    return null;
  }

  @override
  Future<List<Obj>> getLents({context}) {
    // TODO: implement getLents
    return null;
  }


  Future<List<Obj>> getMyRequests({var context}) async{
     ResponsePost res = await new RequestPost("getObjectsRequestedByUser").dataBuilder(
      userInfo: true,
    ).doRequest(context:context);
    return res.objectsUserBuilder(stateType :"requested", mine: true);
  }
  

  Future<List<Obj>> getMyClaims({var context}) async{
     ResponsePost res = await new RequestPost("getClaimsToUser").dataBuilder(
      userInfo: true,
    ).doRequest(context:context);
   return res.objectsUserBuilder(stateType :"claimed", mine: true);
  }


}

class Group extends Entity{

  bool _private;
  bool _autoloan; 
  Group(int idEntity, String name,{String email,String tfno,String info, String img,bool private = false, bool autoloan = false}) 
  : super(EntityType.GROUP, idEntity.toString(), name,tfno : tfno, info : info, img : img, email : email){
    _private = private;
    _autoloan = autoloan;
  }

  get private => _private;
  set private(bool private) => private;

  get autoloan => _autoloan; 
  set autoloan(bool autoloan) => _autoloan;


  @override
  Future addObject(String name, int amount,{var context}) {
    new RequestPost("createGObject").dataBuilder(
        idGroup: this.idEntity,
        userInfo: true,
 ///TODO Poner el id del actual usuario
        name: name 
    ).doRequest(context: context);
  }

  @override
  Future<List<Obj>> getRequests({var context}) {
    // TODO: implement getRequest
  }

  ///TODO Falta
  Future addUser(Entity newUser) async{
    //  ResponsePost res = await new RequestPost("upgradeToAdmin").dataBuilder(
    //    userInfo: true,
    //context: context,
    //    idMemeber: u.idEntity,
    //    idGroup: this.idEntity,
    // ).doRequest(context: context);
  }

  Future delUser({User u}){

  }

  Future addAdmin(User u,{var context}) async{
    ResponsePost res = await new RequestPost("upgradeToAdmin").dataBuilder(
      userInfo: true,
//UserSingleton.singleton.user.idEntity,
      idMemeber: u.idMember,
      idGroup: this.idEntity,
    ).doRequest(context: context);
  }

  Future delGroup({var context}) async{
    ResponsePost res = await new RequestPost("deleteGroup").dataBuilder(
      userInfo: true,
//UserSingleton.singleton.user.idEntity,
      idGroup: this.idEntity,
    ).doRequest(context: context);
  }


///Method to obtain all the user of the group
  void getUsers(){

  }

  @override
  Future updateInfo({String groupName, bool private, bool autoloan, String email, String tfno, String info, File img, var context}) async {
    
    var l = fieldNameFieldValue(groupName: groupName,autoloan: autoloan,private: private, email: email, tfno: tfno, info: info);

    ResponsePost res = await new RequestPost("updateGroup").dataBuilder(
      userInfo: true,
      idGroup: this.idEntity,
      fieldname: l[0],
      fieldValue: l[1],
      img: img
    ).doRequest(context: context);
  }

  @override
  Future<List<Obj>> getObjects({var context}) async{
    ///TODO change link 
    ResponsePost res = await new RequestPost("getObjectsByUser").dataBuilder(
        idGroup: this.idEntity,
    ).doRequest(context: context);
    //return res.objectsBuilder(entity : this);
    return null;
  }

  @override
  Future<List<Obj>> getClaims({var context}) {
    // TODO: implement getClaims
    return null;
  }

  @override
  Future<List<Obj>> getLoans({var context}) {
    // TODO: implement getLoans
    return null;
  }

  @override
  Future<List<Obj>> getReturns({var context}) {
    // TODO: implement getReturns
    return null;
  }

  @override
  Future<List<Obj>> getLents({context}) {
    // TODO: implement getLents
    return null;
  }
}



  enum EntityType {
    USER, GROUP, Default
  }