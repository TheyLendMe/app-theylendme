import 'package:flutter/material.dart';
import 'package:validate/validate.dart'; //TODO: use validation logic

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    //TODO: secciones: Perfil, Seguridad (contraseña)
    return Scaffold(
      body: Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          //key: this._formKey,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                EntryItem(fields[index]),
            itemCount: fields.length,
          )
        )
      )
    );
  }
}

// Displays one Entry.
class EntryItem extends StatefulWidget {
  const EntryItem(this.entry);
  final Entry entry;

  @override
  State<StatefulWidget> createState() => new _EntryItemState();
}

class _EntryItemState extends State<EntryItem> {
  @override
  Widget build(BuildContext context) {
    return TextFormField (
      decoration: InputDecoration (
        labelText: widget.entry.label,
        hintText: widget.entry.hint
      )
    );
  }
}

final List<Entry> fields = <Entry> [
  Entry('Nombre','Escribe tu nombre'),
  Entry('Teléfono','Escribe tu número de teléfono'),
  Entry('Email','tuemail@ejemplo.com'),
  Entry('Descripción','Escribe algo sobre ti para que los demás usuarios te conozcan mejor.')
];

class Entry {
  Entry(this.label, this.hint);

  final String label;
  final String hint;
  //TODO: keyboardType?
}
