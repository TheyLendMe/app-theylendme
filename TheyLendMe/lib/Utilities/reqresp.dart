
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:TheyLendMe/Utilities/errorHandler.dart';
import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/joinRequest.dart';
import 'package:TheyLendMe/Objects/objState.dart';

const String endpoint = "http://18.234.140.97/app/";
//const String endpoint ="http://10.0.2.2/";



class RequestPost{

  String _url;
  Map<String, dynamic> _data;
  Dio dio = new Dio();
  bool userInfo = false;


  RequestPost(String fun){
    _url = fun;

    dio.options.baseUrl=endpoint;
    dio.options.connectTimeout = 500000; //5s
    dio.options.receiveTimeout=15000;  

    _data = new Map();
  
  }


  Future<ResponsePost> doRequest({var context, ErrorHandler errorHandler}) async{

    ///TODO implementar un manejador de errores si deja de haber conexion
    ///Si el 
    try{
      if(userInfo){
          Map<String,dynamic> m = await authInfo();
          this._data.addAll(m);
      }
      return await ResponsePost.responseBuilder(await dio.post(_url,data: new FormData.from(_data)));
      
    }on StatusException catch(e){
      new ErrorToast().handleError(msg : e.errMsg);
      return null;
    }on AuthException catch(e){
      new ErrorAuth(context).handleError();
    
    }on ServerException catch(e){
      errorHandler.handleError(msg : e.errMsg);
      return null;
    }on Exception catch(e){
      new ErrorToast().handleError(msg : e.toString());
      return null;
    }
    


  }


///This will be the builder that
 RequestPost dataBuilder({String idUser,dynamic idGroup, int idObject, 
  String name, String desc,String info, String email, String tfno,String nickName,

  int idLoan, int idRequest, int idClaim, int amount,List fieldname,List fieldValue,
  String oUser, String msg, File img, String claimMsg, String groupName, bool autoLoan,
  bool private, int idMemeber, String requestMsg, bool userInfo = false, String privateCode//add more fields if they are necessary
  }){
    this.userInfo = userInfo;
    if(img != null){ _data['image'] = new UploadFileInfo(img, basename(img.path));}
    if(idUser != null && !userInfo)_data['idGroup'] = idGroup.toString();
    if(idGroup != null)_data['idGroup'] = idGroup.toString();
    if(idObject != null)_data['idObject'] = idObject.toString();
    if(name != null)_data['name'] = name;
    if(desc != null)_data['desc'] = desc;
    if(idLoan != null) _data['idLoan'] = idLoan.toString();
    if(idRequest != null) _data['idRequest'] = idRequest.toString();
    if(idClaim != null) _data['idClaim'] = idClaim.toString();
    if(amount != null) _data['amount'] = amount.toString();
    if(requestMsg != null) _data['request'] = requestMsg;
    if(privateCode != null) _data['privateCode'] = privateCode;
    ///In case we need to pass other user ---> oUser
    if(oUser != null) _data['oUser'] = oUser;
    if(msg != null) _data['msg'] = msg;
    if(claimMsg != null) _data['claimMsg'] = claimMsg;
    if(fieldname != null) {_data['fieldName'] = [fieldname]; _data ['fieldValue'] = [fieldValue];} else{
        _data['fieldName'] =['null'];
        _data['fieldValue'] =['null'];
    }
    if(info != null){_data['info'] = info;}
    if(email != null){_data['email']=email;}
    if(tfno != null){_data['tfno'] = tfno;}
    if(groupName != null) {_data['groupName'] = groupName;}
    if(autoLoan != null){_data['autoloan'] = autoLoan ? 1 : 0;}
    if(private != null)_data['private'] = private ? 1 : 0;
    if(idMemeber != null)_data['idMember'] = idMemeber;

    return this;
  }

