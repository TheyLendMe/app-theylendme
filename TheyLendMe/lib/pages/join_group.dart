import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/entity.dart';



class JoinGroup extends StatefulWidget {

  JoinGroup();

  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }
  

  @override
    Widget build(BuildContext context) {
      return SimpleDialog(
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Únete a un grupo', style: Theme.of(context).textTheme.title),
            IconButton(
              icon: new Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(null),
            ),
          ]
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Introduce el código del grupo'),
                style: Theme.of(context).textTheme.subtitle,
                validator:  _validateName,
                controller: myController,
              ),
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
            onPressed:() async {
              if(myController.text.isNotEmpty){
                //UserSingleton().user.joinGroup();
                Navigator.of(context).pop(null);
              } else {
                Fluttertoast.showToast(msg: "Introduce un código",toastLength: Toast.LENGTH_SHORT);
              }
            },
            color: Theme.of(context).buttonColor,
            child: Text('Unirse', style: TextStyle(color: Colors.white)),
          )
        )
        ],
      );
    }
}

String _validateName(String value) {
  return RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value) ? null : 'Código no válido';
}