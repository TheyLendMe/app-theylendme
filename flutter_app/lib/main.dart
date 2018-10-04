import 'package:flutter/material.dart';

// Dudas:
// - siempre "return MaterialApp"?

void main() => runApp(TheApp());

class TheApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app de préstamos',
      theme: ThemeData( primarySwatch: Colors.blue, ),
      home: TheHome(title: 'Home'),
    );
  }
}

class TheHome extends StatefulWidget {
  TheHome({Key key, this.title}) : super(key: key);
  // This stateful widget is the home page of your application.

  final String title;

  @override
    _TheHomePageState createState() => _TheHomePageState();
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
              TheListView(),
            ],
          ),
        ),

      ),
    );
  }
}

class TheGridView extends StatefulWidget {
    @override
    _TheGridViewState createState() => _TheGridViewState();
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

class TheListView extends StatefulWidget {
    @override
    _TheListViewState createState() => _TheListViewState();
}

class _TheListViewState extends State<TheListView> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: ListView.builder( //ListView de ejemplo:
          itemBuilder: (BuildContext context, int index) =>
              EntryItem(groups[index]),
          itemCount: groups.length,
        ),
      ),
    );
  }
}

class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

final List<Entry> groups = <Entry>[
  Entry('Asociación ASOC'),
  Entry('Grupo GRP'),
  Entry('Equipo C.D.EQUIPO'),
  Entry('Organización ORGANIZ'),
  Entry('Clase CLAS1'),
];

// Displays one Entry.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    return ListTile(title: Text(root.title));
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}