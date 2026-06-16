library;

import 'package:camera/camera.dart';
import 'package:chat_package/components/message/message_widget.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:chat_package/components/chat_input_field/chat_input_field.dart';
import 'package:flutter/material.dart';

export 'package:chat_package/models/chat_message.dart';
export 'package:chat_package/models/media/chat_media.dart';
export 'package:chat_package/models/media/media_type.dart';

/// A ready-made, customizable chat UI that renders a list of [messages] and a
/// rich input field supporting text, voice notes, gallery images and in-app
/// camera photos/videos.
class ChatScreen extends StatefulWidget {
  /// Color of message bubbles that belong to the user (sender).
  final Color? senderColor;

  /// Color of the inactive part of the audio slider.
  final Color? inActiveAudioSliderColor;

  /// Color of the active part of the audio slider.
  final Color? activeAudioSliderColor;

  /// **Required.** Scroll controller for the chat list.
  final ScrollController scrollController;

  /// Background color of the input field container, also used to mask the text
  /// while sliding to cancel a recording.
  final Color chatInputFieldColor;

  /// Hint text shown for sending messages.
  final String sendMessageHintText;

  /// Label for the "from gallery" option in the attachment bottom sheet.
  final String imageAttachmentFromGalleryText;

  /// Icon for the "from gallery" option in the attachment bottom sheet.
  final Icon? imageAttachmentFromGalleryIcon;

  /// Label for the "from camera" option in the attachment bottom sheet.
  final String imageAttachmentFromCameraText;

  /// Icon for the "from camera" option in the attachment bottom sheet.
  final Icon? imageAttachmentFromCameraIcon;

  /// Label for the "cancel" option in the attachment bottom sheet.
  final String imageAttachmentCancelText;

  /// Icon for the "cancel" option in the attachment bottom sheet.
  final Icon? imageAttachmentCancelIcon;

  /// Text style for the attachment bottom sheet entries.
  final TextStyle? imageAttachmentTextStyle;

  /// Hint text shown while recording a voice note.
  final String recordingNoteHintText;

  /// **Required.** Called when a text message is submitted.
  final Function(ChatMessage textMessage) onTextSubmit;

  /// **Required.** The list of chat messages to render.
  final List<ChatMessage> messages;

  /// **Required.** Called with the recorded voice note, or `(null, true)` when
  /// the recording was canceled.
  final Function(ChatMessage? audioMessage, bool canceled) handleRecord;

  /// **Required.** Called with the selected/captured image message (or `null`).
  final Function(ChatMessage? imageMessage) handleImageSelect;

  /// Called with the captured video message (or `null`). When omitted, video
  /// captures fall back to [handleImageSelect].
  final Function(ChatMessage? videoMessage)? handleVideoSelect;

  /// Called when the user slides to cancel a recording.
  final VoidCallback? onSlideToCancelRecord;

  /// Optional external controller for the input text.
  final TextEditingController? textEditingController;

  /// Custom decoration for the input field container.
  final BoxDecoration? chatInputFieldDecoration;

  /// Disables the input field when `true`.
  final bool disableInput;

  /// Padding around the input field.
  final EdgeInsets? chatInputFieldPadding;

  /// Text style for media message captions.
  final TextStyle? messageContainerTextStyle;

  /// Text style for the message date.
  final TextStyle? sendDateTextStyle;

  /// Optional override for the default attachment bottom sheet.
  final Function(BuildContext context)? attachmentClick;

  /// Text direction used throughout the chat (input and text messages).
  final TextDirection textDirection;

  /// Resolution used by the in-app camera.
  final ResolutionPreset cameraResolution;

  /// Bit rate (bits/sec) used when recording voice notes.
  final int audioBitRate;

  /// Quality (0-100) applied to images picked from the gallery.
  final int imageQuality;

  /// Maximum width (px) applied to images picked from the gallery.
  final double imageMaxWidth;

  /// Radius of the input field container. Defaults to 40.
  final double containerBorderRadius;

  /// Radius of the send/record button. Defaults to 35.
  final double buttonRadius;

  /// Max width of a text bubble as a fraction of screen width. Defaults to 0.5.
  final double textMessageWidthFraction;

  /// Width of image/video messages as a fraction of screen width. Defaults to
  /// 0.45.
  final double imageMessageWidthFraction;

