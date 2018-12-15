import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/pages/user_details.dart';
import 'package:TheyLendMe/pages/group_details.dart';

// Pestaña PRESTADOS
class MyRequestsTab extends StatefulWidget {
    final Group _group;
    MyRequestsTab(this._group);
    @override
    _MyRequestsTabState createState() => _MyRequestsTabState();
}

// CONTENIDO de la pestaña PRESTADOS
class _MyRequestsTabState extends State<MyRequestsTab> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: const Text('Solicitudes'),
          //TODO: searchBar
      ),
      body: FutureBuilder<List<Obj>>(
        future: widget._group.getRequestsOthersToMe(),
        builder: (context, snapshot) {
          return (snapshot.hasData
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) => RequestedItem(snapshot.data[index]),
                itemCount: snapshot.data.length
              )
            : Center(child: CircularProgressIndicator()));
        }
      ),
    );
    
  }
}

// Displays one LentItem.
class RequestedItem extends StatelessWidget {

  RequestedItem(this.requestedObject);
  final GroupObject requestedObject;

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return ObjectDetails(requestedObject);
          }
        );
      },
      child: ListTile(
        leading: Container(
          child: (requestedObject.image!=null
            ? Image.network(requestedObject.image, width: 30)
            : Image.asset('images/def_obj_pic.png', width: 30)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0)
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
                      return UserDetails(requestedObject.groupObjectState.nextUser);
                  }
                );
              },
              child: Text(requestedObject.groupObjectState.nextUser.name) //WIP: hacerlo más clickable
            ),
            Text(' pide '),
            Text(requestedObject.name)
          ]
        ),
        subtitle: Column(
          children: [
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
                      children: [ Text('Prestar', style: TextStyle(color: Colors.black)) ]
                    ),
                    height: 42.0
                  ),
                  onPressed:() async {
                    requestedObject.lendObj().then((error){
                      if(!error){Scaffold.of(context).showSnackBar(SnackBar(content: Text("¡Objeto prestado!")));}
                    });
                    
                    //TODO: refresh here
                  }
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.grey,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ Text('Rechazar solicitud', style: TextStyle(color: Colors.black)) ]
                    ),
                    height: 42.0
                  ),
                  onPressed: () async  {
                    requestedObject.deleteRequest().then((error){
                      if(!error){
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Solicitud rechazada")));
                      }
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
