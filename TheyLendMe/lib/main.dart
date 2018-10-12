import 'package:flutter/material.dart';
import 'package:TheyLendMe/the_home.dart';

import 'package:TheyLendMe/pages/my_objects.dart';
import 'package:TheyLendMe/pages/my_loans.dart';
import 'package:TheyLendMe/pages/my_groups.dart';
import 'package:TheyLendMe/pages/settings.dart';
import 'package:TheyLendMe/pages/object_page.dart';
import 'package:TheyLendMe/pages/user_page.dart';

void main() => runApp(TheApp());

class TheApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app de préstamos',
      theme: ThemeData( primarySwatch: Colors.blue, ),
      home: TheHome(title: 'TheyLendMe'),

      //A Route is an abstraction for a “screen” or “page” of an app,
      routes: <String, WidgetBuilder> {
        "/MyObjectsPage": (BuildContext context) => new MyObjectsPage(),
        "/MyLoansPage": (BuildContext context) => new MyLoansPage(),
        "/MyGroupsPage": (BuildContext context) => new MyGroupsPage(),
        "/SettingsPage": (BuildContext context) => new SettingsPage(),

        "/ObjectPage": (BuildContext context) => new ObjectPage(),
        "/UserPage": (BuildContext context) => new UserPage(),
      } // (a live example: https://youtu.be/RLyw-_MLLTo)
    );
  }
}
