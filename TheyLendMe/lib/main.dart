import 'package:flutter/material.dart';
import 'package:TheyLendMe/the_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Utilities/auth.dart';
import 'Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/entity.dart' as entity;
import 'package:TheyLendMe/Objects/obj.dart';
import 'Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/objState.dart';

import 'package:TheyLendMe/pages/my_objects.dart';
import 'package:TheyLendMe/pages/my_loans.dart';
import 'package:TheyLendMe/pages/my_groups.dart';
import 'package:TheyLendMe/pages/my_settings.dart';

import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/pages/user_details.dart';
import 'package:TheyLendMe/pages/auth_page.dart';
import 'package:TheyLendMe/pages/group_objects.dart';
import 'package:TheyLendMe/Objects/entity.dart';

//TODO: (last) https://flutter.io/docs/deployment/android

void main() => runApp(TheApp());

//WIP: choosing main colors ( i'm using https://randoma11y.com )
Color firstColor; //64b5f6
Color  secondColor; //#ffa000


Group _group;

class TheApp extends StatefulWidget{

  void pruebas(BuildContext context) async{
      await Auth.emailRegister( "datinacontacto@gmail.com", "270897");
      //Navigator.of(context).push( MaterialPageRoute(builder: (_context) => new AuthPage()));
      //UserSingleton().refreshUser();
      // var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      // UserSingleton().user.addObject("Prueba de imagen", 1, img: image, info: "Esto es una prueba de imagen",context: context);
      //UserSingleton().user.getRequests(context: context);
  }

  @override
  State<StatefulWidget> createState() {
    return TheAppState();
  }
}

class TheAppState extends State<TheApp>{
  // This widget is the root of your application.


  ThemeData themeData(){

    var primaryColors = firstColor;
    var secondColors = secondColor;
  return new ThemeData(
      primaryColor: firstColor == null ? Color(0xFF64b5f6) : firstColor,
      accentColor: secondColor == null ? Color(0xFFf9a825) : secondColor,
      buttonColor: firstColor == null ? Color(0xFF64b5f6) : firstColor,
  );
}
  @override
  Widget build(BuildContext context) {
    UserSingleton();
    return MaterialApp(
      title: 'TheyLendMe',
      debugShowCheckedModeBanner: false,
      theme: themeData(),
      home: TheHome(this, title: 'TheyLendMe'),

      //A Route is an abstraction for a "screen" or "page" of an app,
      routes: <String, WidgetBuilder> {
        "/MyObjectsPage": (BuildContext context) => new MyObjectsPage(),
        "/MyLoansPage": (BuildContext context) => new MyLoansPage(),
        "/MyGroupsPage": (BuildContext context) => new MyGroupsPage(),
        "/MySettingsPage": (BuildContext context) => new MySettingsPage(),

        "/AuthPage": (BuildContext context) => new AuthPage(),
      } // (a live example: https://youtu.be/RLyw-_MLLTo)
    );
  }

  
}
