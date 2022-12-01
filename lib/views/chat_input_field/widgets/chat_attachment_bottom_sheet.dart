import 'package:flutter/material.dart';

class ChatBottomSheet extends StatelessWidget {
  final Function() imageFromCameraOnTap;
  final Function() imageFromGalleryOnTap;
  final String imageAttachmentFromCameraText;
  final Color imageAttachmentTextColor;
  final String imageAttachmentFromGalleryText;
  final String imageAttachmentCancelText;
  const ChatBottomSheet(
      {super.key,
      required this.imageFromCameraOnTap,
      required this.imageFromGalleryOnTap,
      required this.imageAttachmentFromCameraText,
      required this.imageAttachmentTextColor,
      required this.imageAttachmentFromGalleryText,
      required this.imageAttachmentCancelText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 144,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextButton(
            onPressed: imageFromCameraOnTap,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                imageAttachmentFromCameraText,
                style: TextStyle(color: imageAttachmentTextColor),
              ),
            ),
          ),
          TextButton(
            onPressed: imageFromGalleryOnTap,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                imageAttachmentFromGalleryText,
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
  }
}
