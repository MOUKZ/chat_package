import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';

/// A widget that displays the timestamp for a chat message.
///
// — Formats [message.createdAt] into a user-friendly string and applies
/// padding and text styling.
class DateTimeWidget extends StatelessWidget {
  /// The chat message containing the creation timestamp.
  final ChatMessage message;

  /// Optional style for the timestamp text.
  final TextStyle? sendDateTextStyle;

  /// Creates a [DateTimeWidget].
  ///
  /// - [message]: the chat message whose timestamp will be displayed.
  /// - [sendDateTextStyle]: custom text style for the timestamp.
  const DateTimeWidget({
    Key? key,
    required this.message,
    this.sendDateTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = dateStringFormatter(
      message.createdAt ?? DateTime.now(),
    );

    // Use bodySmall in place of the removed caption style
    final defaultStyle = Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontSize: 12, color: Colors.grey) ??
        const TextStyle(fontSize: 12, color: Colors.grey);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 2,
      ),
      child: Text(
        formattedDate,
        style: sendDateTextStyle ?? defaultStyle,
      ),
    );
  }
}
