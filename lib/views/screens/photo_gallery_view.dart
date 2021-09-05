import 'dart:io';

import 'package:chat_package/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoGalleryView extends StatefulWidget {
  final ChatMessage chatMessage;

  const PhotoGalleryView({
    Key? key,
    required this.chatMessage,
  }) : super(key: key);
  @override
  _PhotoGalleryViewState createState() => _PhotoGalleryViewState();
}

class _PhotoGalleryViewState extends State<PhotoGalleryView> {
  late ImageProvider imageProvider;
  @override
  void initState() {
    super.initState();
    if (widget.chatMessage.imageUrl != null) {
      imageProvider = NetworkImage(widget.chatMessage.imageUrl!);
    } else {
      imageProvider = FileImage(File(widget.chatMessage.imagePath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Stack(
        children: [
          PhotoView(
            heroAttributes: PhotoViewHeroAttributes(
              tag: 'photo_gallery_hero',
            ),
            loadingBuilder: (context, event) => Center(
              child: Container(
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
              child: Container(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      // color: AppColors.blueShade3,
                      size: 30,
                    )),
                // onPressed:,
                // squareSize: size.width / 28,
                // elevation: 32,
                // shadowColor: AppColors.blackColor.withOpacity(0.41),
                // backgroundColor: AppColors.whiteColor,
                // color: AppColors.blackColor,
                // backgroundWidth: size.width / 10.7,
                // onTab: () => locator<NavigationService>().back(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
