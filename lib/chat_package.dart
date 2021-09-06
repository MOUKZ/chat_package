library chat_package;

import 'dart:developer';

import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:chat_package/views/componants/chat_input_feild.dart';
import 'package:chat_package/views/componants/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  //color of all message containers if its belongs to the user
  final Color? senderColor;
  //color of the inactive part of the audio slider
  final Color? inActiveAudioSliderColor;
  //color of the active part of the audio slider
  final Color? activeAudioSliderColor;
  //scrollcontroller for the chat screen
  ScrollController? scrollController;

  /// the color of the outer container and the color used to hide
  /// the text on slide
  final Color containerColor;
//hint text to be shown for sending messages
  final String sendMessageHintText;
  // texts shown wen trying to chose image attachment
  final String imageAttachmentFromGalary;
  final String imageAttachmentFromCamery;
  final String imageAttachmentCancelText;
  final Color imageAttachmentTextColor;

  //hint text to be shown for recording voice note
  final String recordinNoteHintText;
  Function(String? text)? onSubmit;
// [required] the list of chat messages
  List<ChatMessage> messages;
  // function to handel sucessful recordings, bass to override
  final Function(String? path, bool cnaceled)? handleRecord;
// function to handel image selection
  final Function(XFile)? handleImageSelect;
// to handel canceling of the record
  final VoidCallback? onSlideToCancelRecord;
  //TextEditingController to handel input text
  final TextEditingController? textEditingController;

// use this flag to disable the input
  final bool disableInput;

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
    this.imageAttachmentTextColor = const Color(0xFF255965),
    this.handleRecord,
    this.handleImageSelect,
    this.onSlideToCancelRecord,
    this.textEditingController,
    this.disableInput = false,
  }) : super(key: key);

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
            imageAttachmentTextColor: widget.imageAttachmentTextColor,
            containerColor: widget.containerColor,
            recordinNoteHintText: widget.recordinNoteHintText,
            sendMessageHintText: widget.sendMessageHintText,
            disableInput: widget.disableInput,
            handleRecord: widget.handleRecord ??
                (source, canceled) {
                  if (!canceled && source != null) {
                    setState(() {
                      widget.messages
                          .add(ChatMessage(isSender: true, audioPath: source));
                      widget.scrollController?.jumpTo(
                          widget.scrollController!.position.maxScrollExtent +
                              90);
                    });
                  }
                },
            handleImageSelect: widget.handleImageSelect ??
                (file) async {
                  final bytes = await file.readAsBytes();
                  final image = await decodeImageFromList(bytes);
                  final name = file.path.split('/').last;
                  setState(() {
                    widget.messages
                        .add(ChatMessage(isSender: true, imagePath: file.path));
                  });

                  setState(() {
                    widget.scrollController?.jumpTo(
                        widget.scrollController!.position.maxScrollExtent +
                            300);
                  });
                },
            onSlideToCancelRecord: widget.onSlideToCancelRecord ??
                () {
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
            textController:
                widget.textEditingController ?? TextEditingController(),
          ),
        ),
      ],
    );
  }
}
