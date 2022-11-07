import 'package:chat_app/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

      return StreamBuilder<dynamic>(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, chatSnapshot){
        if(chatSnapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        final chatDocs = chatSnapshot.data.docs;
        return ListView.builder(
                reverse: true,
                itemBuilder: (ctx, index) {
                  print(chatDocs[index]['text']);
                   return MessageBubble(
                        message: chatDocs[index]['text'],
                        isMe: chatDocs[index]['userId'] == user!.uid,
                        username: chatDocs[index]['username'],
                     imageUrl: chatDocs[index]['userImage'],
                     key: ValueKey(chatDocs[index].reference.id.toString()),
                    );
      },
                itemCount: chatDocs.length
            );
          }
        );
  }
}
