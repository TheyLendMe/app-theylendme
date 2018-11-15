import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/pages/user_details.dart';
import 'package:TheyLendMe/pages/contact_dialog.dart';

class ObjectDetails extends StatefulWidget {
  final Obj _object;

  ObjectDetails(this._object);

  @override
    _ObjectDetailsState createState() => _ObjectDetailsState();
}

class _ObjectDetailsState extends State<ObjectDetails> {
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
            child: Stack(
              children:[
                Image.network(widget._object.image),
                Positioned(
                  right: 0.0,
                  bottom: 0.0,
                  child: new FloatingActionButton(
                    child: Text('x2', style: Theme.of(context).textTheme.title),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                ),
              ]
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget._object.name, style: Theme.of(context).textTheme.title),
                Text(' de ', style: Theme.of(context).textTheme.subtitle),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return UserDetails(widget._object.owner);
                      }
                    );
                  },
                  child: Text(widget._object.owner.name, style: Theme.of(context).textTheme.subtitle)
                )
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
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return ContactDialog(widget._object.owner);
                  }
                );
              },
              color: Theme.of(context).buttonColor,
              child: Text('Contactar', style: TextStyle(color: Theme.of(context).accentColor)),
            )
          )
        ]
      );
    }
}