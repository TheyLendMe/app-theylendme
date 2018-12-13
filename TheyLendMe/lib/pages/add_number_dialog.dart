import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

class AddNumberDialog extends StatefulWidget {
  final Entity _entity;

  AddNumberDialog(this._entity);

  @override
    _AddNumberDialogState createState() => _AddNumberDialogState();
}

class _AddNumberDialogState extends State<AddNumberDialog> {
  Widget dialog;
  bool isUser = true;
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    isUser = widget._entity.type == EntityType.USER;

    return FutureBuilder<Entity>(
      future: isUser ? (widget._entity as User).getEntityInfo() :  (widget._entity as Group).getEntityInfo() ,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          dialog = new SimpleDialog(
            title: Text('Añadir teléfono'),
            children: [
              Form(
                key: _formKey,
                child: Column ( children: [
                  Icon( FontAwesomeIcons.whatsapp, color: Colors.green,  size: 50.0),
                  TextFormField(
                    decoration: InputDecoration( hintText: '  Escribe tu número de teléfono' ),
                    style: Theme.of(context).textTheme.subtitle,
                    validator: _validatePhoneNumber,
                    controller: myController,
                  ),
                  Text('\nSolo usaremos tu número\npara que los demás usuarios puedan\ncontactar contigo por Whatsapp.\n', textAlign: TextAlign.center),
                  MaterialButton(
                    height: 42.0,
                    onPressed: _validateForm,
                    color: Theme.of(context).buttonColor,
                    child: Text('Guardar', style: TextStyle(color: Colors.white))
                  )
                ])
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

  void _validateForm() async {
    if (_formKey.currentState.validate()) {
      await UserSingleton().user.updateInfo(tfno: myController.text);
      Navigator.of(context).pop(null);
    }
  }

  String _validatePhoneNumber(String value) {
    if (value.length==9) {
      return RegExp(r"^[0-9]+$").hasMatch(value) ? null : 'Número de teléfono inválido';
    } else {
      return 'Un número de teléfono debe tener 9 dígitos';
    }
  }
}
