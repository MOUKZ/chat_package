import 'dart:convert';

import 'package:chat_package/models/media/media_type.dart';

class ChatMedia {
  final String url;
  final MediaType mediaType;
  ChatMedia({
    required this.url,
    required this.mediaType,
  });

  ChatMedia copyWith({
    String? url,
    MediaType? mediaType,
  }) {
    return ChatMedia(
      url: url ?? this.url,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'mediaType': mediaType.toString(),
    };
  }

  factory ChatMedia.fromMap(Map<String, dynamic> map) {
    return ChatMedia(
      url: map['url'] as String,
      mediaType: MediaType.fromString(map['mediaType'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMedia.fromJson(String source) =>
      ChatMedia.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatMedia(url: $url, mediaType: $mediaType)';

  @override
  bool operator ==(covariant ChatMedia other) {
    if (identical(this, other)) return true;

    return other.url == url && other.mediaType == mediaType;
  }

  @override
  int get hashCode => url.hashCode ^ mediaType.hashCode;
}
