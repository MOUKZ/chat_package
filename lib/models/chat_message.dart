// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chat_package/models/media/chat_media.dart';

class ChatMessage {
  /// please note that only one of the following [text,imageUrl,imagePath,audioUrl,audioPath ]
  ///must not be null at a time if more is provided an error will occur
  String text;
  final ChatMedia? chatMedia;
  final bool isSender;
  DateTime? createdAt;
  ChatMessage({
    this.text = '',
    this.chatMedia,
    required this.isSender,
    this.createdAt,
  });

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'chatMedia': chatMedia?.toMap(),
      'isSender': isSender,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] as String,
      chatMedia: map['chatMedia'] != null
          ? ChatMedia.fromMap(map['chatMedia'] as Map<String, dynamic>)
          : null,
      isSender: map['isSender'] as bool,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatMessage(text: $text, chatMedia: $chatMedia, isSender: $isSender, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.chatMedia == chatMedia &&
        other.isSender == isSender &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        chatMedia.hashCode ^
        isSender.hashCode ^
        createdAt.hashCode;
  }
}
