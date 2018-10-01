abstract class Entity{
  final String _idEntity;
  final EntityType _type;
  String _name,_desc,_img;
  


  Entity(this._type,this._idEntity,this._name,{String desc,String img}){

  }


  ///Getters and settes
  String get idEntity => _idEntity;
  String get name => _name;
  String get desc => desc;

  EntityType get type => _type;


  set name(name) => _name = name;
  set desc(desc) => _desc = desc;


  ///Other functions
  ///
  

  ///Add an object to a group or to a user.
  void addObject();

  void delObject();

  void getObjects();

  void getRequest();

  ///TODO valdra solo con getRequest
  void getBringBack();

  void get();



}



class User extends Entity{
  User(String idEntity, String name) : super(EntityType.USER, idEntity, name);

  @override
  void addObject() {
    // TODO: implement addObject
  }

  @override
  void delObject() {
    // TODO: implement delObject
  }

  @override
  void getObjects() {
    // TODO: implement getObjects
  }

  @override
  void get() {
    // TODO: implement get
  }

  @override
  void getBringBack() {
    // TODO: implement getBringBack
  }

  @override
  void getRequest() {
    // TODO: implement getRequest
  }




}

class Group extends Entity{
  Group(EntityType type, String idEntity, String name) : super(EntityType.GROUP, idEntity, name);

  @override
  void addObject() {
    // TODO: implement addObject
  }

  @override
  void delObject() {
    // TODO: implement delObject
  }

  
  @override
  void getObjects() {
    // TODO: implement getObjects
  }

  @override
  void get() {
    // TODO: implement get
  }

  @override
  void getBringBack() {
    // TODO: implement getBringBack
  }

  @override
  void getRequest() {
    // TODO: implement getRequest
  }


  void addUser(){

  }

  void delUser({User u}){
  
  }

  void addAdmin({User u}){
  }


///Method to obtain all the user of the group
  void getUser(){

  }


  

}



  enum EntityType {
    USER, GROUP, Default
  }