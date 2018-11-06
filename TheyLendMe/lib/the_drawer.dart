import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:TheyLendMe/pages/my_objects.dart';
import 'package:TheyLendMe/pages/my_loans.dart';
import 'package:TheyLendMe/pages/my_groups.dart';
import 'package:TheyLendMe/pages/my_settings.dart';

class TheDrawer extends StatefulWidget {

  final drawerItems = [
    DrawerItem("Home",         Icons.home,         "/"),
    DrawerItem("Mis Objetos",  Icons.folder_open,  "/MyObjectsPage"),
    DrawerItem("Mis Préstamos",Icons.import_export,"/MyLoansPage"),
    DrawerItem("Mis Grupos",   Icons.people,       "/MyGroupsPage"),
    DrawerItem("Ajustes",      Icons.settings,     "/MySettingsPage")
  ];

  @override
  _TheDrawerState createState() => _TheDrawerState();
}

class _TheDrawerState extends State<TheDrawer> {
  bool showUserDetails = false;

    /*Widget _buildUserDetail() {
      return Container(
        child: ListView(
          children: [
            ListTile(
              title: Text("User details"),
              leading: Icon(Icons.info_outline),
            )
          ],
        ),
      );
    }*/ //TODO: UserDetail needed?

  @override
  Widget build(BuildContext context) {

    List<Widget> drawerOptions = [];

    for (var i = 0; i < widget.drawerItems.length; i++) {

      var d = widget.drawerItems[i];

      drawerOptions.add(
        ListTile(
          leading: Icon(d.icon),
          title: Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            // Aquí habrá que meter los datos de cada usuario
            accountName: Text("John Doe"), accountEmail: Text("john.doe@gmail.com"),
            /*onDetailsPressed: () { //TODO: UserDetail needed?
              setState(() {
                showUserDetails = !showUserDetails;
              });
            },*/
            // Metiendo imagen de user
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: Icon(FontAwesomeIcons.signInAlt, color: Theme.of(context).primaryColor)
              ),
              onTap: () => Navigator.of(context).pushNamed("/AuthPage")
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/tlm.jpg')
              ),
            )
          ),
          //Expanded(child: showUserDetails ? _buildUserDetail() : Column(children: drawerOptions)), //TODO: UserDetail needed?
          Column(children: drawerOptions)
        ],
      ),
    );
  }

  int _selectedDrawerIndex = 0;

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    // A Navigator is a widget that manages routes
    //TODO: generalizar esta condición:
    if (widget.drawerItems[index].route=="/")
      Navigator.pop(context);
    else
      Navigator.of(context).pushNamed(widget.drawerItems[index].route);
  }

}

class DrawerItem {
  DrawerItem(this.title, this.icon, this.route);

  String title;
  IconData icon;
  String route;
}