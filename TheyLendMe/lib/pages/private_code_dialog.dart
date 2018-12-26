import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrivateCodeDialog extends StatefulWidget {
  final Entity _entity;
  final Group _group;

  PrivateCodeDialog(this._entity,this._group);

  @override
    _PrivateCodeDialogState createState() => _PrivateCodeDialogState();
}

class _PrivateCodeDialogState extends State<PrivateCodeDialog> {
  Widget dialog;
  bool isUser = true;
  String _privateCode;

  @override
  Widget build(BuildContext context) {
    isUser = widget._entity.type == EntityType.USER;

    return FutureBuilder<Entity>(
      future: isUser ? (widget._entity as User).getEntityInfo() :  (widget._entity as Group).getEntityInfo() ,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          dialog = new SimpleDialog(
            title: Text('Compartir a través de...'),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (snapshot.data.email!=''
                    ? SimpleDialogOption(
                      onPressed: () async {
                        _privateCode = await widget._group.getPrivateCode();
                        launch('mailto:${snapshot.data.email}?subject=Código&body=Hola!%20Aquí%20tienes%20el%20código%20para%20unirte%20a%20nuestro%20grupo%20de%20TheyLendMe%20:%20$_privateCode');
                      },
                      child: Icon( FontAwesomeIcons.at, color: Colors.black,  size: 50.0),
                    ): Text('') //esto nunca se mostrará porque siempre hay email
                  ),
                  (snapshot.data.tfno!=''
                    ? SimpleDialogOption(
                      //TODO: check first if it's on WhatsApp
                      onPressed: () {
                        widget._group.getPrivateCode()
                        .then((code) {
                          _privateCode = code;
                        });
                        launch('https://wa.me/${snapshot.data.tfno}/?text=Hola!%20Aquí%20tienes%20el%20código%20para%20unirte%20a%20nuestro%20grupo%20de%20TheyLendMe%20:%20$_privateCode');},
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