import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
	// this source is better: https://youtu.be/iYH2jzUM1Nc

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {

  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
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
      body: Stack( //TODO: Stack? children with only one Widget..
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
                        minWidth: 150.0,
                        color: Colors.green,
                        splashColor: Colors.teal,
                        textColor: Colors.white,
                        child: Text('Registrarme', style: TextStyle(color: Colors.white)),
                        onPressed: () {},
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