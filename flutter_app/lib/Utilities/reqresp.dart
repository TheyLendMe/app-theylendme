
import 'package:http/http.dart' as http;
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
    var response = await client.send(request);
    return new Response(response);


  }


///This will be the builder that
  Request dataBuilder({String idUser,String idGroup, String idObject, 
  String name, String desc, String idLoan, String idRequest, String idClaim, int amount,
  String oUser, //add more fields if they are necessary
  }){
    if(idUser != null) _data['idUser'] = idUser;
    if(idGroup != null)_data['idGroup'] = idGroup;
    if(idGroup != null)_data['idObject'] = idObject;
    if(name != null)_data['name'] = name;
    if(desc != null)_data['desc'] = desc;
    if(idLoan != null) _data['idLoan'] = idLoan;
    if(idRequest != null) _data['idRequest'] = idRequest;
    if(idClaim != null) _data['idClaim'] = idClaim;
    if(amount != null) _data['amount'] = amount.toString();
    ///In case we need to pass other user ---> oUser
    if(oUser != null) _data['oUser'] = oUser;
    return this;
  }
}



class Response{
  final http.StreamedResponse response;


  Response(this.response){
    response.stream.bytesToString().then((s){
      print(s);
    });

  }

  bool hashError(){return response.statusCode != 200;}
  

}