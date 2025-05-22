/// lib/src/presentation/widgets/chat_screen.dart
library chat_package;

import 'package:flutter/material.dart';
import 'package:chat_package/components/chat_input_field/chat_input_field.dart';
import 'package:chat_package/components/chat_input_field/widgets/recording_button.dart';
import 'package:chat_package/components/chat_input_field/widgets/wave_animation.dart';
import 'package:chat_package/components/message/message_widget.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';

/// A full-screen chat UI consisting of a message list and an input field.
///
/// Displays [messages] in a scrollable list and a [ChatInputField] at the bottom.
/// Supports text, image, and audio messages, with customizable styling and callbacks.
///
/// Example:
/// ```dart
/// ChatScreen(
///   messages: messages,
///   scrollController: _scrollController,
///   textEditingController: _textController,
///   onTextSubmit: (msg) => sendText(msg),
///   onImageSelected: (msg) => sendImage(msg),
///   onRecordComplete: (msg) => sendAudio(msg),
/// );
/// ```
class ChatScreen extends StatelessWidget {
  /// Creates a new [ChatScreen].
  ///
  /// Requires [messages], [scrollController], [textEditingController],
  /// [onTextSubmit], [onImageSelected], and [onRecordComplete].
  const ChatScreen({
    Key? key,

    /// The list of chat messages to display.
    required this.messages,

    /// Controller for the message list scrolling.
    required this.scrollController,

    /// Controller for the text input field.
    required this.textEditingController,

    /// Callback invoked when a text message is submitted.
    required this.onTextSubmit,

    /// Callback invoked when an image message is selected.
    required this.onImageSelected,

    /// Callback invoked when audio recording is completed.
    required this.onRecordComplete,

    /// Flag to enable or disable user input.
    this.enableInput = true,

    /// Hint text displayed when recording audio.
    this.recordingNoteHintText = 'Now Recording',

    /// Text for the “From Camera” option in the attachment sheet.
    this.cameraText = 'From Camera',

    /// Icon for the “From Camera” option.
    this.cameraIcon,

    /// Text for the “From Gallery” option.
    this.galleryText = 'From Gallery',

    /// Icon for the “From Gallery” option.
    this.galleryIcon,

    /// Text for the “Cancel” option.
    this.cancelText = 'Cancel',

    /// Icon for the “Cancel” option.
    this.cancelIcon,

    /// Style for the option labels in the bottom sheet.
    this.chatBottomSheetTextStyle,

    /// Decoration for the text input field.
    this.textFieldDecoration,

    /// Padding around the chat field.
    this.chatFieldPadding,

    /// Margin around the chat field.
    this.chatFieldMargin,

    /// Whether to show the wave animation during recording.
    this.showWaveAnimation = true,

    /// Duration of the wave animation.
    this.waveDuration,

    /// Style of the wave animation.
    this.waveStyle,

    /// Style of the recording button.
    this.buttonStyle,

    /// Text direction for the input field.
    this.textDirection,

    /// Color used for sender message bubble.
    this.senderColor,

    /// Color used for receiver message bubble.
    this.receiverColor,

    /// Active color for the audio slider.
    this.activeAudioSliderColor,

    /// Inactive color for the audio slider.
    this.inactiveAudioSliderColor,
  }) : super(key: key);

  /// The list of chat messages to display.
  final List<ChatMessage> messages;

  /// Controller for the message list scrolling.
  final ScrollController scrollController;

  /// Controller for the text input field.
  final TextEditingController textEditingController;

  /// Callback invoked when a text message is submitted.
  final ValueChanged<ChatMessage> onTextSubmit;

  /// Callback invoked when an image message is selected.
  final ValueChanged<ChatMessage> onImageSelected;

  /// Callback invoked when audio recording is completed.
  final ValueChanged<ChatMessage> onRecordComplete;

  /// Flag to enable or disable user input.
  final bool enableInput;

  /// Hint text displayed when recording audio.
  final String recordingNoteHintText;

  /// Text for the “From Camera” option in the attachment sheet.
  final String cameraText;

  /// Icon for the “From Camera” option.
  final Icon? cameraIcon;

  /// Text for the “From Gallery” option.
  final String galleryText;

  /// Icon for the “From Gallery” option.
  final Icon? galleryIcon;

  /// Text for the “Cancel” option.
  final String cancelText;

  /// Icon for the “Cancel” option.
  final Icon? cancelIcon;

  /// Style for the option labels in the bottom sheet.
  final TextStyle? chatBottomSheetTextStyle;

  /// Decoration for the text input field.
  final InputDecoration? textFieldDecoration;

  /// Padding around the chat field.
  final EdgeInsetsGeometry? chatFieldPadding;

  /// Margin around the chat field.
  final EdgeInsetsGeometry? chatFieldMargin;

  /// Whether to show the wave animation during recording.
  final bool showWaveAnimation;

  /// Duration of the wave animation.
  final Duration? waveDuration;

  /// Style of the wave animation.
  final WaveAnimationStyle? waveStyle;

  /// Style of the recording button.
  final RecordingButtonStyle? buttonStyle;

  /// Text direction for the input field.
  final TextDirection? textDirection;

  /// Color used for sender message bubble.
  final Color? senderColor;

  /// Color used for receiver message bubble.
  final Color? receiverColor;

  /// Active color for the audio slider.
  final Color? activeAudioSliderColor;

  /// Inactive color for the audio slider.
  final Color? inactiveAudioSliderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 2,
            ).copyWith(bottom: 100),
            controller: scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return MessageWidget(
                receiverColor: receiverColor ?? kSecondaryColor,
                senderColor: senderColor ?? kPrimaryColor,
                activeAudioSliderColor:
                    activeAudioSliderColor ?? kSecondaryColor,
                inactiveAudioSliderColor:
                    inactiveAudioSliderColor ?? kLightColor,
                message: message,
                messageContainerTextStyle: null,
                sendDateTextStyle: null,
              );
            },
          ),
        ),
        ChatInputField(
          textController: textEditingController,
          onTextSubmit: onTextSubmit,
          onImageSelected: onImageSelected,
          onRecordComplete: onRecordComplete,
          enableInput: enableInput,
          recordingNoteHintText: recordingNoteHintText,
          cameraText: cameraText,
          cameraIcon: cameraIcon,
          galleryText: galleryText,
          galleryIcon: galleryIcon,
          cancelText: cancelText,
          cancelIcon: cancelIcon,
          chatBottomSheetTextStyle: chatBottomSheetTextStyle,
          textFieldDecoration: textFieldDecoration,
          chatFieldPadding: chatFieldPadding,
          chatFieldMargin: chatFieldMargin,
          showWaveAnimation: showWaveAnimation,
          waveDuration: waveDuration,
          waveStyle: waveStyle,
          buttonStyle: buttonStyle,
          textDirection: textDirection,
        ),
      ],
    );
  }
}
