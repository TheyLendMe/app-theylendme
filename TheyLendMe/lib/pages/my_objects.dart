import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart'; // provisional
import 'dart:math'; // provisional

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
  final UserObject object;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return ObjectDetails(object);
          }
        );
      },
      child: ListTile(
        leading: new Container(
          child: new Text(object.name[0]), //just the initial letter in a circle
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.all(
              const Radius.circular(4.0),
            ),
          ),
          padding: EdgeInsets.all(16.0),
        ), //leading (Container)
        title: new Container(
          //padding: new EdgeInsets.only(left: 8.0),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(object.name),
              xN( Random().nextInt(20) ), //provisional
              Text(
                'Disponible', //provisional
                style: stateColor('Disponible') //provisional
              )
            ]
          )
        ) //title (Container)
      ) //ListTile
    ); //GestureDetector
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

final User propietario = User('1', 'Señora Propietaria',
  img: 'https://vignette.wikia.nocookie.net/simpsons/images/b/bd/Eleanor_Abernathy.png');

final List<UserObject> objects = <UserObject>[
  UserObject(1, propietario, 'cat-400', image: 'https://http.cat/400'),
  UserObject(2, propietario, 'cat-401', image: 'https://http.cat/401'),
  UserObject(3, propietario, 'cat-402', image: 'https://http.cat/402'),
  UserObject(4, propietario, 'cat-403', image: 'https://http.cat/403'),
  UserObject(5, propietario, 'cat-404', image: 'https://http.cat/404')
];
