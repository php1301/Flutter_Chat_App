import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chats')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final chatDocs = snapshot.data.documents;
            print('instance there');
            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, i) => MessageBubble(
                chatDocs[i]['text'],
                chatDocs[i]['userId'] == futureSnapshot.data.uid,
                chatDocs[i]['username'],
                chatDocs[i]['userImage'],
                key: ValueKey(chatDocs[i].documentID),
              ),
              itemCount: chatDocs.length,
            );
          },
        );
      },
    );
  }
}
