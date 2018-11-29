import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/create_object.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'package:TheyLendMe/Objects/entity.dart'; // provisional
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//TODO: alinear todo (como una tabla)

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
      body: FutureBuilder<List<Obj>>(
          future: UserSingleton().user.getObjects(),
          builder: (context,snapshot) {
            return (snapshot.hasData
            ?
            ListView.builder(
              itemBuilder: (BuildContext context, int index) => ObjectItem(snapshot.data[index]),
              itemCount: snapshot.data.length
            )

            : Center(child: CircularProgressIndicator()));
          }
      ),

      
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add, color: Colors.black),
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
          leading: Container(
          height: 40.0, width: 40.0,
          child: Text(getFirstCharacter(object.name)), //just the initial letter in a circle
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.all(
              const Radius.circular(4.0),
            ),
          ),
          padding: EdgeInsets.all(15.0),
          ), //leading (Container)
          title: new Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(object.name),
                xN( object.amount ),
                textState(object)
              ]
            ) //Row
          ) //title (Container)
        ) //ListTile
      )
    ); //GestureDetector
  }
}

Widget xN(amount) {
  if (amount>1)
    return Text('x'+amount.toString());
  else
    return Text('');
}

Text textState(object) {
  if (object.objState.state == StateOfObject.DEFAULT)
    return Text( 'Disponible', style: TextStyle(color: Colors.green) );
  else if (object.objState.state == StateOfObject.LENT)
    return Text( 'Prestado', style: TextStyle(color: Colors.red) );
  else
    return Text( 'Reclamado', style: TextStyle(color: Colors.yellow) );
}

String getFirstCharacter(String getFirstCharacter){
  //Un poco feo [\u{1F600}-\U+E007F]
  var regex = '[\u{1F600}\\-\\u{E007F}]';
  String textWithoutEmojis = getFirstCharacter.replaceAll(new RegExp(regex), '');
  return textWithoutEmojis[0];}
