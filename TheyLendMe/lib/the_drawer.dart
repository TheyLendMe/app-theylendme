import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

import 'package:TheyLendMe/pages/me_details.dart';

class TheDrawer extends StatefulWidget {

  final drawerItems = [
    DrawerItem("Home",         Icons.home,         "/"),
    DrawerItem("Mi Ropa",  Icons.folder_open,  "/MyInventoryPage"),
    DrawerItem("Mis Compras",Icons.import_export,"/MyLoansPage"),
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
              ? (UserSingleton().user.name!= null //TODO: better with UserSingleton().user.getEntityInfo().name
                ? Text(UserSingleton().user.name)
                : Text("NombreUsuario"))
              : Text("UsuarioSinRegistrar")),
            accountEmail: (UserSingleton().login
              ? (UserSingleton().user.email!=null
                ? Text(UserSingleton().user.email)
                : Text("sample@ma.il"))
              : Text('')),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                backgroundImage: (UserSingleton().login
                  ? (UserSingleton().userImage!=null ? NetworkImage(UserSingleton().userImage) : AssetImage('images/def_user_pic.png'))
                  : null),
                child: (UserSingleton().login
                  ? null
                  : Icon(FontAwesomeIcons.signInAlt, color: Colors.black))
              ),
              onTap: () async{
                if(UserSingleton().login) {
                  User user = await UserSingleton().user.getEntityInfo();
                  String tfno = user.tfno; String name = user.name;
                  showDialog(
                    context: context,
                    builder: (BuildContext context){ return MeDetails(tfno,name);}
                  );
                } else Navigator.of(context).pushNamed("/AuthPage");
              }
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/tlm.png')
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