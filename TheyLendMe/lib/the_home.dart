import 'package:flutter/material.dart';
import 'package:TheyLendMe/tabs/the_objects_tab.dart';
import 'package:TheyLendMe/tabs/the_groups_tab.dart';
import 'package:TheyLendMe/pages/the_home.dart';
import 'package:TheyLendMe/pages/my_objects.dart';
import 'package:TheyLendMe/pages/my_loans.dart';
import 'package:TheyLendMe/pages/my_groups.dart';
import 'package:TheyLendMe/pages/settings.dart';

//PRUEBAS de AUTENTICACIÓN: '$ flutter run' y después descomentar (2º)
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'Utilities/auth.dart';
// import 'Utilities/reqresp.dart';
// import 'package:TheyLendMe/Objects/entity.dart';
// import 'package:TheyLendMe/Objects/obj.dart';
// import 'Singletons/UserSingleton.dart';

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
    new DrawerItem("Home",         Icons.home,         "/"),
    new DrawerItem("Mis Objetos",  Icons.folder_open,  "/MyObjectsPage"),
    new DrawerItem("Mis Préstamos",Icons.import_export,"/MyLoansPage"),
    new DrawerItem("Mis Grupos",   Icons.people,       "/MyGroupsPage"),
    new DrawerItem("Ajustes",      Icons.settings,     "/SettingsPage")
  ];

  @override
  _TheHomePageState createState() => _TheHomePageState();
}

class _TheHomePageState extends State<TheHome> {

  //Para MENÚ LATERAL (guarda la opción seleccionada)
  int _selectedDrawerIndex = 0; // '_' = privado
  _getDrawerItemWidget(int pos) { //TODO: is this necessary?
    return pos;
  }

  //Para MENÚ LATERAL (acción al seleccionar)
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pushNamed(widget.drawerItems[index].route);
    // A Navigator is a widget that manages routes
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

    //PRUEBAS de AUTENTICACIÓN: '$ flutter run' y después descomentar  (2º)
    // final GoogleSignIn _googleSignIn = GoogleSignIn();
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    // void pruebas() async{
    //   // _handleSignIn();
    //   ///Con poner esto debería de valer para obtener los objetos de este usuario
    //   Auth.googleAuth();
    //   await (new User("myid","nombre").getObjects());
    // }

    // Future<FirebaseUser> _handleSignIn() async {
    //   GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    //   GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    //   FirebaseUser user = await _auth.signInWithGoogle(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );
    //   print("signed in " + user.displayName);
    //   return user;
    // }

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
                  // Aquí habrá que meter los datos de cada usuario
                    accountName: new Text("John Doe"), accountEmail: new Text("john.doe@gmail.com"),
                    // Metiendo imagen de user
                    currentAccountPicture: new CircleAvatar(
                      //backgroundColor: Colors.blueGrey,
                      backgroundImage: NetworkImage('https://http.cat/401'),
                    ),
                    ),
                new Column(children: drawerOptions)
              ],
            ),
          ),
          //PRUEBAS de AUTENTICACIÓN: '$ flutter run' y después descomentar  (2º)
          // floatingActionButton: new FloatingActionButton(
          //   onPressed: pruebas
          // ),
        )
      ),
      // si ponemos el drawer aquí (como estaba antes), ocupa toda la pantalla
    );
  }
}
