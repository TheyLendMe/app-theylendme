import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/object_details.dart';

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
      )
    );
  }
}

// Displays one Object.
class ObjectItem extends StatelessWidget {

  const ObjectItem(this.object);
  final Object object;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return ObjectDetails(object.img);
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
              xN(object.amount),
              Text(
                object.state,
                style: stateColor(object.state)
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

class Object {
  Object(
    this.name,
    this.amount,
    this.state,
    this.img
  );

  final String name;
  final int amount;
  final String state;
  final Image img;
}

final List<Object> objects = <Object>[
  Object('Cosa',1,'Disponible',Image.network('https://http.cat/400')),
  Object('Bici',1,'Prestado',Image.network('https://http.cat/401')),
  Object('Pelota',5,'Disponible',Image.network('https://http.cat/402')),
  Object('Pelota',2,'Prestado',Image.network('https://http.cat/403'))
];
