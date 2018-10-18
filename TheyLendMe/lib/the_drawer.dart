import 'package:flutter/material.dart';

import 'package:TheyLendMe/pages/the_home.dart';
import 'package:TheyLendMe/pages/my_objects.dart';
import 'package:TheyLendMe/pages/my_loans.dart';
import 'package:TheyLendMe/pages/my_groups.dart';
import 'package:TheyLendMe/pages/my_settings.dart';

class TheDrawer extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Home",         Icons.home,         "/"),
    new DrawerItem("Mis Objetos",  Icons.folder_open,  "/MyObjectsPage"),
    new DrawerItem("Mis Préstamos",Icons.import_export,"/MyLoansPage"),
    new DrawerItem("Mis Grupos",   Icons.people,       "/MyGroupsPage"),
    new DrawerItem("Ajustes",      Icons.settings,     "/MySettingsPage"),
    new DrawerItem("TestAuth",      Icons.settings,     "/AuthPage")
  ];

  @override
  _TheDrawerState createState() => _TheDrawerState();
}

class _TheDrawerState extends State<TheDrawer> {

  @override
  Widget build(BuildContext context) {

    List<Widget> drawerOptions = [];

    for (var i = 0; i < widget.drawerItems.length; i++) {

      var d = widget.drawerItems[i];

      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    return new Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            // Aquí habrá que meter los datos de cada usuario
            accountName: new Text("John Doe"), accountEmail: new Text("john.doe@gmail.com"),
            // Metiendo imagen de user
            currentAccountPicture: new CircleAvatar(backgroundImage: NetworkImage('https://http.cat/401')),
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('images/tlm.jpg')
              ),
            )
          ),
          Column(children: drawerOptions)
        ],
      ),
    );
  }

  int _selectedDrawerIndex = 0;

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pushNamed(widget.drawerItems[index].route);
    // A Navigator is a widget that manages routes
  }
  
}

class DrawerItem {
  DrawerItem(this.title, this.icon, this.route);

  String title;
  IconData icon;
  String route;
}