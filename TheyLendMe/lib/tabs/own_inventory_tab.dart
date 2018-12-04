import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/create_object.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'package:TheyLendMe/Objects/entity.dart'; // provisional
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// Pestaña PROPIOS
class OwnInventoryTab extends StatefulWidget {
    @override
    _OwnInventoryTabState createState() => _OwnInventoryTabState();
}

// CONTENIDO de la pestaña PROPIOS
class _OwnInventoryTabState extends State<OwnInventoryTab> {


  Future<List<Obj>> getOwnInventory() async {
    List<Obj> claims = await UserSingleton().user.getClaimsMeToOthers();
    List<Obj> objects = (await UserSingleton().user.getEntityInventory())['mines'];
    List<Obj> l = new List();

    l.addAll(claims);
    for(int i = objects.length-1; i >= 0; i-- ){
      if(objects[i].actualAmount > 0){
        l.add(objects[i]);
      }
    }

    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Obj>>(
        future: getOwnInventory(),
        builder: (context,snapshot) {
          return (snapshot.hasData
          ?
          ListView.builder(
            itemBuilder: (BuildContext context, int index) => ObjectItem(snapshot.data[index]),
            itemCount: snapshot.data.length
          )
          : Center(child: CircularProgressIndicator())); //TODO: what to do if there's no user objects?
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
      )
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
            child: (object.image!=null
              ? Image.network(object.image, width: 30)
              : Image.asset('images/def_obj_pic.png', width: 30)),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0)
            )
          ),
          title: new Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150.0,
                  child: textNameAmount(object, context)
                ),
                SizedBox(
                  width: 100.0,
                  child: textState(object)
                )
              ]
            ) //Row
          ) //title (Container)
        ) //ListTile
      )
    ); //GestureDetector
  }
}

Widget textNameAmount(object, context) {
  if (object.amount>1)
    return RichText( text: TextSpan(
      children:[
        TextSpan(text: object.name.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.15)),
        TextSpan(text: ' (x'+object.amount.toString()+')', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.15, color: Colors.grey[500]))
      ]
    ));
  else
    return RichText( text: TextSpan(
      children:[
        TextSpan(text: object.name.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.15))
      ]
    ));
}

Text textState(object) {
  if (object.objState.state == StateOfObject.DEFAULT)
    return Text( 'Disponible', style: TextStyle(color: Colors.green) );
  else if (object.objState.state == StateOfObject.LENT)
    return Text( 'Prestado', style: TextStyle(color: Colors.yellow) );
  else
    return Text( 'Reclamado', style: TextStyle(color: Colors.red) );
}

String getFirstCharacter(String getFirstCharacter){
  //Un poco feo [\u{1F600}-\U+E007F]
  var regex = '[\u{1F600}\\-\\u{E007F}]';
  String textWithoutEmojis = getFirstCharacter.replaceAll(new RegExp(regex), '');
  return textWithoutEmojis[0];}
