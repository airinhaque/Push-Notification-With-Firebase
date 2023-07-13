import 'package:flutter/material.dart';


class MessageScreen extends StatefulWidget {
  final String ID;
  const MessageScreen({Key? key, required this.ID}) : super(key: key);


  // This widget is the root of your application.
  @override
  State<MessageScreen> createState() => _MessageScreenState();
 


  }


class _MessageScreenState extends State<MessageScreen> {
  @override


   Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages${widget.ID}'),
      ),
     
    );
 
  }
 }
