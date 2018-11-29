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
                Tab(icon: Text('SOLICITUDES')),
                Tab(icon: Text('PRESTADOS')),
              ],
            ),
            title: Text('Mis Préstamos')
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
