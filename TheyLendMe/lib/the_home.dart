import 'package:flutter/material.dart';

import 'package:TheyLendMe/tabs/the_objects_tab.dart';
import 'package:TheyLendMe/tabs/the_groups_tab.dart';
import 'package:TheyLendMe/pages/the_home.dart';
import 'package:TheyLendMe/pages/my_objects.dart';
import 'package:TheyLendMe/pages/my_loans.dart';
import 'package:TheyLendMe/pages/my_groups.dart';
import 'package:TheyLendMe/pages/settings.dart';

// Para MENÚ LATERAL
class DrawerItem {
  DrawerItem(this.title, this.icon, this.route);

  String title;
  IconData icon;
  String route;
}

class TheHome extends StatefulWidget {
  TheHome({Key key, this.title}) : super(key: key);
  // This stateful widget is the home page of your application.

  final String title;

  // Contenido del MENÚ LATERAL
  final drawerItems = [
    new DrawerItem("Home", Icons.home,"/"),
    new DrawerItem("Mis Objetos", Icons.folder_open,"/MyObjectsPage"),
    new DrawerItem("Mis Préstamos", Icons.import_export,"/MyLoansPage"),
    new DrawerItem("Mis Grupos", Icons.people,"/MyGroupsPage"),
    new DrawerItem("Ajustes", Icons.settings,"/SettingsPage")
  ];

  @override
    _TheHomePageState createState() => _TheHomePageState();
}

class _TheHomePageState extends State<TheHome> {

  //Para MENÚ LATERAL
  int _selectedDrawerIndex = 0;
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return TheHomePage();
      case 1:
        return MyObjectsPage();
      case 2:
        return MyLoansPage();
      case 3:
        return MyGroupsPage();
      case 4:
        return SettingsPage();

      default:
        return new Text("Error");
    }
  }

  //Para MENÚ LATERAL (guarda la opción seleccionada)
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pushNamed(widget.drawerItems[index].route); // close the drawer
  }

  @override
  Widget build(BuildContext context) {

    //Para MENÚ LATERAL
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

          // MENÚ LATERAL:
          drawer: new Drawer(  // hay que poner el drawer aquí
            child: new Column( // para que al abrirlo no ocupe toda la pantalla
              children: <Widget>[
                new UserAccountsDrawerHeader(
                    accountName: new Text("John Doe"), accountEmail: null),
                new Column(children: drawerOptions)
              ],
            ),
          ),
        )
      ),
      // si ponemos el drawer aquí (como estaba antes), ocupa toda la pantalla
    );
  }
}
