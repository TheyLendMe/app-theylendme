import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/obj.dart';

class ObjectDetails extends StatefulWidget {
  final UserObject _object;

  ObjectDetails(this._object);

  @override
    _ObjectDetailsState createState() => _ObjectDetailsState();
}

class _ObjectDetailsState extends State<ObjectDetails> {
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
            child: Image.network(widget._object.image),
            //TODO: indicador xN de cantidad
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.5,
              ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(widget._object.name, style: Theme.of(context).textTheme.display1.copyWith(color: Colors.black))
                                                    //TODO: coger el color adecuadamente
          ),
          MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed:(){}, //TODO acción de contactar
            color: Color(0xFF35504d), //TODO: coger firstColor adecuadamente
            child: Text('Contactar', style: TextStyle(color: Color(0xFFf3e2bb))), //TODO: coger secondColor adecuadamente
          )
        ]
      );
    }
}