import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notification/notification_services.dart';
import 'package:http/http.dart' as http;

 class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {


  NotificationServices notificationServices = NotificationServices();


  @override
  void initState() {
   
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    //notificationServices.isTokenRefreshed();
    notificationServices.getDeviceToken().then((value) {
      print('Device Token');
      print(value);
    });
   
  }


  @override


  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        //add color to appbar
        backgroundColor: const Color.fromARGB(255, 210, 196, 255),
        title: const Text('NYUAD LAUNDRY'),
      ),

      body: Center(
        child: TextButton(
          onPressed: () {
            notificationServices.getDeviceToken().then((value)async{
              var data = {
                'notification' : {

                  'to' : value.toString(),
                  'priority' : 'high',
                  'body' : 'You will be notfied when your laundry is ready',
                  'title' : 'Laundry',
                },
                

              };
              await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              body: jsonEncode(data),
              headers: {

                'Content-Type':'application/json; charset=UTF-8',
                'Authorization' : 'key=AAAAUd-q7vw:APA91bFr9GiQPYHLBgyHmx83angXuVgjLqiHqW6fC1TD3rYk3f9Go_PdKVWmJbWCgSOINrLjbHSoWe76KlMCMgAMIoSpgoR9deng896ghuj5aifrIBN6Suam2LJRdQgYRciqcrupVYv_'
              }

              );
              
            });
          },
          child: const Text('Send Notification for Laundry'),
        ),
      ),
      );
  }
}
