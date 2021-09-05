import 'dart:developer';

import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ChatInputField extends StatefulWidget {
  /// Height of the slider. Defaults to 70.
  final double height;

  double? width;

  /// The button widget used on the moving element of the slider. Defaults to Icon(Icons.chevron_right).
  final Widget sliderButtonContent;
  //hit text to be shown for sending messages
  final String sendMessageHintText;

  //hit text to be shown for recording voice note
  final String recordinNoteHintText;

  /// The Icon showed to send a text
  final IconData sendTextIcon;
  // texts shown wen trying to chose image attachment
  final String imageAttachmentFromGalary;
  final String imageAttachmentFromCamery;
  final String imageAttachmentCancelText;
  // image attachment text color
  final Color imageAttachmentTextColor;

  /// the color of the outer container and the color used to hide
  /// the text on slide
  final Color containerColor;

  /// The callback when slider is completed. This is the only required field.
  final VoidCallback onSlideToCancelRecord;

  //The callback when send is pressed.
  Function(String? text)? onSubmit;

  /// function to handle the selected image
  final Function(XFile) handleImageSelect;

  /// function to handle the recorded audio
  final Function(String? path, bool cnaceled)? handleRecord;

  final TextEditingController textController;

  bool isText = false;

  ChatInputField({
    Key? key,
    this.height = 70,
    required this.sendMessageHintText,
    required this.recordinNoteHintText,
    this.sliderButtonContent = const Icon(
      Icons.chevron_right,
      color: Colors.white,
      size: 25,
    ),
    this.sendTextIcon = Icons.send,
    required this.onSlideToCancelRecord,
    this.handleRecord,
    this.onSubmit,
    required this.textController,
    required this.handleImageSelect,
    required this.containerColor,
    required this.imageAttachmentFromGalary,
    required this.imageAttachmentFromCamery,
    required this.imageAttachmentCancelText,
    required this.imageAttachmentTextColor,
  }) : assert(height >= 25);

  @override
  State<StatefulWidget> createState() {
    return ChatInputFieldState();
  }
}

