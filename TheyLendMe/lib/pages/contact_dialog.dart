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
    @override
    Widget build(BuildContext context) {
      return SimpleDialog(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (widget._entity.email!=null
                ? SimpleDialogOption(
                  onPressed: () {launch('mailto:${widget._entity.email}');},
                  child: Icon( FontAwesomeIcons.at, color: Colors.black,  size: 20.0),
                ): Text('') //esto nunca se mostrará porque siempre hay email
              ),
              (widget._entity.tfno!=null
                ? SimpleDialogOption(
                  //TODO: check first if it's on WhatsApp
                  onPressed: () {launch('https://wa.me/${widget._entity.tfno}');},
                  child: Icon( FontAwesomeIcons.whatsapp, color: Colors.green,  size: 20.0),
                ): Text('')
              ),
            ]
          )
        ]
      );
    }
}
