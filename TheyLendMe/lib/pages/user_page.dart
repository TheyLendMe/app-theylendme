import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final Image _img;

  UserPage(
    this._img
  );

  @override
    _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
    @override
    Widget build(BuildContext context) {
      return SimpleDialog(
        //title: new Text('Detalles'),
        children: [
          new Center(
            child: widget._img
          )
        ]
      );
    }
}