  Future<Map<String,dynamic>> authInfo() async{
    FirebaseUser firebaseUser = await UserSingleton().firebaseUser;
    if(firebaseUser == null){throw new AuthException("1", "not loged");}
    UserSingleton user = await UserSingleton();
    Map<String,dynamic> m = new Map();
    m['idUser']= UserSingleton().user.idEntity;
    m['token'] = await firebaseUser.getIdToken();
    m['nickname'] = UserSingleton().user.name;
    m['email'] = firebaseUser.email;
    m['tfno'] = firebaseUser.phoneNumber;
    return m;
  }
}
 /* if(nickName != null){fieldName[i] = 'nickname'; fieldValue[i]=nickName; i++;}
  if(email != null){fieldName[i]='email';fieldValue[i]= (email); i++;}
  if(info != null){fieldName[i]=('info');fieldValue[i]=(info); i++;}
  if(tfno != null){fieldName[i]=('tfno');fieldValue[i]=(tfno);i++;}*/
List<dynamic> fieldNameFieldValue({String nickName,String email, String info, String tfno, int amount, 
String name, String groupName, bool private, bool autoloan}){
    List fieldName = new List();
    List fieldValue = new List();
    List<dynamic> r = new List();
    r.add(fieldName);
    r.add(fieldValue);
    if(nickName != null){fieldName.add('nickname'); fieldValue.add(nickName);}
    if(groupName != null){fieldName.add('groupName'); fieldValue.add(groupName);}
    if(amount != null){fieldName.add('amount'); fieldValue.add(amount);}
    if(private != null){fieldName.add('private'); fieldValue.add(private ? 0 : 1);}
    if(autoloan != null){fieldName.add('autoloan'); fieldValue.add(autoloan ? 0 : 1);}
    if(name != null){fieldName.add('name'); fieldValue.add(name);}
    if(email != null){fieldName.add('email');fieldValue.add(email);}
    if(info != null){fieldName.add('info');fieldValue.add(info);}
    if(tfno != null){fieldName.add('tfno');fieldValue.add(tfno);}
    if(fieldName.length == 0){r.clear(); r.add(null); r.add(null);}
    return r;
}
class ResponsePost{
  ///Builder that allow the app to create the Respnse object asynchronously, we need this, because byteToString
  ///returns a Future!
  static Future<ResponsePost> responseBuilder(Response response) async{
    ///In case of server error like 404 not found... this 
    print(response.request.baseUrl+response.request.path);
    print(response.data);
    if(response.statusCode != 200 ) throw new StatusException("Ha habido un error con el servidor", response.statusCode);
    return new ResponsePost(response.data);
  }
  dynamic _data;
  int _responseType;
  ResponsePost(data){
 
    if(data['error'] != null && data['error'] ) { 
      if(data['errorCode'] == 1) throw new AuthException(data["errorMsg"], data["errorCode"]);

      throw new ServerException(data["errorMsg"], data["errorCode"]);

    }
    this._data = data['responseData'];
    this._responseType = data['responseType'];
  }
  dynamic get data => _data;
////-----------Objects builders------------//////////



  List<Obj> objectsUserBuilder({Entity entity,String stateType, bool mine = false}){
    List<Obj> obj = new List();
    if(_responseType == 4){
      
      ///Obtenemos el estado que se le va a dar a cada uno de los objetos
      if (stateType == null){
        obj.addAll(defaultObjects(_data['UsersObjects'], ObjType.USER_OBJECT));
        obj.addAll(defaultObjects(_data['GroupsObjects'], ObjType.GROUP_OBJECT));
      }else{
        List<dynamic> objects = _data;
        StateOfObject stateOfObject = ObjState.getObjState(stateType);
        if(stateOfObject == StateOfObject.REQUESTED){objects.forEach((element) => obj.addAll(!mine ? requestObjects(element) : myRequestsObjects(element)));}
        if(stateOfObject == StateOfObject.CLAIMED){objects.forEach((element) =>obj.addAll(requestObjects(element)));}
      }
    }

    if(_responseType == 3){

    }
    return obj;
  }

