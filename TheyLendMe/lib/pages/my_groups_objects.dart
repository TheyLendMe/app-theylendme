import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/create_object.dart';
import 'package:TheyLendMe/pages/group_object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/pages/create_group_object.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'package:TheyLendMe/pages/object_details.dart';


class MyGroupsObjectsPage extends StatefulWidget {

    final Group _group;
    
    MyGroupsObjectsPage(this._group);

    @override
    _MyGroupsObjectsPageState createState() => _MyGroupsObjectsPageState();
}

class _MyGroupsObjectsPageState extends State<MyGroupsObjectsPage> {
   Future<List<Obj>> getOwnInventory() async {
    List<Obj> claims = await widget._group.getClaimsMeToOthers();
    List<Obj> lends = await widget._group.getRequestsOthersToMe();
    List<Obj> objects = (await widget._group.getEntityInventory())['mines'];
    List<Obj> l = new List();

    l.addAll(claims);
    for(int i = objects.length-1; i >= 0; i-- ){
      // for(int j = 0; i < claims.length; i++){
      //   if(objects[i].id)
      // }
      if(objects[i].actualAmount > 0){
        l.add(objects[i]);
      }
    }
    l.addAll(lends);
    return l;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // TODO te lleve al drawer inicial o a los grupos
      appBar: AppBar(
          title: const Text('Inventario'),
          
          //TODO: searchBar
        ),
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
      // TODO esconder el boton si no eres miembro
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add, color: Colors.black),
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


Widget textNameAmount(object, context) {
  if (object.actualAmount>1)
    return RichText( text: TextSpan(
      children:[
        TextSpan(text: object.name.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.15)),
        TextSpan(text: ' (x'+object.actualAmount.toString()+')', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.15, color: Colors.grey[500]))
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

final User propietario = User(UserSingleton().user.idEntity,UserSingleton().user.name);

String getFirstCharacter(String getFirstCharacter){
  //Un poco feo [\u{1F600}-\U+E007F]
  var regex = '[\u{1F600}\\-\\u{E007F}]';
  String textWithoutEmojis = getFirstCharacter.replaceAll(new RegExp(regex), '');
  return textWithoutEmojis[0];}
