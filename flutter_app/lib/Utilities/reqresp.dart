
import 'package:http/http.dart' as http;
import 'package:flutter_app/Objects/obj.dart';
import 'package:flutter_app/Objects/entity.dart';
import 'dart:convert';
import 'dart:async';

class Request{

  final String _url;
  Map<String, String> _data;
  http.Client client;
  http.Request request;


  Request(this._url){
    request = new http.Request('POST', Uri.parse(_url));
    client = new http.Client();
    _data = new Map();
  
  }


  Future<Response> doRequest() async{
    request.bodyFields = _data;
    ///TODO implementar un manejador de errores si deja de haber conexion
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
  String name, String desc, int idLoan, int idRequest, int idClaim, int amount,
  String oUser, //add more fields if they are necessary
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
    return this;
  }
}



class Response{

  ///Builder that allow the app to create the Respnse object asynchronously, we need this, because byteToString
  ///returns a Future!
  static Future<Response> responseBuilder(http.StreamedResponse response) async{
    RequestError err = response.statusCode != 200 ? new ServerError("Ha habido un error con el servidor", 1) : null;
    String resString = await response.stream.bytesToString();
    print(resString);
    return new Response(resString,err);
  }

  final RequestError _err;
  dynamic _data;
  
  Response(data,this._err){
    this._data = jsonDecode(data);
  }



  bool hashError(){return _err== null;}
  
  dynamic get data => _data;



  List<Obj> objectsBuilder(Entity entity){
     ///Necesita saber si es lista o mapa, el usuario ()

    //print(_data["responseType"]);

    List<dynamic> l = _data['data'];
    
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

abstract class RequestError{

  final String errMsg;
  final int idErr;
  

  RequestError(this.errMsg,this.idErr){}


}

class StatusError extends RequestError{
  ///TODO define status error
  StatusError(String errMsg, int idErr) : super(errMsg, idErr);

}

class ServerError extends RequestError{
  ServerError(String errMsg, int idErr) : super(errMsg, idErr);


}