import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/pages/user_details.dart';
import 'package:TheyLendMe/pages/group_details.dart';

// Pestaña PRESTADOS
class MyLoansTab extends StatefulWidget {
    @override
    _MyLoansTabState createState() => _MyLoansTabState();
}

// CONTENIDO de la pestaña PRESTADOS
class _MyLoansTabState extends State<MyLoansTab> {

  @override
  Widget build(BuildContext context) {
    //TODO: getLoansOthersToMe()
    return FutureBuilder<List<Obj>>(
      future: UserSingleton().user.getLoansMeToOthers(),
      builder: (context, snapshot) {
        return (snapshot.hasData
          ? ListView.builder(
              itemBuilder: (BuildContext context, int index) => LentItem(snapshot.data[index]),
              itemCount: snapshot.data.length
            )
          : Center(child: CircularProgressIndicator()));
      }
    );
  }
}

// Displays one LentItem.
class LentItem extends StatelessWidget {

  LentItem(this.lentObject);
  final Obj lentObject;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return ObjectDetails(lentObject);
          }
        );
      },
      child: ListTile(
        leading: Container(
          child: (lentObject.image!=null
            ? Image.network(lentObject.image, width: 30)
            : Image.asset('images/def_obj_pic.png', width: 30)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 8.0)
          )
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    if (lentObject.objState.actual is User) {
                      return UserDetails(lentObject.objState.actual);
                    } else if (lentObject.objState.actual is Group) {
                      return GroupDetails(lentObject.objState.actual);
                    }
                  }
                );
              },
              child: Text(lentObject.objState.actual.name) //WIP: hacerlo más clickable
            ),
            Text(' tiene '),
            Text(lentObject.name)
          ]
        ),
        subtitle: Column(
          children: [
            (lentObject.desc!=null
              ? Text(lentObject.desc)
              : Text('')),
            Row(
              children: [
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Theme.of(context).accentColor,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ Text('Pedir devolución', style: TextStyle(color: Colors.black)) ]
                    ),
                    height: 42.0
                  ),
                  onPressed:() async {
                    await lentObject.claimObj().then((error){ //TODO: claimObj({String claimMsg})
                    if(!error){Scaffold.of(context).showSnackBar(SnackBar(content: Text("Solicitud de devolución enviada")));}
                    });
                  }
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.grey,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ Text('Marcar como\n    devuelto', style: TextStyle(color: Colors.black)) ]
                    ),
                    height: 42.0
                  ),
                  onPressed:() async {
                    lentObject.returnObj().then((error){
                      if(!error){Scaffold.of(context).showSnackBar(SnackBar(content: Text("¡Préstamo finalizado!")));}
                    });
                  }
                )
              ]
            )
          ]
        ),
      )
    );
  }
}
