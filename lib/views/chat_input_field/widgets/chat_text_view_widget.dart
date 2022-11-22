import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../utils/constants.dart';

class ChatTextViewWidget extends StatefulWidget {
  final Color containerColor;
  final bool isRecording;
  final String recordingNoteHintText;
  final int recordTime;
  final TextEditingController textController;
  final String sendMessageHintText;
  final Function(String? text)? onSubmit;
  final Function(BuildContext context) attachmentClick;

  const ChatTextViewWidget({
    super.key,
    required this.containerColor,
    required this.isRecording,
    required this.recordingNoteHintText,
    required this.recordTime,
    required this.textController,
    required this.sendMessageHintText,
    this.onSubmit,
    required this.attachmentClick,
  });

  @override
  State<ChatTextViewWidget> createState() => _ChatTextViewWidgetState();
}

class _ChatTextViewWidgetState extends State<ChatTextViewWidget> {
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
                          widget.recordingNoteHintText +
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
                widget.attachmentClick(context);
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
