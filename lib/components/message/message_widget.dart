import 'package:chat_package/components/message/date_time_widget.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:chat_package/components/message/audio_message/audio_message_widget.dart';
import 'package:chat_package/components/message/image_message/image_message_widget.dart';
import 'package:chat_package/components/message/text_message/text_message_widget.dart';
import 'package:chat_package/components/message/video_message/video_message_widget.dart';
import 'package:flutter/material.dart';

/// Determines the message type ([MediaType]) of a [ChatMessage] and renders the
/// matching message widget (text, image, audio or video).
class MessageWidget extends StatelessWidget {
  final Color senderColor;
  final Color inActiveAudioSliderColor;
  final Color activeAudioSliderColor;
  final TextStyle? messageContainerTextStyle;
  final TextStyle? sendDateTextStyle;
  final TextDirection textDirection;
  final double textMessageWidthFraction;
  final double imageMessageWidthFraction;
  final double audioMessageWidthFraction;

  const MessageWidget({
    super.key,
    required this.message,
    required this.senderColor,
    required this.inActiveAudioSliderColor,
    required this.activeAudioSliderColor,
    this.messageContainerTextStyle,
    this.sendDateTextStyle,
    this.textDirection = TextDirection.ltr,
    this.textMessageWidthFraction = 0.5,
    this.imageMessageWidthFraction = 0.45,
    this.audioMessageWidthFraction = 0.7,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Align(
        alignment:
            message.isSender ? Alignment.centerRight : Alignment.centerLeft,

        /// check message type and render the right widget
        child: Column(
          crossAxisAlignment: message.isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            messageContent(message),
            const SizedBox(
              height: 3,
            ),
            DateTimeWidget(
              message: message,
              sendDateTextStyle: sendDateTextStyle,
            )
          ],
        ),
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
        textDirection: textDirection,
        widthFraction: textMessageWidthFraction,
      );
    }

    switch (message.chatMedia!.mediaType) {
      case MediaType.image:
        return ImageMessageWidget(
          message: message,
          senderColor: senderColor,
          messageContainerTextStyle: messageContainerTextStyle,
          widthFraction: imageMessageWidthFraction,
        );
      case MediaType.audio:
        return AudioMessageWidget(
          message: message,
          senderColor: senderColor,
          activeAudioSliderColor: activeAudioSliderColor,
          inActiveAudioSliderColor: inActiveAudioSliderColor,
          widthFraction: audioMessageWidthFraction,
        );
      case MediaType.video:
        return VideoMessageWidget(
          message: message,
          senderColor: senderColor,
          messageContainerTextStyle: messageContainerTextStyle,
          widthFraction: imageMessageWidthFraction,
        );
    }
  }
}
