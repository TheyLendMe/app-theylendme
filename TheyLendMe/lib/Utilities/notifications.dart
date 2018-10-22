

import 'package:firebase_messaging/firebase_messaging.dart';

class NotHandler{
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String _token;

  NotHandler(){

    firebaseMessaging.configure(
      onLaunch: (Map<String,dynamic> msg){
        print(msg);
      },
      onResume: (Map<String,dynamic> msg){
        print(msg);
      },
      onMessage: (Map<String,dynamic> msg){
        print(msg);
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
      print(token);
      _token = token;

    });

    firebaseMessaging.subscribeToTopic("Objetos");

  }



}