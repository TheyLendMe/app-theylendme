import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

/*
//WIP: adaptar el diseño al formato que teníamos pensado
*/

class CreateObject extends StatefulWidget {
  CreateObject();

  @override
    _CreateObjectState createState() => _CreateObjectState();
}

class _CreateObjectState extends State<CreateObject> {
  @override
  Widget build(BuildContext context) {
    //return SizedOverflowBox( size: Size(300,100),
    return OverflowBox( minHeight: 300, minWidth: 100,
    child:  SimpleDialog(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: new Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(null),
            ),
            Text('Crear un objeto', style: Theme.of(context).textTheme.title),
            SizedBox( width: 130, height: 130,
              child: Container(
                color: Theme.of(context).accentColor,
                child: new Icon(Icons.camera_alt)
              )
            )
          ]
        ), // end Row
        new Container(
          child: new Center(
            child: SaleONoLaImagen(),
          )
        ),
        new TextFormField(
          decoration: InputDecoration(
            hintText: 'Escribe el nombre del objeto'),
          style: Theme.of(context).textTheme.subtitle,
          validator: _validateName,
        ),
        new TextFormField(
          decoration: InputDecoration(
            hintText: 'Escribe una descripción del objeto'),
          style: Theme.of(context).textTheme.subtitle,
          validator: _validateDescription,
        ),
        //TODO: opción: [-] cantidad [+]
        new Container(
          constraints: BoxConstraints.expand(
            height: Theme.of(context).textTheme.display1.fontSize * 1.5,
          ),
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            height: 42.0,
            onPressed:(){ //Aquí mandamos cosas a la base de datos
              Navigator.of(context).pushNamed('/MyObjectsPage');
            },
            color: Theme.of(context).buttonColor,
            child: Text('Crear', style: TextStyle(color: Theme.of(context).accentColor)),
          )
        )
      ]
    ));
  }
}

String _validateName(String value) {
  try {
    //Validate.isEmail(value);
    //TODO: validar nombres
  } catch (e) {
    return 'Nombre no válido';
  }
  return '';
}

String _validateDescription(String value) {
  try {
    //Validate.isEmail(value);
    //TODO: validar descripciones
  } catch (e) {
    return 'Descripción no válida';
  }
  return '';
}

// Elegir imagen
 class SaleONoLaImagen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new CameraApp();
  }
}
class CameraApp extends StatefulWidget{
  @override
  CameraAppState createState() => CameraAppState();
}
 class CameraAppState extends State<CameraApp> {
   File file;
  void galleryPicker() async{
    print("GalleryPick llamado");
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(file != null){
      setState(() {});
    }
  }
  void cameraPicker() async{
    print("CameraPick llamado");
    file = await ImagePicker.pickImage(source: ImageSource.camera);
    if(file != null){
      setState(() {});
    }
  }
  /*@override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
      child: new Icon(Icons.photo_camera),
      onPressed: cameraPicker(),
    );
  }*/
  @override
  Widget build(BuildContext context){
     return new Container(
       child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new RaisedButton(
              child: new Text('Select Image from Gallery'),
              onPressed: galleryPicker,
            ),
            new RaisedButton(
              child: new Text('Select Image from Camera'),
              onPressed: cameraPicker,
            ),
            displaySelectedFile(),
          ],
        ),
      );
  }
   
  Widget displaySelectedFile(){
    return new SizedBox(
      height: 70.0,
      width: 70.0,
      child: new Container(
        child: file == null
          ? new Text('Nada seleccionado')
          : new Image.file(file),
      ),
    );
  }
}