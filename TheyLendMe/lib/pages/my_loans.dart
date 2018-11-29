import 'package:flutter/material.dart';

import 'package:TheyLendMe/tabs/my_loans_tab.dart';
import 'package:TheyLendMe/tabs/my_requests_tab.dart';

class MyLoansPage extends StatefulWidget {
    @override
    _MyLoansPageState createState() => _MyLoansPageState();
}

class _MyLoansPageState extends State<MyLoansPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Text('SOLICITUDES', style: TextStyle(color: Colors.white))),
                Tab(icon: Text('PRESTADOS', style: TextStyle(color: Colors.white))),
              ],
            ),
            title: Text('Mis Préstamos', style: TextStyle(color: Colors.white)),
          ),
          body: TabBarView(
            children: [
              MyRequestsTab(),
              MyLoansTab(),
            ],
          ),
        )
      )
    );
  }
}
