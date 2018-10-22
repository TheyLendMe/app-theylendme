import 'package:TheyLendMe/Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

abstract class Entity{
  ///TODO Poner final
  dynamic _idEntity;
  final EntityType _type;
  String _name,_info,_img;

  


  Entity(this._type,this._idEntity,this._name,{String info ="",String img =""}){

  }


  ///Getters and setters
  get idEntity => _idEntity;
  String get name => _name;
  String get info => _info;

  set idEntity(dynamic id) => _idEntity =id;

  EntityType get type => _type;


  set name(name) => _name = name;
  set info(info) => _info = info;


  ///Other functions
  ///
  

  ///Add an object to a group or to a user.
  Future addObject(String name, int amount);





  Future updateInfo();


////INFOOOOOOOOOOOOOOO
  Future<List<Obj>> getObjects();
  Future getRequest();

}



class User extends Entity{

  String userEmail;
  String tfno;

  int idMember;

  User(String idEntity, String name, {this.userEmail,this.idMember}) : super(EntityType.USER, idEntity, name);

  @override
  Future addObject(String name, int amount) {
     new RequestPost("createObject").dataBuilder(
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



///TODO falta probar
  @override
  Future updateInfo({String nickName , String info,String email, String tfno}) async {
    

    var l = fieldNameFieldValue(nickName: nickName, email: email, tfno: tfno, info: info);

    ResponsePost res = await new RequestPost("updateUser").dataBuilder(
      userInfo: true,
      fieldname: l[0],
      fieldValue: l[1]
    ).doRequest();
  }

  Future createGroup({String groupName, String info, String email, String tfno}) async{
    ResponsePost res = await new RequestPost("createGroup").dataBuilder(
      userInfo: true,
      groupName: groupName,
      info: info,
      email : email,
      tfno: tfno
    ).doRequest();
  }

  Future joinGroup(Group group) async{
    ResponsePost res = await new RequestPost("createGroup").dataBuilder(
      userInfo: true,
      idGroup: group.idEntity,
    ).doRequest();
  }

  get email => userEmail;



}

class Group extends Entity{
  Group(int idEntity, String name) : super(EntityType.GROUP, idEntity.toString(), name);


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
}



  enum EntityType {
    USER, GROUP, Default
  }