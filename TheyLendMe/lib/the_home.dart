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
                Tab(icon: Text('OBJETOS', style: TextStyle(color: Colors.white))),
                Tab(icon: Text('GRUPOS', style: TextStyle(color: Colors.white))),
              ],
            ),
            title: Text('TheyLendMe', style: TextStyle(color: Colors.white))
          ),
          body: TabBarView(
            children: [
              TheObjectsTab(),
              TheGroupsTab(),
            ],
          ),

          // MENÚ LATERAL:
          drawer: TheDrawer()
        )
      )
    );
  }
}
