import 'dart:io';

import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:chat_package/utils/transparent_image.dart';
import 'package:chat_package/screens/photo_gallery_view.dart';
import 'package:flutter/material.dart';

//TODO add text size and color for the container
class ImageMessageWidget extends StatelessWidget {
  /// chat message model to get teh data
  final ChatMessage message;

  ///the color of the sender container
  final Color senderColor;

  const ImageMessageWidget(
      {Key? key, required this.message, required this.senderColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: senderColor.withOpacity(0.3),
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
                child: Container(
                  /// 45% of total width
                  width: MediaQuery.of(context).size.width * 0.45,

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
                              File(message.chatMedia!.url),
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
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            // top: 2,
            left: kDefaultPadding / 2,
            right: kDefaultPadding / 2,
          ),
          child: Text(
            dateStringFormatter(message.createdAt ?? DateTime.now()),
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
