
import 'package:http/http.dart' as http;
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'dart:convert';
import 'dart:async';


const String endpoint = "http://54.188.52.254/app/";
class Request{

  String _url;
  Map<String, String> _data;
  http.Client client;
  http.Request request;


  Request(String fun){
    _url = endpoint+fun;
    request = new http.Request('POST', Uri.parse(_url));
    client = new http.Client();
    _data = new Map();
  
  }


  Future<Response> doRequest({var context}) async{
    request.bodyFields = _data;
    ///TODO implementar un manejador de errores si deja de haber conexion
    ///Si el 
    try{
      http.StreamedResponse response = await client.send(request);
      return await Response.responseBuilder(response);
    }catch(e){
      print("Internet connection error");
      return null;
    }
    


  }


///This will be the builder that
  Request dataBuilder({String idUser,int idGroup, int idObject, 
  String name, String desc,String info, String email,String fieldName, String tfno,
  int idLoan, int idRequest, int idClaim, int amount, String fieldValue,
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
    if(fieldName != null) _data ['fieldName'] = fieldName;
    if(fieldName != null) _data ['fieldValue'] = fieldValue;
    if(email != null) _data['email'] = email;
    if(info != null) _data['info'] = info;
    if(tfno != null) _data['tfno'] = tfno;
    if(imagen != null) _data['imagen'] = imagen;
    if(claimMsg != null) _data['claimMsg'] = claimMsg;
    return this;
  }
}



class Response{

  ///Builder that allow the app to create the Respnse object asynchronously, we need this, because byteToString
  ///returns a Future!
  static Future<Response> responseBuilder(http.StreamedResponse response) async{
    ///In case of server error like 404 not found... this 
    ///
    
    String resString = await response.stream.bytesToString();
    print(resString);
    if(response.statusCode != 200 ) throw new StatusException("Ha habido un error con el servidor", response.statusCode);

    return new Response(resString);
  }
  dynamic _data;
  
  Response(data){
    this._data = jsonDecode(data);

    if(_data['error'] != false){ throw new ServerException(_data["errorMsg"], _data["errorCode"]);}
    
  }

  dynamic get data => _data;

  List<Obj> objectsBuilder(Entity entity){
    List<dynamic> l = _data['responseData'];   
    List<Obj> objs = new List();
    l.forEach((element){
      objs.add(objectBuilder(entity, data: element as Map<String,dynamic>));
    });
    return objs;

  } 
  Obj objectBuilder(Entity entity, {Map<String,dynamic> data}){
    data = data == null ?   _data as Map : data; 
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