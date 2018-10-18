import 'package:flutter/material.dart';

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
    return new ListTile(
      leading: new CircleAvatar(
          child: new Text(loan.title[0]), //just the initial letter in a circle
          backgroundColor: Colors.yellow
        ),
      title: new Container(
        //padding: new EdgeInsets.only(left: 8.0),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(loan.title),
            xN(loan.amount),
            Text(
              loan.state,
              style: stateColor(loan.state,loan.owner)
            )
          ]
        )
      )
    );
  }
}

Widget xN(amount) {
  if (amount>1)
    return Text('x'+amount.toString());
  else
    return Text('');
}

TextStyle stateColor(state,owner) {
  if (state=='Devuelto')
    return TextStyle(color: Colors.grey);
  else if (state=='Prestado')
    if (owner=='yo')
        return TextStyle(color: Colors.red);
    else
        return TextStyle(color: Colors.blue);
}

class Loan {
  Loan(
    this.title,
    this.amount,
    this.state,
    this.owner
  );

  final String title;
  final int amount;
  final String state;
  final String owner;
}

final List<Loan> loans = <Loan>[
  Loan('Cosa',1,'Devuelto','yo'),
  Loan('Pelota',1,'Prestado','OtroUsuario1'),
  Loan('Lápiz',3,'Prestado','yo'),
  Loan('Caja',1,'Prestado','OtroUsuario2'),
  Loan('Goma',1,'Devuelto','yo')
];
