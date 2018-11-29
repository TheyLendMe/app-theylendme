import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactDialog extends StatefulWidget {
  final Entity _entity;

  ContactDialog(this._entity);

  @override
    _ContactDialogState createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
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
            title: Text('Contactar a través de...'),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (snapshot.data.email!=null
                    ? SimpleDialogOption(
                      onPressed: () {launch('mailto:${snapshot.data.email}');},
                      child: Icon( FontAwesomeIcons.at, color: Colors.black,  size: 50.0),
                    ): Text('') //esto nunca se mostrará porque siempre hay email
                  ),
                  (snapshot.data.tfno!=null
                    ? SimpleDialogOption(
                      //TODO: check first if it's on WhatsApp
                      onPressed: () {launch('https://wa.me/${snapshot.data.tfno}');},
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