  /// Width of audio messages as a fraction of screen width. Defaults to 0.7.
  final double audioMessageWidthFraction;

  const ChatScreen({
    super.key,
    this.senderColor,
    this.inActiveAudioSliderColor,
    this.activeAudioSliderColor,
    required this.messages,
    required this.scrollController,
    required this.onTextSubmit,
    required this.handleRecord,
    required this.handleImageSelect,
    this.handleVideoSelect,
    this.sendMessageHintText = 'Enter message here',
    this.recordingNoteHintText = 'Now Recording',
    this.imageAttachmentFromGalleryText = 'From Gallery',
    this.imageAttachmentFromCameraText = 'From Camera',
    this.imageAttachmentCancelText = 'Cancel',
    this.chatInputFieldColor = const Color(0xFFCFD8DC),
    this.imageAttachmentTextStyle,
    this.onSlideToCancelRecord,
    this.textEditingController,
    this.disableInput = false,
    this.chatInputFieldDecoration,
    this.chatInputFieldPadding,
    this.imageAttachmentFromGalleryIcon,
    this.imageAttachmentFromCameraIcon,
    this.imageAttachmentCancelIcon,
    this.messageContainerTextStyle,
    this.sendDateTextStyle,
    this.attachmentClick,
    this.textDirection = TextDirection.ltr,
    this.cameraResolution = ResolutionPreset.high,
    this.audioBitRate = 128000,
    this.imageQuality = 70,
    this.imageMaxWidth = 1440,
    this.containerBorderRadius = 40,
    this.buttonRadius = 35,
    this.textMessageWidthFraction = 0.5,
    this.imageMessageWidthFraction = 0.45,
    this.audioMessageWidthFraction = 0.7,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: kDefaultPadding,
              top: kDefaultPadding,
            ),
            controller: widget.scrollController,
            itemCount: widget.messages.length,
            itemBuilder: (context, index) => MessageWidget(
              message: widget.messages[index],
              activeAudioSliderColor:
                  widget.activeAudioSliderColor ?? kSecondaryColor,
              inActiveAudioSliderColor:
                  widget.inActiveAudioSliderColor ?? kLightColor,
              senderColor: widget.senderColor ?? kPrimaryColor,
              messageContainerTextStyle: widget.messageContainerTextStyle,
              sendDateTextStyle: widget.sendDateTextStyle,
              textDirection: widget.textDirection,
              textMessageWidthFraction: widget.textMessageWidthFraction,
              imageMessageWidthFraction: widget.imageMessageWidthFraction,
              audioMessageWidthFraction: widget.audioMessageWidthFraction,
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 8),
            child: ChatInputField(
              imageAttachmentCancelText: widget.imageAttachmentCancelText,
              imageAttachmentFromCameraText:
                  widget.imageAttachmentFromCameraText,
              imageAttachmentFromGalleryText:
                  widget.imageAttachmentFromGalleryText,
              chatInputFieldColor: widget.chatInputFieldColor,
              recordingNoteHintText: widget.recordingNoteHintText,
              sendMessageHintText: widget.sendMessageHintText,
              disableInput: widget.disableInput,
              chatInputFieldDecoration: widget.chatInputFieldDecoration,
              chatInputFieldPadding: widget.chatInputFieldPadding,
              imageAttachmentTextStyle: widget.imageAttachmentTextStyle,
              imageAttachmentFromGalleryIcon:
                  widget.imageAttachmentFromGalleryIcon,
              imageAttachmentFromCameraIcon:
                  widget.imageAttachmentFromCameraIcon,
              imageAttachmentCancelIcon: widget.imageAttachmentCancelIcon,
              attachmentClick: widget.attachmentClick,
              handleRecord: widget.handleRecord,
              handleImageSelect: widget.handleImageSelect,
              handleVideoSelect: widget.handleVideoSelect,
              onSlideToCancelRecord: widget.onSlideToCancelRecord ?? () {},
              onTextSubmit: widget.onTextSubmit,
              textEditingController: widget.textEditingController,
              textDirection: widget.textDirection,
              containerBorderRadius: widget.containerBorderRadius,
              buttonRadius: widget.buttonRadius,
              cameraResolution: widget.cameraResolution,
              audioBitRate: widget.audioBitRate,
              imageQuality: widget.imageQuality,
              imageMaxWidth: widget.imageMaxWidth,
            ),
          ),
        ),
      ],
    );
  }
}
