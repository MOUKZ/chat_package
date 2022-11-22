import 'dart:developer';
import 'package:chat_package/views/chat_input_field/chat_input_field_provider.dart';
import 'package:chat_package/views/chat_input_field/widgets/chat_animated_button.dart';
import 'package:chat_package/views/chat_input_field/widgets/chat_text_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'widgets/chat_drag_trail.dart';

class ChatInputField extends StatelessWidget {
  /// Height of the slider. Defaults to 70.
  final double height;

  /// The button widget used on the moving element of the slider. Defaults to Icon(Icons.chevron_right).
  final Widget sliderButtonContent;

  /// hint text to be shown for sending messages
  final String sendMessageHintText;

  /// hit text to be shown for recording voice note
  final String recordingNoteHintText;

  /// The Icon showed to send a text
  final IconData sendTextIcon;

  /// texts shown wen trying to chose image attachment from gallery
  final String imageAttachmentFromGallery;

  /// texts shown wen trying to chose image attachment from camera
  final String imageAttachmentFromCamera;

  /// texts shown wen trying to chose image attachment cancel text
  final String imageAttachmentCancelText;

  /// image attachment text color
  final Color imageAttachmentTextColor;

  /// the color of the outer container and the color used to hide
  /// the text on slide
  final Color containerColor;

  /// The callback when slider is completed. This is the only required field.
  final VoidCallback onSlideToCancelRecord;

  /// The callback when send is pressed.
  final Function(String? text) onSubmit;

  /// function to handle the selected image
  final Function(XFile) handleImageSelect;

  /// function to handle the recorded audio
  final Function(String? path, bool canceled) handleRecord;

  final TextEditingController textController;

  /// use this flag to disable the input
  final bool disableInput;

  ChatInputField({
    Key? key,
    this.height = 70,
    required this.sendMessageHintText,
    required this.recordingNoteHintText,
    this.sliderButtonContent = const Icon(
      Icons.chevron_right,
      color: Colors.white,
      size: 25,
    ),
    this.sendTextIcon = Icons.send,
    required this.onSlideToCancelRecord,
    required this.handleRecord,
    required this.onSubmit,
    required this.textController,
    required this.handleImageSelect,
    required this.containerColor,
    required this.imageAttachmentFromGallery,
    required this.imageAttachmentFromCamera,
    required this.imageAttachmentCancelText,
    required this.imageAttachmentTextColor,
    required this.disableInput,
  }) : assert(height >= 25);

  @override
  Widget build(BuildContext context) {
    final cancelPosition = MediaQuery.of(context).size.width * 0.95;
    return ChangeNotifierProvider(
      create: (context) => ChatInputFieldProvider(
        onSubmit: onSubmit,
        textController: textController,
        onSlideToCancelRecord: onSlideToCancelRecord,
        cancelPosition: cancelPosition,
        handleRecord: handleRecord,
      ),
      child: Consumer<ChatInputFieldProvider>(
        builder: (context, provider, child) {
          provider.isText =
              KeyboardVisibilityProvider.isKeyboardVisible(context);
          return IgnorePointer(
            ignoring: disableInput,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: AnimatedContainer(
                duration: Duration(milliseconds: provider.duration),
                curve: Curves.ease,
                height: height,
                width: double.infinity,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
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
                    _buildInputField(provider),
                    _buildDragTrail(provider),
                    _buildAnimatedButton(provider),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// build Input Field widget
  Widget _buildInputField(ChatInputFieldProvider provider) =>
      ChatTextViewWidget(
          containerColor: containerColor,
          isRecording: provider.isRecording,
          recordingNoteHintText: recordingNoteHintText,
          recordTime: provider.recordTime,
          textController: textController,
          sendMessageHintText: sendMessageHintText,
          attachmentClick: attachmentClick);

  Widget _buildDragTrail(ChatInputFieldProvider provider) => ChatDragTrail(
        rightPosition: height / 2,
        cancelPosition: provider.getPosition(),
        duration: provider.duration,
        trailColor: containerColor,
      );

  Widget _buildAnimatedButton(ChatInputFieldProvider provider) =>
      ChatAnimatedButton(
        duration: provider.duration,
        rightPosition: provider.getPosition(),
        isRecording: provider.isRecording,
        isText: provider.isText,
        animatedButtonWidget: sliderButtonContent,
        onAnimatedButtonTap: provider.onAnimatedButtonTap,
        onAnimatedButtonLongPress: provider.onAnimatedButtonLongPress,
        onAnimatedButtonLongPressMoveUpdate:
            provider.onAnimatedButtonLongPressMoveUpdate,
        onAnimatedButtonLongPressEnd: (details) =>
            provider.onAnimatedButtonLongPressEnd(details),
        borderRadius: BorderRadius.all(Radius.circular(height / 2)),
        sendTextIcon: sendTextIcon,
      );

  /// show a widget to choose picker type

  void attachmentClick(BuildContext context) {
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
                    imageAttachmentFromCamera,
                    style: TextStyle(color: imageAttachmentTextColor),
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
                    imageAttachmentFromGallery,
                    style: TextStyle(color: imageAttachmentTextColor),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    imageAttachmentCancelText,
                    style: TextStyle(color: imageAttachmentTextColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
      } else {
        // User canceled the picker
      }
    }
  }
}
