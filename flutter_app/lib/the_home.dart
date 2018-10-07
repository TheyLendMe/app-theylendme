import 'package:flutter/material.dart';

import 'package:flutter_app/the_drawer.dart';
import 'package:flutter_app/tabs/the_objects_tab.dart';
import 'package:flutter_app/tabs/the_groups_tab.dart';
import 'package:flutter_app/fragments/my_objects.dart';
import 'package:flutter_app/fragments/my_loans.dart';
import 'package:flutter_app/fragments/my_groups.dart';
import 'package:flutter_app/fragments/settings.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class TheHome extends StatefulWidget {
  TheHome({Key key, this.title}) : super(key: key);
  // This stateful widget is the home page of your application.

  final String title;

  final drawerItems = [
    new DrawerItem("Mis Objetos", Icons.rss_feed),
    new DrawerItem("Mis Préstamos", Icons.local_pizza),
    new DrawerItem("Mis Grupos", Icons.info),
    new DrawerItem("Ajustes", Icons.info)
  ];

  @override
    _TheHomePageState createState() => _TheHomePageState();
}

class _TheHomePageState extends State<TheHome> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return MyObjectsFragment();
      case 1:
        return MyLoansFragment();
      case 2:
        return MyGroupsFragment();
      case 3:
        return SettingsFragment();

      default:
        return new Text("Error");
    }
  }
  
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Text('OBJETOS')),
                Tab(icon: Text('GRUPOS')),
              ],
            ),
            title: Text(widget.title),
          ),
          body: TabBarView(
            children: [
              TheObjectsTab(),
              TheGroupsTab(),
            ],
          ),
        ),
      ),
      drawer: TheDrawer(),
    );
  }
}
