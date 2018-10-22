
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

const String endpoint = "http://54.188.52.254/app/";
//const String endpoint ="http://10.0.2.2/";



class RequestPost{

  String _url;
  Map<String, dynamic> _data;
  Dio dio = new Dio();


  RequestPost(String fun){
    _url = fun;

    dio.options.baseUrl=endpoint;
    dio.options.connectTimeout = 10000; //5s
    dio.options.receiveTimeout=3000;  

    _data = new Map();
  
  }


  Future<ResponsePost> doRequest({var context}) async{

    ///TODO implementar un manejador de errores si deja de haber conexion
    ///Si el 
    try{
      return ResponsePost.responseBuilder(await dio.post(_url,data: new FormData.from(_data)));
      
    }catch(e){
      print("Internet connection error");
      return null;
    }
    


  }


///This will be the builder that
 RequestPost dataBuilder({String idUser,dynamic idGroup, int idObject, 
  String name, String desc,String info, String email, String tfno,String nickName,

  int idLoan, int idRequest, int idClaim, int amount,List fieldname,List fieldValue,
  String oUser, String msg, String imagen, String claimMsg,bool userInfo = false, String groupName, bool autoLoan,
  bool private, int idMemeber, String requestMsg//add more fields if they are necessary

  }){
    if(userInfo){_data.addAll(authInfo());}
    //if(idUser != null) _data['idUser'] = "otherid"; ///TODO modificar por iduser
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
    if(imagen != null) _data['imagen'] = imagen;
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

  Map<String,dynamic> authInfo(){
    if(!UserSingleton.singleton.login){
      throw new NotLogedException("You are not loged");
    }
    Map<String,dynamic> m = new Map();
    m['idUser']= UserSingleton.singleton.user.idEntity;
    m['token'] = UserSingleton.singleton.token;
    m['nickname'] = UserSingleton.singleton.user.name;
    m['email'] = UserSingleton.singleton.firebaseUser.email;
    m['tfno'] = UserSingleton.singleton.firebaseUser.phoneNumber;
    return m;
  }
}



 /* if(nickName != null){fieldName[i] = 'nickname'; fieldValue[i]=nickName; i++;}
  if(email != null){fieldName[i]='email';fieldValue[i]= (email); i++;}
  if(info != null){fieldName[i]=('info');fieldValue[i]=(info); i++;}
  if(tfno != null){fieldName[i]=('tfno');fieldValue[i]=(tfno);i++;}*/
List<dynamic> fieldNameFieldValue({String nickName,String email, String info, String tfno, int amount, 
String name, String groupName, bool private, bool autoloan, }){
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
    ///
    print(response.request.baseUrl+response.request.path);
    print(response.data);
    if(response.statusCode != 200 ) throw new StatusException("Ha habido un error con el servidor", response.statusCode);

    return new ResponsePost(response.data);
  }
  dynamic _data;
  
  ResponsePost(data){
    this._data = data;
    if(_data['error'] != null && _data['error'] ) { throw new ServerException(_data["errorMsg"], _data["errorCode"]);}
    
  }

  dynamic get data => _data;

  List<Obj> objectsBuilder({Entity entity}){
    List<dynamic> l = new List();
    if(_data['responseData'] is Map){
      l.addAll(_data['responseData']['UsersObjects']);
      l.addAll(_data['responseData']['GroupsObjects']);
    }else{
      l = _data['responseData'];
    }
 


    List<Obj> objs = new List();
    l.forEach((element){
      Entity e;
      if(entity == null){
        bool isFromUser = element['idUser'] != null;
        e= isFromUser ? new User(element['idUser'],"") : new Group(element['idGroup'], "");
      }
      objs.add(objectBuilder(entity: entity != null ? entity : e, data: element as Map<String,dynamic>));
    });
    return objs;

  } 
  Obj objectBuilder({Entity entity,Map<String,dynamic> data}){
    data = data == null ? _data as Map : data; 

    return entity.type  == EntityType.USER ? 
      new UserObject(int.parse(data["idObject"]),entity, data["name"]) :
      new GroupObject(int.parse(data["idObject"]),entity, data["name"]);
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

///Login Exception
class NotLogedException implements Exception{
  final String errMsg;
  NotLogedException(this.errMsg);
}