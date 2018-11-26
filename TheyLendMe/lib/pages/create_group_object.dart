import 'package:flutter/material.dart';
import 'package:TheyLendMe/Utilities/pickImage.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'dart:io';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:TheyLendMe/pages/group_objects.dart';

/*
Widget displaySelectedFile(){
  return SizedBox(
    height: 70.0,
    width: 70.0,
    child: Container(
      child: file == null
        ? Text('Nada seleccionado')
        : Image.file(file),
    ),
  );
}
*/

class CreateGroupObject extends StatefulWidget {

  final Group _group;

  CreateGroupObject(this._group);

  @override
    _CreateGroupObjectState createState() => _CreateGroupObjectState();
}

class _CreateGroupObjectState extends State<CreateGroupObject> {
  File _image;
  int _currentAmount = 1;

  void _showNumberPicker() {
      showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 100,
            title: Text("Elige una cantidad"),
            initialIntegerValue: _currentAmount
          );
        }
      ).then<void>((int value) {
        if (value != null) {
          setState(() { _currentAmount = value;});
        }
      });
    }
/*
  void galleryPicker() async{
   
  }

 
  void cameraPicker() async{
    _image = (await PickImage.getImageFromCamera());
  }
*/
  final myController = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Crear un objeto', style: Theme.of(context).textTheme.title),
            IconButton(
              icon: new Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(null),
            ),
          ]
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Escribe el nombre del objeto'),
                style: Theme.of(context).textTheme.subtitle,
                validator:  _validateName,
                controller: myController,
                //TODO limitar nombre en el interfaz
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Escribe una descripción del objeto'),
                style: Theme.of(context).textTheme.subtitle,
                validator: _validateDescription,
                controller: myController2,
              ),
            ]
          )
        ),
        Container(
          constraints: BoxConstraints.expand(
            height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
          ),
          alignment: Alignment.center,
          child: Stack(
            children:[
              SizedBox( width: 180, height: 180,
                child: MaterialButton(
                  color: Colors.grey,
                  child: Icon(Icons.photo_camera),
                  onPressed: () async {_image = (await PickImage.getImageFromCamera());}
                )
              ),
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: new FloatingActionButton(
                  child: Text('x${_currentAmount}', style: Theme.of(context).textTheme.title),
                  backgroundColor: Theme.of(context).accentColor,
                  onPressed: _showNumberPicker
                ),
              ),
            ]
          )
        ),
        Container(
          constraints: BoxConstraints.expand(
            height: Theme.of(context).textTheme.display1.fontSize * 1.5,
          ),
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            height: 42.0,
            onPressed:() async {
              if(myController.text.isNotEmpty){
                if(_image == null && myController2.text == null){
                  await widget._group.addObject(myController.text, _currentAmount);
                } else if(myController2.text == null && _image != null){
                  await widget._group.addObject(myController.text, _currentAmount,img: _image);
                } else if (myController2.text != null && _image == null){
                  await widget._group.addObject(myController.text, _currentAmount,desc: myController2.text);
                } else if(myController2.text != null && _image != null){
                  await widget._group.addObject(myController.text, _currentAmount,img: _image,desc: myController2.text);
                  }
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (BuildContext context) => new MyGroupObjectsPage(widget._group)
                ),
                ModalRoute.withName('/'));
                // TODO: evitar que se vuelva a crear objeto al echar atrás
                /*push(context, MaterialPageRoute(
                  builder: (BuildContext context) => new MyGroupObjectsPage(widget._group)
                ));*/
            } else {
              Fluttertoast.showToast(msg: "Rellena el nombre",toastLength: Toast.LENGTH_SHORT);
            }},
            color: Theme.of(context).buttonColor,
            child: Text('Crear objeto', style: TextStyle(color: Theme.of(context).accentColor)),
          )
        )
      ]
    );
  }
}

String _validateName(String value) {
  return RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value) ? null : 'Nombre no válido';
}

String _validateDescription(String value) {
  return RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value) ? null : 'Descripción no válida';
}
