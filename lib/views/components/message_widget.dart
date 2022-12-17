import 'package:chat_package/enums/chat_message_type.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:chat_package/views/audio_message/audio_message_widget.dart';
import 'package:chat_package/views/components/image_message_widget.dart';
import 'package:chat_package/views/components/text_message_widget.dart';
import 'package:flutter/material.dart';

/// widget used to determine the right message type
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
    Widget messageContent(ChatMessage message) {
      /// check message type and render the right widget
      switch (message.getType()) {
        case ChatMessageType.TextMessage:

          /// render text message
          return TextMessageWidget(
            message: message,
            senderColor: senderColor,
          );
        case ChatMessageType.AudioMessage:

          /// render audion message
          return AudioMessageWidget(
            message: message,
            senderColor: senderColor,
            activeAudioSliderColor: activeAudioSliderColor,
            inActiveAudioSliderColor: inActiveAudioSliderColor,
          );
        case ChatMessageType.ImageMessage:

          /// render image message
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

        /// check message type and render the right widget
        child: messageContent(message),
      ),
    );
  }
}
