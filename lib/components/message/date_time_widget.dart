import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';

class DateTimeWidget extends StatelessWidget {
  final TextStyle? sendDateTextStyle;
  const DateTimeWidget({
    Key? key,
    required this.message,
    this.sendDateTextStyle,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        // top: 2,
        left: kDefaultPadding / 2,
        right: kDefaultPadding / 2,
      ),
      child: Text(
        dateStringFormatter(message.createdAt ?? DateTime.now()),
        style: sendDateTextStyle ?? TextStyle(fontSize: 12),
      ),
    );
  }
}
