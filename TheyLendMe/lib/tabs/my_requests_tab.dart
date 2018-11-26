import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/pages/user_details.dart';
import 'package:TheyLendMe/pages/group_details.dart';

// Pestaña SOLICITUDES
class MyRequestsTab extends StatefulWidget {
    @override
    _MyRequestsTabState createState() => _MyRequestsTabState();
}

// CONTENIDO de la pestaña SOLICITUDES
class _MyRequestsTabState extends State<MyRequestsTab> {

  @override
  Widget build(BuildContext context) {
    //TODO: getRequestsMeToOthers()
    return FutureBuilder<List<Obj>>(
      future: UserSingleton().user.getRequestsOthersToMe(),
      builder: (context, snapshot) {
        return (snapshot.hasData
          ? ListView.builder(
              itemBuilder: (BuildContext context, int index) => RequestedItem(snapshot.data[index]),
              itemCount: snapshot.data.length
            )
          : Center(child: CircularProgressIndicator()));
      }
    );
  }
}

// Displays one RequestedItem.
class RequestedItem extends StatelessWidget {

  RequestedItem(this.requestedObject);
  final Obj requestedObject;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /*onTap: () { //TODO
        showDialog(
          context: context,
          builder: (BuildContext context){
            return GroupDetails(request);
          }
        );
      },*/
      child: ListTile(
        leading: Container(
          child: (requestedObject.image!=null
            ? Image.network(requestedObject.image, width: 30)
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
                    if (requestedObject.objState.next is User) {
                      return UserDetails(requestedObject.objState.next);
                    } else if (requestedObject.objState.next is Group) {
                      return GroupDetails(requestedObject.objState.next);
                    }
                  }
                );
              },
              child: Text(requestedObject.objState.next.name) //WIP: hacerlo más clickable
            ),
            Text(' pide '),
            Text(requestedObject.name)
          ]
        ),
        subtitle: Column(
          children: [
            (requestedObject.desc!=null
              ? Text(requestedObject.desc)
              : Text('')),
            Row(
              children: [
                MaterialButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Prestar', style: TextStyle(color: Colors.black)),
                  height: 42.0,
                  onPressed:() async {
                    await requestedObject.lendObj();
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("¡Objeto prestado!")));
                    //TODO: refresh here
                  }
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                ),
                MaterialButton(
                  color: Colors.grey,
                  child: Text('Rechazar solicitud', style: TextStyle(color: Colors.black)),
                  height: 42.0,
                  onPressed: () {
                    //TODO: something like refuseObj()
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Solicitud rechazada (//TODO)")));
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
