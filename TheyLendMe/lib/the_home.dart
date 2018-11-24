import 'package:flutter/material.dart';

import 'package:TheyLendMe/the_drawer.dart';
import 'package:TheyLendMe/tabs/the_objects_tab.dart';
import 'package:TheyLendMe/tabs/the_groups_tab.dart';
import 'main.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_colorpicker/material_picker.dart';


class TheHome extends StatefulWidget {
  TheHome(this._theAppState,{Key key, this.title}) : super(key: key);

  final String title;
  final TheAppState _theAppState;
  @override
  _TheHomePageState createState() => _TheHomePageState();
}

class _TheHomePageState extends State<TheHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: new FloatingActionButton(
            onPressed: () async => changeColors(),
          ),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Text('OBJETOS')),
                Tab(icon: Text('GRUPOS')),
              ],
            ),
            title: Text('TheyLendMe')
          ),
          body: TabBarView(
            children: [
              TheObjectsTab(),
              TheGroupsTab(),
            ],
          ),

          // MENÚ LATERAL:
          drawer: TheDrawer()
        )
      )
    );
  }
  Color pickerColor1;
  Color pickerColor2;

  Future changeColors() async{
    await changeFirstColor();
    await changeSecondColor();
    setState(() { firstColor = pickerColor1;secondColor = pickerColor2;});
  }

  changeColorFirst(Color color) {
    widget._theAppState.setState(() => firstColor = color);
  }
 
  Future changeFirstColor() async{
    await showDialog(
    context: context,
    child: AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: MaterialPicker(
          pickerColor: firstColor == null ? Color(0xFF64b5f6) : firstColor,
          onColorChanged: changeColorFirst,
          enableLabel: true,
          ),

        // Use Material color picker
        // child: MaterialPicker(
        //   pickerColor: pickerColor,
        //   onColorChanged: changeColor,
        //   enableLabel: true, // only on portrait mode
        // ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Got it'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ], 
    ),
  );}

  changeColorSecond(Color color) {
    widget._theAppState.setState(() => secondColor = color);
  }
 
  Future changeSecondColor() async{
    await showDialog(
    context: context,
    child: AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: MaterialPicker(
          pickerColor: secondColor,
          onColorChanged: changeColorSecond,
          enableLabel: true,
          ),
        // Use Material color picker
        // child: MaterialPicker(
        //   pickerColor: pickerColor,
        //   onColorChanged: changeColor,
        //   enableLabel: true, // only on portrait mode
        // ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Got it'),
          onPressed: () {
            
            Navigator.of(context).pop();
          },
        ),
      ], 
    ),
  );}
}






