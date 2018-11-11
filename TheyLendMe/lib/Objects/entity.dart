import 'package:TheyLendMe/Objects/joinRequest.dart';
import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
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
  Future<List<Obj>> getClaims({var context});
  Future<List<Obj>> getMyClaims({var context});
  Future<List<Obj>> getMyLoans({var context});
  Future<List<Obj>> getMyRequests({var context});
}
class User extends Entity{
  int idMember;
  bool admin = false;
  ///You may need the email and the idMember (if you are searching for a group)
  User(String idEntity, String name, {this.idMember,String email,String tfno,String info, String img, this.admin}) : 
  super(EntityType.USER, idEntity, name, tfno : tfno, info : info, img : img, email : email,);
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

  ///Request de objetos
  @override
  Future<List<UserObject>> getRequests({var context}) async {
    ResponsePost res = await new RequestPost("getUserRequests").dataBuilder(
      userInfo: true,
    ).doRequest(context:context);
    return res.requestsUserObjectBuilder(mine : false);
  }
  @override
  Future<List<Obj>> getClaims({var context}) async{
    ResponsePost res = await new RequestPost("getUserClaims").dataBuilder(
      userInfo: true,
    ).doRequest(context:context);
    return res.claimsUserObjectBuilder(mine : true);
  }
  @override
  Future<List<Obj>> getLoans({var context}) async{
    ResponsePost res = await new RequestPost("getUserLoans").dataBuilder(
      userInfo: true,
    ).doRequest(context:context);
    return res.loansUserObjectBuilder(mine : true);
  }
  @override
  Future<List<Obj>> getMyRequests({var context}) async{
    ResponsePost res = await new RequestPost("getUserRequests").dataBuilder(
      userInfo: true,
    ).doRequest(context:context);
    return res.requestsUserObjectBuilder(mine : true);
  }
  @override
  Future<List<Obj>> getMyClaims({var context}) async{
    ResponsePost res = await new RequestPost("getUserClaims").dataBuilder(
      userInfo: true,
    ).doRequest(context:context);
    return res.claimsUserObjectBuilder(mine : false);
  }
  @override
  Future<List<Obj>> getMyLoans({var context}) async{
    ResponsePost res = await new RequestPost("getUserLoans").dataBuilder(
      userInfo: true,
    ).doRequest(context:context);
    return res.loansUserObjectBuilder(mine : false);
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
  Future addObject(String name, int amount,{var context}) async{
    await new RequestPost("createGObject").dataBuilder(
        idGroup: this.idEntity,
        userInfo: true,
        name: name 
    ).doRequest(context: context);
  }

  Future addAdmin(User u,{var context}) async{
    ResponsePost res = await new RequestPost("upgradeToAdmin").dataBuilder(
      userInfo: true,
      idMemeber: u.idMember,
      idGroup: this.idEntity,
    ).doRequest(context: context);
  }

  Future delGroup({var context}) async{
    ResponsePost res = await new RequestPost("deleteGroup").dataBuilder(
      userInfo: true,
      idGroup: this.idEntity,
    ).doRequest(context: context);
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

  Future<List<JoinRequest>> getJoinRequest({var context})async {
    ResponsePost response = await new RequestPost("getJoinRequests").dataBuilder(
        idGroup: this.idEntity,
        userInfo: true,
        name: name 
    ).doRequest(context: context);
    return response.joinRequestsBuilder(this);
  }

  Future<List<User>> getGroupMembers({var context}) async{
    ResponsePost response = await new RequestPost("getGroupMembers").dataBuilder(
        idGroup: this.idEntity,
        userInfo: true,
        name: name 
    ).doRequest(context: context);
    return response.groupMembersBuilder();
  }

  ///Peticiones de objetos
  @override
  Future<List<Obj>> getObjects({var context}) async{
    ResponsePost res = await new RequestPost("getGroupObjects").dataBuilder(
        idGroup: this.idEntity,
        userInfo: true
    ).doRequest(context: context);
    return res.groupObjectsBuilder(group: this);
  }
  @override
  Future<List<GroupObject>> getRequests({var context}) async{
    ResponsePost responsePost =await new RequestPost("getGroupRequests").dataBuilder(
        idGroup: this.idEntity,
        userInfo: true,
    ).doRequest(context: context);
    return responsePost.requestsGroupObjectBuilder(this, mine: false);
  }
  ///Las que he hecho
  Future<List<GroupObject>> getMyRequests({var context}) async{
    ResponsePost responsePost =await new RequestPost("getGroupRequests").dataBuilder(
        idGroup: this.idEntity,
        userInfo: true,
    ).doRequest(context: context);
    return responsePost.requestsGroupObjectBuilder(this, mine: true);
  }
  @override
  Future<List<GroupObject>> getLoans({var context}) async{
    ResponsePost res = await new RequestPost("getGroupLoans").dataBuilder(
      userInfo: true,
      idGroup: this._idEntity,
    ).doRequest(context:context);
    return res.loansGroupObjectBuilder(this,mine : true);
  }
  @override
  Future<List<GroupObject>> getMyLoans({var context}) async{
    ResponsePost res = await new RequestPost("getGroupLoans").dataBuilder(
      userInfo: true,
      idGroup: this._idEntity,
    ).doRequest(context:context);
    return res.loansGroupObjectBuilder(this,mine : false);
  }
  @override
  Future<List<GroupObject>> getClaims({var context}) async{
    ResponsePost res = await new RequestPost("getGroupClaims").dataBuilder(
      userInfo: true,
      idGroup: this._idEntity,
    ).doRequest(context:context);
    return res.claimsGroupObjectBuilder(this,mine : true);
  }

  @override
  Future<List<GroupObject>> getMyClaims({var context}) async{
    ResponsePost res = await new RequestPost("getGroupClaims").dataBuilder(
      userInfo: true,
      idGroup: this._idEntity,
    ).doRequest(context:context);
    return res.claimsGroupObjectBuilder(this,mine : false);
  }

  Future<List<User>> getMembers()async{}
  Future addUser(Entity newUser) async{}
  Future delUser({User u}) async{}




}



  enum EntityType {USER, GROUP, Default}