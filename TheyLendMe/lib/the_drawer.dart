import 'package:flutter/material.dart';

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
            child: Text('MiNombre'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Mis Objetos'),
            onTap: () { Navigator.pop(context); },
          ),
          ListTile(
            title: Text('Mis Préstamos'),
            onTap: () { Navigator.pop(context); },
          ),
          ListTile(
            title: Text('Mis Grupos'),
            onTap: () { Navigator.pop(context); },
          ),
          ListTile(
            title: Text('Ajustes'),
            onTap: () { Navigator.pop(context); },
          ),
        ],
      ),
    );
  }
}