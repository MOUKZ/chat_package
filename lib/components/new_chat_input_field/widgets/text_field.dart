import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
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
            hintText: "Type a message",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.keyboard,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: onAttachmentClicked,
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (builder) =>
                    //             CameraApp()));
                  },
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
