import 'package:flutter/material.dart';
import 'package:TheyLendMe/the_home.dart';

import 'package:TheyLendMe/pages/my_objects.dart';
import 'package:TheyLendMe/pages/my_loans.dart';
import 'package:TheyLendMe/pages/my_groups.dart';
import 'package:TheyLendMe/pages/my_settings.dart';

import 'package:TheyLendMe/pages/object_page.dart';
import 'package:TheyLendMe/pages/user_page.dart';
import 'package:TheyLendMe/pages/auth_page.dart';

void main() => runApp(TheApp());

final firstColor = const Color(0xFF35504d);
final secondColor = const Color(0xFFf3e2bb);

class TheApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app de préstamos',
      theme: ThemeData(
        primaryColor: firstColor,
        accentColor: secondColor,
      ),
      home: TheHome(title: 'TheyLendMe'),

      //A Route is an abstraction for a “screen” or “page” of an app,
      routes: <String, WidgetBuilder> {
        "/MyObjectsPage": (BuildContext context) => new MyObjectsPage(),
        "/MyLoansPage": (BuildContext context) => new MyLoansPage(),
        "/MyGroupsPage": (BuildContext context) => new MyGroupsPage(),
        "/MySettingsPage": (BuildContext context) => new MySettingsPage(),

        //"/ObjectPage": (BuildContext context) => new ObjectPage(),
        "/UserPage": (BuildContext context) => new UserPage(),
        "/AuthPage": (BuildContext context) => new AuthPage(),
      } // (a live example: https://youtu.be/RLyw-_MLLTo)
    );
  }
}
