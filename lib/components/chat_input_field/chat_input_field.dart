import 'dart:developer';
import 'package:chat_package/components/chat_input_field/chat_input_field_provider.dart';
import 'package:chat_package/components/chat_input_field/widgets/chat_animated_button.dart';
import 'package:chat_package/components/chat_input_field/widgets/chat_attachment_bottom_sheet.dart';
import 'package:chat_package/components/chat_input_field/widgets/chat_input_field_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'widgets/chat_drag_trail.dart';

class ChatInputField extends StatelessWidget {
  /// Height of the slider. Defaults to 70.
  final double buttonRadios;

  /// The button widget used on the moving element of the slider. Defaults to Icon(Icons.chevron_right).
  final Widget sliderButtonContent;

  /// hint text to be shown for sending messages
  final String sendMessageHintText;

  /// hit text to be shown for recording voice note
  final String recordingNoteHintText;

  /// The Icon showed to send a text
  final IconData sendTextIcon;

  /// text shown wen trying to chose image attachment from gallery
  final String imageAttachmentFromGalleryText;

  /// Icon shown wen trying to chose image attachment from gallery
  final Icon? imageAttachmentFromGalleryIcon;

  /// text shown wen trying to chose image attachment from camera
  final String imageAttachmentFromCameraText;

  /// Icon shown wen trying to chose image attachment from camera
  final Icon? imageAttachmentFromCameraIcon;

  /// text shown wen trying to chose image attachment cancel text
  final String imageAttachmentCancelText;

  /// Icon shown wen trying to chose image attachment cancel text
  final Icon? imageAttachmentCancelIcon;

  /// image attachment text style
  final TextStyle? imageAttachmentTextStyle;

  /// the color of the outer container and the color used to hide
  /// the text on slide
  final Color chatInputFieldColor;

  // TODO  right description
  final TextDirection textDirection;
  final BoxDecoration? chatInputFieldDecoration;

  /// The callback when slider is completed. This is the only required field.
  final VoidCallback onSlideToCancelRecord;

  /// The callback when send is pressed.
  final Function(String? text) onTextSubmit;

  /// function to handle the selected image
  final Function(XFile) handleImageSelect;

  /// function to handle the recorded audio
  final Function(String? path, bool canceled) handleRecord;

  final TextEditingController _textController = TextEditingController();

  final EdgeInsets? chatInputFieldPadding;

  /// use this flag to disable the input
  final bool disableInput;

  ChatInputField({
    Key? key,
    this.buttonRadios = 35,
    required this.sendMessageHintText,
    required this.recordingNoteHintText,
    this.textDirection = TextDirection.rtl,
    this.chatInputFieldDecoration,
    this.sliderButtonContent = const Icon(
      Icons.chevron_right,
      color: Colors.white,
      size: 25,
    ),
    this.sendTextIcon = Icons.send,
    required this.onSlideToCancelRecord,
    required this.handleRecord,
    required this.onTextSubmit,
    required this.handleImageSelect,
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
  });

  // : assert(height >= 25);

  @override
  Widget build(BuildContext context) {
    final cancelPosition = MediaQuery.of(context).size.width * 0.95;
    return ChangeNotifierProvider(
      create: (context) => ChatInputFieldProvider(
        onTextSubmit: onTextSubmit,
        textController: _textController,
        onSlideToCancelRecord: onSlideToCancelRecord,
        cancelPosition: cancelPosition,
        handleRecord: handleRecord,
      ),
      child: Consumer<ChatInputFieldProvider>(
        builder: (context, provider, child) {
          provider.isText =
              KeyboardVisibilityProvider.isKeyboardVisible(context);
          return Padding(
            padding: chatInputFieldPadding ?? EdgeInsets.only(bottom: 3),
            child: IgnorePointer(
              ignoring: disableInput,
              child: Directionality(
                textDirection: textDirection,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: provider.duration),
                  curve: Curves.ease,
                  width: double.infinity,
                  padding: EdgeInsets.all(3),
                  decoration: chatInputFieldDecoration,
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

  /// build Input Field widget
  Widget _buildInputField(ChatInputFieldProvider provider) =>
      ChatInputFieldContainerWidget(
          chatInputFieldColor: chatInputFieldColor,
          isRecording: provider.isRecording,
          recordingNoteHintText: recordingNoteHintText,
          recordTime: provider.recordTime,
          textController: _textController,
          sendMessageHintText: sendMessageHintText,
          attachmentClick: attachmentClick,
          formKey: provider.formKey,
          onSubmitted: provider.onAnimatedButtonTap);

  Widget _buildDragTrail(ChatInputFieldProvider provider) => ChatDragTrail(
        cancelPosition: provider.getPosition(),
        duration: provider.duration,
        trailColor: chatInputFieldColor,
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
        borderRadius: BorderRadius.all(Radius.circular(buttonRadios)),
        sendTextIcon: sendTextIcon,
      );

  /// show a widget to choose picker type

  void attachmentClick(BuildContext context) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        //TODO should accep custom chld
        return ChatBottomSheet(
          imageFromCameraOnTap: () {
            Navigator.pop(context);

            pickImage(1);
          },
          imageFromGalleryOnTap: () {
            Navigator.pop(context);
            pickImage(2);
          },
          imageAttachmentFromCameraText: imageAttachmentFromCameraText,
          imageAttachmentTextStyle: imageAttachmentTextStyle,
          imageAttachmentFromGalleryText: imageAttachmentFromGalleryText,
          imageAttachmentCancelText: imageAttachmentCancelText,
          imageAttachmentFromGalleryIcon: imageAttachmentFromGalleryIcon,
          imageAttachmentFromCameraIcon: imageAttachmentFromCameraIcon,
          imageAttachmentCancelIcon: imageAttachmentCancelIcon,
        );
      },
    );
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
}
