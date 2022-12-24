import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final bool sendButton;
  final Function() onPressed;
  final Function() onLongPress;
  final Function(double) onDragChange;
  const SendButton({
    Key? key,
    required this.sendButton,
    required this.onPressed,
    required this.onLongPress,
    required this.onDragChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPressMoveUpdate: (details) {
        if (!sendButton &&
            details.localPosition.dx < 0 &&
            details.localPosition.dx >= -20) {
          onDragChange(details.localPosition.dx);
        }
      },
      onLongPressEnd: (details) {
        onDragChange(0);
      },
      onLongPress: () {
        if (!sendButton) {
          onLongPress();
        }
      },
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Color(0xFF128C7E),
        child: Icon(
          sendButton ? Icons.send : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
