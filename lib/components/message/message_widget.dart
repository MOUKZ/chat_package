import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:chat_package/components/message/audio_message/audio_message_widget.dart';
import 'package:chat_package/components/message/image_message/image_message_widget.dart';
import 'package:chat_package/components/message/text_message/text_message_widget.dart';
import 'package:flutter/material.dart';

/// widget used to determine the right message type
/// //TODO add color support for reciver
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

  Widget messageContent(ChatMessage message) {
    /// check message type and render the right widget
    if (message.chatMedia == null) {
      /// render text message
      return TextMessageWidget(
        message: message,
        senderColor: senderColor,
      );
    } else {
      return message.chatMedia!.mediaType.maybeWhen(
          imageMediaType: () => ImageMessageWidget(
                message: message,
                senderColor: senderColor,
              ),
          audioMediaType: () => AudioMessageWidget(
                message: message,
                senderColor: senderColor,
                activeAudioSliderColor: activeAudioSliderColor,
                inActiveAudioSliderColor: inActiveAudioSliderColor,
              ),
          //TODO add this
          videoMediaType: () => Container(),
          orElse: () => TextMessageWidget(
                message: message,
                senderColor: senderColor,
              ));
    }
  }
}
