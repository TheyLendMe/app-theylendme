import 'package:flutter/material.dart';

import 'package:TheyLendMe/tabs/own_inventory_tab.dart';
import 'package:TheyLendMe/tabs/others_inventory_tab.dart';

class MyInventoryPage extends StatefulWidget {

    @override
    _MyInventoryPageState createState() => _MyInventoryPageState();
}

class _MyInventoryPageState extends State<MyInventoryPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Mi Inventario', style: TextStyle(color: Colors.white)),
            bottom: TabBar(
              tabs: [
                Tab(icon: Text('PROPIOS', style: TextStyle(color: Colors.white))),
                Tab(icon: Text('AJENOS', style: TextStyle(color: Colors.white))),
              ]
            )
            //TODO: searchBar
          ),
          body: TabBarView(
            children: [
              OwnInventoryTab(),
              OthersInventoryTab()
            ]
          )
        )
      )
    );
  }
}
