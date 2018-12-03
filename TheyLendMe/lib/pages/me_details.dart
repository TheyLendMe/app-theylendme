import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/pages/contact_dialog.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:fluttertoast/fluttertoast.dart'; //provisonal

class MeDetails extends StatefulWidget {
  final User _me;

  MeDetails(this._me);

  @override
    _MeDetailsState createState() => _MeDetailsState();
}

class _MeDetailsState extends State<MeDetails> {
    @override
    Widget build(BuildContext context) {
      return SimpleDialog(
        contentPadding: const EdgeInsets.all(0.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: new Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(null),
              ),
            ]
          ),
          Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
            ),
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 120.0,
              backgroundImage: (widget._me.img!=null ? NetworkImage(widget._me.img) : AssetImage('images/def_user_pic.png')),
              backgroundColor: Theme.of(context).accentColor
            )
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.5,
              ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: (widget._me.name!=null
              ? Text(widget._me.name, style: Theme.of(context).textTheme.title)
              : Text(''))
          ),
          Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.5,
            ),
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              height: 42.0,
              onPressed:(){
                if(UserSingleton().login){
                  ( widget._me.tfno!=null
                    ? ContactDialog(widget._me)
                    : Fluttertoast.showToast(msg: "Función disponible próximamente: añadir teléfono",toastLength: Toast.LENGTH_SHORT) );
                } else {
                  Navigator.of(context).pushNamed("/AuthPage");
                }
              },
              color: Theme.of(context).buttonColor,
              child: ( widget._me.tfno!=null
                ? Text('Teléfono: ${widget._me.tfno}')
                : Text('Añadir número de teléfono', style: TextStyle(color: Colors.white)) ),
            )
          ),
          MaterialButton(
            height: 60.0,
            onPressed:(){ Navigator.of(context).pushNamed("/MyInventoryPage"); },
            color: Theme.of(context).indicatorColor,
            child: Text('Mis Objetos', style: TextStyle(color: Colors.black)),
          )
        ]
      );
    }
}