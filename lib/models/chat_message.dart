import 'dart:convert';

import 'package:chat_package/enums/chat_message_type.dart';

class ChatMessage {
  //plese note that only one of the following [text,imageUrl,imagePath,audioUrl,audioPath ]
//must not be null at a time if more is provided an error will occure
  String? text;
  String? imageUrl;
  String? imagePath;
  String? audioUrl;
  String? audioPath;
  final bool isSender;
  DateTime? createdAt;
  ChatMessage({
    this.text,
    this.imageUrl,
    this.imagePath,
    this.audioUrl,
    this.audioPath,
    required this.isSender,
    this.createdAt,
  });

  ChatMessage copyWith({
    String? text,
    String? imageUrl,
    String? imagePath,
    String? audioUrl,
    String? audioPath,
    bool? isSender,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      audioUrl: audioUrl ?? this.audioUrl,
      audioPath: audioPath ?? this.audioPath,
      isSender: isSender ?? this.isSender,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// convert the ChatMessage object to json
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'audioUrl': audioUrl,
      'audioPath': audioPath,
      'isSender': isSender,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// create ChatMessage from json and
  /// retreve it from api
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      imageUrl: map['imageUrl'],
      imagePath: map['imagePath'],
      audioUrl: map['audioUrl'],
      audioPath: map['audioPath'],
      isSender: map['isSender'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source));

  /// override the toString function
  @override
  String toString() {
    return 'ChatMessage(text: $text, imageUrl: $imageUrl, imagePath: $imagePath, audioUrl: $audioUrl, audioPath: $audioPath, isSender: $isSender, createdAt: $createdAt)';
  }

  /// override the '==' operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessage &&
        other.text == text &&
        other.imageUrl == imageUrl &&
        other.imagePath == imagePath &&
        other.audioUrl == audioUrl &&
        other.audioPath == audioPath &&
        other.isSender == isSender &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        imageUrl.hashCode ^
        imagePath.hashCode ^
        audioUrl.hashCode ^
        audioPath.hashCode ^
        isSender.hashCode ^
        createdAt.hashCode;
  }

// check message type to render the right widget
  ChatMessageType getType() {
    if (imageUrl != null) {
      return ChatMessageType.ImageMessage;
    }
    if (imagePath != null) {
      return ChatMessageType.ImageMessage;
    }
    if (audioUrl != null) {
      return ChatMessageType.AudioMessage;
    }
    if (audioPath != null) {
      return ChatMessageType.AudioMessage;
    }

    return ChatMessageType.TextMessage;
  }
}
