import 'package:flutter/material.dart';

import 'package:TheyLendMe/the_drawer.dart';
import 'package:TheyLendMe/tabs/the_objects_tab.dart';
import 'package:TheyLendMe/tabs/the_groups_tab.dart';

class TheHome extends StatefulWidget {
  TheHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TheHomePageState createState() => _TheHomePageState();
}

class _TheHomePageState extends State<TheHome> {

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
            title: Text('TheyLendMe')
          ),
          body: TabBarView(
            children: [
              TheObjectsTab(),
              TheGroupsTab(),
            ],
          ),

          // MENÚ LATERAL:
          //drawer: TheDrawer()

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
      )
    );
  }
}
