import 'dart:io';

import 'package:chat_package/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// this widget is used for viewing the image in full size
class PhotoGalleryView extends StatefulWidget {
  final ChatMessage chatMessage;

  const PhotoGalleryView({
    super.key,
    required this.chatMessage,
  });
  @override
  State<PhotoGalleryView> createState() => _PhotoGalleryViewState();
}

class _PhotoGalleryViewState extends State<PhotoGalleryView> {
  late ImageProvider imageProvider;
  @override
  void initState() {
    super.initState();

    /// check if url is provided or a path to a file
    bool validURL = Uri.parse(widget.chatMessage.chatMedia!.url).isAbsolute;

    validURL
        ? imageProvider = NetworkImage(widget.chatMessage.chatMedia!.url)
        : imageProvider = FileImage(File(widget.chatMessage.chatMedia!.url));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      body: Stack(
        children: [
          PhotoView(
            heroAttributes: const PhotoViewHeroAttributes(
              tag: 'photo_gallery_hero',
            ),
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
            imageProvider: imageProvider,
          ),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).padding.top + 16,
                horizontal: size.width / 18,
              ),
              /// icon to cancel and return to the previous view
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
