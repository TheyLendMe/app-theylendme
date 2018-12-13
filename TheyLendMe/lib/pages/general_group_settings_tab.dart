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
  bool autoloan;
  // TODO: Guardarlo siempre primero, FutureBuilder pidiendo getEntityInfo
  
  void groupInfo(){
    FutureBuilder<Group>(
      future: widget._group.getEntityInfo(),
      builder: (context,snapshot){
        return (snapshot.hasData
          ? (){
            group = snapshot.data;
            private = snapshot.data.private;
            autoloan = snapshot.data.autoloan;
          }
          : Center(child: CircularProgressIndicator(),));
      },
    );
  }

  GeneralGroupSettingsTabState(this.group){private = group.private;autoloan = group.autoloan;}
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
          SwitchListTile(
            title: const Text('Permitir autopréstamo'),
            value: autoloan,
            onChanged: (bool newValue) async {
                setState(() {autoloan = newValue;}); 
                group.updateInfo(autoloan: newValue).then((error){
                  if(!error){
                     group.autoloan = autoloan;
                  }else{
                    setState(() {autoloan = group.autoloan;}); 
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
                widget._group.leaveGroup().then((hasError){
                  if(!hasError){ Navigator.of(context).pop(); }
                });
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