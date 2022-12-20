import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_type.freezed.dart';

@freezed
class MediaType with _$MediaType {
  const factory MediaType.imageMediaType() = ImageMediaType;
  const factory MediaType.audioMediaType() = AudioMediaType;
  const factory MediaType.videoMediaType() = VideoMediaType;
  @override
  String toString() {
    return this.when(
      imageMediaType: () => 'image',
      audioMediaType: () => 'audio',
      videoMediaType: () => 'video',
    );
  }

  factory MediaType.fromString(String type) {
    switch (type) {
      case 'image':
        return MediaType.imageMediaType();
      case 'audio':
        return MediaType.audioMediaType();
      case 'video':
        return MediaType.videoMediaType();

      default:
        return MediaType.imageMediaType();
    }
  }
}
