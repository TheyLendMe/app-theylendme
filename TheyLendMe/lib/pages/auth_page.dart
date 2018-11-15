import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:TheyLendMe/Utilities/auth.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

/*
//TODO:
* - use googleAuth, emailAuth, facebookAuth from Utilities/auth.dart
*/

class AuthPage extends StatefulWidget {
	// this source is better: https://youtu.be/iYH2jzUM1Nc

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {

  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  String _email="johndoe@ema.il";
  String _password="p4ssw0rd";

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    _iconAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo( //TODO: CIRCLEAvatar?
                size: _iconAnimation.value * 140.0,
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  autovalidate: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Introduce tu e-mail", fillColor: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Introduce tu contraseña",
                        ),
                        obscureText: true, //TODO: showPassword button
                        keyboardType: TextInputType.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      MaterialButton(
                        height: 50.0,
                        minWidth: 240.0,
                        color: Colors.green,
                        splashColor: Colors.teal,
                        textColor: Colors.white,
                        child: Text('Registrarme', style: TextStyle(color: Colors.white)),
                        onPressed: () { Auth.emailRegister(_email,_password); },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      MaterialButton(
                        child: googleButton(context)
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ]
      )
    );
  }
}

Widget googleButton(BuildContext context) {
  return FlatButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    color: Color(0Xffdb3236),
    onPressed: () async {
      await Auth.login(google: true);
      Navigator.of(context).pop(null);
    },
    child: Container(
      height: 50.0,
      width: 215.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 15.0,
              bottom: 15.0,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                  size: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                ),
                Text(
                  "Identificarme con Google",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}