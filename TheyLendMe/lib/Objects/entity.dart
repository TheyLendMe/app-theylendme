import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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
  get email => email;
  set email(String email) => _email = email;
  get tfno => tfno;
  set tfno(String tfno) => _tfno = tfno;
  get img => img;
  set img(String img) => _img = img;



  ///Add an object to a group or to a user.
  Future addObject(String name, int amount);
  ///Update info for the user ----> only for the actual user UserSingleton.user!!
  Future updateInfo();
  ///To get the actual objects of the user
  Future<List<Obj>> getObjects();
  ///Get the actual petitions of a user
  Future getRequest();
  Future getLoans();
  Future getReturns();
  Future getClaims();

}

class User extends Entity{
  int idMember;
  ///You may need the email and the idMember (if you are searching for a group)
  User(String idEntity, String name, {this.idMember,String email,String tfno,String info, String img}) : 
  super(EntityType.USER, idEntity, name, tfno : tfno, info : info, img : img, email : email);

  @override
  Future addObject(String name, int amount) async{
     await new RequestPost("createObject").dataBuilder(
        userInfo: true,
        name: name 
    ).doRequest();
    
  }

  ///This is a Future<List<Obj>> , to get the list must use await otherwise it will return a Future!
  @override
  Future<List<Obj>> getObjects() async{
    ResponsePost res = await new RequestPost("getObjectsByUser_v2").dataBuilder(
        userInfo: true,
    ).doRequest();
    return res.objectsBuilder(entity: this);
  }

  @override
  Future getRequest() {
    // TODO: implement getRequest
  }
  
  @override 
  Future updateInfo({String nickName , String info,String email, String tfno}) async {
    var l = fieldNameFieldValue(nickName: nickName, email: email, tfno: tfno, info: info);
    ResponsePost res = await new RequestPost("updateUser").dataBuilder(
      userInfo: true,
      fieldname: l[0],
      fieldValue: l[1]
    ).doRequest();
  }

  Future createGroup({String groupName, String info, String email, String tfno, bool autoloan = false, bool private = false}) async{
    ResponsePost res = await new RequestPost("createGroup").dataBuilder(
      userInfo: true,
      groupName: groupName,
      info: info,
      email : email,
      autoLoan: autoloan,
      private: private,
      tfno: tfno
    ).doRequest();
  }

  Future joinGroup(Group group) async{
    ResponsePost res = await new RequestPost("createGroup").dataBuilder(
      userInfo: true,
      idGroup: group.idEntity,
    ).doRequest();
  }

  Future<List<String>> getNotTopics() async{
    ResponsePost res = await new RequestPost("getAsociatedGroups").dataBuilder(
      userInfo: true,
    ).doRequest();
    print(res.topicsBuilder());
    return res.topicsBuilder();
  }



  @override
  Future getClaims() {
    // TODO: implement getClaims
    return null;
  }

  @override
  Future getLoans() {
    // TODO: implement getLoans
    return null;
  }

  @override
  Future getReturns() {
    // TODO: implement getReturns
    return null;
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

  /// idGroup, idUser(admin), [name, imagen, amount]

  @override
  Future addObject(String name, int amount) {
    new RequestPost("createGObject").dataBuilder(
        idGroup: this.idEntity,
        userInfo: true, ///TODO Poner el id del actual usuario
        name: name 
    ).doRequest();
  }

  @override
  Future getRequest() {
    // TODO: implement getRequest
  }

  ///TODO Falta
  Future addUser(Entity newUser) async{
    //  ResponsePost res = await new RequestPost("upgradeToAdmin").dataBuilder(
    //    userInfo: true,
    //    idMemeber: u.idEntity,
    //    idGroup: this.idEntity,
    // ).doRequest();
  }

  Future delUser({User u}){

  }

  Future addAdmin(User u) async{
    ResponsePost res = await new RequestPost("upgradeToAdmin").dataBuilder(
      userInfo: true,//UserSingleton.singleton.user.idEntity,
      idMemeber: u.idMember,
      idGroup: this.idEntity,
    ).doRequest();
  }

  Future delGroup() async{
    ResponsePost res = await new RequestPost("deleteGroup").dataBuilder(
      userInfo: true,//UserSingleton.singleton.user.idEntity,
      idGroup: this.idEntity,
    ).doRequest();
  }


///Method to obtain all the user of the group
  void getUsers(){

  }

  @override
  Future updateInfo({String groupName, bool private, bool autoloan, String email, String tfno, String info}) async {
    
    var l = fieldNameFieldValue(groupName: groupName,autoloan: autoloan,private: private, email: email, tfno: tfno, info: info);

    ResponsePost res = await new RequestPost("updateGroup").dataBuilder(
      userInfo: true,
      idGroup: this.idEntity,
      fieldname: l[0],
      fieldValue: l[1]
    ).doRequest();
  }

  @override
  Future<List<Obj>> getObjects() async{
    ///TODO change link 
    ResponsePost res = await new RequestPost("getObjectsByUser").dataBuilder(
        idGroup: this.idEntity,
    ).doRequest();
    return res.objectsBuilder(entity : this);
  }

  @override
  Future getClaims() {
    // TODO: implement getClaims
    return null;
  }

  @override
  Future getLoans() {
    // TODO: implement getLoans
    return null;
  }

  @override
  Future getReturns() {
    // TODO: implement getReturns
    return null;
  }
}



  enum EntityType {
    USER, GROUP, Default
  }