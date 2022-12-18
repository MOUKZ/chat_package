import 'package:flutter/material.dart';

class ChatBottomSheet extends StatelessWidget {
  final Function() imageFromCameraOnTap;
  final Function() imageFromGalleryOnTap;
  final String imageAttachmentFromCameraText;
  final TextStyle? imageAttachmentTextStyle;
  final String imageAttachmentFromGalleryText;
  final String imageAttachmentCancelText;
  const ChatBottomSheet(
      {super.key,
      required this.imageFromCameraOnTap,
      required this.imageFromGalleryOnTap,
      required this.imageAttachmentFromCameraText,
      this.imageAttachmentTextStyle,
      required this.imageAttachmentFromGalleryText,
      required this.imageAttachmentCancelText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text(
              imageAttachmentFromCameraText,
              style: imageAttachmentTextStyle,
            ),
            onTap: imageFromCameraOnTap,
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text(
              imageAttachmentFromGalleryText,
              style: imageAttachmentTextStyle,
            ),
            onTap: imageFromGalleryOnTap,
          ),
          ListTile(
            leading: Icon(Icons.cancel),
            title: Text(
              imageAttachmentCancelText,
              style: imageAttachmentTextStyle,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
