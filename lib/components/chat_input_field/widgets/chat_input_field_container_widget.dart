import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../utils/constants.dart';

/// The visual container of the chat input field: shows either the text field
/// (with an attachment button) or the "now recording" indicator.
class ChatInputFieldContainerWidget extends StatelessWidget {
  final Color chatInputFieldColor;
  final double containerBorderRadius;
  final bool isRecording;
  final String recordingNoteHintText;
  final int recordTime;
  final TextEditingController textController;
  final String sendMessageHintText;
  final TextDirection textDirection;
  final GlobalKey<FormState> formKey;
  final Function(BuildContext context) attachmentClick;
  final Function()? onSubmitted;
  final Function(String)? onTextFieldValueChanged;

  const ChatInputFieldContainerWidget({
    super.key,
    required this.chatInputFieldColor,
    required this.containerBorderRadius,
    required this.isRecording,
    required this.recordingNoteHintText,
    required this.recordTime,
    required this.textController,
    required this.sendMessageHintText,
    required this.textDirection,
    required this.formKey,
    required this.attachmentClick,
    required this.onTextFieldValueChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Container(
      decoration: BoxDecoration(
        color: chatInputFieldColor,
        borderRadius: BorderRadius.circular(containerBorderRadius),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => attachmentClick(context),
            borderRadius: BorderRadius.circular(containerBorderRadius),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              child: Icon(
                isRecording ? Icons.delete : Icons.camera_alt_outlined,
                color: isRecording
                    ? kErrorColor
                    : iconColor?.withValues(alpha: 0.64),
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: formKey,
              child: isRecording
                  ? SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          '$recordingNoteHintText '
                          '${StopWatchTimer.getDisplayTime(recordTime)}',
                        ),
                      ),
                    )
                  : TextFormField(
                      controller: textController,
                      onChanged: onTextFieldValueChanged,
                      textDirection: textDirection,
                      decoration: InputDecoration(
                        hintText: sendMessageHintText,
                        border: InputBorder.none,
                      ),
                      onFieldSubmitted: (_) => onSubmitted?.call(),
                    ),
            ),
          ),
          // Reserved space for the floating mic/send button that is positioned
          // on top of the right edge of this container.
          const SizedBox(width: 50),
        ],
      ),
    );
  }
}
