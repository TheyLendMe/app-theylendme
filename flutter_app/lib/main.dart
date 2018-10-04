import 'package:flutter/material.dart';
import 'Objects/entity.dart';
import 'Objects/obj.dart';
import 'Utilities/reqresp.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'app de préstamos',
      theme: new ThemeData( primarySwatch: Colors.blue, ),
      home: new MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  // This stateful widget is the home page of your application.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Este objeto State contiene campos que modifican el aspecto de
  // MyHomePage, ya que es un widget "stateful" (puede cambiar dinámicamente)
  int _counter = 0;

  void _incrementCounter() {
    User u = new User("myid", "Hugo");
   // u.addObject("Esto es una prueba", 12);
    u.getObjects();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return new Scaffold(
      appBar: new AppBar( title: new Text(widget.title), ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text( 'You have pushed the button this many times:', ),
            new Text( '$_counter', style: Theme.of(context).textTheme.display1, ),
          ],
        ),//final del widget child (de tipo Column)
      ),//final del widget body (de tipo Center)
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
