
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

const String endpoint = "http://54.188.52.254/app/";




class RequestPost{

  String _url;
  Map<String, dynamic> _data;
  Dio dio = new Dio();


  RequestPost(String fun){
    _url = fun;

    dio.options.baseUrl=endpoint;
    dio.options.connectTimeout = 5000; //5s
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
 RequestPost dataBuilder({String idUser,int idGroup, int idObject, 
  String name, String desc,String info, String email, String tfno,String nickName,
  int idLoan, int idRequest, int idClaim, int amount,Map fieldname,Map fieldValue,
  String oUser, String msg, String imagen, String claimMsg//add more fields if they are necessary
  }){
    if(idUser != null) _data['idUser'] = idUser;
    if(idGroup != null)_data['idGroup'] = idGroup.toString();
    if(idObject != null)_data['idObject'] = idObject.toString();
    if(name != null)_data['name'] = name;
    if(desc != null)_data['desc'] = desc;
    if(idLoan != null) _data['idLoan'] = idLoan.toString();
    if(idRequest != null) _data['idRequest'] = idRequest.toString();
    if(idClaim != null) _data['idClaim'] = idClaim.toString();
    if(amount != null) _data['amount'] = amount.toString();
    ///In case we need to pass other user ---> oUser
    if(oUser != null) _data['oUser'] = oUser;
    if(msg != null) _data['msg'] = msg;
    if(imagen != null) _data['imagen'] = imagen;
    if(claimMsg != null) _data['claimMsg'] = claimMsg;
    if(fieldname != null) {_data['fieldName'] = fieldname; _data ['fieldValue'] = fieldValue;}
    return this;
  }
}


List<dynamic> fieldNameFieldValue({String nickName,String email, String info, String tfno}){
    Map fieldName = new Map();
    Map fieldValue = new Map();
    List<dynamic> r = new List();
    r.add(fieldName);
    r.add(fieldValue);

    if(nickName != null){fieldName['nickname'] = ("nickName");fieldValue['nickname'] =nickName;}
    if(email != null){fieldName['email'] = ("email");fieldValue['email'] = (email);}
    if(info != null){fieldName['info'] = "info";fieldValue['info'] = info;}
    if(tfno != null){fieldName['tfno'] = ("tfno");fieldValue['tfno'] = (tfno);}
    return r;
}



class ResponsePost{

  ///Builder that allow the app to create the Respnse object asynchronously, we need this, because byteToString
  ///returns a Future!
  static Future<ResponsePost> responseBuilder(Response response) async{
    ///In case of server error like 404 not found... this 
    ///
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