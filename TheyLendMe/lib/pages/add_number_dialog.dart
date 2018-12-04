import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//TODO: TextField, _entity.updateInfo()

class AddNumberDialog extends StatefulWidget {
  final Entity _entity;

  AddNumberDialog(this._entity);

  @override
    _AddNumberDialogState createState() => _AddNumberDialogState();
}

class _AddNumberDialogState extends State<AddNumberDialog> {
  Widget dialog;
  bool isUser = true;

  @override
  Widget build(BuildContext context) {
    isUser = widget._entity.type == EntityType.USER;

    return FutureBuilder<Entity>(
      future: isUser ? (widget._entity as User).getEntityInfo() :  (widget._entity as Group).getEntityInfo() ,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          dialog = new SimpleDialog(
            title: Text('Añadir tu número de teléfono'),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (snapshot.data.email!=''
                    ? SimpleDialogOption(
                      onPressed: () {launch('mailto:${snapshot.data.email}');},
                      child: Icon( FontAwesomeIcons.at, color: Colors.black,  size: 50.0),
                    ): Text('') //esto nunca se mostrará porque siempre hay email
                  ),
                  (snapshot.data.tfno!=''
                    ? SimpleDialogOption(
                      //TODO: check first if it's on WhatsApp
                      onPressed: () {launch('https://wa.me/${snapshot.data.tfno}/?text=Hola!%20He%20visto%20algo%20tuyo%20en%20TheyLendMe%20que%20te%20quería%20pedir%20prestado:');},
                      child: Icon( FontAwesomeIcons.whatsapp, color: Colors.green,  size: 50.0),
                    ): Text('')
                  ),
                ]
              )
            ]
          );
          return dialog;
        }else{
          dialog = new SimpleDialog();
          return dialog;
        }
      }
    );
  }
}
