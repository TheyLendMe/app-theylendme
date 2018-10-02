import 'package:flutter/material.dart';

void main() => runApp(new TheApp());

class TheApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'app de préstamos',
      theme: new ThemeData( primarySwatch: Colors.blue, ),
      home: new TheHome(title: 'Home'),
    );
  }
}

class TheHome extends StatefulWidget {
  TheHome({Key key, this.title}) : super(key: key);
  // This stateful widget is the home page of your application.

  final String title;

  @override
    _TheHomePageState createState() => new _TheHomePageState();
}

class _TheHomePageState extends State<TheHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
              ],
            ),
            title: Text('app de préstamos'),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}
