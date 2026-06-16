import 'package:camera/camera.dart';
import 'package:chat_package/components/chat_input_field/chat_input_field_provider.dart';
import 'package:chat_package/components/chat_input_field/widgets/chat_animated_button.dart';
import 'package:chat_package/components/chat_input_field/widgets/chat_attachment_bottom_sheet.dart';
import 'package:chat_package/components/chat_input_field/widgets/chat_input_field_container_widget.dart';
import 'package:chat_package/models/captured_media.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/chat_drag_trail.dart';

/// The chat input field: a text field with a slide-to-cancel voice recorder and
/// an attachment (camera / gallery) entry point.
class ChatInputField extends StatefulWidget {
  /// Radius of the send/record button. Defaults to 35.
  final double buttonRadius;

  /// Radius of the input field container. Defaults to 40.
  final double containerBorderRadius;

  /// The widget shown on the moving slider element while recording.
  final Widget sliderButtonContent;

  /// hint text shown for sending messages
  final String sendMessageHintText;

  /// hint text shown while recording a voice note
  final String recordingNoteHintText;

  /// The icon used to send a text message
  final IconData sendTextIcon;

  /// text shown for the "from gallery" attachment option
  final String imageAttachmentFromGalleryText;

  /// icon shown for the "from gallery" attachment option
  final Icon? imageAttachmentFromGalleryIcon;

  /// text shown for the "from camera" attachment option
  final String imageAttachmentFromCameraText;

  /// icon shown for the "from camera" attachment option
  final Icon? imageAttachmentFromCameraIcon;

  /// text shown for the "cancel" attachment option
  final String imageAttachmentCancelText;

  /// icon shown for the "cancel" attachment option
  final Icon? imageAttachmentCancelIcon;

  /// text style for the attachment bottom sheet entries
  final TextStyle? imageAttachmentTextStyle;

  /// background color of the input field container
  final Color chatInputFieldColor;

  /// text direction of the input field
  final TextDirection textDirection;

  /// custom decoration for the input field container
  final BoxDecoration? chatInputFieldDecoration;

  /// resolution used by the in-app camera
  final ResolutionPreset cameraResolution;

  /// bit rate used when recording voice notes
  final int audioBitRate;

  /// quality (0-100) applied to gallery images
  final int imageQuality;

  /// max width (px) applied to gallery images
  final double imageMaxWidth;

  /// callback when the slider is completed (recording canceled)
  final VoidCallback onSlideToCancelRecord;

  /// callback when a text message is sent
  final Function(ChatMessage text) onTextSubmit;

  /// callback for a selected/captured image
  final Function(ChatMessage? imageMessage) handleImageSelect;

  /// callback for a captured video
  final Function(ChatMessage? videoMessage)? handleVideoSelect;

  /// callback for a recorded voice note
  final Function(ChatMessage? audioMessage, bool canceled) handleRecord;

  /// optional external controller for the input text
  final TextEditingController? textEditingController;

  final EdgeInsets? chatInputFieldPadding;

  /// disables the whole input when `true`
  final bool disableInput;

  /// optional override for the default attachment bottom sheet
  final Function(BuildContext context)? attachmentClick;

