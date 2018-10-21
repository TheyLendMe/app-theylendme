import 'package:flutter/material.dart';
import 'package:TheyLendMe/the_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Utilities/auth.dart';
import 'Utilities/reqresp.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'Singletons/UserSingleton.dart';
import 'package:TheyLendMe/Objects/objState.dart';
import 'package:http/http.dart' as Http;

void main() => runApp(TheApp());



class TheApp extends StatelessWidget {
  // This widget is the root of your application.7

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void pruebas() async{


   ///Con poner esto debería de valer para obtener los o bjetos de este usuario
    // // await Auth.login(google:true);
    await Auth.login(google:true);



    // await Obj.getObjects();
    // new User("myid","nombre").updateInfo(nickName: "myid");
    //await (new User("myid","nombre").getObjects());
    // var a = fieldNameFieldValue(nickName: "hey", info: "heyyy");
    


    //  List<Obj> objs= await (new User("myid","nombre").getObjects());
     
    //   objs.forEach((f){
    //    print(f.name + "      " + f.type.toString());
    //  });

    // ResponsePost res = await new RequestPost("updateUser").dataBuilder(
    //   fieldname: a[0],
    //   fieldValue: a[1],
    //   idUser: "hey",

    // ).doRequest();

    //new UserObject(3, new User("myid","nombre"), "xdd", objState: new ObjState(id: 6, state: StateOfObject.BORROWED)).returnObj(idUser:"otherid");

    // User u = new User("myid", "hey");
    // User o = new User("otherid", "hey");

    // UserObject uO = new UserObject(3, u, "hey");
    
    // uO.requestObj();


    //new User("otherid", "prueba").upgradeToAdmin(new Group(4, "hey"));
   


    

  


  }





  @override
  Widget build(BuildContext context) {









    
    return MaterialApp(
      title: 'app de préstamos',
      theme: ThemeData( primarySwatch: Colors.blue, ),
      home: new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: pruebas
        ),
        body: new Container()
      ),
    );
  }
}
