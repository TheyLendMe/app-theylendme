import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/create_object.dart';
import 'package:TheyLendMe/pages/group_object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/pages/create_group_object.dart';
import 'package:TheyLendMe/Objects/objState.dart';


class MyGroupsObjectsPage extends StatefulWidget {

    final Group _group;
    
    MyGroupsObjectsPage(this._group);

    @override
    _MyGroupsObjectsPageState createState() => _MyGroupsObjectsPageState();
}

class _MyGroupsObjectsPageState extends State<MyGroupsObjectsPage> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // TODO te lleve al drawer inicial o a los grupos
      appBar: AppBar(
          title: const Text('Inventario'),
          
          //TODO: searchBar
        ),
      body: FutureBuilder<List<Obj>>(
          future: widget._group.getObjects(),
          builder: (context,snapshot){
            return (snapshot.hasData
            ?
            ListView.builder( //ListView de ejemplo:
            itemBuilder: (BuildContext context, int index) => ObjectItem(snapshot.data[index]),
            itemCount: snapshot.data.length)
            : Center(child: CircularProgressIndicator()));
          }
      ),
      // TODO esconder el boton si no eres miembro
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add, color: Theme.of(context).primaryColor),
        onPressed: (){
          showDialog(
            context: this.context,
            builder: (BuildContext context){
              return CreateGroupObject(widget._group);
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
  final GroupObject object;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return GroupObjectDetails(object);
          }
        );
      },
      child: ListTile(
        leading: new Container(
          child: new Text(getFirstCharacter(object.name)), //just the initial letter in a circle
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
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
              SizedBox(
                  width: 150.0,
                  child: textNameAmount(object, context)
                ),
                SizedBox(
                  width: 100.0,
                  child: textState(object)
                )
            ]
          )
        ) //title (Container)
      ) //ListTile
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
    return Text( 'Prestado', style: TextStyle(color: Colors.red) );
  else
    return Text( 'Reclamado', style: TextStyle(color: Colors.yellow) );
}

String getFirstCharacter(String getFirstCharacter){
  //Un poco feo [\u{1F600}-\U+E007F]
  var regex = '[\u{1F600}\\-\\u{E007F}]';
  String textWithoutEmojis = getFirstCharacter.replaceAll(new RegExp(regex), '');
  return textWithoutEmojis[0];}
