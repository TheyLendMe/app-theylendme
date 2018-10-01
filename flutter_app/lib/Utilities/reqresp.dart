
import 'package:http/http.dart' as http;
import 'dart:convert';

class Request{

  final String _url;
  Map<String, dynamic> data;
  

  Request(this._url);


  Future<String> response() async{
    http.post(_url,body:data);


  }








}