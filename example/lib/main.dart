import 'package:chat_package/chat_package.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Ui example',
      theme: ThemeData(
        primaryColor: const Color(0xFF075E54),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textEditingController = TextEditingController();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  final messages = [
    ChatMessage(
      text: 'hi omar',
      isSender: true,
    ),
    ChatMessage(
      text: 'hello',
      isSender: false,
    ),
    ChatMessage(
      isSender: true,
      text: 'this is a banana',
      chatMedia: const ChatMedia(
        url:
            'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
        mediaType: MediaType.imageMediaType(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: const Color(0xFF075E54),
      ),
      body: ChatScreen(
        messages: messages,
        scrollController: ScrollController(),
        onRecordComplete: (audioMessage) {
          messages.add(audioMessage);
          setState(() {});
        },
        onImageSelected: (imageMessage) {
          messages.add(imageMessage);
          setState(() {});
        },
        textEditingController: TextEditingController(),
        onTextSubmit: (textMessage) {
          messages.add(textMessage);
          setState(() {});
        },
      ),
    );
  }
}
