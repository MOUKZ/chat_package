import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';

/// Renders a single text message bubble.
class TextMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final Color senderColor;

  const TextMessageWidget({
    Key? key,
    required this.message,
    required this.senderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSender = message.isSender;
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.5;
    final backgroundColor = senderColor.withOpacity(isSender ? 1 : 0.1);
    final textColor = isSender
        ? Colors.white
        : Theme.of(context).textTheme.bodyMedium!.color!;
    final alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxBubbleWidth,
          minWidth: 50,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 0.75,
            vertical: kDefaultPadding * 0.5,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            message.text,
            textDirection: TextDirection.rtl,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
