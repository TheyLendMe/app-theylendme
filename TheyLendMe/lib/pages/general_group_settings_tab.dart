import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:flutter/cupertino.dart';
import 'private_code_dialog.dart';

class GeneralGroupSettingsTab extends StatefulWidget {
  
  final Group _group;
  GeneralGroupSettingsTab(this._group);

  @override
  GeneralGroupSettingsTabState createState() => GeneralGroupSettingsTabState(_group);
}

class GeneralGroupSettingsTabState extends State<GeneralGroupSettingsTab> {
  Group group;
  bool private;
  GeneralGroupSettingsTabState(this.group){private = group.private;}
  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Grupo privado'),
            value: private,
            onChanged: (bool newValue) async {
                setState(() {private = newValue;}); 
                group.updateInfo(private: newValue).then((error){
                  if(!error){
                     group.private = private;
                  }else{
                    setState(() {private = group.private;}); 
                  }
                });

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