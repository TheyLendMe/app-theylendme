import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart'; // provisional

// Pestaña OBJETOS
class TheObjectsTab extends StatefulWidget {
    @override
    _TheObjectsTabState createState() => _TheObjectsTabState();
}

// CONTENIDO de la pestaña OBJETOS
class _TheObjectsTabState extends State<TheObjectsTab> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GridView.count( //GridView de ejemplo:
        crossAxisCount: 2,
        children: List.generate(100, (index) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: this.context,
                builder: (BuildContext context){
                  return ObjectDetails(objects[index%5]);
                }
              );
            },
            child: Center(
              child: Image.network(objects[index%5].image)
            )
          ); //GestureDetector
        }),
      ),
    );
  }
}

final User propietario = User('1', 'Señor Propietario');

final List<UserObject> objects = <UserObject>[
  UserObject(1, propietario, 'cat-400', image: 'https://http.cat/400'),
  UserObject(2, propietario, 'cat-401', image: 'https://http.cat/401'),
  UserObject(3, propietario, 'cat-402', image: 'https://http.cat/402'),
  UserObject(4, propietario, 'cat-403', image: 'https://http.cat/403'),
  UserObject(5, propietario, 'cat-404', image: 'https://http.cat/404')
];
