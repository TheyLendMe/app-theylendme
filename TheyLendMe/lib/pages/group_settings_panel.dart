import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'group_members_tab.dart';
import 'general_group_settings_tab.dart';

class GroupSettingsPanel extends StatefulWidget {
  
  final Group _group;

  GroupSettingsPanel(this._group);

  @override
    _GroupSettingsPanelState createState() => _GroupSettingsPanelState();

}

class _GroupSettingsPanelState extends State<GroupSettingsPanel> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Text('GENERAL', style: TextStyle(color: Colors.white))),
                Tab(icon: Text('MIEMBROS',style: TextStyle(color: Colors.white))),
              ],
            ),
            title: Text('Panel de ajustes', style: TextStyle(color: Colors.white)),
          ),
          body: TabBarView(
            children: [
              GeneralGroupSettingsTab(widget._group),
              GroupMembersTab(widget._group)
            ],
          ),
        ),
      ),
    );
  }
    
}