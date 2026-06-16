import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';

/// this widget is used to render a text message container

class TextMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final Color senderColor;

  /// Text direction of the message content. Defaults to [TextDirection.ltr].
  final TextDirection textDirection;

  /// Maximum width of the bubble as a fraction of the available width.
  final double widthFraction;

  const TextMessageWidget({
    super.key,
    required this.message,
    required this.senderColor,
    this.textDirection = TextDirection.ltr,
    this.widthFraction = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * widthFraction,
              minWidth: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 0.75,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: senderColor.withValues(alpha: message.isSender ? 1 : 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              message.text,
              textDirection: textDirection,
              style: TextStyle(
                color: message.isSender
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