  List<Obj> defaultObjects(List<dynamic> objects, ObjType objType){
    List<Obj> objs = new List();
    objects.forEach((object){
      Obj obj;
      obj = objType == ObjType.USER_OBJECT ? 
      ///Pedir a victor que incluyaa nombres de los owners
        new UserObject(
          int.parse(object['idObject']),
          new User(object['idUser'], "prueba"),
          object['name'],
          image : object['imagen'],
          amount :int.parse(object['amount']),
          //TODO incluir fecha 
        ) : 
        new GroupObject(
          int.parse(object['idObject']),
          new Group(int.parse(object['idGroup']), "pruebaGrupo"),
          object['name'],
          image : object['imagen'],
          amount : int.parse(object['amount']),
          //TODO incluir fecha 
        );
      objs.add(obj);
    });
    return objs;
      
  }


///TODO falta incluir el date
  List<Obj> requestObjects(Map<String,dynamic> requestsInfo){
    StateOfObject stateOfObject = StateOfObject.REQUESTED;
      List<Obj> list = new List();
      List<dynamic> states = requestsInfo["requests"];
      states.forEach((stateInfo){
        Entity actual =  UserSingleton().user;
        Entity next =  User(stateInfo['idUser'], stateInfo['requesterNickName']);
        ObjState state = new ObjState(
          actual: actual,
          next: next,
          id: stateInfo['id'],
          state: stateOfObject,
            
        );
        list.add(new UserObject(
          int.parse(requestsInfo['idObject']),
          actual,
          requestsInfo['name'],
          objState: state
        ));

      });
      return list;
  }

  List<Obj> myRequestsObjects(Map<String,dynamic> request){
    List<Obj> list = new List();
    Map<String,dynamic> objInfo = request['objectData'];
    list.add(new UserObject(
      int.parse(objInfo['idObject']), 
      new User(objInfo['owner_id'],objInfo['owner_nickname']), 
      objInfo['name'],
      image: objInfo['imagen'],
      objState: new ObjState(
        actual: new User(objInfo['owner_id'],objInfo['owner_nickname']),
        next: UserSingleton().user,
        id: int.parse(request['idRequest']),
        state: StateOfObject.REQUESTED
        )
    ));
    return list;
  }

  List<Obj> claimstObjects(Map<String,dynamic> requestsInfo){
      StateOfObject stateOfObject = StateOfObject.CLAIMED;
      List<Obj> list = new List();
      List<dynamic> states = requestsInfo["claims"];
      states.forEach((stateInfo){
        Entity actual =  User(stateInfo['idUser'], stateInfo['owner']);
        Entity next =  UserSingleton().user;
        ObjState state = new ObjState(
          actual: actual,
          next: next,
          id: stateInfo['idClaim'],
          state: stateOfObject,
            
        );
        list.add(new UserObject(
          int.parse(requestsInfo['idObject']),
          actual,
          requestsInfo['name']
        ));

      });
      return list;
  }


    
  List<Obj> myClaimstObjects(Map<String,dynamic> request){
    List<Obj> list = new List();
    Map<String,dynamic> objInfo = request['objectData'];
    Map<String,dynamic> loanData = request['loanData'];
    list.add(new UserObject(
      int.parse(objInfo['idObject']), 
      new User(objInfo['idUser'],objInfo['owner_name']), 
      objInfo['name'],
      image: objInfo['imagen'],
      objState: new ObjState(
        actual: UserSingleton().user,
        next: new User(objInfo['idUser'],objInfo['owner_nickname']),
        id: int.parse(request['idClaim']),
        msg: request['claimMsg'],
        state: StateOfObject.CLAIMED
        )
    ));
    return list;
  }

  List<GroupObject> groupObjectsBuilder({Group group, ObjState objState}){
    List<dynamic> list = _data;
    List<GroupObject> obs = new List();
    list.forEach((object){obs.add(objectBuilder(
        data:object, 
        forUser: false, 
        group: group, 
        objState: 
        objState))
      ;});
    return obs;
    
  }
  Obj objectBuilder({Map<String, dynamic> data, bool forUser = true,ObjState objState ,Group group, User user}){
      data = data == null ? _data : data;
      return forUser ? 
        new UserObject(
          int.parse(data['idObject']), 
          data['owner'] != null ? userBuilder(data :data['owner']) : UserSingleton().user, 
          data['name'],
          amount: int.parse(data['amount']),
          image : data['imagen'],
          objState: objState
          ) 
          : 
        new GroupObject(
          int.parse(data['idObject']), 
          group,
           //TODO decirle a victor que me incluya todo el grupo
          data['name'],
          image : data['imagen'],
          amount: int.parse(data['amount']),
          objState: objState
        );

  } 

