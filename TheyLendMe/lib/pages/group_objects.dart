import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/create_object.dart';
import 'package:TheyLendMe/pages/group_object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart'; // provisional
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'dart:math'; // provisional
import 'package:TheyLendMe/pages/create_group_object.dart';


class OtherGroupObjectsPage extends StatefulWidget {

    final Group _group;
    
    OtherGroupObjectsPage(this._group);

    @override
    _OtherGroupObjectsPageState createState() => _OtherGroupObjectsPageState();
}

class _OtherGroupObjectsPageState extends State<OtherGroupObjectsPage> {
  
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
          child: new Text(object.name[0]), //just the initial letter in a circle
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
              Text(object.name),
              xN( object.amount ), //provisional
              Text(
                object.objState.state.toString(),
                style: stateColor(object.objState.toString())
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

/*final User propietario = User('1', 'Señora Propietaria',
  img: 'https://vignette.wikia.nocookie.net/simpsons/images/b/bd/Eleanor_Abernathy.png',
  tfno: '34606991934', email: 'sofia@adolfodominguez.com');
*/

final User propietario = User(UserSingleton().user.idEntity,UserSingleton().user.name);
//Group grupo = new Group(idEntity, name);

//List<Obj> objects;



/*final List<UserObject> objects = <UserObject>[
  UserObject(1, propietario, 'cat-400', image: 'https://http.cat/400'),
  UserObject(2, propietario, 'cat-401', image: 'https://http.cat/401'),
  UserObject(3, propietario, 'cat-402', image: 'https://http.cat/402'),
  UserObject(4, propietario, 'cat-403', image: 'https://http.cat/403'),
  UserObject(5, propietario, 'cat-404', image: 'https://http.cat/404')
];*/