import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:TheyLendMe/Objects/entity.dart';

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
        //FIXME: widget._entity.tfno, .email siempre son null (.name, .info no son null)
          (widget._entity.tfno!=null
            ? SimpleDialogOption(
              //TODO: check first if it's on WhatsApp
              onPressed: () {launch('https://wa.me/${widget._entity.tfno}');},
              child: Text('Escribir WhatsApp a ${widget._entity.tfno}'),
            ): Text('Sin WhatsApp') //TODO: cambiar esto
          ),
          (widget._entity.email!=null //FIXME: widget._entity.email siempre es null
            ? SimpleDialogOption(
              onPressed: () {launch('mailto:${widget._entity.email}');},
              child: Text('Escribir email a ${widget._entity.email}'),
            ): Text('Sin email') //TODO: cambiar esto
          )
        ]
      );
    }
}
