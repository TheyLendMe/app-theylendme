import 'package:flutter/material.dart';

class ObjectPage extends StatefulWidget {
  final Image _img;

  ObjectPage(
    this._img
  );

  @override
    _ObjectPageState createState() => _ObjectPageState();
}

class _ObjectPageState extends State<ObjectPage> {
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