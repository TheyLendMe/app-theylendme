
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

const String endpoint = "http://54.188.52.254/app/";
//const String endpoint ="http://10.0.2.2/";



class RequestPost{

  String _url;
  Map<String, dynamic> _data;
  Dio dio = new Dio();
  bool userInfo = false;


  RequestPost(String fun){
    _url = fun;

    dio.options.baseUrl=endpoint;
    dio.options.connectTimeout = 10000; //5s
    dio.options.receiveTimeout=3000;  

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
    }
    


  }


///This will be the builder that
 RequestPost dataBuilder({String idUser,dynamic idGroup, int idObject, 
  String name, String desc,String info, String email, String tfno,String nickName,

  int idLoan, int idRequest, int idClaim, int amount,List fieldname,List fieldValue,
  String oUser, String msg, File img, String claimMsg, String groupName, bool autoLoan,
  bool private, int idMemeber, String requestMsg, bool userInfo = false//add more fields if they are necessary
  }){
    this.userInfo = userInfo;
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
    ///In case we need to pass other user ---> oUser
    if(oUser != null) _data['oUser'] = oUser;
    if(msg != null) _data['msg'] = msg;
    if(img != null) _data['image'] = new UploadFileInfo(img, basename(img.path));
    if(claimMsg != null) _data['claimMsg'] = claimMsg;
    if(fieldname != null) {_data['fieldName'] = [fieldname]; _data ['fieldValue'] = [fieldValue];}
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
    await UserSingleton().refreshUser();
    Map<String,dynamic> m = new Map();
    m['idUser']= UserSingleton().user.idEntity;
    m['token'] = UserSingleton().token;
    m['nickname'] = UserSingleton().user.name;
    m['email'] = UserSingleton().firebaseUser.email;
    m['tfno'] = UserSingleton().firebaseUser.phoneNumber;
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
        user: false, 
        group: group, 
        objState: 
        objState))
      ;});
    return obs;
    
  }
  Obj objectBuilder({Map<String, dynamic> data, bool user = true,ObjState objState ,Group group}){
      data = data == null ? _data : data;
      return user ? 
        new UserObject(1, new User("awda", "awd"), "name") : 
        new GroupObject(
          int.parse(data['idObject']), 
          group,
           //TODO decirle a victor que me incluya todo el grupo
          data['name'],
          image : data['image'],
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

  List<Obj> requestObjectBuilder({Group group}){
    
  }








  // List<Obj> objectsBuilder({Entity entity, String stateType}){
  //   List<dynamic> l = new List();
  //   if(_data is Map){
  //     l.addAll(_data['UsersObjects']);
  //     l.addAll(_data['GroupsObjects']);
  //   }else{
  //     l = _data;
  //   }
 
  //   List<Obj> objs = new List();
  //   l.forEach((element){
  //     Entity e;
  //     if(entity == null){
  //       bool isFromUser = element['idUser'] != null;
  //       e= isFromUser ? new User(element['idUser'],"") : new Group(element['idGroup'], "");
  //     }
  //     objs.add(objectsStateBuilder(entity: entity != null ? entity : e, data: element as Map<String,dynamic>));
  //   });
  //   return objs;

  // } 

  // Obj objectsStateBuilder({Entity entity,Map<String,dynamic> objData,String stateType}){
  //   objData = objData == null ? _data as Map : data; 

  //   if(_responseType == 4){
  //     int id;
  //     int amount;
  //     String name;
  //     String imagen;


  //     if(objData.containsKey("requests")){
  //       List<dynamic> states = objData['requests'];
  //       states.forEach((elememt){
  //         ObjState state = new ObjState(
  //           state: StateOfObject.REQUESTED,
  //           actual: ,
  //            id: element['idRequested']
  //           );
  //       });
  //     }


  //   }



  //   return entity.type  == EntityType.USER ? 
  //     new UserObject(int.parse(data["idObject"]),entity, data["name"]) :
  //     new GroupObject(int.parse(data["idObject"]),entity, data["name"]);
  // }


  // Obj objectBuilder({Entity entity,Map<String,dynamic> objData,String stateType}){
  //   objData = objData == null ? _data as Map : data; 

  //   if(_responseType == 4){
  //     int id;
  //     int amount;
  //     String name;
  //     String imagen;


  //     if(objData.containsKey("requests")){

  //     }


  //   }



  //   return entity.type  == EntityType.USER ? 
  //     new UserObject(int.parse(data["idObject"]),entity, data["name"]) :
  //     new GroupObject(int.parse(data["idObject"]),entity, data["name"]);
  // }

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
