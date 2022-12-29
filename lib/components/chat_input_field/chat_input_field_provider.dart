import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ChatInputFieldProvider extends ChangeNotifier {
  final Function(String? path, bool cancel) handleRecord;
  final VoidCallback onSlideToCancelRecord;

  /// function to handle the selected image
  final Function(XFile) handleImageSelect;

  /// The callback when send is pressed.
  final Function(String? text) onTextSubmit;
  final TextEditingController textController;
  final double cancelPosition;

  late Record _record = Record();
  double _position = 0;
  int _duration = 0;
  bool _isRecording = false;
  int _recordTime = 0;
  bool isText = false;
  double _height = 70;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _formKey = GlobalKey<FormState>();

  /// getters
  int get duration => _duration;
  bool get isRecording => _isRecording;
  int get recordTime => _recordTime;
  GlobalKey<FormState> get formKey => _formKey;

  /// setters
  set height(double val) => _height = val;

  Permission micPermission = Permission.microphone;
  ChatInputFieldProvider({
    required this.onTextSubmit,
    required this.textController,
    required this.handleRecord,
    required this.onSlideToCancelRecord,
    required this.cancelPosition,
    required this.handleImageSelect,
  });

  /// animated button on tap
  void onAnimatedButtonTap() {
    _formKey.currentState?.save();
    if (isText && textController.text.isNotEmpty) {
      onTextSubmit(textController.text);
    }
    textController.clear();
    isText = false;
    notifyListeners();
  }

  /// animated button on LongPress
  void onAnimatedButtonLongPress() async {
    // HapticFeedback.heavyImpact();

    if (await micPermission.isGranted) {
      if (!isText) {
        _stopWatchTimer.onStartTimer();
        _stopWatchTimer.rawTime.listen((value) {
          _recordTime = value;

          print('rawTime $value ${StopWatchTimer.getDisplayTime(_recordTime)}');
          notifyListeners();
        });

        textController.clear();
        recordAudio();

        _isRecording = true;
        notifyListeners();
      }
    }
    if (await micPermission.isDenied) {
      await Permission.microphone.request();
    }
  }

  /// animated button on Long Press Move Update
  void onAnimatedButtonLongPressMoveUpdate(
      LongPressMoveUpdateDetails details) async {
    if (!isText && _isRecording == true) {
      _duration = 0;
      _position = details.localPosition.dx * -1;
      notifyListeners();
    }
  }

  /// animated button on Long Press End
  void onAnimatedButtonLongPressEnd(LongPressEndDetails details) async {
    final res = await stopRecord();
    // Stop
    _stopWatchTimer.onStopTimer();

    // Reset
    _stopWatchTimer.onResetTimer();

    if (!isText && await micPermission.isGranted) {
      if (_position > cancelPosition - _height) {
        log('canceled');

        handleRecord(res, true);

        onSlideToCancelRecord();
      } else {
        handleRecord(res, false);
      }

      _duration = 600;
      _position = 0;
      _isRecording = false;
      notifyListeners();
    }
  }

  /// function used to record audio
  void recordAudio() async {
    if (await _record.isRecording()) {
      _record.stop();
    }

    await _record.start(
      // path: 'aFullPath/myFile.m4a', // required
      bitRate: 128000, // by default
      // sampleRate: 44100, // by default
    );
  }

  /// function used to stop recording
  /// and returns the record path as a string

  Future<String?> stopRecord() async {
    return await _record.stop();
  }

  /// get the animated button position
  double getPosition() {
    log(_position.toString());
    if (_position < 0) {
      return 0;
    } else if (_position > cancelPosition - _height) {
      return cancelPosition - _height;
    } else {
      return _position;
    }
  }

  // TODO: make this custom from user
  /// open image picker from camera, gallery, or cancel the selection
  void pickImage(int type) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();
    if (statuses.containsValue(PermissionStatus.denied)) {
      log('no permission');
    } else {
      final result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
      );
      if (result != null) {
        handleImageSelect(result);

        print(result.path);
      }
    }
  }

  void onTextFieldValueChanged(String value) {
    if (value.length > 0) {
      textController.text = value;
      isText = true;
      notifyListeners();
    } else {
      isText = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
