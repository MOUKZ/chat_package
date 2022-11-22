import 'package:flutter/material.dart';

class ChatDragTrail extends StatelessWidget {
  final double rightPosstion;
  final double cancelPossition;
  final int duration;
  final Color trailColor;
  const ChatDragTrail(
      {super.key,
      required this.rightPosstion,
      required this.cancelPossition,
      required this.duration,
      required this.trailColor});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: rightPosstion,
      bottom: 5,
      child: AnimatedContainer(
        height: 100,
        width: cancelPossition,
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
