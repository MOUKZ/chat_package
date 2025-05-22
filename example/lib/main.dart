import 'package:chat_package/chat_package.dart';
import 'package:chat_package/models/chat_message.dart';
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
