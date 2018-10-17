import 'package:flutter/material.dart';

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
              Navigator.of(context).pushNamed("/ObjectPage");
            },
            child: Center(
              child: Image.network('https://http.cat/40'+(index%5).toString())
            )
          );
        }),
      ),
    );
  }
}