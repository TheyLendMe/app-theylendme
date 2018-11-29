import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/pages/contact_dialog.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

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
              backgroundImage: (widget._user.img!=null ? NetworkImage(widget._user.img) : AssetImage('images/def_user_pic.png')),
              backgroundColor: Theme.of(context).accentColor
            )
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.5,
              ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: (widget._user.name!=null
              ? Text(widget._user.name, style: Theme.of(context).textTheme.title)
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
                  showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return ContactDialog(widget._user);
                  }
                );} else{
                  Navigator.of(context).pushNamed("/AuthPage");
                }
              },
              color: Theme.of(context).buttonColor,
              child: Text('Contactar', style: TextStyle(color: Colors.white)),
            )
          ),
          MaterialButton(
            height: 60.0,
            onPressed:(){
              Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) {
                  
                },
              ));
            },
            color: Theme.of(context).indicatorColor,
            child: Text('Ver Inventario', style: TextStyle(color: Colors.black)),
          )
        ]
      );
    }
}