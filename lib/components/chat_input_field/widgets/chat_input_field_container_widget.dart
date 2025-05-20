import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../utils/constants.dart';

class ChatInputFieldContainerWidget extends StatefulWidget {
  final Color chatInputFieldColor;
  final bool isRecording;
  final String recordingNoteHintText;
  final int recordTime;
  final TextEditingController textController;
  final String sendMessageHintText;
  final GlobalKey<FormState> formKey;
  final void Function(BuildContext context) attachmentClick;
  final ValueChanged<String>? onTextFieldValueChanged;
  final VoidCallback? onSubmitted;

  const ChatInputFieldContainerWidget({
    Key? key,
    required this.chatInputFieldColor,
    required this.isRecording,
    required this.recordingNoteHintText,
    required this.recordTime,
    required this.textController,
    required this.sendMessageHintText,
    required this.formKey,
    required this.attachmentClick,
    this.onTextFieldValueChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _ChatInputFieldContainerWidgetState createState() =>
      _ChatInputFieldContainerWidgetState();
}

class _ChatInputFieldContainerWidgetState
    extends State<ChatInputFieldContainerWidget> {
  @override
  Widget build(BuildContext context) {
    final isRecording = widget.isRecording;
    final iconData = isRecording ? Icons.delete : Icons.camera_alt_outlined;
    final iconColor = isRecording
        ? kErrorColor
        : Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.64);

    return Container(
      decoration: BoxDecoration(
        color: widget.chatInputFieldColor,
        borderRadius: BorderRadius.circular(40), // TODO: allow custom shape
      ),
      child: Row(
        children: [
          const SizedBox(width: 50),
          Expanded(
            child: Form(
              key: widget.formKey,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: isRecording
                    ? SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            '${widget.recordingNoteHintText} ${StopWatchTimer.getDisplayTime(widget.recordTime)}',
                          ),
                        ),
                      )
                    : TextFormField(
                        controller: widget.textController,
                        onChanged: widget.onTextFieldValueChanged,
                        onFieldSubmitted: (_) => widget.onSubmitted?.call(),
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          hintText: widget.sendMessageHintText,
                          border: InputBorder.none,
                        ),
                      ),
              ),
            ),
          ),
          InkWell(
            onTap: () => widget.attachmentClick(context),
            child: Icon(iconData, color: iconColor),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
