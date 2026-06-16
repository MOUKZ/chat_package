import 'dart:io';

import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/transparent_image.dart';
import 'package:chat_package/screens/photo_gallery_view.dart';
import 'package:flutter/material.dart';

//TODO add text size
class ImageMessageWidget extends StatelessWidget {
  /// chat message model to get teh data
  final ChatMessage message;

  ///the color of the sender container
  final Color senderColor;

  final TextStyle? messageContainerTextStyle;

  /// Width of the image as a fraction of the available width. Defaults to 0.45.
  final double widthFraction;

  const ImageMessageWidget({
    super.key,
    required this.message,
    required this.senderColor,
    this.messageContainerTextStyle,
    this.widthFraction = 0.45,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: senderColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: message.isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  /// navigate to to the photo gallery view, for viewing the taped image
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => PhotoGalleryView(
                        chatMessage: message,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * widthFraction,

                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Uri.parse(message.chatMedia!.url).isAbsolute
                          ? FadeInImage.memoryNetwork(
                              placeholder: transparentImage,
                              image: message.chatMedia!.url,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(
                                message.chatMedia!.url,
                              ),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: message.text.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 8,
                    top: 8,
                    right: message.isSender ? 8 : 0,
                    left: message.isSender ? 0 : 8,
                  ),
                  child: Text(
                    message.text,
                    style: messageContainerTextStyle ?? const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
