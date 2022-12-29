import 'dart:developer';

import 'package:chat_package/chat_package.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat ui example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ChatMessage> messages = [
    ChatMessage(
      isSender: true,
      text: 'this is a banana',
      chatMedia: ChatMedia(
        url:
            'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
        mediaType: MediaType.imageMediaType(),
      ),
    ),
    ChatMessage(
      isSender: false,
      chatMedia: ChatMedia(
        url:
            'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
        mediaType: MediaType.imageMediaType(),
      ),
    ),
    ChatMessage(isSender: false, text: 'wow that is cool'),
  ];
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ChatScreen(
        scrollController: scrollController,
        messages: messages,
        onSlideToCancelRecord: () {
          log('not sent');
        },
        onTextSubmit: (textMessage) {
          setState(() {
            messages.add(textMessage);

            scrollController
                .jumpTo(scrollController.position.maxScrollExtent + 50);
          });
        },
        handleRecord: (audioMessage, canceled) {
          if (!canceled) {
            setState(() {
              messages.add(audioMessage!);
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent + 90);
            });
          }
        },
        handleImageSelect: (imageMessage) async {
          if (imageMessage != null) {
            setState(() {
              messages.add(
                imageMessage,
              );
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent + 300);
            });
          }
        },
      ),
    );
  }
}