class ChatInputFieldState extends State<ChatInputField>
    with TickerProviderStateMixin {
  late Record record;
  double _position = 0;
  int _duration = 0;
  bool isRecording = false;
  int recordTime = 0;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  double getPosition() {
    log(_position.toString());
    if (_position < 0) {
      return 0;
    } else if (_position > widget.width! - widget.height) {
      return widget.width! - widget.height;
    } else {
      return _position;
    }
  }

  @override
  void initState() {
    super.initState();
    record = Record();
  }

  void updatePosition(details) {
    // log();
    if (details is DragEndDetails) {
      setState(() {
        _duration = 600;
        if (_position > widget.width! - widget.height) {
          _position = widget.width! - widget.height;
        } else {
          _position = 0;
        }
      });
    } else if (details is DragUpdateDetails) {
      setState(() {
        _duration = 0;
        _position = details.localPosition.dx - (widget.height / 2);
      });
    }
  }

  void sliderReleased(details) {
    if (_position > widget.width! - widget.height) {
      widget.onSlideToCancelRecord();
    }
    updatePosition(details);
  }

  // Color calculateBackground() {
  //   if (widget.backgroundColorEnd != null) {
  //     double percent;

  //     // calculates the percentage of the position of the slider
  //     if (_position > widget.width! - widget.height) {
  //       percent = 1.0;
  //     } else if (_position / (widget.width! - widget.height) > 0) {
  //       percent = _position / (widget.width! - widget.height);
  //     } else {
  //       percent = 0.0;
  //     }

  //     int red = widget.backgroundColorEnd!.red;
  //     int green = widget.backgroundColorEnd!.green;
  //     int blue = widget.backgroundColorEnd!.blue;

  //     return Color.alphaBlend(
  //         Color.fromRGBO(red, green, blue, percent), widget.backgroundColor);
  //   } else {
  //     return widget.backgroundColor;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    widget.isText = KeyboardVisibilityProvider.isKeyboardVisible(context);
    widget.width = MediaQuery.of(context).size.width * 0.85;
    BoxShadow shadow;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedContainer(
        duration: Duration(milliseconds: _duration),
        curve: Curves.ease,
        height: widget.height,
        // width: widget.width,
        width: double.infinity,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          // color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 32,
              color: Color(0xFF087949).withOpacity(0.08),
            ),
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                right: 60,
                left: 10,
                // top: kDefaultPadding / 2,
                // bottom: kDefaultPadding / 2,
              ),
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
                // top: kDefaultPadding / 2,
                // bottom: kDefaultPadding / 2,
              ),
              decoration: BoxDecoration(
                // color: kPrimaryColor.withOpacity(0.05),
                color: widget.containerColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 0.0, right: 0),
                      child: isRecording
                          ? Container(
                              height: 50,
                              child: Center(
                                child: Text(
                                  widget.recordinNoteHintText +
                                      " " +
                                      StopWatchTimer.getDisplayTime(recordTime),
                                ),
                              ),
                            )
                          : TextField(
                              controller: widget.textController,
                              decoration: InputDecoration(
                                hintText: widget.sendMessageHintText,
                                border: InputBorder.none,
                              ),
                              textDirection: TextDirection.ltr,
                              onSubmitted: (text) {
                                if (widget.onSubmit != null) {
                                  widget.onSubmit!(text);
                                }
                                widget.textController.clear();
                                setState(() {});
                              },
                            ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        attachmintClick(context);
                      },
                      child: Icon(
                        isRecording ? Icons.delete : Icons.camera_alt_outlined,
                        color: isRecording
                            ? kErrorColor
                            : Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                      )),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: widget.height / 2,
              bottom: 5,
              child: AnimatedContainer(
                // padding: EdgeInsets.symmetric(
                //     // horizontal: kDefaultPadding,
                //     // vertical: 100,
                //     ),

                height: 100,
                width: getPosition(),
                duration: Duration(milliseconds: _duration),
                curve: Curves.ease,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: widget.containerColor,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: _duration),
              curve: Curves.bounceOut,
              right: getPosition(),
              top: 0,
              child: GestureDetector(
                onTap: () {
                  if (widget.isText &&
                      widget.onSubmit != null &&
                      widget.textController.text != '') {
                    widget.onSubmit!(widget.textController.text);
                  }
                },
                onTapDown: (details) async {
                  await record.hasPermission();
                },

                onLongPress: () async {
                  // HapticFeedback.heavyImpact();
                  if (await record.hasPermission()) {
                    if (!widget.isText) {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                      _stopWatchTimer.rawTime.listen((value) {
                        setState(() {
                          recordTime = value;
                        });
                        print(
                            'rawTime $value ${StopWatchTimer.getDisplayTime(recordTime)}');
                      });
                      setState(() {
                        widget.textController.clear();
                        recordAudio();

                        isRecording = true;
                      });
                    }
                  }
                },
                onLongPressMoveUpdate: (details) async {
                  if (await record.hasPermission()) {
                    if (!widget.isText) {
                      setState(() {
                        _duration = 0;
                        _position = details.localPosition.dx * -1;
                      });
                    }
                  }
                },
                onLongPressEnd: (details) async {
                  final res = await stopRecord();
                  // Stop
                  _stopWatchTimer.onExecute.add(StopWatchExecute.stop);

                  // Reset
                  _stopWatchTimer.onExecute.add(StopWatchExecute.reset);

                  if (!widget.isText && await record.hasPermission()) {
                    if (_position > widget.width! - widget.height) {
                      log('canceled');

                      widget.handleRecord != null
                          ? widget.handleRecord!(res, true)
                          : null;

                      widget.onSlideToCancelRecord();
                    } else {
                      widget.handleRecord != null
                          ? widget.handleRecord!(res, false)
                          : null;
                    }

                    setState(() {
                      isRecording = false;
                    });
                    setState(() {
                      _duration = 600;
                      _position = 0;
                      isRecording = false;
                    });
                  }

                  log(res ?? "");
                },

                // onHorizontalDragStart: (d) {
                //   updatePosition(d);
                // },
                // onHorizontalDragStart: (d) {
                //   updatePosition(d);

                //   log('fuck');
                // },
                // onTapDown: (_) =>
                //     widget.onTapDown != null ? widget.onTapDown!() : null,
                // onTapUp: (_) => widget.onTapUp != null ? widget.onTapUp!() : null,
                // onPanUpdate: (details) {
                //   log('pan');
                //   updatePosition(details);
                // },
                // onSecondaryLongPressMoveUpdate: (s) {
                //   log('sexond');
                // },
                // onPanEnd: (details) {
                //   if (widget.onTapUp != null) widget.onTapUp!();
                //   sliderReleased(details);
                // },
                child: AnimatedSize(
                  curve: Curves.easeIn,
                  vsync: this,
                  duration: Duration(microseconds: 500),
                  child: Container(
                    margin: EdgeInsets.only(top: isRecording ? 0 : 8),
                    height: isRecording ? 60 : 45,
                    width: isRecording ? 60 : 45,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(widget.height / 2)),
                      color: kSecondaryColor,
                    ),
                    child: isRecording
                        ? widget.sliderButtonContent
                        : Icon(
                            widget.isText ? widget.sendTextIcon : Icons.mic,
                            color: Colors.white,
                            size: 25,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void attachmintClick(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  pickImage(1);
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.imageAttachmentFromCamery,
                    style: TextStyle(color: widget.imageAttachmentTextColor),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(2);
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.imageAttachmentFromGalary,
                    style: TextStyle(color: widget.imageAttachmentTextColor),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.imageAttachmentCancelText,
                    style: TextStyle(color: widget.imageAttachmentTextColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
        widget.handleImageSelect(result);

        print(result.path);
      } else {
        // User canceled the picker
      }
    }
  }

  void recordAudio() async {
    if (await record.isRecording()) {
      record.stop();
    }

    await record.start(
      // path: 'aFullPath/myFile.m4a', // required
      encoder: AudioEncoder.AAC, // by default
      bitRate: 128000, // by default
      // sampleRate: 44100, // by default
    );
  }

  Future<String?> stopRecord() async {
    return await record.stop();
  }
}
