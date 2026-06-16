/// The kind of media carried by a [ChatMedia].
///
/// Replaces the previous Freezed union (`MediaType.imageMediaType()` etc.)
/// with a plain Dart enum, removing the code-generation dependency.
enum MediaType {
  image,
  audio,
  video;

  /// Parses a [MediaType] from its string representation
  /// (`'image'`, `'audio'` or `'video'`). Falls back to [MediaType.image].
  factory MediaType.fromString(String type) {
    switch (type) {
      case 'audio':
        return MediaType.audio;
      case 'video':
        return MediaType.video;
      case 'image':
      default:
        return MediaType.image;
    }
  }

  /// The string representation used for serialization (`'image'`, `'audio'`,
  /// `'video'`).
  String get value => name;
}
