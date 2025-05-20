/// media_type.dart
sealed class MediaType {
  const MediaType._();

  const factory MediaType.imageMediaType() = ImageMediaType;
  const factory MediaType.audioMediaType() = AudioMediaType;
  const factory MediaType.videoMediaType() = VideoMediaType;

  T when<T>({
    required T Function() imageMediaType,
    required T Function() audioMediaType,
    required T Function() videoMediaType,
  });

  @override
  String toString() => when(
        imageMediaType: () => 'image',
        audioMediaType: () => 'audio',
        videoMediaType: () => 'video',
      );

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

final class ImageMediaType extends MediaType {
  const ImageMediaType() : super._();
  @override
  T when<T>({
    required T Function() imageMediaType,
    required T Function() audioMediaType,
    required T Function() videoMediaType,
  }) =>
      imageMediaType();
}

final class AudioMediaType extends MediaType {
  const AudioMediaType() : super._();
  @override
  T when<T>({
    required T Function() imageMediaType,
    required T Function() audioMediaType,
    required T Function() videoMediaType,
  }) =>
      audioMediaType();
}

final class VideoMediaType extends MediaType {
  const VideoMediaType() : super._();
  @override
  T when<T>({
    required T Function() imageMediaType,
    required T Function() audioMediaType,
    required T Function() videoMediaType,
  }) =>
      videoMediaType();
}
