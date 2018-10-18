import 'package:flutter/material.dart';

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
    return new ListTile(
      leading: new CircleAvatar( //TODO: square?
          child: new Text(object.title[0]),
          backgroundColor: Colors.yellow
        ),
      title: new Container(
        //padding: new EdgeInsets.only(left: 8.0),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
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
