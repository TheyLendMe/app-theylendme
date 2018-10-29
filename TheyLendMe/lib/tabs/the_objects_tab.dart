import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/object_page.dart';

// Pestaña OBJETOS
class TheObjectsTab extends StatefulWidget {
    @override
    _TheObjectsTabState createState() => _TheObjectsTabState();
}

final List<Image> imgs = <Image>[
  Image.network('https://http.cat/400'),
  Image.network('https://http.cat/401'),
  Image.network('https://http.cat/402'),
  Image.network('https://http.cat/403'),
  Image.network('https://http.cat/404'),
];

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
                  return ObjectPage(imgs[index%5]);
                }
                //Navigator.of(context).pushNamed("/ObjectPage");
              );
            },
            child: Center(
              child: imgs[index%5]
            )
          ); //GestureDetector
        }),
      ),
    );
  }
}