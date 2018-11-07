import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

/*
//FIXME
*/

class CreateObject extends StatefulWidget {
  CreateObject();

  @override
    _CreateObjectState createState() => _CreateObjectState();
}

class _CreateObjectState extends State<CreateObject> {
    @override
    Widget build(BuildContext context) {
      return SimpleDialog(
        title: new Text('Crea tu objeto'),
        children: <Widget>[
          new TextField(
            decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Nombre del objeto')),
          /*new Container(
            child: new Center(
              child: SaleONoLaImagen(),
            )
          ),*/ //FIXME
          new TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Descripción del objeto'
            )
          ),
          new FlatButton(
            child: new Text('Crear'),
          onPressed: (){
            //Aqui mandamos cosas a la base de datos
          Navigator.of(context).pushNamed('/MyObjectsPage');
          })
        ],
      );
    }
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
  File galleryFile;
  File cameraFile;
  galleryPicker() async{
    print("GalleryPick llamado");
    galleryFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(galleryFile != null){
      setState(() {});
    }
  }
  cameraPicker() async{
    print("CameraPick llamado");
    cameraFile = await ImagePicker.pickImage(source: ImageSource.camera);
    displaySelectedFile(cameraFile);
    if(cameraFile != null){
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
     return new Scaffold(
      body: new Builder(
        builder: (BuildContext context) {
          return new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new RaisedButton(
                child: new Text('Select Image from Gallery'),
                onPressed: galleryPicker(),
              ),
              new RaisedButton(
                child: new Text('Select Image from Camera'),
                onPressed: cameraPicker(),
              ),
              displaySelectedFile(galleryFile),
              displaySelectedFile(cameraFile)
            ],
          );
        },
      ),
    );
  }
   Widget displaySelectedFile(File file){
    return new SizedBox(
      height: 70.0,
      width: 70.0,
      child: file == null
          ? new Text('Nada seleccionado')
          : new Image.file(file),
    );
  }
}