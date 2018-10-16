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
      leading: new CircleAvatar(
          child: new Text(object.title[0]), //just the initial letter in a circle
          backgroundColor: Colors.yellow
        ),
      title: new Container(
        child: Row(
          children: <Widget>[
            Text(object.title),
            xN(object.amount),
            Text(object.state),
          ]
        )
      )
    );
  }
}

Widget xN(amount) {
  if (amount>1)
    return Text(amount.toString());
  else
    return Text('');
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
  Object('Cosa',1,'Disponsible'),
  Object('Bici',1,'Prestado'),
  Object('Pelota',5,'Disponible'),
  Object('Pelota',2,'Prestado')
];
