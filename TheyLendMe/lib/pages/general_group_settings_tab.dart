import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:flutter/cupertino.dart';

class GeneralGroupSettingsTab extends StatefulWidget {
  
  final Group _group;
  GeneralGroupSettingsTab(this._group);

  @override
  _GeneralGroupSettingsTabState createState() => _GeneralGroupSettingsTabState();
}

class _GeneralGroupSettingsTabState extends State<GeneralGroupSettingsTab> {

  bool _hola = true;

  @override
  Widget build (BuildContext context){
    
    return Scaffold(
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Grupo privado'),
            value: _hola,
            onChanged: (bool newValue) {
              setState(() {
                _hola = newValue;
                //widget._group.updateInfo(private: newValue); 
              });
            },
          ),
          ListTile(

          )
        ],
      ),
    );
  }
}