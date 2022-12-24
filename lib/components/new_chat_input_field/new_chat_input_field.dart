import 'package:chat_package/components/new_chat_input_field/widgets/camera/camera_capture_screen.dart';
import 'package:chat_package/components/new_chat_input_field/widgets/camera/camptured_media_view.dart';
import 'package:chat_package/components/new_chat_input_field/widgets/send_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_input_field_provider.dart';
import 'widgets/text_field.dart';

import 'widgets/attachment_bottom_sheet.dart';

class NewChatInputField extends StatelessWidget {
  //send button
  final Color? sendButtonColor;
  final bool? disableRecording;
  final IconData? sendButtonTextIcon;
  final IconData? sendButtonRecordIcon;
  final Color? sendButtonIconColor;
  //text field
  final String? textFieldHintText;
  final TextStyle? textFieldHintTextStyle;
  final bool? disableCamera;
  final bool? disableAttachment;

  final IconData? cameraIcon;
  final IconData? attachmentIcon;

  final String? capturedMediaHintText;

  NewChatInputField({
    Key? key,
    this.sendButtonColor,
    this.disableRecording,
    this.sendButtonRecordIcon,
    this.sendButtonTextIcon,
    this.sendButtonIconColor,
    this.textFieldHintText,
    this.textFieldHintTextStyle,
    this.disableCamera,
    this.disableAttachment,
    this.cameraIcon,
    this.attachmentIcon,
    this.capturedMediaHintText,
  }) : super(key: key);

  final FocusNode focusNode = FocusNode();

  final TextEditingController textFieldController = TextEditingController();
  // ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewChatInputFieldProvider(
        textFieldController: textFieldController,
      ),
      child: Consumer<NewChatInputFieldProvider>(
        builder: (context, provider, child) {
          double width =
              MediaQuery.of(context).size.width * (1 - provider.scale);
          return AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: width,
            child: WillPopScope(
              child: Row(
                children: [
                  CustomTextField(
                    width: width * (0.85 - provider.scale),
                    focusNode: focusNode,
                    controller: textFieldController,
                    onChanged: provider.onTextFieldValueChanged,
                    onAttachmentClicked: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (builder) => AttachmentBottomSheet());
                    },
                    textFieldHintText: textFieldHintText,
                    textFieldHintTextStyle: textFieldHintTextStyle,
                    disableCamera: disableCamera,
                    disableAttachment: disableAttachment,
                    cameraIcon: cameraIcon,
                    attachmentIcon: attachmentIcon,
                    onCameraIconPressed: () async {
                      final cameras = await provider.getCameras();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => CameraCaptureScreen(
                            cameras: cameras,
                            takeImage: (controller) async {
                              final file = await provider.takePhoto(controller);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => CapturedMediaView(
                                    path: file.path,
                                    capturedMediaHintText:
                                        capturedMediaHintText,
                                    onSubmitMediaFromCamera:
                                        provider.onSubmitMediaFromCamera,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SendButton(
                    sendButtonColor: sendButtonColor,
                    onDragChange: provider.onLongPressDragChange,
                    onPressed: provider.onSendButtonClicked,
                    onLongPress: provider.onLongPress,
                    isText: provider.isText,
                    disableRecording: disableRecording ?? false,
                    sendButtonRecordIcon: sendButtonRecordIcon,
                    sendButtonTextIcon: sendButtonTextIcon,
                    sendButtonIconColor: sendButtonIconColor,
                  ),
                ],
              ),
              onWillPop: () {
                Navigator.pop(context);
                return Future.value(false);
              },
            ),
          );
        },
      ),
    );
  }
}
