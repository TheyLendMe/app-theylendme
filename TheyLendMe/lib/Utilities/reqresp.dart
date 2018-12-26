
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as Image;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:TheyLendMe/Utilities/errorHandler.dart';
import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/joinRequest.dart';
import 'package:TheyLendMe/Objects/objState.dart';


const String endpoint = "https://app.theylend.me/";
final DateFormat dateFormat = new DateFormat('yyyy-MM-dd');


class RequestPost{

  String _url;
  Map<String, dynamic> _data;
  Dio dio = new Dio();
  bool userInfo = false;


  RequestPost(String fun){
    _url = fun;
    dio.options.baseUrl=endpoint + "app/";
    dio.options.connectTimeout = 10000; //5s
    dio.options.receiveTimeout=3000;  
    _data = new Map();
  }
  Future<ResponsePost> doRequest({var context}) async{

    ///TODO implementar un manejador de errores si deja de haber conexion
    try{
      if(userInfo){
          Map<String,dynamic> m = await authInfo();
          this._data.addAll(m);
      }
      return ResponsePost.responseBuilder(await dio.post(_url,data: new FormData.from(_data)));
    }on StatusException catch(e){
      new ErrorToast().handleError(msg :"Connection Error", id: e.id);
      return new ResponsePost({'error' : true});
    }on AuthServer catch(e){
      new ErrorAuth(context).handleError(msg: e.errMsg, id: e.id);
      return new ResponsePost({'error' : true});
    }on PrivateServerErrorException catch(e){
      new ErrorToast().handleError(msg: "Error in Server", id: e.id);
      return new ResponsePost({'error' : true});
    }on PublicServerErrorException catch(e){
      new ErrorToast().handleError(msg: e.errMsg, id : e.id);
      return new ResponsePost({'error' : true});
    }on EmailNotVerify catch(e){
      new ErrorEmail(context).handleError(msg: e.errMsg);
      return new ResponsePost({'error' : true});
    }on Exception catch(e){
      new ErrorToast().handleError(msg : e.toString());
      return new ResponsePost({'error' : true});
    }
  }
///This will be the builder that
 RequestPost dataBuilder({String idUser,dynamic idGroup, int idObject, 
  String name, String desc,String info, String email, String tfno,String nickName,
  int idLoan, int idRequest, int idClaim, int amount,List fieldname,List fieldValue,
  String oUser, String msg, File img, String claimMsg, String groupName, bool autoLoan,
  bool private, int idMemeber, String requestMsg, bool userInfo = false, String privateCode,//add more fields if they are necessary
  Map updateValues,
  }){
    this.userInfo = userInfo;
    if(img != null){
      img = getImage(img.path);
      _data['image'] = new UploadFileInfo(img, basename(img.path))
    ;}
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
    if(updateValues != null){_data['updateRequest']= json.encode(updateValues);}
    if(privateCode != null) _data['privateCode'] = privateCode;
    ///In case we need to pass other user ---> oUser
    if(oUser != null) _data['idOtherUser'] = oUser;
    if(msg != null) _data['msg'] = msg;
    if(claimMsg != null) _data['claimMsg'] = claimMsg;
    if(nickName != null) _data['nickName'] = nickName.toString();
    if(info != null){_data['info'] = info;}
    if(email != null){_data['email']=email;}
    if(tfno != null){_data['tfno'] = tfno;}
    if(groupName != null) {_data['groupName'] = groupName;}
    if(autoLoan != null){_data['autoloan'] = autoLoan;}
    if(private != null)_data['private'] = private;
    if(idMemeber != null)_data['idMember'] = idMemeber;

    return this;
  }

  File getImage(String path){
    Image.Image image = Image.decodeImage(new File(path).readAsBytesSync());
    return new File(path+".png")..writeAsBytesSync(Image.encodePng(image));
  }
  

  Future<Map<String,String>> authInfo() async{
    FirebaseUser firebaseUser = await UserSingleton().firebaseUser;
    if(firebaseUser == null){throw new AuthServer("No estas logeado",id :0);}
    UserSingleton user = await UserSingleton();
    Map<String,String> m = new Map();
    m['idUser']= UserSingleton().user.idEntity;
    m['token'] = await firebaseUser.getIdToken();
    if(UserSingleton().user.name != null) m['nickname'] = UserSingleton().user.name;
    m['email'] = firebaseUser.email;
    m['tfno'] = firebaseUser.phoneNumber;
    return m;
  }
}

