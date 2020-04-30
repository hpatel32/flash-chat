import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  String email;
  String messageText;

  FirebaseUser loggedInUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getMessages() async {
    final response = await _fireStore.collection("messages").getDocuments();
    for (var message in response.documents) {
      print(message.data);
    }
  }

  void getStreamMessages() async {
    //final response = await _fireStore.collection("messages").snapshots();
    await for (var message in _fireStore.collection("messages").snapshots()) {
      for (var msg in message.documents) {
        print(msg.data);
      }
    }
  }

  void getCurrentUser() async {
    final curUser = await _auth.currentUser();
    loggedInUser = curUser;
    email = loggedInUser.email;
    print(loggedInUser.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                getStreamMessages();
                //_auth.signOut();
                //Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                final messages = snapshot.data.documents;
                List<MessageBubble> messageWidgets = [];
                for (var msg in messages) {
                  final msgText = msg.data['text'];
                  final msgSender = msg.data['sender'];
                  final newWid = MessageBubble(
                    sender: msgSender,
                    msg: msgText,
                  );
                  messageWidgets.add(newWid);
                }
                return Expanded(
                  child: ListView(
                    children: messageWidgets,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textController.clear();
                      //Implement send functionality.
                      _fireStore
                          .collection('messages')
                          .add({'text': messageText, 'sender': email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  String msg;
  String sender;
  MessageBubble({this.msg, this.sender});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '$sender',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 5.0,
              color: Colors.lightBlueAccent,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  '$msg',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
