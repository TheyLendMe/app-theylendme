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
            /*if (snapshot.hasError) //TODO: this is from https://github.com/CodingInfinite/FutureBuilderWithPagination
              return PlaceHolderContent(
                title: "Error de conexión",
                message: "Error. Inténtalo de nuevo",
                tryAgainButton: _tryAgainButtonClick,
              );*/
            if(snapshot.hasData){
              if(listOfObject == null){listOfObject = new ObjectTile(objects: snapshot.data);}
              return listOfObject;
            }
            return Center(child: CircularProgressIndicator());
            
          }),
      )
    );
  }

  //_tryAgainButtonClick(bool _) => setState(() {});
 
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
              tag: objects[i].idObject.toString()+objects[i].name[0],
              //tag: idObject+first_name_lettter because it could happen
              // that groupObject.idObject=userObject.idObject -> black screen
              child: FadeInImage(
                image: (objects[i].image!=null
                  ? NetworkImage(objects[i].image)
                  : AssetImage('images/def_obj_pic.png')),
                fit: BoxFit.cover,
                placeholder: AssetImage('images/tlm.jpg'),
              )
            ),
          ),
        );
      },
      staggeredTileBuilder: (i) =>
          StaggeredTile.count(2, i.isEven ? 2 : 3),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}
