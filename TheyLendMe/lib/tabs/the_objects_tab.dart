import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// Pestaña OBJETOS
class TheObjectsTab extends StatefulWidget {
    @override
    _TheObjectsTabState createState() => _TheObjectsTabState();
}

// CONTENIDO de la pestaña OBJETOS.
class _TheObjectsTabState extends State<TheObjectsTab> {
  ObjectTile listOfObject;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> _refresh() {return Obj.getObjects().then((_objects) {  setState(() {listOfObject = ObjectTile(objects: _objects);}); }); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator( //example: https://github.com/sharmadhiraj/flutter_examples/blob/master/lib/pages/refresh_indicator.dart
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: FutureBuilder<List<Obj>>(
          future: Obj.getObjects(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(listOfObject == null){listOfObject = new ObjectTile(objects: snapshot.data);}
              return listOfObject;
            } else { return Center(child: CircularProgressIndicator()); }
          }
        ),
      )
    );
  }
}

class ObjectTile extends StatelessWidget {
  final List<Obj> objects;
  ObjectTile({this.objects});

  @override
  Widget build(BuildContext context) {
    // example for StaggeredGridView: https://youtu.be/SrGP1BdkYpk
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      itemCount: objects.length,
      itemBuilder: (context, i) {
        return Material(
          elevation: 8.0,
          borderRadius:
              BorderRadius.all(Radius.circular(8.0)),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return ObjectDetails(objects[i]);
                }
              );
            },
            child: Hero(
              tag: objects[i].idObject.toString()+getFirstCharacter(objects[i].name),
              //tag: idObject+first_name_lettter because it could happen
              // that groupObject.idObject=userObject.idObject -> black screen
              child: FadeInImage(
                image: (objects[i].image!=null
                  ? NetworkImage(objects[i].image)
                  : AssetImage('images/def_obj_pic.png')),
                fit: BoxFit.cover,
                placeholder: AssetImage('images/tlm.png'),
              )
            ),
          ),
        );
      },
      staggeredTileBuilder: (i) =>
          StaggeredTile.count(4,4),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}

String getFirstCharacter(String getFirstCharacter){
  //Un poco feo [\u{1F600}-\U+E007F]
  var regex = '[\u{1F600}\\-\\u{E007F}]';
  String textWithoutEmojis = getFirstCharacter.replaceAll(new RegExp(regex), '');
  return textWithoutEmojis[0];}
