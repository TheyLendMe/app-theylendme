import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart'; // provisional
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/*WIP: reading https://stackoverflow.com/questions/51988852/flutter-infinite-scroll-view-with-mysql
* FIXME: ObjectTile.objects is null
*/

// Pestaña OBJETOS
class TheObjectsTab extends StatefulWidget {
    @override
    _TheObjectsTabState createState() => _TheObjectsTabState();
}

// CONTENIDO de la pestaña OBJETOS.
class _TheObjectsTabState extends State<TheObjectsTab> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Obj>>(
        future: Obj.getObjects(), //FIXME: endpoint/app/getObjects throws Fatal error
        builder: (context, snapshot) {
          /*if (snapshot.hasError) //TODO: this is from https://github.com/CodingInfinite/FutureBuilderWithPagination
            return PlaceHolderContent(
              title: "Error de conexión",
              message: "Error. Inténtalo de nuevo",
              tryAgainButton: _tryAgainButtonClick,
            );*/
          return snapshot.hasData
            ? ObjectTile(objects: snapshot.data)
            : Center(child: CircularProgressIndicator());
          }
      )
    );
  }

  _tryAgainButtonClick(bool _) => setState(() {});

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
                  return ObjectDetails(objects[i%5]);
                }
              );
            },
            child: Hero(
              tag: objects[i%5].image,
              //child: Image.network(objects[i%5].image)
              child: FadeInImage(
                image: NetworkImage(objects[i%5].image),
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

/*final User propietario = User('1', 'Señora Propietaria',
  img: 'https://vignette.wikia.nocookie.net/simpsons/images/b/bd/Eleanor_Abernathy.png');

final List<UserObject> objects = <UserObject>[
  UserObject(1, propietario, 'cat-400', image: 'https://http.cat/400'),
  UserObject(2, propietario, 'cat-401', image: 'https://http.cat/401'),
  UserObject(3, propietario, 'cat-402', image: 'https://http.cat/402'),
  UserObject(4, propietario, 'cat-403', image: 'https://http.cat/403'),
  UserObject(5, propietario, 'cat-404', image: 'https://http.cat/404')
];*/