  List<JoinRequest> joinRequestsBuilder(Group group){
    List<dynamic> list = _data;
    List<JoinRequest> joinRequests = new List();
    list.forEach((request){
      joinRequests.add(joinRequestBuilder(group,data : request));
    });
    return joinRequests;
  }
  JoinRequest joinRequestBuilder(Group group,{Map<String, dynamic> data}){
    data = data == null ? _data : data;
    User user = userBuilder(data : data['user']);
    return new JoinRequest(int.parse(data['idRequest']), group, user);
  }

  List<User> groupMembersBuilder(){
    List<dynamic> list = _data;
    List<User> u = new List();
    list.forEach((userInfo){
      u.add((userBuilder(
        data : userInfo['user'], 
        admin: userInfo['admin'] == "1",
        idMember: int.parse(userInfo['admin'])
        ))
      );
    });
    return u;
  }
  User userBuilder({Map<String, dynamic> data,int idMember, bool admin}){
    if(data == null){return null;}
    data = data == null ? _data : data;
    return new User(
      data['idUser'], 
      data['nickname'],
      email: data['email'],
      tfno: data['tfno'],
      info: data['info'],
      idMember: idMember,
      admin: admin);
  }

  Group groupBuilder({Map<String, dynamic> data, bool imAdmin = false}){
    if(data == null){return null;}
    data = data == null ? _data : data;
    return new Group(
      int.parse(data['idGroup']), 
      data['groupName'],
      email: data['email'],
      tfno: data['tfno'],
      info: data['info'],
      autoloan:  "1" == data['autoloan'],
      private: "1" == data['private'],
      imAdmin: true,
    );
  }
  List<Group> myGroupsBuilder(){
    List<dynamic> listAdmin = _data['admin'];
    List<dynamic> listMember = _data['admin'];
    List<Group> listGroup = new List();
    listAdmin.forEach((group){listGroup.add(groupBuilder(data : group, imAdmin: true));});
    listMember.forEach((group){listGroup.add(groupBuilder(data : group));});
    return listGroup;
  }

  List<Group> myRequestedGroupsBuilder(){
    List<dynamic> listRequested = _data['request'];
    List<Group> listGroup = new List();
    listRequested.forEach((group){listGroup.add(groupBuilder(data : group));});
    return listGroup;
  }

  List<UserObject> requestsUserObjectBuilder({bool mine = null}){
    if(mine == null){
      List<UserObject> list = new List();
      list.addAll(_requestsUserObjectBuilder(_data['toUser']));
      list.addAll(_requestsUserObjectBuilder(_data['byUser']));
      return list;
    }else{
      return mine ? _requestsUserObjectBuilder(_data['byUser']) : _requestsUserObjectBuilder(_data['toUser']);
    }
  }

  List<UserObject> _requestsUserObjectBuilder(List<dynamic> requests){
    List<UserObject> requestsList= new List();
    requests.forEach((request){
      ObjState state = new ObjState(
        id: int.parse(request['idRequest']),
        state: StateOfObject.REQUESTED,
        amount: int.parse(request['amount']),
        msg: request['requestMsg'],
        actual: userBuilder(data : request['object']['owner']),
        next: userBuilder(data : request['requester']),
        date: request['date'],
      );
      requestsList.add(objectBuilder(data: request['object'], objState: state));
    });
    return requestsList;
  }

 
  List<GroupObject> requestsGroupObjectBuilder(Group group,{bool mine = null}){
    List<GroupObject> list = new List();
    if(mine == null) {
      list.addAll(_requestsGroupObjectBuilder(_data['intraGroup'], group: group));
      list.addAll(_requestsGroupObjectBuilder(_data['fromOthersGroups'], group: group));
      list.addAll(_requestsGroupObjectBuilder(_data['toOthersGroups'], group: group));
      list.addAll(_requestsGroupObjectBuilder(_data['fromOthersUsers'], group: group, notFromAGroup: true));
    }
    if(mine) {
      list.addAll(_requestsGroupObjectBuilder(_data['intraGroup'], group: group));
      list.addAll(_requestsGroupObjectBuilder(_data['toOthersGroups'], group: group));
    
    }
    if(!mine) {
      list.addAll(_requestsGroupObjectBuilder(_data['fromOthersGroups'], group: group));
      list.addAll(_requestsGroupObjectBuilder(_data['fromOthersUsers'], group: group, notFromAGroup: true));
    }
    return list;
  }

