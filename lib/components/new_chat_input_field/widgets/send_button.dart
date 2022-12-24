import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final Color? sendButtonColor;
  final bool disableRecording;
  final IconData? sendButtonTextIcon;
  final IconData? sendButtonRecordIcon;
  final Color? sendButtonIconColor;

  final bool isText;
  final Function() onPressed;
  final Function() onLongPress;
  final Function(double) onDragChange;
  const SendButton({
    Key? key,
    required this.isText,
    required this.onPressed,
    required this.onLongPress,
    required this.onDragChange,
    this.sendButtonColor = kPrimaryColor,
    this.disableRecording = false,
    this.sendButtonRecordIcon,
    this.sendButtonTextIcon,
    this.sendButtonIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPressMoveUpdate: (details) {
        if (!isText &&
            details.localPosition.dx < 0 &&
            details.localPosition.dx >= -20 &&
            !disableRecording) {
          onDragChange(details.localPosition.dx);
        }
      },
      onLongPressEnd: (details) {
        if (!disableRecording) {
          onDragChange(0);
        }
      },
      onLongPress: () {
        if (!isText && !disableRecording) {
          onLongPress();
        }
      },
      child: CircleAvatar(
        radius: 25,
        backgroundColor: sendButtonColor,
        child: Icon(
          isText
              ? (sendButtonTextIcon ?? Icons.send)
              : (!disableRecording
                  ? (sendButtonRecordIcon ?? Icons.mic)
                  : (sendButtonTextIcon ?? Icons.send)),
          color: sendButtonIconColor ?? Colors.white,
        ),
      ),
    );
  }
}
