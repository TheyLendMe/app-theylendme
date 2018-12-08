import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/pages/add_number_dialog.dart';
import 'package:TheyLendMe/pages/contact_dialog.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

class MeDetails extends StatefulWidget {
  final String _tfno;
  final String _name;

  MeDetails(this._tfno,this._name);

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
              backgroundImage: (UserSingleton().user.img!=null ? NetworkImage(UserSingleton().user.img) : AssetImage('images/def_user_pic.png')),
              backgroundColor: Theme.of(context).accentColor
            )
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.5,
              ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: (widget._name!=''
              ? Text(widget._name, style: Theme.of(context).textTheme.title)
              : Text('NombreUsuario', style: Theme.of(context).textTheme.title))
          ),
          Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.5,
            ),
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              height: 42.0,
              color: Theme.of(context).buttonColor,
              child: ( widget._tfno!=''
                ? Text('Teléfono: ${widget._tfno}', style: TextStyle(color: Colors.white))
                : Text('Añadir número de teléfono', style: TextStyle(color: Colors.white)) ),
              onPressed:(){
                if(UserSingleton().login){
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      if(widget._tfno!='') {
                        return ContactDialog(UserSingleton().user);
                      } else {
                        return AddNumberDialog(UserSingleton().user);
                      }
                    }
                  );
                } else {
                  Navigator.of(context).pushNamed("/AuthPage");
                }
              },
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