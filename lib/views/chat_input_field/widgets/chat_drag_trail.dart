import 'package:flutter/material.dart';

class ChatDragTrail extends StatelessWidget {
  final double rightPosition;
  final double cancelPosition;
  final int duration;
  final Color trailColor;
  const ChatDragTrail(
      {super.key,
      required this.rightPosition,
      required this.cancelPosition,
      required this.duration,
      required this.trailColor});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: rightPosition,
      bottom: 5,
      child: AnimatedContainer(
        height: 100,
        width: cancelPosition,
        duration: Duration(milliseconds: duration),
        curve: Curves.ease,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: trailColor,
        ),
      ),
    );
  }
}