  List<GroupObject> _requestsGroupObjectBuilder(List<dynamic> requests, {Group group, bool notFromAGroup = false}){
    List<GroupObject> requestsList= new List();
    requests.forEach((request){
      Group groupTarget = groupBuilder(data : request['groupTarget']);
      Group requesterGroup = groupBuilder(data : request['requesterGroup']);
      GroupObjState state = new GroupObjState(
        id: int.parse(request['idRequest']),
        state: StateOfObject.REQUESTED,
        amount: int.parse(request['amount']),
        msg: request['requestMsg'],
        actual: groupTarget != null ? groupTarget  : group,
        next: requesterGroup != null ? requesterGroup  : group,
        date: request['date'],
        //actualUser:userBuilder(data : request['user']) ,
        nextUser: userBuilder(data : request['requester_user']), ///FIXME
        notFromAGroup: notFromAGroup
      );
      requestsList.add(objectBuilder(data: request['object'], objState: state, forUser: false));
    });
    return requestsList;
  }

  List<UserObject> claimsUserObjectBuilder({bool mine}){
    if(mine == null){
      List<UserObject> list = new List();
      list.addAll(_claimsUserObjectBuilder(_data['toUser']));
      list.addAll(_claimsUserObjectBuilder(_data['byUser']));
    }else{
      return mine ? _claimsUserObjectBuilder(_data['byUser']) : _claimsUserObjectBuilder(_data['toUser']);
    }
  }

  List<UserObject> _claimsUserObjectBuilder(List<dynamic> claims){
    List<UserObject> claimsList= new List();
    claims.forEach((claim){
      ObjState state = new ObjState(
        state: StateOfObject.CLAIMED,
        amount: int.parse(claim['loan']['amount']),
        msg: claim['claimMsg'],
        id: int.parse(claim['idClaim']),
        actual: userBuilder(data : claim['loan']['keeper']),
        next: userBuilder(data : claim['loan']['object']['owner']),
        fromID: int.parse(claim['loan']['idLoan'])
      );
      claimsList.add(objectBuilder(data: claim['loan']['object'], objState: state));
    });
    return claimsList;
  }



  List<GroupObject> claimsGroupObjectBuilder(Group group,{bool mine = null}){
    List<GroupObject> list = new List();
    if(mine == null) {
      list.addAll(_claimsGroupObjectBuilder(_data['intraGroup'], group: group));
      list.addAll(_claimsGroupObjectBuilder(_data['fromOthersGroups'], group: group));
      list.addAll(_claimsGroupObjectBuilder(_data['toOthersGroups'], group: group));
      list.addAll(_claimsGroupObjectBuilder(_data['fromOthersUsers'], group: group, notFromAGroup: true));
    }
    if(mine) {
      list.addAll(_claimsGroupObjectBuilder(_data['intraGroup'], group: group));
      list.addAll(_claimsGroupObjectBuilder(_data['toOthersGroups'], group: group));
      list.addAll(_claimsGroupObjectBuilder(_data['toOthersUsers'], group: group, notFromAGroup: true));
    
    }
    if(!mine) {
      list.addAll(_claimsGroupObjectBuilder(_data['fromOthersGroups'], group: group));

    }
    return list;
  }

  List<GroupObject> _claimsGroupObjectBuilder(List<dynamic> claims, {Group group, bool notFromAGroup = false}){
    List<GroupObject> claimsList = new List();
    claims.forEach((claim){
      Group claimGroup = groupBuilder(data : claim['claimingGroup']);
      Group keepGroup = groupBuilder(data : claim['keeperGroup']);
      User keepUser = userBuilder(data : claim['targetUser']);
      GroupObjState state = new GroupObjState(
        id: int.parse(claim['idClaim']),
        state: StateOfObject.CLAIMED,
       // amount: int.parse(claim['amount']),
        msg: claim['claimMsg'],
        actual: keepGroup != null ? keepGroup  : group,
        next: claimGroup != null ? claimGroup  : group,
        date: claim['claimDate'],
        //actualUser:userBuilder(data : claim['user']) ,
        actualUser: keepUser == null ? userBuilder(data : claim['keeper_user']) : keepUser,
        notFromAGroup: notFromAGroup
      );
      claimsList.add(objectBuilder(data: claim['object'], objState: state, forUser: false));
    });
    return claimsList;
  }

