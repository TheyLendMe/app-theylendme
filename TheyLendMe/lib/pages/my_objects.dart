import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MyObjectsPage extends StatefulWidget {
    @override
    _MyObjectsPageState createState() => _MyObjectsPageState();
}

class _MyObjectsPageState extends State<MyObjectsPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text('Mis Objetos'),
          //TODO: searchBar
        ),
      body: ListView.builder( //ListView de ejemplo:
        itemBuilder: (BuildContext context, int index) => ObjectItem(objects[index]),
        itemCount: objects.length
      ),

      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add,color: Colors.white),
        onPressed: (){
          showDialog(
            context: this.context,
            builder: (BuildContext context){
              return SimpleDialog(
                title: new Text('Crea tu objeto'),
                children: <Widget>[
                  new TextField(
                    decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nombre del objeto')),
                  //new Image.network('https://wakyma.com/blog/wp-content/uploads/2017/10/Tipos-de-diarrea-en-gatos-y-su-tratamiento-770x460.'),
                  new Container(
                    child: new Center(
                      child: SaleONoLaImagen(),
                    )
                  ),
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
          );
          
        },
      ),    
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
  //File galleryFile;
  File cameraFile;

  /*galleryPicker() async{
    print("GalleryPick llamado");
    galleryFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(galleryFile != null){
      setState(() {});
    }
  }*/
  cameraPicker() async{
    print("CameraPick llamado");
    cameraFile = await ImagePicker.pickImage(source: ImageSource.camera);
    displaySelectedFile(cameraFile);
    if(cameraFile != null){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
      child: new Icon(Icons.photo_camera),
      onPressed: cameraPicker(),
    );
  }

  /*@override
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
  }*/

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
// Displays one Object.
class ObjectItem extends StatelessWidget {

  const ObjectItem(this.object);
  final Object object;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new CircleAvatar(
          child: new Text(object.title[0]), //just the initial letter in a circle
          backgroundColor: Colors.yellow
        ),
      title: new Container(
        //padding: new EdgeInsets.only(left: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(object.title),
            xN(object.amount),
            Text(
              object.state,
              style: stateColor(object.state)
            )
          ]
        )
      )
    );
  }
}

Widget xN(amount) {
  if (amount>1)
    return Text('x'+amount.toString());
  else
    return Text('');
}

TextStyle stateColor(state) {
  if (state=='Disponible')
    return TextStyle(color: Colors.green);
  else if (state=='Prestado')
    return TextStyle(color: Colors.red);
}

class Object {
  Object(
    this.title,
    this.amount,
    this.state,
  );

  final String title;
  final int amount;
  final String state;
}

final List<Object> objects = <Object>[
  Object('Cosa',1,'Disponible'),
  Object('Bici',1,'Prestado'),
  Object('Pelota',5,'Disponible'),
  Object('Pelota',2,'Prestado')
];
