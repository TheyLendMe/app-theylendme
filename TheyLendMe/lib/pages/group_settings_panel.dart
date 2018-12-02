import 'package:flutter/material.dart';


class GroupSettingsPanel extends StatefulWidget {
    
  @override
    _GroupSettingsPanelState createState() => _GroupSettingsPanelState();

}

class _GroupSettingsPanelState extends State<GroupSettingsPanel> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de ajustes'),
      ),
    );
  }
    
}