  List<UserObject> loansUserObjectBuilder({bool mine}){
    if(mine == null){
      List<UserObject> list = new List();
      list.addAll(_loansUserObjectBuilder(_data['toUser']));
      list.addAll(_loansUserObjectBuilder(_data['byUser']));
    }else{
      return mine ? _loansUserObjectBuilder(_data['byUser']) : _loansUserObjectBuilder(_data['toUser']);
    }
  }

  List<UserObject> _loansUserObjectBuilder(List<dynamic> loans){
    List<UserObject> loansList= new List();
    loans.forEach((loan){
      ObjState state = new ObjState(
        state: StateOfObject.LENT,
        amount: int.parse(loan['amount']),
        //date: loan['date'],
        msg: loan['loanMsg'],
        id: int.parse(loan['idLoan']),
        actual: userBuilder(data : loan['keeper']),
        next: userBuilder(data : loan['object']['owner']),
      );
      loansList.add(objectBuilder(data: loan['object'], objState: state));
    });
    return loansList;
  }
  

    List<GroupObject> loansGroupObjectBuilder(Group group,{bool mine = null}){
    List<GroupObject> list = new List();
    if(mine == null) {
      list.addAll(_loansGroupObjectBuilder(_data['intraGroup'], group: group));
      list.addAll(_loansGroupObjectBuilder(_data['fromOthersGroups'], group: group));
      list.addAll(_loansGroupObjectBuilder(_data['toOthersGroups'], group: group));
      list.addAll(_loansGroupObjectBuilder(_data['fromOthersUsers'], group: group, notFromAGroup: true));
    }
    if(mine) {
      list.addAll(_loansGroupObjectBuilder(_data['intraGroup'], group: group));
      list.addAll(_loansGroupObjectBuilder(_data['toOthersGroups'], group: group));
      list.addAll(_loansGroupObjectBuilder(_data['toOthersUsers'], group: group, notFromAGroup: true));
    
    }
    if(!mine) {
      list.addAll(_loansGroupObjectBuilder(_data['fromOthersGroups'], group: group));

    }
    return list;
  }

  List<GroupObject> _loansGroupObjectBuilder(List<dynamic> claims, {Group group, bool notFromAGroup = false}){
    List<GroupObject> loanssList = new List();
    claims.forEach((loan){
      Group ownerGroup = groupBuilder(data : loan['ownerGroup']);
      Group keepGroup = groupBuilder(data : loan['keeperGroup']);
      User keepUser = userBuilder(data : loan['targetUser']);
      GroupObjState state = new GroupObjState(
        id: int.parse(loan['idLoan']),
        state: StateOfObject.LENT,
        amount: int.parse(loan['amount']),
    
        actual: keepGroup != null ? keepGroup  : group,
        next: ownerGroup != null ? ownerGroup  : group,
        date: loan['date'],
        //actualUser:userBuilder(data : loan['user']) ,
        actualUser: keepUser == null ? userBuilder(data : loan['keeper_user']) : keepUser,
        notFromAGroup: notFromAGroup
      );
      loanssList.add(objectBuilder(data: loan['object'], objState: state, forUser: false));
    });
    return loanssList;
  }




////-------------GetTopics----------------//////////
  List<String> topicsBuilder(){
    List<dynamic> l= new List();
    
    l.addAll(_data['admin']);
    //l.addAll(_data['member']); ver si añadimos al grupo de notificaciones, el tema de si son admins o no o ver como lo hacemos.

    List<String> topics = new List();

    l.forEach((value){
      topics.add(topicBuilder(value));
    });
    return topics;
  }
  String topicBuilder(Map<String,dynamic> data){
    data = data == null ? _data as Map : data;
    return data['idGroup'];
  }


}

/// TODO Implement a exception mangager
class RequestException implements Exception{
  final String errMsg;
  final int idErr;
  RequestException(this.errMsg,this.idErr);
}

class StatusException extends RequestException{
  ///TODO define status error
  StatusException(String errMsg, int idErr) : super(errMsg, idErr);
}
class ServerException extends RequestException{
  ServerException(String errMsg, int idErr) : super(errMsg, idErr);
}
