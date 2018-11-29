import 'package:flutter/material.dart';
import 'Singletons/UserSingleton.dart';
import 'package:TheyLendMe/the_home.dart';
import 'package:TheyLendMe/pages/my_objects.dart';
import 'package:TheyLendMe/pages/my_loans.dart';
import 'package:TheyLendMe/pages/my_groups.dart';
import 'package:TheyLendMe/pages/my_settings.dart';
import 'package:TheyLendMe/pages/auth_page.dart';

//TODO: (last) https://flutter.io/docs/deployment/android

void main() => runApp(TheApp());

//WIP: choosing main colors ( i'm using https://randoma11y.com )

Color firstColor = Color(0xFF1d89e4);
Color secondColor = Color(0xFFfb8c00);

class TheApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    UserSingleton();
    return MaterialApp(
      title: 'TheyLendMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: firstColor,
        accentColor: secondColor,
        buttonColor: firstColor,
      ),
      home: TheHome(title: 'TheyLendMe'),

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
