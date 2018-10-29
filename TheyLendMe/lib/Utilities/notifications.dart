

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

class Notifications{
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final List<Map<String,dynamic>> notList = new List();
  static Notifications _singleton;
  String _token;


  factory Notifications(){
    if(_singleton == null){
      _singleton = new Notifications._internal();
    }
    return _singleton;
  }
  
  Notifications._internal(){
    firebaseMessaging.configure(
      onLaunch: (Map<String,dynamic> msg){
        print("hey1");
        this.addNot(msg);
      },

      ///When the user clicks on the notification
      onResume: (Map<String,dynamic> msg){
        print("hey2");
        this.addNot(msg);
      },

      ///When we receive the notification, esto actua.
      onMessage: (Map<String,dynamic> msg){
        print("hey3");
        this.addNot(msg);

      }
   
    );


    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        alert:true,
        badge: true
      )
    );
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings){
      print('IOS SETTINGS REGISTERED');
    });

    firebaseMessaging.getToken().then((token){
      //print(token);
      _token = token;

    });
  }

  void addNot(Map msg){
    notList.add(msg);
  }

  void suscribeToTopic(String topic){
    firebaseMessaging.subscribeToTopic(topic);
  }






}
