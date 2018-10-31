import 'package:flutter/material.dart';
import 'package:TheyLendMe/the_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Utilities/auth.dart';
import 'Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'package:http/http.dart' as Http;

import 'package:TheyLendMe/pages/my_objects.dart';
import 'package:TheyLendMe/pages/my_loans.dart';
import 'package:TheyLendMe/pages/my_groups.dart';
import 'package:TheyLendMe/pages/my_settings.dart';

import 'package:TheyLendMe/pages/object_page.dart';
import 'package:TheyLendMe/pages/user_page.dart';
import 'package:TheyLendMe/pages/auth_page.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(TheApp());



class TheApp extends StatelessWidget {

  void pruebas() async{
    await Auth.googleAuth();
    UserSingleton().refreshUser();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    UserSingleton().user.addObject("Prueba de imagen", 1, img: image, info: "Esto es una prueba de imagen");
    
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'app de préstamos',
      theme: ThemeData( primarySwatch: Colors.blue, ),
      home: new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: pruebas,
        ),
      ),
    );
    //   home: TheHome(title: 'TheyLendMe'),

    //   //A Route is an abstraction for a “screen” or “page” of an app,
    //   routes: <String, WidgetBuilder> {
    //     "/MyObjectsPage": (BuildContext context) => new MyObjectsPage(),
    //     "/MyLoansPage": (BuildContext context) => new MyLoansPage(),
    //     "/MyGroupsPage": (BuildContext context) => new MyGroupsPage(),
    //     "/MySettingsPage": (BuildContext context) => new MySettingsPage(),

    //     "/ObjectPage": (BuildContext context) => new ObjectPage(),
    //     "/UserPage": (BuildContext context) => new UserPage(),
    //     "/AuthPage": (BuildContext context) => new AuthPage(),
    //   } // (a live example: https://youtu.be/RLyw-_MLLTo)
    // );
  }
}
