import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ChatInputFieldProvider extends ChangeNotifier {
  final Function(String? path, bool cancel)? handleRecord;
  final VoidCallback onSlideToCancelRecord;

  /// The callback when send is pressed.
  final Function(String? text) onSubmit;
  final TextEditingController textController;
  final double cancelPosition;

  late Record _record = Record();
  double _position = 0;
  int _duration = 0;
  bool _isRecording = false;
  int _recordTime = 0;
  bool _isText = false;
  //TODO : create setter for this
  double _height = 70;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  /// getters
  int get duration => _duration;
  bool get isRecording => _isRecording;
  int get recordTime => _recordTime;
  bool get isText => _isText;

  /// setters
  set isText(bool val) => _isText = val;
  Permission micPermission = Permission.microphone;
  ChatInputFieldProvider({
    required this.onSubmit,
    required this.textController,
    this.handleRecord,
    required this.onSlideToCancelRecord,
    required this.cancelPosition,
  });

  /// animated button on tap
  void onAnimatedButtonTap() {
    if (_isText && textController.text.isNotEmpty) {
      onSubmit(textController.text);
    }
    textController.clear();
  }

  /// animated button on LongPress
  void onAnimatedButtonLongPress() async {
    // HapticFeedback.heavyImpact();

    if (await micPermission.isGranted) {
      if (!_isText) {
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
    if (!_isText && _isRecording == true) {
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

    if (!_isText && await micPermission.isGranted) {
      if (_position > cancelPosition - _height) {
        log('canceled');

        handleRecord?.call(res, true);

        onSlideToCancelRecord();
      } else {
        handleRecord?.call(res, false);
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
}
