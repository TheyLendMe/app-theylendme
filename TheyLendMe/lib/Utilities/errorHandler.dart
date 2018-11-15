import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:TheyLendMe/pages/auth_page.dart';
abstract class ErrorHandler{
  BuildContext _context;

  ErrorHandler({BuildContext context}){this._context = context;}
  void handleError({String msg});
}

class ErrorToast extends ErrorHandler{
  @override
  void handleError({String msg}) async{
    Fluttertoast.showToast(
     msg: msg,
     toastLength: Toast.LENGTH_SHORT,
    );
  }
}


class ErrorAuth extends ErrorHandler{
  ErrorAuth(BuildContext context) : super(context : context);
  @override
  void handleError({String msg}) async{
    await Navigator.of(_context).push( MaterialPageRoute(builder: (_context) => new AuthPage()));
    Fluttertoast.showToast(
     msg: "Tienes que logearte",
     toastLength: Toast.LENGTH_SHORT,
    );
    

  }
}