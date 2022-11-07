import 'package:chat_app/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../chat/messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter chat'),
        actions: [
          DropdownButton(
            underline: Container(),
              icon: Icon(Icons.more_vert, color: Theme.of(context).primaryIconTheme.color,),
              items: [
                DropdownMenuItem(
                    child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8,),
                      Text('Logout')
                    ],
                  ),
                ),
                  value: 'logout',
                )
              ],
              onChanged: (itemIdentifier){
                if(itemIdentifier == 'logout'){
                  FirebaseAuth.instance.signOut();
                }
              }
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages()
            ),
            NewMessage()
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((event) {
     print("On Message received --> ${event.data}");
     return;
   });

   FirebaseMessaging.onBackgroundMessage((message) {
      print("Background Message received --> ${message.data}");
      return Future.value(null);
   });

   FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Message opened Message received --> ${event.data}");
   });

   FirebaseMessaging.instance.subscribeToTopic('chat');
  }
}
