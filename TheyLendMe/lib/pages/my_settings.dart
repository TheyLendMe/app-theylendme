import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'package:TheyLendMe/Utilities/auth.dart';

import 'package:fluttertoast/fluttertoast.dart'; //provisional

/*
//TODO:
* - Validation
* - Load data from API
*/

class MySettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

//Para VALIDACIÓN
class _UserData {
  String email = '';
}

String _validateEmail(String value) {
  // If empty value, the isEmail function throw a error.
  // So I changed this function with try and catch.
  try {
    Validate.isEmail(value);
  } catch (e) {
    return 'Introduce una dirección de email válida.';
  }
  return '';
}

class _SettingsPageState extends State<MySettingsPage> {

  //VALIDACIÓN
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _UserData _data = _UserData();

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      print('Datos del usuario:');    //DEBUG
      print('Email: ${_data.email}'); //DEBUG
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: secciones: Perfil, Seguridad (contraseña)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Ajustes'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          //key: this._formKey,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                EntryItem(fields[index]),
            itemCount: fields.length,
          )
        )
      ),

      floatingActionButton: 
        Row( 
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,       
          children: <Widget>[
            FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Fluttertoast.showToast(msg: "Función disponible en versiones futuras",toastLength: Toast.LENGTH_SHORT);
              },
              child: Text("Guardar cambios", style: TextStyle(color: Colors.white)),
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () async {
                await Auth.signOut();
                Navigator.of(context).pop(null);
              },
              child: Text("Cerrar sesión"),
            )
          ]
        )
    );
  }
}

// Displays one Entry.
class EntryItem extends StatefulWidget {
  const EntryItem(this.entry);
  final Entry entry;

  @override
  State<StatefulWidget> createState() => _EntryItemState();
}

class _EntryItemState extends State<EntryItem> {
  @override
  Widget build(BuildContext context) {
    return TextFormField (
      decoration: InputDecoration (
        labelText: widget.entry.label,
        hintText: widget.entry.hint
      ),
      validator: widget.entry.validator,
      onSaved: (String value) {
        //this._email = value; //TODO: pasar '_email' como propiedad de widget.entry
        //FIXME: Error: Setter not found: '_email'.
      }
    );
  }
}

final List<Entry> fields = <Entry> [ //'_validateEmail' en todos para probar
  Entry('Nombre',     'Escribe tu nombre',_validateEmail),
  Entry('Teléfono',   'Escribe tu número de teléfono',_validateEmail),
  Entry('Email',      'tuemail@ejemplo.com',_validateEmail),
  Entry('Descripción','Escribe algo sobre ti para que los demás usuarios te conozcan mejor',_validateEmail)
];

class Entry {
  Entry(this.label, this.hint, this.validator);

  final String label;
  final String hint;
  final Function validator;
  //TODO: keyboardType?
}
