import 'package:flutter/material.dart';
import 'package:chat_package/components/message/date_time_widget.dart';
import 'package:chat_package/components/message/audio_message/audio_message_widget.dart';
import 'package:chat_package/components/message/image_message/image_message_widget.dart';
import 'package:chat_package/components/message/text_message/text_message_widget.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';

/// A chat bubble that renders text, image, audio (or future video) messages,
/// along with a timestamp.
///
/// Aligns to the right for sender messages and to the left for receiver messages,
/// applying distinct bubble colors and styles.
class MessageWidget extends StatelessWidget {
  /// Data for this chat message (text, media, timestamp, sender flag).
  final ChatMessage message;

  /// Bubble color for messages sent by the user.
  final Color senderColor;

  /// Bubble color for messages received from others.
  final Color receiverColor;

  /// Inactive track color for audio message slider.
  final Color inactiveAudioSliderColor;

  /// Active track color for audio message slider.
  final Color activeAudioSliderColor;

  /// Optional text style applied inside image message containers.
  final TextStyle? messageContainerTextStyle;

  /// Optional style for the timestamp text.
  final TextStyle? sendDateTextStyle;

  /// Creates a [MessageWidget].
  ///
  /// All color parameters are required to ensure consistent theming.
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
    final bool isSender = message.isSender;
    final Alignment alignment =
        isSender ? Alignment.centerRight : Alignment.centerLeft;
    final CrossAxisAlignment crossAxisAlignment =
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final Color bubbleColor = isSender ? senderColor : receiverColor;

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Align(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            _buildContent(bubbleColor),
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

  /// Chooses and returns the correct content widget based on [message].
  ///
  /// - Text messages render with [TextMessageWidget].
  /// - Image messages use [ImageMessageWidget].
  /// - Audio messages use [AudioMessageWidget].
  /// - Video messages are not yet implemented.
  Widget _buildContent(Color bubbleColor) {
    if (message.chatMedia == null) {
      return TextMessageWidget(
        message: message,
        senderColor: bubbleColor,
      );
    }

    return message.chatMedia!.mediaType.when(
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
        // TODO: Replace with VideoMessageWidget when available
        return const SizedBox.shrink();
      },
    );
  }
}
