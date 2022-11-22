import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../utils/constants.dart';

class ChatInputFeild extends StatefulWidget {
  final Color containerColor;
  final bool isRecording;
  final String recordinNoteHintText;
  final int recordTime;
  final TextEditingController textController;
  final String sendMessageHintText;
  final Function(String? text)? onSubmit;
  final Function(BuildContext context) attachmintClick;

  const ChatInputFeild({
    super.key,
    required this.containerColor,
    required this.isRecording,
    required this.recordinNoteHintText,
    required this.recordTime,
    required this.textController,
    required this.sendMessageHintText,
    this.onSubmit,
    required this.attachmintClick,
  });

  @override
  State<ChatInputFeild> createState() => _ChatInputFeildState();
}

class _ChatInputFeildState extends State<ChatInputFeild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 60,
        left: 10,
      ),
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: widget.containerColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 0.0, right: 0),
              child: widget.isRecording
                  ? Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          widget.recordinNoteHintText +
                              " " +
                              StopWatchTimer.getDisplayTime(widget.recordTime),
                        ),
                      ),
                    )
                  : TextField(
                      controller: widget.textController,
                      decoration: InputDecoration(
                        hintText: widget.sendMessageHintText,
                        border: InputBorder.none,
                      ),
                      textDirection: TextDirection.ltr,
                      onSubmitted: (text) {
                        if (widget.onSubmit != null) {
                          widget.onSubmit!(text);
                        }
                        widget.textController.clear();
                        setState(() {});
                      },
                    ),
            ),
          ),
          InkWell(
              onTap: () {
                widget.attachmintClick(context);
              },
              child: Icon(
                widget.isRecording ? Icons.delete : Icons.camera_alt_outlined,
                color: widget.isRecording
                    ? kErrorColor
                    : Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .color!
                        .withOpacity(0.64),
              )),
        ],
      ),
    );
  }
}
