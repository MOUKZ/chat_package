library chat_package;

import 'dart:developer';

import 'package:chat_package/components/message/message_widget.dart';
import 'package:chat_package/components/new_chat_input_field/new_chat_input_field.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:chat_package/components/chat_input_field/chat_input_field.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  ///color of all message containers if its belongs to the user
  final Color? senderColor;

  ///color of the inactive part of the audio slider
  final Color? inActiveAudioSliderColor;

  ///color of the active part of the audio slider
  final Color? activeAudioSliderColor;

  ///scrollController for the chat screen
  final ScrollController? scrollController;

  /// the color of the outer container and the color used to hide
  /// the text on slide
  final Color chatInputFieldColor;

  ///hint text to be shown for sending messages
  final String sendMessageHintText;

  /// these parameters for changing the text and icons in the [attachment-bottom-sheet]
  /// text shown wen trying to chose image attachment from gallery in attachment
  /// bottom sheet
  final String imageAttachmentFromGalleryText;

  /// Icon shown wen trying to chose image attachment from gallery in attachment
  /// bottom sheet
  final Icon? imageAttachmentFromGalleryIcon;

  /// text shown wen trying to chose image attachment from camera in attachment
  /// bottom sheet
  final String imageAttachmentFromCameraText;

  /// Icon shown wen trying to chose image attachment from camera in attachment
  /// bottom sheet
  final Icon? imageAttachmentFromCameraIcon;

  /// text shown wen trying to chose image attachment cancel text in attachment
  /// bottom sheet
  final String imageAttachmentCancelText;

  /// Icon shown wen trying to chose image attachment cancel text in attachment
  /// bottom sheet
  final Icon? imageAttachmentCancelIcon;

  /// image attachment text style in attachment
  /// bottom sheet
  final TextStyle? imageAttachmentTextStyle;

  ///hint text to be shown for recording voice note
  final String recordingNoteHintText;

  /// handel [text message] on submit
  final Function(String? text)? onSubmit;

  /// [required] the list of chat messages
  final List<ChatMessage> messages;

  /// function to handel successful recordings, bass to override
  final Function(String? path, bool canceled)? handleRecord;

  /// function to handel image selection
  final Function(XFile)? handleImageSelect;

  /// to handel canceling of the record
  final VoidCallback? onSlideToCancelRecord;

  ///TextEditingController to handel input text
  final TextEditingController? textEditingController;

  final BoxDecoration? chatInputFieldDecoration;

  /// use this flag to disable the input
  final bool disableInput;

  /// git the chat input field padding
  final EdgeInsets? chatInputFieldPadding;

  /// text style for the message container
  final TextStyle? messageContainerTextStyle;

  /// text style for the message container date
  final TextStyle? sendDateTextStyle;

  /// this is an optional parameter to override the default attachment bottom sheet
  final Function(BuildContext context)? attachmentClick;

  ChatScreen({
    Key? key,
    this.senderColor,
    this.inActiveAudioSliderColor,
    this.activeAudioSliderColor,
    required this.messages,
    this.scrollController,
    this.sendMessageHintText = 'Enter message here',
    this.recordingNoteHintText = 'Now Recording',
    this.imageAttachmentFromGalleryText = 'From Gallery',
    this.imageAttachmentFromCameraText = 'From Camera',
    this.imageAttachmentCancelText = 'Cancel',
    this.chatInputFieldColor = const Color(0xFFCFD8DC),
    this.imageAttachmentTextStyle,
    this.handleRecord,
    this.handleImageSelect,
    this.onSlideToCancelRecord,
    this.textEditingController,
    this.disableInput = false,
    this.chatInputFieldDecoration,
    this.onSubmit,
    this.chatInputFieldPadding,
    this.imageAttachmentFromGalleryIcon,
    this.imageAttachmentFromCameraIcon,
    this.imageAttachmentCancelIcon,
    this.messageContainerTextStyle,
    this.sendDateTextStyle,
    this.attachmentClick,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
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
            messageContainerTextStyle: widget.messageContainerTextStyle,
            sendDateTextStyle: widget.sendDateTextStyle,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 5,
          right: 5,
          child: NewChatInputField(),
        ),
      ],
    );
  }
}
