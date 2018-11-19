import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

import 'package:TheyLendMe/pages/my_objects.dart';
import 'package:TheyLendMe/pages/my_loans.dart';
import 'package:TheyLendMe/pages/my_groups.dart';
import 'package:TheyLendMe/pages/my_settings.dart';
import 'package:TheyLendMe/pages/user_details.dart';

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
            accountName: (UserSingleton().login
              ? (UserSingleton().user.name!=null
                ? Text(UserSingleton().user.name)
                : Text("NombreUsuario"))
              : Text("NombreUsuario")),
            accountEmail: (UserSingleton().login
              ? (UserSingleton().user.email!=null
                ? Text(UserSingleton().user.email)
                : Text("sample@ma.il"))
              : Text("sample@ma.il")),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: (UserSingleton().login
                    ? (UserSingleton().user.img!=null
                      ? Image.network(UserSingleton().user.img) //TODO: circular
                      : Image.asset('images/def_user_pic.png'))
                  : Icon(FontAwesomeIcons.signInAlt, color: Theme.of(context).primaryColor))
              ),
              onTap: () {
                if(UserSingleton().login) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return UserDetails(UserSingleton().user); //TODO: since it's UserDetails(me), should it be different?
                    }
                  );
                } else Navigator.of(context).pushNamed("/AuthPage");
              }
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/tlm.jpg')
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
    // A Navigator is a widget that manages routes
    if (widget.drawerItems[index].route=="/")
      Navigator.pop(context);
    else {
      if (UserSingleton().login)
      Navigator.of(context).pushNamed(widget.drawerItems[index].route);
      else Navigator.of(context).pushNamed("/AuthPage");
    }
  }

}

class DrawerItem {
  DrawerItem(this.title, this.icon, this.route);

  String title;
  IconData icon;
  String route;
}