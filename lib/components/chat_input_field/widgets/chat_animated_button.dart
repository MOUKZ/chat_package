import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';

class ChatAnimatedButton extends StatelessWidget {
  final int duration;
  final rightPosition;
  final bool isRecording;
  final bool isText;
  final Widget? animatedButtonWidget;
  final Function() onAnimatedButtonTap;
  final Function() onAnimatedButtonLongPress;
  final Function(LongPressMoveUpdateDetails)
      onAnimatedButtonLongPressMoveUpdate;
  final Function(LongPressEndDetails details) onAnimatedButtonLongPressEnd;
  final BorderRadiusGeometry? borderRadius;
  final IconData sendTextIcon;
  //TODO SHould add button shape

  const ChatAnimatedButton(
      {super.key,
      required this.duration,
      this.rightPosition,
      required this.isRecording,
      required this.isText,
      this.animatedButtonWidget,
      required this.onAnimatedButtonTap,
      required this.onAnimatedButtonLongPress,
      required this.onAnimatedButtonLongPressMoveUpdate,
      required this.onAnimatedButtonLongPressEnd,
      this.borderRadius,
      required this.sendTextIcon});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: duration),
      curve: Curves.bounceOut,
      right: rightPosition,
      // top: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: onAnimatedButtonTap,
        onLongPress: onAnimatedButtonLongPress,
        onLongPressMoveUpdate: onAnimatedButtonLongPressMoveUpdate,
        onLongPressEnd: onAnimatedButtonLongPressEnd,
        child: AnimatedSize(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 100),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: kSecondaryColor,
            ),
            child: isRecording
                ? animatedButtonWidget
                : Icon(
                    isText ? sendTextIcon : Icons.mic,
                    color: Colors.white,
                    size: 25,
                  ),
          ),
        ),
      ),
    );
  }
}
