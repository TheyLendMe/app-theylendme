import 'package:flutter/material.dart';

class LoanDetails extends StatefulWidget {
  final Image _img;

  LoanDetails(
    this._img
  );

  @override
    _LoanDetailsState createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> {
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