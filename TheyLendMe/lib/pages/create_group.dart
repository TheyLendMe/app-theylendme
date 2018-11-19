import 'package:flutter/material.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

//TODO: TextFormField email (mandatory), phone

class CreateGroup extends StatefulWidget {

  CreateGroup();

  @override
    _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

  final myController = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Crear un grupo', style: Theme.of(context).textTheme.title),
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
                  hintText: 'Escribe el nombre del grupo'),
                style: Theme.of(context).textTheme.subtitle,
                validator:  _validateName,
                controller: myController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Escribe una descripción del grupo'),
                style: Theme.of(context).textTheme.subtitle,
                validator: _validateDescription,
                controller: myController2,
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
              if(myController2.text == null){
                await UserSingleton().user.createGroup(groupName: myController.text);
              } else {
                await UserSingleton().user.createGroup(groupName: myController.text, info: myController2.text);
              }
              Navigator.of(context).pop(null);
            },
            color: Theme.of(context).buttonColor,
            child: Text('Crear grupo', style: TextStyle(color: Theme.of(context).accentColor)),
          )
        )
      ]
    );
  }
}

String _validateName(String value) {
  return RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value) ? null : 'Nombre no válido';
}

String _validateDescription(String value) {
  return RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value) ? null : 'Descripción no válida';
}
