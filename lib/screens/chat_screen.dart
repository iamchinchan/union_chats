import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:secret_chats/constants.dart';
import '../screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const id = 'chat_screen';
  static User? loggedInUser;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void deactivate() {
    super.deactivate();
    print('chat screen deactivated');
  }

  @override
  void dispose() {
    super.dispose();
    print('chat screen disposed');
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();
  String? messageValue;
  final _auth = FirebaseAuth.instance;
  void getCurrentUser() {
    try {
      setState(() {
        ChatScreen.loggedInUser = _auth.currentUser;
      });
      if (ChatScreen.loggedInUser != null) {
        print('A user is signed in: show chat screen rather than loading icon');
      } else {
        print('Sending to welcome screen as no user is signed in');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, WelcomeScreen.id, (route) => false);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (ChatScreen.loggedInUser != null)
                ? const MessageStream()
                : const Center(
                    child: Text('No User Logged In'),
                  ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                      controller: messageController,
                      onChanged: (value) {
                        setState(() {
                          messageValue = value;
                        });
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      if (ChatScreen.loggedInUser != null) {
                        _firestore.collection('messages').add({
                          'timestamp': FieldValue.serverTimestamp(),
                          'sender': ChatScreen.loggedInUser!.email.toString(),
                          'text': messageValue,
                        });
                      }
                      messageController.clear();
                    },
                    child: const Text(
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

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final String? loggedInUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (BuildContext context, snapshot) {
        Widget builderChild;
        if (snapshot.hasError) {
          builderChild = Center(
            child: Column(children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Stack trace: ${snapshot.stackTrace}'),
              ),
            ]),
          );
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              builderChild = Center(
                child: Column(
                  children: const <Widget>[
                    Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Select a lot'),
                    ),
                  ],
                ),
              );
              break;
            case ConnectionState.waiting:
              builderChild = Center(
                child: Column(
                  children: const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting messages...'),
                    ),
                  ],
                ),
              );
              break;
            case ConnectionState.active:
              // print(snapshot.data.docs);
              if (snapshot.hasData) {
                final messages = snapshot.data;
                builderChild = Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: (messages!.docs.isNotEmpty)
                        ? ListView(
                            reverse: true,
                            children: messages.docs.reversed.map((message) {
                              // return Text(message['sender']);
                              return MessageBubble(
                                  isMe: message['sender'].toString() ==
                                      ChatScreen.loggedInUser!.email.toString(),
                                  sender: message['sender'],
                                  text: message['text']);
                            }).toList(),
                          )
                        : const Center(
                            child: Text(
                              'No messages yet!',
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                  ),
                );
              } else {
                print(
                    'snapshot has no data! Ask user to reload or re start the application');
                builderChild = const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                );
              }

              break;
            case ConnectionState.done:
              builderChild = Column(
                children: const <Widget>[
                  Icon(
                    Icons.info,
                    color: Colors.blue,
                    size: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('connection closed'),
                    // child: Text('\$${snapshot.data} (closed)'),
                  ),
                ],
              );
              break;
          }
        }
        return builderChild;
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {required this.sender, required this.text, required this.isMe, Key? key})
      : super(key: key);
  final bool isMe;
  final String text;
  final String sender;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(color: Colors.black45, fontSize: 16.0),
          ),
          const SizedBox(
            height: 3.5,
          ),
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.lightBlueAccent : Colors.grey.shade300,
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))
                  : const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20.0,
                color: isMe ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
