import 'package:flutter/material.dart';
import 'package:flutter_app/the_home.dart';

void main() => runApp(TheApp());

class TheApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app de préstamos',
      theme: ThemeData( primarySwatch: Colors.blue, ),
      home: TheHome(title: 'Home'),
    );
  }
}