Map<String,dynamic> updateRequestBuild({String nickName,String email, String info, String tfno,String desc, int amount, 
String name, String groupName, bool private, bool autoloan}){
  Map<String,dynamic> updateRequest = new Map();
  if(nickName != null){updateRequest['nickname'] = nickName;}
  if(email != null){updateRequest['email'] = email;}
  if(info != null){updateRequest['info'] = info;}
  if(tfno != null){updateRequest['tfno'] = tfno;}
  if(amount != null){updateRequest['amount'] = amount;}
  if(name != null){updateRequest['name'] = name;}
  if(desc != null){updateRequest['desc'] = desc;}
  if(groupName != null){updateRequest['groupName'] = groupName;}
  if(private != null){updateRequest['private'] = private;}
  if(autoloan != null){updateRequest['autoloan'] = autoloan;}
  return updateRequest;
}
class ResponsePost{
  ///Builder that allow the app to create the Respnse object asynchronously, we need this, because byteToString
  ///returns a Future!
  static ResponsePost responseBuilder(Response response){
    ///In case of server error like 404 not found... this 
    print(response.request.baseUrl+response.request.path);
    print(response.data);
    if(response.statusCode != 200 ) throw new StatusException(response.statusCode);
    return new ResponsePost(response.data);
  }
  dynamic _data;
  int _responseType;
  bool _error =  false;
  ResponsePost(data){
  ///Server error
    if(data['error'] != null && data['error']) {
      _error = true;
      if(data['errorCode'] != null){
        int errorCode  = data['errorCode'];
        ///Private errors
        if(errorCode <=22){
          ///Email not verify
          if(errorCode == 16){throw new EmailNotVerify();}
          ///Auth error
          if(errorCode >= 12 && errorCode <=17 ) throw new AuthServer(data["errorMsg"], id: errorCode);
          throw new PrivateServerErrorException(errorCode,data["errorMsg"]);
        }
        if(errorCode >= 100){
          throw new PublicServerErrorException(errorCode, data['errorMsg']);
        }
      }
    }
    this._data = data['responseData'];
    this._responseType = data['responseType'];
  }
  dynamic get data => _data;
  
  bool get hasError => _error;
////-----------Objects builders------------//////////

  List<UserObject> getMyObjects(){
    List objects = _data['BYproperty'];
    List <UserObject> userObjects = new List();
    objects.forEach((object){
      userObjects.add(objectBuilder(data : object,forUser: true));
    });
    return userObjects;
  }

