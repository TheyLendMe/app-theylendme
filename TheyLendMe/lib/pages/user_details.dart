import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';

class UserDetails extends StatefulWidget {
  final User _user;

  UserDetails(this._user);

  @override
    _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
    @override
    Widget build(BuildContext context) {
      return SimpleDialog(
        //TODO: botón de cerrar
        //title: new Text('Detalles'), //TODO: poner título?
        children: [
          Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
            ),
            alignment: Alignment.center,
            child: Image.network(widget._user.img) //TODO: circular
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.5,
              ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(widget._user.name, style: Theme.of(context).textTheme.title)
          ),
          MaterialButton(
            height: 42.0, //TODO: hacer que no ocupe todo el ancho
            onPressed:(){}, //TODO acción de contactar
            color: Theme.of(context).buttonColor,
            child: Text('Contactar', style: TextStyle(color: Theme.of(context).accentColor)),
          )
        ]
      );
    }
}