/// Result returned by the in-app camera flow (capture + preview/caption).
class CapturedMedia {
  /// Local file path of the captured photo or video.
  final String path;

  /// Optional caption the user typed on the preview screen.
  final String caption;

  /// Whether the captured media is a video (`true`) or a photo (`false`).
  final bool isVideo;

  const CapturedMedia({
    required this.path,
    this.caption = '',
    required this.isVideo,
  });
}
