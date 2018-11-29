import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/create_object.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart'; // provisional
import 'dart:math'; // provisional
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


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
      
      body:
      FutureBuilder<List<Obj>>(
          future: UserSingleton().user.getObjects(),
          builder: (context,snapshot){
            return (snapshot.hasData
            /*
            ListView.builder(
              itemBuilder: (BuildContext context, int index) => ObjectItem(snapshot.data[index]),
              itemCount: snapshot.data.length
            )*/
            ? ObjectTile(objects: snapshot.data)
            : Center(child: CircularProgressIndicator()));
          }
      ),

      
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add, color: Theme.of(context).primaryColor),
        onPressed: (){
          showDialog(
            context: this.context,
            builder: (BuildContext context){
              return CreateObject();
            }
          );
        },
      ),
    );
  }
}

class ObjectTile extends StatelessWidget {
  final List<Obj> objects;
  ObjectTile({this.objects});

  @override
  Widget build(BuildContext context) {
    // example for StaggeredGridView: https://youtu.be/SrGP1BdkYpk
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      itemCount: objects.length,
      itemBuilder: (context, i) {
        return Material(
          elevation: 8.0,
          borderRadius:
              BorderRadius.all(Radius.circular(8.0)),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return ObjectDetails(objects[i]);
                }
              );
            },
            child: Hero(
              tag: objects[i].idObject,
              child: FadeInImage(
                image: NetworkImage(objects[i].image),
                fit: BoxFit.cover,
                placeholder: AssetImage('images/tlm.jpg'),
              )
            ),
          ),
        );
      },
      staggeredTileBuilder: (i) =>
          StaggeredTile.count(2, i.isEven ? 2 : 3),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}
// Displays one Object.
class ObjectItem extends StatelessWidget {

  const ObjectItem(this.object);
  final Obj object;

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

      child: Container(
        padding: new EdgeInsets.only(left: 8.0, top: 15.0),
        child: ListTile(
          leading: new CircleAvatar(
            child: new Text(getFirstCharacter(object.name)), //just the initial letter in a circle
            backgroundColor: Colors.yellow,          
          ),
          /*decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.all(
              const Radius.circular(4.0),
            ),
          ),
          padding: EdgeInsets.all(16.0),
        ), //leading (Container)*/
        title: new Container(
          //padding: new EdgeInsets.only(left: 8.0),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(object.name),
              xN( object.amount ),
              Text(
                object.objState.toString(),
                style: stateColor(object.objState.toString()),
              )
            ]
          )
        )
      ) //title (Container)
    ) //ListTile
  ); //GestureDetector
}}

String getFirstCharacter(String getFirstCharacter){
  //Un poco feo [\u{1F600}-\U+E007F]
  var regex = '[\u{1F600}\\-\\u{E007F}]';
  String textWithoutEmojis = getFirstCharacter.replaceAll(new RegExp(regex), '');
  return textWithoutEmojis[0];}

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
  else
    return TextStyle(color: Colors.yellow);
}
