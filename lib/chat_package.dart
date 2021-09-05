library chat_package;

import 'dart:developer';

import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:chat_package/views/componants/chat_input_feild.dart';
import 'package:chat_package/views/componants/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ChatScreen extends StatefulWidget {
  final Color? senderColor;
  final Color? inActiveAudioSliderColor;
  final Color? activeAudioSliderColor;
  ScrollController? scrollController;
  final Color containerColor;
  final String sendMessageHintText;
  final String imageAttachmentFromGalary;
  final String imageAttachmentFromCamery;
  final String imageAttachmentCancelText;

  //hit text to be shown for recording voice note
  final String recordinNoteHintText;
  Function(String? text)? onSubmit;

  List<ChatMessage> messages;

  ChatScreen({
    Key? key,
    this.senderColor,
    this.inActiveAudioSliderColor,
    this.activeAudioSliderColor,
    required this.messages,
    this.scrollController,
    this.sendMessageHintText = 'Enter message here',
    this.recordinNoteHintText = 'Now Recording',
    this.imageAttachmentFromGalary = 'From Galary',
    this.imageAttachmentFromCamery = 'From Camera',
    this.imageAttachmentCancelText = 'Cancel',
    this.containerColor = const Color(0xFFCFD8DC),
  }) : super(key: key);
  // final
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            controller: widget.scrollController ?? _controller,
            itemCount: widget.messages.length,
            itemBuilder: (context, index) => MessageWidget(
              message: widget.messages[index],
              activeAudioSliderColor:
                  widget.activeAudioSliderColor ?? kSecondaryColor,
              inActiveAudioSliderColor:
                  widget.inActiveAudioSliderColor ?? kLightColor,
              senderColor: widget.senderColor ?? kPrimaryColor,
            ),
          ),
        ),
        KeyboardVisibilityProvider(
          child: ChatInputField(
            imageAttachmentCancelText: widget.imageAttachmentCancelText,
            imageAttachmentFromCamery: widget.imageAttachmentFromCamery,
            imageAttachmentFromGalary: widget.imageAttachmentFromGalary,
            containerColor: widget.containerColor,
            recordinNoteHintText: widget.recordinNoteHintText,
            sendMessageHintText: widget.sendMessageHintText,
            handleRecord: (source, canceled) {
              if (!canceled && source != null) {
                setState(() {
                  widget.messages
                      .add(ChatMessage(isSender: true, audioPath: source));
                  widget.scrollController?.jumpTo(
                      widget.scrollController!.position.maxScrollExtent + 90);
                });
              }
            },
            handleImageSelect: (file) async {
              final bytes = await file.readAsBytes();
              final image = await decodeImageFromList(bytes);
              final name = file.path.split('/').last;
              setState(() {
                widget.messages
                    .add(ChatMessage(isSender: true, imagePath: file.path));
              });

              setState(() {
                widget.scrollController?.jumpTo(
                    widget.scrollController!.position.maxScrollExtent + 300);
              });
            },
            onSlideToCancelRecord: () {
              log('slide to cancel');
            },
            onSubmit: (text) {
              if (widget.onSubmit != null) {
                widget.onSubmit!(text);
              } else {
                if (text != null) {
                  setState(() {
                    widget.messages
                        .add(ChatMessage(isSender: true, text: text));

                    widget.scrollController?.jumpTo(
                        widget.scrollController!.position.maxScrollExtent + 50);
                  });
                }
              }
            },
            textController: TextEditingController(),
          ),
        ),
      ],
    );
  }
}
