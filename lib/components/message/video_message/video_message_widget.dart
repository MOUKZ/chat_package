import 'dart:io';

import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/screens/video_player_screen.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Renders a video message as a tappable thumbnail (the video's first frame)
/// with a play overlay. Tapping opens a full-screen [VideoPlayerScreen].
///
/// Supports both remote (network) urls and local file paths and shows an
/// optional caption ([ChatMessage.text]) underneath.
class VideoMessageWidget extends StatefulWidget {
  /// The chat message holding the video media.
  final ChatMessage message;

  /// The color of the sender bubble background.
  final Color senderColor;

  /// Optional text style for the caption.
  final TextStyle? messageContainerTextStyle;

  /// Fraction of the available width the thumbnail occupies. Defaults to 0.45.
  final double widthFraction;

  const VideoMessageWidget({
    super.key,
    required this.message,
    required this.senderColor,
    this.messageContainerTextStyle,
    this.widthFraction = 0.45,
  });

  @override
  State<VideoMessageWidget> createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget> {
  late final VideoPlayerController _thumbnailController;
  bool _initialized = false;

  String get _url => widget.message.chatMedia!.url;

  @override
  void initState() {
    super.initState();
    _thumbnailController = isNetworkSource(_url)
        ? VideoPlayerController.networkUrl(Uri.parse(_url))
        : VideoPlayerController.file(File(_url));
    _thumbnailController.initialize().then((_) {
      if (!mounted) return;
      setState(() => _initialized = true);
    }).catchError((_) {
      // Leave the placeholder visible if the first frame can't be loaded.
    });
  }

  @override
  void dispose() {
    _thumbnailController.dispose();
    super.dispose();
  }

  void _openFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VideoPlayerScreen(url: _url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        _initialized ? _thumbnailController.value.aspectRatio : 1.0;
    return Column(
      crossAxisAlignment: widget.message.isSender
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.senderColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: widget.message.isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: _openFullScreen,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * widget.widthFraction,
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_initialized)
                            VideoPlayer(_thumbnailController)
                          else
                            Container(color: Colors.black12),
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.black45,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.message.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 8,
                    top: 8,
                    right: widget.message.isSender ? 8 : 0,
                    left: widget.message.isSender ? 0 : 8,
                  ),
                  child: Text(
                    widget.message.text,
                    style: widget.messageContainerTextStyle ??
                        const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
