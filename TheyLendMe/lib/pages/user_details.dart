import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  final Image _img;

  UserDetails(
    this._img
  );

  @override
    _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
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