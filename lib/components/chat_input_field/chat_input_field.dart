import 'package:chat_package/components/chat_input_field/chat_input_field_provider.dart';
import 'package:chat_package/components/chat_input_field/widgets/recording_button.dart';
import 'package:chat_package/components/chat_input_field/widgets/wave_animation.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A chat input field with text entry and press‑and‑hold + slide‑to‑cancel recording.
/// All visuals and durations can be customized via constructor parameters.
class ChatInputField extends StatefulWidget {
  /// Called when non‑empty text is submitted.

  /// Called when an audio recording successfully completes.
  final ValueChanged<ChatMessage> onRecordComplete;

  /// Invoked with a [ChatMessage] when an image is picked, or `null` on cancel.
  final ValueChanged<ChatMessage> onImageSelected;

  /// Controller for the text input.
  final TextEditingController textController;

  /// Horizontal drag distance (in px) to cancel recording.
  final double cancelThreshold;

  /// Whether to show the wave animation during recording.
  final bool showWaveAnimation;

  /// Duration of the wave animation cycle.
  final Duration waveDuration;

  /// Padding inside the main container.
  final EdgeInsetsGeometry chatFieldPadding;

  /// Margin around the main container.
  final EdgeInsetsGeometry chatFieldMargin;

  /// Decoration for the main container.
  final Decoration decoration;

  /// Decoration for the TextField input.
  final InputDecoration textFieldDecoration;

  /// Customization for the wave animation widget.
  final WaveAnimationStyle waveStyle;

  /// Customization for the recording/send button.
  final RecordingButtonStyle buttonStyle;

  /// Label for the “From Camera” option.
  /// used for [ChatBottomSheet]
  final String cameraText;

  /// Icon for the “From Camera” option.
  /// used for [ChatBottomSheet]
  final Icon? cameraIcon;

  /// Label for the “From Gallery” option.
  /// used for [ChatBottomSheet]
  final String galleryText;

  /// Icon for the “From Gallery” option.
  /// used for [ChatBottomSheet]
  final Icon? galleryIcon;

  /// Label for the “Cancel” option.
  /// used for [ChatBottomSheet]
  final String cancelText;

  /// Icon for the “Cancel” option.
  /// used for [ChatBottomSheet]
  final Icon? cancelIcon;

  /// Text style applied to all option labels.
  /// used for [ChatBottomSheet]
  final TextStyle? chatBottomSheetTextStyle;

  final ValueChanged<ChatMessage> onTextSubmit;

  ///
  final bool enableInput;
  final TextDirection? textDirection;
  final String recordingNoteHintText;

