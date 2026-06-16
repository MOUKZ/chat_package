import 'dart:async';

import 'package:chat_package/models/captured_media.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:chat_package/utils/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

/// Holds and drives the state of the chat input field: text entry, voice-note
/// recording (with slide-to-cancel) and image/video selection.
class ChatInputFieldProvider extends ChangeNotifier {
  /// Called with the recorded voice note, or `(null, true)` when canceled.
  final Function(ChatMessage? audioMessage, bool cancel) handleRecord;

  /// Called when the user slides to cancel a recording.
  final VoidCallback onSlideToCancelRecord;

  /// Called with the selected/captured image message (or `null` when canceled).
  final Function(ChatMessage? imageMessage) handleImageSelect;

  /// Called with the captured video message (or `null` when canceled).
  final Function(ChatMessage? videoMessage)? handleVideoSelect;

  /// Called when the send button is pressed with a non-empty text message.
  final Function(ChatMessage text) onTextSubmit;

  final TextEditingController textController;
  final double cancelPosition;

  /// Service used for all runtime permission requests.
  final PermissionService permissionService;

  /// Bit rate (bits/sec) used when recording voice notes.
  final int audioBitRate;

  /// Quality (0-100) applied to images picked from the gallery.
  final int imageQuality;

  /// Maximum width (px) applied to images picked from the gallery.
  final double imageMaxWidth;

  final AudioRecorder _record = AudioRecorder();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _formKey = GlobalKey<FormState>();
  StreamSubscription<int>? _timerSubscription;

  double _position = 0;
  int _duration = 0;
  bool _isRecording = false;
  int _recordTime = 0;
  bool isText = false;
  double _height = 70;

  /// getters
  int get duration => _duration;
  bool get isRecording => _isRecording;
  int get recordTime => _recordTime;
  GlobalKey<FormState> get formKey => _formKey;

  /// setters
  set height(double val) => _height = val;

  ChatInputFieldProvider({
    required this.onTextSubmit,
    required this.textController,
    required this.handleRecord,
    required this.onSlideToCancelRecord,
    required this.cancelPosition,
    required this.handleImageSelect,
    this.handleVideoSelect,
    this.permissionService = const PermissionService(),
    this.audioBitRate = 128000,
    this.imageQuality = 70,
    this.imageMaxWidth = 1440,
  });

  /// animated button on tap -> submit the typed text message
  void onAnimatedButtonTap() {
    _formKey.currentState?.save();
    if (isText && textController.text.isNotEmpty) {
      final textMessage =
          ChatMessage(isSender: true, text: textController.text);
      onTextSubmit(textMessage);
    }
    textController.clear();
    isText = false;
    notifyListeners();
  }

  /// animated button on long press -> start recording a voice note
  void onAnimatedButtonLongPress() async {
    if (isText) return;

    final granted = await permissionService.requestMicrophone();
    if (!granted) return;

    _stopWatchTimer.onStartTimer();
    _timerSubscription ??= _stopWatchTimer.rawTime.listen((value) {
      _recordTime = value;
      notifyListeners();
    });

    textController.clear();
    await recordAudio();

    _isRecording = true;
    notifyListeners();
  }

  /// animated button on long press move -> track the slide-to-cancel position
  void onAnimatedButtonLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (!isText && _isRecording) {
      _duration = 0;
      _position = details.localPosition.dx * -1;
      notifyListeners();
    }
  }

  /// animated button on long press end -> stop and either send or cancel
  void onAnimatedButtonLongPressEnd(LongPressEndDetails details) async {
    if (isText || !_isRecording) return;

    final source = await stopRecord();
    _stopWatchTimer.onStopTimer();
    _stopWatchTimer.onResetTimer();

    if (_position > cancelPosition - _height || source == null) {
      handleRecord(null, true);
      onSlideToCancelRecord();
    } else {
      final audioMessage = ChatMessage(
        isSender: true,
        chatMedia: ChatMedia(url: source, mediaType: MediaType.audio),
      );
      handleRecord(audioMessage, false);
    }

    _duration = 600;
    _position = 0;
    _isRecording = false;
    notifyListeners();
  }

  /// start recording audio to a temporary file
  Future<void> recordAudio() async {
    if (await _record.isRecording()) {
      await _record.stop();
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/chat_voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _record.start(
      RecordConfig(bitRate: audioBitRate),
      path: path,
    );
  }

  /// stop recording and return the recorded file path (or `null`)
  Future<String?> stopRecord() => _record.stop();

  /// clamp the animated button position between 0 and the cancel threshold
  double getPosition() {
    if (_position < 0) {
      return 0;
    } else if (_position > cancelPosition - _height) {
      return cancelPosition - _height;
    }
    return _position;
  }

  /// pick an image from the gallery and forward it through [handleImageSelect]
  Future<void> pickImageFromGallery() async {
    final granted = await permissionService.requestGallery();
    if (!granted) {
      handleImageSelect(null);
      return;
    }

    final result = await ImagePicker().pickImage(
      imageQuality: imageQuality,
      maxWidth: imageMaxWidth,
      source: ImageSource.gallery,
    );
    handleImageSelect(_imageMessageFromPath(result?.path));
  }

  /// build a chat message from the result of the in-app camera flow and
  /// forward it through the matching callback
  void handleCapturedMedia(CapturedMedia? media) {
    if (media == null) return;

    final message = ChatMessage(
      isSender: true,
      text: media.caption,
      chatMedia: ChatMedia(
        url: media.path,
        mediaType: media.isVideo ? MediaType.video : MediaType.image,
      ),
    );

    if (media.isVideo) {
      (handleVideoSelect ?? handleImageSelect)(message);
    } else {
      handleImageSelect(message);
    }
  }

  ChatMessage? _imageMessageFromPath(String? path) {
    if (path == null) return null;
    return ChatMessage(
      isSender: true,
      chatMedia: ChatMedia(url: path, mediaType: MediaType.image),
    );
  }

  void onTextFieldValueChanged(String value) {
    final hasText = value.isNotEmpty;
    if (hasText != isText) {
      isText = hasText;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    _stopWatchTimer.dispose();
    _record.dispose();
    // The text controller is owned by [ChatInputField]; it is disposed there.
    super.dispose();
  }
}
