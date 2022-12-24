import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? textFieldHintText;
  final TextStyle? textFieldHintTextStyle;
  final bool? disableCamera;
  final bool? disableAttachment;

  final IconData? cameraIcon;
  final IconData? attachmentIcon;

  final Function() onCameraIconPressed;

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String)? onChanged;
  final Function()? onAttachmentClicked;
  final double width;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onAttachmentClicked,
    required this.width,
    this.textFieldHintText,
    required this.textFieldHintTextStyle,
    required this.disableCamera,
    required this.disableAttachment,
    required this.cameraIcon,
    required this.attachmentIcon,
    required this.onCameraIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          minLines: 1,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: textFieldHintText ?? 'Type a message',
            hintStyle: textFieldHintTextStyle ?? TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.keyboard,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                disableAttachment ?? false
                    ? Container()
                    : IconButton(
                        icon: Icon(attachmentIcon ?? Icons.attach_file),
                        onPressed: onAttachmentClicked,
                      ),
                disableCamera ?? false
                    ? Container()
                    : IconButton(
                        icon: Icon(cameraIcon ?? Icons.camera_alt),
                        onPressed: onCameraIconPressed,
                      ),
              ],
            ),
            contentPadding: EdgeInsets.all(5),
          ),
        ),
      ),
    );
  }
}
