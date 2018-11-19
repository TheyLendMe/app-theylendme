import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/create_object.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart'; // provisional
import 'dart:math'; // provisional
import 'package:TheyLendMe/pages/create_group_object.dart';


class MyGroupObjectsPage extends StatefulWidget {

    final Group _group;
    
    MyGroupObjectsPage(this._group);

    @override
    _MyGroupObjectsPageState createState() => _MyGroupObjectsPageState();
}

class _MyGroupObjectsPageState extends State<MyGroupObjectsPage> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                object.objState.toString(),
                style: stateColor(object.objState.toString()) //provisional
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
  img: 'https://vignette.wikia.nocookie.net/simpsons/images/b/bd/Eleanor_Abernathy.png',
  tfno: '34606991934', email: 'sofia@adolfodominguez.com');


//Group grupo = new Group(idEntity, name);

//List<Obj> objects;



/*final List<UserObject> objects = <UserObject>[
  UserObject(1, propietario, 'cat-400', image: 'https://http.cat/400'),
  UserObject(2, propietario, 'cat-401', image: 'https://http.cat/401'),
  UserObject(3, propietario, 'cat-402', image: 'https://http.cat/402'),
  UserObject(4, propietario, 'cat-403', image: 'https://http.cat/403'),
  UserObject(5, propietario, 'cat-404', image: 'https://http.cat/404')
];*/