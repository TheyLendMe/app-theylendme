import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/pages/contact_dialog.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

class GroupDetails extends StatefulWidget {
  final Group _group;

  GroupDetails(this._group);

  @override
    GroupDetailsState createState() => GroupDetailsState();
}

class GroupDetailsState extends State<GroupDetails> {
    @override
    Widget build(BuildContext context) {
      return SimpleDialog(
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
            child: Image.network(widget._group.img) //TODO: circular
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(widget._group.name, style: Theme.of(context).textTheme.title),
                Text(widget._group.info, style: Theme.of(context).textTheme.subtitle)
              ]
            )
          ),
          Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.5,
            ),
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              height: 42.0,
              onPressed:(){
                if(!UserSingleton().login)
                  Navigator.of(context).pushNamed("/AuthPage");
                else {
                  showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return ContactDialog(widget._group);
                  }
                );}
              },
              color: Theme.of(context).buttonColor,
              child: Text('Contactar', style: TextStyle(color: Theme.of(context).accentColor)),
            )
          ),
          Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.5,
            ),
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              height: 42.0,
              onPressed:(){}, //TODO acción de ver miembros
              color: Theme.of(context).buttonColor,
              child: Text('Ver Miembros', style: TextStyle(color: Theme.of(context).accentColor)),
            )
          ),
          MaterialButton(
            height: 42.0, //TODO: pegar al borde inferior
            onPressed:(){},
            color: Theme.of(context).indicatorColor,
            child: Text('Ver Inventario', style: TextStyle(color: Theme.of(context).primaryColor)),
          )
        ]
      );
    }
}