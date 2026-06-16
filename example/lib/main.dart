import 'dart:developer';

import 'package:chat_package/chat_package.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat_package example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ChatMessage> messages = [
    const ChatMessage(
      isSender: true,
      text: 'this is a banana',
      chatMedia: ChatMedia(
        url:
            'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
        mediaType: MediaType.image,
      ),
    ),
    const ChatMessage(
      text: '',
      isSender: false,
      chatMedia: ChatMedia(
        url:
            'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
        mediaType: MediaType.image,
      ),
    ),
    const ChatMessage(isSender: false, text: 'wow that is cool'),
  ];

  final scrollController = ScrollController();

  void _addMessage(ChatMessage message) {
    setState(() => messages.add(message));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('chat_package')),
      body: ChatScreen(
        scrollController: scrollController,
        messages: messages,
        onSlideToCancelRecord: () => log('recording canceled'),
        onTextSubmit: (textMessage) => _addMessage(textMessage),
        handleRecord: (audioMessage, canceled) {
          if (!canceled && audioMessage != null) _addMessage(audioMessage);
        },
        handleImageSelect: (imageMessage) {
          if (imageMessage != null) _addMessage(imageMessage);
        },
        handleVideoSelect: (videoMessage) {
          if (videoMessage != null) _addMessage(videoMessage);
        },
      ),
    );
  }
}
