/// A sealed union of supported media types: image, audio, and video.
///
/// Use the provided factories to construct instances, `when` to
/// pattern‑match on the subtype, and `toString`/`fromString` for
/// serialization/deserialization.
sealed class MediaType {
  /// Private constructor. Use one of the public factories instead.
  const MediaType._();

  /// Creates an [ImageMediaType] instance.
  ///
  /// ```dart
  /// final m = const MediaType.imageMediaType();
  /// assert(m.toString() == 'image');
  /// ```
  const factory MediaType.imageMediaType() = ImageMediaType;

  /// Creates an [AudioMediaType] instance.
  ///
  /// ```dart
  /// final m = const MediaType.audioMediaType();
  /// assert(m.toString() == 'audio');
  /// ```
  const factory MediaType.audioMediaType() = AudioMediaType;

  /// Creates a [VideoMediaType] instance.
  ///
  /// ```dart
  /// final m = const MediaType.videoMediaType();
  /// assert(m.toString() == 'video');
  /// ```
  const factory MediaType.videoMediaType() = VideoMediaType;

  /// Pattern‑matches on the current subtype and returns the result.
  ///
  /// - [imageMediaType] is invoked if this is an [ImageMediaType].
  /// - [audioMediaType] is invoked if this is an [AudioMediaType].
  /// - [videoMediaType] is invoked if this is a [VideoMediaType].
  ///
  /// ```dart
  /// final desc = m.when(
  ///   imageMediaType: () => 'An image file',
  ///   audioMediaType: () => 'An audio track',
  ///   videoMediaType: () => 'A video clip',
  /// );
  /// ```
  T when<T>({
    required T Function() imageMediaType,
    required T Function() audioMediaType,
    required T Function() videoMediaType,
  });

  @override

  /// Returns the string representation of this media type:
  /// `'image'`, `'audio'`, or `'video'`.
  String toString() => when(
        imageMediaType: () => 'image',
        audioMediaType: () => 'audio',
        videoMediaType: () => 'video',
      );

  /// Parses a string into a [MediaType].
  ///
  /// - `'image'` → [ImageMediaType]
  /// - `'audio'` → [AudioMediaType]
  /// - `'video'` → [VideoMediaType]
  ///
  /// Any other input defaults to [ImageMediaType].
  ///
  /// ```dart
  /// final m1 = MediaType.fromString('audio'); // AudioMediaType
  /// final m2 = MediaType.fromString('unknown'); // ImageMediaType
  /// ```
  factory MediaType.fromString(String type) {
    switch (type) {
      case 'image':
        return const MediaType.imageMediaType();
      case 'audio':
        return const MediaType.audioMediaType();
      case 'video':
        return const MediaType.videoMediaType();
      default:
        return const MediaType.imageMediaType();
    }
  }
}

/// Represents the `image` subtype of [MediaType].
final class ImageMediaType extends MediaType {
  /// Constructs an [ImageMediaType].
  const ImageMediaType() : super._();

  @override
  T when<T>({
    required T Function() imageMediaType,
    required T Function() audioMediaType,
    required T Function() videoMediaType,
  }) =>
      imageMediaType();
}

/// Represents the `audio` subtype of [MediaType].
final class AudioMediaType extends MediaType {
  /// Constructs an [AudioMediaType].
  const AudioMediaType() : super._();

  @override
  T when<T>({
    required T Function() imageMediaType,
    required T Function() audioMediaType,
    required T Function() videoMediaType,
  }) =>
      audioMediaType();
}

/// Represents the `video` subtype of [MediaType].
final class VideoMediaType extends MediaType {
  /// Constructs a [VideoMediaType].
  const VideoMediaType() : super._();

  @override
  T when<T>({
    required T Function() imageMediaType,
    required T Function() audioMediaType,
    required T Function() videoMediaType,
  }) =>
      videoMediaType();
}
