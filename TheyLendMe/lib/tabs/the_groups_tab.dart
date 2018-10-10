import 'package:flutter/material.dart';

// Pestaña GRUPOS
class TheGroupsTab extends StatefulWidget {
    @override
    _TheGroupsTabState createState() => _TheGroupsTabState();
}

// CONTENIDO de la pestaña GRUPOS
class _TheGroupsTabState extends State<TheGroupsTab> {
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