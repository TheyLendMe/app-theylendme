import 'package:flutter/material.dart';

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
      drawer: TheDrawer(),
    );
  }
}

// MENÚ LATERAL
class TheDrawer extends StatefulWidget {
  @override
  _TheDrawerState createState() => _TheDrawerState();
}

// Contenido del MENÚ LATERAL
class _TheDrawerState extends State<TheDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () { Navigator.pop(context); },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () { Navigator.pop(context); },
          ),
        ],
      ),
    );
  }
}

// Pestaña OBJETOS
class TheGridView extends StatefulWidget {
    @override
    _TheGridViewState createState() => _TheGridViewState();
}

// CONTENIDO de la pestaña OBJETOS
class _TheGridViewState extends State<TheGridView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GridView.count( //GridView de ejemplo:
        crossAxisCount: 2,
        children: List.generate(100, (index) {
          return Center(
            child: Text( 'Item $index', style: Theme.of(context).textTheme.headline, ),
          );
        }),
      ),
    );
  }
}

// Pestaña GRUPOS
class TheListView extends StatefulWidget {
    @override
    _TheListViewState createState() => _TheListViewState();
}

// CONTENIDO de la pestaña GRUPOS
class _TheListViewState extends State<TheListView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: ListView.builder( //ListView de ejemplo:
          itemBuilder: (BuildContext context, int index) =>
              EntryItem(groups[index]),
          itemCount: groups.length,
        ),
    );
  }
}

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
