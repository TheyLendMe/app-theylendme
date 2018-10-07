import 'package:flutter/material.dart';
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

// MENÚ LATERAL
class TheDrawer extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Mis Objetos", Icons.folder_open),
    new DrawerItem("Mis Préstamos", Icons.import_export),
    new DrawerItem("Mis Grupos", Icons.people),
    new DrawerItem("Ajustes", Icons.settings)
  ];

  @override
  _TheDrawerState createState() => _TheDrawerState();
}

// Contenido del MENÚ LATERAL
class _TheDrawerState extends State<TheDrawer> {

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
    //FIXME: reload parent state
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

    return Drawer(
      child: new Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("John Doe"),
            accountEmail: null
          ),
          new Column(children: drawerOptions)
        ],
      ),
    );
  }
}
