import 'package:flutter/material.dart';

// Dudas:
// - siempre "return MaterialApp"?
// - "tabs: [Tab(), Tab()]" o "tabs: [new Tab(), new Tab()]"?

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
                Tab(icon: Text('OBJETOS')),
                Tab(icon: Text('GRUPOS')),
              ],
            ),
            title: Text(widget.title),
          ),
          body: TabBarView(
            children: [
              TheGridView(),
              TheGridView(),
            ],
          ),
        ),

      ),
    );
  }
}

class TheGridView extends StatefulWidget {
    @override
    _TheGridViewState createState() => new _TheGridViewState();
}

class _TheGridViewState extends State<TheGridView> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: GridView.count( //GridView de ejemplo:
          crossAxisCount: 2,
          children: List.generate(100, (index) {
            return Center(
              child: Text( 'Item $index', style: Theme.of(context).textTheme.headline, ),
            );
          }),
        ),
      ),
    );
  }
}