  const ChatInputField({
    super.key,
    this.buttonRadius = 35,
    this.containerBorderRadius = 40,
    required this.sendMessageHintText,
    required this.recordingNoteHintText,
    this.textDirection = TextDirection.ltr,
    this.chatInputFieldDecoration,
    this.sliderButtonContent = const Icon(
      Icons.chevron_right,
      color: Colors.white,
      size: 25,
    ),
    this.sendTextIcon = Icons.send,
    this.cameraResolution = ResolutionPreset.high,
    this.audioBitRate = 128000,
    this.imageQuality = 70,
    this.imageMaxWidth = 1440,
    required this.onSlideToCancelRecord,
    required this.handleRecord,
    required this.onTextSubmit,
    required this.handleImageSelect,
    this.handleVideoSelect,
    required this.chatInputFieldColor,
    required this.imageAttachmentFromGalleryText,
    required this.imageAttachmentFromCameraText,
    required this.imageAttachmentCancelText,
    required this.disableInput,
    this.chatInputFieldPadding,
    this.imageAttachmentFromGalleryIcon,
    this.imageAttachmentFromCameraIcon,
    this.imageAttachmentCancelIcon,
    this.imageAttachmentTextStyle,
    this.textEditingController,
    this.attachmentClick,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late final TextEditingController _textController;

  /// whether this widget created (and therefore owns/disposes) the controller
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.textEditingController == null;
    _textController = widget.textEditingController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (_ownsController) _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cancelPosition = MediaQuery.of(context).size.width * 0.95;
    return ChangeNotifierProvider(
      create: (context) => ChatInputFieldProvider(
        onTextSubmit: widget.onTextSubmit,
        textController: _textController,
        onSlideToCancelRecord: widget.onSlideToCancelRecord,
        cancelPosition: cancelPosition,
        handleRecord: widget.handleRecord,
        handleImageSelect: widget.handleImageSelect,
        handleVideoSelect: widget.handleVideoSelect,
        audioBitRate: widget.audioBitRate,
        imageQuality: widget.imageQuality,
        imageMaxWidth: widget.imageMaxWidth,
      ),
      child: Consumer<ChatInputFieldProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: widget.chatInputFieldPadding ??
                const EdgeInsets.only(bottom: 3),
            child: IgnorePointer(
              ignoring: widget.disableInput,
              child: Directionality(
                textDirection: widget.textDirection,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: provider.duration),
                  curve: Curves.ease,
                  width: double.infinity,
                  padding: const EdgeInsets.all(3),
                  decoration: widget.chatInputFieldDecoration,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      _buildInputField(provider),
                      _buildDragTrail(provider),
                      _buildAnimatedButton(provider),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField(ChatInputFieldProvider provider) =>
      ChatInputFieldContainerWidget(
        chatInputFieldColor: widget.chatInputFieldColor,
        containerBorderRadius: widget.containerBorderRadius,
        isRecording: provider.isRecording,
        recordingNoteHintText: widget.recordingNoteHintText,
        recordTime: provider.recordTime,
        textController: _textController,
        sendMessageHintText: widget.sendMessageHintText,
        textDirection: widget.textDirection,
        onTextFieldValueChanged: provider.onTextFieldValueChanged,
        attachmentClick: widget.attachmentClick ??
            (context) => _attachmentClick(context, provider),
        formKey: provider.formKey,
        onSubmitted: provider.onAnimatedButtonTap,
      );

  Widget _buildDragTrail(ChatInputFieldProvider provider) => ChatDragTrail(
        cancelPosition: provider.getPosition(),
        duration: provider.duration,
        trailColor: widget.chatInputFieldColor,
      );

  Widget _buildAnimatedButton(ChatInputFieldProvider provider) =>
      ChatAnimatedButton(
        duration: provider.duration,
        rightPosition: provider.getPosition(),
        isRecording: provider.isRecording,
        isText: provider.isText,
        animatedButtonWidget: widget.sliderButtonContent,
        onAnimatedButtonTap: provider.onAnimatedButtonTap,
        onAnimatedButtonLongPress: provider.onAnimatedButtonLongPress,
        onAnimatedButtonLongPressMoveUpdate:
            provider.onAnimatedButtonLongPressMoveUpdate,
        onAnimatedButtonLongPressEnd: provider.onAnimatedButtonLongPressEnd,
        borderRadius: BorderRadius.all(Radius.circular(widget.buttonRadius)),
        sendTextIcon: widget.sendTextIcon,
      );

  /// show the default attachment bottom sheet (camera / gallery / cancel)
  void _attachmentClick(BuildContext context, ChatInputFieldProvider provider) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (sheetContext) {
        return ChatBottomSheet(
          imageFromCameraOnTap: () {
            Navigator.pop(sheetContext);
            _openCamera(context, provider);
          },
          imageFromGalleryOnTap: () {
            Navigator.pop(sheetContext);
            provider.pickImageFromGallery();
          },
          imageAttachmentFromCameraText: widget.imageAttachmentFromCameraText,
          imageAttachmentTextStyle: widget.imageAttachmentTextStyle,
          imageAttachmentFromGalleryText: widget.imageAttachmentFromGalleryText,
          imageAttachmentCancelText: widget.imageAttachmentCancelText,
          imageAttachmentFromGalleryIcon: widget.imageAttachmentFromGalleryIcon,
          imageAttachmentFromCameraIcon: widget.imageAttachmentFromCameraIcon,
          imageAttachmentCancelIcon: widget.imageAttachmentCancelIcon,
        );
      },
    );
  }

  /// open the in-app camera, then forward the captured media into the chat
  Future<void> _openCamera(
      BuildContext context, ChatInputFieldProvider provider) async {
    final granted = await provider.permissionService.requestCamera();
    if (!granted) {
      provider.handleImageSelect(null);
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty || !context.mounted) return;

    final captured = await Navigator.of(context).push<CapturedMedia>(
      MaterialPageRoute(
        builder: (_) => CameraScreen(
          cameras: cameras,
          resolutionPreset: widget.cameraResolution,
        ),
      ),
    );
    provider.handleCapturedMedia(captured);
  }
}
