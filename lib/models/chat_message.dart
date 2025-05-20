import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:chat_package/models/media/chat_media.dart';

@immutable
class ChatMessage {
  // JSON keys
  static const _keyText = 'text';
  static const _keyChatMedia = 'chatMedia';
  static const _keyIsSender = 'isSender';
  static const _keyCreatedAt = 'createdAt';

  /// The textual content of the message.
  /// Mutually exclusive with [chatMedia].
  final String text;

  /// The media content of the message.
  /// Mutually exclusive with [text].
  final ChatMedia? chatMedia;

  /// Whether this message was sent by the local user.
  final bool isSender;

  /// When the message was created.
  final DateTime? createdAt;

  /// Creates a chat message containing either [text] or [chatMedia], but not both.
  ///
  /// ```dart
  /// // A text message:
  /// final m1 = ChatMessage(text: 'Hello!', isSender: true);
  ///
  /// // A media message:
  /// final m2 = ChatMessage(
  ///   chatMedia: ChatMedia(url: 'https://…', mediaType: MediaType.imageMediaType()),
  ///   isSender: false,
  /// );
  /// ```
  ChatMessage({
    required this.text,
    this.chatMedia,
    required this.isSender,
    this.createdAt,
  });

  /// Returns a copy of this message, replacing only the given fields.
  ChatMessage copyWith({
    String? text,
    ChatMedia? chatMedia,
    bool? isSender,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      chatMedia: chatMedia ?? this.chatMedia,
      isSender: isSender ?? this.isSender,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converts this message to a JSON‐compatible map.
  Map<String, dynamic> toMap() {
    return {
      _keyText: text,
      _keyChatMedia: chatMedia?.toMap(),
      _keyIsSender: isSender,
      _keyCreatedAt: createdAt?.millisecondsSinceEpoch,
    };
  }

  /// Creates a message from a `Map`, e.g. from decoded JSON.
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: (map[_keyText] as String?) ?? '',
      chatMedia: map[_keyChatMedia] != null
          ? ChatMedia.fromMap(map[_keyChatMedia] as Map<String, dynamic>)
          : null,
      isSender: map[_keyIsSender] as bool,
      createdAt: map[_keyCreatedAt] != null
          ? DateTime.fromMillisecondsSinceEpoch(map[_keyCreatedAt] as int)
          : null,
    );
  }

  /// Encodes this message to a JSON string.
  String toJson() => jsonEncode(toMap());

  /// Decodes a JSON string into a [ChatMessage].
  factory ChatMessage.fromJson(String jsonStr) =>
      ChatMessage.fromMap(jsonDecode(jsonStr) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatMessage(text: $text, chatMedia: $chatMedia, isSender: $isSender, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage &&
        other.text == text &&
        other.chatMedia == chatMedia &&
        other.isSender == isSender &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(text, chatMedia, isSender, createdAt);
}
