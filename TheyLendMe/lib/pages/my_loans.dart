import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/object_page.dart';

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
      body: ListView.builder( //ListView de ejemplo:
        itemBuilder: (BuildContext context, int index) => LoanItem(loans[index]),
        itemCount: loans.length
      )
    );
  }
}

// Displays one Loan.
class LoanItem extends StatelessWidget {

  const LoanItem(this.loan);
  final Loan loan;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return ObjectPage(loan.img);
          }
        );
      },
      child: Dismissible(
        key: new Key(loan.name),
        background: new Container(
          color: (loan.state=="Prestado"
            ? Colors.green
            : Colors.blue
          ),
          child: new Row(
            children: [new Container(
              child: (loan.state=="Prestado"
                ? new Text("Marcar\ncomo\nDevuelto")
                : new Text("Descartar")
              ),
              padding: EdgeInsets.only(left: 4.0),
            )]
          ) //Row
        ), //Container
        secondaryBackground: new Container(
          color: (loan.state=="Prestado"
            ? Colors.red
            : Colors.blue
          ),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [new Container(
              //child: new Text("Solicitar"),
              child: (loan.state=="Prestado"
                ? new Text("Solicitar")
                : new Text("")
              ),
              padding: EdgeInsets.only(right: 4.0),
            )]
          ) //Row
        ), //Container
        child: new Container(
          color: (loan.state=='Devuelto' ? Colors.grey : Colors.white), //TODO: just disable it
          child: new ListTile(
            leading: new Container(
              child: new Text(loan.name[0]), //just the initial letter in a circle
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(
                  const Radius.circular(4.0),
                ),
              ),
              padding: EdgeInsets.all(16.0),
            ), //Container
            title: new Container(
              //padding: new EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(loan.name),
                  xN(loan.amount),
                  stateIcon(loan.state,loan.owner)
                ]
              ) //Row
            ) //Container
          ), //ListTile
        ), //Container
        //direction: DismissDirection.horizontal,
        direction: (loan.state=="Prestado"
          ? (loan.owner=="yo")
            ? DismissDirection.horizontal
            : DismissDirection.down //TODO: DismissDirection.none
          : DismissDirection.horizontal
        ),
        onDismissed: (direction) {
          //TODO: show SnackBars for a shorter time
          if(loan.state=="Devuelto") {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Préstamo finalizado correctamente")));
          }
          else {
            if(direction == DismissDirection.endToStart) { //right: send CLAIM
              //TODO: don't remove the tile! get its initial position back
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("¡Devolución solicitada!")));
            }
            if(direction == DismissDirection.startToEnd) { //left: mark loan as RETURNED
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
  if (state=='Devuelto')
    return Container(
      child: Icon(Icons.check),
    );
  else if (state=='Prestado')
    if (owner=='yo')
        return Container(
          child: Icon(Icons.call_received), //TODO: icon: call_made = loan_received ??
          //color: Colors.red
        );
    else
        return Container(
          child: Icon(Icons.call_made), // icon: call_received = loan_made ??
          //color: Colors.green
        );
}

class Loan {
  Loan(
    this.name,
    this.amount,
    this.state,
    this.owner,
    this.img
  );

  final String name;
  final int amount;
  final String state;
  final String owner;
  final Image img;
}

final List<Loan> loans = <Loan>[
  Loan('Cosa',1,'Devuelto','yo',Image.network('https://http.cat/400')),
  Loan('Pelota',1,'Prestado','OtroUsuario1',Image.network('https://http.cat/401')),
  Loan('Mi Lápiz',3,'Prestado','yo',Image.network('https://http.cat/402')),
  Loan('Caja',1,'Prestado','OtroUsuario2',Image.network('https://http.cat/403')),
  Loan('Goma',1,'Devuelto','yo',Image.network('https://http.cat/404'))
];
