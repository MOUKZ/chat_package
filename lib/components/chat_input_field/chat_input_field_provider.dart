import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';

/// Defines the source for picking images: camera or gallery.
enum ImageSourceType { camera, gallery }

/// Manages chat input logic: text entry, image picking, and audio recording gestures.
///
/// - Tracks recording state and drag threshold for slide-to-cancel.
/// - Requests permissions, starts/stops audio recording.
/// - Emits callbacks for text submission, image selection, and audio recording.
class ChatInputProvider extends ChangeNotifier {
  // ======== Callbacks ========
  /// Invoked with a [ChatMessage] when audio recording completes successfully.
  final ValueChanged<ChatMessage> onRecordComplete;

  /// Invoked with a [ChatMessage] on text submission.
  final ValueChanged<ChatMessage> onTextSubmit;

  /// Invoked with a [ChatMessage] when an image is picked, or `null` on cancel.
  final ValueChanged<ChatMessage> onImageSelected;

  // ======== Controllers & Config ========
  /// Controller for the text input field.
  final TextEditingController textController;

  /// Horizontal drag distance threshold to cancel recording (in pixels).
  final double cancelThreshold;

  // ======== Internal State ========
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  double _dragOffset = 0.0;

  /// Constructs a [ChatInputProvider].
  ///
  /// - [onRecordComplete]: callback when audio recording is done.
  /// - [onTextSubmit]: callback for text messages.
  /// - [onImageSelected]: callback for image selection or cancellation.
  /// - [textController]: controller for text input.
  /// - [cancelThreshold]: pixels user must drag to cancel recording.
  ChatInputProvider({
    required this.onRecordComplete,
    required this.onTextSubmit,
    required this.onImageSelected,
    required this.textController,
    required this.cancelThreshold,
  }) {
    textController.addListener(_onTextChanged);
  }

  /// Whether the provider is currently recording audio.
  bool get isRecording => _isRecording;

  /// Current drag offset along the X axis (negative when dragging left).
  double get dragOffset => _dragOffset;

  /// True if the text input contains non-whitespace characters.
  bool get hasText => textController.text.trim().isNotEmpty;

  // ─────────────────────────────────────────────────────────────────────────
  // Permission & Recording Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Requests [perm] and opens app settings if permanently denied.
  Future<bool> _requestPermission(Permission perm) async {
    final status = await perm.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  /// Starts recording to a timestamped `.m4a` file in the temp directory.
  Future<void> _startAudioRecord() async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
    if (await _audioRecorder.isRecording()) {
      await _audioRecorder.stop();
    }
    await _audioRecorder.start(
      const RecordConfig(),
      path: filePath,
    );
  }

  /// Stops recording and returns the recorded file path, or `null`.
  Future<String?> _stopAudioRecord() => _audioRecorder.stop();

  // ─────────────────────────────────────────────────────────────────────────
  // Recording Gesture Handlers
  // ─────────────────────────────────────────────────────────────────────────

  /// Initiates audio recording on long-press start if no text is present.
  Future<void> startRecording() async {
    if (hasText) return;
    if (!await _requestPermission(Permission.microphone)) return;

    await _startAudioRecord();
    _isRecording = true;
    _dragOffset = 0.0;
    notifyListeners();
  }

  /// Updates drag offset. Cancels recording if threshold is exceeded.
  void onMove(Offset offset) {
    if (!_isRecording || hasText) return;
    _dragOffset = offset.dx.clamp(-cancelThreshold, 0.0);
    if (_dragOffset <= -cancelThreshold) {
      _resetRecordingState();
    }
    notifyListeners();
  }

  /// Ends recording on long-press release; completes or cancels accordingly.
  Future<void> endRecording() async {
    if (!_isRecording) return;

    final recordedPath = await _stopAudioRecord();
    final canceled =
        (recordedPath == null) || (_dragOffset <= -cancelThreshold);

    _resetRecordingState();
    if (!canceled) {
      final message = ChatMessage(
        text: '',
        isSender: true,
        chatMedia: ChatMedia(
          url: recordedPath,
          mediaType: MediaType.audioMediaType(),
        ),
      );
      onRecordComplete(message);
    }
    notifyListeners();
  }

  /// Sends the current text message if non-empty, then clears the input.
  void sendTextMessage() {
    if (!hasText) return;
    final message = ChatMessage(
      text: textController.text,
      isSender: true,
    );
    onTextSubmit(message);

    textController.clear();
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Image Picking
  // ─────────────────────────────────────────────────────────────────────────

  /// Picks an image from [sourceType], then invokes [onImageSelected].
  Future<void> pickImage(ImageSourceType sourceType) async {
    final permission = sourceType == ImageSourceType.camera
        ? Permission.camera
        : Permission.photos;
    if (!await _requestPermission(permission)) {
      return;
    }

    final picker = ImagePicker();
    final source = sourceType == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    final file = await picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1440,
    );

    if (file == null) {
    } else {
      final message = ChatMessage(
        text: '',
        isSender: true,
        chatMedia: ChatMedia(
          url: file.path,
          mediaType: MediaType.imageMediaType(),
        ),
      );
      onImageSelected(message);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Internal Helpers
  // ─────────────────────────────────────────────────────────────────────────

  void _onTextChanged() => notifyListeners();

  void _resetRecordingState() {
    _isRecording = false;
    _dragOffset = 0.0;
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    _audioRecorder.dispose();
    super.dispose();
  }
}
