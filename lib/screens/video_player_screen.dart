import 'dart:io';

import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Full-screen, view-only video player used when a [VideoMessageWidget] is
/// tapped. Supports both remote (network) urls and local file paths.
class VideoPlayerScreen extends StatefulWidget {
  /// Network url or local file path of the video to play.
  final String url;

  const VideoPlayerScreen({super.key, required this.url});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = isNetworkSource(widget.url)
        ? VideoPlayerController.networkUrl(Uri.parse(widget.url))
        : VideoPlayerController.file(File(widget.url));
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _controller.play();
    });
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            const CircularProgressIndicator(),
          if (_controller.value.isInitialized)
            GestureDetector(
              onTap: _togglePlayback,
              child: AnimatedOpacity(
                opacity: _controller.value.isPlaying ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.black45,
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          if (_controller.value.isInitialized)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).padding.top + 16,
                horizontal: size.width / 18,
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
