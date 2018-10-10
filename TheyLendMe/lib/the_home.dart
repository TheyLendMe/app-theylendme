import 'package:flutter/material.dart';

import 'package:TheyLendMe/the_drawer.dart';
import 'package:TheyLendMe/tabs/the_objects_tab.dart';
import 'package:TheyLendMe/tabs/the_groups_tab.dart';
import 'package:TheyLendMe/fragments/the_home.dart';
import 'package:TheyLendMe/fragments/my_objects.dart';
import 'package:TheyLendMe/fragments/my_loans.dart';
import 'package:TheyLendMe/fragments/my_groups.dart';
import 'package:TheyLendMe/fragments/settings.dart';

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
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Mis Objetos", Icons.folder_open),
    new DrawerItem("Mis Préstamos", Icons.import_export),
    new DrawerItem("Mis Grupos", Icons.people),
    new DrawerItem("Ajustes", Icons.settings)
  ];

  @override
    _TheHomePageState createState() => _TheHomePageState();
}

class _TheHomePageState extends State<TheHome> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return TheHomeFragment();
      case 1:
        return MyObjectsFragment();
      case 2:
        return MyLoansFragment();
      case 3:
        return MyGroupsFragment();
      case 4:
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

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Text('OBJETOS')),
                Tab(icon: Text('GRUPOS')),
              ],
            ),
            //title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
            title: new Container(
                child: Row(
                    children: <Widget>[
                      new Icon(widget.drawerItems[_selectedDrawerIndex].icon),
                      //TODO: padding entre Icon y Text
                      new Text(widget.drawerItems[_selectedDrawerIndex].title),
                    ],
                  )
              )
          ),
          body: TabBarView(
            children: [
              TheObjectsTab(),
              TheGroupsTab(),
            ],
          ),
          drawer: TheDrawer(), // hay que poner el drawer aquí
                                 // para que al abrirlo no ocupe toda la pantalla
          //FIXME: si uso TheDrawer() en vez de new Drawer(),
          //       no guarda el _selectedDrawerIndex
          //       (está cogiendo el contexto adecuado?)
          //       Posible solución: reload parent state desde the_drawer.dart
          // drawer: new Drawer(
          //   child: new Column(
          //     children: <Widget>[
          //       new UserAccountsDrawerHeader(
          //           accountName: new Text("John Doe"), accountEmail: null),
          //       new Column(children: drawerOptions)
          //     ],
          //   ),
          // ),
        )
      ),
      // si ponemos el drawer aquí (como estaba antes), ocupa toda la pantalla
    );
  }
}
