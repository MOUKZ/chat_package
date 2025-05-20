import 'dart:convert';

import 'package:flutter/foundation.dart'; // for @immutable
import 'package:chat_package/models/media/media_type.dart';

@immutable
class ChatMedia {
  // keys for JSON/map serialization

  /// The remote URL of the media.
  final String url;

  /// The type of media (image, audio, or video).
  final MediaType mediaType;

  /// Creates a new [ChatMedia].
  const ChatMedia({
    required this.url,
    required this.mediaType,
  });

  /// Returns a copy of this [ChatMedia] with any provided fields replaced.
  ///
  /// ```dart
  /// final m1 = ChatMedia(url: 'a.png', mediaType: MediaType.imageMediaType());
  /// final m2 = m1.copyWith(url: 'b.png');
  /// assert(m2.url == 'b.png' && m2.mediaType == m1.mediaType);
  /// ```
  ChatMedia copyWith({
    String? url,
    MediaType? mediaType,
  }) {
    return ChatMedia(
      url: url ?? this.url,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  /// Converts this object into a `Map<String, dynamic>` suitable for JSON encoding.
  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'mediaType': mediaType.toString(),
    };
  }

  /// Creates a new [ChatMedia] from a map (e.g. decoded JSON).
  ///
  /// Throws if the required keys are missing or of the wrong type.
  factory ChatMedia.fromMap(Map<String, dynamic> map) {
    return ChatMedia(
      url: map['url'] as String,
      mediaType: MediaType.fromString(map['mediaType'] as String),
    );
  }

  /// Serializes this object to a JSON string.
  String toJson() => jsonEncode(toMap());

  /// Deserializes a JSON string into a [ChatMedia].
  factory ChatMedia.fromJson(String source) =>
      ChatMedia.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatMedia(url: $url, mediaType: $mediaType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMedia &&
        other.url == url &&
        other.mediaType == mediaType;
  }

  @override
  int get hashCode => Object.hash(url, mediaType);
}
