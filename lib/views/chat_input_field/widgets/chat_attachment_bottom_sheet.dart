import 'package:flutter/material.dart';

class ChatBottomSheet extends StatelessWidget {
  final Function() imageFromCameraOnTap;

  final Function() imageFromGalleryOnTap;
  //TODO: add disable functionality
  final String imageAttachmentFromCameraText;
  final Icon? imageAttachmentFromCameraIcon;

  final String imageAttachmentFromGalleryText;
  final Icon? imageAttachmentFromGalleryIcon;

  final String imageAttachmentCancelText;
  final Icon? imageAttachmentCancelIcon;

  final TextStyle? imageAttachmentTextStyle;
  const ChatBottomSheet({
    super.key,
    required this.imageFromCameraOnTap,
    required this.imageFromGalleryOnTap,
    required this.imageAttachmentFromCameraText,
    this.imageAttachmentTextStyle,
    required this.imageAttachmentFromGalleryText,
    required this.imageAttachmentCancelText,
    this.imageAttachmentFromCameraIcon,
    this.imageAttachmentFromGalleryIcon,
    this.imageAttachmentCancelIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          ListTile(
            leading: imageAttachmentFromCameraIcon ?? Icon(Icons.camera),
            title: Text(
              imageAttachmentFromCameraText,
              style: imageAttachmentTextStyle,
            ),
            onTap: imageFromCameraOnTap,
          ),
          ListTile(
            leading: imageAttachmentFromGalleryIcon ?? Icon(Icons.image),
            title: Text(
              imageAttachmentFromGalleryText,
              style: imageAttachmentTextStyle,
            ),
            onTap: imageFromGalleryOnTap,
          ),
          ListTile(
            leading: imageAttachmentCancelIcon ?? Icon(Icons.cancel),
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
