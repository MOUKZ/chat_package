import 'package:chat_package/enums/chat_message_type.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:chat_package/views/componants/audio_message_widget.dart';
import 'package:chat_package/views/componants/image_message_widget.dart';
import 'package:chat_package/views/componants/text_message_widget.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Color senderColor;
  final Color inActiveAudioSliderColor;
  final Color activeAudioSliderColor;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.senderColor,
    required this.inActiveAudioSliderColor,
    required this.activeAudioSliderColor,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage message) {
      switch (message.getType()) {
        case ChatMessageType.TextMessage:
          return TextMessageWidget(
            message: message,
            senderColor: senderColor,
          );
        case ChatMessageType.AudioMessage:
          return AudioMessageWidget(
            message: message,
            senderColor: senderColor,
            activeAudioSliderColor: activeAudioSliderColor,
            inActiveAudioSliderColor: inActiveAudioSliderColor,
          );
        case ChatMessageType.ImageMessage:
          return ImageMessageWidget(
            message: message,
            senderColor: senderColor,
          );
        default:
          return SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Align(
        alignment:
            message.isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: messageContaint(message),
      ),
    );
  }
}
