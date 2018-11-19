import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/object_details.dart';
import 'package:TheyLendMe/pages/loan_details.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

/*
//TODO:
* - Complete Dismissible behaviour
*/


class MyLoansPage extends StatefulWidget {
    @override
    _MyLoansPageState createState() => _MyLoansPageState();
}

class _MyLoansPageState extends State<MyLoansPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text('Mis Préstamos'),
        ),
      body: FutureBuilder<List<Obj>>(
        future: UserSingleton().user.getClaimsOthersToMe(), //TODO: getLoansOthersToMe also needed
        builder: (context, snapshot) {
          return (snapshot.hasData
            ? ListView.builder( //ListView de ejemplo:
                itemBuilder: (BuildContext context, int index) => LoanItem(snapshot.data[index]),
                itemCount: snapshot.data.length
              )
            : Center(child: CircularProgressIndicator()));
          }
    ));
  }
}

// Displays one Loan.
class LoanItem extends StatelessWidget {

  const LoanItem(this.object);
  final Obj object;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return LoanDetails(object);
          }
        );
      },
      child: Dismissible(
        key: new Key(object.name),
        background: new Container(
          color: (object.objState.state==StateOfObject.LENT
            ? Colors.green
            : Colors.blue
          ),
          child: new Row(
            children: [new Container(
              child: (object.objState.state==StateOfObject.LENT
                ? new Text("Marcar\ncomo\nDevuelto")
                : new Text("Descartar")
              ),
              padding: EdgeInsets.only(left: 4.0),
            )]
          ) //Row
        ), //background Container
        secondaryBackground: new Container(
          color: (object.objState.state==StateOfObject.LENT
            ? Colors.red
            : Colors.blue
          ),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [new Container(
              //child: new Text("Solicitar"),
              child: (object.objState.state==StateOfObject.LENT
                ? new Text("Solicitar")
                : new Text("")
              ),
              padding: EdgeInsets.only(right: 4.0),
            )]
          ) //Row
        ), //secondaryBackground Container
        child: new Container(
          color: (object.objState.state==StateOfObject.DEFAULT ? Colors.grey : Colors.white), //TODO: just disable it
          child: new ListTile(
            leading: new Container(
              child: new Text(object.name[0]), //just the initial letter in a circle
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(
                  const Radius.circular(4.0),
                ),
              ),
              padding: EdgeInsets.all(16.0),
            ), //leading Container
            title: new Container(
              //padding: new EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(object.name),
                  stateIcon(object.objState.state,object.owner)
                ]
              ) //Row
            ) //title Container
          ), //ListTile
        ), //Container
        //direction: DismissDirection.horizontal,
        direction: (object.objState.state==StateOfObject.LENT
          ? (object.owner==UserSingleton().user)
            ? DismissDirection.horizontal
            : DismissDirection.down //TODO: DismissDirection.none
          : DismissDirection.horizontal
        ),
        onDismissed: (direction) {
          //TODO: show SnackBars for a shorter time
          if(object.objState.state==StateOfObject.DEFAULT) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Préstamo finalizado correctamente")));
          }
          else {
            if(direction == DismissDirection.endToStart) { //right: send CLAIM
              //TODO: don't remove the tile! get its initial position back
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("¡Devolución solicitada!")));
            }
            if(direction == DismissDirection.startToEnd) { //left: mark object as RETURNED
              //TODO: don't remove the tile! just disable them
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("¡Préstamo marcado como devuelto!")));
            }
          }
        },
      ) //Dismissible
    ); //GestureDetector
  }
}

Widget xN(amount) {
  if (amount>1)
    return Text('x'+amount.toString());
  else
    return Text('');
}

Widget stateIcon(state,owner) {
  if (state==StateOfObject.DEFAULT)
    return Container(
      child: Icon(Icons.check),
    );
  else if (state==StateOfObject.LENT)
    if (owner==UserSingleton().user)
        return Container(
          child: Icon(Icons.call_received), //TODO: icon: call_made = object_received ??
          //color: Colors.red
        );
    else
        return Container(
          child: Icon(Icons.call_made), // icon: call_received = object_made ??
          //color: Colors.green
        );
}

/*final User usuario1 = User('1', 'Usuario 1',
  img: 'https://vignette.wikia.nocookie.net/simpsons/images/b/bd/Eleanor_Abernathy.png',
  tfno: '34606991934', email: 'sofia@adolfodominguez.com');
final User usuario2 = User('2', 'Usuario 2',
  img: 'https://d1u5p3l4wpay3k.cloudfront.net/futuramaworldsoftomorrow_gamepedia_en/a/a9/Hattie_McDoogal_Find_a_Cat_Sitter.png',
  tfno: '34606991934', email: 'sofia@adolfodominguez.com');
final User yo = User('3', 'Yo mismo',
  img: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAqvCudv9tguYJwMavtlmGM25jbivv_pZ5rdBxNM4a4EXXXT5j',
  tfno: '34606991934', email: 'sofia@adolfodominguez.com');

final List<UserObject> loanObjects = <UserObject>[
  UserObject(1, usuario1, 'Cosa', image: 'https://http.cat/400', objState: ObjState()),
  UserObject(2, usuario2, 'Pelota', image: 'https://http.cat/401', objState: ObjState()),
  UserObject(3, yo, 'Mi Lápiz', image: 'https://http.cat/402', objState: ObjState()),
  UserObject(4, usuario2, 'Caja', image: 'https://http.cat/403', objState: ObjState()),
  UserObject(5, usuario1, 'Goma', image: 'https://http.cat/404', objState: ObjState())
];*/

