import 'package:flutter/material.dart';

class ObjectDetails extends StatefulWidget {
  final Image _img;

  ObjectDetails(
    this._img
  );

  @override
    _ObjectDetailsState createState() => _ObjectDetailsState();
}

class _ObjectDetailsState extends State<ObjectDetails> {
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