  List<Obj> objectsUserBuilder({Entity entity,String stateType, bool mine = false}){
    List<Obj> obj = new List();
    if(_responseType == 4){
      
      ///Obtenemos el estado que se le va a dar a cada uno de los objetos
      if (stateType == null){
        obj.addAll(defaultObjects(_data['UsersObjects'], ObjType.USER_OBJECT));
        try{
          obj.addAll(defaultObjects(_data['GroupsObjects'], ObjType.GROUP_OBJECT));
        }catch(e){
          print(e);
        }
        
      }else{
        List<dynamic> objects = _data;
        StateOfObject stateOfObject = ObjState.getObjState(stateType);
        if(stateOfObject == StateOfObject.REQUESTED){objects.forEach((element) => obj.addAll(!mine ? requestObjects(element) : myRequestsObjects(element)));}
        if(stateOfObject == StateOfObject.CLAIMED){objects.forEach((element) =>obj.addAll(requestObjects(element)));}
      }
    }

    if(_responseType == 3){

    }
    _orderObjeList(obj);
    return obj;
  }
  List<Group> groupsBuilder(){
    List l = _data['publicGroups'];

    List<Group> groups = new List();
    l.forEach((group){groups.add(groupBuilder(data: group));});
    return groups;

  }
  List<Obj> defaultObjects(List<dynamic> objects, ObjType objType){
    List<Obj> objs = new List();
    objects.forEach((object){
      objs.add(objectBuilder(data : object, forUser: objType == ObjType.USER_OBJECT));
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
          amount: data['amount'] != null ? int.parse(data['amount']) :  int.parse(data['max_amount']),
          image : data['imagen'],
          desc: data['descr'],
          date: data['creationDate'],
          actualAmount: data['available_amount'] != null ? data['available_amount'] : int.parse(data['amount']) ,
          objState: objState
          ) 
          : 
        new GroupObject(
          int.parse(data['idObject']), 
          data['owner'] != null ? groupBuilder(data:data['owner'])  : group ,
          data['name'],
          image : data['imagen'],
          desc: data['descr'],
          amount: data['amount'] != null ? int.parse(data['amount']) :int.parse(data['max_amount']),
          date: data['creationDate'],
          actualAmount: data['available_amount'] != null ? data['available_amount'] : int.parse(data['amount']) ,
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
        idMember: int.parse(userInfo['idMember'])
        ))
      );
    });
    return u;
  }
  User userBuilder({Map<String, dynamic> data,int idMember, bool admin}){
    data = data == null ? _data['user'] : data;
    return new User(
      data['idUser'], 
      data['nickname'],
      email: data['email'],
      img: data['imagen'],
      tfno: data['tfno'],
      info: data['info'],
      idMember: idMember,
      admin: admin);
  }

  Group groupBuilder({Map<String, dynamic> data, bool imAdmin = false, bool imMember = false}){
    data = data == null ? _data['group'] : data;
    return new Group(
      int.parse(data['idGroup']), 
      data['groupName'],
      email: data['email'],
      tfno: data['tfno'],
      img: data['imagen'],
      info: data['info'],
      imMember: imMember,
      autoloan:  "1" == data['autoloan'],
      private: "1" == data['private'],
      imAdmin: imAdmin,
    );
  }
  List<Group> myGroupsBuilder(){
    List<dynamic> listAdmin = _data['admin'];
    List<dynamic> listMember = _data['member'];
    List<Group> listGroup = new List();
    listAdmin.forEach((group){listGroup.add(groupBuilder(data : group, imAdmin: true, imMember: true));});
    listMember.forEach((group){listGroup.add(groupBuilder(data : group, imMember: true));});
    return listGroup;
  }

  List<Group> myRequestedGroupsBuilder(){
    List<dynamic> listRequested = _data['request'];
    List<Group> listGroup = new List();
    listRequested.forEach((group){listGroup.add(groupBuilder(data : group));});
    return listGroup;
  }

  List<UserObject> requestsUserObjectBuilder({bool mine = null}){
    List<UserObject> list = new List();
    if(mine == null){
      
      list.addAll(_requestsUserObjectBuilder(_data['toUser']));
      list.addAll(_requestsUserObjectBuilder(_data['byUser']));
     
    }else{
      list.addAll(mine ? _requestsUserObjectBuilder(_data['byUser']) : _requestsUserObjectBuilder(_data['toUser']));
    }
    _orderObjeList(list);
    return list;
  }

  List<UserObject> _requestsUserObjectBuilder(List<dynamic> requests){
    List<UserObject> requestsList= new List();
    requests.forEach((request){
      ObjState state = new ObjState(
        id: int.parse(request['idRequest']),
        state: StateOfObject.REQUESTED,
        amount: int.parse(request['amount']),
        msg: request['requestMsg'],
        actual: request['object']['owner'] == null ?  UserSingleton().user : userBuilder(data :request['object']['owner']),
        next: request['requester'] == null ? UserSingleton().user : userBuilder(data : request['requester']),
        date: request['date'],
      );
      requestsList.add(objectBuilder(data: request['object'], objState: state));
    });
    _orderObjeList(requestsList);
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
      list.addAll(_requestsGroupObjectBuilder(_data['fromOthersUsers'], group: group, notFromAGroup: true));
      list.addAll(_requestsGroupObjectBuilder(_data['toOthersGroups'], group: group));

    
    }
    if(!mine) {
      list.addAll(_requestsGroupObjectBuilder(_data['intraGroup'], group: group));
      //list.addAll(_requestsGroupObjectBuilder(_data['fromOthersGroups'], group: group));
      list.addAll(_requestsGroupObjectBuilder(_data['fromOthersUsers'], group: group, notFromAGroup: true));
    }
    _orderObjeList(list);
    return list;
  }

  List<GroupObject> _requestsGroupObjectBuilder(List<dynamic> requests, {Group group, bool notFromAGroup = false}){
    List<GroupObject> requestsList= new List();
    requests.forEach((request){
      Group groupTarget = request['groupTarget'] != null ?  groupBuilder(data : request['groupTarget']) : group;
      Group requesterGroup = request['requesterGroup'] != null ? groupBuilder(data : request['requesterGroup']) : group;
      GroupObjState state = new GroupObjState(
        id: int.parse(request['idRequest']),
        state: StateOfObject.REQUESTED,
        amount: int.parse(request['amount']),
        msg: request['requestMsg'],
        actual: groupTarget != null ? groupTarget  : group,
        next: requesterGroup != null ? requesterGroup  : group,
        date: request['date'],
        //actualUser:userBuilder(data : request['user']) ,
        nextUser: userBuilder(data : request['requester_user']),
        notFromAGroup: notFromAGroup
      );
      requestsList.add(objectBuilder(data: request['object'], objState: state, group: group, forUser: false));
    });
    return requestsList;
  }

  List<UserObject> claimsUserObjectBuilder({bool mine}){
    List<UserObject> list = new List();
    if(mine == null){
      
      list.addAll(_claimsUserObjectBuilder(_data['toUser']));
      list.addAll(_claimsUserObjectBuilder(_data['byUser']));

    }else{
      list.addAll(mine ? _claimsUserObjectBuilder(_data['byUser']) : _claimsUserObjectBuilder(_data['toUser']));
    }

     _orderObjeList(list);
     return list;
  }

  List<UserObject> _claimsUserObjectBuilder(List<dynamic> claims){
    List<UserObject> claimsList= new List();
    claims.forEach((claim){
      ObjState state = new ObjState(
        state: StateOfObject.CLAIMED,
        amount: int.parse(claim['loan']['amount']),
        msg: claim['claimMsg'],
        id: int.parse(claim['idClaim']),
        actual:claim['loan']['keeper'] != null ? userBuilder(data : claim['loan']['keeper']) : UserSingleton().user,
        next: claim['loan']['object']['owner'] != null ? userBuilder(data : claim['loan']['object']['owner']) : UserSingleton().user,
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
      //list.addAll(_claimsGroupObjectBuilder(_data['toOthersGroups'], group: group));
      //list.addAll(_claimsGroupObjectBuilder(_data['toOthersUsers'], group: group, notFromAGroup: true));
    
    }
    if(!mine) {
      list.addAll(_claimsGroupObjectBuilder(_data['fromOthersGroups'], group: group));

    }
    _orderObjeList(list);
    return list;
  }

  List<GroupObject> _claimsGroupObjectBuilder(List<dynamic> claims, {Group group, bool notFromAGroup = false}){
    List<GroupObject> claimsList = new List();
    claims.forEach((claim){
      Group claimGroup =  claim['claimingGroup'] != null ? groupBuilder(data : claim['claimingGroup']) : group;
      Group keepGroup = claim['keeperGroup'] != null ? groupBuilder(data : claim['keeperGroup']) : group;
      User keepUser = userBuilder(data : claim['targetUser']);
      GroupObjState state = new GroupObjState(
        id: int.parse(claim['idClaim']),
        amount: int.parse(claim['object']['amount']) ,
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
      claimsList.add(objectBuilder(data: claim['object'],group: group, objState: state, forUser: false));
    });
    return claimsList;
  }

  List<UserObject> loansUserObjectBuilder({bool mine}){
    List<UserObject> list = new List();
    if(mine == null){
     
      list.addAll(_loansUserObjectBuilder(_data['toUser']));
      list.addAll(_loansUserObjectBuilder(_data['byUser']));
      _orderObjeList(list);
      return list;
    }else{
      list.addAll(mine ? _loansUserObjectBuilder(_data['byUser'], mine: mine) : _loansUserObjectBuilder(_data['toUser']));
    }
    _orderObjeList(list);
    return list;
  }

  List<UserObject> _loansUserObjectBuilder(List<dynamic> loans,{bool mine = false}){
    List<UserObject> loansList= new List();
    loans.forEach((loan){
      ObjState state = new ObjState(
        state: StateOfObject.LENT,
        amount: int.parse(loan['amount']),
        //date: loan['date'],
        msg: loan['loanMsg'],
        id: int.parse(loan['idLoan']),
        actual: loan['keeper'] != null ? userBuilder(data : loan['keeper']): UserSingleton().user,
        next:mine ? UserSingleton().user : userBuilder(data : loan['object']['owner']),
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
     // list.addAll(_loansGroupObjectBuilder(_data['toOthersGroups'], group: group));
      list.addAll(_loansGroupObjectBuilder(_data['toOthersUsers'], group: group, notFromAGroup: true));
    
    }
    if(!mine) {
      list.addAll(_loansGroupObjectBuilder(_data['fromOthersGroups'], group: group));

    }
    _orderObjeList(list);
    return list;
  }

  List<GroupObject> _loansGroupObjectBuilder(List<dynamic> loans, {Group group, bool notFromAGroup = false}){
    List<GroupObject> loanssList = new List();
    loans.forEach((loan){
      Group ownerGroup =  loan['ownerGroup'] != null ? groupBuilder(data : loan['ownerGroup']) : group;
      Group keepGroup = loan['keeperGroup'] != null ? groupBuilder(data : loan['keeperGroup']) : group;
      User keepUser =  loan['targetUser']!= null ? userBuilder(data : loan['targetUser']) : userBuilder(data : loan['keeper_user']);
      GroupObjState state = new GroupObjState(
        id: int.parse(loan['idLoan']),
        state: StateOfObject.LENT,
        amount: int.parse(loan['amount']),
        actual: keepGroup != null ? keepGroup  : group,
        next: ownerGroup != null ? ownerGroup  : group,
        date: loan['date'],
        //actualUser:userBuilder(data : loan['user']) ,
        actualUser: keepUser,
        notFromAGroup: notFromAGroup
      );
      loanssList.add(objectBuilder(data: loan['object'], group: group, objState: state, forUser: false));
    });
    return loanssList;
  }

  Map<String,List<Obj>> userInventory(){
    Map<String,List<Obj>> map = new Map();

    List<Obj> mines = new List();
    List<Obj> elses = new List();
    _data['mine_objs'].forEach((object){
      if(object != null){
        mines.add(objectBuilder(data: object, user: UserSingleton().user));}
    });
    _data['elses_objs'].forEach((object){
      if(object != null){elses.add(objectBuilder(data: object));}
    });
    map['mines'] = mines;
    map['others'] = elses;
    return map;
  }


  Map<String,List<GroupObject>> groupInventory(Group group){
    Map<String,List<GroupObject>> map = new Map();

    List<GroupObject> mines = new List();
    List<GroupObject> elses = new List();
    _data['our_objs'].forEach((object){
      if(object != null){mines.add(objectBuilder(data: object,group: group,forUser: false));}
    });
    _data['elses_objs'].forEach((object){
      if(object != null){elses.add(objectBuilder(data: object, group: group, forUser: false ));}
    });
    map['mines'] = mines;
    map['others'] = elses;
    return map;
  }

  Group signInGroupBuilder(){
    int idMember = int.parse(_data['member']['idMember']);
    bool admin = int.parse(_data['member']['idMember']) != 0 ;
    return groupBuilder(data: _data['member']['group'], imAdmin: admin);
  }


  void _orderObjeList(List<Obj> list){list.sort((a,b) => a.date.isAfter(b.date) ? 0 : 1);}


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

class StatusException implements Exception{
  int id;
  String errMsg = "Ha habido un error de conexion";
  StatusException(this.id);
  }
class AuthServer implements Exception{
  String errMsg;
  int id; 
  AuthServer(this.errMsg,{this.id});
}

class PrivateServerErrorException implements Exception{
  int id; 
  String errMsg;
  PrivateServerErrorException(this.id, this.errMsg);
}

class PublicServerErrorException implements Exception{
  int id; 
  String errMsg;
  PublicServerErrorException(this.id, this.errMsg);
}

class EmailNotVerify implements Exception{String errMsg = "Necesitas verificar el email";}