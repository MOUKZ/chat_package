import 'dart:io';

import 'package:chat_package/models/captured_media.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Preview screen shown after capturing a photo or video with the in-app
/// camera. Lets the user add a caption and confirm, returning a [CapturedMedia]
/// via [Navigator.pop] (or `null` when the user backs out).
class MediaPreviewPage extends StatefulWidget {
  /// Local file path of the captured media.
  final String path;

  /// Whether the captured media is a video.
  final bool isVideo;

  /// Hint text for the caption field.
  final String captionHintText;

  const MediaPreviewPage({
    super.key,
    required this.path,
    required this.isVideo,
    this.captionHintText = 'Add caption...',
  });

  @override
  State<MediaPreviewPage> createState() => _MediaPreviewPageState();
}

class _MediaPreviewPageState extends State<MediaPreviewPage> {
  final TextEditingController _captionController = TextEditingController();
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.file(File(widget.path))
        ..initialize().then((_) {
          if (mounted) setState(() {});
        })
        ..setLooping(true);
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _confirm() {
    Navigator.of(context).pop(
      CapturedMedia(
        path: widget.path,
        caption: _captionController.text.trim(),
        isVideo: widget.isVideo,
      ),
    );
  }

  void _toggleVideo() {
    final controller = _videoController;
    if (controller == null) return;
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, elevation: 0),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 90,
              child: Center(child: _buildPreview()),
            ),
            if (widget.isVideo &&
                (_videoController?.value.isInitialized ?? false))
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  iconSize: 64,
                  onPressed: _toggleVideo,
                  icon: Icon(
                    _videoController!.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: Colors.white70,
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black38,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _captionController,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 17),
                        maxLines: 6,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.captionHintText,
                          hintStyle: const TextStyle(
                              color: Colors.white70, fontSize: 17),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _confirm,
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.tealAccent[700],
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 27),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (!widget.isVideo) {
      return Image.file(File(widget.path), fit: BoxFit.contain);
    }
    final controller = _videoController;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      );
    }
    return const CircularProgressIndicator();
  }
}