  /// Creates a chat input field.
  ChatInputField({
    Key? key,
    required this.onRecordComplete,
    required this.textController,
    required this.onTextSubmit,
    required this.onImageSelected,
    this.cameraText = 'From Camera',
    this.galleryText = 'From Gallery',
    this.cancelText = 'Cancel',
    this.cameraIcon,
    this.galleryIcon,
    this.cancelIcon,
    this.chatBottomSheetTextStyle,
    this.cancelThreshold = 100.0,
    this.showWaveAnimation = true,
    this.enableInput = true,
    this.textDirection,
    required this.recordingNoteHintText,
    Duration? waveDuration,
    EdgeInsetsGeometry? chatFieldPadding,
    EdgeInsetsGeometry? chatFieldMargin,
    Decoration? decoration,
    InputDecoration? textFieldDecoration,
    WaveAnimationStyle? waveStyle,
    RecordingButtonStyle? buttonStyle,
  })  : waveDuration = waveDuration ?? const Duration(milliseconds: 600),
        chatFieldPadding =
            chatFieldPadding ?? const EdgeInsets.symmetric(vertical: 6),
        chatFieldMargin =
            chatFieldMargin ?? const EdgeInsets.symmetric(horizontal: 6),
        decoration = decoration ??
            BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(26)),
        textFieldDecoration = textFieldDecoration ??
            const InputDecoration.collapsed(
              hintText: 'Type a message',
            ),
        waveStyle = waveStyle ?? const WaveAnimationStyle(),
        buttonStyle = buttonStyle ?? const RecordingButtonStyle(),
        super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatInputProvider>(
      create: (_) => ChatInputProvider(
        onImageSelected: widget.onImageSelected,
        onTextSubmit: widget.onTextSubmit,
        onRecordComplete: widget.onRecordComplete,
        textController: widget.textController,
        cancelThreshold: widget.cancelThreshold,
      ),
      child: Consumer<ChatInputProvider>(
        builder: (context, provider, _) {
          return Container(
            padding: widget.chatFieldPadding,
            margin: widget.chatFieldMargin,
            decoration: widget.decoration,
            child: Row(
              children: [
                AnimatedPadding(
                    padding:
                        EdgeInsets.only(left: provider.isRecording ? 12 : 4),
                    duration: const Duration(milliseconds: 100)),
                const SizedBox(width: 4),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: provider.isRecording
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.delete,
                              ),
                              if (widget.showWaveAnimation)
                                Expanded(
                                  child: WaveAnimation(
                                    controller: _waveController,
                                    style: widget.waveStyle,
                                  ),
                                ),
                              Text(
                                '00:00',
                                // style: widget.waveStyle.timerTextStyle,
                              ),
                              SizedBox(width: 2),
                              Text(
                                widget.recordingNoteHintText,
                                // style: widget.waveStyle.timerTextStyle,
                              ),
                              const SizedBox(width: 12),
                            ],
                          )
                        : Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ChatBottomSheet(
                                        cameraText: widget.cameraText,
                                        galleryText: widget.galleryText,
                                        cancelText: widget.cancelText,
                                        cameraIcon: widget.cameraIcon,
                                        galleryIcon: widget.galleryIcon,
                                        cancelIcon: widget.cancelIcon,
                                        textStyle:
                                            widget.chatBottomSheetTextStyle,
                                        onCameraTap: () {
                                          Navigator.pop(context);

                                          provider.pickImage(
                                              ImageSourceType.camera);
                                        },
                                        onGalleryTap: () {
                                          provider.pickImage(
                                              ImageSourceType.gallery);
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.add),
                              ),
                              Expanded(
                                child: TextField(
                                  enabled: widget.enableInput,
                                  controller: widget.textController,
                                  decoration: widget.textFieldDecoration,
                                  textDirection: widget.textDirection,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(
                    width:
                        provider.isRecording ? (20 - provider.dragOffset) : 5),
                RecordingButton(
                  dragOffset: provider.dragOffset,
                  onLongPressStart: (_) => provider.startRecording(),
                  onLongPressMoveUpdate: (details) =>
                      provider.onMove(details.offsetFromOrigin),
                  onLongPressEnd: (_) => provider.endRecording(),
                  onTap: provider.sendTextMessage,
                  hasText: provider.hasText,
                  style: widget.buttonStyle,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A bottom sheet presenting image attachment options.
///
/// Displays three tappable options:
/// 1. Capture a new photo via camera
/// 2. Pick an existing image from the gallery
/// 3. Cancel and dismiss the sheet
///
/// All texts, icons, and styles are customizable.
class ChatBottomSheet extends StatelessWidget {
  /// Called when the user taps “From Camera”.
  final VoidCallback onCameraTap;

  /// Called when the user taps “From Gallery”.
  final VoidCallback onGalleryTap;

  /// Label for the “From Camera” option.
  final String cameraText;

  /// Icon for the “From Camera” option.
  final Icon? cameraIcon;

  /// Label for the “From Gallery” option.
  final String galleryText;

  /// Icon for the “From Gallery” option.
  final Icon? galleryIcon;

  /// Label for the “Cancel” option.
  final String cancelText;

  /// Icon for the “Cancel” option.
  final Icon? cancelIcon;

  /// Text style applied to all option labels.
  final TextStyle? textStyle;

  /// Creates a chat attachment bottom sheet.
  ///
  /// [onCameraTap] and [onGalleryTap] must not be null.
  /// [cameraText], [galleryText], and [cancelText] default to
  /// "From Camera", "From Gallery", and "Cancel" respectively.
  const ChatBottomSheet({
    Key? key,
    required this.onCameraTap,
    required this.onGalleryTap,
    this.cameraText = 'From Camera',
    this.galleryText = 'From Gallery',
    this.cancelText = 'Cancel',
    this.cameraIcon,
    this.galleryIcon,
    this.cancelIcon,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        children: [
          _buildOption(
            context: context,
            icon: cameraIcon ?? const Icon(Icons.camera_alt),
            label: cameraText,
            onTap: onCameraTap,
          ),
          _buildOption(
            context: context,
            icon: galleryIcon ?? const Icon(Icons.photo_library),
            label: galleryText,
            onTap: onGalleryTap,
          ),
          _buildOption(
            context: context,
            icon: cancelIcon ?? const Icon(Icons.close),
            label: cancelText,
            onTap: () => Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }

  /// Helper to build each list tile option.
  Widget _buildOption({
    required BuildContext context,
    required Icon icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: icon,
      title: Text(label, style: textStyle),
      onTap: onTap,
    );
  }
}
