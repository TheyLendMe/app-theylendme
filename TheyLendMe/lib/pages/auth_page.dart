import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:TheyLendMe/Utilities/auth.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

class AuthPage extends StatefulWidget {

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {

  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  void initState() { // Animation:
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

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      Auth.emailRegister(controllerEmail.text,controllerPassword.text);
      //TODO: sync-await return Center(child: CircularProgressIndicator()));
      Navigator.of(context).pop(null);
    }
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
              Image(
                height: _iconAnimation.value*200, width: _iconAnimation.value*200,
                image: AssetImage('images/icon.png')
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Introduce tu e-mail", fillColor: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        controller: controllerEmail,
                      ),
                      GestureDetector(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Introduce tu contraseña",
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          validator: _validatePassword,
                          controller: controllerPassword,
                        ),
                        //onTap: () => (obscureText ? false : true) //TODO: showPassword button
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      MaterialButton(
                        height: 50.0,
                        minWidth: 240.0,
                        color: Theme.of(context).primaryColor,
                        splashColor: Colors.teal,
                        textColor: Colors.white,
                        child: Text('Registrarme', style: TextStyle(color: Colors.white)),
                        onPressed:() {
                          _submit();
                        }
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
    color: Theme.of(context).accentColor,
    onPressed: () async {
       Auth.login(google: true).then((valid){
         if(valid){Navigator.of(context).pop(null);}
       });
        //TODO: sync-await return Center(child: CircularProgressIndicator()));
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

// https://github.com/MikeMitterer/dart-validate/blob/master/lib/validate.dart#L57
String _validateEmail(String value) {
  return (value.isEmpty ? 'Por favor, introduce un email'
    : (!RegExp("^([0-9a-zA-Z]([-.+\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})\$").hasMatch(value) ? 'Email no válido'
      : null));
}

// https://iirokrankka.com/2017/10/17/validating-forms-in-flutter/
String _validatePassword(String value) {
  return (value.isEmpty ? 'Por favor, introduce una contraseña'
    : (value.length<6 ? 'La contraseña tiene que tener al menos 6 caracteres'
      : null));
}
