import 'package:flutter/material.dart';
import 'package:chat_package/components/message/date_time_widget.dart';
import 'package:chat_package/components/message/audio_message/audio_message_widget.dart';
import 'package:chat_package/components/message/image_message/image_message_widget.dart';
import 'package:chat_package/components/message/text_message/text_message_widget.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';

/// Renders a chat bubble (text, image, audio, or video) plus its timestamp.
///
/// Supports custom bubble colors for sender and receiver.
class MessageWidget extends StatelessWidget {
  /// The chat message data.
  final ChatMessage message;

  /// Base color for the sender’s bubble.
  final Color senderColor;

  /// Base color for the receiver’s bubble.
  final Color receiverColor;

  /// Color of the inactive portion of the audio slider.
  final Color inactiveAudioSliderColor;

  /// Color of the active portion of the audio slider.
  final Color activeAudioSliderColor;

  /// Optional text style for message content (used by ImageMessageWidget).
  final TextStyle? messageContainerTextStyle;

  /// Optional text style for the timestamp.
  final TextStyle? sendDateTextStyle;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.senderColor,
    required this.receiverColor,
    required this.inactiveAudioSliderColor,
    required this.activeAudioSliderColor,
    this.messageContainerTextStyle,
    this.sendDateTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSender = message.isSender;
    final alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;
    final crossAxis =
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isSender ? senderColor : receiverColor;

    // Choose the correct content widget based on message type
    final content = message.chatMedia == null
        ? TextMessageWidget(
            message: message,
            senderColor: bubbleColor,
          )
        : message.chatMedia!.mediaType.when(
            imageMediaType: () => ImageMessageWidget(
              message: message,
              senderColor: bubbleColor,
              messageContainerTextStyle: messageContainerTextStyle,
            ),
            audioMediaType: () => AudioMessageWidget(
              message: message,
              senderColor: bubbleColor,
              inactiveAudioSliderColor: inactiveAudioSliderColor,
              activeAudioSliderColor: activeAudioSliderColor,
            ),
            videoMediaType: () {
              // TODO: implement a VideoMessageWidget
              return const SizedBox.shrink();
            },
          );

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Align(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: crossAxis,
          children: [
            content,
            const SizedBox(height: 3),
            DateTimeWidget(
              message: message,
              sendDateTextStyle: sendDateTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
