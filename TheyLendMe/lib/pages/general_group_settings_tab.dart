import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:flutter/cupertino.dart';
import 'private_code_dialog.dart';

class GeneralGroupSettingsTab extends StatefulWidget {
  
  final Group _group;
  GeneralGroupSettingsTab(this._group);

  @override
  _GeneralGroupSettingsTabState createState() => _GeneralGroupSettingsTabState();
}

class _GeneralGroupSettingsTabState extends State<GeneralGroupSettingsTab> {

  @override
  Widget build (BuildContext context){
    
    return Scaffold(
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Grupo privado'),
            value: widget._group.private,
            onChanged: (bool newValue) { //FIXME: si se cambia el valor no se mantiene
                widget._group.updateInfo(private: newValue);
                widget._group.private = newValue;
                setState(() {});
            },
          ),
          ListTile(
            title: Text('Compartir grupo'),
            onTap: () { 
              showDialog(
                builder: (BuildContext context){
                  return PrivateCodeDialog(widget._group, widget._group);
                },
              context: context
              );
            },
          )
        ],
      ),
    );
  }
}