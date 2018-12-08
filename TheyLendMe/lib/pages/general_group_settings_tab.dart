import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:flutter/cupertino.dart';
import 'private_code_dialog.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

class GeneralGroupSettingsTab extends StatefulWidget {
  
  final Group _group;
  GeneralGroupSettingsTab(this._group);

  @override
  GeneralGroupSettingsTabState createState() => GeneralGroupSettingsTabState(_group);
}

class GeneralGroupSettingsTabState extends State<GeneralGroupSettingsTab> {
  Group group;
  bool private;
  // TODO: Guardarlo siempre primero, FutureBuilder pidiendo getEntityInfo
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
          ),
          ListTile(
            title: Text('Abandonar grupo'),
            trailing: MaterialButton(
              onPressed: (){
                widget._group.delUser(u: UserSingleton().user);
              },
              color: Colors.red,
              child: Text('Abandonar'),
            ),
          )
        ],
      ),
    );
  }
}