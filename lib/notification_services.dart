import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification/message_screen.dart';


class NotificationServices {

  FirebaseMessaging messaging = FirebaseMessaging.instance;


  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  void requestNotificationPermission()async{


    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted permission');
     


    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provisional permission');


  }else {
    print('User declined or has not accepted permission');


  }


}

  void initLocalNotification(BuildContext context ,RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();


      var initializationSetting = InitializationSettings(


        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
        );


        await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
          handleMessage(context, message);
         


        }
       
        );


   
  }
  void firebaseInit(BuildContext context){


    FirebaseMessaging.onMessage.listen((message) {


    if (kDebugMode) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      print(message.data.toString());
      print(message.data['Type']);
      print(message.data['ID']);


      }

      //We can send ID with the notification but  the feature only works on Android

    if(Platform.isAndroid){

      initLocalNotification(context, message);
      showNotification(message);
      
    }else{          
    showNotification(message);
   
    }

    });

  }
  Future<void> showNotification(RemoteMessage message)async{


    AndroidNotificationChannel channel = AndroidNotificationChannel(
     
      Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
      importance: Importance.max
     
      );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'This is a channel for high importance notification',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker'


      );



      const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        
      );





      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails
      ,iOS: darwinNotificationDetails);




    Future.delayed(Duration.zero, () {
       _flutterLocalNotificationsPlugin.show(
         0,
         message.notification!.title.toString(),
         message.notification!.body.toString(),
     
         notificationDetails);  
 


    });
   


  }


  Future<String> getDeviceToken()async{


    String? token = await messaging.getToken();
    return token!;
  }


  void isTokenRefreshed()async{


    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });


  }

  Future<void> setupInteractMessage(BuildContext context)async{


    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();


    if(initialMessage != null){
      handleMessage(context, initialMessage);    
         
    }


    //when app is in background


    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });


  }

void handleMessage(BuildContext context, RemoteMessage message) {

  if(message.data['Type'] == 'Message'){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen(
      ID: message.data['ID'],
    )));
  }
 
}
}
