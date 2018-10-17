import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
	// source: https://youtu.be/efbB8-x9T2c

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
@override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar( //TODO: CIRCLEAvatar?
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('images/tlm.jpg'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        hintText: 'tuemail@ejemplo.com',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      initialValue: '',
      obscureText: false, //TODO: showPassword button
      decoration: InputDecoration(
        hintText: 'tuContraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.fromLTRB(0,0,0,0),
      child: Container(
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            Navigator.of(context).pushNamed('/MyObjectsPage');
          },
          color: Colors.lightBlueAccent,
          child: Text('¡Regístrate!', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    // final forgotLabel = FlatButton(
    //   child: Text(
    //     '¿Has olvidado tu contraseña?',
    //     style: TextStyle(color: Colors.black54),
    //   ),
    //   onPressed: () {},
    // );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 72.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 12.0),
            loginButton,
            //forgotLabel
          ],
        ),
      ),
    );
  }
}