import 'package:flutter/material.dart';

class SettingsFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // WIP: implement build
    return Scaffold (
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            EntryItem(fields[index]),
        itemCount: fields.length,
      )
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

final List<Entry> fields = <Entry> [
  Entry('Nombre'),
  Entry('Teléfono'),
  Entry('Email'),
  Entry('Descripción')
];

class Entry {
  Entry(this.title);

  final String title;
  //TODO: TextFields here
}
